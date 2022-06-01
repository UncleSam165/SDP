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

tic
rate = 12;
SNR = 15;
runs = 1000;
results = zeros(runs,6);
index = 1;
for desired = [-20 -15 -14 -11 -10.5 -10]
for run = 1:runs



sig = createSignal(rate,length(MPDU));
PreScrData = prepare4Scrambling(Data1,rate);
Scrambler = comm.Scrambler(2,'1 + z^4 + z^7',[1 0 1 1 1 0 1],'ResetInputPort',true);
ScrData = Scrambler(PreScrData,1);
EncodedData1 = Encoder(ScrData, rate);
EncodedData = Interleaver(EncodedData1,rate);
MappedData = Mapper(EncodedData,rate);
MappedData = reshape(MappedData,48,[]);
Piloted = zeros(52,size(MappedData,2));
for i = 1:size(MappedData,2)
    Piloted(:,i) = insertPilots(MappedData(:,i),i);
end
T = ofdmmod(Piloted,64,16,[1:6 33 60:64].');

waveform = [pre;sig;T];

%%%%%%%%%%%%%%%%
%PowerCalculations
energy = waveform'*waveform;
power = 10*log10(energy/length(waveform));
gain = 10^((desired-power)/20);
waveformG = gain*waveform;
energyG = waveformG'*waveformG;
powerG = 10*log10(energyG/length(waveformG));


AWGNChan = comm.AWGNChannel('NoiseMethod','Signal to noise ratio (SNR)', ...
    'SNR',SNR, ...
    'SignalPower',0.1);

chan = comm.RayleighChannel('SampleRate',10e6, ...
    'PathDelays', 1e-9, ...
    'AveragePathGains',-24.9, ...
    'MaximumDopplerShift', 884, ...
    'DopplerSpectrum',doppler('Rounded'), ...
    'Visualization', 'Off');
waveformG = AWGNChan(waveformG);
nwaveformG = chan(waveformG);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% Channel Estimation & Equalization %%%%%%%%%%%%%%%%%%%%%%
LongSymbol = [1, 1, -1, -1, 1, 1, -1, 1, -1, 1, 1, 1, 1, 1, 1, -1, -1, 1,...
                  1, -1, 1, -1, 1, 1, 1, 1, 1, -1, -1, 1, 1, -1, 1, -1, 1,...
                  -1, -1, -1, -1, -1, 1, 1, -1, -1, 1, -1, 1, -1, 1, 1, 1, 1].';
RcvLong1 = ofdmdemod(nwaveformG(161:256),64,32,1,[1:6 33 64-4:64].');
RcvLong2 = ofdmdemod(nwaveformG(257:320),64,0,0,[1:6 33 64-4:64].');
ChanEstimate = mean([RcvLong1./LongSymbol,RcvLong2./LongSymbol],2);


%%%%%%%%%%%%%%%%%%%%%%%% PHY LAYER %%%%%%%%%%%%%%%%%%%%%%
[Rcvrate, Length, ChanEstimate] = decodeSignal(nwaveformG(322:322+80-1),0,ChanEstimate,SNR);

if (Rcvrate == -1 || Rcvrate~=rate || Length~=length(MPDU))
    BER = 0;
else
Databits = Demodulation(nwaveformG(402:end), Rcvrate, Length, 0, ChanEstimate, SNR);
Deinterleved = Deinterleaver(Databits,Rcvrate);
Deinterleved = reshape(Deinterleved,[],1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% Viterbi Decoder %%%%%%%%%%%%%%%%%%%%%%%%%
DecodedData = Decoder(Deinterleved,Rcvrate);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% Descrambler %%%%%%%%%%%%%%%%%%%%%%%%%%%
Descrambler = comm.Descrambler(2,'1 + z^4 + z^7',[1 0 1 1 1 0 1],'ResetInputPort',true);
Descrambled = Descrambler(DecodedData,1);
Descrambled = Descrambled(17:16+Length*8);
BER = sum(Descrambled == Data1)/length(Descrambled)*100;
results(run,index) = BER;
end
end
index = index +1;
end
toc 

PER = sum(results~=100,1)/10;
%%
figure
x = [-20 -15 -14 -11 -10.5 -10];
semilogx(x,PER,'Marker','*','LineWidth',1.5)
title('PER vs TxPwrLvl, Rate = 12 Mbps, SNR = 15 dB')
xlabel('TxPwrLvl (dB)')
ylabel('PER (%)')
%%
% close all;
% figure
% x = [10:5:30]';
% p = semilogx(x,PERvSNR(:,1),x,PERvSNR(:,2),x,PERvSNR(:,3),x,PERvSNR(:,4));
% p(1).LineWidth = 1.5;
% p(2).LineWidth = 1.5;
% p(3).LineWidth = 1.5;
% p(4).LineWidth = 1.5;
% p(1).Marker = '*';
% p(2).Marker = 'd';
% p(3).Marker = 's';
% p(4).Marker = '+';
% title('PER vs SNR, Max Tx Pwr, rates:3, 4.5, 6, 9 Mbps')
% xlabel('SNR (dB)')
% ylabel('PER (%)')
% legend('3 Mbps', '4.5 Mbps', '6 Mbps', '9 Mbps')
% figure
% p = semilogx(x,PERvSNR(:,5),x,PERvSNR(:,6),x,PERvSNR(:,7),x,PERvSNR(:,8));
% p(1).LineWidth = 1.5;
% p(2).LineWidth = 1.5;
% p(3).LineWidth = 1.5;
% p(4).LineWidth = 1.5;
% p(1).Marker = '*';
% p(2).Marker = 'd';
% p(3).Marker = 's';
% p(4).Marker = '+';
% title('PER vs SNR, Max Tx Pwr (20dBm), rates:12, 18, 24, 27 Mbps')
% xlabel('SNR (dB)')
% ylabel('PER (%)')
% legend('12 Mbps', '18 Mbps', '24 Mbps', '27 Mbps')