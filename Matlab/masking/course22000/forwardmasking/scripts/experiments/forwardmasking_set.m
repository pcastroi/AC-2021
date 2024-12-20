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
% set.callevel = 120.8;		% This is with HDA 200 + Limiter Box + RealTek High Definition Audio sound card speaker level set to 100 (Control Panel/Sound)
set.callevel = 111.7;		% This is with HD 380 pro + Limiter Box + RealTek High Definition Audio sound card speaker level set to 50 (Control Panel/Sound)



set.hannlen = round(0.05*def.samplerate);
set.window = hannfl(def.intervallen,set.hannlen,set.hannlen); 

%====================the window for lowpass noise of 500ms===================
% The length of the Hanning window is 4096 i.e. the windowed time is 2048/44100
% = 40ms for the beginning or the end.
win = hanning(4096);
set.win =[ones(20002,1) ; win(2049:4096); ones(9040,1)];
%==========================================================================


% eof