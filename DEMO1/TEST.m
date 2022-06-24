clc; clear; close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SAE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
commandStr = 'python3 SAE/encode.py';
[status, commandOut] = system(commandStr);
if status==0 
Msg = commandOut ;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% WSMP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Wsm_request = struct('Channel_Identifier' ,178 , ...
'Data_Rate' , 120 ,...
'Transmit_Power_Level' ,  0 , ...
'Channel_Load' , '0000' , ...
'Info_Elements_Indicator', '0000' , ...
'User_Priority' , 2 , ...
'Expiry_Time', 200 , ...
'Length' , length(Msg), ...
'Data', Msg , ...
'Peer_MAC_Address', 'FF:FF:FF:FF:FF:FF' , ... 
'Provider_Service_Identifier', '87' ) ;
DL_UNIT_DATA_X = DL_UNIT_DATA_X_creator(Wsm_request) ;
MA_UNIT_DATA_X = MA_UNIT_DATA_X_creator(DL_UNIT_DATA_X) ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MAC LAYER %%%%%%%%%%%%%%%%%%%%%%%%%%%%
MPDU = MACencapsulate('Data','Data', true, true, MA_UNIT_DATA_X);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PHY LAYER %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Data Reshaping
Data1 = uint8(bin2dec(reshape(dec2bin(hex2dec(MPDU)).',[],1)));

%Creating Preamble and Signal
pre = createPreamble();
sig = createSignal(18,length(MPDU));
PreScrData = prepare4Scrambling(Data1,144);
Scrambler = comm.Scrambler(2,'1 + z^4 + z^7',[1 0 1 1 1 0 1],'ResetInputPort',true);
ScrData = Scrambler(PreScrData,1);
EncodedData1 = convenc(ScrData,poly2trellis(7,[133 171]),[1 1 1 0 0 1]);
EncodedData = Interleaver(reshape(EncodedData1,192,[]),192);
MappedData = sqrt(1/10).*   conj(qammod(bin2dec(num2str(reshape(EncodedData,4,[]).')),16));
MappedData = reshape(MappedData,48,[]);
Piloted = zeros(52,size(MappedData,2));
for i = 1:size(MappedData,2)
    Piloted(:,i) = insertPilots(MappedData(:,i),i);
end
T = ofdmmod(Piloted,64,16,[1:6 33 60:64].');

waveform = [pre;sig;T];
figure
t = linspace(0,floor(length(waveform)/80),length(waveform));
subplot(2,1,1)
plot(t, real(waveform))
title('Real Part of the OFDM waveform')
subplot(2,1,2)
plot(t, imag(waveform))
title('Imaginary Part of the OFDM waveform')

%% radar channel
distances = [400 300 200] ;  % distances in meters
speeds = [-10 5 25]; % speed in meter/sec
RCS = [30 15 1]; % Radar cross section of the targets
c = physconst('lightSpeed');
fc = 5.9*10^9; % carrier frequency
df = 125 * 10^3; %frequency spacing
dt = 0.1 * 10^-6; % sampling interval
fs = 1/dt; %sampling frequency (20 MHz)
deltaT = 0.4 *10^-3; % Observation time (means we take measurement every deltaT time)
NumberofTimeSlots = 64; % number of time frames
NumberOfSubcarriers = 64;
Nfftn = 1024;
Nfftm = 1024;

RadarChannel = Generate_radar_channel(distances,speeds,RCS,fc,df,deltaT,NumberofTimeSlots,NumberOfSubcarriers);
RadarChannel = normalize(RadarChannel);
RadarChannel_time = ifft(RadarChannel);

% add the channel to the wavefrom
waveform_radar = zeros(length(waveform),NumberofTimeSlots);
for k = 1 : NumberofTimeSlots
    temp = conv(waveform,RadarChannel_time(:,k));
    waveform_radar(:,k) = temp(1:end-NumberOfSubcarriers+1);
end
%% Receiver
chan = zeros(52,NumberofTimeSlots);
for i = 1: NumberofTimeSlots
    [preamble, Data1] = extractPreamble(waveform_radar(:,i));

    %remove the cyclic prefix from the original and recieved signals
    longpre1 = round(ofdmdemod(pre(161:256),64,32,32,[1:6 33 64-4:64].')); % original preamble

    longpre1rx = round(ofdmdemod(preamble(161:256),64,32,32,[1:6 33 64-4:64].'),8); % received preamble
    longpre2rx = round(ofdmdemod(preamble(257:320),64,0,0,[1:6 33 64-4:64].'),8); % received preamble
    longprerx = (longpre2rx + longpre1rx)./2;

    %do channel estimation here
    chan(:,i) = longprerx ./longpre1;
    chan(:,i) = circshift(chan(:,i),52+16);
    chan(27,i) = (chan(26,i) + chan(28,i))/2;

end

%%%%%%%%%%%%%%%%%%%%%%%% PHY LAYER %%%%%%%%%%%%%%%%%%%%%%
[rate, length] = decodeSignal(sig,0);
Databits = Demodulation(T, rate, length, 0);
Deinterleved = Deinterleaver(reshape(Databits,192,[]),192);
Deinterleved = reshape(Deinterleved,[],1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% Viterbi Decoder %%%%%%%%%%%%%%%%%%%%%%%%%
trelli = poly2trellis(7,[133 171]);
ConstraintLength = log2(trelli.numStates) + 1;
coderate = 3/4;
tbdepth = 10*(ConstraintLength - 1);
DecodedData = vitdec(Deinterleved, trelli, tbdepth, 'trunc', 'hard',[1 1 1 0 0 1]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% Descrambler %%%%%%%%%%%%%%%%%%%%%%%%%%%
Descrambler = comm.Descrambler(2,'1 + z^4 + z^7',[1 0 1 1 1 0 1],'ResetInputPort',true);
Descrambled = Descrambler(DecodedData,1);
Descrambled = num2str(Descrambled);

MSDU = dec2hex(bin2dec(reshape(Descrambled,8,[])'),2);
MSDU = MSDU(3:2+length,:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% MAC LAYER  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[SrcAddress, DestAddress, RcvData] = MACDecapsulate(MSDU);
MA_MESSAGE = MA_UNITDATA_inidication_Create(SrcAddress, DestAddress, RcvData);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% LLC Layer %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MA_UNITDATA_indication_msg = MA_UNITDATA_indication(MA_MESSAGE) ;
%
DL_UNITDATA_indication_msg = DL_UNITDATA_indication(MA_UNITDATA_indication_msg) ;
%
WSMP_Message = WSMWaveShortMessage_indication(DL_UNITDATA_indication_msg) ;
%
commandStr = sprintf('python3 SAE/decode.py %s' , WSMP_Message.Data) ; % python or python3    
[status, commandOut] = system(commandStr);
if status==0
Msg2 = commandOut ;
end

if lower(WSMP_Message.Data) == Msg 
    disp('Recieved') ;
end
%%%%%%%%%%%%%%%%%%%%%%%%% WSMP Layer %%%%%%%%%%%%%%%%%%%%%%%%%%%%




shifted_per = Periodogram(chan,Nfftn,Nfftm,fc,deltaT,df);
shifted_per = circshift(shifted_per,Nfftn/2,2);
figure;
im = imagesc(linspace(((Nfftm/2-1)*c)/(2*fc*deltaT*Nfftm),-c/(4*fc*deltaT),Nfftm) , linspace(0,((Nfftn-1)*c)/(2*df*Nfftn),Nfftn) , shifted_per );
colorbar;
xlabel('relative speed (m/s)');
ylabel('Distance (m)');
set(gca,'YDir','normal');
