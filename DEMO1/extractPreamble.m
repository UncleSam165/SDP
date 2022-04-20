function [preamble, Data] = extractPreamble(waveform)
% there supposed to be matched filter her then do frequency and time
% synchoronization
% assume for now that synchoronization is done
preamble = waveform(1:321,1);
Data = waveform(401:end);
end
