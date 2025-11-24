%% INITAEB.m - Initialisation complète et robuste du scénario AEB
clc;
clear;
%% Charger le scénario
scenario = choisirScenario();  % Appelle automatiquement readScenario()


%% Paramètres généraux
if isfield(scenario, 'Ts')
    Ts = scenario.Ts;
else
    Ts = 0.1; % par défaut
end

if isfield(scenario, 'SimStopTime')
    SimStopTime = scenario.SimStopTime;
else
    SimStopTime = 10; % par défaut
end

%%  Paramètres du véhicule égo
ego = scenario.EgoVehicle;
x0_vech = ego.x0;
y0_vech = ego.y0;
v0_vech = ego.v0;
yaw0_vech = ego.yaw0;
if isfield(ego, 'ydot')
    ydot_o = ego.ydot;
else
    ydot_o = 0;
end

if isfield(ego, 'delta')
    delta_vech = ego.delta;
else
    delta_vech = 0;
end

%% Paramètres du véhicule cible
cible = scenario.TargetVehicle;
x0_cible = cible.x0;
y0_cible = cible.y0;
v0_cible = cible.v0;


if isfield(cible, 'yaw0')
    yaw0_cible = cible.yaw0;
else
    yaw0_cible = 0;
end

if isfield(cible, 'delta')
    delta_cible = cible.delta;
else
    delta_cible = 0;
end



%% Paramètres ARC (alerte FCW + inattention)
if isfield(scenario, 'ARC')
    ARC = scenario.ARC;

    if isfield(ARC, 'fcw_seuil')
        seuil_FCW = ARC.fcw_seuil;
    elseif isfield(ARC, 'seuil')
        seuil_FCW = ARC.seuil;
    else
        seuil_FCW = 1.6;
    end

    if isfield(ARC, 'decel_conduc')
        decelConducteur = ARC.decel_conduc;
    else
        decelConducteur = 1.5;
    end
else
    seuil_FCW = 1.6;
    decelConducteur = 1.5;
end


%%  Paramètres FRU (freinage automatique) 
if isfield(scenario, 'FRU')
    FRU = scenario.FRU;

    if isfield(FRU, 'PB1_decel')
        PB1_decel = FRU.PB1_decel;
    else
        PB1_decel = 1.8;
    end

    if isfield(FRU, 'PB2_decel')
        PB2_decel = FRU.PB2_decel;
    else
        PB2_decel = 3.2;
    end

    if isfield(FRU, 'FFORT_decel')
        FFORT_decel = FRU.FFORT_decel;
    else
        FFORT_decel = 5.0;
    end

    if isfield(FRU, 'headwayOffset')
        headwayOffset = FRU.headwayOffset;
    else
        headwayOffset = 1.5;
    end

    if isfield(FRU, 'timeMargin')
        timeMargin = FRU.timeMargin;
    else
        timeMargin = 0.3;
    end
else
    PB1_decel = 1.8;
    PB2_decel = 3.2;
    FFORT_decel = 5.0;
    headwayOffset = 1.0;
    timeMargin = 0.3;
end

%% Contrôleur de vitesse
if isfield(scenario, 'SpeedController')
    speedController = scenario.SpeedController;
    Kp_vitesse = speedController.Kp;
    Ki_vitesse = speedController.Ki;
    Amax = speedController.Amax;
    Amin = speedController.Amin;

    if isfield(speedController, 'Kd')
        Kd_vitesse = speedController.Kd;
    else
        Kd_vitesse = 0;
    end

    if isfield(speedController, 'FilterCoeff')
        FilterCoeff = speedController.FilterCoeff;
    else
        FilterCoeff = 0;
    end
else
    % Valeurs par défaut si SpeedController absent
    Kp_vitesse = 1.0;
    Ki_vitesse = 0.1;
    Amax = 3.0;
    Amin = -5.0;
    Kd_vitesse = 0;
    FilterCoeff = 0;
end

%% 🔹 Contrôleur de braquage
if isfield(scenario, 'DriverController')
    conduc = scenario.DriverController;
    Kp_braquage = conduc.Kp;
    Ki_braquage = conduc.Ki;
    yawErrGain  = conduc.yawErrGain;
else
    % Valeurs par défaut si DriverController absent
    Kp_braquage = 1.0;
    Ki_braquage = 0.1;
    yawErrGain  = 1.0;
end

%% 🔹 Affichage final
fprintf("\n✅ Scénario '%s' chargé avec succès !\n", scenario.NomScenario);
conducteurActive_var = Simulink.Parameter;
conducteurActive_var.Value = 1;  % Par défaut Off
conducteurActive_var.DataType = 'boolean'; 
conducteurActive_var.CoderInfo.StorageClass = 'ExportedGlobal';
%  Variable d'erreur système dynamique (modifiable en simulation)
if ~exist('erreurSysteme_var', 'var')
    erreurSysteme_var = Simulink.Signal;
    erreurSysteme_var.DataType = 'boolean';
    erreurSysteme_var.CoderInfo.StorageClass = 'SimulinkGlobal';
    erreurSysteme_var.InitialValue = '0'; % Valeur initiale
end

% Texte pour affichage
Pas_en_panne = "Pas en panne";
en_panne = "En panne";


if ~exist('commandeAEB', 'var')
   commandeAEB = Simulink.Signal;
    commandeAEB.DataType = 'boolean';
    commandeAEB.CoderInfo.StorageClass = 'SimulinkGlobal';
   commandeAEB.InitialValue = '0'; % Valeur initiale
end
if ~exist('inattentionConducteur', 'var')
   inattentionConducteur = Simulink.Signal;
    inattentionConducteur.DataType = 'boolean';
    inattentionConducteur.CoderInfo.StorageClass = 'SimulinkGlobal';
   inattentionConducteur.InitialValue = '0'; % Valeur initiale
end
if ~exist('Securite', 'var')
  Securite = Simulink.Signal;
    Securite.DataType = 'boolean';
    Securite.CoderInfo.StorageClass = 'SimulinkGlobal';
   Securite.InitialValue = '0'; % Valeur initiale
end