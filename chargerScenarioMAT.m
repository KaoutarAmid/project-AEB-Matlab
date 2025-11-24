function chargerScenarioMAT(dd, txtArea, folder)
    fichier = dd.Value;
    chemin = fullfile(folder, fichier);

    try
        data = load(chemin);
        scenario = data.scenario;
        assignin('base', 'scenario', scenario);

        ego = scenario.EgoVehicle;
        cible = scenario.TargetVehicle;

        % ➡️ Texte affiché dans l'interface
        infos = sprintf("✅Scénario chargé : %s\n\n", scenario.NomScenario);

        if isfield(scenario, 'Ts')
            infos = [infos, sprintf("⏱️  Ts : %.2f s\n", scenario.Ts)];
        end
        if isfield(scenario, 'SimStopTime')
            infos = [infos, sprintf("🕒 Durée : %.2f s\n", scenario.SimStopTime)];
        end

        infos = [infos, sprintf("\n🚗 Véhicule égo :\n")];
        infos = [infos, sprintf("   • Vitesse : %.2f m/s\n", ego.v0)];
        infos = [infos, sprintf("   • Position : [%.2f, %.2f]\n", ego.x0, ego.y0)];
        infos = [infos, sprintf("   • Orientation (yaw) : %.2f rad\n", ego.yaw0)];
        if isfield(ego, 'delta')
            infos = [infos, sprintf("   • Braquage (delta) : %.2f rad\n", ego.delta)];
        end

        infos = [infos, sprintf("\n🎯 Véhicule cible :\n")];
        infos = [infos, sprintf("   • Vitesse : %.2f m/s\n", cible.v0)];
        infos = [infos, sprintf("   • Position : [%.2f, %.2f]\n", cible.x0, cible.y0)];
        infos = [infos, sprintf("   • Orientation (yaw) : %.2f rad\n", cible.yaw0)];

        txtArea.Value = infos;

        % ➡️ Mise à jour dans Simulink
        if bdIsLoaded('AEBsystem')
            set_param('AEBsystem/voiture_ego', ...
                'x0_vech', num2str(ego.x0), ...
                'y0_vech', num2str(ego.y0), ...
                'v0_vech', num2str(ego.v0), ...
                'yaw0_vech', num2str(ego.yaw0));

            set_param('AEBsystem/voiture_cible', ...
                'x0_cible', num2str(cible.x0), ...
                'y0_cible', num2str(cible.y0), ...
                'v0_cible', num2str(cible.v0), ...
                'yaw0_cible', num2str(cible.yaw0));

            save_system('AEBsystem');
        end

    catch ME
        txtArea.Value = ['❌ Erreur de lecture : ', ME.message];
    end
end
