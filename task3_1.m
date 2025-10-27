function task3_1()
    % load the camera parameters into the file
    S1 = load("Project2DataFiles/Parameters_V1_1.mat")
    S2 = load("Project2DataFiles/Parameters_V2_1.mat")

     
    % Extract the camera structs from the files
    cam1 = [];
    f1 = fieldnames(S1);
    for i = 1:numel(f1)
        if isstruct(S1.(f1{i}))
            cam1 = S1.(f1{i});
            break;
        end
    end
    
    
    cam2 = [];
    f2 = fieldnames(S2);
    for i = 1:numel(f2)
        if isstruct(S2.(f2{i}))
            cam2 = S2.(f2{i});
            break;
        end
    end

    % look at the camera's fields
    fprintf('--- Camera 1: available fields ---\n'); disp(fieldnames(cam1));
    fprintf('--- Camera 2: available fields ---\n'); disp(fieldnames(cam2));

    % Extract the needed variables from cameras

    % Intrinsics
    K1 = cam1.Kmat;
    K2 = cam2.Kmat;

    % Rotations
    R1 = cam1.Rmat;
    R2 = cam2.Rmat;

    % Camera Centers
    C1 = cam1.position(:);
    C2 = cam2.position(:);

    % Check the size of each of the matrices
    fprintf('\n[K1 size] %s   [K2 size] %s\n', mat2str(size(K1)), mat2str(size(K2)));
    fprintf('[R1 size] %s   [R2 size] %s\n', mat2str(size(R1)), mat2str(size(R2)));
    fprintf('[C1 size] %s   [C2 size] %s\n', mat2str(size(C1)), mat2str(size(C2)));

    % make sure that the rotations are correct by making sure R R^T = I and det(R) = 1
    R1_orth_err = norm(R1*R1' - eye(3));
    R2_orth_err = norm(R2*R2' - eye(3));
    fprintf('\nR1 orthonormality error: %.3e   det(R1): %.6f\n', R1_orth_err, det(R1));
    fprintf('R2 orthonormality error: %.3e   det(R2): %.6f\n', R2_orth_err, det(R2));
    
    % build the projection matrix
    P1 = K1 * [R1, -R1*C1];
    P2 = K2 * [R2, -R2*C2];
    
    % Make sure that each camera center maps to a zero vector
    v1 = P1 * [C1;1];
    v2 = P2 * [C2;1];
    fprintf('\n||P1*[C1;1]||: %.3e   ||P2*[C2;1]||: %.3e\n', norm(v1), norm(v2));
    
    % Save the file    
    save('Project2DataFiles\camera_mats.mat','K1','R1','C1','P1','K2','R2','C2','P2');
    fprintf('\nSaved camera_mats.mat\n');