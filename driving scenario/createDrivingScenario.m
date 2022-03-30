function [scenario, egoVehicle] = createDrivingScenario()
% createDrivingScenario Returns the drivingScenario defined in the Designer

% Generated by MATLAB(R) 9.11 (R2021b) and Automated Driving Toolbox 3.4 (R2021b).
% Generated on: 23-Mar-2022 17:31:06

% Construct a drivingScenario object.
scenario = drivingScenario;

% Add all road segments
roadCenters = [0.5 0.4 0;
    150.3 0 0];
laneSpecification = lanespec(4);
road1 = road(scenario, roadCenters, 'Lanes', laneSpecification, 'Name', 'Road');

% Add the barriers
barrier(scenario, road1, 'RoadEdge', 'left', ...
    'ClassID', 5, ...
    'Width', 0.61, ...
    'Height', 0.81, ...
    'Mesh', driving.scenario.jerseyBarrierMesh, 'PlotColor', [0.65 0.65 0.65], 'Name', 'Jersey Barrier');

barrier(scenario, road1, 'RoadEdge', 'right', ...
    'ClassID', 6, ...
    'Width', 0.433, ...
    'Mesh', driving.scenario.guardrailMesh, 'PlotColor', [0.55 0.55 0.55], 'Name', 'Guardrail');

% Add the ego vehicle
egoVehicle = vehicle(scenario, ...
    'ClassID', 1, ...
    'Position', [1.68329932151828 2.34671650145639 0.01], ...
    'Mesh', driving.scenario.carMesh, ...
    'Name', 'Car');
waypoints = [1.68329932151828 2.28671650145639 0.01;
    7.48 2.21 0.01;
    13.14 2.71 0.01;
    21.19 4.76 0.01;
    27.19 5.37 0.01;
    33.85 5.32 0.01;
    41.6 4.71 0;
    54 2.61 0;
    70.9 2.01 0;
    149.3 2.01 0;
    149.4 2.01 0];
speed = [30;30;30;30;30;30;30;30;30;30;30];
trajectory(egoVehicle, waypoints, speed);

% Add the non-ego actors
vehicle(scenario, ...
    'ClassID', 2, ...
    'Length', 8.2, ...
    'Width', 2.5, ...
    'Height', 3.5, ...
    'Position', [25.8 -1.5 0], ...
    'Mesh', driving.scenario.truckMesh, ...
    'Name', 'Truck');

car1 = vehicle(scenario, ...
    'ClassID', 1, ...
    'Position', [21.9 2.1 0], ...
    'Mesh', driving.scenario.carMesh, ...
    'Name', 'Car1');
waypoints = [21.9 2.1 0;
    150.4 2.3 0;
    150.6 2.3 0];
speed = [10;10;10];
waittime = [0;0;0];
trajectory(car1, waypoints, speed, waittime);

bicycle = actor(scenario, ...
    'ClassID', 3, ...
    'Length', 1.7, ...
    'Width', 0.45, ...
    'Height', 1.7, ...
    'Position', [25 -5 0], ...
    'Mesh', driving.scenario.bicycleMesh, ...
    'Name', 'Bicycle');
waypoints = [25 -5 0;
    82.6 -4 0;
    120.6 -1.9 0;
    149.8 -1.9 0];
speed = [60;60;60;60];
trajectory(bicycle, waypoints, speed);

vehicle(scenario, ...
    'ClassID', 1, ...
    'Position', [47.9 5.89 0.01], ...
    'Mesh', driving.scenario.carMesh, ...
    'Name', 'Car2');

car3 = vehicle(scenario, ...
    'ClassID', 1, ...
    'Position', [43.62 -1.36 0.01], ...
    'Mesh', driving.scenario.carMesh, ...
    'Name', 'Car3');
waypoints = [43.62 -1.36 0.01;
    70.1 -1.4 0;
    114.7 -5.2 0;
    148.8 -5.2 0];
speed = [40;40;40;40];
trajectory(car3, waypoints, speed);

vehicle(scenario, ...
    'ClassID', 1, ...
    'Position', [64.2 5.6 0], ...
    'Mesh', driving.scenario.carMesh, ...
    'Name', 'Car4');

car5 = vehicle(scenario, ...
    'ClassID', 1, ...
    'Position', [89.2 2 0], ...
    'Mesh', driving.scenario.carMesh, ...
    'Name', 'Car5');
waypoints = [89.2 2 0;
    112.57 2.49 0.01;
    132.34 5.09 0.01;
    150.38 5.56 0;
    150.62 5.56 0];
speed = [10;10;10;10;10];
trajectory(car5, waypoints, speed);

