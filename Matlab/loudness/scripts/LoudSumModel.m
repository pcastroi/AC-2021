function N = LoudSumModel(level,BW,model)
% LoudSumModel	calculates loudness for loudness summation experiments
%
% Calculates loudness of bandlimited 500-ms white-noise burst with a
% center frequency of 2000 Hz. The bandwidth must be given as parameter
% (see below). The loudness is calculated according to DIN45631/ISO532B
% or Moore & Glasberg (1996).
%
% syntax: N = LoudSumModel(level, BW, model)
%
% input:  level  sound level in dBSPL
%         BW     bandwidth of the noise (200, 400, 800, 1600, 3200 or 6400)
%         model  'd' use loudness model according to DIN45631/ISO532B
%                'm' use loudness model according to Moore & Glasberg (1996)
%
% output: N      calculated loudness in sone

% (c) of, 2003 Sep 12
% Last Update: 2003 Sep 12

if nargin < 3,
  help(mfilename)
  return
end

bDIN = ~isempty(find(model=='d'));
bMoore = ~isempty(find(model=='m'));

skriptpath = fileparts(which(mfilename));
if bDIN,
  ModelPath = strcat(skriptpath,filesep,'DIN45631');
elseif bMoore,
  ModelPath = strcat(skriptpath,filesep,'Moore96');
else
  error('Please choose one model: either ''d'' or ''m''');
end

sig.fs = 44100;                        % sampling frequency in Hz
sig.len = 13230;                       % length of signal in samples
sig.lvl = level;
sig.BW = BW;
sig.fc = 2000;                         % center frequency in Hz
sig.LowCut = -sig.BW/2 + sqrt((sig.BW/2)^2 + sig.fc^2);
sig.UpCut = sig.fc^2/sig.LowCut;
sig.hannlen = round(0.05*sig.fs);
sig.win = hannfl(sig.len,sig.hannlen,sig.hannlen);

signal = real(ifft(scut(fft(randn(sig.len,1)),sig.LowCut,sig.UpCut,sig.fs)));

addpath(ModelPath);
N = CalcLoud(signal,sig.fs,sig.lvl);
rmpath(ModelPath);

%disp(sprintf('%0.2f sone',N));
return
