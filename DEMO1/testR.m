MA_UNITDATA_indication_msg = MA_UNITDATA_indication(message) ;
DL_UNITDATA_indication_msg = DL_UNITDATA_indication(message) ;
WSMP_Message = WSMWaveShortMessage_indication(WSMP_Message) ;
commandStr = sprintf('python3 SAE/decode.py %s' , WSMP_Message.Data) ; % python or python3    
[status, commandOut] = system(commandStr);
if status==0
Msg = commandOut ;
end