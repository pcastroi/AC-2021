addpath scripts

clear all; clc; clf; close all;

set(groot, 'defaultLineLinewidth', 0.5)
set(groot, 'defaultAxesFontSize', 5)


% figure(1)
% pldata('loudadj', {'GL', 'PC', 'S173830', 'S113850'}, 'group7', ['raw'], ['yes']);
% xlabel('\Delta Loudness')
% ylabel('\Delta Level dB SPL')
% grid on
% grid minor
% legend('1','2','3','4','mean', 'Location', 'Northwest')
% legend('boxoff')
% 
% 
% %%
% 
% clear all; clc; clf;
% 
% 
% figure(1)
% pldata('loudtempint', {'GL', 'PC', 'S173830', 'S113850'}, 'group7',['raw'],['yes']);
% xlabel('Pulse duration [ms]')
% ylabel('\Delta Level dB SPL')
% grid on
% grid minor
% legend('1','2','3','4','mean', 'Location', 'Northeast')
% legend('boxoff')

%%

pldata('loudsumspec', {'GL', 'PC', 'S173830', 'S113850'}, 'group7', ['mean'], ['no']);
title('Spectral Loudness Summation Mean for each subject')
xlabel('Bandwidth [Hz]')
ylabel('\Delta Level dB SPL')
grid on
legend('\mu_1','\mu_2','\mu_3','\mu_4','mean', 'Location', 'Northeast')
legend('boxoff')

pldata('loudsumspec', {'GL', 'PC', 'S173830', 'S113850'}, 'group7', ['raw'], ['only']);
legend('\mu', 'Location', 'Northeast')
legend('boxoff')
title('Spectral Loudness Summation Mean for all subjects')
xlabel('Bandwidth [Hz]')
ylabel('\Delta Level dB SPL')
grid on


%% Variation in the loudness prediction of the two models
clear all;clc;

L = zeros(2,6)

for i = 1:length(L)

    L(1, i) = LoudSumModel(55, 3200, 'm');
    L(2, i) = LoudSumModel(55, 3200, 'd');
end

%% Loudness prediction

clear all; clc;

L_m_ref = LoudSumModel(55, 3200, 'm');
L_d_ref = LoudSumModel(55, 3200, 'd');
Lref = [L_m]
Level = 20;
BW = [200 400 800 1600 6400];


for i = 1:length(BW)

    while 1
    
        L_BW(i) = LoudSumModel(Level, BW(i), 'd');
    
        if (L -1 <= L_BW(i)) && (L_BW(i) <= L + 1)
            Level_m(i) = Level;
            break
        end
    
        Level = Level + 1;
        L_BW(i) = 0;
    end
    
    Level = 30;
end



dLevel = Level_m - 55

BW_fig = [BW(1:4) 3200 BW(5)]
dLevel_fig = [dLevel(1:4) 0 dLevel(5)]
%%
figure()
plot(BW_fig, dLevel_fig, 'o-', 'LineWidth', 2)
xlabel('BW, Hz')
ylabel('\Delta Level, dB SPL')
title('Loudness model predictions')
xticks(BW_fig)
set(gca, 'FontSize', 12)
grid on
grid minor

