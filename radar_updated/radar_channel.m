%%%% radar channel implementation
% a reference for the equation is in the paper(Delay and Doppler processing for mutli-target detection with IEEE 802.11 OFDM signaling)
clear;
clc;

% NumberOfTargets = randi(5);
NumberOfTargets = 4;
% distances = rand(1,NumberOfTargets)*80 +20;  % distances in meters
speeds = rand(1,NumberOfTargets,1)*50 - 25; % speed in meter/sec
RCS = rand(1,NumberOfTargets)*10 ; % Radar cross section of the targets
distances = [19.3775 72.6074 41.0392 54.9183];
% speeds = 0;
% RCS = 1;
c = physconst('lightSpeed');
fc = 1.745*10^9; % carrier frequency
df = 156.25 * 10^3; %frequency spacing 
dt = 0.1 * 10^-6; % sampling interval
fs = 1/dt; %sampling frequency (20 MHz)
deltaT = 0.4 *10^-3; % Observation time (means we take measurement every deltaT time)
lambda = freq2wavelen(fc,c); % Wavelength (m)
NumberofTimeSlots = 64; % number of time frames
NumberOfSubcarriers = 64;
% NumberOfTargets = length(distances) ;
TxPower = 10 * 10^-3; %power in watt

Nfftn = 1024;
Nfftm = 1024;
if length(distances) ~= length(speeds)
    error('please enter distances and speeds with same number of targets')
end

%%
% calculate delay from targets distances
delays = 2*distances./c;

% calculate doppler shift from targets speed
Fd = 2*fc*speeds./c;

%claculate power related to each target and time slot
% this equation for channel gain is from PHD thesis(OFDM radar algo. in mob. comm. networks) page 18
% the vector has the same number of elements as the number of targets
a =  sqrt(c*RCS./((4*pi)^3 * distances.^4 * fc.^2));  
% a = [1 1 1];
H = zeros(NumberOfSubcarriers,NumberofTimeSlots);
% get the equivelent channel estimate from all targets
% there is a similar eqn in the PHD thesis
for m = 1:NumberofTimeSlots
    for n = 1:NumberOfSubcarriers
        H(n,m) =  sum(a.* exp(-1i*2*pi*fc*delays) .* exp(-1i*2*pi*delays*df*n) .* exp(-1i*4*pi*(fc+df*n).*(speeds./c)*deltaT*m));
    end
end
%% periodogram claculation 
figure;
for num = 53:length(data(1,:))
H= normalize(data(:,num-52:num)); %vthis line is to normalize the power of the channel
Hout = fft(H,Nfftn,2);
Hout = ifft(Hout,Nfftm,1);
per = abs(Hout).^2/(Nfftn*Nfftm); % The division by the fft number down the scale by 10^-6!!

shifted_per = (circshift(per,Nfftn/2,2)).^2;

% shifted_per =per;
% shifted_per = 10*log10(shifted_per);

imagesc( linspace(((Nfftm/2-1)*c)/(2*fc*deltaT*Nfftm),-c/(4*fc*deltaT),Nfftm) , linspace(0,((Nfftn-1)*c)/(2*df*Nfftn),Nfftn) , shifted_per)
colorbar
xlabel('relative speed (m/s)');
ylabel('Distance (m)');
set(gca,'YDir','normal') 
pause(0.01);
end
%% Espirt 
 H = normalize(H); %vthis line is to normalize the power of the channel
Rxx = (1/NumberOfSubcarriers)*(H*H'); % from the thesis
[V,D] = eig(Rxx);
S = V(:,end-NumberOfTargets+1:end);
sI = [eye(NumberOfSubcarriers-1),zeros(NumberOfSubcarriers-1,1)];
s1 = sI*S;
sI2 = [zeros(NumberOfSubcarriers-1,1) , eye(NumberOfSubcarriers-1)];
s2 = sI2*S;
phi = inv(s2'*s2)*(s2'*s1);
[Vf , Df] = eig(phi);
estimatedDistances = (angle(Df*ones(NumberOfTargets,1))*c/(2*pi*2*df))';
% estimate velocities 
Rxx_v = (1\NumberofTimeSlots)*(H'*H);
[V_v D_v] = eig(Rxx_v);
S_v = V_v(:,end-NumberOfTargets+1:end);
sI_v = [eye(NumberOfSubcarriers-1),zeros(NumberOfSubcarriers-1,1)];
s1_v = sI_v*S_v;
sI2_v = [zeros(NumberOfSubcarriers-1,1) , eye(NumberOfSubcarriers-1)];
s2_v = sI2_v*S_v;
phi_v = inv(s2_v'*s2_v)*(s2_v'*s1_v);
[Vf_v , Df_v] = eig(phi_v);
estimatedVelocities = -(angle(Df_v*ones(NumberOfTargets,1))*c/(2*pi*15*2*df))';
% %% test ESPIRT
% [estimatedDistances, estimatedVelocities] = ESPIRT(H,NumberOfSubcarriers,NumberofTimeSlots,NumberOfTargets,df,c);
% %% results 
% % get the estimation error for one target at different SNRs
% sorted_distances = sort(distances);
% sorted_velocities = sort(speeds);
% sorted_est_distances = sort(estimatedDistances);
% sorted_est_velocities = sort(estimatedVelocities);
% for snr = 0:5:20
%     H_noisy = awgn(H,snr);
% end

% %% USRP data 
% 
% data_real = csvread("USRPdata_real.csv");
% data_real = data_real(:,[7:59]);
% data_real(:,27) = (data_real(:,26) + data_real(:,28))./2;
% data_imag = csvread("USRPdata_imag.csv");
% data_imag = data_imag(:,[7:59]);
% data_imag(:,27) = (data_imag(:,26) + data_imag(:,28))./2;
% 
% data =flip(transpose(data_real +j*data_imag),1);
% %% USRP ESPIRT
% lastdata = repmat(data(:,end),1,53);
% % lastdata = repmat(H(:,1),1,64);
% [estimatedDistances, estimatedVelocities] = ESPIRT(lastdata,53,53, 1,df,c);
% %% USRP Periodogram 
% [estimatedDistances_p , estimatedVelocities_p] = Periodogram_est(data(:,end-52:end),Nfftn,Nfftm,fc,deltaT,df,NumberOfTargets);