function [out] = mdata(varargin);
% [out] = mdata(input);   >>> for AFC DATA <<<
% 
% DESCRIPTION:
% calculates the 
% mean, mean - one standard deviation, and mean + one standard deviation
% of the input data for each parameter (first colimn of input matrix)
% If more than one input file isspecified the mean
% is calculated across all files.
%
% SEE ALSO:
% zdata, mean, median

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
            out(size(out,1),2) = mean(ally4oldx);
            out(size(out,1),3) = std(ally4oldx);
            out(size(out,1),4) = std(ally4oldx);
            numrep = length(ally4oldx);
            oldx = actx;
            ally4oldx = acty;
        end
    end
    if   i == size(rawdata,1)
        out(size(out,1)+1,1) = oldx;
        out(size(out,1),2) = mean(ally4oldx);
        out(size(out,1),3) = std(ally4oldx);
        out(size(out,1),4) = std(ally4oldx);
    end
end
return
