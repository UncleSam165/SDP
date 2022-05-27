function out = Deinterleaver(data ,rate)
%DEINTERLEAVER Summary of this function goes here
%   Detailed explanation goes here
RateTable = containers.Map({3, 4.5, 6, 9, 12, 18, 24, 27}, ...
    {48, 48, 96, 96, 192, 192, 288, 288});
N_CBPS = RateTable(rate);
data = reshape(data,N_CBPS,[]);
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

