function MACDecapsulate(MPDU)
Data = MPDU(25:end-32);
reshape(Data',1,[]);
end