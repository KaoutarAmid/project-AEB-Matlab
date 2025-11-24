function scenario = readScenario(jsonFilePath)
% readScenario Lit un fichier JSON et retourne la structure du scénario
%
% Entrée :
%   - jsonFilePath : chemin vers le fichier JSON (ex: 'json/scenario_1.json')
% Sortie :
%   - scenario : structure contenant les paramètres du scénario

    % Vérification d'existence du fichier
    if ~isfile(jsonFilePath)
        error("❌ Fichier JSON introuvable : %s", jsonFilePath);
    end

    % Lecture du contenu du fichier
    fid = fopen(jsonFilePath, 'r');
    rawText = fread(fid, inf, '*char')';
    fclose(fid);

    % Conversion JSON → structure MATLAB
    scenario = jsondecode(rawText);

    % Affichage de confirmation
    fprintf("✅ Scénario '%s' chargé avec succès !\n", jsonFilePath);
end
