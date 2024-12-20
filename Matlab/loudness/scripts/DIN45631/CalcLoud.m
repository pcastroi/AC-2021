function N = CalcLoud(sig,fs,lvl)
% CalcLoud	calculates loudness in sone according to ISO 532B / DIN 45631
%
% syntax:	N = CalcLoud(sig,fs,lvl)
%
% input:  sig	signal vector
%         fs	sampling frequency
%         lvl	desired signal level in dB SPL
%
% output: N	total loudness in sone

% based upon CallSound.m by Aaron Hastings, Herrick Labs, Purdue University
% (c) of, 2003 Aug 14
% Last Update: 2003 Aug 27

%	Methodology:
%	Calibrate
%	Estimate Power Spectrum
%	Convert to dB
%	Filter
%	Calculate Loudness accordint to DIN 45631
%
%	Variables:
%	MS	=	Sound Field (See DIN45631)
%	y	=	(calibrated) Time Vector (Pascals)
%	err	=	Error recording variable
%	df	=	Minimum desired resolution PowSpec will choose a
%			power of 2 which gives at least this resolution
%			Further in the code, this becomes the true resolution
%	Yxx	=	Power Spectrum (Pascals^2/Hz)
%	f	=	Frequency (Hz)
%	YdB	=	Sound Pressure Level
%	H	=	Filter Frequency Response Function
%	Lt	=	1/3 Octave Band Inputs to the Loudness Program (dB)
%	N	=	Total Loudness (Sones)
%	Ns	=	Specific Loudness (Sones/Bark ?)
%	z	=	Critical Band Rate

MS = 'f'; %%	'f': free field -- 'd': diffuse field

for i = 1:length(lvl),

  %%	Calibrate Sound
  Pref = 20e-6;				% Ref Pressure
  RMS=sqrt(mean(sig.^2));		% RMS
  SPLmat=20*log10(RMS/Pref);		% SPLmax as calculated by Matlab
  c=10^((lvl(i)-SPLmat)/20);
  y = c*sig;

  %%	Call function to perform PSD
  df=2;		
  [Yxx,f]=PowSpec(y,fs,df);
  df=f(2)-f(1);

  %%	Convert to dB
  [YdB, err]=Convert2dB(Yxx, 1);

  %%	Filter
  [H, err]=GenerateFilters(f);
  %% Scale so that the sum of the energy of all 1/3 OB for a given freq.
  %% is amplified by 1. The sum of all filters for a given frequency
  %% changes depending on which freq you look at. To make sure that the
  %% total energy is not amplified to be greater than 1 times the
  %% original the average sum was used in calculating the correction.
  %% e.g.
  %%	for ink=1:length(H)
  %%		energy(ink)=sum(abs(H(:,ink)));
  %%	end
  %%	AverageEnergyGain = mean(energy)
  %%	Correction = 1 / AverageEnergyGain
  %%
  %%	This would give a correction of 0.9639, but 0.9483 works better.
%  H = 0.94833730532091043 * H;	% calculated by of
  H = H*0.9639;			% -> 8.02 sone for 1 kHz, 70 dB SPL
%  H=0.94833723551160*H;	% original by AH
  for ink=1:28
     Lt(ink)=10*log10(sum((10.^(YdB/10)).*(abs(H(ink,:).^2))));
  end

  %%	Calculate Loudness
  [N(i), Ns, err]=DIN45631(Lt, MS);

end	% for i = 1:length(lvl)

return
