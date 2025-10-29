function sed = task3_7(pts1, pts2, F)
    N = size(pts1, 1);
    sed = 0;
    for i = 1:N
        x1 = [pts1(i,:) 1]';  % homogeneous
        x2 = [pts2(i,:) 1]';

        l2 = F * x1;  % epipolar line in image 2
        l1 = F' * x2; % epipolar line in image 1

        d2 = (x2' * l2)^2 / (l2(1)^2 + l2(2)^2);
        d1 = (x1' * l1)^2 / (l1(1)^2 + l1(2)^2);

        sed = sed + d1 + d2;
    end
    sed = sed / N;
    fprintf('Mean symmetric epipolar distance: %g\n', sed);

end