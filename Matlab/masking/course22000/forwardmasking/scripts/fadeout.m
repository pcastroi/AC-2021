%         COPYRIGHT     2004    Dik J. Hermes and Maxim Schram
%         Eindhoven University of Technology
%         Dept. of Technology Management
%         P.O. Box 513, NL 5600 MB Eindhoven, The Netherlands 


function signal = FadeOut(x, sf, fa);
% The function 'FadeOut(x, sf, fa)' attenuates the 
% last 'fa*sf' elements of the vector 'x' linearly 
% from 1 to 0.

signal = x;
if fa > 0,
        p = [fa:(-1/sf):0]/fa;
        if length(p)<=length(x),
                signal(length(x)-length(p)+1:length(x)) = ...
                        p .* signal(length(x)-length(p)+1:length(x));
        else
                signal = p(length(p)-length(x)+1:length(p)) .* signal;
        end
elseif fa < 0,
        disp('FadeOut Warning: fade-out time smaller than 0. Nothing done!');
en




%         COPYRIGHT     2004    Dik J. Hermes and Maxim Schram
%         Eindhoven University of Technology
%         Dept. of Technology Management
