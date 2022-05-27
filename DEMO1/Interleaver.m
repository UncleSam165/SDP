function out = Interleaver(data ,rate)
RateTable = containers.Map({3, 4.5, 6, 9, 12, 18, 24, 27}, ...
    {48, 48, 96, 96, 192, 192, 288, 288});
N_CBPS = RateTable(rate);
data = reshape(data,N_CBPS,[]);
N_BPSC = N_CBPS/48;
[~,c] = size(data);
s = max([N_BPSC/2 1]);
k = [1:N_CBPS];
i = (N_CBPS/16)*mod(k-1,16)+floor((k-1)/16)+1;
j = s*floor((i-1)/s) + mod(i-1+N_CBPS-floor(16*(i-1)/N_CBPS),s)+1;
out = zeros(N_CBPS,c);
for z = 1 :N_CBPS
    out(j(z),:) = data(z,:);
end
end