function Xi=quantize1(X,scf,n)
%  function Xi=quantize(X,scf,n)
%  Quantize the signal X with n bits in the interval [-scf:scf]
%
% X : columnvector
%
%  If scf (the scalefactor) is 0.2 and the number of bits, n, is 4 the values:
%      -.19   -.15   -.11   -0.07   -0.03   0.01   0.05   0.09   0.13  0.17
%  should be quantized into the integer values:
%       -7     -6     -4     -3      -1       0     2       3      5     6
%
% Your code goes here.

nLevels = (2^n)-1;

q_step = (2*scf)/nLevels;

Xi = round(X./q_step);


end