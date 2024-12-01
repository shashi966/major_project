function signature = RSA_AES(U, V, key)


Usum = sum(U);
Vsum = sum(V);

Usum_threshold = median(Usum);  
Vsum_threshold = median(Vsum);

Usum(find(Usum > Usum_threshold)) = 1;
Usum(find(Usum < Usum_threshold)) = 0;

Vsum(find(Vsum > Vsum_threshold)) = 1;
Vsum(find(Vsum < Vsum_threshold)) = 0;

clear('Usum_threshold', 'Vsum_threshold');

UV_XOR = bitxor(uint8(Usum), uint8(Vsum));


rand('seed', key);
binary_seq = randi([0 1], 1, length(UV_XOR));
signature = double( bitxor(uint8(UV_XOR), uint8(binary_seq)) ); % signature length=512

clear('Usum', 'Vsum', 'UV_XOR', 'binary_seq');
end