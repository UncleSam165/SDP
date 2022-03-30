% This function creates the DL-UNITDATAX.request message after getting
% needed parameters from the WSM request message

function message = DL_UNIT_DATA_X_creator(parsed_wsm_message)
    % Source_address
    message(1) = 0x001b638445e6;  % This is a random hexdecimal representing 
    % the source address, but to get the sender's device Mac address I used
    % the attahed function MACAddress
    
    % destination address
    message(2) = parsed_wsm_message(11); 
    
    %Creating the header to append before payload data
    %Creating the header version as a one byte with 4-bits reserved
    reserved_bits_h_version = dec2bin(0,4);
    h_version = [dec2bin(2,4) reserved_bits_h_version];
    %Creating the header Timeslot appeneded in the header as a one-byte
    h_time_slot = dec2bin(str2double(parsed_wsm_message(2));
    %Creating the header Length received from the application layer 
    h_length = dec2bin(parsed_wsm_message(9));
    %Creating the header psid received from the application layer
    h_psid = dec2bin(str2double(parsed_wsm_message(12)));

    % data 

    payload = dec2bin(str2double(parsed_wsm_message(10)));
    message(3) = [h_version h_psid h_time_slot h_length payload];
    
    % priority
    if (0 < parsed_wsm_message(7)) && (parsed_wsm_message(7) < 7) 
        message(4) = parsed_wsm_message(7);
    else
        message = nan ; %% out of range
    end
   
    % Channel Identifier 
    if (0 < parsed_wsm_message(1)) && (parsed_wsm_message(1) < 200) 
        message(5) = parsed_wsm_message(1);
    else
        message = nan ; %% out of range
    end
    
    % TimeSlot
    import TimeSlot_enum_datatype
    message(6) = TimeSlot_enum_datatype(parsed_wsm_message(2));
    
    % DataRate
    if (2 < parsed_wsm_message(3)) && (parsed_wsm_message(3) < 127) 
        message(7) = parsed_wsm_message(3);
    else
        message = nan ; %% out of range
    end
    
    % Transmitter Power level
    if (-128 < parsed_wsm_message(4)) && (parsed_wsm_message(4) < 127) 
        message(8) = parsed_wsm_message(3);
    else
        message = nan ; %% out of range
    end
    
    % Channel Load
    message(9) = parsed_wsm_message(10);

    % Expiry Time
    if (0 < parsed_wsm_message(8)) && (parsed_wsm_message(8) < 2^64) 
        message(10) = parsed_wsm_message(8);
    else
        message = nan ; %% out of range
    end
    
end