% example_cfg - example measurement configuration file -
%
% This matlab skript is called by afc_main when starting
% the experiment 'example'.
% example_cfg construdts a structure 'def' containing the complete
% configuration for the experiment.
% To design an own experiment, e.g., 'myexperiment'
% make changes in this file and save it as 'myexperiment_cfg.m'.
% Ensure that none of the entries is missing.
%
% See also help example_set, example_user, afc_main
%

% Copyright (c) 1999 Stephan Ewert, Universitaet Oldenburg.
% $Revision: 0.92 beta$  $Date: 2000/01/13 10:01:37 $

def=struct(...
'expname','loudsumspec',		...		% name of experiment   
'intervalnum',2,			...		% number of intervals
'ranpos',0,					...		% interval which contains the test signal: 1 = first interval ..., 0 = random interval
'rule',[1 1],				...		% [up down]-rule: [1 2] = 1-up 2-down
'startvar',-5,			...		% starting value of the tracking variable
'expvarunit','Level re ref/dB',		...		% unit of the tracking variable
'varstep',[8 4 2],	...      % [starting stepsize ... minimum stepsize] of the tracking variable
'minvar',-30,				...		% minimum value of the tracking variable
'maxvar',30,					...		% maximum value of the tracking variable
'steprule',-1,				...		% stepsize is changed after each upper (-1) or lower (1) reversal
'reversalnum',8,			...		% number of reversals in measurement phase
'exppar1',[200 400 800 1600 3200 6400],				...		% vector containing experimental parameters for which the exp is performed
'exppar1unit','Bandwidth/Hz',		...		% unit of experimental parameter
'repeatnum',2,				...		% number of repeatitions of the experiment
'parrand',[1],				...		% toggles random presentation of the elements in "exppar" on (1), off(0)
'mouse',0,					...		% enables mouse control (1), or disables mouse control (0)  
'markinterval',0,			...		% toggles visuell interval marking on (1), off(0)
'feedback',1,				...		% visuell feedback after response: 0 = no feedback, 1 = correct/false/measurement phase
'samplerate',48000,		...		% sampling rate in Hz
'intervallen',24000,		...		% length of each signal-presentation interval in samples (might be overloaded in 'expname_set')
'pauselen',24000,			...		% length of pauses between signal-presentation intervals in samples (might be overloaded in 'expname_set')
'presiglen',12000,				...		% length of signal leading the first presentation interval in samples (might be overloaded in 'expname_set')
'postsiglen',0,			...		% length of signal following the last presentation interval in samples (might be overloaded in 'expname_set')
'result_path','',			...		% where to save results
'control_path','',		...		% where to save control files
'messages','loudsumspec',	...		% message configuration file
'savefcn','default',		...		% function which writes results to disk
'interleaved',0,			...		% toggles block interleaving on (1), off (0)
'interleavenum',2,		...		% number of interleaved runs
'debug',0,					...		% set 1 for debugging (displays all changible variables during measurement)
'dither',0,					...		% 1 = enable +- 0.5 LSB uniformly distributed dither, 0 = disable dither
'bits',16,					...		% output bit depth: 8 or 16
'backgroundsig',0,		...		% allows a backgroundsignal during output: 0 = no bgs, 1 = bgs is added to the other signals, 2 = bgs and the other signals are multiplied
'terminate',1,				...		% terminate execution on min/maxvar hit: 0 = warning, 1 = terminate !!not used
'allowclient',0,			...		% clients for signal pregeneration: 0 = no clients, 1 = one client, 2 = two clients !!not used
'allowpredict',1,			...		% allows signal pregeration durin output if markinterval is disabled
'endstop',4,				...
'windetail',1,				...
'loadafcext',0,			...
'afcextname','pics'		...
);

% eof
