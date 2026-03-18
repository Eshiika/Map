# Projet final - Carte de France interactive
Application flutter permettant de rechercher des villes en fonction de critère géographique (distance, région, population) avec une interface interactive basée sur une carte.

## Installation et exécution avec Docker
### 1 - Cloner le projet
```bash
git clone https://github.com/Eshiika/Map.git
cd Map
```

### 2 - Lancer l'application
```bash
docker compose up -d
```

### 3 - Accès à l'application
http://localhost:3000

### 4 - Arrêter les conteneurs
```bash
docker compose down
```

## Choix techniques et architecturaux
### Frontend
- Utilisation de Flutter pour une interface moderne et responsive
- Intégration d'OpenStreetMap avec flutter_map
- Utilisation de provider et dio
- Interaction temps réel entre la carte et la liste
- Architecture MVVM avec Provider (code plus lisible)
- Flutter / Provider / Flutter Map / latlong2

```
lib/
├── data/               
│   ├── datasources/    # Services API
│   ├── models/         # Modèles de données
│   ├── repository/     # Accès aux données
├── screens/            # Pages
├── viewmodels/         # Logique métier + état de l'écran
├── widgets/            # Composant UI réutilisables
└── main.dart           # Point d'entrée
```

### Backend
- Spring Boot pour la création de l'API REST
- Utilisation de JPA pour l'accès aux données
- Requêtes SQL natives pour les calculs géographiques
- Java 21 / Spring Boot / Spring Web / Spring Data JPA

```
com.example.backend/
├── common/                   # Eléments partagés
│   ├── config/               # Configuration Spring (CORS, WebMvc)
│   ├── exception/            # Gestion globale des erreurs / exceptions
│   ├── response/            
├── domain/                   # Coeur métier de l'application
│   ├── city/                 
│       ├── entity/           # Entités métier / JPA 
│       ├── repository/       # Accès aux données / base de données
│       ├── service/          # Logique métier
├── http/                     # Couche d'exposotion HTTP
│   ├── api/                  # Contrôleurs REST / endpoints
└── BackendApplication.java   # Point d'entrée Spring Boot
```

### Base de données
- PostgreSQL
- Extension PostGIS pour les calculs géographiques

## Documentation API
### GET /api/cities
Récupère une liste de villes selon plusieurs filtres

#### Paramètres
```
| Paramètre     | Type    | Obligatoire | Description                          |
|---------------|---------|-------------|--------------------------------------|
| region        | string  | Non         | Région à filtrer                     |
| nbVille       | integer | Non         | Nombre maximum de villes à retourner |
| habitantMin   | integer | Non         | Nombre minimum d’habitants           |
| latitude      | double  | Oui         | Latitude du point central            |
| longitude     | double  | Oui         | Longitude du point central           |
| rayon         | double  | Non         | Rayon de recherche en mètres         |
```

#### Exemple de requête
```
GET /api/cities?nbVille=10&latitude=48.85962397285242&longitude=2.3470761672175215&rayon=10000
```

### Exemple de réponse
```
{
  "success": true,
  "status": 200,
  "message": "OK",
  "data": [
    {
      "id": 1,
      "latitude": 48.8566,
      "longitude": 2.3522,
      "name": "Paris",
      "population": 2148271,
      "region": "Île-de-France"
    },
  ],
  "timestamp": "2026-03-18T11:50:54.9767894",
  "errors": null
}
```

### GET /api/cities/regions
Retourne la liste des régions disponibles.

#### Exemple de requête
```
GET /api/cities/region
```

### Exemple de réponse
```
{
  "success": true,
  "status": 200,
  "message": "OK",
  "data": [
    "Auvergne-Rhône-Alpes",
    "Bourgogne-Franche-Comté",
    "Bretagne",
    "Centre-Val de Loire",
    "Corsica",
    "Grand Est",
    "Hauts-de-France",
    "Île-de-France",
    "Normandie",
    "Nouvelle-Aquitaine",
    "Occitanie",
    "Pays de la Loire",
    "Provence-Alpes-Côte d’Azur"
  ],
  "timestamp": "2026-03-18T11:56:13.0130662",
  "errors": null
}
```
