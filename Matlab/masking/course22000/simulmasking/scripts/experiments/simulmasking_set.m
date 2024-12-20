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

function simulmasking_set

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

% define signals in structure set
set.wishlevel = 75;
% set.callevel = 120.8;		% This is with HDA 200 + Limiter Box + RealTek High Definition Audio sound card speaker level set to 100 (Control Panel/Sound)
set.callevel = 111.7;		% This is with HD 380 pro + Limiter Box + RealTek High Definition Audio sound card speaker level set to 50 (Control Panel/Sound)
set.sine = sqrt(2) * sin([0:def.intervallen-1]'*2*pi*work.exppar1/def.samplerate);

centralfrequency = 1000;
% The equations below are used to calculate the lower and upper cutoff frequencies:
%     lcut = centre/2^(1/6)
%     ucut = centre*2^(1/6)
%     ucut-lcut=bandwidth
% where 2^(1/6) is the factor in one-third octave band

set.lcut = 891;
set.ucut = 1123;
% the bandwidth is 232 Hz

set.hannlen = round(0.05*def.samplerate);
set.window = hannfl(def.intervallen,set.hannlen,set.hannlen);

%===========startinglevel control==========================================
% In order to have more closer starting points of the pure tones, different
% starting level has to be assigned to each frequency.

switch work.exppar1
   case  500
      work.expvarnext = {[45]};
   case  630
      work.expvarnext = {[45]};
   case  800
      work.expvarnext = {[60]};
   case  1000
      work.expvarnext = {[80]};
   case  1250
      work.expvarnext = {[70]};
   case  1600
      work.expvarnext = {[60]};
   case  2000
      work.expvarnext = {[60]};
   otherwise
%       error('condition not recognized')
end
%==========================================================================

% eof