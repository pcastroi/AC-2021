% Calibrate.m
%
%	Syntax:
%	[ycal, err]=calibrate(y)
%
%	Methodology:
%	Determine SPL of uncalibrated signal
%	Determine correction coefficient
%
%	Variables:
%	INPUT
%	y			=	Time Vector (Pascals)
%	
%	WORKING
%	Pref		=	Reference Pressure (Pascals)	
%	RMS		=	RMS of Time Vector
%	SPLmat	=	SPL calculated
%	SPLmeas	=	SPL which the sound should have
%	c			=	Calibration Coefficient
%	ycal		=	Calibrated Time Vector
%	
%	OUTPUT
%	ycal		=	calibrated time vector
%	err    	= Value for an error return
%               0 = No error
%               1 = Unkown error
%

%	Author:	Aaron Hastings, Herrick Labs, Purdue University
%	Date Started:	15 July 00
%	Last Revision:	5 Dec 00
%	Status: No Known Bugs

function[ycal, err]=calibrate(y)

%%	Begin function

err=1;

Pref = 20e-6;				%%	Ref Pressure
RMS=sqrt(mean(y.^2));			%%	RMS
SPLmat=20*log10(RMS/Pref);		%%	SPLmax as calculated by Matlab

disp(['The RMS SPL, calculated as SPLmax=20*log10(RMS(y)/Pref), is: '...
      num2str(SPLmat),10,])

SPLmeas=input('Please enter the RMS SPL as determined during the measurment ')

c=10^((SPLmeas-SPLmat)/20);
ycal=c*y;

err=0;

return

