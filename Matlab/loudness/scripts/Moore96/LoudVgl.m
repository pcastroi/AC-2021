function eqLvl = LoudVgl(vRefSig, RefLvl, vSig, fs, flags)
% LoudVgl	simulation to get equal loudness
%
% syntax: eqLvl = LoudVgl(vRefSig, RefLvl, vSig, SigLvl, fs)
%
% input:  vRefSig  reference signal vector
%         RefLvl   reference signal level
%         vSig     signal to be matched in loudness
%         fs       sampling frequency
%         flags    'v' for verbose and 'l' for logfile
%
% output: eqLvl    Level of vSig to be equal loud as Refsig

% (c) of, 2003 Aug 14
% Last Update: 2003 Aug 28

if ~exist('flags','var'),
  flags = [];
end
bLog = ~isempty(find(flags=='l'));
bVerbose = ~isempty(find(flags=='v'));

maxStep = 8;		% maximum step size (start)
minStep = 1;		% minimum step size

% open logfile
if bLog,
  logfname = sprintf('%s.log',mfilename);
  loghndl = fopen(logfname,'wt');
end

% calculate loudness of reference signal
Nref = CalcLoud(vRefSig,fs,RefLvl);
if bVerbose,
  disp(sprintf('reference: N = %1.5f sone',Nref));
end
if bLog,
  fprintf(loghndl,'reference: N = %1.5f sone\n',Nref);
end

% loudness matching
i = 0;
dBStep = maxStep;
Lvl(1) = RefLvl;
while (1)
  % scale signal
  i = i + 1;				% number of Trials
  tstval = (Lvl == Lvl(i));		% did we already had this level?
  if sum(tstval) > 1,			% if yes:
    ind = find(tstval);			% get the indices of the level
    Ntst(i) = Ntst(ind(1));		% use the old value
  else					% otherwise:
    Ntst(i) = CalcLoud(vSig,fs,Lvl(i));	% calculate the loudness
  end
  Ndiff = Nref - Ntst(i);		% loudness difference
  if Ndiff > 0,				% reference louder?
    if (i > 1)  &  (Lvl(i-1) > Lvl(i)),	% should stepsize be decreased?
      dBStep = dBStep/2;
      if dBStep < minStep,		% are we finished?
        break;
      end
    end
    Lvl(i+1) = Lvl(i) + dBStep;		% yes: increase by dBStep
  elseif Ndiff < 0,
    if (i > 1)  &  (Lvl(i-1) < Lvl(i)),	% should stepsize be decreased?
      dBStep = dBStep/2;
      if dBStep < minStep,		% are we finished?
        break;
      end
    end
    Lvl(i+1) = Lvl(i) - dBStep;		% no: decrease by dBStep
  else					% condition: Ndiff == 0
    break;
  end
  % logging
  if bVerbose,
    disp(sprintf('Trial %i:  Lvl=%1.1f;  N=%1.5f sone;  Ndiff=%1.5f;  dBStep=%1.1f', ...
                  i,Lvl(i),Ntst(i),Ndiff,dBStep));
  end
  if bLog,
    fprintf(loghndl,'Trial %i:  Lvl=%1.1f;  N=%1.5f sone;  Ndiff=%1.5f;  dBStep=%1.1f\n', ...
                    i,Lvl(i),Ntst(i),Ndiff,dBStep);
  end
end % while(1)

index = find(min(abs(Ntst-Nref)) == abs(Ntst-Nref));
if (length(index) > 1)  &  (sum(diff(Lvl(index))) ~= 0),
  disp(sprintf('%sunexpected condition!',7));
  disp('entering debug mode...');
  keyboard
end
eqLvl = Lvl(index(1));

if bVerbose,
  disp(sprintf('Trial %i:  Lvl=%1.1f;  N=%1.5f sone;  Ndiff=%1.5f', ...
                i,Lvl(i),Ntst(i),Ndiff));
  disp(sprintf('equal loud: RefLvl=%1.1f; Lvl=%1.1f',RefLvl,eqLvl));
end
if bLog,
  fprintf(loghndl,'Trial %i:  Lvl=%1.1f;  N=%1.5f sone;  Ndiff=%1.5f\n', ...
                  i,Lvl(i),Ntst(i),Ndiff);
  fprintf(loghndl,'equal loud: RefLvl=%1.1f; Lvl=%1.1f',RefLvl,eqLvl);
  % Protokoll-Datei schliessen
  fclose(loghndl);
end

