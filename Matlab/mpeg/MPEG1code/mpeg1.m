function [G,SM,SCF]=mpeg1(x,fs)
%   
%   [G,SM,SCF]=MPEG1(x,fs)
%
%   x is the signal column vector
%   fs is the sampling frequency, set to 44100 if omitted
%
%   Author: Fabien A. P. Petitcolas
%           Computer Laboratory
%           University of Cambridge
%
%   Copyright (c) 1998--2001 by Fabien A. P. Petitcolas
%   $Header: /Matlab MPEG/Test_MPEG.m 7     7/07/01 1:27 Fabienpe $
%   $Id: Test_MPEG.m,v 1.3 1998-06-24 10:21:06+01 fapp2 Exp $
%
%   Modified 05-04-02  Finn Agerkvist
%            07-04-05  Finn Agerkvist
%            18-11-11  Added plotting of Global and minimum masked
%            threshold
%   References:
%    [1] Information technology -- Coding of moving pictures and associated
%        audio for digital storage media at up to 1,5 Mbits/s -- Part3: audio.
%        British standard. BSI, London. October 1993. Implementation of ISO/IEC
%        11172-3:1993. BSI, London. First edition 1993-08-01.
%
%   Legal notice:
%    This computer program is based on ISO/IEC 11172-3:1993, Information
%    technology -- Coding of moving pictures and associated audio for digital
%    storage media at up to about 1,5 Mbit/s -- Part 3: Audio, with the
%    permission of ISO. Copies of this standards can be purchased from the
%    British Standards Institution, 389 Chiswick High Road, GB-London W4 4AL, 
%    Telephone:+ 44 181 996 90 00, Telefax:+ 44 181 996 74 00 or from ISO,
%    postal box 56, CH-1211 Geneva 20, Telephone +41 22 749 0111, Telefax
%    +4122 734 1079. Copyright remains with ISO.
%
%
%-------------------------------------------------------------------------------
Common;

G=[];
SM = [];
SCF = [];
% Build a demo sample

if nargin<2
   fs=44100
end
if nargin<1
   f = [220 800 2000 2500 8000 9000 10000];
   a = [ .1   .2   .1   .5    .2   .15    .3    .1];
   t = (0:1/fs:1)';
   x = 0.01*randn(size(t));
   for i = 1:length(f),
      x = x + a(i) * sin(2 * pi * f(i) * t);
   end
end

x=x';

x=[x zeros(1,383-mod(length(x)-1,384))];

N2fft=256
ffft=(0:255)*fs/512;

if (DRAW)
   figure(1);
end
% Load tables.
[TH, Map, LTq] = Table_absolute_threshold(1, fs, 128); % Threshold in quiet bitrate >96 kb/s
CB = Table_critical_band_boundaries(1, fs);
C = Table_analysis_window;

% Process the input row vector x.



for OFFSET = 1:384:length(x)-383;
   S = [];
   i=OFFSET   
%%% Subband filter analysis. Layer 1 uses 12 samples per subband.
   
   % Analysis subband filtering [1, pp. 67].
   for i = 0:11,
      S = [S; Analysis_subband_filter(x, OFFSET + 32 * i, C)];
   end
   
   % Scalefactor calculation [1, pp. 70].
   scf = Scale_factors(S);
   
%%% Psychoacoustic analysis.

	% Compute the FFT for time frequency conversion [1, pp. 110].
	X = FFT_Analysis(x, OFFSET);
   
   % Determine the sound pressure level in each  subband [1, pp. 110].
   Lsb = Sound_pressure_level(X, scf);
   
   % Find the tonal (sine like) and non-tonal (noise like) components
   % of the signal [1, pp. 111--113]
   [Flags Tonal_list Non_tonal_list] = Find_tonal_components(X, TH, Map, CB);
   
   % Decimate the maskers: eliminate all irrelevant maskers [1, pp. 114]
   [Flags Tonal_list Non_tonal_list] = ...
      Decimation(X, Tonal_list, Non_tonal_list, Flags, TH, Map);
   
   % Compute the individual masking thresholds [1, pp. 113--114]
   [LTt, LTn] = Individual_masking_thresholds(X, Tonal_list, Non_tonal_list, TH, Map);
   
   % Compute the global masking threshold [1, pp. 114]
   LTg = Global_masking_threshold(LTq, LTt, LTn);
   
   if (DRAW)
      disp('Global masking threshold');
      hold on;
      plot(TH(:, INDEX), LTg, 'k');
      hold off;
      title('Masking components and masking thresholds.');
      axes1=axis;
      pause
   end
   
   % Determine the minimum masking threshold in each subband [1, pp. 114]
   LTmin = Minimum_masking_threshold(LTg, Map);
   if (DRAW>0)
%      stairs(LTmin); title('Minimum masking threshold');
%      xlabel('Subband number'); ylabel('dB'); pause;
       LTmin2=[1;1]*LTmin;
       LTmin2=LTmin2(:);
       fband=[1;1]*(0:32)*256/32;
       fband=fband(:);
       fband=fband(2:65);
       %whos
%       plot(TH(:,INDEX),LTg)
%       pause
%       plot(fband,LTmin2)
%       pause
       plot(TH(:,INDEX),LTg,'k')
       axis(axes1)
       hold on
       pause
       plot(fband,LTmin2,'r')
       legend('256 bin FFT','Minimum masked threshold 32 bands')
       xlabel('Frequency index');ylabel('dB')
       title('Masked threshold')
       hold off
       pause
   end
   
   % Compute the signal-to-mask ratio
   SMRsb = Lsb - LTmin;
  if (DRAW>0)
      stairs(SMRsb); title('Signal to Masker ratio');
      xlabel('Subband number'); ylabel('dB'); pause;
   end

   G = [G; S];
   SM = [SM ; SMRsb ];
   SCF =[ SCF; scf];
end
