 function [vELFre,vELErb,vELDB,vELInt,vN,N] = loud96(vCFre,vCDB,vMFre,vMDB,vTHRFre,vTHRDB,vOHCFre,vOHCDB,vlDFre,vhDFre,bFF,bBin);
%
%    function [vELFre, vELErb, vELDB, vELInt, vN, N]] =
%                       loud96( vCFre    , vCDB,
%                               vMFre    , vMDB,
%                               vTHRFre  , vTHRDB,
%                               vOHCFre  , vOHCDB,
%                               vlDFre   , vhDFre
%                               bFF,
%                               bBin,
%                       );
%
% calculates excitation patterns and loudness from spectrum components
% vCDB (Minimum are 2 components). Calcultation performs according to
% 'loud.for' version 3.0 from 2nd Feb 1996, written by Brian Glasberg.
% A detailed description of the model is given in :
% BCJ Moore and BR Glasberg: A Model of Loudness Perception Applied
% to Cochlear Hearing Loss, Heardip Report 17th March 1996.
%
% Parameters: - vXXXFre stands for the frequency scale of vXXX
%             - vXXXErb stands for the erb scale of vXXX
%             - vXXXDB  stands for dB values in vXXX
%             - vXXXInt stands for Intensity (non dB) values in vXXX
% Note: vectors vM, vTHR, vOHC will be interpolated, therefore data
%       may be required for a wide frequency range. If you choose a
%       range from 0Hz to 20kHz you are on the save side.
%
% vCDB     : spectrum components
% vMDB     : headphone correction given in dBSPL at the eardrum. vMDB will
%            be subtracted from vCDB even in the free field condition.
%            (vM = [] -> flat responce of headphone is assumed,
%            in the free field condition only the 
% vTHRDB   : thresholds in dBHL (vM = [] -> use default)
% vOHCDB   : DBs contributing to 'OHC-loss'. vOHCDB must be smaller then vTHRDB !
%            (vOHCDB = [] -> vOHCDB = 0.8*vTHRDB with limits)
% vlDFre, vhDFre : lower and upper limits of dead regions
% bFF      : bFF  ~= 0 or bFF  = [] -> free field presentation (ELC correction is applied)
%            bFF  == 0 -> headphone presentation (ELC - (Transfer FF->EarDrum) is applied)
% bBin     : bBin ~= 0 or bBin = [] -> Binaural presentation,
%            bBin == 0 -> Monaural presentation (-2dB for (OHC)THR when calculating loudness)
%
% vEL      : excitation level
% vN       : specific loudness (use vELFre or vELErb as frequency scale)
% N        : (total) loudness in sones
%
% author/date : jens-e. appell / 6.96
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% disp(' constant params');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
CONST   = 0.0955808;
ALFA    = 0.1953224;
C1      = 24.673;
C2      = 4.368;
invP51_1K  = 1 / (4000.0 / (C1*(C2 + 1.0)));
% scale on which excitation will be calculated
dELErb  = 0.25;
vELErb  = [0.6:dELErb:39.0]';
% default fraction of OHC part
OHCFrac = 0.8;
% frequency scale for the constant correction data
vXXXFre = [0    20    25   31.5 40   50   63   80   100  125  160 200   250  315  400  500  630  800  1000 1250 1600 2000 2500 3150 4000 5000 6300 8000 10000 12500 15000 20000]';
% ELC correction relative 0.0 dB to 1 kHz
vELCDB  = [25.8 25.7  21.4 16.6 12.6 10.1 7.9  5.6  3.6  1.8  0.1 -1.3  -2.2 -2.8 -2.7 -2.6 -1.9 -1.0 0.0  -0.5 -1.6 -3.2 -5.4 -7.8 -8.1 -5.3 2.4  11.1 12.2  7.4   17.8  17.8 ]';
% MAF correction relative 0.0 dB to 1 kHz
vMAFDB  = [75.8 70.1  60.8 52.1 44.2 37.5 31.3 25.6 20.9 16.5 12.6 9.6  7.0  4.7  3.0  1.8  0.8  0.2  0.0  -0.5 -1.6 -3.2 -5.4 -7.8 -8.1 -5.3 2.4  11.1 12.2  7.4   17.8  17.8 ]';
% MID correction = ELC correction - (Transferfunction between free field and eardrum)
vMidDB  = [25.8 25.7  21.4 16.6 12.6 10.1 7.9  5.6  3.6  1.9  0.4  -0.8 -1.2 -1.4 -1.1 -0.9 0.6  1.6  2.6  2.7  5.0  8.8  11.4 7.4  6.1  5.4  8.8  12.9 10.6  5.7   16.0  16.2 ]';

vCFre   = vCFre(:);
vCDB    = vCDB(:);
nEL     = length(vELErb);
vELFre  = erb2freq(vELErb);
lCFre   = min(vCFre);
hCFre   = max(vCFre);
lELFre  = min(vELFre);
hELFre  = max(vELFre);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% disp(' kick out irrelevant data');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vi = find( (vCDB>(-50))  &  (min(vELFre)<=vCFre) );
vCDB  = vCDB(vi);
vCFre = vCFre(vi);
nC    = length(vCFre);
vCInt = 10.0 .^(vCDB / 10.0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% disp(' chk arguments and calc OHC loss on scale "vTHRFre"');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin ~= 12,
	error('loud96(): 12 arguments required. Empty vectors indicate use of default parameters');
end;

if isempty(bBin),
	bBin = 1;
end;
if isempty(bFF),
	bFF  = 1;
end;
if isempty(vlDFre),
   vlDFre = 0;
   vhDFre = 0;
else
   vlDFre = vlDFre(:);
   vhDFre = vhDFre(:);
end;
if isempty(vTHRDB),
   vTHRFre = [lELFre hELFre]';
   vTHRDB  = [0      0     ]';
else
   vTHRFre = vTHRFre(:);
   vTHRDB  = vTHRDB(:);
   if min(vTHRFre) > lELFre,
      vTHRFre = [lELFre    ; vTHRFre]; 	
      vTHRDB  = [vTHRDB(1) ; vTHRDB ];
   end;
   if max(vTHRFre) < hELFre,
      vTHRFre = [vTHRFre ;                hELFre]; 	
      vTHRDB  = [vTHRDB  ;vTHRDB(length(vTHRDB))];
   end;
end;
if isempty(vOHCDB),
   vOHCFre = vTHRFre(:);
   vOHCDB  = OHCFrac * vTHRDB;
   i  = find((vOHCFre <= 1000) & (vOHCDB > 55));
   vOHCDB(i) = 55 + zeros(size(i));
   i  = find((vOHCFre > 1000) & (vOHCDB > 65));
   vOHCDB(i) = 65 + zeros(size(i));
else
   vOHCDB  = vOHCDB(:);
   vOHCFre = vOHCFre(:);
   if min(vOHCFre) > lELFre,
      vOHCFre = [lELFre    ; vOHCFre]; 	
      vOHCDB  = [vOHCDB(1) ; vOHCDB ];
   end;
   if max(vOHCFre) < hELFre,
      vOHCFre = [vOHCFre ;                hELFre]; 	
      vOHCDB  = [vOHCDB  ;vOHCDB(length(vOHCDB))];
   end;
end;
if isempty(vMDB),
	vMFre = [lCFre hCFre]';;
	vMDB  = [0     0    ]';
else
   vMFre = vMFre(:);
   vMDB  = vMDB(:);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% disp(' apply linear corrections and calc component intensity');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vCDB  = vCDB - interp1(vMFre, vMDB, vCFre);
if bFF,
   vCDB  = vCDB - interp1(vXXXFre, vELCDB, vCFre);
else,
   vCDB  = vCDB - interp1(vXXXFre, vMidDB, vCFre);
end;
clear vMFre;
clear vMDB;
clear vMidDB;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% disp(' calc total level in roex(p) filter round each input component');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mP     = (4.0 * vCFre ./ (C1 * (C2 * vCFre * 0.001 + 1.0))) * ones(1,nC);
mG     = vCFre * ones(1,nC);
mG     = abs(mG./mG' - 1);
m      = abs(mG) .* mP;
m      = (1.0 + m) .* exp(-m)  .* (ones(nC,1) * vCInt') .* (mG <= 4);
vERBDB = 10.0 * log10(  sum(m')'  );
clear mP;
clear mG;
clear m ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% disp(' Transform THR, OHC to "vELFre" and calculate IHC loss');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vTHRDB = interp1(vTHRFre, vTHRDB, vELFre);
vOHCDB = interp1(vOHCFre, vOHCDB, vELFre);
vIHCDB = vTHRDB - vOHCDB;
% following limitations set IHC<0 to 0 and then OHC=THR (MAGIC)
vOHCDB = vOHCDB .* (vIHCDB >= 0.0) + vTHRDB .* (vIHCDB < 0.0);
vIHCDB = vIHCDB .* (vIHCDB >  0.0);
clear vTHRFre;
clear vOHCFre;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% disp(' calc broadening of the filters due to OHC loss');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
v  = (vOHCDB - 22.0).*(vOHCDB <= 55.0) + 33.0*(vOHCDB > 55.0);
v  = 0.01757 * v;
vBroad =          (vELFre <  1000) .* 10.^(v ./ (1.0 - 0.355 * log10(vELFre * 0.001)));
vBroad = vBroad + (vELFre >= 1000) .* 10.^(v);
vBroad = vBroad .* (vBroad >= 1.0) + 1.0 .* (vBroad <   1.0);
vBroad = vBroad .* (vOHCDB > 22.0) + 1.0 .* (vOHCDB <= 22.0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% disp(' calc excitation level');
% mPXXX : specifies filter slopes.
% mP51  : filter slope at 51dB
% mPLL  : specifies level dependency of slope to lower freq.
% mP    : filter slope with two restrictions: 1. slopes
%         are only level dependent to lower frequencies (mG<0.0)
%         and P values are allways >= 0.1
% m     : 1) frequency distance in octaves. I.E < 0.0 for
%            component freqs 'vCFre' lower than current EL
%            freq. 'vELFred'. -> 'g value'
%         2) m will be redifined to m = abs(m) .* mP
%            -> 'temporary needed'
%         3) m holds intensities (each row holds the filtered
%            component intensity at the filter center
%            frequency given by the row index. The sum
%            accross one row is therefore the total
%            intensity at the filter center frequency)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mP51 = (  4.0 * vELFre ./ (C1 * (C2 * vELFre * 0.001 + 1.0) .* vBroad)  ) * ones(1,nC);
mG   = (ones(nEL,1) * vCFre') ./ (vELFre * ones(1,nC)) - 1;
vPLL = 0.38 - (0.38/3) * (vBroad - 1);
mPLL = (vPLL .* (vPLL >= 0.0) ) * ones(1,nC);
mP   = mP51 - ( ((mPLL.*mP51)*invP51_1K) .* ((ones(nEL,1)*vERBDB')-51.0) .* (mG < 0.0) );
mP   = mP .* (mP>0.1) + (0.1*(mP<=0.1));
m    = abs(mG) .* mP;
clear mP;
clear mP51;
clear mPLL;
clear vCFre;
m    = (1.0+m) .* exp(-m) .* (ones(nEL,1)*vCInt') .* (mG <= 4);
if (1 == min(size(m))),
	vELInt = m;
else,
	vELInt = sum( m' )';
end;
clear m;
vELInt = (vELInt < 1.0e-10) * 1.0e-10  +  (vELInt >= 1.0e-10) .* vELInt;
vELDB  = 10.0 * log10(vELInt);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% disp(' set excitation level to -100dB within dead regions');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i  = vELFre * ones(1,length(vlDFre));
i  = (i > ( ones(nEL,1)*vlDFre' ))   &   (i < ( ones(nEL,1)*vhDFre' ));
if (1 == min(size(i))),
	i  = find(sum(i'));
else
	i  = find(i);
end;
vELDB(i)  = zeros(size(i)) - 100;
vELInt(i) = zeros(size(i)) + 1.0e-10;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% disp(' calculate specific and total loudness');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (bBin), BinMonCorr = 4.2;
else,      BinMonCorr = 6.2;
end;
v =     interp1(vXXXFre, vMAFDB, vELFre);
v = v - interp1(vXXXFre, vELCDB, vELFre);
vELTHRDB = BinMonCorr + vOHCDB;
vELTHRDB = vELTHRDB.*(vELFre >= 1000.0) + (vELTHRDB + v).*(vELFre < 1000.0);
vN = 10.^( (vELDB-vIHCDB)/10 * ALFA ) - 10.^(vELTHRDB/10 * ALFA);
vN = (CONST * dELErb) * (vN .* (vN > 0.0));
vN = vN.* (vELDB > vELTHRDB);
N  = sum(vN);

return;
%%-------------------------------------------------------------------------
%%
%%	Copyright (C) 1996  	Jens-E. Appell, Carl-von-Ossietzky-Universitat
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
%%		e-mail:		jens@hinz.physik.uni-oldenburg.de
%%
%%-------------------------------------------------------------------------

