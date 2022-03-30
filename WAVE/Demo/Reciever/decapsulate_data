function WSMP_header = decapsulate_data(data)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
WSMP_header.Version  = hex2dec(data(1));
WSMP_header.PSID = hex2dec(data(2:3));
WSMP_header.Time_Slot = hex2dec(data(4));
WSMP_header.Length = hex2dec(data(5:6));
WSMP_header.Wsm_Data = data(7:end);

end
