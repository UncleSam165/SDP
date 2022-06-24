 clear;
clc;

% NumberOfTargets = randi(5);
NumberOfTargets = 3;
% distances = rand(1,NumberOfTargets)*80 +20;  % distances in meters
speeds = rand(1,NumberOfTargets,1)*50 - 25; % speed in meter/sec
% RCS = rand(1,NumberOfTargets)*2 ; % Radar cross section of the targets
distances = [20 30 50];
% speeds = 0;
RCS = [1 20 40];
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
%% Periodogram
H = normalize(H);
Hout = fft(H,Nfftn,2);
Hout = ifft(Hout,Nfftm,1);
per = abs(Hout).^2/(Nfftn*Nfftm); % The division by the fft number down the scale by 10^-6!!

shifted_per = (circshift(per,Nfftn/2,2)).^2;

% shifted_per =per;
% shifted_per = 20*log10(shifted_per) + 30;

imagesc( linspace(((Nfftm/2-1)*c)/(2*fc*deltaT*Nfftm),-c/(4*fc*deltaT),Nfftm) , linspace(0,((150)*c)/(2*df*Nfftn),Nfftn) , shifted_per(2:150,:))
colormap jet
colorbar
xlabel('relative speed (m/s)');
ylabel('Distance (m)');
set(gca,'YDir','normal') 

