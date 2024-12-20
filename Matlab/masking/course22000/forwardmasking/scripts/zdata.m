function [out] = zdata(varargin);
% [out] = zdata(input);   >>> for AFC DATA <<<
% 
% DESCRIPTION:
% calculates the median and interquartiles of the input data for each 
% parameter in the first column of the matrix. If more than one input 
% file is specified the median is calculated across all input data.
%
% SEE ALSO:
% mdata, mean, median
if nargin < 1
    disp(sprintf('%s(input)',mfilename))
    disp(sprintf('Type -> help %s <- for more information',mfilename))
    return
end
rawdata = varargin{1};
for i = 2:nargin
    newdata = varargin{i};
    actrow = size(rawdata,1);
    rawdata([(size(rawdata,1)+1):(size(rawdata,1)+size(newdata,1))],:) = newdata;
end
% now do the job
[dummy,newi] = sort(rawdata,1);
rawdata = rawdata(newi(:,1),:);
out = [];
numrep = 0;
for i = 1:size(rawdata,1)
    actx = rawdata(i,1);
    acty = rawdata(i,2);
    if i == 1
        oldx = actx;
        ally4oldx = acty;
    else
        if actx == oldx
            ally4oldx(length(ally4oldx)+1) = acty;
        else
            if ((numrep ~= 0) & (numrep ~=length(ally4oldx)))
                warning('not the same number of repetitions for every parameter')
            end
            out(size(out,1)+1,1) = oldx;
            ally4oldx = sort(ally4oldx);
            out(size(out,1),2) = median(ally4oldx);
            out(size(out,1),3) = median(ally4oldx) - median(ally4oldx(1:floor(length(ally4oldx)*0.5)));
            out(size(out,1),4) = median(ally4oldx(floor(length(ally4oldx)*0.5)+1:length(ally4oldx))) - median(ally4oldx);
            numrep = length(ally4oldx);
            oldx = actx;
            ally4oldx = acty;
        end
    end
    if   i == size(rawdata,1)
        out(size(out,1)+1,1) = oldx;
        ally4oldx = sort(ally4oldx);
        out(size(out,1),2) = median(ally4oldx);
        out(size(out,1),3) = median(ally4oldx) - median(ally4oldx(1:floor(length(ally4oldx)*0.5)));
        out(size(out,1),4) = median(ally4oldx(floor(length(ally4oldx)*0.5)+1:length(ally4oldx)))- median(ally4oldx);
    end
end
return
