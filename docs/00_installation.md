# 00 - Installation d'Apache NiFi

## Prérequis

- Docker >= 20.10
- Docker Compose >= 2.0
- 6 Go RAM minimum (8 Go recommandés)
- Ports libres : 8443 (NiFi HTTPS), 5433 (PostgreSQL), 18080 (NiFi Registry)

## Lancement rapide

```bash
git clone https://github.com/opinaka-attik/atelier-apache-nifi
cd atelier-apache-nifi
docker compose -f docker/docker-compose.yml up -d
```

> **Note** : Le premier démarrage prend 2-3 minutes. NiFi initialise sa PKI et génère des certificats TLS.

## Vérification

```bash
docker compose -f docker/docker-compose.yml ps
# nifi       doit être "Up (healthy)"
# nifi-postgres doit être "Up (healthy)"
# nifi-registry doit être "Up"
```

Ouvrir le navigateur : https://localhost:8443/nifi

> Le navigateur affichera un avertissement de certificat auto-signé. Cliquer sur "Accepter le risque".

## Identifiants par défaut

| Service | URL | Utilisateur | Mot de passe |
|---------|-----|-------------|-------------|
| NiFi Web UI | https://localhost:8443/nifi | admin | adminpassword123 |
| NiFi Registry | http://localhost:18080 | aucun | aucun |
| PostgreSQL | localhost:5433 | nifiuser | nifipass |

## Structure des services

| Service | Port | Rôle |
|---------|------|------|
| nifi | 8443 | Interface web NiFi (HTTPS) |
| nifi-postgres | 5433 | Base de données PostgreSQL |
| nifi-registry | 18080 | Versioning des flows NiFi |

## Connexion PostgreSQL dans NiFi

Créer un service `DBCPConnectionPool` dans NiFi avec :

- **Database Connection URL** : `jdbc:postgresql://nifi-postgres:5432/nifidb`
- **Database Driver Class Name** : `org.postgresql.Driver`
- **Database User** : `nifiuser`
- **Password** : `nifipass`

Télécharger le driver JDBC PostgreSQL depuis : https://jdbc.postgresql.org/download/

## Arrêt et nettoyage

```bash
# Arrêter
docker compose -f docker/docker-compose.yml down

# Arrêter et supprimer les volumes
docker compose -f docker/docker-compose.yml down -v
```
