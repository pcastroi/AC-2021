function G = analysis(x);

% x is the row vector in put signal

% G is output matrix with each column containing the samples from one band 
w=table_analysis_window;

ones_=ones(1,64);
square=[-ones_ ones_ -ones_ ones_ -ones_ ones_ -ones_ ones_];

h=square.*w';
pow=sum(h.^2)
%plot(h);
%pause;
h=ones(32,1)*h;
M=cos((1:2:63)'*(-16:495)*pi/64);
base=fliplr(h.*M);

%temp=(base.^2)';
%sum(temp)

G=conv( base(1,:) , x) ;
sG=size(G);
idx=(4:32:sG(2));
G=G(idx);
%pow=sum(G.^2)
for i=2 : 32,
   
   res=conv( base(i,:) , x) ;
   
   %plot(res);
   res =res(idx);
   
   %pause;

   
   %   size(res)
   %pow=sum(res.^2)
   G = [ G ; res ];
   
end;
G=G';
siz=size(G)