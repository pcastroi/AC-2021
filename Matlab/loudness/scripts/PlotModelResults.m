function PlotModelResults
% PlotModelResults Plot results of the simulation of loudness summation
%
% This function should be used to plot the results of the loudness
% matching experiments.

% (c) of, 2003 Sep 12
% Last Update: 2003 Sep 12

FontSize = 16;
MarkerSize = 12
LineWidth = 2;

mData = [ 200 400 800 1600 3200 6400 ; ...
            0   0   0    0    0    0];

disp(sprintf(['Please enter your data in the matrix.\n', ...
              'The first row is for the bandwidth and\n' ...
              'the second row for the level differences.\n' ...
              'After finishing type ''return'' on the on\n' ...
              'the commandline and press [ENTER]!']));
openvar('mData');
keyboard

[vBW, i] = sort(mData(1,:));
vdB = mData(2,i);;
figure
h = semilogx(vBW,vdB,'o-');
set(h,'LineWidth',LineWidth,'MarkerSize',MarkerSize);
set(gca,'LineWidth',LineWidth,'FontSize',FontSize);
xlabel('Bandwidth in Hz');
ylabel('Level difference in dB');
title('Simulated loudness summation');
set(gca,'XTick',vBW,'XMinorTick','off');
xlim([min(vBW)/1.2 max(vBW)*1.2]);
