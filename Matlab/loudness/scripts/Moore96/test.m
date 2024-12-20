fs = 44100;	% sampling frequency in Hz
f = 1000;	% signal frequency in Hz
len = 1;	% signal length in s
lvl = 0:10:100;	% signal level in dB SPL

t = (0:1:len*fs-1)/fs;
sig = sin(2*pi*f*t);

N = CalcLoud(sig,fs,lvl);
disp(N)
