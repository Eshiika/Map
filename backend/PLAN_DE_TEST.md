# Plan de Test - City Explorer

## Analyse des Risques
L'analyse des risques permet d'identifier les problèmes potentiels pouvant impacter le projet ou le produit.

| ID  | Type de risque  | Risque identifié                                                                                    | Probabilité  |     Impact     | Niveau IEC 61508 | Action prévue |
|:---:|:---------------:|-----------------------------------------------------------------------------------------------------|:------------:|:--------------:|:----------------:|---------------|
| R1  |     Projet      | Mauvaise couverture de tests sur les fonctionnalités principales                                    | Peu probable |   Impactant    |       III        | Prioriser les tests sur les fonctionnalités critiques identifiées             
| R2  |     Projet      | Impossible de se connecter à la base de données (mauvaise config, Docker non lancé, port incorrect) | Peu probable | Catastrophique |       III        | Vérifier la configuration, les variables d’environnement et ajouter des tests d’intégration
| R3  |     Produit     | Le filtre par région retourne des résultats incorrects                                              |   Probable   |   Impactant    |       III        | Ajouter des tests d'intégration sur l'endpoint et vérifier le contenu JSON retourné |
| R4  |     Produit     | Le filtre par rayon retourne des résultats incorrects                                               | Peu probable | Catastrophique |       III        | Vérifier les paramètres envoyés à la requête et tester plusieurs cas connus avec ST_DWithin |


## Matrice des risques

| Impact \ Probabilité | Anecdotique  | Peu impactant | Impactant | Catastrophique |
|----------------------|:------------:|:-------------:|:---------:|:--------------:|
| Invraisemblable      |              |               |           |                |
| Peu probable         |              |               |    R1     |     R2, R4     |
| Probable             |              |               |    R3     |                |
| Certain              |              |               |           |                |

---
## Périmètre des Tests
### Fonctionnalité testée

La campagne de test se concentre exclusivement sur la fonctionnalité suivante :

> **Filtrage des villes**

### Critères testés

Les tests portent sur les éléments suivants :

- Filtrage par **région**
- Filtrage par **population minimale**
- Filtrage par **rayon géographique**
- Limitation du **nombre de villes retournées**
- Gestion des cas où certains filtres sont **absents (null)**
- La bonne communication entre le **frontend** et le **backend** et la **base de données**
- La vérification du bon affichage des résultats dans l'interface utilisateur

### Fonctionnalités exclues du périmètre
Les éléments suivants ne sont pas couverts par cette campagne de test :
- les autres fonctionnalités de navigation de l’application ;
- les performances globales de l’application ;
- la sécurité ;
- la gestion avancée des erreurs hors cas liés au filtrage ;
- les autres fonctionnalités non liées à la recherche de villes.

## Cahier de Recette (Tests d'Acceptation)

| ID du test | Description du scénario | Résultat attendu |  Statut  |
|:----------:|-------------------------|------------------|:--------:|
| A1 | L’utilisateur sélectionne un point sur la carte puis recherche les villes dans un rayon donné sans filtre de région ni de population. | Une liste de villes s’affiche en fonction de la position sélectionnée et du rayon choisi. Les marqueurs correspondants apparaissent sur la carte. |   Pass   |
| A2 | L’utilisateur sélectionne un point sur la carte puis applique un filtre de population minimale à 100 000 habitants. | Seules les villes ayant une population supérieure ou égale à 100 000 habitants sont affichées dans la liste et sur la carte. |   Pass   |
| A3 | L’utilisateur sélectionne un point sur la carte puis choisit la région « Hauts-de-France ». | Seules les villes appartenant à la région Hauts-de-France sont retournées dans les résultats. |   Pass   |