function v = Split(b,mindim,fun)
k=size(b,3);
v(1:k)=true;
w=(512*512)/k;
sq=floor(sqrt(w)-2);
for i=1:k
   quadrgn=b(:,:,i);
    
    
    flag=feval(fun,quadrgn,sq);
    disp(size(quadrgn,1));
     
    if size(quadrgn,1)<=mindim || (~flag)
        v(i)=false;
        continue;
    end
   % disp(flag);
    
end
end