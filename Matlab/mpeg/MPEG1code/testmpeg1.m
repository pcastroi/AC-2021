[sig, fs] =audioread('sk8rboi.wav');
scf = max(abs(sig));
n = 4;
fs=44100;
% Can be either 'uniform' or 'percep'
bitass='uniform';

Qsig = quantize1(sig,scf,n);
[G,SM,SCF]=mpeg1(sig,44100);

% use n bits everywhere
Uniform2Bits=n*ones(size(SCF,1),32);
PerceptBits=bitassign(SM,bitrate,fs,SCF,n);
if strcmp(bitass,'uniform')
    Bits = Uniform2Bits ; 
elseif strcmp(bitass,'percep')
    Bits = PerceptBits;
else
    disp('bitass has to be either "uniform" or "percep"');
end
Gi=quantize(G,SCF,Bits);
xq = decode(Gi,SCF,Bits);
sound(xq,fs); % (playback over head phones)