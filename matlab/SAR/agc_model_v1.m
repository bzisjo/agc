close all
clear all
clc

% Set the incoming amplitude and frequency
amplitude = 200e-6;
f = 2e6;

% Sampling frequency
Fs = 16e6;

% Max gain (76dB) and threshold that toggles overload signal
max_gain = 6300;
threshold = 50e-3;

% Number of time points and time vector
N = 1e2;
dT = 1/Fs;
t = 0:dT:(N-1)*dT;

% Generate some white noise to add to the signal
noise_power = (1e-9)^2 * (Fs/2);
noise = sqrt(noise_power) * randn(1,N);

% Generate input signal with noise
vin = amplitude * sin(2*pi*f*t) + noise;

% Keep track of gain setting at every timestep, start at the max
gain = max_gain*ones(1,N);

% Initialize some signals
vin_amplified = zeros(1,N);
overload = zeros(1,N);

% Step through each timestep and adjust the gain
for ii = 5:N   
    
    % If the overload signal is high, cut gain in half
    if(vin_amplified(ii-1) > threshold)
        overload(ii) = 1;
        gain(ii) = gain(ii-1)/2;
        
    % If overload is not high, but it was in the last cycle, then increase gain by 1.5    
    elseif (overload(ii-1) == 1)
        overload(ii) = 0;
        gain(ii) = gain(ii-1)*1.5;
        
    % Otherwise don't do anything, keep the same gain
    else
        overload(ii) = 0;
        gain(ii) = gain(ii-1);
    end
    
    % Generate the output signal
    vin_amplified(ii) = gain(ii) * vin(ii);
    
end

% Plots
set(gca,'Fontsize',16)
plot(t,vin_amplified)
title('Output Voltage after AGC')
xlabel('Time')
ylabel('Amplitude [V]')
grid on

set(gca,'Fontsize',16)
figure
stairs(t,overload)
title('Overload Signal')
xlabel('Time')
ylabel('Amplitude [V]')
grid on

set(gca,'Fontsize',16)
figure
stairs(t,gain)
title('Gain Setting')
xlabel('Time')
ylabel('Gain [V/V]')
grid on



