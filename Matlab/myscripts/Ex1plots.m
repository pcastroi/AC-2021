clear
close all
clc


fc=[1000 2000 3000 4000];
bw=[200 400 800 1600 3200 6400];

c=['b','r','g','m'];
fig = figure;
h=1.2;
for j=1:length(fc)
    for i=1:length(bw)
        f1 = @(fu,fl) fu-fl-bw(i)+1;
        f2 = @(fu,fl) fu.*fl/fc(j)^2;
        hcolor(j) = plot(NaN,c(j));
        hcolor2 = plot(NaN,'k');
        zhandle1 = fcontour(f1,'k'); % Returns a useful number of x-values for f1
        hold on
        zhandle2 = fcontour(f2,c(j)); % Returns a useful number of x-values for f2
    end
    grid on
end
hold off

xlim([-h h])
ylim([-h h])

title(['Contour of both equations for $B_w$ = [' num2str(bw) '] Hz'],'Interpreter','latex');
xlabel('$X$','Interpreter','latex')
ylabel('$Y$','Interpreter','latex')

hcolor=[hcolor hcolor2];
legend(hcolor,{'$\sqrt{f_l*f_u} = 1 kHz$','$\sqrt{f_l*f_u} = 2 kHz$','$\sqrt{f_l*f_u} = 3 kHz$','$\sqrt{f_l*f_u} = 4 kHz$', '$f_u-f_l = B_w$'},'Interpreter','latex','Location','southwest');

name='fufl';
% print(fig,name,'-r800','-dpng');



