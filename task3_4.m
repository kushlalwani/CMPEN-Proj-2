function task3_4()
    
    % Load Triangulation results
    triangulationData = load("Project2DataFiles/triangulation_results.mat");
    triangulationData = triangulationData.Xv_true;

    % Specify the 3D locations of 3 points on the floor
    floorPoints = triangulationData([32, 38, 39], :);

    % Specify the 3D locations of 3 points on the wall
    wallPoints = triangulationData([6, 9, 27], :);

    % Compute centroid
    floorCentroid = mean(floorPoints, 1);
    wallCentroid = mean(wallPoints, 1);

    % Compute vectors in the floor plane
    floorVectors = [
      floorPoints(1, :) - floorCentroid;
      floorPoints(2, :) - floorCentroid;
      floorPoints(3, :) - floorCentroid
    ];

    % Compute vectors in the wall plane
    wallVectors = [
      wallPoints(1, :) - wallCentroid;
      wallPoints(2, :) - wallCentroid;
      wallPoints(3, :) - wallCentroid
    ];

    % Compute the normal vector of the plane
    normalVector = cross(floorVectors(1, :), floorVectors(2, :));
    normalVectorW = cross(wallVectors(1, :), wallVectors(2, :));

    % Normalize normal vector
    normalVector = normalVector / norm(normalVector);
    normalVectorW = normalVectorW / norm(normalVectorW);
    
    % Compute the constant d
    d = -dot(normalVector, floorCentroid);
    dW = -dot(normalVectorW, wallCentroid);

    % Fit a 3D plane to the points
    floorPlane = [normalVector, d];
    wallPlane = [normalVectorW, dW];

    % Verify the floor plane is ~ Z=0
    % The floor plane has a normal vector of [0, 0, 1]
    % Check if the computed normal vector is ~ [0, 0, 1]
    angle = acosd(dot(normalVector, [0, 0, 1]));
    angleW = acosd(dot(normalVectorW, [1, 0, 0]));
    % Input eq & better validation
    fprintf('Computed Normal Vector Angle Difference from Vertical: %.3f degrees\n', angle);
    fprintf('Computed Normal Vector Angle Difference from Vertical: %.3f degrees\n', angleW);
    
    % Wall Plane Equation
    fprintf('Wall Plane equation: %.3f*X + %.3f*Y + %.3f*Z + %.3f = 0\n', ...
        normalVectorW(1,1), normalVectorW(1,2), normalVectorW(1,3), dW);



 
end
