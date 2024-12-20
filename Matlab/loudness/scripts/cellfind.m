function [row,col] = cellfind(x,svar)
% CELLFIND   Find indices of element in cell.
%     [I,J] = CELLFIND(X,VAR) returns the row and column indices of
%     the entries that are equal to VAR. Only works with 2dim cells. 
%    Var has to be a char or a numeric.

% 28/08/03 -- jlv
if nargin < 2
   disp(sprintf('%s(x,var)',mfilename))
   disp(sprintf('Type -> help %s <- for more information',mfilename))
   return
end
if iscell(x) ~= 1
    error('first input must be of type cell')
elseif length(size(x)) > 2
    error('sorry, only works with two dimensional cells')
end
row = [];
col = [];
for i = 1:size(x,1)
    for j = 1:size(x,2)
        actvar = x{i,j};
        if ischar(svar)
            if ischar(actvar)
                if strcmp(actvar,svar)
                    row(length(row)+1) = i;
                    col(length(col)+1) = j;
                end
            end
        elseif isnumeric(svar)
            if isnumeric(actvar)
                if actvar == svar
                    row(length(row)+1) = i;
                    col(length(col)+1) = j;
                end
            end
        else
            error('second input must  be of type char or numeric')
        end
    end
end
% eof