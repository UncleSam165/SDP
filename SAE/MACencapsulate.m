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
  FrameControl = dec2hex(bin2dec(FrameControl));

 %get addresses and shape them into hexa decimals
 Address1 = Struct.DestinationAddress;
 Address2 = Struct.SourceAddress;
 Address3 = 'FFFFFFFFFFFF';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sequence Control Field
FragmentNumber = dec2hex(randi([0,2^4-1]));
SequenceNumber = dec2hex(randi([0,2^12-1]));
SequenceControlField = reshape([FragmentNumber, SequenceNumber],2,[])';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Data = Struct.Data;
generator = comm.CRCGenerator('Polynomial',...
    'z^32+ z^26+ z^23+ z^22+ z^16+ z^12+ z^11+ z^10+ z^8+ z^7+ z^5+ z^4 + z^2 + z + 1');
ID = randi([0 1],[1,16]);
MPDU = hex2poly([FrameControl, ID, Address1, Address2, Address3, SequenceControlField, Data]);
MPDU = [zeros(rem(length(MPDU),4),1) MPDU];
MPDU = generator(MPDU);
MPDU = dec2hex(bin2dec(reshape(dec2bin(MPDU),8,[])'));

end
