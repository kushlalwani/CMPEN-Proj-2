function task3_3()
    % load any required data from past tasks
    cam_mat = load("Project2DataFiles\camera_mats.mat");
    K1 = cam_mat.K1; R1 = cam_mat.R1; C1 = cam_mat.C1;
    K2 = cam_mat.K2; R2 = cam_mat.R2; C2 = cam_mat.C2;

    S = load('Project2DataFiles\proj2D_points.mat');
    x1 = S.x1; x2 = S.x2; X_true = S.X;
    N  = size(X_true,1);

    fprintf('starts wiht N=%d pairs of points\n',N)

    % Keep only the points that are visible in both images
    valid = all(isfinite(x1),2) & all(isfinite(x2),2);
    x1v = x1(valid,:);  x2v = x2(valid,:);  Xv_true = X_true(valid,:);
    Nv  = size(x1v,1);
    fprintf("Finite in both views: %d / %d\n", Nv, N);
    if Nv==0, error('No finite pairs to triangulate.'); end

    % Precompute inverses of intrinsics
    K1inv = inv(K1); K2inv = inv(K2);

    % Back-project pixels to unit rays in world coords
    d1 = zeros(Nv,3); d2 = zeros(Nv,3);
    for i = 1:Nv
        dc1 = K1inv * [x1v(i,1); x1v(i,2); 1];
        dw1 = R1' * dc1; d1(i,:) = (dw1 / norm(dw1)).';
        dc2 = K2inv * [x2v(i,1); x2v(i,2); 1];
        dw2 = R2' * dc2; d2(i,:) = (dw2 / norm(dw2)).';
    end
    
    % Closest points between L1(s)=C1+s d1 and L2(t)=C2+t d2
    X_rec = zeros(Nv,3);
    for i = 1:Nv
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
        X_rec(i,:) = ((p1 + p2) / 2).';
    end

    
    diffs = X_rec - Xv_true;
    mse   = mean(sum(diffs.^2, 2));
    rmse  = sqrt(mse);
    fprintf('MSE = %.6f (units^2), RMSE = %.6f (units)\n', mse, rmse);
    
    % Save results
    save('Project2DataFiles\triangulation_results.mat', 'X_rec', 'Xv_true', 'mse', 'rmse');
    fprintf("Saved triangulation_results.mat\n");

    % visualization of the 3d space
    figure;
    plot3(Xv_true(:,1), Xv_true(:,2), Xv_true(:,3), 'k.', 'MarkerSize', 10); hold on;
    plot3(X_rec(:,1),   X_rec(:,2),   X_rec(:,3),   'ro', 'MarkerSize', 4);
    grid on; axis equal;
    legend('Ground Truth','Triangulated','Location','best');
    title('Task 3.3: DLT Triangulation Results');

end