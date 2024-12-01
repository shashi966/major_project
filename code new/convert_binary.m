function str=convert_binary(abc)
fid = fopen('kk.bin', 'w');
fwrite(fid,abc);
fclose(fid);

% Read the contents back into an array
fid = fopen('kk.bin');
m5 = fread(fid);
fclose(fid);
str=dec2bin(m5);
%s=char(m5');
%disp(s);
end