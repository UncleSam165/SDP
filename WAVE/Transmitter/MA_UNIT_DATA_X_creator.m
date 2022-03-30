% This function creates the MA-UNITDATAX.request message after getting
% needed parameters from the DL-UNITDATAX.request message

function struct_message = MA_UNIT_DATA_X_creator(DL_message)
    
    ma_message = [];
    % Source_address
    ma_message(1) = 0x001b638445e6;  % This is a random hexdecimal representing 
    % the source address, but to get the sender's device Mac address I used
    % the attahed function MACAddress
    
    % destination address
    ma_message(2) = DL_message(2); 

    % Routing Information
    ma_message(3) = null;
    
    % data
    ma_message(4) = DL_message(3); 
    
    
    % priority
    if (0 < DL_message(7)) && (DL_message(7) < 7) 
        ma_message(5) = DL_message(7);
    else
        ma_message = nan ; %% out of range
    end

    % Service Class 
    ma_message(6) = 'StrictlyOrdered';
   
    % Channel Identifier 
    if (0 < DL_message(1)) && (DL_message(1) < 200) 
        ma_message(7) = DL_message(1);
    else
        ma_message = nan ; %% out of range
    end
    
    % TimeSlot
    import TimeSlot_enum_datatype
    ma_message(8) = TimeSlot_enum_datatype(DL_message(2));
    
    % DataRate
    if (2 < DL_message(3)) && (DL_message(3) < 127) 
        ma_message(9) = DL_message(3);
    else
        ma_message = nan ; %% out of range
    end
    
    % Transmitter Power level
    if (-128 < DL_message(4)) && (DL_message(4) < 127) 
        ma_message(10) = DL_message(3);
    else
        ma_message = nan ; %% out of range
    end
    
    % Channel Load
    ma_message(11) = DL_message(10);

    % Expiry Time
    if (0 < DL_message(8)) && (DL_message(8) < (2^64)-1) 
        ma_message(12) = DL_message(8);
    else
        ma_message = nan ; %% out of range
    end


   struct_message = struct(SourceAddress,ma_message(1),DestinationAddress,ma_message(2),RoutingInformation,ma_message(3),Data,ma_message(4),Priority,ma_message(5),ServiceClass,ma_message(6),ChannelIdentifier,ma_message(7),TimeSlot,ma_message(8),DataRate,ma_message(9),TransmitterPowerLevel,ma_message(10),ExpiryTime,ma_message(12)) ;
end