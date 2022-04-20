% This function creates the MA-UNITDATAX.request message after getting
% needed parameters from the DL-UNITDATAX.request message

function ma_message = MA_UNIT_DATA_X_creator(DL_message)
    
    % Source_address
    ma_message.SourceAddress = DL_message.Source_address;  % This is a random hexdecimal representing 
    % the source address, but to get the sender's device Mac address I used
    % the attahed function MACAddress
    
    % destination address
    ma_message.DestinationAddress = DL_message.Destination_address; 

    % Routing Information
    ma_message.Routing = 'null';
    
    % data
    ma_message.Data = DL_message.Data; 
    
    
    % priority
    if (0 < DL_message.User_Priority) && (DL_message.User_Priority < 7) 
        ma_message.User_Priority = DL_message.User_Priority;
    else
        ma_message = nan ; %% out of range
    end

    % Service Class 
    ma_message.Service_Class = 'StrictlyOrdered';
   
    % Channel Identifier 
    if (0 < DL_message.Channel_Identifier) && (DL_message.Channel_Identifier < 200) 
        ma_message.Channel_Identifier = DL_message.Channel_Identifier;
    else
        ma_message = nan ; %% out of range
    end
    
    %ma_message.Time_Slot = DL_message.Time_Slot;
    
    % DataRate
    if (2 < DL_message.Data_Rate) && (DL_message.Data_Rate < 127) 
        ma_message.Data_Rate = DL_message.Data_Rate;
    else
        ma_message = nan ; %% out of range
    end
    
    % Transmitter Power level
    if (-128 < DL_message.Transmit_Power_Level) && (DL_message.Transmit_Power_Level < 127) 
        ma_message.Transmit_Power_Level = DL_message.Transmit_Power_Level;
    else
        ma_message = nan ; %% out of range
    end
    
    % Channel Load
    ma_message.Channel_Load = DL_message.Channel_Load;

    % Expiry Time
    if (0 < DL_message.Expiry_Time) && (DL_message.Expiry_Time < (2^64)-1) 
        ma_message.Expiry_Time = DL_message.Expiry_Time;
    else
        ma_message = nan ; %% out of range
    end


%   struct_message = struct(SourceAddress,ma_message(1),DestinationAddress,ma_message(2),RoutingInformation,ma_message(3),Data,ma_message(4),Priority,ma_message(5),ServiceClass,ma_message(6),ChannelIdentifier,ma_message(7),TimeSlot,ma_message(8),DataRate,ma_message(9),TransmitterPowerLevel,ma_message(10),ExpiryTime,ma_message(12)) ;
end