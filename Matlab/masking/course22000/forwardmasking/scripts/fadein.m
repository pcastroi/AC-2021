%         COPYRIGHT     2004    Dik J. Hermes and Maxim Schram
%         Eindhoven University of Technology
%         Dept. of Technology Management
%         P.O. Box 513, NL 5600 MB Eindhoven, The Netherlands 


function signal = FadeIn(x, sf, fa);
% The function 'FadeIn(x, sf, fa)' attenuates the 
% first 'fa*sf' elements of the vector 'x' linearly 
% from 0 to 1.
signal = x;
if fa > 0,
        p = [0:1/sf:fa]/fa;
        if length(p)<=length(x),
                signal(1:length(p)) = p .* signal(1:length(p));
        else
                signal = p(1:length(x)) .* signal;
        end
elseif fa < 0,
        disp('FadeIn Warning: fade-in time smaller than 0. Nothing done!');
en




%         COPYRIGHT     2004    Dik J. Hermes and Maxim Schram
%         Eindhoven University of Technology
%         Dept. of Technology Management
%         P.O. Box 513, NL 5600 MB Eindhoven, The Netherlands 