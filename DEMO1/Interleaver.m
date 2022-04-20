function out = Interleaver(data ,N_CBPS)
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