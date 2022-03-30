function frame = addNoise(frame,SNR,m)
preamblePower = sum(abs(frame(2*80+1:4*80)).^2)/length(frame(2*80+1:4*80));
preamblenoise = sqrt(preamblePower/(2*SNR))*(randn(1,160)+1i*randn(1,160));
frame(2*80+1:4*80) = frame(2*80+1:4*80) + preamblenoise;

datapower = sum(abs(frame(5*80+1:end)).^2)/length(frame(5*80+1:end));
datanoise = sqrt(datapower/(2*SNR*m))*(randn(1,length(frame(5*80+1:end)))+1i*randn(1,length(frame(5*80+1:end))));
frame(5*80+1:end) = frame(5*80+1:end) + datanoise;
end 