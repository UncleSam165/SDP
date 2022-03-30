%% CREATE MAC HEADER
function MPDU = MACencapsulate(Type, Subtype, MoreFragments, Retry, Struct)
 version = '00';
 switch Type
     case 'Control'
        Type = '01';
     case 'Data'
        Type = '10';
     case 'Management'
        Type = '00';
     case 'Extension'
        Type = '11';
 end
 switch Subtype
     case 'Data'
         Subtype = '0000';
         %other cases may be added later
 end
 if (~(Type == "01" && Subtype == "0110"))
     if Type == "10"
        toDS = '0';
        fromDS = '0';

     elseif Type == "00"
     end
 end
 if MoreFragments
     MoreFragments = '1';
 else
     MoreFragments = '0';
 end
 if Retry
     Retry = '1';
 else
     Retry = '0';
 end
 PowerManagement = '0';
 MoreData = '0';
 Protected = '0';
 order = '0';
 % Concatinate Frame Control Fields 
 FrameControl = [version, Type, Subtype, toDS, fromDS, MoreFragments,...
     Retry, PowerManagement, MoreData, Protected, order];
 % reshape into hexadecimal
 FrameControl = reshape(dec2hex(bin2dec(FrameControl)),[],2)';

 %get addresses and shape them into hexa decimals
 Address1 = reshape(Struct.SourceAddress,2,[])';
 Address2 = reshape(Struct.DestinationAddress,2,[])';
 Address3 = reshape('FFFFFFFFFFFF',2,[])';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sequence Control Field
FragmentNumber = dec2hex(randi([0,2^4-1]),4);
SequenceNumber = dec2hex(randi([0,2^12-1]),12);
SequenceControlField = reshape([FragmentNumber, SequenceNumber],2,[])';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

MPDU = [FrameControl;Address1;Address2;Address3;SequenceControlField];

end

