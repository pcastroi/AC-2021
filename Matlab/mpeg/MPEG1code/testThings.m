
%% Test quantizer
xtest = [-.19 -.15 -.11 -.07 -.03 .01 .05 .09 .13 .17]
[Y] = quantize1(xtest, .2, 4)

%% Listen to quantized audio
nBits = 4;
[sig, fs] = audioread('zauber.wav');
scf = max(abs(sig));
Qsig = quantize1(sig,scf,nBits);

%Careful with the SPL!
%soundsc(Qsig, fs)

%% try MPEG
nBitsPerFrameBand = 4;
[G,SM,SCF] = mpeg1(sig,fs);
Bits = nBitsPerFrameBand*ones(size(SCF));
Gi = quantize(G,SCF,Bits);
xq = decode(Gi,SCF,Bits);

sound(xq, fs)

%% Test bit-assignment
nBitsPerFrameBand = 2;
%test quantize1 with 0 bits
Xi = quantize1(xtest, .2, 0);
%Perceptual vs uniform assignment of bits
Uniform2Bits = nBitsPerFrameBand*ones(size(SCF)); %bits per frame and band in matrix form
Gi_uniform = quantize(G,SCF,Uniform2Bits);
xq_uniform = decode(Gi_uniform,SCF,Uniform2Bits);

bitrate = ((nBitsPerFrameBand*32)/384)*fs;%bits per second
bitrate = 512e3;
PerceptBits = bitassign(SM,bitrate,fs);
Gi_percept = quantize(G,SCF,PerceptBits);
xq_percept = decode(Gi_percept,SCF,PerceptBits);

sound(xq_uniform,fs)
sound(xq_percept,fs)

%% bitrate calculation

%2bits per band
bitsPerFrame = 2*32;
bitsPerSample = bitsPerFrame/384;
bitsPerSecond = bitsPerSample*fs;





