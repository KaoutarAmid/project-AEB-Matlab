function AEB_GUI
    % Interface graphique pour sélectionner un scénario AEB (.mat)

    % Créer la fenêtre
    fig = uifigure('Name', 'AEB - Gestion de Scénarios MAT', 'Position', [100 100 500 320]);

    % Dossier contenant les fichiers .mat
    folder = fullfile(pwd, 'mat_scenarios');
    matFiles = dir(fullfile(folder, '*.mat'));
    fileNames = {matFiles.name};

    % Vérifie s'il y a des fichiers
    if isempty(fileNames)
        uialert(fig, 'Aucun fichier .mat trouvé dans ce dossier.', 'Erreur');
        return;
    end

    % Label
    uilabel(fig, ...
        'Text', 'Sélectionne un scénario AEB à charger :', ...
        'Position', [20 270 300 22], ...
        'FontWeight', 'bold');

    % Menu déroulant
    dd = uidropdown(fig, ...
        'Items', fileNames, ...
        'Position', [20 240 200 22]);

    % Zone de texte
    txtArea = uitextarea(fig, ...
        'Position', [20 20 450 180], ...
        'Editable', 'off');

    % Bouton "Charger scénario"
    uibutton(fig, ...
        'Text', '📥 Charger scénario', ...
        'Position', [250 240 150 25], ...
        'ButtonPushedFcn', @(btn, event) chargerScenarioMAT(dd, txtArea, folder));

    % Bouton "Lancer Simulink"
    uibutton(fig, ...
        'Text', '▶️ Lancer Simulink', ...
        'Position', [170 210 150 25], ...
        'ButtonPushedFcn', @(btn, event) open_system('AEBsystem'));  % Modèle Simulink
end
