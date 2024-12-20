% Convert2dB.m
%	This program takes the complex fft amplitudes and converts them to dB
%	It use the cal variable to produce calibrated levels
%
%	Syntax:
%	[YdB, err]=Convert2dB(Yxx, cal)
%
%	Variables:
%	INPUT
%	Yxx   = 	PSD of y 
%	cal   = 	A calibration factor which multiplies each element of the wav file 
%				to get the correct SPL. This will generally be set to 1 since 
%				calibration is normally done elsewhere
%	
%	OUTPUT
%	YdB   = 	Amplitude spectrum in dB
%	err   = 	value for an error return
%               0 = no error
%               1 = unkown error

%	Author:	Aaron Hastings, Herrick Labs, Purdue University
%	Date Started:	8 July 00
%	Last Revision:	11 Nov 00
%	Status: No Known Bugs

% Change by of (2003 Aug 27): avoid 'log of zero' warning

function[YdB, err]=Convert2dB(Yxx, cal)

%%	Begin function

err=1;

ref = 20e-6;
% begin (change by of)
i_zero = find(Yxx == 0);
Yxx(i_zero) = realmin;
% end (change by of)

YdB=10*log10((cal^2)*Yxx/(ref^2));

err=0;

return
