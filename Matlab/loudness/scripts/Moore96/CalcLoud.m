function N = CalcLoud(sig,fs,lvl)
% CalcLoud	calculates loudness in sone according to Moore (1996)
%
% syntax:
%		N = CalcLoud(sig,lvl)
%
% input:	sig	signal vector
%		fs	sampling frequency
%		lvl	desired signal level in dB SPL
%
% output:	N	total loudness in sone

% alpha factor
alfa = 1;	% Should not be changed!
alfacorfq =	[0, fs/2]';
alfacor =	[alfa, alfa]';

% hearing threshold (in terms of dB HL)
vThrFre =	[1,	125,	250,	500,	750,	1000,	1500,	2000,	3000,	4000,	6000,	8000,	25000,	50000]';
vThrdB =	[0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0]';

% middle ear correction factors
vMFre = [
		0,	20,	25,	30,	35,	40,	45,	50,	55,	60,	70,	80,	90,...
		100,	125,	150,	177,	200,	250,	300,	350,	400,	450,	500,	550,	600,...
		700,	800,	900,	1000,	1500,	2000,	2500,	2828,	3000,	3500,	4000,	4500,	5000,...
		5500,	6000,	7000,	8000,	9000,	10000,	12748,	15000,	20000,	25000,	50000
	]';
vMdB = [
		31.8,	31.8,	26.0,	21.7,	18.8,	17.2,	15.4,	14.0,	12.6,	11.6,	10.6,	9.2,	8.2,...
		7.7,	6.7,	5.3,	4.6,	3.9,	2.9,	2.7,	2.3,	2.2,	2.3,	2.5,	2.7,	2.9,...
		3.4,	3.9,	3.9,	3.9,	2.7,	0.9,	-1.3,	-2.5,	-3.2,	-4.4,	-4.1,	-2.5,	-0.5,...
		2.0,	5.0,	10.2,	15.0,	17.0,	15.5,	11.0,	22.0,	22.0,	22.0,	22.0
	]';

bFF = 1;	% free field
bBin = 1;	% binaural

for i = 1:length(lvl),
  % calibrate sound
  Pref = 0.5/sqrt(0.5);			% sinusoid with ampl 1 -> 0 dB SPL
  RMS=sqrt(mean(sig.^2));		% RMS
  SPLmat=20*log10(RMS/Pref);		% SPLmat as calculated by Matlab
  c=10^((lvl(i)-SPLmat)/20);
  vSig = c*sig;

  % magnitude spectrum
  vSpec = abs(fft(vSig)/length(vSig)*2);	% the spectrum
  ind_zero = find(vSpec == 0);			% find zeros
  vSpec(ind_zero) = realmin;			% smallest positive number possible
  vCdB = 20*log10(vSpec);			% no log10 should work

  % corresponding frequency axis
  vCFre = (0:(length(vCdB)-1)) / length(vCdB) * fs;
  % only positive frequencies are of interest!
  vCdB = vCdB(1:length(vCdB)/2);
  vCFre = vCFre(1:length(vCFre)/2);

  % loudness
  [vELFreGl,vELErbGl,vELdBGl,vELIntGl,vNGl,N(i)] = ...
     loud96(vCFre,vCdB, vMFre,vMdB, vThrFre,vThrdB ,vThrFre,vThrdB ,0,0,bFF,bBin);
end

return
