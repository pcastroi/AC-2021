function [out] = finddata(dirname,expname);
% [out] = finddata(dirname,expname)   >>> for AFC DATA <<<
% 
% DESCRIPTION:
% finds all data files in the directory dirname. If the function is called
% without an input argument it will search the current directory
% expname is otional. By specifying expname it will search in the directory 
% for files starting with expname. For example,  you can get all 
% data files names for tint in the current dir by typing 
%              finddata('.','tint')
% or if you wish to get only the file names for this experiment and subject
% 'MM' type 
%              finddata('.','tint_MM')
% You can also use wildcards (*)
%
% INPUT:
% dirname : name of directory 
%
% OUTPUT:
% returns a cell array with the names of all data files 
%
% SEE ALSO: dir

% 28/08/03 -- jlv
if nargin < 1
    dirname = '.';
    expname ='';
end
% error check
if (ischar(dirname) == 0) | (ischar(expname) == 0)
    error('Input must be a string')
end
% check if last char of dir is a / or \
if strcmp(dirname(length(dirname)),'/') | strcmp(dirname(length(dirname)),'\') 
    dirname = dirname(1:length(dirname)-1)
end
out = {};
if isempty(expname)
    allindir = dir(sprintf('%s/*.dat',dirname));
    for i = 1:length(allindir)
        if strncmp(allindir(i).name,'control',7) ~= 1
            out{length(out)+1} = allindir(i).name;
        end
    end
else
    allindir = dir(sprintf('%s/%s*.dat',dirname,expname));
    for i = 1:length(allindir)
        %disp(allindir(i).name)
        out{length(out)+1} = allindir(i).name;
    end
end
return
% eof