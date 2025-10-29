function task3_4()
    
    % Load camera matrix
    cam_mat = load('/MATLAB Drive/Project2DataFiles/camera_mats.mat');
    K1 = cam_mat.K1; R1 = cam_mat.R1; C1 = cam_mat.C1;
    K2 = cam_mat.K2; R2 = cam_mat.R2; C2 = cam_mat.C2;

    % Precompute inverses of intrinsics
    K1inv = inv(K1); K2inv = inv(K2);

    % Measure floor points from Image 1
    floorPoints1 = [
        977, 934; % Yellow tape intersection R
        337, 708; % Yellow tape intersection L
        982, 723; % Floor line
    ];

    % Measure floor points from Image 2
    floorPoints2 = [
        1712, 697; % Yellow tape intersection R
        932, 889; % Yellow tape intersection L
        1131, 638; % Floor line
    ];

    % Measure wall points from Image 1
    wallPoints1 = [
        1430, 219; % Paint corner 1
        1066, 215; % Paint corner 3
        1609, 116; % Paint corner 2
    ];

    % Measure wall points from Image 2
    wallPoints2 = [
        612, 109; % Paint corner 1
        86, 66; % Paint corner 3
        768, 30; % Paint corner 2
    ];

    % Back-project Wall pixels to unit rays in world coords
    d1F = zeros(3,3); d2F = zeros(3,3);
    for i = 1:3
        dc1F = K1inv * [floorPoints1(i,1); floorPoints1(i,2); 1];
        dw1F = R1' * dc1F; d1F(i,:) = (dw1F / norm(dw1F)).';
        dc2F = K2inv * [floorPoints2(i,1); floorPoints2(i,2); 1];
        dw2F = R2' * dc2F; d2F(i,:) = (dw2F / norm(dw2F)).';
    end

    % Closest points between L1(s)=C1+s d1 and L2(t)=C2+t d2
    floorX = zeros(3,3);
    for i = 1:3
        di = d1F(i,:); dj = d2F(i,:);
        a = 1; b = dot(di,dj); c = 1; 
        r = C1 - C2; d = dot(di, r); e = dot(dj, r);
        denom = a*c - b*b; 
    
        if abs(denom) < 1e-12   % nearly parallel rays
            s = 0;
            t = e / c;
        else
            s = (b*e - c*d) / denom;
            t = (a*e - b*d) / denom;
        end
    
        p1 = C1 + s * di';
        p2 = C2 + t * dj';
        floorX(i,:) = ((p1 + p2) / 2).';
    end

    % Back-project Wall pixels to unit rays in world coords
    d1 = zeros(3,3); d2 = zeros(3,3);
    for i = 1:3
        dc1 = K1inv * [wallPoints1(i,1); wallPoints1(i,2); 1];
        dw1 = R1' * dc1; d1(i,:) = (dw1 / norm(dw1)).';
        dc2 = K2inv * [wallPoints2(i,1); wallPoints2(i,2); 1];
        dw2 = R2' * dc2; d2(i,:) = (dw2 / norm(dw2)).';
    end

    % Closest points between L1(s)=C1+s d1 and L2(t)=C2+t d2
    wallX = zeros(3,3);
    for i = 1:3
        di = d1(i,:); dj = d2(i,:);
        a = 1; b = dot(di,dj); c = 1; 
        r = C1 - C2; d = dot(di, r); e = dot(dj, r);
        denom = a*c - b*b; 
    
        if abs(denom) < 1e-12   % nearly parallel rays
            s = 0;
            t = e / c;
        else
            s = (b*e - c*d) / denom;
            t = (a*e - b*d) / denom;
        end
    
        p1 = C1 + s * di';
        p2 = C2 + t * dj';
        wallX(i,:) = ((p1 + p2) / 2).';
    end

    % Derive floor points from floorX values
    floorPoints = [
        -1611.5, 1960.9, 4.9;
        2246.5, 1971.7, -36;
        -23.7, 19.6, 2.8;
    ];

    % Derive wall points from wallX values
    wallPoints = [
        482, -5562, 2715;
        3788, -5539, 2756;
        -742, -5535, 3380;
    ];

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
    fprintf('\nFloor plane: %.3fx + %.3fy + %.3fz + %.3f = 0\n', floorPlane);

    % Verify the floor plane is ~ Z=0
    a = -floorPlane(1) / floorPlane(3);
    b = -floorPlane(2) / floorPlane(3);
    c = -floorPlane(4) / floorPlane(3);
    fprintf('Floor plane expressed as Z = %.3fx + %.3fy + %.3f\n', a, b, c);

    % Compute angle between floor plane and [0,0,1]
    angle = acos(dot(floorNormal, [0, 0, 1]));
    angle = rad2deg(angle);
    fprintf('Angle between floor plane and Z-axis is %.3f degrees\n\n', angle);

    % Display wall plane equation
    fprintf('Wall plane: %.3fx + %.3fy + %.3fz + %.3f = 0\n', wallPlane);
    
    %%% How tall is the doorway? %%%

end
