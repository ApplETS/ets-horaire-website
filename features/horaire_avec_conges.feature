# language: fr

Fonctionnalité: Génération d'horaire
  En tant qu’étudiant,
  Je veux être en mesure de spécifier des congés lors de la sélection de mes cours,
  Afin de répondre à mes besoins.

  Scénario: Une combinaison d'horaire avec congés pour une ancien étudiant
    Étant donné je suis un étudiant en Génie logiciel, inscrit à la session d’Été 2014
    Et je choisi CHM131, COM110, FRA150 et FRA151 comme cours qui m'intéressent
    Et je spécifie comme contrainte les combinaisons de 3 cours seulement
    Et je spécifie les congés:
      | Jour     | Début | Fin   |
      | Lundi    | 00h00 | 23h00 |
      | Mercredi | 00h00 | 23h00 |
      | Vendredi | 16h00 | 23h00 |
    Lorsque je soumets mon choix
    Alors je suis sur la page des résultats
    Et il devrait n'y avoir que 3 résultats possibles
    Et il devrait y avoir une mention de Génie logiciel à la session d’Été 2014
    Et il devrait y avoir une mention des cours sélectionnés: CHM131, COM110, FRA150 et FRA151
    Et il devrait y avoir une mention de la contrainte de 3 cours
    Et il devrait y avoir des mentions pour les congés:
      | Jour     | Début | Fin   |
      | Lundi    | 00h00 | 23h00 |
      | Mercredi | 00h00 | 23h00 |
      | Vendredi | 16h00 | 23h00 |
    Et je devrais avoir comme cours:
      | Numéro d'horaire | Jour     | Période       | Cours  | Groupe | Type      |
      | 1                | Mardi    | 09h00 - 12h00 | CHM131 | 4      | TP        |
      | 1                | Mardi    | 13h30 - 17h00 | FRA150 | 1      | Cours     |
      | 1                | Mardi    | 18h00 - 21h30 | COM110 | 4      | Cours     |
      | 1                | Jeudi    | 09h00 - 12h30 | CHM131 | 4      | Cours     |
      | 1                | Jeudi    | 18h00 - 22h00 | COM110 | 4      | TP A+B    |
      | 1                | Vendredi | 13h30 - 15h30 | FRA150 | 1      | TP        |

      | 2                | Mardi    | 08h30 - 12h30 | COM110 | 1      | TP A+B    |
      | 2                | Mardi    | 13h30 - 17h00 | FRA150 | 1      | Cours     |
      | 2                | Mardi    | 18h00 - 21h00 | CHM131 | 8      | TP        |
      | 2                | Jeudi    | 09h00 - 12h30 | COM110 | 1      | Cours     |
      | 2                | Jeudi    | 18h00 - 21h30 | CHM131 | 8      | Cours     |
      | 2                | Vendredi | 13h30 - 15h30 | FRA150 | 1      | TP        |

      | 3                | Mardi    | 09h00 - 12h30 | CHM131 | 9      | Cours     |
      | 3                | Mardi    | 13h30 - 17h00 | FRA150 | 1      | Cours     |
      | 3                | Mardi    | 18h00 - 21h30 | COM110 | 4      | Cours     |
      | 3                | Jeudi    | 09h00 - 12h00 | CHM131 | 9      | TP        |
      | 3                | Jeudi    | 18h00 - 22h00 | COM110 | 4      | TP A+B    |
      | 3                | Vendredi | 13h30 - 15h30 | FRA150 | 1      | TP        |