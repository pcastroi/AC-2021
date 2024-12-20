function Xi=quantize2(X,scf,n)
%  function Xi=quantize(X,scf,n)
%  ** Quantization with variable scale factor and number of bits  **
%
%  Quantize each frame of 12 samples in X with the corresponding scalefactor value in SCF
%  and number of bits in N
%
% X  : columnvector -  length 12*Nf, where Nf is the total number of frames
% SCF: columnvector -  length Nf
% N  : columnvector -  length Nf
% Your code goes here.

numFrames = size(scf,1);

Xi = zeros(size(X)); %Initialise the output

for nn=1:numFrames
    if n(nn) == 0
        Xi(nn) = 0; %set output of subband to zero if no bits allocated
    else
        nLevels = (2^n(nn))-1; %number of values
        q_step = (2*(scf(nn)))/nLevels; %stepsize
        startVal = (nn-1)*12 + 1;
        endVal = startVal+11;
        nthFrameSamples = startVal:endVal;
        Y_quantized = round(X(nthFrameSamples)./q_step); %quantized integer values
        Xi(nthFrameSamples) = Y_quantized;
    end
end

