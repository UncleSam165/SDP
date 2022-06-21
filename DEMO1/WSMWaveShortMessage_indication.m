function WSMP_Message = WSMWaveShortMessage_indication(Message)

WSMP_header = decapsulate_data(Message.Data) ;
WSMP_Message.Version = WSMP_header.Version ;
WSMP_Message.User_Priority = Message.User_Priority ;
WSMP_Message.Length = WSMP_header.Length ;
WSMP_Message.Data = WSMP_header.Wsm_Data ;
WSMP_Message.Data(end) = newline;
WSMP_Message.Peer_MAC_Address = Message.Source_address ;
WSMP_Message.PSID = WSMP_header.PSID ;

end
