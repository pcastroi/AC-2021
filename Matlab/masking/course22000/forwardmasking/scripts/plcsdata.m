function [x, pc] = plcsdata(expname, vp, group);
% plcsdata  reads in and plots data of a constant stimuli measurement
%
% syntax: [x, pc] = plcsdata(expname, vp, group)
%
% input:  expname  name of the experiment
%         vp       initials of the subject
%         group    name of the subject group
%
% output: x        the variable of the experiment
%         pc       the percent correct responses
%
% This plot routine is suited for one subject only!
%
% see also: pldata

% (c) of, 2004 Feb 09
% Last Update: 2004 Feb 27
% Timestamp: <plcsdata.m Fri 2004/02/27 09:47:02 OF@OFPC>

if nargin < 3
  help(mfilename);
end

fname = sprintf('%s_%s_%s.dat',expname,vp,group);  % the filename to look for
if ~exist(fname,'file'),               % does it exist?
  error(sprintf('%s not found!',fname));
end

vals = load(fname);                    % load the data
if size(vals,2) < 6,                   % do we have a constant stimuli measurement?
  error('This is probably not the result file of a constant stimuli measurement');
end
x = vals(:,4);                         % get the expvar
pc = vals(:,6)./vals(:,5);             % and the percent correct responses
figure                                 % open new figure
plot(x,pc*100,'o');                    % plot the data
xlabel('Level in dB');                 % label x axis
ylabel('Percent correct responses');   % label y axis
titstr=sprintf('%s_%s_%s',expname,vp,group);  % build the title string
titstr=strrep(titstr,'_','\_');        % escape underscores
title(titstr);                         % add the title
xl = xlim;                             % get the x range
xl(1) = xl(1)-0.1*diff(xl);            % modify the xrange
xl(2) = xl(2)+0.1*diff(xl);            % ...
xlim(xl);                              % rescale the x axis
ylim([0 100]);                         % scale y axis to full scale (0-100%)


% EOF
