# 02 - Concepts clés Apache NiFi

## Architecture NiFi

### FlowFile
Unité de données fondamentale dans NiFi.
- **Attributs** : métadonnées (clé/valeur) — ex: `filename`, `uuid`, `mime.type`
- **Contenu** : les données binaires elles-mêmes (stockées dans le Content Repository)

### Processor
Composant de traitement. Chaque Processor effectue une tâche spécifique sur les FlowFiles.
- **Entrées** : 0 ou plusieurs queues
- **Sorties** : des Relationships (success, failure, retry...)

### Connection
Lien entre deux Processors via une Relationship.
Chaque connexion possède une **queue** avec contrôle de backpressure.

### Process Group
Conteneur logique pour grouper des Processors en sous-flow.
Permet de créer des flows réutilisables et hiérarchiques.

### Controller Service
Service partagé entre plusieurs Processors :
- `DBCPConnectionPool` : pool de connexions JDBC
- `CSVReader` / `JsonTreeReader` : lecteurs de formats
- `JsonRecordSetWriter` : écrivains de formats

### Repository
| Repository | Rôle |
|-----------|------|
| FlowFile Repository | Suivi de l'état de chaque FlowFile |
| Content Repository | Stockage des données des FlowFiles |
| Provenance Repository | Historique de chaque événement |

## Principaux Processors

### Entrée (Source)
| Processor | Usage |
|-----------|-------|
| `GenerateFlowFile` | Génère des FlowFiles de test |
| `GetFile` | Lit des fichiers depuis le système de fichiers |
| `InvokeHTTP` | Appel HTTP (GET, POST, PUT, DELETE) |
| `QueryDatabaseTable` | Lecture incrémentale d'une table SQL |
| `ConsumeKafka_2_6` | Consomme des messages Kafka |
| `ListenHTTP` | Récepteur HTTP (webhook) |

### Transformation
| Processor | Usage |
|-----------|-------|
| `SplitJson` | Divise un JSON tableau en FlowFiles |
| `EvaluateJsonPath` | Extrait des valeurs JSON en attributs |
| `RouteOnAttribute` | Route selon les attributs (conditions NiFi EL) |
| `UpdateAttribute` | Ajoute/modifie des attributs |
| `JoltTransformJSON` | Transformation JSON avec JOLT |
| `ConvertRecord` | Convertit entre formats (CSV, JSON, Avro...) |

### Sortie (Destination)
| Processor | Usage |
|-----------|-------|
| `PutSQL` | Exécute des requêtes SQL |
| `PutDatabaseRecord` | INSERT/UPDATE/UPSERT avec Record API |
| `PutFile` | Écrit vers le système de fichiers |
| `PublishKafka_2_6` | Publie vers un topic Kafka |
| `InvokeHTTP` | Appel HTTP (aussi en sortie) |

## NiFi Expression Language (NiFi EL)

Syntaxe : `${attributeName:function()}`

```
${filename}                          # valeur de l'attribut
${mime.type:equals('text/csv')}      # comparaison
${montant:toNumber():greaterThan(100)}  # comparaison numerique
${now():format('yyyy-MM-dd')}        # date formatee
${uuid()}                            # UUID aleatoire
```

## Backpressure

Chaque connexion peut avoir :
- **Object Threshold** : nombre max de FlowFiles en queue
- **Size Threshold** : taille max totale en queue

Si dépassé, le Processor source est mis en pause automatiquement.
