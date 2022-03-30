function [allData, scenario, sensor] = first_scenario_vsec()
%first_scenario - Returns sensor detections
%    allData = first_scenario returns sensor detections in a structure
%    with time for an internally defined scenario and sensor suite.
%
%    [allData, scenario, sensors] = first_scenario optionally returns
%    the drivingScenario and detection generator objects.

% Generated by MATLAB(R) 9.11 (R2021b) and Automated Driving Toolbox 3.4 (R2021b).
% Generated on: 30-Mar-2022 17:19:39

% Create the drivingScenario object and ego car
[scenario, egoVehicle] = createDrivingScenario;

% Create all the sensors
sensor = createSensor(scenario);

allData = struct('Time', {}, 'ActorPoses', {}, 'ObjectDetections', {}, 'LaneDetections', {}, 'PointClouds', {}, 'INSMeasurements', {});
running = true;
while running

    % Generate the target poses of all actors relative to the ego vehicle
    poses = targetPoses(egoVehicle);
    time  = scenario.SimulationTime;

    % Generate detections for the sensor
    laneDetections = [];
    ptClouds = [];
    insMeas = [];
    [objectDetections, numObjects, isValidTime] = sensor(poses, time);
    objectDetections = objectDetections(1:numObjects);

    % Aggregate all detections into a structure for later use
    if isValidTime
        allData(end + 1) = struct( ...
            'Time',       scenario.SimulationTime, ...
            'ActorPoses', actorPoses(scenario), ...
            'ObjectDetections', {objectDetections}, ...
            'LaneDetections', {laneDetections}, ...
            'PointClouds',   {ptClouds}, ... %#ok<AGROW>
            'INSMeasurements',   {insMeas}); %#ok<AGROW>
    end

    % Advance the scenario one time step and exit the loop if the scenario is complete
    running = advance(scenario);
end

% Restart the driving scenario to return the actors to their initial positions.
restart(scenario);

% Release the sensor object so it can be used again.
release(sensor);

%%%%%%%%%%%%%%%%%%%%
% Helper functions %
%%%%%%%%%%%%%%%%%%%%

% Units used in createSensors and createDrivingScenario
% Distance/Position - meters
% Speed             - meters/second
% Angles            - degrees
% RCS Pattern       - dBsm

function sensor = createSensor(scenario)
% createSensors Returns all sensor objects to generate detections

% Assign into each sensor the physical and radar profiles for all actors
profiles = actorProfiles(scenario);
sensor = drivingRadarDataGenerator('SensorIndex', 1, ...
    'UpdateRate', 100, ...
    'MountingLocation', [3.7 0 0.2], ...
    'RangeLimits', [0 100], ...
    'HasNoise', false, ...
    'TargetReportFormat', 'Detections', ...
    'HasFalseAlarms', false, ...
    'Profiles', profiles);

function [scenario, egoVehicle] = createDrivingScenario
% createDrivingScenario Returns the drivingScenario defined in the Designer

% Construct a drivingScenario object.
scenario = drivingScenario;

% Add all road segments
roadCenters = [-9.9 0.2 0;
    -6.5 0.8 0;
    29.7 2.1 0;
    60.4 0.1 0];
laneSpecification = lanespec(3, 'Width', 6);
road(scenario, roadCenters, 'Lanes', laneSpecification, 'Name', 'Road');

% Add the ego vehicle
egoVehicle = vehicle(scenario, ...
    'ClassID', 1, ...
    'Position', [-7.65150491139326 0.785444180363085 0], ...
    'Mesh', driving.scenario.carMesh, ...
    'Name', 'Car');
waypoints = [-7.65150491139326 0.785444180363085 0;
    0.1 1.8 0;
    6.7 2.5 0;
    13 2.8 0;
    17.8 3.5 0;
    26.1 7.7 0;
    32.5 8.4 0;
    40.7 6.9 0;
    47.7 1.7 0;
    55.5 0.4 0;
    59.7 0.1 0];
speed = [10;20;20;10;5;10;10;10;10;10;10];
waittime = [0;0;0;0;0;0;0;0;0;0;0];
trajectory(egoVehicle, waypoints, speed, waittime);

% Add the non-ego actors
vehicle(scenario, ...
    'ClassID', 2, ...
    'Length', 8.2, ...
    'Width', 2.5, ...
    'Height', 3.5, ...
    'Position', [26.1 2.6 0], ...
    'Mesh', driving.scenario.truckMesh, ...
    'Name', 'Truck');

bicycle = actor(scenario, ...
    'ClassID', 3, ...
    'Length', 1.7, ...
    'Width', 0.45, ...
    'Height', 1.7, ...
    'Position', [47.2 6.8 0], ...
    'Mesh', driving.scenario.bicycleMesh, ...
    'Name', 'Bicycle');
waypoints = [47.2 6.8 0;
    51.8 6.6 0;
    55 6.2 0;
    59.9 5.7 0];
speed = [2;2;2;2];
waittime = [0;0;0;0];
trajectory(bicycle, waypoints, speed, waittime);

