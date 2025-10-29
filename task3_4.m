function task3_4()
    
    % Load Triangulation results
    triangulationData = load("Project2DataFiles/triangulation_results.mat");
    triangulationData = triangulationData.Xv_true;

    % Specify the 3D locations of 3 points on the floor
    floorPoints = triangulationData([32, 38, 39], :);

    % Specify the 3D locations of 3 points on the wall
    wallPoints = triangulationData([6, 9, 27], :);

    % Compute centroids
    floorCentroid = mean(floorPoints, 1);
    wallCentroid = mean(wallPoints, 1);

    % Subtract centroids from points
    floorVectors = floorPoints - floorCentroid;
    wallVectors = wallPoints - wallCentroid;

    % Derive orthonormal vectors
    [~, ~, fV] = svd(floorVectors, 0);
    [~, ~, wV] = svd(wallVectors, 0);

    % Derive normal vectors
    floorNormal = fV(:, 3);
    wallNormal = wV(:, 3);

    % Normalize
    floorNormal = floorNormal / norm(floorNormal);
    wallNormal = wallNormal / norm(wallNormal);

    % Compute constant d
    floord = -dot(floorNormal, floorCentroid);
    walld = -dot(wallNormal, wallCentroid);

    % Fit a 3D plane to the points
    floorPlane = [floorNormal', floord];
    wallPlane = [wallNormal', walld];

    % Display floor plane equation
    fprintf('Floor plane: %.3fx + %.3fy + %.3fz + %.3f = 0\n', floorPlane);

    % Verify the floor plane is ~ Z=0
    a = -floorPlane(1) / floorPlane(3);
    b = -floorPlane(2) / floorPlane(3);
    c = -floorPlane(4) / floorPlane(3);
    fprintf('Floor plane expressed as Z = %.3fx + %.3fy + %.3f\n', a, b, c);

    % While Z != 0, the normal vector is nearly [0,0,1]
    % Meaning the floor plane is nearly horizontal
    

 
end
