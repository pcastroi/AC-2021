function LoudSumm
% LoudSumm	Show effect of loudness summation
%
% all stimuli: 300-ms Gaussian noise, geometrically centered at 2 kHz, 45 dB SPL
% reference:   3200 Hz bandwidth
% all other:   [200 400 800 1600 6400] Hz bandwidth

% (c) ow 2003 Aug 15
% Last Update: 2003 Sep 12

fs = 44100;	% sampling frequency
fc = 2000;	% center frequency in Hz
dur = 300;	% duration in ms
RefBW = 3200;	% in Hz
RefLvl = 55;	% in dB SPL
BW = [200 400 800 1600 3200 6400];

% get the cut-off frequencies f1 and f2
f1Ref = -RefBW/2+sqrt(RefBW.^2/4+fc.^2);
f2Ref = f1Ref + RefBW;
f1 = -BW/2+sqrt(BW.^2/4+fc.^2);
f2 = f1 + BW;

% window settings
slen = dur/1000*fs;                      % length in samples
hannlen = round(0.05*fs);                 % length of hanning window
hannwin = hannfl(slen,hannlen,hannlen);  % hanning window

dLvl = zeros(length(RefLvl),length(BW));	% initialize 'empty' matrix
legLbl = cell(size(RefLvl));			% empty labels for legend
for iRef = 1:length(RefLvl),			% for each reference level
  vRefSig = real(ifft(scut(fft(randn(slen,1)),f1Ref,f2Ref,fs))); % reference signal
%  vRefSig = gnoise(dur,f1Ref,f2Ref,RefLvl(iRef),1,fs);	% reference signal
  disp(sprintf('Reference Level: %d dB SPL:',RefLvl(iRef)));
  for iBW = 1:length(BW),				% for each bandwidth
    disp(sprintf('Matching for a bandwidth of %d Hz...',BW(iBW)));
    vSig = real(ifft(scut(fft(randn(slen,1)),f1(iBW),f2(iBW),fs))); % generate signal
%        gnoise(dur,f1(iBW),f2(iBW),RefLvl(iRef),1,fs);	% generate signal
    Lvl = LoudVgl(vRefSig,RefLvl(iRef),vSig,fs);	% match the loudness
    dLvl(iRef,iBW) = Lvl-RefLvl(iRef);
  end
  legLbl{iRef} = sprintf('L_{Ref} = %d dB SPL',RefLvl(iRef));
end

semilogx(BW,dLvl,'o-');
xlabel('bandwidth in Hz');
ylabel('level difference in dB');
title('loudness summation effect');
set(gca,'XTick',BW,'XMinorTick','off');
xlim([min(BW)/1.2 max(BW)*1.2])
ylim([-7 17])
hLine = line(xlim,[0 0]);
set(hLine,'LineStyle',':');
legend(legLbl);
