 Étapes d'utilisation
1. Ouvrir le fichier Simulink principal
Ouvrez le fichier :
AEBsystem.slx
Cela vous permettra de visualiser l’architecture du système dans Simulink.
2. Charger les fichiers MATLAB (.m)
Assurez-vous que les fichiers .m du projet sont présents dans le même dossier. Ils seront utilisés par le système lors de la simulation.
3. Exécuter le script d'initialisation
Lancez le fichier :
INITAEB.m
Lors de l’exécution, choisissez un scénario :
1 — Scénario 1
2 — Scénario 2
4. Simuler les autres fichiers .m
Après l’initialisation, exécutez les autres scripts .m nécessaires au fonctionnement du projet.
5. Utiliser l’interface AEB — Gestion de Scénarios
Ouvrez l’interface :
AEB-gestion de scenarios.mat
Dans l’interface :
Chargez votre scénario via le bouton prévu.
Lancez l’envoi vers Simulink.
6. Simuler dans Simulink
Retournez dans AEBsystem.slx, puis lancez la simulation du modèle.
7. Analyser les résultats
Selon le scénario sélectionné, observez :
les graphiques,
les variables enregistrées,
le comportement du système AEB.
8. Simuler d'autres scénarios personnalisés
Vous pouvez également créer ou tester d’autres scénarios en modifiant l’état des capteurs directement dans les blocs Simulink. Cela permet par exemple de simuler :
un scénario d’erreur système,
un capteur qui ne répond plus,
des valeurs incohérentes ou bruitées.
Il suffit d’ajuster les paramètres ou signaux dans les blocs concernés pour observer le comportement du système AEB. `
