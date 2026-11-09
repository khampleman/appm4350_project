clc; clear; close all;

pts = 200; % Check points in pts x pts grid

U = linspace(0.1, 3, pts); % Ship's velocity
g = 9.796; % Gravitational Acceleration (in Boulder, CO)
H = linspace(0.1, 3, pts); % Depths to test

% Define k as a sweeping array rather than a single scalar
k = linspace(0.1, 2000, 5000); 

% Pre-allocate an array to store the maximum wake angle for each depth
wake_angles = zeros(pts); 

for i = 1:pts
    for j = 1:pts
        Fr = U(j) / sqrt(g * H(i)); % Calculate Fr for current depth
        
        % Evaluate your formula using the k array and the current H(i)
        a = k*H(i)*Fr*Fr./tanh(k*H(i)) - 1;
        b = 1 + 2*k*H(i)./sinh(2*k*H(i));
        
        % Note: Some k values might make 'a' negative, resulting in imaginary numbers.
        % You only want to calculate y and x where a >= 0.
        valid = a >= 0;
        
        y = sqrt(a(valid)) .* b(valid);
        x = 2 + 2.*a(valid) - b(valid);
        
        xi = atan2(y, x); 
        
        % The actual wake angle is the maximum ray angle for this depth
        wake_angles(i, j) = max(xi) * (180/pi); % Storing in degrees
    end
end

% Plotting

figure;

% Create a filled contour plot with 100 color levels and no contour lines
contourf(U, H, wake_angles, 100, 'LineColor', 'none');

% Add and label the color bar
c = colorbar;
c.Label.String = 'Maximum Wake Angle (Degrees)';
c.Label.FontSize = 11;
c.Ticks = [19.47, 30:10:90];

% Format the plot
colormap('turbo'); % 'turbo' or 'parula' provide good contrast
xlabel('Ship Velocity, U (m/s)', 'FontWeight', 'bold');
ylabel('Water Depth, H (m)', 'FontWeight', 'bold');
title('Wake Angle as a Function of Velocity and Depth');
set(gca, 'FontSize', 12);