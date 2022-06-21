% 
% DLUNITDATA_indication = struct ('source_address', MAUNITDATA_Ind.SC_add, ...
% 'destination_address', MAUNITDATA_Ind.Dest_add , ...
% 'data',MAUNITDATA_Ind.data , ...
% 'priority' , MAUNITDATA_Ind.priority ) ; 
% The source_address ----> local LSAPs (Link Service Access Point)  involved in the data unit transfer.
% The destination address may be the address of a local LSAP
% The data parameter specifies the link service data unit that has been received by the LLC sublayer entity. 
% The priority parameter specifies the priority desired for the data unit transfer.


function WSMP_Message = DL_UNITDATA_indication(message)
    WSMP_Message.Source_address = message.Source_address;  
    WSMP_Message.Destination_address = message.Destination_address; 
    % data
    WSMP_Message.Data = message.Data; 
    if (0 < message.User_Priority) && (message.User_Priority < 7) 
        WSMP_Message.User_Priority = message.User_Priority;
    else
        WSMP_Message.User_Priority = nan ; %% out of range
    end
end
