function H = Generate_radar_channel(distances,speeds,RCS,fc,df,deltaT,NumberofTimeSlots,NumberOfSubcarriers)
% calculate delay from targets distances
c = physconst('lightSpeed');
delays = 2*distances./c;

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

end