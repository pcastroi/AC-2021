% CallSound.m
%
%	Syntax:
%	CallSound
%
%	Methodology:
%	Load Soand
%	Estimate Power Spectrum
%	Convert to dB
%	Filter
%	Calculate Loudness accordint to DIN 45631
%	Plot
%
%	Variables:
%	fullscreen	=	Variable to set the size of plot windows
%	fname			=	file name of wav file to be loaded
%	MS				=	Sound Field (See DIN45631)
%	y				=	Time Vector (Pascals)
%	fs				=	Sampling Frequency (Hz)
%	nbits			=	Number of bits (Not Used in program, just there for syntax)
%	err			=	Error recording variable
%	ycal			=	Callibrated time vecotr (Pascals) 
%	df				=	Minimum desired resolution PowSpec will choose a power of 2
%						which gives at least this resolution
%					=	Further in the code, this becomes the true resolution
%	Yxx			=	Power Spectrum (Pascals^2/Hz)
%	f				=	Frequency (Hz)
%	YdB			=	Sound Pressure Level
%	H				=	Filter Frequency Response Function
%	Lt				=	1/3 Octave Band Inputs to the Loudness Program (dB)
%	N				=	Total Loudness (Sones)
%	Ns				=	Specific Loudness (Sones/Bark ?)
%	z				=	Critical Band Rate

%	Author:	Aaron Hastings, Herrick Labs, Purdue University
%	Date Started:	Unknown
%	Last Revision:	5 Dec 00
%	Status: No Known Bugs

clc
clear all
close all

fullscreen=[1 1 1152 795];	%%	Size for full screen figure
fname='sin1000.wav';
MS = 'f'; %%	Diffuse field

%%	Load and Calibrate Sound
[y,fs,nbits,err]=LoadSound(fname);
[ycal,err] = Calibrate(y);
y=ycal;

%%	Call function to perform PSD

df=2;		
[Yxx,f]=PowSpec(y,fs,df);
df=f(2)-f(1);

%%	Convert to dB
[YdB, err]=Convert2dB(Yxx, 1);

%%	Filter
[H, err]=GenerateFilters(f);
%%	Scale so that the sum of the energy of all 1/3 OB for a given freq. is 
%% amplified by 1. The sum of all filters for a given frequency changes 
%%	depending on which freq you look at. To make sure that the total energy 
%% is not amplified to be greater than 1 times the original 
%% The average sum was used in calculating the correction.
%%	e.g.
%%		for ink=1:length(H)
%%			energy(ink)=sum(abs(H(:,ink)));
%%		end
%%		AverageEnergyGain = mean(energy)
%%		Correction = 1 / AverageEnergyGain
%%
%%	This would give a correction of 0.9639, but 0.9483 works better.
H=0.94833723551160*H;	
for ink=1:28
   Lt(ink)=10*log10(sum((10.^(YdB/10)).*(abs(H(ink,:).^2))));
end

%%	Calculate Loudness
[N, Ns, err]=DIN45631(Lt, MS);

%%	Plots
figure(1)
set(gcf,'Position',fullscreen)
subplot(211)
ref = 20e-6;
plot(f,10*log10(Yxx/ref^2))
axis([0 22050 0 80])
[pointY, pointI]=max(10*log10(Yxx/ref^2));
grid
hold on
plot(f(pointI),pointY,'or')
legend('PSD',num2str(pointY))
title('Windowed Power Specrum of Input Signal')
xlabel('Frequency, Hz')
ylabel('Level, dB / Hz')
subplot(212)
z=0.1:0.1:24;
plot(z,Ns)
axis([0 24 0 3])
grid
title(['Loudness Spectrum', 10, 'Total Loudness = ', num2str(N)])
xlabel('Critical Band Rate, Bark')
ylabel('SPecific Loudness, Sones')

figure(2)
set(gcf,'Position',fullscreen)
subplot(211)
for ink=1:29
   loglog(f,abs(H(ink,:))')
   hold on
end
title('Frequency Response of One-Third Octave Band Filter Set')
xlabel('Frequency, Hz')
ylabel('Amplitude, Signal Units')
axis([20 20000 0.1 2])
grid
subplot(212)
stem(Lt)
axis([0 30 0 80])
title('One-Third Octave Band Levels Sent to Loudness Function')
xlabel('One-Third Octave Band Number')
ylabel('Level, dB')
grid

clc
disp(['Calculated Loudness is: ' num2str(N) ' Sones'])
disp(['Maximum Specific Loudness is: ' num2str(max(Ns)) ' Sones/Bark'])