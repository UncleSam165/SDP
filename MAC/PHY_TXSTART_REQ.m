%% REPLYING WITH PHY.TXSTART.CONFIRMATION
function F = PHY_TXSTART_REQ(TX_VECTOR)
F = true;
end
function TX_STATUS = PHY_TXSTART_CFM(F)
    if F == true
        TX_STATUS = struct;
        TX_STATUS.TX_START_OF_FRAME_OFFSET = randi([0,2^32-1]);
    end
end