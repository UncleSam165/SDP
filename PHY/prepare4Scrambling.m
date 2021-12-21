function out = prepare4Scrambling(Data,N_DBPS)
    Data = [zeros(16,1);Data;zeros(6,1)];
    Padding = (ceil(length(Data)/N_DBPS)*N_DBPS) - length(Data);
    out = [Data;zeros(Padding,1)];
end