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

% 20/09/2007 update by SES
% def.pauselen line 102 was commented out because it did not set the pause
% duration to a fixed 500ms


function loudtempint_set

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

set.refDur = 160;
set.sigFreq = 1000;

set.refDurSmp = round(set.refDur/1000*def.samplerate);
set.sigDurSmp = round(work.exppar1/1000*def.samplerate);

def.intervallen = max([set.refDurSmp set.sigDurSmp]);

set.hannlen=round(0.005*def.samplerate);
set.refWindow = hannfl(set.refDurSmp,set.hannlen,set.hannlen);
set.sigWindow = hannfl(set.sigDurSmp,set.hannlen,set.hannlen);

% reference tone
refTone = sin(2*pi*set.sigFreq*[0:set.refDurSmp-1]'/def.samplerate);
refTone = refTone .* set.refWindow;
refTone = refTone/rms(refTone);

% fringe of zeros to center stimulus in interval
refToneZeros = (def.intervallen - set.refDurSmp)/2;

if refToneZeros > 0
	set.tref1 = [zeros(refToneZeros,1); refTone; zeros(refToneZeros,1)];
else
	set.tref1 = refTone;
end

% now sig tone
sigTone = sin(2*pi*set.sigFreq*[0:set.sigDurSmp-1]'/def.samplerate);
sigTone = sigTone .* set.sigWindow;
sigTone = sigTone/rms(sigTone);

% fringe of zeros to center stimulus in interval
sigToneZeros = (def.intervallen - set.sigDurSmp)/2;

if sigToneZeros > 0
	set.tuser = [zeros(sigToneZeros,1); sigTone; zeros(sigToneZeros,1)];
else
	set.tuser = sigTone;
end

% adjust def.pauselen so that the pause between the two tones is half a second
% def.pauselen = def.samplerate/2 - set.refDurSmp - set.sigDurSmp


% define signals in structure set
set.reflevel = 55;
% set.callevel = 91.5;    % This is with JDA 200 + Limiter Box + snd_pc_snd_ini(0.2) slider setting on Aureon Wave
% set.callevel = 120.8;		% This is with HDA 200 + Limiter Box + RealTek High Definition Audio sound card speaker level set to 100 (Control Panel/Sound)
set.callevel = 110;		% Sennheiser HD 380 pro directly in PC headphone port, DTU B352 R005, 50% windows volume setting



% eof
