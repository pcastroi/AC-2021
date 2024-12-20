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

function loudadj_set

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

   %set.level=0.05;
otherwise
   error('condition not recognized')
end

set.refBW = 3200;
set.centerF = 2000;

% calculate lower and upper cutoff freq (centerF is geometric mean of band with width BW)
set.refLowCut = -set.refBW/2 + sqrt((set.refBW/2)^2 + set.centerF^2);
set.refUpCut = set.centerF^2/set.refLowCut;

set.sigLowCut = -work.exppar1/2 + sqrt((work.exppar1/2)^2 + set.centerF^2);
set.sigUpCut = set.centerF^2/set.sigLowCut;


% define signals in structure set
set.reflevel = 55;
% set.callevel = 91.5;    % This is with JDA 200 + Limiter Box + snd_pc_snd_ini(0.2) slider setting on Aureon Wave
% set.callevel = 120.8;		% This is with HDA 200 + Limiter Box + RealTek High Definition Audio sound card speaker level set to 100 (Control Panel/Sound)
set.callevel = 109.5;		% Sennheiser HD 380 pro directly in PC headphone port, DTU B352 R005, 50% windows volume setting

set.hannlen=round(0.05*def.samplerate);
set.window = hannfl(def.intervallen,set.hannlen,set.hannlen);

% eof
