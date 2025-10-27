function task3_2()
    %load the data from previous part
    cam_mat = load("Project2DataFiles\camera_mats.mat")
    fprintf("\nCamera Matrices Loaded\n")


    % Extract the variables from the matrix
    K1 = cam_mat.K1; R1 = cam_mat.R1; C1 = cam_mat.C1; P1 = cam_mat.P1;
    K2 = cam_mat.K2; R2 = cam_mat.R2; C2 = cam_mat.C2; P2 = cam_mat.P2;

    % Load mocap 3D points
    mocapData = load('Project2DataFiles/mocapPoints3D.mat');
    X = mocapData.pts3D'; % Make sure that the matrix is Nx3

    %X = V'; % Make sure that the matrix is Nx3

    N = size(X,1);
    fprintf("Using %d mocap points\n",N)

    % Project the 3D points to each image
    Xh  = [X, ones(N,1)]';     % 4×N homogeneous
    x1h = P1 * Xh;             % 3×N
    x2h = P2 * Xh;             % 3×N
    x1  = (x1h(1:2,:) ./ x1h(3,:))';   % N×2 pixel coords
    x2  = (x2h(1:2,:) ./ x2h(3,:))';

    % Quick range checks
    mins1 = min(x1); maxs1 = max(x1);
    mins2 = min(x2); maxs2 = max(x2);
    fprintf('Image1 proj range: x=[%.1f, %.1f], y=[%.1f, %.1f]\n', mins1(1), maxs1(1), mins1(2), maxs1(2));
    fprintf('Image2 proj range: x=[%.1f, %.1f], y=[%.1f, %.1f]\n', mins2(1), maxs2(1), mins2(2), maxs2(2));

    % Load corrected images and overlay projections
    I1 = imread('Project2DataFiles/im1corrected.jpg');
    I2 = imread('Project2DataFiles/im2corrected.jpg');

    figure; imshow(I1); hold on;
    plot(x1(:,1), x1(:,2), 'r.', 'MarkerSize', 12);
    title('Projected mocap points on Image 1');
    figure(1);
    exportgraphics(gcf, 'Images\Image1_overlay.png', 'Resolution', 300);  % save Image 1 figure
    fprintf("Saved Image1_overlay.png\n");
    

    figure; imshow(I2); hold on;
    plot(x2(:,1), x2(:,2), 'g.', 'MarkerSize', 12);
    title('Projected mocap points on Image 2');
    exportgraphics(gcf, 'Images\Image2_overlay.png', 'Resolution', 300);  % save last (Image 2) figure
    fprintf("Saved Image2_overlay.png\n");

    % Save for next task
    save('Project2DataFiles\proj2D_points.mat', 'x1', 'x2', 'X');
    fprintf('Saved proj2D_points.mat (x1, x2, X)\n');
end

