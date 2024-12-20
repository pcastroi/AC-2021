function [] = pldata(varargin);
% [] = pldata(expname,subject,group[,proc,'allmean']);   >>> for AFC DATA <<<
% 
% DESCRIPTION:
% plots experimental data from file for specified experimental names ('expname')
% subjects ('subject'), and groups ('group').
%
% INPUT:
% All input arguments could be either a string or a cell array with strings
% A cell array allows you to read and plot several data files, e.g.
% pldata('tint',{'MM1','MM2'},'prakt1') plots the data stored in
% tint_MM1_prakt1.dat and tint_MM2_prakt1.dat. The data for each experiment 
% will be shown on seperate figures. 
%
% 'proc' is optional. Three values are possible
% proc set to 'raw' -> raw data
% proc set to 'mean' -> mean data
% proc set to 'median' -> median and interquartiles
% default is raw,
%
% 'allmean' is optional. If set to 'yes' it will include a plot of the mean data
% across subjects. If set to 'only' the figure will only show mean data across
% subjects. default is 'no'
%
% OUTPUT:
% No output
%
% SEE ALSO: rddata, plinput

% 28/08/03 -- jlv
% modified by of, 2003 Sep 15
% modified by et, 2006 Sep 27 to update for Matlab 7 usage - errorbar now
%             only returns one handle, was 2 handles with Matlab 6.x
% Last Update: 2006 Sep 27

if nargin < 3
    disp(sprintf('%s(expname,subject,group)',mfilename))
    disp(sprintf('Type -> help %s <- for more information',mfilename))
    return
end
% what todo with the data
proc = 'raw';
allmean = 'no';
% some error checks
for i = 1:nargin
    actin = varargin{i};
   if (ischar(actin) == 0) & (iscell(actin) == 0)
      error('Inputs must strings or cell arrays')
   end
end
% now check if proc and allmean is specified
if nargin >= 4
    proc = varargin{4};
    if isempty(cellfind({'median','mean','raw'},proc))
        warning(sprintf('''%s'' not recognized as processing option. Using ''raw'' instead',proc)) 
        proc = 'raw';
    end
end
if nargin >= 5
    allmean = varargin{5};
end


% no convert all to cell arrays
innames = {'expname','subject','group'};
for i = 1:3
    if ischar(varargin{i})
        eval(sprintf('%s = {varargin{i}};',innames{i}))
    else
        eval(sprintf('%s = varargin{i};',innames{i}))
    end
end
% some quick and dirty work-around to get a logarithmic x-axis for
% several experiments
switch upper(expname{:}),
case {'LOUDTEMPINT', 'LOUDSUMSPEC'}
  bLogxScale = 1;
otherwise
  bLogxScale = 0;
end

% some settings for the plot
colors = [0.2 0.7 0.2;0 0 1; 1 0 0;0 0 0;0.7 0.2 0.2; 1 1 0; 1 0 1];
lines =  {'--','-.',':'};
markers = {'s','^','v','d','>','<','x','p'};
fsize = 12;
msize = 6;
lwidth = 1;
% now do the job
for i = 1:length(expname)
    allval = [];
    toput =[];
    towrite = {};
    figure % new figure for new experiment
    actexp = expname{i};
    % find all files in current dir that are experimental data files for
    % that particular experiment
    allfiles = finddata('.',actexp);
    %
    actcolor = colors((mod(i-1,length(colors))+1),:);
    for j = 1:length(subject)
        actsub = subject{j};
        % each subject gets a separate marker
        actmarker = markers{(mod(j-1,length(markers))+1)};        
        for k = 1:length(group)
            actgroup = group{k};
            % each group gets a separate linestyle
            actline = lines{(mod(k-1,length(lines))+1)};        
            % load data
            if isempty(cellfind(allfiles,sprintf('%s_%s_%s.dat',actexp,actsub,actgroup))) ~= 1
                loadfilename = sprintf('''%s_%s_%s.dat''',actexp,actsub,actgroup);
                eval(sprintf('newval = load(%s);',loadfilename));
                % something special for interleaved
                if size(newval,2) == 5
                    tnewval(:,1) = newval(:,2);
                    tnewval(:,2) = newval(:,4);
                    tnewval(:,3) = newval(:,5);
                    newval = tnewval;
                end
               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
               % process data
               if strcmp(proc,'mean')
                   newval = mdata(newval);
               elseif strcmp(proc,'median')
                   newval = zdata(newval);
               elseif strcmp(proc,'raw')
               else
                   warning('procedure not recognized. plotting raw data')
               end
               % for grand average
               if isempty(allval)
                   allval = newval;
               else
                   allval(size(allval,1)+1:size(allval,1)+size(newval,1),:) = newval;
               end
               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
               % plot data
               if strcmp(allmean,'only') ~= 1
                   if strcmp(proc,'raw')
                       if bLogxScale,
                         hpl =plot(log10(newval(:,1)),newval(:,2),actmarker,'color',actcolor,'markersize',msize,'linewidth',lwidth);
                       else
                         hpl =plot(newval(:,1),newval(:,2),actmarker,'color',actcolor,'markersize',msize,'linewidth',lwidth);
                       end
                       toput(length(toput)+1) = hpl;
                       towrite{length(toput)} = actsub;
                       hold on
                   else
                       if bLogxScale,
                         herr = errorbar(log10(newval(:,1)),newval(:,2),newval(:,3),newval(:,4));
                       else
                         herr = errorbar(newval(:,1),newval(:,2),newval(:,3),newval(:,4));
                       end
                       set(herr,'linestyle',actline,'marker',actmarker)
                       set(herr,'linewidth',lwidth,'color',actcolor,'markerfacecolor','w','markersize',msize)
                       toput(length(toput)+1) = herr;
                       towrite{length(toput)} = actsub;
                       hold on
                   end
               end
           else
               disp(sprintf('sorry no %s data found for subject %s in group %s',actexp,actsub,actgroup)) 
           end
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % calculate limits
    if isempty(allval)
        return
    end
    if bLogxScale,
      xtl = unique(sort(allval(:,1))); % XTickLabels to use
      xt = log10(xtl);                 % corresponding XTicks
      allval(:,1) = log10(allval(:,1));
    end
    minxval = min(allval(:,1));
    maxxval = max(allval(:,1));
    if strcmp(proc,'raw')
        minyval = min(allval(:,2))-max(allval(:,3));
        maxyval = max(allval(:,2))+max(allval(:,3));
    else
        minyval = min(allval(:,2))-max(max(allval(:,3)),max(allval(:,4)));
        maxyval = max(allval(:,2))+max(max(allval(:,3)),max(allval(:,4)));
    end
    xupplim = maxxval + 0.1*(maxxval-minxval);
    xlowlim = minxval - 0.1*(maxxval-minxval);
    if (maxxval-minxval) == 0
        if xupplim == 0
            xupplim = 0.1;
            xlowlim = -0.1;
        else
            xupplim = 1.1*xupplim;
            xlowlim = 0.9*xlowlim;
        end
    end
    yupplim = maxyval + 0.1*(maxyval-minyval);
    ylowlim = minyval - 0.1*(maxyval-minyval);
    if (maxyval-minyval) == 0
        if yupplim == 0
            yupplim = 0.1;
            ylowlim = -0.1;
        else
            yupplim = 1.1*yupplim;
            ylowlim = 0.9*ylowlim;
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % calculates  and plots the mean if 'allmean' is set to 'yes' or 'only'
    if strcmp(allmean,'yes') | strcmp(allmean,'only')
        allval = mdata(allval);
        herr = errorbar(allval(:,1),allval(:,2),allval(:,3),allval(:,4)); 
        set(herr,'linestyle','-','linewidth',lwidth,'markerfacecolor',actcolor,'color',actcolor,'markersize',msize)
        set(herr,'marker','o')
        toput(length(toput)+1) = herr;
        towrite{length(toput)} = 'mean';
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % adjust figure according to limits
    axis([xlowlim xupplim ylowlim yupplim])
    if bLogxScale,
      set(gca,'XTick',xt,'XTickLabel',xtl);
    end
    % some labeling
    knownexps = {'tint','notch','fletcher','intjnd','ildjnd','bmld','bbtmtf'};
    xlabels = {'duration [ms]','notch width re. sig freq','bandwidth re. sig freq','level [dB]','ref interaural level difference [dB]','interaural phase diff [degree]','modulation freq [Hz]'};
    ylabels = {'level [dB]','level [dB re masker spec level]','level [dB re masker spec level]','level [dB]','level [dB]','level [dB]','modulation depth [dB]'};
    [row,col] = cellfind(knownexps,actexp);
    htitle = title(actexp);
    set(htitle,'FontSize',fsize)
    if isempty(row) == 0
        xlabel(xlabels{row,col})
        ylabel(ylabels{row,col})
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    set(gca,'FontSize',fsize,'Linewidth',lwidth);
    %[LEGH,OBJH,OUTH,OUTM] = legend(toput,towrite,0);
    %set(LEGH,'Linewidth',lwidth);
end
return
% eof
