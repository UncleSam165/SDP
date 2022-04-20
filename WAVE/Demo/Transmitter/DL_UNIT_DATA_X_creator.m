% This function creates the DL-UNITDATAX.request message after getting
% needed parameters from the WSM request message

function message = DL_UNIT_DATA_X_creator(input_struct_message)
    % Source_address
    message.Source_address = MACAddress();  % This is a random hexdecimal representing 
    % the source address, but to get the sender's device Mac address I used
    % the attahed function MACAddress
    
    % destination address
    message.Destination_address = input_struct_message.Peer_MAC_Address; 
    
    %Creating the header to append before payload data
    %Creating the header version as a one byte with 4-bits reserve
    h_version = dec2hex(2);
    %Creating the header Timeslot appeneded in the header as a
    %one-byte---------------------------------------------
    h_time_slot = dec2hex(2);
    %Creating the header Length received from the application layer 
    h_length = dec2hex(input_struct_message.Length,2);
    %Creating the header psid received from the application layer
    h_psid = dec2hex(str2double(input_struct_message.Provider_Service_Identifier));

% 
%     reserved_bits_h_version = dec2bin(0,4);
%     h_version = [reserved_bits_h_version dec2bin(2,4)];
%     %Creating the header Timeslot appeneded in the header as a
%     %one-byte---------------------------------------------
%     h_time_slot = dec2bin(2,8);
%     %Creating the header Length received from the application layer 
%     h_length = dec2bin(input_struct_message.Length,16);
%     %Creating the header psid received from the application layer
%     h_psid = dec2bin(str2double(input_struct_message.Provider_Service_Identifier),8);
% 


    % data 

    payload = input_struct_message.Data;
    message.Data = [h_version h_psid h_time_slot h_length payload];
    
    % priority
    if (0 <= input_struct_message.User_Priority) && (input_struct_message.User_Priority <= 7) 
        message.User_Priority = input_struct_message.User_Priority;
    else
        message.User_Priority = nan ; %% out of range
    end
   
    % Channel Identifier 
    if (0 < input_struct_message.Channel_Identifier) && (input_struct_message.Channel_Identifier < 200) 
        message.Channel_Identifier = input_struct_message.Channel_Identifier;
    else
        message.Channel_Identifier = nan ; %% out of range
    end
    
    % TimeSlot
%     import TimeSlot_enum_datatype
  %  message.Time_Slot = TimeSlot_enum_datatype(input_struct_message.Time_Slot);
    
    % DataRate
    if (2 < input_struct_message.Data_Rate) && (input_struct_message.Data_Rate < 127) 
        message.Data_Rate = input_struct_message.Data_Rate;
    else
        message = Data_Rate ; %% out of range
    end
    
    % Transmitter Power level
    if (-128 < input_struct_message.Transmit_Power_Level) && (input_struct_message.Transmit_Power_Level < 127) 
        message.Transmit_Power_Level = input_struct_message.Transmit_Power_Level;
    else
        message.Transmit_Power_Level = nan ; %% out of range
    end
    
    % Channel Load
    message.Channel_Load = input_struct_message.Channel_Load;

    % Expiry Time
    if (0 < input_struct_message.Expiry_Time) && (input_struct_message.Expiry_Time < 2^64) 
        message.Expiry_Time = input_struct_message.Expiry_Time;
    else
        message.Expiry_Time = nan ; %% out of range
    end
    
end
