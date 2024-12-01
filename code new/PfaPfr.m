function [Pfa, Pfr] = PfaPfr(meanOfDecodedCorrect, stdOfDecodedCorrect, meanOfDecodedWrong, stdOfDecodedWrong, N)

step = abs(meanOfDecodedCorrect - meanOfDecodedWrong)/(N-1);

Pfa = zeros(1, N);
Pfr = zeros(1, N);
count = 1;
for ii = meanOfDecodedWrong:step:meanOfDecodedCorrect
    Pfa(count) = normspec( [ii, inf], meanOfDecodedWrong, stdOfDecodedWrong, 'inside'); close;
    Pfr(count) = normspec( [-inf, ii], meanOfDecodedCorrect, stdOfDecodedCorrect, 'inside'); close;
    count = count + 1;
end

figure;
loglog(Pfa, Pfr);
xlabel('Pfr'), ylabel('Pfa');
title('ROC');


end