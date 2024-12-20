 function yi = interpjm(x,y,xi,method)
%
% function yi = interpjm(x,y,xi,method)
%
% a save call to function interp1.
% following steps will be done before calling interp1:
% - margins will be patched preventing from index errors
%   when using method 'linear' or funny values when using
%   method 'spline'.
%
% see also: interpj, interpjs, interpjc, interpjm, interp1
%
% author / date : jens-e. appell / 6.97
% 

if (x(1) > x(length(x)))
	error('interpjm.m: x must be increasing');
end;

if nargin<4,
	method='linear';
end;

% patch some margin values, so that linear, spline, cubic
% will work correctly.
% NOTE: we have to patch something which is close to values in x.
%       therefore we patch x to become
%       [vxMin-1*dX vxMin-2*dX vxMin-3*dX x vxMax+1*dX vxMax+2*dX vxMax+3*dX]
vxMin   = min(x(1        ), min(xi));
vxMax   = max(x(length(x)), max(xi));
dX      = abs(x(1)-x(2));
vxMin   = vxMin + dX * (-3:-1)';
vxMax   = vxMax + dX * ( 1: 3)';
y = [ones(3,1)*y(1,:);	y	 ;	ones(3,1)*y(length(y),:)];
x = [vxMin  			;	x(:);	vxMax							];

yi=interp1(x,y,xi,method);

return;
%%-------------------------------------------------------------------------
%%
%%	Copyright (C) 1997   	Jens-E. Appell, Carl-von-Ossietzky-Universitat
%%	
%%	Permission to use, copy, and distribute this software/file and its
%%	documentation for any purpose without permission by the author
%%	is strictly forbidden.
%%
%%	Permission to modify the software is granted, but not the right to
%%	distribute the modified code.
%%
%%	This software is provided "as is" without expressed or implied warranty.
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
%%		e-mail:		jens@medi.physik.uni-oldenburg.de
%%
%%-------------------------------------------------------------------------

