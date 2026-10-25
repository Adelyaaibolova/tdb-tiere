"""
Verlustfreiheitstest / Lossless-join check

Rebuilds the original flat table (Ausgangstabelle.xlsx) from the normalized
database via the view `v_ausgangstabelle` and checks that every record is
identical. If the decomposition into 3NF lost or altered information, this
script exits with an error.

Usage:
    mysql -B -N tdb_tiere -e "SELECT * FROM v_ausgangstabelle" > view.tsv
    python scripts/verify_roundtrip.py view.tsv
"""

import sys
from decimal import Decimal
from pathlib import Path

import openpyxl

ROOT = Path(__file__).resolve().parent.parent
XLSX = ROOT / "data" / "excel" / "Ausgangstabelle.xlsx"


def norm(value):
    """Normalize numbers so that 190, 190.0 and '190.0' compare equal."""
    if value is None:
        return ""
    s = str(value).strip()
    try:
        d = Decimal(s)
        return str(d.normalize()) if d == d.to_integral() else str(d)
    except Exception:
        return s


def main(tsv_path: str) -> int:
    ws = openpyxl.load_workbook(XLSX, read_only=True).active
    rows = list(ws.iter_rows(values_only=True))
    expected = sorted(tuple(norm(v) for v in r) for r in rows[1:] if any(r))

    lines = Path(tsv_path).read_text(encoding="utf-8").splitlines()
    actual = sorted(tuple(norm(v) for v in line.split("\t")) for line in lines if line)

    print(f"Ausgangstabelle.xlsx : {len(expected)} records")
    print(f"v_ausgangstabelle    : {len(actual)} records")

    missing = set(expected) - set(actual)
    extra = set(actual) - set(expected)
    for r in sorted(missing):
        print("  MISSING in DB :", r)
    for r in sorted(extra):
        print("  EXTRA in DB   :", r)

    if missing or extra or len(expected) != len(actual):
        print("FAIL - normalized schema does not reproduce the source table")
        return 1
    print("OK - lossless decomposition: all records reconstructed exactly")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1]))
