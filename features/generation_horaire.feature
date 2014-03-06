# language: fr

Fonctionnalité: Génération d'horaire
  En tant qu’étudiant,
  Je veux être en mesure de spécifier les divers cours et leurs caractéristiques,
  Afin de générer des combinaisons d’horaires intéressantes.

  Scénario: Une combinaison d'horaire pour une ancien étudiant
    Étant donné je suis un étudiant en Génie logiciel, inscrit à la session d’Automne 2013
    Et j'ai spécifié LOG210, LOG240, LOG540, LOG645 et LOG720 comme cours qui m'intéressent
    Et je spécifie comme contrainte les combinaisons de 5 cours seulement
    Lorsque je soumets mon choix
    Alors il devrait n'y avoir que 2 résultats possibles
    Et une mention de Génie logiciel à la session d’Automne 2013
    Et une mention des cours sélectionnés: LOG210, LOG240, LOG540, LOG645 et LOG720
    Et une mention de la contrainte de 5 cours, sans aucun congé
    Lorsque je sélectionne le Calendrier HTML
    Alors je devrais voir apparaitre:
      | Numéro d'horaire | Jour     | Période       | Cours  | Groupe | Type      |
      | 1                | Lundi    | 08:30 - 10:30 | LOG720 | 1      | Labo A    |
      | 1                | Lundi    | 10:30 - 12:30 | LOG720 | 1      | Labo B    |
      | 1                | Lundi    | 13:30 - 15:30 | LOG240 | 1      | Labo A    |
      | 1                | Lundi    | 15:30 - 17:30 | LOG240 | 1      | Labo B    |
      | 1                | Mardi    | 08:45 - 12:15 | LOG210 | 1      | Cours     |
      | 1                | Mardi    | 18:00 - 20:00 | LOG540 | 1      | Labo A    |
      | 1                | Mardi    | 20:00 - 22:00 | LOG540 | 1      | Labo B    |
      | 1                | Mercredi | 08:45 - 12:15 | LOG720 | 1      | Cours     |
      | 1                | Mercredi | 13:30 - 15:30 | LOG645 | 1      | TP-Labo A |
      | 1                | Mercredi | 15:30 - 17:30 | LOG645 | 1      | TP-Labo B |
      | 1                | Jeudi    | 08:30 - 11:30 | LOG210 | 1      | Labo      |
      | 1                | Jeudi    | 13:30 - 17:00 | LOG240 | 1      | Cours     |
      | 1                | Jeudi    | 18:00 - 21:30 | LOG540 | 1      | Cours     |
      | 1                | Vendredi | 08:45 - 12:15 | LOG645 | 1      | Cours     |

      | 2                | Lundi    | 08:30 - 10:30 | LOG720 | 1      | Labo A    |
      | 2                | Lundi    | 10:30 - 12:30 | LOG720 | 1      | Labo B    |
      | 2                | Lundi    | 13:30 - 15:30 | LOG240 | 1      | Labo A    |
      | 2                | Lundi    | 15:30 - 17:30 | LOG240 | 1      | Labo B    |
      | 2                | Mardi    | 08:45 - 12:15 | LOG210 | 2      | Labo     |
      | 2                | Mardi    | 18:00 - 20:00 | LOG540 | 1      | Labo A    |
      | 2                | Mardi    | 20:00 - 22:00 | LOG540 | 1      | Labo B    |
      | 2                | Mercredi | 08:45 - 12:15 | LOG720 | 1      | Cours     |
      | 2                | Mercredi | 13:30 - 15:30 | LOG645 | 1      | TP-Labo A |
      | 2                | Mercredi | 15:30 - 17:30 | LOG645 | 1      | TP-Labo B |
      | 2                | Jeudi    | 08:30 - 11:30 | LOG210 | 2      | Cours      |
      | 2                | Jeudi    | 13:30 - 17:00 | LOG240 | 1      | Cours     |
      | 2                | Jeudi    | 18:00 - 21:30 | LOG540 | 1      | Cours     |
      | 2                | Vendredi | 08:45 - 12:15 | LOG645 | 1      | Cours     |