# 04 - Dépannage Apache NiFi

## Problèmes courants

### L'interface NiFi ne répond pas

**Symptôme** : https://localhost:8443/nifi inaccessible

**Vérifications** :
```bash
# Vérifier l'état des containers
docker compose -f docker/docker-compose.yml ps

# Voir les logs NiFi
docker compose -f docker/docker-compose.yml logs nifi

# NiFi prend 2-3 minutes à démarrer
docker compose -f docker/docker-compose.yml logs nifi | grep -i "started"
```

**Solution** : Attendre le message `NiFi has started. The UI is available at https://...`

---

### Erreur de certificat TLS

**Symptôme** : `NET::ERR_CERT_AUTHORITY_INVALID` dans le navigateur

**Solution** : C'est normal avec les certificats auto-signés.
- Chrome : cliquer "Paramètres avancés" → "Continuer vers localhost"
- Firefox : "Accepter le risque et continuer"

---

### Processor en erreur (cercle rouge)

**Symptôme** : Un Processor affiche une icône d'erreur rouge

**Diagnostic** :
1. Survoler l'icône d'erreur → voir le message
2. Clic droit → **View status history**
3. Menu **Summary** → onglet **Bulletin Board** pour les erreurs détaillées

---

### Connexion PostgreSQL échoue

**Symptôme** : `Connection refused` dans le Processor `PutSQL` ou `PutDatabaseRecord`

**Vérifications** :
```bash
# Tester la connexion depuis NiFi
docker compose -f docker/docker-compose.yml exec nifi \
  bash -c "nc -zv nifi-postgres 5432"

# Tester PostgreSQL directement
docker compose -f docker/docker-compose.yml exec nifi-postgres \
  psql -U nifiuser -d nifidb -c "SELECT 1"
```

**Solution** : Vérifier l'URL JDBC dans le Controller Service `DBCPConnectionPool` :
`jdbc:postgresql://nifi-postgres:5432/nifidb`

---

### FlowFiles bloqués dans une queue

**Symptôme** : Les FlowFiles s'accumulent sans être traités

**Diagnostic** :
1. Clic droit sur la connexion → **List queue**
2. Inspecter un FlowFile (icône œil) → voir le contenu et les attributs

**Solutions** :
- Vérifier que le Processor destination est démarré
- Vider la queue : clic droit → **Empty queue**
- Vérifier le backpressure (object threshold trop bas ?)

---

### Erreur OutOfMemory

**Symptôme** : `java.lang.OutOfMemoryError`

**Solution** :
```yaml
# Dans docker-compose.yml, augmenter la JVM heap :
environment:
  - NIFI_JVM_HEAP_INIT=1g
  - NIFI_JVM_HEAP_MAX=4g
```

## Commandes utiles

```bash
# Logs en temps réel
docker compose -f docker/docker-compose.yml logs -f nifi

# Redémarrer NiFi
docker compose -f docker/docker-compose.yml restart nifi

# Shell dans le container NiFi
docker compose -f docker/docker-compose.yml exec nifi bash

# Vérifier les tables PostgreSQL
docker compose -f docker/docker-compose.yml exec nifi-postgres \
  psql -U nifiuser -d nifidb -c "\dt"

# Provoquer un test Kafka
docker compose -f docker/docker-compose.yml exec kafka \
  kafka-console-producer --broker-list kafka:9092 --topic nifi-events
```

## Réinitialiser l'environnement

```bash
docker compose -f docker/docker-compose.yml down -v
docker compose -f docker/docker-compose.yml up -d
```

> **Attention** : Toutes les données NiFi (flows, configurations) et PostgreSQL seront effacées.
