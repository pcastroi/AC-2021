function [varargout] = rdalldata(varargin);
% [out] = rddata(expname,subject,group[,proc]);   >>> for AFC DATA <<<
% 
% DESCRIPTION:
% reads experimental data from file for specified experimental names ('expname')
% subjects ('subject'), and groups ('group').
%
% INPUT:
% All input arguments could be either a string or a cell array with strings
% A cell array allows you to read in several data files, e.g.
% rddata('tint',{'MM1','MM2'},'prakt1') reads the data stored in
% tint_MM1_prakt1.dat and tint_MM2_prakt1.dat
% 'proc' is optional. Three values are possible
% proc set to 'raw' -> raw data
% proc set to 'mean' -> mean data
% proc set to 'median' -> median and interquartiles
% default is raw
%
% OUTPUT:
% If no output is specified the data is loaded into your workspace by the
% names of the files, e.g. tint_MM1_prakt1 is the data found in 
% tint_MM1_prakt1.dat. However you can also specify the name of the
% variable in your workspace, e.g. 
% [tMM1,tMM2,bMM1,bMM2] = rddata({'tint','bbtmtf'},{'MM1','MM2'},'prakt1')
% reads the data into tMM1 and tMM2 (tint data) and bMM1 and bMM2 (bbtmtf data) 
% on your workspace. Note that the number of output variables must be the same
% as the number of  files to load. 
%
% SEE ALSO: load
if nargin < 3
    disp(sprintf('%s(expname,subject,group)',mfilename))
    disp(sprintf('Type -> help %s <- for more information',mfilename))
    return
end
% what todo withthe data
proc = 'raw';
if nargin == 4
    proc = varargin{4};
end
% some error checks
for i = 1:nargin
    actin = varargin{i};
   if (ischar(actin) == 0) & (iscell(actin) == 0)
      error('Inputs must strings or cell arrays')
   end
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
% another error check
if nargout > 0
    if length(expname)*length(subject)*length(group) ~= nargout
        error('not enough output arguments')
    end
end
% now do the job
for i = 1:length(expname)
    actexp = expname{i};
    allfiles = finddata('.',actexp);
    for j = 1:length(subject)
        actsub = subject{j};
        for k = 1:length(group)
            actgroup = group{k};
            loadfilename = sprintf('''%s_%s_%s.dat''',actexp,actsub,actgroup);
            if isempty(cellfind(allfiles,sprintf('%s_%s_%s.dat',actexp,actsub,actgroup))) ~= 1
                disp(sprintf('loading %s',loadfilename))
                eval(sprintf('outval = load(%s);',loadfilename));
                if strcmp(proc,'mean')
                    outval = mdata(outval);
                elseif strcmp(proc,'median')
                    outval = zdata(outval);
                elseif strcmp(proc,'raw')
                else
                    warning('procedure not recognized. outputting raw data')
                end
				if nargout == 0
                    outname = sprintf('''%s_%s_%s''',actexp,actsub,actgroup);
                    eval(sprintf('assignin(''base'',%s,outval);',outname))
				else
                    varargout{(i-1)*length(subject)*length(group) +(j-1)*(length(group)) + k} = outval;
				end
            else
                disp(sprintf('sorry no %s data found for subject %s in group %s',actexp,actsub,actgroup)) 
            end
        end
    end
end

return
