% addpath([fileparts(which(mfilename)), filesep, '..\..\CAHR\afc\scripts'])
% addpath([fileparts(which(mfilename)), filesep, '..\..\CAHR\afc\base'])
% addpath([fileparts(which(mfilename)), filesep, '..\..\CAHR\afc\calibration'])
% addpath([fileparts(which(mfilename)), filesep, '..\..\CAHR\afc\gui'])
% % addpath([fileparts(which(mfilename)), filesep, '..\..\CAHR\snd'])
 addpath([fileparts(which(mfilename)), filesep, 'scripts'])
 addpath([fileparts(which(mfilename)), filesep, 'scripts' filesep 'experiments'])
 % % Turn Matlab error sound off
 beep off
% calmixer
 run(['..' filesep '..' filesep 'CAHR' filesep 'afc' filesep 'afc_addpath.m']);