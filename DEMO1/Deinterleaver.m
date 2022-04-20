function out = Deinterleaver(data ,N_CBPS)
%DEINTERLEAVER Summary of this function goes here
%   Detailed explanation goes here
N_BPSC = N_CBPS/48;
[~,c] = size(data);
s = max([N_BPSC/2 1]);
j = [1:N_CBPS];
i = s*floor((j-1)/s)+rem((j-1)+floor(16*(j-1)/N_CBPS),s)+1;
k = 16*(i-1)-(N_CBPS-1)*floor(16*(i-1)/N_CBPS)+1;
out = zeros(N_CBPS,c);
for z = 1 :N_CBPS
    out(k(z),:) = data(z,:);
end
end

