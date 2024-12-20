% % Title: Noise
% % Subtitle: Pink noise
% % Five 0.8 s samples of pink noise are presented. 
% % The power spectrum of pink noise is 
% % proportional to f^(-1) (f is frequency), which 
% % means that it decreases 3 dB per octave. 
% % This means that frequency bands with the same 
% % bandwidth on a logarithmic frequency scale 
% % contain the same power. 
% % 
% % This pink noise was calculated according to 
% % an algorithm I found on the internet 
% % The original author was Mr. Tom Bruhns from HP 
% % who proposed the following values for a 
% % white-to-pink noise filter for audio signals:
% % poles=[.9986823 .9914651 .9580812 .8090598 .2896591]';
% % zeros=[.9963594 .9808756 .9097290 .6128445 -.0324723]';
% % 

clear
clf
sampleFrequency = 44100;
dt = 1/sampleFrequency;
interOnsetTime = 1.0;
duration = 0.8;
t = [0:dt:duration];

poles=[.9986823 .9914651 .9580812 .8090598 .2896591]';
zeros=[.9963594 .9808756 .9097290 .6128445 -.0324723]';

% Find forward and backward coefficients of the filter
[b,a]=zp2tf(zeros,poles,1);

% Calculate 5 realisations of normally 
% distributed noise samples
% with 0 mean and 0.1 standard deviation.
% Then filter them to get 5 realisations 
% of pink noise.
for i=1:5,
        x = random('norm', 0, 0.1, 1, length(t));
        % Filter the white noise to get pink noise.
        s(i,:) = filter(b, a, x);
        % The next two operations are carried out 
        % in order to prevent clicks at the onset 
        % and offset of the sound. 
        s(i,:) = FadeIn(s(i,:), sampleFrequency, 0.02);
        s(i,:) = FadeOut(s(i,:), sampleFrequency, 0.02);
end

PlaySounds(s, sampleFrequency, interOnsetTime-duration)
SaveSounds(s, sampleFrequency, interOnsetTime-duration, sprintf('..\\wavFiles\\%s.wav', mfilename));
PlotSounds(s, sampleFrequency, 0.04, 0.05)
print(gcf, '-dmeta', sprintf('..\\images\\%s', mfilename))




%         COPYRIGHT     2004    Dik J. Hermes and Maxim Schram
%         Eindhoven University of Technology
%         Dept. of Technology Management
%         P.O. Box 513, NL 5600 MB Eindhoven, The Netherlands 
