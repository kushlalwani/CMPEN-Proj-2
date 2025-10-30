function task3_5()

    % Load camera calibration information
    load('Project2DataFiles/camera_mats.mat');

    % Compute relative rotation between cameras
    R = R2 * R1';

    % Find location of camera 2 wrt camera 1
    T = R2 * (C1 - C2);
    S = [
      0, -T(3), T(2);
      T(3), 0, -T(1);
      -T(2), T(1), 0;
    ];

    % Compute the essential matrix
    E = S * R;

    % Compute the fundamental matrix
    F = inv(K2') * E * inv(K1);

    % Sanity check
    
    % Image 1 points
    points1 = [
        977, 934;
        337, 708;
        982, 723;
    ];

    % Image 2 points
    points2 = [
        1712, 697;
        932, 889;
        1131, 638;
    ];
    
    % Load images
    I1 = imread("/MATLAB Drive/Project2DataFiles/im1corrected.jpg");
    I2 = imread("/MATLAB Drive/Project2DataFiles/im2corrected.jpg");
    
    % Convert points to homogeneous
    points1H = [points1, ones(size(points1, 1), 1)]';
    points2H = [points2, ones(size(points2, 1), 1)]';

    % Compute epipolar lines
    lines1 = F' * points2H;
    lines2 = F  * points1H;

    % Normalize the lines for plotting
    lines1 = lines1 ./ sqrt(lines1(1, :).^2 + lines1(2, :).^2);
    lines2 = lines2 ./ sqrt(lines2(1, :).^2 + lines2(2, :).^2);

     % Plot epipolar lines on image 1
    figure; imshow(I1); hold on; title('Epipolar lines in Image 1');
    plot(points1(:,1), points1(:,2), 'go', 'MarkerSize', 8, 'LineWidth', 2);
    x = [1, size(I1,2)];
    for i = 1:size(lines1, 2)
        y = -(lines1(1,i)*x + lines1(3,i)) / lines1(2,i);
        plot(x, y, 'r-', 'LineWidth', 1);
    end

    % Plot epipolar lines on image 2
    figure; imshow(I2); hold on; title('Epipolar lines in Image 2');
    plot(points2(:,1), points2(:,2), 'go', 'MarkerSize', 8, 'LineWidth', 2);
    x = [1, size(I2,2)];
    for i = 1:size(lines2, 2)
        y = -(lines2(1,i)*x + lines2(3,i)) / lines2(2,i);
        plot(x, y, 'r-', 'LineWidth', 1);
    end

end