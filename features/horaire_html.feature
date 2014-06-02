# language: fr

Fonctionnalité: Génération d'horaire
  En tant qu’étudiant,
  Je veux être en mesure de visualiser un horaire,
  Afin de mieux comprendre les résultats de la combinaison d'horaire.

  Scénario: Un horaire généré et représenté en HTML
    Étant donné un horaire avec la clé 1a2b-3c4d et composé des périodes:
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
    Lorsque j'accède au calendrier HTML avec la clé 1a2b-3c4d
    Alors je devrais voir les cours correspondant