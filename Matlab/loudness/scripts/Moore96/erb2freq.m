function mF = erb2freq(mE);
%
%    function mF = erb2freq(mE);
%
% calculates a frequency scale 'vFre'
% from the erb scale 'vErb'.
%
% author / date: jens-e. appell / 1.95
%

c1    = 24.673;
c2    = 4.368;
c3    = (2302.6/(c1*c2));
mF    = mE;
mF(:) = (1000/c2) * ( 10.^(mE(:)/c3) - 1) ;

return;
%%-------------------------------------------------------------------------
%%
%%	Copyright (C) 1995   	Jens-E. Appell, Carl-von-Ossietzky-Universitat
%%	
%%	Permission to use, copy, and distribute this software/file and its
%%	documentation for any purpose without permission by the author
%%	is strictly forbidden.
%%
%%	Permission to modify the software is granted, but not the right to
%%	distribute the modified code.
%%
%%	This software is provided "as is" without express or implied warranty.
%%
%%
%%	AUTHOR
%%
%%		Jens-E. Appell
%%		Carl-von-Ossietzky-Universitat
%%		Fachbereich 8, AG Medizinische Physik
%%		26111 Oldenburg
%%		Germany
%%
%%		e-mail:		jens@hinz.physik.uni-oldenburg.de
%%
%%-------------------------------------------------------------------------

