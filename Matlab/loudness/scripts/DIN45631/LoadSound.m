%	LoadSound.m
%
% 	This function loads a wav file
%
%	Syntax:
%	[y,fs,nbits,err]=LoadSound(fname)
%
%	Variables:
%	INPUT
%	fname = Name of wav file
%
%	OUTPUT
%	y     = Digitally sampled amplitude vector from wav file
%	fs    = Sampling frequency of wav file in Hz
%	nbits = Number of bits of amplitude resolution of the wav file
%	err   = value for an error return
%               0 = no error
%               1 = unkown error

%	Author:	Aaron Hastings, Herrick Labs, Purdue University
%	Date Started:	2 June 00
%	Last Revision: 6 Nov 00
%	Status: No Known Bugs

function[y,fs,nbits,err]=LoadSound(fname)

%%	Begin function

err=1;

[y,fs,nbits]=wavread(fname);

err=0;
return