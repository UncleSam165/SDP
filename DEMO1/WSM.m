% Wsm Request 
% 
% 
% Channel Identifier : We will use Channel num 178 which is reserved solely for safety communications and is termed the control channel
% (CCH) . 
% Time Slot : (ENUM) 0,1,etc 
% Data Rate : Goes with the standard sugesstion to be
% Transmit Power Level : (INT) 2-127 
% Channel Load : (OCTET String) Channel Load is optionally included in the WSMP-N-Header for use by the WSM recipient to support
% sharing of relevant channel load information between devices .
% User Priority : (INT) From 0-->7
% Expiry Time : (INT) 1/data Rate 
% WSM Data : (OCTET String) Msg Data
% Peer MAC address : (MACADRESS) Broadcast Msg 
% Provider Service Identifier : (OCTET String) The PSID is an identifier used in WAVE standards , Each PSID value is associated
% with an organization that is authorized to describe the use of that PSID.For our application we use PSID = 0x87 (0p80-07) which associated with WAVE Service Advertisement
Data = '0f202af0af040af04af0424af02424af68';
Wsm_request = struct('Channel_Identifier' ,178 , ...
'Data_Rate' , 120 ,...
'Transmit_Power_Level' ,  0 , ...
'Channel_Load' , '0000' , ...
'Info_Elements_Indicator', '0000' , ...
'User_Priority' , 2 , ...
'Expiry_Time', 200 , ...
'Length' , length(Data), ...
'Data', Data , ...
'Peer_MAC_Address', 'FF:FF:FF:FF:FF:FF' , ... 
'Provider_Service_Identifier', '87' ) ;

%'Time_Slot' , 'either' , ...