 function [N_,N] = loudness(mode,ELfq,ELerb,ELdB,thfq,thdB,alfacorfq,alfacor);
%
%    function [N_,N] =
%               loudness(mode,ELfq,ELerb,ELdB,thfq,thdB,alfafq,alfa);
%
% calculates specific Loudness and Loudness from excitation pattern.
% 
%    mode : discribes the mode for the calculation.
%           char1: formula for the calculation
%                  'z' for Zwickers model.
%                  'm' for Moores model.
%           char2: how to introduce sens. hearing impairment
%                  'i' internal noise model
%                  'l' S. Launers model
%           example: mode == 'mi' for Moores model with internal
%                  noise.
%    ELfq, ELerb, ELdB : frequency scale, erb scale (equally
%                        spaced) and corresponding excitation
%                        pattern in dBSPL. Parameters should be
%                        calculated with function excite.
%    thfq, thdB        : frequency scale in Hertz and corres-
%                        ponding auditory thresholds (dBHL).
%    alfacorfq, alfacor: frequency scale in Hertz and
%                        corresponding correction factor for
%                        'Zwickers Exponent'. 
%                        (optional, default alfacor = 1,
%                        expo = alfacor * alfa = 1 * 0.23)
%    N_   : vector of specific Loudness (sone/erb)
%    N    : Loudness (sone)
%
% see also: excite, excite_p, excite_d
%
% author/date : jens-e. appell / 1.95
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% constant parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exponent 'alfa' and constant factor 'factor' used for
% calculating spec. loudness were fitted as follows:
% 1) Middle ear correction in excite.m and Iso Threshold
%    in loudness.m were used.
% 2) Exponent alfa and factor were fitted for mode 'ml' so
%    that a 1kHz sine at 40, 50, 60, 70 dB produces a total
%    loudness of 1, 2, 4, 8 sone.
% remarks:
% -  alfa and factor have to be fitted for the other models.
% -  Moore fitted a factor of 0.0806 for his model which did
%    not include the ISO threshold and might not include the
%    middle ear correction (Moore,94).
%
if mode == 'mi',
	disp('LOUDNESS(): fuer option mi muessen factor und alfa noch angepaﬂt werden !!!');
	factor = 0.084;
	alfa   = 0.205;
elseif mode == 'ml',
	factor = 0.08521; 		% values calibrated with sine signals (ja 16.11.95)
	alfa   = 0.2036;
elseif mode == 'zi',
	disp('LOUDNESS(): fuer option zi muessen factor und alfa noch angepaﬂt werden !!!');
	factor = 0.13797;
	alfa   = 0.20932;
elseif mode == 'zl',
	disp('LOUDNESS(): fuer option zl muessen factor und alfa noch angepaﬂt werden !!!');
	factor = 0.13797;
	alfa   = 0.20932;
else,
	error('loudness(): wrong parameter mode');
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% check dimensions, parameters and interpolate to erb scale
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~(sum(nargin == [4 6 8])),
	error('loudness(): missing arguments');
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Excitation values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ELfq  = ELfq(:);
ELerb = ELerb(:);
ELdB  = ELdB(:);
if ~(size(ELfq) == size(ELerb) == size(ELdB)),
	error('excite(): vector dimensions must be the same');
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% auditory Threshold values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ISO Auditory Thresholds
erbisothdB = isothr(ELfq);

% Auditory Thresholds from audiogram [dB HL]
if nargin < 6,
	erbthdB = zeros(size(ELfq));
else,
	erbthdB = interp1(thfq(:),thdB(:),ELfq);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 'Zwickers exponent'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 8,
	erbalfa = alfa * ones(size(ELfq));
else
	erbalfacor = interp1(alfacorfq(:),alfacor(:),ELfq);
	erbalfa    = alfa * erbalfacor;
	clear erbalfacor;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculate loudness
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if mode == 'mi',
	N_ = 10.^(ELdB/10 .* erbalfa) - 10.^((erbisothdB+erbthdB)/10 .* erbalfa);
elseif mode == 'ml',
	N_ = 10.^((ELdB-erbthdB)/10 .* erbalfa) - 10.^(erbisothdB/10 .* erbalfa);
elseif mode == 'zi',
	N_ = 10.^((erbisothdB+erbthdB)/10 .* erbalfa) .* ((0.5 + (0.5 * 10.^((ELdB-(erbthdB+erbisothdB))/10))).^ erbalfa - 1);
elseif mode == 'zl',
	N_ = 10.^(erbisothdB /10 .* erbalfa) .* ((0.5 + (0.5 * 10.^((ELdB-erbthdB-erbisothdB)/10))).^ erbalfa - 1);
end;

% values below 0 set to zero
N_ = (N_ .* (N_ > 0)) * factor;	

% erb scale resolution
d_erb = ELerb(2) - ELerb(1);

% integrate specific loudness
N  =  sum(N_) * d_erb;

return;
%-------------------------------------------------------------------------
% changes :
%      02.05.95 / ja: interpolations set to linear instead of spline
%      15.05.95 / ja: some optimizations
%      16.11.95 / ja: adjusting of parameters alfa and factor for model 'ml'
%                     according to the new version of excite.m
%
%%-------------------------------------------------------------------------
%%
%%	Copyright (C) 1995   	Jens-E. Appell, Carl-von-Ossietzky-Universitat
%%	
%%	Permission to use, copy, and distribute this software/file and its
%%	documentation for any purpose without permission by the author
%%	is strictly forbidden.
%%
%%	Permission to modify the software is granted, but not the right to
%%	distribute the modified code.
%%
%%	This software is provided "as is" without express or implied warranty.
%%
%%
%%	AUTHOR
%%
%%		Jens-E. Appell
%%		Carl-von-Ossietzky-Universitat
%%		Fachbereich 8, AG Medizinische Physik
%%		26111 Oldenburg
%%		Germany
%%
%%		e-mail:		jens@hinz.physik.uni-oldenburg.de
%%
%%-------------------------------------------------------------------------

