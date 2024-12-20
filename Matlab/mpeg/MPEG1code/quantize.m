function Gi = quantize(G,scf,Bits)
%  function Gi=quantize(G,scf,Bits)
%  ** Multicolumn version **
%  For each frame in G (12 rows), quantize() quantizes each of the 32 frequency band in G according
%  to the scalefactors (SCF) and number of bits (Bits).
%  G  :  12*Nf x 32 matrix - filterbank output
%  SCF:   Nf  x 32 matrix - scale factors
%  Bits:  Nf  x 32 matrix - assigned bits
%
%
%
% Your code goes here.

numFrames = size(scf,1);
numBands = size(scf,2);

Gi = zeros(size(G)); %Initialise the output

for nn = 1:numFrames
    for ff=1:numBands %over frequency bands (32)
        if Bits(nn,ff) == 0
            Gi(nn,ff) = 0; %set output of subband to zero if no bits allocated
        else
            nLevels = (2^Bits(nn,ff))-1; %number of values
            q_step = (2*(scf(nn,ff)))/nLevels; %stepsize
            startVal = (nn-1)*12 + 1;
            endVal = startVal+11;
            samplesInFrame = startVal:endVal;
            Y_quantized = round(G(samplesInFrame,ff)./q_step); %quantized integer values
            Gi(startVal:endVal,ff) = Y_quantized;
        end
    end
end

