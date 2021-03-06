clear;
clc;

% NumberOfTargets = randi(5);
NumberOfTargets = 1;
% distances = rand(1,NumberOfTargets)*80 +20;  % distances in meters
% speeds = rand(1,NumberOfTargets,1)*50 - 25; % speed in meter/sec
% RCS = rand(1,NumberOfTargets)*10 ; % Radar cross section of the targets
distances = 10;
speeds = 0;
RCS = 1;
c = physconst('lightSpeed');
fc = 1.745*10^9; % carrier frequency
df = 156.25 * 10^3*5; %frequency spacing 
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
%% USRP data 

data_real = csvread("USRPdata_real_foil_1.csv");
data_real = data_real(:,[7:59]);
data_real(:,27) = (data_real(:,26) + data_real(:,28))./2;
data_imag = csvread("USRPdata_real_foil_1.csv");
data_imag = data_imag(:,[7:59]);
data_imag(:,27) = (data_imag(:,26) + data_imag(:,28))./2;
data =flip(transpose(data_real +j*data_imag),1);
data(:,isnan(data(1,:))) = [];
%% USRP ESPIRT
est_dists = [];
esp_order = 2;
for num = 53:length(data(1,:)) 
% lastdata = normalize(data(:,num-52:num));
lastdata = data(:,num-52:num);
[estimatedDistances, estimatedVelocities] = ESPIRT(lastdata,53,53, esp_order,df,c);
est_dists = [est_dists estimatedDistances'];
% disp(estimatedDistances);
% pause(0.1);
end
est_dists(est_dists < 0) = 0;
est_dists = sort(est_dists,1);
figure;
subplot(esp_order,1,1);
plot(est_dists(1,:));
title("ESPIRT Estimation of the second target");
ylabel("Distance in m");
xlabel("Frame Number");
subplot(esp_order,1,2);
plot(est_dists(2,:));
title("ESPIRT Estimationof the first target");
ylabel("Distance in m");
xlabel("Frame Number");
% subplot(esp_order,1,3);
% plot(est_dists(3,:));
% title("ESPIRT Estimation");
% ylabel("Distance in m");
% xlabel("Frame Number");

% %% USRP ESPIRT
% lastdata = data(:,200:200+52);
% % lastdata = repmat(H(:,1),1,64);
% [estimatedDistances, estimatedVelocities] = ESPIRT(lastdata,53,53, 4,df,c);
% %% USRP Periodogram 
% [estimatedDistances_p , estimatedVelocities_p] = Periodogram_est(data(:,end-52:end),Nfftn,Nfftm,fc,deltaT,df,NumberOfTargets);
%% periodogram claculation 
figure;
for num = 53:length(data(1,:))
% H= normalize(data(:,num-52:num)); %vthis line is to normalize the power of the channel
H= data(:,num-52:num); %vthis line is to normalize the power of the channel
Hout = fft(H,Nfftn,2);
Hout = ifft(Hout,Nfftm,1);
per = abs(Hout).^2/(Nfftn*Nfftm); % The division by the fft number down the scale by 10^-6!!

shifted_per = (circshift(per,Nfftn/2,2)).^2;
% shifted_per = 10*log10(shifted_per);

% imagesc( linspace(((Nfftm/2-1)*c)/(2*fc*deltaT*Nfftm),-c/(4*fc*deltaT),Nfftm) , linspace(0,((Nfftn-1)*c)/(2*df*Nfftn),Nfftn) , shifted_per)
imagesc( linspace(((Nfftm/2-1)*c)/(2*fc*deltaT*Nfftm),-c/(4*fc*deltaT),Nfftm) , linspace(0,(150*c)/(2*df*Nfftn),Nfftn) , shifted_per(2:150,:));
colormap jet;
colorbar 
xlabel('relative speed (m/s)');
ylabel('Distance (m)');
set(gca,'YDir','normal') 
pause(0.01);
end