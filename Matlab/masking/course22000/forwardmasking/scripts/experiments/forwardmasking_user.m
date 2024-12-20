% example_user - stimulus generation function of experiment 'example' -
%
% This function is called by afc_main when starting
% the experiment 'example'. It generates the stimuli which
% are presented during the experiment.
% The stimuli must be elements of the structure 'work' as follows:
%
% work.signal = def.intervallen by 2 times def.intervalnum matrix.
%               The first two columns must contain the test signal
%               (column 1 = left, column 2 = right) ...
% 
% work.presig = def.presiglen by 2 matrix.
%               The pre-signal. 
%               (column 1 = left, column 2 = right).
%
% work.postsig = def.postsiglen by 2 matrix.
%                The post-signal. 
%               ( column 1 = left, column 2 = right).
%
% work.pausesig = def.pausesiglen by 2 matrix.
%                 The pause-signal. 
%                 (column 1 = left, column 2 = right).
% 
% To design an own experiment, e.g., 'myexperiment',
% make changes in this file and save it as 'myexperiment_set.m'.
% Ensure that the referenced elements of structure 'work' are existing.
%
% See also help example_cfg, example_set, afc_main

function forwardmasking_user

warning off

global def
global work
global set

%=================white noise===============================================
% The white noise whose length is 500ms
work.wnoise = randn(def.intervallen,1);
%==========================================================================

%================Gaussian signal================================
% The Gaussian signal is white Gaussian nois whose length is 5ms, and
% windowed by a hanning window.
work.probelength = floor(0.005*def.samplerate);
work.probewin = hanning(work.probelength);
work.gaussiansignal = randn(work.probelength,1).*work.probewin;
%===============================================================

% define the level of gaussian signal
work.gaussiansignal = work.gaussiansignal * 10^((work.expvaract-set.callevel)/20);

% generate windowed white noise
tref1 = work.wnoise.* set.window;
tref2 = work.wnoise.* set.window;
tuser1 = work.wnoise.*set.window;

% get the correct levels
tref1 = tref1/rms(tref1) * 10^((set.wishlevel-set.callevel)/20);
tref2 = tref2/rms(tref2) * 10^((set.wishlevel-set.callevel)/20);
tuser1 = tuser1/rms(tuser1) * 10^((set.wishlevel-set.callevel)/20);

%==================the signal and the delay=============================
% Replacement method
% The largest length of the total procedure is 500+200+5=705ms, i.e.almost 31090Hz. 
% The method here is that first of all, a white noise is generated in the whole length; 
% the time delay is given from 22051 Hz; the probe signal is given after 
% the time delay and the rest is zero.

work.gap = floor(0.001*work.exppar1*def.samplerate);
work.delay = zeros(work.gap,1);

gapstop = 22050 + work.gap;
tuser1(22051:gapstop) = work.delay;

probestop = gapstop + work.probelength;
tuser1((gapstop+1):probestop) = work.gaussiansignal;

tuser1((probestop+1):31090) = 0;
tuser1 = tuser1.*set.win;
%================design the refrence interval=============================
% The reference interval just contains the white noise which duration is 500ms.
tref1(22051:31090) = 0;
tref1 =tref1.*set.win;
tref2(22051:31090) = 0;
tref2 =tref2.*set.win;
%=========================================================================


presig=zeros(def.presiglen,2);
postsig=zeros(def.postsiglen,2);
pausesig=zeros(def.pauselen,2);

% the first column holds the test signal(left right)
work.signal=[tuser1*0 tuser1 tref1*0 tref1 tref2*0 tref2];	

work.presig=presig;											% must contain the presignal
work.postsig=postsig;										% must contain the postsignal
work.pausesig=pausesig;										% must contain the pausesignal

% eof