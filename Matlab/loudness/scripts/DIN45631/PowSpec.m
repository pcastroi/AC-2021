% PowSpec.m
%
%	Methodology:
%
%	Syntax:
%	[Yxx,f]=PowSpec(y,fs,df)
%
%	Variables:
%	INPUT
%	y			=	Time signal
%	fs			=	Sampling frequency
%	df			=	DESIRED df
%
%	WORKING
%	NFFT		=	Nummber of points for a given fft
%	NOVERLAP	=	Number of Points to overlap
%
%	OUTPUT
%	Yxx		=	Power Spectrum Amplitude
%	f			=	Frequency vector of power spectrum

%	Author:	Aaron Hastings, Herrick Labs, Purdue University
%	Date Started:	11 Nov 00
%	Last Revision:	11 Nov 00
%	Status: No Known Bugs

% Modification by of (2003 Aug 27): Don't use windowing

function [Yxx,f]=PowSpec(y,fs,df);

%%	Want to make sure that we have at least df resolution
NFFT=ceil(fs/df);	
%%	Set NFFT to power of 2 again err towards higher resolution
NFFT=length(y); % error makes it neccessary to have maximum length of y 2^ceil(log2(NFFT));

NOVERLAP=0;
%[Yxx,f] =  psd(y,NFFT,fs,ones(NFFT,1),NOVERLAP);	% uses no windowing

%%[Yxx,f] = psd(y,NFFT,fs,NFFT,NOVERLAP);	% uses a hanning window of length NFFT
%Yxx=2*Yxx/NFFT;	%%	Scale to get the power spectrum correct
%Yxx=Yxx';
[Yxx,f] = pwelch(y,ones(NFFT,1),0,NFFT,fs);
Yxx = Yxx';
return