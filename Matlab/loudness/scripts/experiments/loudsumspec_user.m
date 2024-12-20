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

function loudsumspec_user

warning off

global def
global work
global set

tref1 = real(ifft(scut(fft(randn(def.intervallen,1)),set.refLowCut,set.refUpCut,def.samplerate)));
tref1 = tref1 .* set.window;
tref1 = tref1/rms(tref1) * 10^((set.reflevel - set.callevel)/20);

tuser = real(ifft(scut(fft(randn(def.intervallen,1)),set.sigLowCut,set.sigUpCut,def.samplerate)));
tuser = tuser .* set.window;
tuser = tuser/rms(tuser) * 10^((work.expvaract + set.reflevel - set.callevel)/20);;

presig=zeros(def.presiglen,2);
postsig=zeros(def.postsiglen,2);
pausesig=zeros(def.pauselen,2);

work.signal=[tuser tuser tref1 tref1];	% left = right (diotic) first two columns must contain the test signal (left right)
work.presig=presig;											% must contain the presignal
work.postsig=postsig;										% must contain the postsignal
work.pausesig=pausesig;										% must contain the pausesignal

% eof