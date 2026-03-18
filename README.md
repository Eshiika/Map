# Projet final - Carte de France interactive
Application flutter permettant de rechercher des villes en fonction de critère géographique (distance, région, population) avec une interface interactive basée sur une carte.

## Installation et exécution avec Docker
### 1 - Cloner le projet
```bash
git clone https://github.com/Eshiika/Carte-France-Interactive.git
cd map
```

### 2 - Lancer l'application
```bash
docker compose up --build
```

### 3 - Accès à l'application
http://localhost:3000

### 4 - Arrêter les conteneurs
```bash
docker compose down
```

## Choix techniques et architecturaux
### Frontend
- Utilisation de Flutter Web pour une interface moderne et responsive
- Intégration d'OpenStreetMap avec flutter_map
- Gestion des états avec setState
- Interaction temps réel entre la carte et la liste

```
lib/
├── i18n/              # Fichiers de traduction
├── logic/             # Logique technique
│   ├── api/          # Services d'API
│   ├── constants/    # Constantes
│   ├── models/       # Modèles de données
│   ├── providers/    # Gestion d'état
│   └── router/       # Navigation
├── ui/               # Interface utilisateur
│   ├── pages/       # Pages principales
│   ├── views/       # Composants réutilisables
│   ├── widgets/     # Widgets customisés
│   └── view_parts/  # Éléments d'interface
└── main.dart         # Point d'entrée
```

### Backend
- API REST développée avec Spring Boot
- Utilisation de JPA pour l'accès aux données
- Requêtes SQL natives pour les calculs géographiques

```
lib/
├── i18n/              # Fichiers de traduction
├── logic/             # Logique technique
│   ├── api/          # Services d'API
│   ├── constants/    # Constantes
│   ├── models/       # Modèles de données
│   ├── providers/    # Gestion d'état
│   └── router/       # Navigation
├── ui/               # Interface utilisateur
│   ├── pages/       # Pages principales
│   ├── views/       # Composants réutilisables
│   ├── widgets/     # Widgets customisés
│   └── view_parts/  # Éléments d'interface
└── main.dart         # Point d'entrée
```

### Base de données
- PostgreSQL
- Extension PostGIS pour les calculs géographiques