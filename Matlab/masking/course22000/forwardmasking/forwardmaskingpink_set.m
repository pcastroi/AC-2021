% example_set - setup function of experiment 'example' -
%
% This function is called by afc_main when starting
% the experiment 'example'. It makes defines elements
% of the structure 'set'. The elements of 'set' are used 
% by the function 'example_user.m'.
% 
% If an experiments can be started with different experimental 
% conditions, e.g, presentation at different sound preasure levels,
% one might switch between different condition dependent elements 
% of structure 'set' here.
%
% For most experiments it is also suitable to pregenerate some 
% stimuli here.
% 
% To design an own experiment, e.g., 'myexperiment',
% make changes in this file and save it as 'myexperiment_set.m'.
% Ensure that this function does exist, even if absolutely nothing 
% is done here.
%
% See also help example_cfg, example_user, afc_main

function forwardmasking_set

global def
global work
global set

% make condition dependend entries in structure set

switch work.condition
case 'group'
case 'group1'
case 'group2'
case 'group3'
case 'group4'
case 'group5'
case 'group6'
case 'group7'
case 'group8'
case 'group9'
case 'group10'
case 'group11'
case 'group12'
case 'group13'
case 'group14'
case 'group15'
case 'group16'
otherwise
%   error('condition not recognized')
end

switch work.userpar1 %different noise level in dB SPL
case '80'
case '60'
case '40'
otherwise
   %error('illegal level')
end
% define noise signals in structure set
set.wishlevel = str2num(work.userpar1);
set.callevel = 91.5;		% This is with HDA 200 + Limiter Box + snd_pc_snd_ini(0.2) slider setting on Aureon Wave

%=================white noise===============================================
% The cutoff frequencies are 30Hz and 500Hz
wnoise_ref = bpnoise(def.intervallen, 30, 500, def.samplerate);
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
set.probelength = floor(0.005*def.samplerate);
set.probewin = hanning(set.probelength);
set.gaussiansignal = randn(set.probelength,1).*set.probewin;
%===============================================================

set.hannlen = round(0.05*def.samplerate);
set.window = hannfl(def.intervallen,set.hannlen,set.hannlen); 

%====================the window for pink noise of 500ms===================
% The length of the Hanning window is 1024 i.e. the windowed time is 512/44100
% = 10ms for the beginning or the end.
win = hanning(1024);
set.win =[ones(21538,1) ; win(513:1024); ones(9040,1)];
%==========================================================================


% eof