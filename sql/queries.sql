-- ============================================================
-- TDB Tiere – Beispielabfragen / Sample queries
-- Usage: mysql -u root -p tdb_tiere < sql/queries.sql
-- ============================================================

USE `tdb_tiere`;

-- 1) Vollständiger mehrsprachiger Eintrag pro Tierart
--    Full multilingual record per species (all lookup tables resolved)
SELECT t.Tierart_DE, t.Tierart_EN, t.Tierart_FR, t.Tierart_LA,
       k.Tierklasse_DE, e.Ernaehrung_DE, b.Bedrohungsstatus_DE, b.IUCN_Kuerzel
FROM tierart t
JOIN klasse     k ON t.Klasse_ID     = k.Klasse_ID
JOIN ernaehrung e ON t.Ernaehrung_ID = e.Ernaehrung_ID
JOIN bedrohung  b ON t.Bedrohungs_ID = b.Bedrohungs_ID
ORDER BY t.Tier_ID;

-- 2) Stark gefährdete oder vom Aussterben bedrohte Arten (IUCN EN / CR)
--    Endangered or critically endangered species
SELECT t.Tierart_DE, t.Tierart_EN, t.Tierart_FR, t.Tierart_LA, b.IUCN_Kuerzel
FROM tierart t
JOIN bedrohung b ON t.Bedrohungs_ID = b.Bedrohungs_ID
WHERE b.IUCN_Kuerzel IN ('EN', 'CR');

-- 3) Arten pro Kontinent (Aggregation)
--    Species per continent
SELECT ko.Kontinent_DE,
       COUNT(*) AS Anzahl,
       GROUP_CONCAT(t.Tierart_DE ORDER BY t.Tierart_DE SEPARATOR ', ') AS Tierarten
FROM lebensraum l
JOIN tierart   t  ON l.Tier_ID      = t.Tier_ID
JOIN kontinent ko ON l.Kontinent_ID = ko.Kontinent_ID
GROUP BY ko.Kontinent_DE
ORDER BY Anzahl DESC, ko.Kontinent_DE;

-- 4) Durchschnittsgewicht pro Tierklasse
--    Average weight per animal class
SELECT k.Tierklasse_DE, k.Tierklasse_EN,
       COUNT(*)                  AS Arten,
       ROUND(AVG(l.Gewicht_kg),1) AS Durchschnitt_kg
FROM tierart t
JOIN klasse     k ON t.Klasse_ID = k.Klasse_ID
JOIN lebensraum l ON t.Tier_ID   = l.Tier_ID
GROUP BY k.Klasse_ID, k.Tierklasse_DE, k.Tierklasse_EN
ORDER BY Durchschnitt_kg DESC;

-- 5) Terminologische Suche: Äquivalente zu einem französischen Begriff
--    Terminology lookup: find all equivalents for a French term
SELECT Tierart_FR AS Suchbegriff, Tierart_DE, Tierart_EN, Tierart_LA
FROM tierart
WHERE Tierart_FR LIKE '%requin%';

-- 6) Rekonstruktion der Ausgangstabelle (Denormalisierung als View)
--    Rebuild the original flat table from the normalized schema
CREATE OR REPLACE VIEW v_ausgangstabelle AS
SELECT t.Tierart_DE, t.Tierart_EN, t.Tierart_FR, t.Tierart_LA,
       k.Tierklasse_DE AS Tierklasse,
       l.Lebensraum,
       ko.Kontinent_DE AS Kontinent,
       e.Ernaehrung_DE AS Ernaehrung,
       l.Koerpergroesse_cm, l.Gewicht_kg,
       b.Bedrohungsstatus_DE AS Bedrohungsstatus,
       l.Quelle
FROM tierart t
JOIN klasse     k  ON t.Klasse_ID     = k.Klasse_ID
JOIN ernaehrung e  ON t.Ernaehrung_ID = e.Ernaehrung_ID
JOIN bedrohung  b  ON t.Bedrohungs_ID = b.Bedrohungs_ID
JOIN lebensraum l  ON t.Tier_ID       = l.Tier_ID
JOIN kontinent  ko ON l.Kontinent_ID  = ko.Kontinent_ID;

SELECT * FROM v_ausgangstabelle ORDER BY Tierart_DE;
