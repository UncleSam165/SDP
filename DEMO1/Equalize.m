function out = Equalize(in, ChanEstimate)
%EQUALIZE Summary of this function goes here
%   Detailed explanation goes here
ChanEstimate = [ChanEstimate(1:5);ChanEstimate(7:19);ChanEstimate(21:32);ChanEstimate(34:46);ChanEstimate(48:end)];
out = in./ChanEstimate;
end

