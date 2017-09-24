close all
clear all
clc

rng('shuffle');

% Set the incoming amplitude and frequency
%amplitude = 200e-6;
%amplitude = 0.005;
amplitude = 0.01;
f = 2e6;

% Sampling frequency
Fs = 16e6;

% Max gain (76dB) and threshold that toggles overload signal
%max_gain = 6300;
threshold = 50e-3;

% Number of time points and time vector, ambitiously using BLE standard
N = 128;
dT = 1/Fs;
t = 0:dT:(N-1)*dT;
tt = 1:N;
% Generate some white noise to add to the signal
noise_power = (1e-9)^2 * (Fs/2);
noise = sqrt(noise_power) * randn(1,N);


% Generate input signal with noise
vin = amplitude * sin(2*pi*f*t) + noise;
%vin = amplitude * sin(2*pi*f*t);

vin = [noise(1:N/8), vin(1:7*N/8)];

% Keep track of gain setting at every timestep, start at the max
%gain = max_gain*ones(1,N);
gain = zeros(1,N);

% Initialize some signals
vin_amplified = zeros(1,N);
overload = zeros(1,N);

gain_array = zeros(N,6);
gain_array(1,:) = [1 0 0 1 1 0];
gain_array(2,:) = [1 0 0 1 1 0];
gain_array(3,:) = [1 0 0 1 1 0];
gain_array(4,:) = [1 0 0 1 1 0];
gain_array(5,:) = [1 0 0 1 1 0];

i = 1;
counter = 16;

for ii = 5:N
    if i < 7
        if vin_amplified(ii-1) > threshold
            overload(ii) = 1;
        else
            overload(ii) = 0;
        end
        
        switch overload(ii)
            case(1)
                if isequal(gain_array(ii-1,:), [1 0 0 1 1 0])
                    %Weird special case
                    gain_array(ii,:) = [0 1 1 1 1 1];
                    i = 2;
                else
                    %Copy over last gain settings
                    gain_array(ii,:) = gain_array(ii-1,:);
                    %Turn down next most significant bit
                    gain_array(ii,i) = 0;
                    %Decrease bit count
                    i = i + 1;
                end
                %counter = 6;
            case(0)
                if (overload(ii-1) == 1 || overload(ii-2) == 1 || counter == 0)
                    if isequal(gain_array(ii-1,:), [0 1 1 1 1 1])
                        gain_array(ii,:) = [1 0 0 0 1 1];
                        i = 5;
                    else
                        %Copy over last gain settings
                        gain_array(ii,:) = gain_array(ii-1,:);
                        %Turn back last turned down value
                        gain_array(ii,i-1) = 1;
                        %Turn down current value
                        gain_array(ii,i) = 0;
                        %Decrease bit count
                        i = i + 1;
                    end
                    %counter = 6;
                else
                    %counter = counter - 1;
                    gain_array(ii,:) = gain_array(ii-1,:);
                end
            otherwise
                warning('Wat.');
        end
        decimal_gain = 2*bi2de(gain_array(ii,:),'left-msb');
        %Enable following 2 lines to give error margins to dB gain
        %error_range = 1;
        %decimal_gain = decimal_gain - error_range + rand(1) * (2 * error_range);
        
        gain(ii) = db2mag(decimal_gain);
    else
        %This doesn't contribute, just makes sure the entire vector is
        %filled
        gain(ii) = gain(ii-1);
    end
    vin_amplified(ii) = gain(ii) * vin(ii);
end

%Plots
figure;subplot(411);
set(gca, 'Fontsize', 16)
plot(t, vin_amplified, '-o')
ylim([-0.5, 0.5])
title('Output Voltage after AGC')
xlabel('Time')
ylabel('Amplitude [V]')
grid on

subplot(412);
set(gca, 'Fontsize', 16)
plot(t, vin, '-o')
title('Input Voltage')
xlabel('Time')
ylabel('Amplitude [V]')
grid on

subplot(413);
set(gca, 'Fontsize', 16)
stairs(t, overload, '-o')
title('Overload Signal')
xlabel('Time')
ylabel('Status')
grid on

subplot(414);
set(gca, 'Fontsize', 16)
stairs(t, gain, '-o')
title('Gain Setting')
xlabel('Time')
ylabel('Gain [V/V]')
grid on
