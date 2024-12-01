
function BER = BitErrorRate(differenceOfWatermark)
x=1:1:20;
for ii = 1:size(differenceOfWatermark, 1)
    count_correct(ii) = sum( differenceOfWatermark(ii, :) == 0 );
    BER(ii) = (1 - ( mean ( count_correct(ii) ) / size(differenceOfWatermark, 2) ) ) * 100;
end
figure;
plot(x,BER);
xlabel('no of keys'), ylabel('BER');
title('BER');
end