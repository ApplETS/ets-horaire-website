# language: fr

Fonctionnalité: Génération d'horaire
  En tant qu’étudiant,
  Je veux être en mesure de spécifier les divers cours et leurs caractéristiques,
  Afin de générer des combinaisons d’horaires intéressantes.

  Scénario: Une combinaison d'horaire pour une ancien étudiant
    Étant donné je suis un étudiant en Génie logiciel, inscrit à la session d’Automne 2013
    Et je choisi LOG210, LOG240, LOG540, LOG645 et LOG720 comme cours qui m'intéressent
    Et je spécifie comme contrainte les combinaisons de 5 cours seulement
    Lorsque je soumets mon choix
    Alors je suis sur la page des résultats
    Et il devrait n'y avoir que 2 résultats possibles
    Et il devrait y avoir une mention de Génie logiciel à la session d’Automne 2013
    Et il devrait y avoir une mention des cours sélectionnés: LOG210, LOG240, LOG540, LOG645 et LOG720
    Et il devrait y avoir une mention de la contrainte de 5 cours, sans aucun congé
    Lorsque je sélectionne le Calendrier HTML
    Alors je devrais voir apparaitre:
      | Numéro d'horaire | Jour     | Période       | Cours  | Groupe | Type      |
      | 1                | Lundi    | 08h30 - 10h30 | LOG720 | 1      | Labo A    |
      | 1                | Lundi    | 10h30 - 12h30 | LOG720 | 1      | Labo B    |
      | 1                | Lundi    | 13h30 - 15h30 | LOG240 | 1      | Labo A    |
      | 1                | Lundi    | 15h30 - 17h30 | LOG240 | 1      | Labo B    |
      | 1                | Mardi    | 08h45 - 12h15 | LOG210 | 1      | Cours     |
      | 1                | Mardi    | 18h00 - 20h00 | LOG540 | 1      | Labo A    |
      | 1                | Mardi    | 20h00 - 22h00 | LOG540 | 1      | Labo B    |
      | 1                | Mercredi | 08h45 - 12h15 | LOG720 | 1      | Cours     |
      | 1                | Mercredi | 13h30 - 15h30 | LOG645 | 1      | TP-Labo A |
      | 1                | Mercredi | 15h30 - 17h30 | LOG645 | 1      | TP-Labo B |
      | 1                | Jeudi    | 08h30 - 11h30 | LOG210 | 1      | Labo      |
      | 1                | Jeudi    | 13h30 - 17h00 | LOG240 | 1      | Cours     |
      | 1                | Jeudi    | 18h00 - 21h30 | LOG540 | 1      | Cours     |
      | 1                | Vendredi | 08h45 - 12h15 | LOG645 | 1      | Cours     |

      | 2                | Lundi    | 08h30 - 10h30 | LOG720 | 1      | Labo A    |
      | 2                | Lundi    | 10h30 - 12h30 | LOG720 | 1      | Labo B    |
      | 2                | Lundi    | 13h30 - 15h30 | LOG240 | 1      | Labo A    |
      | 2                | Lundi    | 15h30 - 17h30 | LOG240 | 1      | Labo B    |
      | 2                | Mardi    | 08h45 - 11h45 | LOG210 | 2      | Labo      |
      | 2                | Mardi    | 18h00 - 20h00 | LOG540 | 1      | Labo A    |
      | 2                | Mardi    | 20h00 - 22h00 | LOG540 | 1      | Labo B    |
      | 2                | Mercredi | 08h45 - 12h15 | LOG720 | 1      | Cours     |
      | 2                | Mercredi | 13h30 - 15h30 | LOG645 | 1      | TP-Labo A |
      | 2                | Mercredi | 15h30 - 17h30 | LOG645 | 1      | TP-Labo B |
      | 2                | Jeudi    | 08h30 - 12h00 | LOG210 | 2      | Cours     |
      | 2                | Jeudi    | 13h30 - 17h00 | LOG240 | 1      | Cours     |
      | 2                | Jeudi    | 18h00 - 21h30 | LOG540 | 1      | Cours     |
      | 2                | Vendredi | 08h45 - 12h15 | LOG645 | 1      | Cours     |

  Scénario: Une combinaison d'horaire pour une ancien étudiant
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
    Lorsque je sélectionne le Calendrier HTML
    Alors je devrais voir apparaitre:
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

  Scénario: Une combinaison d'horaire pour une ancien étudiant
    Étant donné je suis un étudiant en Génie de la construction, inscrit à la session d’Été 2014
    Et je choisi CTN200, CTN258, CTN600 et CTN626 comme cours qui m'intéressent
    Et je spécifie comme contrainte les combinaisons de 4 cours seulement
    Lorsque je soumets mon choix
    Alors je suis sur la page des résultats
    Et il devrait n'y avoir que 2 résultats possibles
    Et il devrait y avoir une mention de Génie de la construction à la session d’Été 2014
    Et il devrait y avoir une mention des cours sélectionnés: CTN200, CTN258, CTN600 et CTN626
    Et il devrait y avoir une mention de la contrainte de 4 cours, sans aucun congé
    Lorsque je sélectionne le Calendrier HTML
    Alors je devrais voir apparaitre:
      | Numéro d'horaire | Jour     | Période       | Cours  | Groupe | Type      |
      | 1                | Lundi    | 08h45 - 12h15 | CTN626 | 2      | Cours     |
      | 1                | Lundi    | 18h00 - 21h30 | CTN600 | 1      | Cours     |
      | 1                | Mardi    | 13h30 - 17h00 | CTN258 | 2      | Cours     |
      | 1                | Mardi    | 18h00 - 21h30 | CTN200 | 1      | Cours     |
      | 1                | Mercredi | 13h30 - 16h30 | CTN626 | 2      | TP-Labo/2 |
      | 1                | Jeudi    | 08h45 - 11h45 | CTN258 | 2      | TP/Labo   |
      | 1                | Jeudi    | 18h00 - 21h00 | CTN200 | 1      | TP/Labo   |
      | 1                | Samedi   | 09h00 - 17h00 | CTN600 | 1      | TP-Labo/2 |

      | 2                | Lundi    | 08h45 - 12h15 | CTN626 | 2      | Cours     |
      | 2                | Lundi    | 18h00 - 21h30 | CTN600 | 1      | Cours     |
      | 2                | Mardi    | 13h30 - 17h00 | CTN258 | 2      | Cours     |
      | 2                | Mardi    | 18h00 - 21h00 | CTN200 | 2      | TP/Labo   |
      | 2                | Mercredi | 13h30 - 16h30 | CTN626 | 2      | TP-Labo/2 |
      | 2                | Jeudi    | 08h45 - 11h45 | CTN258 | 2      | TP/Labo   |
      | 2                | Jeudi    | 18h00 - 21h30 | CTN200 | 2      | Cours     |
      | 2                | Samedi   | 09h00 - 17h00 | CTN600 | 1      | TP-Labo/2 |