close all
clear all
clc

rng('shuffle');
% Set the incoming amplitude and frequency
%amplitude = 200e-6;
%amplitude = 0.005;
%amplitude = 0.05;
amplitude = 10e-6;
f = 2e6;

% Sampling frequency
Fs = 16e6;

% Max gain (76dB) and threshold that toggles overload signal
%max_gain = 6300;
threshold = 50e-3;

% Number of time points and time vector, using 128us requirement
N = 2048;
dT = 1/Fs;
t = 0:dT:(N-1)*dT;
tt = 1:N;
% Generate some white noise to add to the signal
noise_power = (1e-9)^2 * (Fs/2);
noise = sqrt(noise_power) * randn(1,N);


% Generate input signal with noise
vin = amplitude * sin(2*pi*f*t) + noise;
%vin = amplitude * sin(2*pi*f*t);

%Start with noise, jump to signal
vin = [noise(1:10), vin(1:N-10)];

% Keep track of gain setting at every timestep, start at the max
%gain = max_gain*ones(1,N);
gain = zeros(1,N);
%For personal viewing pleasure
gaindB = zeros(1,N);

% Initialize some signals
vin_amplified = zeros(1,N);
% Overload is not assessed during the post-adjustment delay time. Gain of
% -1 marks that period for an easier viewing experience
overload = ones(1,N) * -1;

% Gain of -1 for easier debugging
gain_array = ones(N,6) * -1;

% Initialize gain to 76dB
gain_array(1,:) = [1 0 0 1 1 0]; 

i = 1;
counter1 = 16; %Counter for envelope detection. 1 us
counter2 = 16; %Counter for delay. 1 us
indicator = 0; %Indicates whether or not overload was high at some point during the detection period.

for ii = 2:N
    %Start by copying over last gain settings
    gain_array(ii,:) = gain_array(ii-1,:);
    if i < 7
        if counter1 == 0
            %Envelope detection of 1 us complete
            if counter2 == 16
                %Adjust gain once
                switch indicator
                    case(1)
                        if isequal(gain_array(ii-1,:), [1 0 0 1 1 0])
                            %Weird special case
                            gain_array(ii,:) = [0 1 1 1 1 1];
                            i = 2;
                        else
                            %Turn down next most significant bit
                            gain_array(ii,i) = 0;
                            %Decrease bit count
                            i = i + 1;
                        end
                    case(0)
                        if isequal(gain_array(ii-1,:), [1 0 0 1 1 0])
                            %Do nothing; can't increase anymore
                        elseif isequal(gain_array(ii-1,:), [0 1 1 1 1 1])
                            gain_array(ii,:) = [1 0 0 0 1 1];
                            i = 5;
                        else
                            %Turn back last turned down value
                            gain_array(ii,i-1) = 1;
                            %Turn down current value
                            gain_array(ii,i) = 0;
                            %Decrease bit count
                            i = i + 1;
                        end
                    otherwise
                        warning('Wat.');
                end
            end
            %Wait for 1 us before resetting envelope detector
            if counter2 == 0
                indicator = 0;
                counter1 = 16;
                counter2 = 16;
            else
                counter2 = counter2 - 1;
            end
        else
            %Envelope detecting
            if vin_amplified(ii-1) > threshold
                overload(ii) = 1;
                indicator = 1;
            else
                overload(ii) = 0;
            end
            counter1 = counter1 - 1;
        end
    end
    
    % Calculate dB gain from binary gain array
    gaindB(ii) = 2*bi2de(gain_array(ii,:), 'left-msb');
    
    %Uncomment to give error
    error_range = 1;
    gaindB(ii) = gaindB(ii) - 0.5*error_range + rand(1)*error_range;
    
    % Calculate mag gain from db gain
    gain(ii) = db2mag(gaindB(ii));
    
    % Apply gain
    vin_amplified(ii) = gain(ii) * vin(ii);
end

%Plots
figure;subplot(411);
set(gca, 'Fontsize', 16)
plot(t(1,1:250), vin_amplified(1,1:250), '-o')
ylim([-0.08, 0.08])
title('Output Voltage after AGC')
xlabel('Time')
ylabel('Amplitude [V]')
grid on

subplot(412);
set(gca, 'Fontsize', 16)
plot(t(1,1:250), vin(1,1:250), '-o')
title('Input Voltage')
xlabel('Time')
ylabel('Amplitude [V]')
grid on

subplot(413);
set(gca, 'Fontsize', 16)
stairs(t(1,1:250), overload(1,1:250), '-o')
title('Overload Signal')
xlabel('Time')
ylabel('Status')
grid on

subplot(414);
set(gca, 'Fontsize', 16)
stairs(t(1,1:250), gaindB(1,1:250), '-o')
title('Gain Setting')
xlabel('Time')
ylabel('Gain dB')
grid on
