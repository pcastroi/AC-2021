function Bits=bitassign(SM,bitrate,fs)
%  function Bits=bitassign(SM,bitrate,fs)
%  For each frame bitassign() assigns the available bit to the 32 frequency bands
%  according to the signal-to-masker information in SM, and the bitrate and the
%  sampling frequency of the signal )
%
%  Calculated the bit budget available for each frame
%
% Your code goes here.

%% Initialization
numFrames = size(SM,1);
numBands = size(SM,2);

bitsPerSample = bitrate/fs; %bits per sample
bitsTotalPerFrame = bitsPerSample * 384; %Number of available bits in a frame of 384 samples

Bits = zeros(size(SM));

%% loop over frames
for nFrame = 1:numFrames
    currentBitsBand = zeros(1,numBands); %Initialise output vector
    bitsAvailable = bitsTotalPerFrame; %current Number of available bits
    
    
    %% Assign bits loop
    while bitsAvailable > 0 %while loop until there are no more bits available
        %% Step 1:
        %RMS of the signal
        sigRMS = 1/sqrt(2);
        %RMS of the quantisation noise
        qstep = 2./(2.^(currentBitsBand) - 1);
        for nBands = 1:numBands
            if currentBitsBand(nBands) == 0
                QnoiseRMS(nBands) = sigRMS;
            elseif currentBitsBand(nBands) == 2
                QnoiseRMS(nBands) = 0.39 * qstep(nBands);
            elseif currentBitsBand(nBands) == 3
                QnoiseRMS(nBands) = 0.47 * qstep(nBands);
            elseif currentBitsBand(nBands) > 3
                QnoiseRMS(nBands) = (1/sqrt(12)) * qstep(nBands);
            else
                warning('Something went wrong in the bit allocation.')
            end
        end
        %Calculate SQNR
        SQNR = 20*log10(sigRMS./QnoiseRMS);%Signal to Noise Ratio
        
        %% Step 2:
        %Calculate NM
        NM = SM(nFrame,:)-SQNR; %The new NM
        
        
        %% Step 3:
        [~, idxBandPeak] = max(NM); %find max in NM
        
        if currentBitsBand(idxBandPeak) == 0 %if allocated bits == 0
            currentBitsBand(idxBandPeak) = currentBitsBand(idxBandPeak)+2; %add 2 bits
            bitsAvailable = bitsAvailable-2;
        elseif currentBitsBand(idxBandPeak) > 0 %if allocated bits > 0
            currentBitsBand(idxBandPeak) = currentBitsBand(idxBandPeak)+1; %add 1 bit
            bitsAvailable = bitsAvailable-1;
        end
        if bitsAvailable<0
            a=0;
        end
        
    end
    
    Bits(nFrame,:) = currentBitsBand; %output the allocated Bits
end

