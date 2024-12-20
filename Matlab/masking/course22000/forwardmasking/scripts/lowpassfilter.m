
[b,a] = butter(9,500/22050);
% fvtool(b,a); 
y = wgn(100,1,0);
% c =conv(y,b);
c = fftshift(fft(y))*fftshift(fft(b));
freqz(c);
