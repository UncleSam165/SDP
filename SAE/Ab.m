commandStr = 'python F:\J2735-python\__init__.py';
[status, commandOut] = system(commandStr);
if status==0 
Msg = commandOut ;
end



commandStr = sprintf('python SAE_decode.py %s' , Msg) ;
[status, commandOut] = system(commandStr);
if status==0
Msg = commandOut ;
end


