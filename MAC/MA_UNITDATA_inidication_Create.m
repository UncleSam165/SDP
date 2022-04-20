function ma_message = MA_UNITDATA_inidication_Create(SrcAddress, DestAddress, Data)
%MA_UNITDATA_INIDICATION Summary of this function goes here
%   Detailed explanation goes here
ma_message = struct();
ma_message.Source_address = SrcAddress;
ma_message.Destination_address = DestAddress;
% Routing Information
ma_message.Routing = 'null';
ma_message.Data = Data;
ma_message.ReceptionStatus = "Success";
ma_message.User_Priority = nan;
ma_message.Service_Class = 'StrictlyOrdered';
end

