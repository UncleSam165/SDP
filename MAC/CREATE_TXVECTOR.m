function TX_VECTOR = CREATE_TXVECTOR(length, datarate, service, txPwrLvl, ToDReq, CH_BANDWIDTH_IN_NON_HT, DYN_BANDWIDTH_IN_NON_HT)
TX_VECTOR = struct;
if (length >= 1 && length <= 4095)
    TX_VECTOR.LENGTH = length;
end
rates = [3 4 5 6 9 12 18 24 27];
if (find(datarate == rates))
    TX_VECTOR.DATARATE = datarate;
end
TX_VECTOR.SERVICE = service;
if (length >= 1 && length <= 8)
    TX_VECTOR.TXPWR_LVL_INDEX = txPwrLvl;
end
TX_VECTOR.TIME_OF_DEPARTURE_REQUESTED = ToDReq;
TX_VECTOR.CH_BANDWIDTH_IN_NON_HT = CH_BANDWIDTH_IN_NON_HT;
TX_VECTOR.DYN_BANDWIDTH_IN_NON_HT = DYN_BANDWIDTH_IN_NON_HT;
end