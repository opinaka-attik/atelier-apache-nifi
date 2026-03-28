# 01 - Interface Apache NiFi

## Accès

URL : https://localhost:8443/nifi  
Login : `admin` / `adminpassword123`

> Accepter l'avertissement de certificat TLS auto-signé.

## Zones principales

### 1. Barre d'outils (haut)
- **Icônes de composants** : Processor, Input Port, Output Port, Process Group, Funnel, Label, Remote Process Group
- **Icônes d'actions** : New, Delete, Copy, Paste, Undo, Redo
- **Statistiques globales** : Messages, Bytes, Tasks, Time

### 2. Canvas (centre)
- Zone de conception visuelle infinie
- **Glisser-déposer** les composants depuis la barre d'outils
- **Double-clic** sur un Process Group pour y entrer
- **Clic droit** pour le menu contextuel
- **Ctrl+A** pour sélectionner tout
- **Molette** pour zoomer/dézoomer

### 3. Panneau des opérateurs (barre gauche)
Accès aux **Controller Services** (connexions partagees, readers, writers)

### 4. Panneau de navigation (coin haut gauche)
- Minimap pour naviguer dans les grands flows
- Boutons zoom +/-

### 5. Barre de statut (bas)
- Messages dans les queues
- Bytes traités
- Taux d'erreurs
- Version du flow

## Actions sur les composants

| Action | Raccourci |
|--------|-----------|
| Sélectionner tout | Ctrl+A |
| Copier | Ctrl+C |
| Coller | Ctrl+V |
| Supprimer | Delete |
| Grouper en Process Group | Ctrl+G |
| Zoom avant | Ctrl+Scroll+ |
| Zoom arrière | Ctrl+Scroll- |

## Configurer un Processor

1. Double-cliquer sur un Processor
2. Onglet **Properties** : configurer les paramètres
3. Onglet **Scheduling** : intervalle d'exécution
4. Onglet **Relationships** : gérer les sorties (auto-terminer les non utilisées)
5. Cliquer **Apply**

## Démarrer / Arrêter

- **Clic droit** sur un composant → Start / Stop
- **Clic droit** sur le canvas → Start all / Stop all
- Les Processors verts sont actifs, gris sont arrêtés, rouges ont des erreurs

## Queues et provenance

- **Clic droit sur une connexion** → "List queue" pour voir les FlowFiles en attente
- **Clic droit sur une connexion** → "Data provenance" pour tracer l'historique
