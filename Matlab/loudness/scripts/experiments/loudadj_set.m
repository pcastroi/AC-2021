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
global msg

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

switch work.exppar1
case 2
   %msg.ready_msg = 'Stellen Sie den Pegel des zweiten Signals so ein, dass Sie in als doppelt doppelt so laut wie das erste empfinden. Drücken Sie Taste 1 um den Pegel des zweiten Tones zu erhöhen und Taste 2 um ihn zu verringern.';
	%msg.ready_msg = 'War das zweite Signal mehr oder weniger als DOPPELT so laut wie das erste?        Taste 1: weniger,       Taste 2: mehr.';    
	msg.ready_msg = 'Adjust the signal in the second interval to be TWICE as loud as that in the first. Button 1: increase, Button 2: decrease.';    
case 0.5
   %msg.ready_msg = 'War das zweite Signal mehr oder weniger als HALB so laut wie das erste?        Taste 1: weniger,       Taste 2: mehr.';   
   %msg.ready_msg = 'dfjghkdfjghdk: Drücken Sie Taste 1 um den Pegel des zweiten Tones zu erhöhen und Taste 2 um ihn zu verringern.';
	msg.ready_msg = 'Adjust the signal in the second interval to be HALF as loud as that in the first. Button 1: increase, Button 2: decrease.';    
otherwise
   error('parameter not recognized')
end

work.expvarnext{1} = def.startvar{1} + floor( rand(1,1)*11 - 5 );

% define signals in structure set
set.wishlevel = 60;
% set.callevel = 91.5;    % This is with JDA 200 + Limiter Box + snd_pc_snd_ini(0.2) slider setting on Aureon Wave
% set.callevel = 120.8;		% This is with HDA 200 + Limiter Box + RealTek High Definition Audio sound card speaker level set to 100 (Control Panel/Sound)
set.callevel = 113.5;		% Sennheiser HD 380 pro directly in PC headphone port, DTU B352 R005, 50% windows volume setting




set.sine = sqrt(2) * sin([0:def.intervallen-1]'*2*pi*1000/def.samplerate);

set.hannlen=round(0.05*def.samplerate);
set.window = hannfl(def.intervallen,set.hannlen,set.hannlen);

% eof
