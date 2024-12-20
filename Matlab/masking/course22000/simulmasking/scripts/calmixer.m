function calmixer
% CALMIXER  sets the windows sound mixer to calibrated values
%
% see also SND_PC_INI, SND_MIXER_INFO

% (c) of, 2004 Feb 04
% Last Update: 2004 Feb 17
% Timestamp: <calmixer.m Tue 2004/02/17 16:01:41 OF@OFPC>

factor = 0.2;
snd_pc_snd_ini(factor);
