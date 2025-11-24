function scenario = choisirScenario()

    % Dossier où sont stockés les fichiers .mat
    dossier = 'mat_scenarios';  % Mets ici le nom du dossier

    % Liste des fichiers .mat
    scenarios = {
        'scenario_1.mat', ...
        'scenario_2.mat', ...
        'scenario_3.mat', ...
        'scenario_4.mat'
    };

    % Afficher la liste
    fprintf("📋 Scénarios disponibles :\n");
    for i = 1:numel(scenarios)
        fprintf(" %d - %s\n", i, scenarios{i});
    end

    % Demander à l’utilisateur de choisir
    choix = input("🔍 Quel scénario veux-tu charger ? (1-4) : ");

    if choix < 1 || choix > numel(scenarios)
        error("Choix invalide.");
    end

    % Construire le chemin complet
    chemin = fullfile(dossier, scenarios{choix});
    
    % Vérifier que le fichier existe
    if ~isfile(chemin)
        error("❌ Fichier .mat introuvable : %s", chemin);
    end

    % Charger le fichier .mat
    donnees = load(chemin);
    
    % Vérifie que la variable 'scenario' est présente
    if ~isfield(donnees, 'scenario')
        error("❌ Le fichier %s ne contient pas de variable 'scenario'.", chemin);
    end

    scenario = donnees.scenario;

    % Afficher un message de confirmation
    fprintf("✅ Scénario '%s' chargé avec succès !\n", scenarios{choix});
    disp(scenario);
end
