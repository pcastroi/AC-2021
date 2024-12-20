function calmixer
% CALMIXER  sets the windows sound mixer to calibrated values
%
% see also SND_PC_INI, SND_MIXER_INFO

% (c) of, 2004 Feb 04
% Last Update: 2004 Aug 03
% Timestamp: <calmixer.m Tue 2004/08/03 13:59:56 OF@OFPC>

factor = 0.2;                          % thus set.callevel = 91.5 in *_set.m
snd_pc_snd_ini(factor);
