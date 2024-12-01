function reconstructed_signature = dewatermarking(LLw_4, HHw_4, lengthOfWatermark)


% LLw_4 = reshape(LLw_4, 1, length(LLw_4)^2);
% HHw_4 = reshape(HHw_4, 1, length(HHw_4)^2);

combined_LLw_4_and_HHw_4_coeff = [LLw_4 HHw_4];

negative_watermarked_idxs = combined_LLw_4_and_HHw_4_coeff(logical(combined_LLw_4_and_HHw_4_coeff)) < 0;


combined_LLw_4_and_HHw_4_coeff_pos = abs(combined_LLw_4_and_HHw_4_coeff);
integer_part_of_watermarked_image = fix(combined_LLw_4_and_HHw_4_coeff_pos);
fraction_part_of_watermarked_image = abs(combined_LLw_4_and_HHw_4_coeff_pos - integer_part_of_watermarked_image);

clear('LLw_4', 'HHw_4', 'combined_LLw_4_and_HHw_4_coeff', ...
    'negative_watermarked_idxs', 'fraction_part_of_watermarked_image');

binary_watermarked_coefficients = {};
for y = 1:length(combined_LLw_4_and_HHw_4_coeff_pos)
    binary_watermarked_coefficients{y} = decimalToBinaryVector(integer_part_of_watermarked_image(y), 16);
end

clear('combined_LLw_4_and_HHw_4_coeff_pos', 'integer_part_of_watermarked_image');

reconstructed_signature = zeros(1, lengthOfWatermark);


clear('binary_watermarked_coefficients');

end