function [estimatedDistances,estimatedVelocities] = ESPIRT(H,NumberOfSubcarriers, NumberofTimeSlots,NumberOfTargets,df,c)
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
end