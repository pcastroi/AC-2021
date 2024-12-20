function masking(f1,f2,dl);

dl=10^(-dl/20);
x=sin(2*pi*f1*(1:88000)/44100).*[0:0.0005:1 ones(1,83998) (1:-0.0005:0)];
y=[ zeros(1,26000) dl*sin(2*pi*f2*(1:36000)/44100).*[0:0.0005:1 ones(1,31998) (1:-0.0005:0)] zeros(1,26000)];
z=x+y;
m=2*max(z)
x=x/m;
y=y/m;
z=z/m;
sound(x,44100);
pause(2.5)
sound(y,44100);
pause(2.5)
sound(z,44100);
