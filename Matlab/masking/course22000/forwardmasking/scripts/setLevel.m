function y = setLevel(signal,level,peakLevel);

% Sets the rms signal level to "level dB SPL" 
% If a third parameter is specified the peak level is set to "level dB"

pref	= 20e-6; 

if nargin < 3
	y	= signal*(pref/rms(signal)*10^(level/20));
else
	y	= signal*(pref/max(abs(signal))*10^(level/20));
end;
