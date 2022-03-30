function per = Periodogram(H,Nfftn,Nfftm,fc,deltaT,df)
c = physconst('lightSpeed');
Hout = fft(H,Nfftn,2);
Hout = ifft(Hout,Nfftm,1);
per = abs(Hout).^2/(Nfftn*Nfftm); % The division by the fft number down the scale by 10^-6!!

shifted_per = circshift(per,Nfftn/2,2);
% shifted_per =per;
% shifted_per = 10*log10(shifted_per);
% figure;
% imagesc( linspace(((Nfftm/2-1)*c)/(2*fc*deltaT*Nfftm),-c/(4*fc*deltaT),Nfftm) , linspace(0,((Nfftn-1)*c)/(2*df*Nfftn),Nfftn) , shifted_per);
% colorbar
% xlabel('relative speed (m/s)');
% ylabel('Distance (m)');
% set(gca,'YDir','normal') 
end