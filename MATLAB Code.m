clear all; close all; clc;

%Draw dispersion curves for the TE mode
v = 0:0.01:10; % Normalized frequency grid
b0 = [0 1]; % Initial interval for

for m = 0:6 % Mode number
    for n = 1:length(v); 
        if v(n) > m*pi/2
        Fun = @(x) v(n).*sqrt(1-x) - m*pi/2 - atan(sqrt(x/(1-x)));  % Find root of f(m,v,b)=0
        b(m+1,n) = fzero(Fun,b0);   % Find b for f(m,v,b)=0
        else
        b(m+1,n) = NaN;
        end
    end
end

% Plot dispersion curves
figure('position', [200 200 600 350]);
plot(v,b)
hold on; grid on; box on;
ylim([0 1])
xlim([0 10])
xticks([0:1:10])
yticks([0:0.1:1])
xlabel('Normalized frequency (v)')
ylabel('Normalized propagation constant (b)')
legend('m=0','m=1','m=2',...
'm=3','m=4','m=5','m=6','Location','bestoutside')
title('Dispersion curve')
set(gca,'FontSize',12,'FontName','Times')


%Draw representative electric field distributions
a = 100; % Core size, micrometer
A = 1; % Amplitude
n1 = 1.444; % Core refractive index
n0 = 1.440; % Cladding refractive index
lambda = 1.55; % Wavelength, micrometer
k0 = 2*pi/lambda; % Wavenumber, rad/micrometer
x = -50:0.1:50; % Spatial grid, x, micrometer

for m = 0:1:2; % Mode number
    vn = k0*a*sqrt(n1^2 - n0^2);     % The normalized frequency v is determined.
    Fun = @(x) vn.*sqrt(1-x) - m*pi/2 - atan(sqrt(x/(1-x)));    %Dispersion equation
    bn = fzero(Fun,b0);   % Find the normalized propagation constant b form the dispersion eq.
    ne = sqrt(bn*(n1^2 - n0^2) + n0^2);
    beta = ne*k0;
    K = sqrt(k0^2 * n1^2 - beta^2);  % The parameters 𝜅, 𝜎, and 𝜙 are determined.
    sigma = sqrt(beta^2 - k0^2 * n0^2);
    phi = m*pi/2;
% Calculate electric field distribution Ey(x)
    for n = 1:length(x)
        if x(n) > a
            Ey(m+1,n) = A*cos(K*a - phi) * exp(-sigma*(x(n)-a));
        elseif x(n) < -a
            Ey(m+1,n) = A*cos(K*a + phi) * exp(sigma*(x(n)+a));
        else
            Ey(m+1,n) = A*cos(K*x(n) - phi);
        end
    end
end

% Plot electric field distribution
figure('position', [800 200 500 350]);
plot(x,Ey)
hold on; grid on; box on;
% ylim([-1.2 1.2])
% xticks([-50:25:50])
xlabel('x [Mu]')
ylabel('E_y')
legend('m=0','m=1','m=2')
title("Electric field distribution | a = "+ a)
set(gca,'FontSize',12,'FontName','Times')