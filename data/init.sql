-- Init NiFi PostgreSQL database
-- Création des tables pour les exercices Apache NiFi

-- Table des commandes (source ETL)
CREATE TABLE IF NOT EXISTS commandes (
    id SERIAL PRIMARY KEY,
    client_id INTEGER NOT NULL,
    produit VARCHAR(200) NOT NULL,
    quantite INTEGER NOT NULL DEFAULT 1,
    prix_unitaire DECIMAL(10,2) NOT NULL,
    montant DECIMAL(10,2) GENERATED ALWAYS AS (quantite * prix_unitaire) STORED,
    statut VARCHAR(50) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Table des clients
CREATE TABLE IF NOT EXISTS clients (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    email VARCHAR(200) UNIQUE NOT NULL,
    ville VARCHAR(100),
    pays VARCHAR(50) DEFAULT 'FR',
    created_at TIMESTAMP DEFAULT NOW()
);

-- Table pour les données API (module 03)
CREATE TABLE IF NOT EXISTS api_users (
    id INTEGER PRIMARY KEY,
    name VARCHAR(200),
    email VARCHAR(200),
    phone VARCHAR(50),
    website VARCHAR(200),
    loaded_at TIMESTAMP DEFAULT NOW()
);

-- Table des events Kafka (module 05)
CREATE TABLE IF NOT EXISTS kafka_events (
    id SERIAL PRIMARY KEY,
    topic VARCHAR(100),
    payload JSONB,
    received_at TIMESTAMP DEFAULT NOW()
);

-- Données de test - clients
INSERT INTO clients (nom, email, ville, pays) VALUES
    ('Alice Martin', 'alice@example.com', 'Paris', 'FR'),
    ('Bob Dupont', 'bob@example.com', 'Lyon', 'FR'),
    ('Claire Moreau', 'claire@example.com', 'Marseille', 'FR'),
    ('David Petit', 'david@example.com', 'Bordeaux', 'FR'),
    ('Emma Bernard', 'emma@example.com', 'Lille', 'FR');

-- Données de test - commandes
INSERT INTO commandes (client_id, produit, quantite, prix_unitaire, statut) VALUES
    (1, 'Laptop Pro 15', 1, 1299.99, 'completed'),
    (2, 'Souris ergonomique', 2, 45.00, 'completed'),
    (3, 'Clavier mécanique', 1, 89.99, 'pending'),
    (4, 'Moniteur 4K', 1, 549.00, 'completed'),
    (5, 'Webcam HD', 3, 79.99, 'shipped'),
    (1, 'Casque Bluetooth', 1, 199.00, 'completed'),
    (2, 'Hub USB-C', 1, 35.50, 'pending'),
    (3, 'SSD 1To', 2, 120.00, 'completed');
