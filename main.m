clc; clear; close all;
U = 2.23; % Ship's velocity
g = 9.796; % Gravitational Acceleration (in Boulder, CO)
H = [1, 2, 3, 4, 5]; % Depths to test

% Define k as a sweeping array rather than a single scalar
k = linspace(0.1, 50, 2000); 

% Pre-allocate an array to store the maximum wake angle for each depth
wake_angles = zeros(size(H)); 

for i = 1:length(H)
    Fr = U / sqrt(g * H(i)); % Calculate Fr for current depth
    
    % Evaluate your formula using the k array and the current H(i)
    a = k.*H(i).*Fr.*Fr./tanh(k.*H(i)) - 1;
    b = 1 + 2.*k.*H(i)./sinh(2.*k.*H(i));
    
    % Note: Some k values might make 'a' negative, resulting in imaginary numbers.
    % You only want to calculate y and x where a >= 0.
    valid = a >= 0;
    
    y = sqrt(a(valid)) .* b(valid);
    x = 2 + 2.*a(valid) - b(valid);
    
    xi = atan2(y, x); 
    
    % The actual wake angle is the maximum ray angle for this depth
    wake_angles(i) = max(xi) * (180/pi); % Storing in degrees
end

disp('Wake Angles (degrees) for each depth:');
disp(wake_angles);