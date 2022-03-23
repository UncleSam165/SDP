%This Function takes a WSM-req message from the application layer 
% as a struct datatype and store its compartments to be passed to another
% function to create the DL-UNITDATAX-req message for the logic link
% control sublayer
% I assuemed that , this function would receive a struct datatype and its
% only objective is to degrade it to its components to be able to use those
% individual values to construct the DL-UNITDATAX-req message.
function output = WSM_req_parser(input_struct_message)
    output(1) = input_struct_message.Channel_Identifier ;
    output(2) = input_struct_message.Time_Slot ;
    output(3) = input_struct_message.Data_Rate ;
    output(4) = input_struct_message.Transmit_Power_Level ;
    output(5) = input_struct_message.Channel_Load ;
    output(6) = input_struct_message.Info_Elements_Indicator ;
    output(7) = input_struct_message.User_Priority ;
    output(8) = input_struct_message.Expiry_Time ;
    output(9) = input_struct_message.Length ;
    output(10) = input_struct_message.Data ;
    output(11) = input_struct_message.Peer_MAC_Address ;
    output(12) = input_struct_message.Provider_Service_Identifier ;

end



