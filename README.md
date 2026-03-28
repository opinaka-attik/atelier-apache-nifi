# Atelier Apache NiFi

> Dataflow visuel, routage et transformation de données en temps réel

## Description

Cet atelier pratique vous permet de découvrir **Apache NiFi**, un système de dataflow distribué permettant d'automatiser le mouvement et la transformation de données entre systèmes. Basé sur des flows visuels, NiFi facilite l'ingestion, le routage, le filtrage et la transformation de données en temps réel sans écrire de code.

## Prérequis

- Docker & Docker Compose installés
- 4 Go de RAM minimum disponible
- Ports 8443 disponible
- Navigateur web moderne

## Structure du projet

```
atelier-apache-nifi/
├── docker/
│   └── docker-compose.yml
├── flows/
│   ├── 01_hello_nifi.json
│   ├── 02_file_ingestion.json
│   ├── 03_http_to_database.json
│   ├── 04_data_transformation.json
│   └── 05_realtime_pipeline.json
├── docs/
│   ├── 00_installation.md
│   ├── 01_interface.md
│   ├── 02_concepts_cles.md
│   ├── 03_guide_modules.md
│   └── 04_depannage.md
└── README.md
```

## Démarrage rapide

```bash
# Cloner le dépôt
git clone https://github.com/opinaka-attik/atelier-apache-nifi.git
cd atelier-apache-nifi

# Lancer NiFi
cd docker
docker compose up -d

# Accéder à l'interface (attendre ~2 minutes)
# https://localhost:8443/nifi
# Identifiants : admin / adminPassword123
```

## Flows inclus

| # | Flow | Description | Niveau |
|---|------|-------------|--------|
| 01 | Hello NiFi | Premier flow : générer et logger des données | Débutant |
| 02 | File Ingestion | Lire des fichiers et les transformer | Débutant |
| 03 | HTTP to Database | Appel API REST vers base de données | Intermédiaire |
| 04 | Data Transformation | Transformation avancée avec Jinja/Groovy | Intermédiaire |
| 05 | Realtime Pipeline | Pipeline temps réel multi-sources | Avancé |

## Documentation

| Fichier | Contenu |
|---------|----------|
| [00_installation.md](docs/00_installation.md) | Installation et configuration initiale |
| [01_interface.md](docs/01_interface.md) | Découverte de l'interface NiFi |
| [02_concepts_cles.md](docs/02_concepts_cles.md) | Processors, Connections, FlowFiles |
| [03_guide_modules.md](docs/03_guide_modules.md) | Guide des processors essentiels |
| [04_depannage.md](docs/04_depannage.md) | Résolution des problèmes courants |

## Concepts clés

- **FlowFile** : unité de données qui transite dans NiFi (contenu + attributs)
- **Processor** : composant qui traite les FlowFiles (GetFile, PutHTTP, ExecuteScript...)
- **Connection** : lien entre processors avec queue et priorité
- **Process Group** : groupe logique de processors (réutilisable)
- **Controller Service** : service partagé (connexion DB, SSL context...)

## Technologies

- Apache NiFi 1.23+
- Docker Compose
- REST API intégrée

## Auteur

opinaka-attik — Atelier pédagogique open-source
