%% Audiometry demo script
% You just have to substitute the following variables with the results of 
% your own tests and you will get your audiometrical results in a
% proper format.


faudioair = [125 250 500 1000 2000 4000 8000]; % frequencies tested in air conduction audiometry
faudiobone = [ 250 500 1000 2000 4000 ]; % frequencies tested in bone conduction audiometry

audiogramL = [30 35 40 45 60 50  70]; % air conduction audiometry, left ear.
audiogramR = [30 40 45 45 50 40  60]; % air conduction audiometry, right ear.

Bone_audiogramL = [ 35 35 40 55 50  ]; % bone conduction audiometry, left ear.
Bone_audiogramR = [ 35 40 45 55 50  ]; % bone conduction audiometry, left ear.


%% Plot whole audiogram in one plot
[pta,h] = audiogram([audiogramL;audiogramR],'faud',faudioair,'side','both','type','air');
[pta,h] = audiogram([Bone_audiogramL;Bone_audiogramR],'faud',faudiobone,'side','both','type','bone','fig',h.Number,'redraw',1);
%% Plot only Left audiogram 
[pta,h] = audiogram([audiogramL],'faud',faudioair,'side','left','type','air');
[pta,h] = audiogram([Bone_audiogramL],'faud',faudiobone,'side','left','type','bone','fig',h.Number,'redraw',1);
%% Plot two audiograms
hfigure = figure
hsub1 = subplot(1,2,1)
[pta,h] = audiogram([audiogramL],'faud',faudioair,'side','left','type','air','fig',hfigure.Number);
[pta,h] = audiogram([Bone_audiogramL],'faud',faudiobone,'side','left','type','bone','fig',hfigure.Number,'redraw',1);
hsub2 = subplot(1,2,2)
[pta,h] = audiogram([audiogramR],'faud',faudioair,'side','right','type','air','fig',hfigure.Number);
[pta,h] = audiogram([Bone_audiogramR],'faud',faudiobone,'side','right','type','bone','fig',hfigure.Number,'redraw',1);
hfigure.Position = [368         360        1030         420];