function [pta,h] = audiogram(agram,varargin)

% AUDIOGRAM     Plots audiogram (for air- and bone conduction)
% 
% [PTA,H] = AUDIOGRAM(AGRAM,VARARGIN)
% Plots the audiogram defined in AGRAM and returns the pure-tone average
% values and the figure handle.
% 
% Define type of audiogram with the following options in VARARGIN:
% TYPE:     type of audiogram. {AIR} or BONE
% SIDE:     side of audiogram. LEFT, RIGHT or {BOTH}
% FIG:      figure handle or {[]}
% REDRAW :  reformat figure if handle given. {0} or 1
% FAUD:     frequencies the audiogram was measured on.
%           {[125 250 500 1000 2000 3000 4000 6000 8000]}
% PTA:      frequencies to calculate the PTA on. {[500 1000 2000]}
% 
% If SIDE is BOTH, AGRAM has to have two rows, in the order of [LEFT; RIGHT].
% If FIG is set, the results are plotted on the specified figure, without
% any formatting.

% Gusztav Locsei, 03. Dec. 2013.
% Modified by Raul H Sanchez 02 Oct. 2017

%% Parsing input
p = inputParser;

defaultFaud    = [125 250 500 1000 2000 3000 4000 6000 8000]; % Frequencies for the audiogram
defaultPTA     = [500 1000 2000]; % PTA frequencies to average
defaultAuType  = 'air';   % Type of averaging
validAuType    = {'air' 'bone'};
checkAuType    = @(faud) any(validatestring(faud,validAuType));
defaultSide    = 'both';  % Side tested
validSide      = {'left' 'right' 'both'};
checkSide      = @(faud) any(validatestring(faud,validSide));
defaultFig     = [];
defaultRedraw  = 0;

addRequired(p,'agram',@isnumeric);
addParamValue(p,'faud',defaultFaud,@isnumeric);
addParamValue(p,'pta',defaultPTA,@isnumeric);
addParamValue(p,'type',defaultAuType,checkAuType);
addParamValue(p,'side',defaultSide,checkSide);
addParamValue(p,'fig',defaultFig,@isnumeric);
%addParamValue(p,'fig',defaultFig,@isstruct);
addParamValue(p,'redraw',defaultRedraw,@isnumeric);

parse(p,agram,varargin{:});
agram  = p.Results.agram;
faud   = p.Results.faud;
ptafq  = p.Results.pta;
autype = p.Results.type;
side   = p.Results.side;
h      = p.Results.fig;

%% Plotting
xt = [125 250 500 1000 2000 4000 8000];
xtl = {'.125' '.25' '.5' '1' '2' '4' '8'};
% Plot on new figure or not
if ~isempty(h)
    figure(h); hold on
else
    h = figure; hold on
end
% Calculate PTA (pure tone average)
ptaind = ismember(faud,ptafq);
pta = mean(agram(:,ptaind));
% If both sides, but only one row: duplicate it
if size(agram,1) == 1 && strcmpi(side,'both')
    agram(2,:) = agram(1,:);
    pta(2,1) = pta(1);
end
% Actual plotting
if strcmpi(autype,'air') % Air conduction
    if strcmpi(side,'left') || strcmpi(side,'both')
        plot(faud,agram(1,:),'bx','MarkerSize',8,'LineWidth',2.1,'LineStyle','-')
    end
    if strcmpi(side,'right') 
        plot(faud,agram(1,:),'ro','MarkerSize',8,'LineWidth',2.1,'LineStyle','-')
    elseif strcmpi(side,'both')
        plot(faud,agram(2,:),'ro','MarkerSize',8,'LineWidth',2.1,'LineStyle','-')
    end
else % Bone conduction
    if strcmpi(side,'left') || strcmpi(side,'both')
        text(faud+faud/15,agram(1,:),'>','FontName','Courier','FontWeight','Bold','FontSize',20,'HorizontalAlignment','center',...
            'Color','b')
        plot(faud,agram(1,:),'LineWidth',2.1,'LineStyle','--','Color','b')
    end
    if strcmpi(side,'right') 
        text(faud-faud/15,agram(1,:),'<','FontName','Courier','FontWeight','Bold','FontSize',20,'HorizontalAlignment','center',...
            'Color','r')
        plot(faud,agram(1,:),'LineWidth',2.1,'LineStyle','--','Color','r')
    elseif strcmpi(side,'both')
        text(faud-faud/15,agram(2,:),'<','FontName','Courier','FontWeight','Bold','FontSize',20,'HorizontalAlignment','center',...
            'Color','r')
        plot(faud,agram(2,:),'LineWidth',2.1,'LineStyle','--','Color','r')
        
    end 
end
%% Formatting plot - if new
%if isempty(p.Results.fig) || p.Results.redraw
    if  p.Results.redraw==0
    set(gca,'XLim',[100 10000],'YLim',[-15 130],'YDir','reverse','XScale','log', ...
        'XTick',xt,'XTickLabel',xtl,'XMinorTick','off','YTick',-10:10:120, ...
        'DataAspectRatio',[1 0.014 1]);
    xlabel('Frequency [kHz]');
    ylabel('Hearing level [dB]');
    % Create dots here
    %hd = plot(faud,repmat(-10:5:120,length(faud),1),'k.','MarkerSize',1); uistack(hd,'bottom');
    hl(1) = line([1000 1000],[-15 130],'LineStyle',':','Color',[0.5 0.5 0.5]);
    hl(2) = line([100 10000],[0 0],'LineStyle','-','Color',[0 0 0]); uistack(hl,'bottom');
    title('Audiogram')
    box on
   % Create grids here
    for ii = -10:10:130 % Horizontal grids
        hl = line([100 10000],[ii ii],'LineStyle','-','Color',[0.9 0.9  0.9]);
        uistack(hl,'bottom');
        if ii == 0
            set(hl,'LineWidth',2)
        end
    end
    for ii = xt % Vertical grids
        vl = line([ii ii],[-15 130],'LineStyle','-','Color',[0.9 0.9 0.9]);
        uistack(vl,'bottom');
        if ii == 1000
            set(vl,'LineWidth',2)
        end
    end
end