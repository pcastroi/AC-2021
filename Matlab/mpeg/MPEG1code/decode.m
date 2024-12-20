function g = decode(Gi,SCF,Bits);
% g = decode(Gi,SCF,Bits)   
% Each column of Gi contains samples from one band
% The samples in Gi are integer values

w=Table_analysis_window;
nstepsize=[3 2 2./(2.^([2:1024])-1)]';%[3 2/3 2./( 2.^(2:127)-1 ) ]' ;

ones_=ones(1,64);
square=[ones_ -ones_ ones_ -ones_ ones_ -ones_ ones_ -ones_];

h=square.*w';
%sumh=sum(h)
h=ones(32,1)*h;
M=cos((1:2:63)'*(-16:495)*pi/64);
base=(h.*M);
siz=size(Gi)

%rescale samples with scalefactor (one scalefactor covers 12 samples)

sc=((SCF(:,1).*nstepsize(Bits(:,1)+1))*ones(1,12))';
s=sc(:);
s=s.*Gi(:,1);


s=[s zeros(siz(1),31)]';
s=s(:);
sS=size(s);
res = conv( s , base(1,:) );
g=res;
pow=sum(res.^2);

for i=2 : 32,
   i
   sc=((SCF(:,i).*nstepsize(Bits(:,i)+1))*ones(1,12))';
   s=sc(:).*Gi(:,i);
   
   s=[s zeros(siz(1),31)]';
   s=s(:);
   res=conv( s , base(i,:) );
   g = res + g ;
   
end;
g=32*g;
% cut of encode decode delay
sg=size(g);
g=g(481:sg(1));