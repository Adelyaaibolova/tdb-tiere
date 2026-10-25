-- ============================================================
-- TDB Tiere – Terminologische Datenbank
-- EMLex A3: Data Modelling | Laura Giacomini | April 2026
-- Exportiert aus: XAMPP / phpMyAdmin
-- ============================================================

CREATE DATABASE IF NOT EXISTS `tdb_tiere`
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE `tdb_tiere`;

-- ------------------------------------------------------------
-- Tabelle: klasse
-- Enthält die Tierklassen (Säugetier, Fisch, Vogel, Reptil)
-- PK: Klasse_ID
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `klasse`;
CREATE TABLE `klasse` (
  `Klasse_ID`      INT          NOT NULL AUTO_INCREMENT,
  `Tierklasse_DE`  VARCHAR(50)  NOT NULL,
  `Tierklasse_EN`  VARCHAR(50)  NOT NULL,
  `Tierklasse_FR`  VARCHAR(50)  NOT NULL,
  PRIMARY KEY (`Klasse_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `klasse` (`Klasse_ID`, `Tierklasse_DE`, `Tierklasse_EN`, `Tierklasse_FR`) VALUES
(1, 'Säugetier', 'Mammal',  'Mammifère'),
(2, 'Fisch',     'Fish',    'Poisson'),
(3, 'Vogel',     'Bird',    'Oiseau'),
(4, 'Reptil',    'Reptile', 'Reptile');

-- ------------------------------------------------------------
-- Tabelle: kontinent
-- PK: Kontinent_ID
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `kontinent`;
CREATE TABLE `kontinent` (
  `Kontinent_ID`   INT          NOT NULL AUTO_INCREMENT,
  `Kontinent_DE`   VARCHAR(50)  NOT NULL,
  `Kontinent_EN`   VARCHAR(50)  NOT NULL,
  `Kontinent_FR`   VARCHAR(60)  NOT NULL,
  PRIMARY KEY (`Kontinent_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `kontinent` (`Kontinent_ID`, `Kontinent_DE`, `Kontinent_EN`, `Kontinent_FR`) VALUES
(1, 'Afrika',      'Africa',         'Afrique'),
(2, 'Asien',       'Asia',           'Asie'),
(3, 'Nordamerika', 'North America',  'Amérique du Nord'),
(4, 'Australien',  'Australia',      'Australie'),
(5, 'Weltweit',    'Worldwide',      'Monde entier'),
(6, 'Antarktika',  'Antarctica',     'Antarctique'),
(7, 'Arktis',      'Arctic',         'Arctique');

-- ------------------------------------------------------------
-- Tabelle: ernaehrung
-- PK: Ernaehrung_ID
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `ernaehrung`;
CREATE TABLE `ernaehrung` (
  `Ernaehrung_ID`   INT         NOT NULL AUTO_INCREMENT,
  `Ernaehrung_DE`   VARCHAR(50) NOT NULL,
  `Ernaehrung_EN`   VARCHAR(50) NOT NULL,
  `Ernaehrung_FR`   VARCHAR(50) NOT NULL,
  PRIMARY KEY (`Ernaehrung_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `ernaehrung` (`Ernaehrung_ID`, `Ernaehrung_DE`, `Ernaehrung_EN`, `Ernaehrung_FR`) VALUES
(1, 'Fleischfresser', 'Carnivore',  'Carnivore'),
(2, 'Pflanzenfresser','Herbivore',  'Herbivore'),
(3, 'Allesfresser',   'Omnivore',   'Omnivore');

-- ------------------------------------------------------------
-- Tabelle: bedrohung
-- PK: Bedrohungs_ID
-- IUCN-Kategorien
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `bedrohung`;
CREATE TABLE `bedrohung` (
  `Bedrohungs_ID`         INT         NOT NULL AUTO_INCREMENT,
  `Bedrohungsstatus_DE`   VARCHAR(50) NOT NULL,
  `Bedrohungsstatus_EN`   VARCHAR(50) NOT NULL,
  `Bedrohungsstatus_FR`   VARCHAR(60) NOT NULL,
  `IUCN_Kuerzel`          CHAR(2)     NOT NULL,
  PRIMARY KEY (`Bedrohungs_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `bedrohung` (`Bedrohungs_ID`, `Bedrohungsstatus_DE`, `Bedrohungsstatus_EN`, `Bedrohungsstatus_FR`, `IUCN_Kuerzel`) VALUES
(1, 'Nicht gefährdet',         'Least Concern',          'Préoccupation mineure', 'LC'),
(2, 'Gefährdet',               'Vulnerable',             'Vulnérable',            'VU'),
(3, 'Stark gefährdet',         'Endangered',             'En danger',             'EN'),
(4, 'Vom Aussterben bedroht',  'Critically Endangered',  'En danger critique',    'CR');

-- ------------------------------------------------------------
-- Tabelle: tierart
-- Zentrale Tabelle | PK: Tier_ID
-- FK: Klasse_ID → klasse, Ernaehrung_ID → ernaehrung, Bedrohungs_ID → bedrohung
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `tierart`;
CREATE TABLE `tierart` (
  `Tier_ID`         INT          NOT NULL AUTO_INCREMENT,
  `Tierart_DE`      VARCHAR(100) NOT NULL,
  `Tierart_EN`      VARCHAR(100) NOT NULL,
  `Tierart_FR`      VARCHAR(100) NOT NULL,
  `Tierart_LA`      VARCHAR(100) NOT NULL COMMENT 'Wissenschaftlicher Name (Latein)',
  `Klasse_ID`       INT          NOT NULL,
  `Ernaehrung_ID`   INT          NOT NULL,
  `Bedrohungs_ID`   INT          NOT NULL,
  PRIMARY KEY (`Tier_ID`),
  CONSTRAINT `fk_tier_klasse`    FOREIGN KEY (`Klasse_ID`)     REFERENCES `klasse`    (`Klasse_ID`),
  CONSTRAINT `fk_tier_ernaehr`   FOREIGN KEY (`Ernaehrung_ID`) REFERENCES `ernaehrung`(`Ernaehrung_ID`),
  CONSTRAINT `fk_tier_bedrohung` FOREIGN KEY (`Bedrohungs_ID`) REFERENCES `bedrohung` (`Bedrohungs_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `tierart` (`Tier_ID`, `Tierart_DE`, `Tierart_EN`, `Tierart_FR`, `Tierart_LA`, `Klasse_ID`, `Ernaehrung_ID`, `Bedrohungs_ID`) VALUES
(1,  'Löwe',                     'Lion',               'Lion',                   'Panthera leo',            1, 1, 2),
(2,  'Elefant',                  'Elephant',           'Éléphant',               'Loxodonta africana',      1, 2, 2),
(3,  'Weißer Hai',               'Great White Shark',  'Grand requin blanc',     'Carcharodon carcharias',  2, 1, 2),
(4,  'Kaiserpinguin',            'Emperor Penguin',    'Manchot empereur',       'Aptenodytes forsteri',    3, 1, 1),
(5,  'Grüne Meeresschildkröte',  'Green Sea Turtle',   'Tortue verte',           'Chelonia mydas',          4, 2, 2),
(6,  'Amurtiger',                'Amur Tiger',         'Tigre de l\'Amour',      'Panthera tigris altaica', 1, 1, 3),
(7,  'Gorilla',                  'Gorilla',            'Gorille',                'Gorilla beringei',        1, 2, 3),
(8,  'Polarfuchs',               'Arctic Fox',         'Renard arctique',        'Vulpes lagopus',          1, 3, 1),
(9,  'Pazifischer Lachs',        'Pacific Salmon',     'Saumon du Pacifique',    'Oncorhynchus mykiss',     2, 3, 1),
(10, 'Komododrache',             'Komodo Dragon',      'Dragon de Komodo',       'Varanus komodoensis',     4, 1, 2);

-- ------------------------------------------------------------
-- Tabelle: lebensraum
-- PK: Lebensraum_ID | FK: Tier_ID → tierart, Kontinent_ID → kontinent
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `lebensraum`;
CREATE TABLE `lebensraum` (
  `Lebensraum_ID`     INT          NOT NULL AUTO_INCREMENT,
  `Tier_ID`           INT          NOT NULL,
  `Lebensraum`        VARCHAR(100) NOT NULL,
  `Kontinent_ID`      INT          NOT NULL,
  `Koerpergroesse_cm` INT          NOT NULL COMMENT 'Durchschnittliche Körpergröße in cm',
  `Gewicht_kg`        DECIMAL(8,1) NOT NULL COMMENT 'Durchschnittliches Gewicht in kg',
  `Quelle`            VARCHAR(100) NOT NULL,
  PRIMARY KEY (`Lebensraum_ID`),
  CONSTRAINT `fk_lebens_tier`      FOREIGN KEY (`Tier_ID`)      REFERENCES `tierart`   (`Tier_ID`),
  CONSTRAINT `fk_lebens_kontinent` FOREIGN KEY (`Kontinent_ID`) REFERENCES `kontinent` (`Kontinent_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `lebensraum` (`Lebensraum_ID`, `Tier_ID`, `Lebensraum`, `Kontinent_ID`, `Koerpergroesse_cm`, `Gewicht_kg`, `Quelle`) VALUES
(1,  1,  'Savanne',       1, 200, 190,  'IUCN Red List 2023'),
(2,  2,  'Savanne/Wald',  1, 330, 5000, 'WWF 2023'),
(3,  3,  'Ozean',         5, 600, 1100, 'IUCN Red List 2023'),
(4,  4,  'Antarktis',     6, 120, 40,   'BirdLife 2022'),
(5,  5,  'Ozean/Strand',  5, 150, 200,  'IUCN Red List 2023'),
(6,  6,  'Wald',          2, 280, 300,  'WWF 2023'),
(7,  7,  'Regenwald',     1, 175, 200,  'IUCN Red List 2023'),
(8,  8,  'Tundra',        7, 60,  4,    'IUCN Red List 2022'),
(9,  9,  'Fluss/Ozean',   3, 75,  4,    'NOAA 2023'),
(10, 10, 'Tropen',        2, 250, 90,   'IUCN Red List 2023');

-- ============================================================
-- Ende des Exports
-- ============================================================
