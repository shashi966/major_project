
clc;
close all;
    secret_key = 3; 

[cover_fname, cover_pthname] = ...
    uigetfile('*.jpg; *.png; *.tif; *.bmp', 'Select the encrypted Image');
if (cover_fname ~= 0)
    watermarked_image = strcat(cover_pthname, cover_fname);
    watermarked_image = double( ( imread( watermarked_image ) ) );
    watermarked_image = imresize(watermarked_image, [512 512], 'bilinear');
else
    return;
end


    
watermark_image = double( im2bw( ( ( watermark_image ) ) ) );
[LLw HLw LHw HHw] = dwt2(watermarked_image, 'haar');

[LLw_1, HLw_1, LHw_1, HHw_1] = dwt2(LLw, 'haar');    
[LLw_2, HLw_2, LHw_2, HHw_2] = dwt2(LLw_1, 'haar');  
[LLw_3, HLw_3, LHw_3, HHw_3] = dwt2(LLw_2, 'haar');  
[LLw_4, HLw_4, LHw_4, HHw_4] = dwt2(LLw_3, 'haar');  

[Uw_x Sw_x Vw_x] = svd(watermark_image);
generated_signature = RSA_AES(Uw_x, Vw_x, key);
reconstructed_signature = dewatermarking(LLw_4, HHw_4, length(watermark_image));

    
  if ( reconstructed_signature == generated_signature | corr2(reconstructed_signature, generated_signature) > 0.7 )
        
        [Ucw Scw Vcw] = svd(HHw(:,:,1), 'econ');
        
        HH_singularValues = zeros(length(watermark_image));
        Shh_diag = diag(HH_singularValues);
        Scw_diag = diag(Scw);
      
        if (length(watermark_logo) >= 256)
            Shh_diag(1:length(Scw), :) = Scw_diag;
        elseif (length(watermark_logo) < 256)
            Shh_diag(1:length(watermark_logo), :) = Scw_diag(1:length(watermark_logo), :);
        end
        HH_singularValues(logical(eye(size(HH_singularValues)))) = Shh_diag;
        
        Watermark_logo_extracted = Uw_x * HH_singularValues * Vw_x';
         
    else
        Watermark_logo_extracted = zeros(length(watermark_image), length(watermark_image));
    end


    [Ucw Scw Vcw]     = svd(HHw(:,:,1), 'econ');
    HH_singularValues = zeros(length(watermark_image));
    Shh_diag = diag(HH_singularValues);
    Scw_diag = diag(Scw);
   
  
    if (length(watermark_image) >= 256)
        Shh_diag(1:length(Scw), 1) = Scw_diag;
    elseif (length(watermark_image) < 256)
        Shh_diag(1:length(watermark_image), :) = Scw_diag(1:length(watermark_image), :);
    end
    HH_singularValues(logical(eye(size(HH_singularValues)))) = Shh_diag;
       
    Watermark_logo_extracted = Uw_x * HH_singularValues * Vw_x';
    
    

[wm_LL,wm_LH,wm_HL,wm_HH]=dwt2(watermarked_image,'haar');
img_w=wm_LL;
red3=img_w(:,:,1);
green3=img_w(:,:,2);
blue3=img_w(:,:,3);
[U_imgr3,S_imgr3,V_imgr3]= svd(red3);
[U_imgg3,S_imgg3,V_imgg3]= svd(green3);
[U_imgb3,S_imgb3,V_imgb3]= svd(blue3);



S_ewatr=(S_imgr3-S_imgr1)/0.10;
S_ewatg=(S_imgg3-S_imgg1)/0.10;
S_ewatb=(S_imgb3-S_imgb1)/0.10;

ewatr = U_imgr2*S_ewatr*V_imgr2';
ewatg = U_imgg2*S_ewatg*V_imgg2';
ewatb = U_imgb2*S_ewatb*V_imgb2';

ewat=cat(3,ewatr,ewatg,ewatb);

newwatermark_LL=ewat;

%output

watermark_logo_extracted=idwt2(newwatermark_LL,w_LH,w_HL,w_HH,'haar');
figure;imshow(uint8(watermark_logo_extracted));
title('extracted original image')
imwrite(uint8(watermark_logo_extracted),'Extracted_Watermark.jpg');title('Extracted cover image');
           

