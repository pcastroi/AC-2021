set.callevel = 91.5;
%=================white noise===============================================
% The cutoff frequencies are 30Hz and 500Hz
wnoise_ref = bpnoise(31090, 30, 500, 44100);
%==========================================================================

%================pink noise======================================
% % The power spectrum of pink noise is 
% % proportional to f^(-1) (f is frequency), which 
% % means that it decreases 3 dB per octave. 
% % This means that frequency bands with the same 
% % bandwidth on a logarithmic frequency scale 
% % contain the same power. 
% % 
% % This pink noise was calculated according to 
% % an algorithm I found on the internet 
% % The original author was Mr. Tom Bruhns from HP 
% % who proposed the following values for a 
% % white-to-pink noise filter for audio signals:
% % poles=[.9986823 .9914651 .9580812 .8090598 .2896591]';
% % zeros=[.9963594 .9808756 .9097290 .6128445 -.0324723]';

poles=[.9986823 .9914651 .9580812 .8090598 .2896591]';
zeros=[.9963594 .9808756 .9097290 .6128445 -.0324723]';

% Find forward and backward coefficients of the filter
[m,n]=zp2tf(zeros,poles,1);
% Filter the white noise to get pink noise.
set.pinknoise = filter(m,n,wnoise_ref);

%         COPYRIGHT     2004    Dik J. Hermes and Maxim Schram
%         Eindhoven University of Technology
%         Dept. of Technology Management
%         P.O. Box 513, NL 5600 MB Eindhoven, The Netherlands 
%===================================================================

%================Gaussian signal================================
% The Gaussian signal is white Gaussian nois whose length is 5ms, and
% windowed by a hanning window.
set.probelength = floor(0.005*44100);
set.probewin = hanning(set.probelength);
set.gaussiansignal = randn(set.probelength,1).*set.probewin;
%===============================================================

set.hannlen = round(0.05*44100);
set.window = hannfl(31090,set.hannlen,set.hannlen); 

%====================the window for pink noise of 500ms===================
win = hanning(1024);
set.win =[ones(21538,1) ; win(513:1024); ones(9040,1)];
%==========================================================================
% define the level of gaussian signal
work.gaussiansignal = set.gaussiansignal * 10^((70-91.5)/20);

% generate windowed bandpassed noise
tref1 = set.pinknoise.* set.window;
tuser1 = set.pinknoise.*set.window;

% get the correct levels
tref1 = tref1/rms(tref1) * 10^((80-set.callevel)/20);
tuser1 = tuser1/rms(tuser1) * 10^((80-set.callevel)/20);

%==================the signal and the delay=============================
% Replacement method
% The largest length of the total procedure is 500+200+5=705ms, i.e.almost 31090Hz. 
% The method here is that first of all, a pinknoise is generated in the whole length; 
% the time delay is given from 22051 Hz; the probe signal is given after 
% the time delay and the rest is zero.


work.delay = zeros(3087,1);

gapstop = 22050 + work.gap;
tuser1(22051:gapstop) = work.delay;

probestop = gapstop + set.probelength;
tuser1((gapstop+1):probestop) = work.gaussiansignal;

tuser1((probestop+1):31090) = 0;
tuser1 = tuser1.*set.win;
%================design the refrence interval=============================
% The reference interval just contains the pinknoise which duration is 500ms.
tref1(22051:31090) = 0;
tref1 =tref1.*set.win;
%=========================================================================


% presig=zeros(def.presiglen,2);
% postsig=zeros(def.postsiglen,2);
% pausesig=zeros(def.pauselen,2);
% 
% % the first column holds the test signal(left right)
% work.signal=[tuser1*0 tuser1 tref1*0 tref1];	
% 
% work.presig=presig;											% must contain the presignal
% work.postsig=postsig;										% must contain the postsignal
% work.pausesig=pausesig;										% must contain the pausesignal