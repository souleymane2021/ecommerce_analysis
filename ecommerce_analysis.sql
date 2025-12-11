-- Création de la base de données
CREATE DATABASE ecommerce;

-- Utilisation de la base
\c ecommerce;

-- Création des tables
CREATE TABLE clients(
    client_id INT PRIMARY KEY,
    nom VARCHAR(100),
    ville VARCHAR(100),
    pays VARCHAR(100)
);

CREATE TABLE produits(
    produit_id INT PRIMARY KEY,
    nom_produit VARCHAR(100),
    categorie VARCHAR(50),
    prix DECIMAL(10,2)
);

CREATE TABLE ventes(
    vente_id INT PRIMARY KEY,
    client_id INT,
    produit_id INT,
    date_vente DATE,
    quantite INT,
    FOREIGN KEY (client_id) REFERENCES clients(client_id),
    FOREIGN KEY (produit_id) REFERENCES produits(produit_id)
);

-- Insertion des données
INSERT INTO clients (client_id, nom, ville, pays)
VALUES
(1, 'Alice Dupont', 'Paris', 'France'),
(2, 'Karim Benali', 'Lyon', 'France'),
(3, 'Sarah Lemoine', 'Marseille', 'France'),
(4, 'John Doe', 'Bruxelles', 'Belgique'),
(5, 'Maria Rossi', 'Rome', 'Italie'),
(6, 'Lucas Martin', 'Toulouse', 'France'),
(7, 'Emma Dubois', 'Nice', 'France'),
(8, 'Tom Bernard', 'Geneve', 'Suisse'),
(9, 'Nina Muller', 'Berlin', 'Allemagne'),
(10, 'Pedro Gomez', 'Madrid', 'Espagne');

INSERT INTO produits (produit_id, nom_produit, categorie, prix)
VALUES
(1, 'Ordinateur Portable', 'Electronique', 899.99),
(2, 'Casque Audio', 'Electronique', 129.99),
(3, 'Chaise de Bureau', 'Mobilier', 199.50),
(4, 'Bureau en Bois', 'Mobilier', 349.00),
(5, 'Souris sans fil', 'Electronique', 49.99),
(6, 'Lampe de Bureau', 'Decoration', 39.99),
(7, 'Tapis de Souris', 'Accessoires', 14.99),
(8, 'Moniteur 27 pouces', 'Electronique', 249.00);

INSERT INTO ventes (vente_id, client_id, produit_id, date_vente, quantite)
VALUES
(1, 1, 1, '2025-01-15', 1),
(2, 2, 2, '2025-01-17', 2),
(3, 3, 3, '2025-02-02', 1),
(4, 1, 5, '2025-02-10', 1),
(5, 4, 4, '2025-02-22', 1),
(6, 5, 8, '2025-03-05', 2),
(7, 6, 7, '2025-03-12', 3),
(8, 7, 6, '2025-03-20', 1),
(9, 8, 1, '2025-04-01', 1),
(10, 9, 2, '2025-04-10', 1),
(11, 10, 3, '2025-04-15', 2),
(12, 2, 4, '2025-05-01', 1),
(13, 3, 5, '2025-05-10', 2),
(14, 1, 8, '2025-05-25', 1),
(15, 5, 7, '2025-06-01', 4),
(16, 6, 6, '2025-06-15', 2),
(17, 7, 1, '2025-07-03', 1),
(18, 8, 2, '2025-07-10', 1),
(19, 9, 5, '2025-07-22', 3),
(20, 10, 4, '2025-08-01', 1);

-- Analyses

-- 1. Liste complète des ventes avec montant total
SELECT
    c.nom,
    p.nom_produit,
    v.quantite,
    v.date_vente,
    (p.prix * v.quantite) AS montant_total
FROM ventes v
JOIN produits p ON v.produit_id = p.produit_id
JOIN clients c ON v.client_id = c.client_id;

-- 2. Ventes totales et revenu total par catégorie
SELECT
    p.categorie,
    SUM(v.quantite) AS total_ventes,
    SUM(v.quantite * p.prix) AS revenu_total
FROM ventes v
JOIN produits p ON v.produit_id = p.produit_id
GROUP BY p.categorie
ORDER BY revenu_total DESC;

-- 3. Revenu total par mois
SELECT
    EXTRACT(MONTH FROM v.date_vente) AS mois,
    SUM(v.quantite * p.prix) AS revenu_total
FROM ventes v
JOIN produits p ON v.produit_id = p.produit_id
GROUP BY mois
ORDER BY mois ASC;

-- 4. Top 5 clients par revenu total
SELECT
    c.nom,
    SUM(v.quantite * p.prix) AS revenu_total
FROM ventes v
JOIN produits p ON v.produit_id = p.produit_id
JOIN clients c ON v.client_id = c.client_id
GROUP BY c.nom
ORDER BY revenu_total DESC
LIMIT 5;

-- 5. Indicateurs agrégés sur toutes les ventes
SELECT
    SUM(v.quantite * p.prix) AS chiffre_affaires_total,
    AVG(v.quantite) AS quantite_moyenne_par_vente,
    AVG(p.prix) AS prix_moyen_par_produit_vendu
FROM ventes v
JOIN produits p ON v.produit_id = p.produit_id;
