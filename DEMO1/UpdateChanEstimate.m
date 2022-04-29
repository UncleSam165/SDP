function UpdChanEstimate = UpdateChanEstimate(ChanEstimate, pilots, alpha)
%UPDATECHANESTIMATE Summary of this function goes here
%   Detailed explanation goes here
Hp_mean = mean(pilots);
pilots = [Hp_mean; pilots; Hp_mean];
H = interp(pilots,13,2,pi/14);
Hp = [H(9:9+25);H(9+27:61)];
UpdChanEstimate = (1-(1/alpha))*ChanEstimate + (1/alpha)*Hp;
end

