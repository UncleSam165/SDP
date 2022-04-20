function complex_symboles = demap_sig(recieved_fft)
    complex_symboles=zeros(size(recieved_fft)-[0,16]);
    
    complex_symboles(:,1:5)=    recieved_fft(:,39:43);
    complex_symboles(:,6:18)=   recieved_fft(:,45:57) ;
    complex_symboles(:,19:24)=  recieved_fft(:,59:64) ;
    complex_symboles(:,25:30)=  recieved_fft(:,2:7);
    complex_symboles(:,31:43)=  recieved_fft(:,9:21);
    complex_symboles(:,44:48)=  recieved_fft(:,23:27) ;
    
end