function ma_message = MA_UNITDATA_inidication_Create(SrcAddress, DestAddress, Data)
%MA_UNITDATA_INIDICATION Summary of this function goes here
%   Detailed explanation goes here
ma_message = struct();
ma_message.Source_address = [SrcAddress(1:2) '-' SrcAddress(3:4) '-' SrcAddress(5:6) '-' SrcAddress(7:8) '-' SrcAddress(9:10) '-' SrcAddress(11:12) ];
ma_message.Destination_address = [DestAddress(1:2) '-' DestAddress(3:4) '-' DestAddress(5:6) '-' DestAddress(7:8) '-' DestAddress(9:10) '-' DestAddress(11:12)];
% Routing Information
ma_message.Routing = 'null';
ma_message.Data = Data(1:end-1);
ma_message.ReceptionStatus = "Success";
ma_message.User_Priority = nan;
ma_message.Service_Class = 'StrictlyOrdered';
end

