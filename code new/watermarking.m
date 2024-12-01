function LL_inv = watermarking(LL, signature, print_figures)

[LL_1, HL_1, LH_1, HH_1] = dwt2(LL, 'haar');    % 1st step DWT
[LL_2, HL_2, LH_2, HH_2] = dwt2(LL_1, 'haar');  % 2nd step DWT
[LL_3, HL_3, LH_3, HH_3] = dwt2(LL_2, 'haar');  % 3rd step DWT
[LL_4, HL_4, LH_4, HH_4] = dwt2(LL_3, 'haar');  % 4rth step DWT

if (print_figures == true)
    cod_cA = wcodemat(LL_4);
    cod_cH = wcodemat(HL_4);
    cod_cV = wcodemat(LH_4);
    cod_cD = wcodemat(HH_4);
    dec2dim = [cod_cA, cod_cH; cod_cV, cod_cD];
    
 
end


% LL_4 = reshape(LL_4, 1, length(LL_4)^2);
% HH_4 = reshape(HH_4, 1, length(HH_4)^2);

combined_LL4_and_HH4_coef = [LL_4 HH_4];

negative_idxs = combined_LL4_and_HH4_coef(logical(combined_LL4_and_HH4_coef)) < 0;


combined_LL4_and_HH4_coeff_pos = abs(combined_LL4_and_HH4_coef);
integer_part = fix(combined_LL4_and_HH4_coeff_pos);
fraction_part = abs(combined_LL4_and_HH4_coeff_pos - integer_part);

binary_coefficients = {};
for p = 1:length(integer_part)
    binary_coefficients{p} = decimalToBinaryVector(integer_part(p), 16);
end

for m = 1:length(signature)
    for n = 1:16
        if (n == 10)
            binary_coefficients{1, m}(n) = signature(m);
        end
    end
end
bin2decimal = zeros(1, length(binary_coefficients));
for x = 1:length(binary_coefficients)
    bin2decimal(x) = binaryVectorToDecimal(double(binary_coefficients{1, x}));
end


bin2decimal = bin2decimal ;

bin2decimal(find(negative_idxs == 1)) = -bin2decimal(find(negative_idxs == 1));

clear('LL_1', 'LL_2', 'LL_3', 'LL_4', 'HH_4', 'combined_LL4_and_HH4_coef',...
    'negative_idxs', 'combined_LL4_and_HH4_coeff_pos', 'integer_part',...
    'fraction_part', 'binary_coefficients', 'signature');

LL_4_modified = bin2decimal(1:256);
HH_4_modified = bin2decimal(257:end);
LL_4_modified = reshape(LL_4_modified, 16, 16);
HH_4_modified = reshape(HH_4_modified, 16, 16);

clear('bin2decimal');

LL_3_inv = idwt2(LL_4_modified, HL_4, LH_4, HH_4_modified, 'haar');
LL_2_inv = idwt2(LL_3_inv, HL_3, LH_3, HH_3, 'haar');
LL_1_inv = idwt2(LL_2_inv, HL_2, LH_2, HH_2, 'haar');
LL_inv   = idwt2(LL_1_inv, HL_1, LH_1, HH_1, 'haar');

clear('LL_1_inv', 'LL_2_inv', 'LL_3_inv', 'LL_4_modified', ...
    'HL_1', 'HL_2', 'HL_3', 'HL_4', ...
    'LH_1', 'LH_2', 'LH_3', 'LH_4', ...
    'HH_1', 'HH_2', 'HH_3', 'HH_4_modified');

end