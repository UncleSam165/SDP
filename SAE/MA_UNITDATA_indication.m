% This function creates the MA-UNITDATAX.request message after getting
% needed parameters from the DL-UNITDATAX.request message

function LLC_message = MA_UNITDATA_indication(message)
    
    % Source_address
    LLC_message.Source_address = message.Source_address;  
    if strcmp(message.Destination_address, MACAddress()) || strcmp(message.Destination_address, 'FF:FF:FF:FF:FF:FF')
      
        LLC_message.Destination_address = message.Destination_address;
    else 
           error('Not destinated to the evice')

    end
    LLC_message.Routing = message.Routing;    
    % data
    LLC_message.Data = message.Data; 
    LLC_message.Reception_Status = 'Success';
    % priority
    if (0 < message.User_Priority) && (message.User_Priority < 7) 
        LLC_message.User_Priority = message.User_Priority;
    else
        LLC_message = nan ; %% out of range
    end

    % Service Class 
    LLC_message.Service_Class = message.Service_Class;

end