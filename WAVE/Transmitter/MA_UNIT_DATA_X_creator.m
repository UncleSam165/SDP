% This function creates the MA-UNITDATAX.request message after getting
% needed parameters from the DL-UNITDATAX.request message

function message = MA_UNIT_DATA_X_creator(DL_message)
    % Source_address
    message(1) = 0x001b638445e6;  % This is a random hexdecimal representing 
    % the source address, but to get the sender's device Mac address I used
    % the attahed function MACAddress
    
    % destination address
    message(2) = DL_message(2); 

    % Routing Information
    message(3) = null;
    
    % data
    message(4) = DL_message(3); % This shall be an octet string in
    % a format like the following (11 FA BB BA 00) with no specified range
    
    % priority
    if (0 < DL_message(7)) && (DL_message(7) < 7) 
        message(4) = DL_message(7);
    else
        message = nan ; %% out of range
    end
   
    % Channel Identifier 
    if (0 < DL_message(1)) && (DL_message(1) < 200) 
        message(5) = DL_message(1);
    else
        message = nan ; %% out of range
    end
    
    % TimeSlot
    import TimeSlot_enum_datatype
    message(6) = TimeSlot_enum_datatype(DL_message(2));
    
    % DataRate
    if (2 < DL_message(3)) && (DL_message(3) < 127) 
        message(7) = DL_message(3);
    else
        message = nan ; %% out of range
    end
    
    % Transmitter Power level
    if (-128 < DL_message(4)) && (DL_message(4) < 127) 
        message(8) = DL_message(3);
    else
        message = nan ; %% out of range
    end
    
    % Channel Load
    message(9) = DL_message(10);

    % Expiry Time
    if (0 < DL_message(8)) && (DL_message(8) < 2^64) 
        message(10) = DL_message(8);
    else
        message = nan ; %% out of range
    end
    
end