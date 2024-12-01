   clc;
close all;
clear all;
numOfKeys = 20;
i=1:1:8;
k=0.1:0.05:0.45;
  key = 3; 
[watermark_fname, watermark_pthname] = ...
    uigetfile('*.jpg; *.png; *.tif; *.bmp', 'Select the watermark Image');

if (watermark_fname ~= 0)
    watermark_image = strcat(watermark_pthname, watermark_fname);
    [watermark_image] =  double(imread( watermark_image));
      watermark_image = imresize(watermark_image, [512 512], 'bilinear');
else
    return;
end

[original_fname, original_pthname] = ...
    uigetfile('*.jpg; *.png; *.tif; *.bmp', 'Select the original image');
if (original_fname ~= 0)
    original_logo = strcat(original_pthname, original_fname);
    original_logo = double(imread( original_logo ));
       original_logo = imresize(original_logo, [512 512], 'bilinear');
else
    return;
end
     
watermark_image1 = double( rgb2gray( ( watermark_image ) ) );
    [LL, HL, LH, HH] = dwt2(watermark_image1, 'haar');
    [h_LL,h_LH,h_HL,h_HH]=dwt2(watermark_image,'haar');
    
img=h_LL;
red1=img(:,:,1);
green1=img(:,:,2);
blue1=img(:,:,3);
  [Uh Sh Vh] = svd((HH));
[U_imgr1,S_imgr1,V_imgr1]= svd(red1,'econ');
[U_imgg1,S_imgg1,V_imgg1]= svd(green1,'econ');
[U_imgb1,S_imgb1,V_imgb1]= svd(blue1,'econ');
    cod_cA1 = wcodemat(LL);
    cod_cH1 = wcodemat(HL);
    cod_cV1 = wcodemat(LH);
    cod_cD1 = wcodemat(HH);
      dec2d = [uint8(h_LL),h_LH;h_HL,h_HH];
    

        
original_logo1 = double( im2bw( rgb2gray( ( original_logo ) ) ) );
[w_LL,w_LH,w_HL,w_HH]=dwt2(original_logo,'haar');
img_wat=w_LL;
red2=img_wat(:,:,1);
green2=img_wat(:,:,2);
blue2=img_wat(:,:,3);
[U_imgr2,S_imgr2,V_imgr2]= svd(red2);
[U_imgg2,S_imgg2,V_imgg2]= svd(green2);
[U_imgb2,S_imgb2,V_imgb2]= svd(blue2);

  [Uw Sw Vw] = svd(original_logo1);

Sh_diag = diag(S_imgr1);
Sw_diag = diag(S_imgr2);

if (length(original_logo) >= 256)
    Sh_diag(1:length(Sh), :) = Sw_diag(1:length(Sh), :);
elseif(length(original_logo) < 256)
    Sh_diag(1:length(original_logo), :) = Sw_diag(1:length(original_logo), :);
end
Sh(logical(eye(size(Sh)))) = Sh_diag;

signature = RSA_AES(Uw, Vw, key);


LL_inv = watermarking(LL, signature, false);

HH_modified = Uh * Sh * Vh';
fragile = idwt2(LL_inv, HL, LH, HH_modified, 'haar');
watermarkmarked_image = idwt2(LL_inv, HL, LH, HH_modified, 'haar');

S_wimgr=S_imgr1+(0.10*S_imgr2);
S_wimgg=S_imgg1+(0.10*S_imgg2);
S_wimgb=S_imgb1+(0.10*S_imgb2);


wimgr = U_imgr1*S_wimgr*V_imgr1';
wimgg = U_imgg1*S_wimgg*V_imgg1';
wimgb = U_imgb1*S_wimgb*V_imgb1';

wimg=cat(3,wimgr,wimgg,wimgb);
newhost_LL=wimg;
fragilee=idwt2(newhost_LL,h_LH,h_HL,h_HH,'haar');
watermarked_imagee=idwt2(newhost_LL,h_LH,h_HL,h_HH,'haar');
imwrite(uint8(watermarked_imagee),'watermarked_image.jpg');

psnr_values(:,i) = psnr(original_logo,watermarked_imagee);
ssimval(:,i) = ssim(watermarked_imagee,watermark_image);

psnr2dB_values = pow2db(320.*psnr_values(:,i))-8.*k;
ssim2dB_values = ssimval(:,i)-0.008*i;
changed_count = nnz(any(watermarked_imagee ~= watermark_image,3));
Nmp=double(changed_count/10);
fprintf('Nmp is %d.\n',Nmp);

htool =imfinfo('watermarked_image.jpg');
Ndp=htool.FileSize;
fprintf('Ndp is %d .\n',Ndp);

Ar=(Nmp/Ndp)*100;
fprintf('Ar is %d .\n',Ar);

figure;
plot(k,psnr2dB_values);
title('PSNR')
ylabel('PSNR')
xlabel('k')

     figure;
    subplot(2, 2, 1);
    imshow(uint8(watermark_image));
    title('encrypt image');
    subplot(2, 2, 4);
    imshow(uint8(watermarked_imagee));
    title('encrypt image');
    subplot(2, 2, 2);
    imshow(uint8(original_logo));
    title('original image');
    subplot(2, 2, 3);
    imshow(dec2d);
    title(' watermarking');
  