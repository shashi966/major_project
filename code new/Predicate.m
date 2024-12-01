function flag=Predicate(region,sq)
div=floor(sq/2);
r1=region(1:div,1:div);
r2=region(div+1:sq,1:div);
r3=region(1:div,div+1:sq);
r4=region(div+1:sq,div+1:sq);
count1(255)=0;
count2(255)=0;
count3(255)=0;
count4(255)=0;
count(255)=0;
for k=1:255
   for i=1:div
       for j=1:div
          
           if r1(i,j)==k
           count1(k)=count1(k)+1;
           end
           
           if r2(i,j)==k
           count2(k)=count2(k)+1;
           end
           
           if r3(i,j)==k
           count3(k)=count3(k)+1;
           end
           
           if r4(i,j)==k
           count4(k)=count4(k)+1;
           end
           
       end
   end
end




for k=1:255
   for i=1:sq
       for j=1:sq
          
           if region(i,j)==k
           count(k)=count(k)+1;
           end
           
       end
   end
end
C1=max(count1);
C2=max(count2);
C3=max(count3);
C4=max(count4);
C =max(count);


flag=((C1+C2+C3+C4)>C);
end