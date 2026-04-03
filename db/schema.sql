-- Création de la base de données
CREATE DATABASE IF NOT EXISTS vide_grenier
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE vide_grenier;

-- Table des articles
CREATE TABLE IF NOT EXISTS articles (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    nom         VARCHAR(150)   NOT NULL,
    description TEXT,
    prix        DECIMAL(8, 2)  NOT NULL DEFAULT 0.00,
    vendeur     VARCHAR(100)   NOT NULL,
    created_at  DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Données de démo
INSERT INTO articles (nom, description, prix, vendeur) VALUES
    ('Vélo enfant 20"',    'Vélo rouge, bon état, quelques rayures.',          25.00, 'Marie D.'),
    ('Table basse bois',   'Table carrée 80x80, style scandinave.',            40.00, 'Paul R.'),
    ('Lot de livres BD',   '12 albums Tintin en très bon état.',               30.00, 'Sophie L.'),
    ('Appareil photo film','Olympus OM-10, fonctionne parfaitement.',          55.00, 'Thomas B.'),
    ('Vase en céramique',  'Hauteur 35 cm, couleur bleu nuit, sans défaut.',   15.00, 'Emma V.');
