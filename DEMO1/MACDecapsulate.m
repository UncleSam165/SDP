function [SrcAddress, DestAddress, Data] = MACDecapsulate(MPDU)
MyAddress = "ABC123ABC123";
generator = comm.CRCGenerator('Polynomial',...
    'z^32+ z^26+ z^23+ z^22+ z^16+ z^12+ z^11+ z^10+ z^8+ z^7+ z^5+ z^4 + z^2 + z + 1');
Bits = hex2poly(reshape(MPDU',1,[]))';
Checked = generator(Bits(1:end-32));
if(sum(Bits(end-31:end) == Checked(end-31:end)) == 32)
    DestAddress = reshape(MPDU(5:5+5,:)',1,[]);
    SrcAddress = reshape(MPDU(11:11+5,:)',1,[]);
    if (DestAddress == "FFFFFFFFFFFF" || DestAddress == MyAddress)
        Data = reshape(MPDU(25:end-4,:)',1,[]);
    end
end
end