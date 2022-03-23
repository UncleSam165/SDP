# To run the encoding 
commandStr = 'python encode.py';
[status, commandOut] = system(commandStr);
if status==0 
Msg = commandOut ;
end


# To run the decoding
commandStr = sprintf('python decode.py %s' , Msg) ;
[status, commandOut] = system(commandStr);
if status==0
Msg = commandOut ;
end


