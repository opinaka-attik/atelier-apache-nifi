# 03 - Guide des modules (Flows NiFi)

## Module 01 - Hello NiFi Flow

**Fichier** : `flows/01_hello_flow.json`  
**Objectif** : Premier flow, comprendre le cycle de vie d'un FlowFile

### Importer le flow
1. Cliquer droit sur le canvas → **Upload template**
2. Sélectionner le fichier JSON (NiFi 1.x) ou importer via Registry
3. Glisser le template sur le canvas

### Etapes du flow
1. `GenerateFlowFile` : génère un FlowFile JSON toutes les 5 secondes
2. `LogAttribute` : affiche les attributs et le contenu dans les logs

### Exécuter
- Clic droit sur chaque Processor → Start
- Voir les logs : menu **Summary** → onglet **Logging**

---

## Module 02 - CSV vers PostgreSQL

**Fichier** : `flows/02_csv_to_postgres.json`  
**Objectif** : Lire un CSV et charger en base

### Prérequis
1. Créer un `DBCPConnectionPool` nommé `DBCPConnectionPool-postgres`
2. URL : `jdbc:postgresql://nifi-postgres:5432/nifidb`
3. Copier le JDBC driver PostgreSQL dans `/opt/nifi/nifi-current/lib/`
4. Déposer un fichier CSV dans `/opt/nifi/data/`

### Etapes
1. `GetFile` : détecte les CSV dans `/opt/nifi/data/`
2. `SplitRecord` : divise le CSV en records individuels (CSVReader)
3. `PutDatabaseRecord` : INSERT dans la table `commandes`

---

## Module 03 - API REST vers PostgreSQL

**Fichier** : `flows/03_rest_api_to_db.json`  
**Objectif** : Consommer une API HTTP et stocker les données

### Etapes
1. `InvokeHTTP` : GET https://jsonplaceholder.typicode.com/users (toutes les 60s)
2. `SplitJson` : sépare le tableau en FlowFiles individuels (`$.*`)
3. `EvaluateJsonPath` : extrait `id`, `name`, `email`, `phone`, `website` en attributs
4. `PutSQL` : UPSERT dans la table `api_users`

### NiFi EL utilisée
```
${user.id}, ${user.name}, ${user.email}, ${user.phone}, ${user.website}
```

---

## Module 04 - Filtrage et Transformation

**Fichier** : `flows/04_filter_transform.json`  
**Objectif** : Lire des données SQL, les transformer et les router

### Etapes
1. `QueryDatabaseTable` : lecture incrémentale de `commandes` (MAX id comme watermark)
2. `ConvertAvroToJSON` : convert Avro → JSON
3. `SplitJson` : sépare en enregistrements
4. `RouteOnAttribute` : route selon `${statut}` : completed / pending / shipped

### Concept RouteOnAttribute
Chaque propriété définit une condition NiFi EL :
```
completed : ${statut:equals('completed')}
pending   : ${statut:equals('pending')}
```

---

## Module 05 - Kafka Streaming

**Fichier** : `flows/05_kafka_streaming.json`  
**Objectif** : Consommer un topic Kafka et persister en base

### Prérequis
Ajouter Kafka au docker-compose :
```yaml
kafka:
  image: confluentinc/cp-kafka:7.5.0
  environment:
    KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://kafka:9092
    KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
  networks:
    - nifi-net
```

### Etapes
1. `ConsumeKafka_2_6` : topic `nifi-events`, broker `kafka:9092`
2. `ParseRecord` : parse le JSON avec `JsonTreeReader`
3. `PutDatabaseRecord` : INSERT dans `kafka_events`

### Tester avec un producteur
```bash
docker exec -it kafka kafka-console-producer \
  --broker-list kafka:9092 \
  --topic nifi-events
# Taper : {"topic": "test", "payload": {"key": "value"}}
```
