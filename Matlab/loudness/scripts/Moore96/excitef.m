 function [vELFre,vELErb,vELDB,vELInt] = excitef(vCFre,vCDB,vMFre,vMDB);
%
%    function [vELFre, vELErb, vELDB, vELInt] =
%                       excitef(vCFre, vCDB, vMFre, mecdb);
%
% calculates excitation patterns from spectrum vCDB given
% by any number of components in dB (Minimum are 2 components).
% The middle ear correction using vMDB is optional.
% All frequency scales must increase monotonously, a linear
% scale is not required.
% If parameters vMFre and mecdb are omitted standard values
% will be used.
% Dependent on the size of vCDB different calculation
% strategies will be used to optimize for speed or for
% memory usage.
%
% vCFre, vCDB : spectrum components as frequency-level pair.
% vMFre, vMDB : frequency vector and middle ear correction
%               in dB.
% vELFre     : frequency scale corresponding to vELErb
% vELErb     : erb scale with 0.1 erb resolution corresponding
%              vELDB and vELInt
% vELDB      : excitation in dB
% vELInt     : excitation as intensity
%
% See also   : excite_d (demo),
% Uses       : erb2freq, freq2erb, interpjm
%
% author/date : jens-e. appell / 1.95
% last change : jens-e. appell / 5.98
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% constant params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% C1, C2, c3 empirical factors for calculations between erb and frequency scales.
C1        = 24.673;
C2        = 4.368;
C3        = (2302.6/(C1*C2));

% empirical value for filter symmetry at 1kHz
P51_1K    = 4.0 * 1000.0/(C1*(C2 + 1.0));

% first and last erb band and stepsize in between for calculating excitation.
ELERBSTART    = 3.0;
ELERBEND      = 36.0;
ELERBSTEP     = 0.1;

% half of the bandwidth in erb the intensity will be summed linear.
ERB_WIDTH = 0.5;

% if 1 the audit. filter shape to higher frequencies will be level dependent.
filter_depending_level = 1;

% Minimum of excitation value. Values below will be set to it.
ELINT_MIN = 1.0e-10;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% check dimensions and parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~(sum(nargin == [2 4])),
	error('excite(): missing arguments');
end;

vCDB  = vCDB(:);
vCFre = vCFre(:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% disp(' kick out irrelevant data');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vi = find( (vCDB>(-50))   );
vCDB  = vCDB(vi);
vCFre = vCFre(vi);
nComp = length(vCFre);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% recalculation of vCDB using the middle ear correction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (nargin < 3),
	vMFre = [
		0,		20,	25,	30,	35,	40,	45,	50,	55,	60,	70,...
				80,	90,	100,	125,	150,	177,	200,	250,	300,	350,...
				400,	450,	500,	550,	600,	700,	800,	900,	1000,	1500,...
				2000,	2500,	2828,	3000,	3500,	4000,	4500,	5000,	5500,	6000,...
				7000,	8000,	9000,	10000,12748,15000,...
		20000
	]';
	vMDB = [
		31.8,	31.8,	26.0,	21.7,	18.8,	17.2,	15.4,	14.0,	12.6,	11.6,	10.6,...
				9.2,	8.2,	7.7,	6.7,	5.3,	4.6,	3.9,	2.9,	2.7,	2.3,...
				2.2,	2.3,	2.5,	2.7,	2.9,	3.4,	3.9,	3.9,	3.9,	2.7,...
				0.9, -1.3, -2.5, -3.2, -4.4, -4.1, -2.5, -0.5,	2.0,	5.0,...
				10.2,	15.0,	17.0,	15.5,	11.0,	22.0,...
		22.0
	]';
end;

mec1k = interp1(vMFre(:),vMDB(:),1000);
vMDB  = interpjm(vMFre(:),vMDB(:),vCFre);
vCDB  = vCDB - vMDB + mec1k;
vCInt = 10.0 .^(vCDB/10.0); % Intensity of inout spectrum
vCErb = freq2erb(vCFre);   % erb scale
clear vCDB;
clear vMDB;
clear vMFre;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% start calculation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calc intensity in the erb bands
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create logical matrix to sum components
moSumBins =              (vCErb(:,ones(1,nComp)) > (ones(nComp,1)*(vCErb-ERB_WIDTH)') );	% TRUE for all higher
moSumBins = moSumBins .* (vCErb(:,ones(1,nComp)) < (ones(nComp,1)*(vCErb+ERB_WIDTH)') );	% TRUE for all in between
clear vCErb;

% calculate intensity in erb bands as sum over the columns 
vCSumDB  = 10.0 * log10(  (sum(moSumBins .* (vCInt*ones(1,nComp))))'  );
clear moSumBins;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calc excitation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% frequency scales
vELFre = erb2freq([ELERBSTART:ELERBSTEP:ELERBEND]');
nEL    = size(vELFre,1);

% calc. weighted frequency distance 'g'
mG     = vELFre * ones(1,nComp);								% EL freqs in each column
mG     = ( (ones(nEL,1)*vCFre') - mG) ./ mG;	% dist between Comp. and EL freqs
clear vCFre;

% values for lower skirt of audit. filter, others are 0
% empirical value for filter symmetry, (C1*(C2*vELFre/1000.0+1.0)) == bandwidth at the center frequency
mP51   = (4.0 * vELFre./(C1 * (C2 * vELFre * 0.001 + 1.0))) * ones(1,nComp);
mEDB   = ones(nEL,1) * vCSumDB';
clear vCSumDB;
mPLower = (mG <  0)    .* (  mP51 - ((0.380/P51_1K * mP51)   .*    (mEDB - 51.0))  );

% values for upper skirt of audit. filter, others are 0
if filter_depending_level == 1,
	mPUpper = (mG >= 0) .* (  mP51 + ((0.118/P51_1K * mP51)   .*    (mEDB - 51.0))  );
else
	mPUpper = (mG >= 0) .*    mP51;
end;                  
clear mP51;
clear mEDB;

% combine values
mPAbsG = (mPLower + mPUpper) .* abs(mG);                

% calc intensity using rounded exponential audit. filter.
% vector compintensity holds all intensities of all
% components weighted with the audit. filters.
% set values of G above 2 to value 0
compintensity = (1.0 + mPAbsG ) .* exp(-mPAbsG)  .* (ones(nEL,1)*vCInt') .* (mG<=2);
clear mG;
clear mPAbsG;

% calc total intensity of the excitation pattern, set minimum to ELINT_MIN
if (1 == min(size(compintensity))),
	vELInt = compintensity;
else,
	vELInt = sum(compintensity')';
end;
vELInt = (vELInt < ELINT_MIN) * ELINT_MIN   +   (vELInt >= ELINT_MIN) .* vELInt;
clear compintensity;

% calc the rest of the required values
vELDB    = 10.0 * log10(vELInt);
vELErb   = freq2erb(vELFre);

return;
%-------------------------------------------------------------------------
% changes:
%          02.05.95/ja : interp1 now performs linear interpolation
%                        instead of spline interpolation
%          25.05.95/ja : mec1k added in excite_p.m and calculation
%          10.11.95/ja : in speed zero intensity summation via index in the
%                        component vector
%          10.11.95/ja : param. file excite_p is deleeted, parameters are included 
%                        in this file.
%          12.11.95/ja : P51 =4.0*vELFre./(C1* C2*vELFre/1000.0+C1 )  changed to
%                        P51 =4.0*vELFre./(C1*(C2*vELFre/1000.0+1.0))
%                        corresponding to brian glasbergs calculation. This
%                        leads to a difference app. 2 dB for broadband signals.
%          12.11.95/ja : Speed -1 introduced for testing.
%          12.11.95/ja : nargin == 3 results in speed equals the third argument,
%                        for middle ear correction default values will be taken.
%          17.06.96/ja : all speed stuff kicked out.
%          10.06.97/ja : criterion
%									vi = find( (vCDB>(-50))  &  (erb2freq(ELERBSTART) <= vCFre) );
%								 changed to
%									vi = find( (vCDB>(-50)) );
%								 Data for such low freqs is still unwanted but this change allows
%								 a call for spectra with very low freqs (needed in betterio.m)
%				13.06.97/ja: interp1 replaced by interpjm
%				13.05.98/ja: some documentation
%%-------------------------------------------------------------------------
%%
%%	Copyright (C) 1995,1998   	Jens-E. Appell, Carl-von-Ossietzky-Universitat
%%	
%%	Permission to use, copy, and distribute this software/file and its
%%	documentation for any purpose without permission by the author
%%	is strictly forbidden.
%%
%%	Permission to modify the software is granted, but not the right to
%%	distribute the modified code.
%%
%%	This software is provided "as is" without expressed or implied warranty.
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
%%		e-mail:		jens@medi.physik.uni-oldenburg.de
%%
%%-------------------------------------------------------------------------

