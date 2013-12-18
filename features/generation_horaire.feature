# language: fr

Fonctionnalité: Génération d'horaire
  En tant qu’étudiant,
  Je veux être en mesure de spécifier les divers cours et leurs caractéristiques,
  Afin de générer des combinaisons d’horaires intéressantes.

  Scénario: Une combinaison d'horaire pour une ancien étudiant
    Étant donné je suis un ancien étudiant à l'ÉTS, inscrit à la session d’automne 2013
    Et j'ai spécifié PHY335, LOG210, LOG430, LOG510 et LOG630 comme cours qui m'intéressent
    Et je spécifie comme contrainte les combinaisons de 3 cours seulement
    Alors je devrais recevoir un résultat de toutes les combinaisons d'horaires possibles pour 3 cours seulement