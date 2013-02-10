close all;
colors_cluster = {'-r', '-k', '-b'};
colors_infty = {'--r', '--k', '--b'};
colors_infty_all = {':r', ':k', ':b'};
Ls = [200];
figure; hold on;
for i = 1:length(Ls)
    L = Ls(i);
    values = load([num2str(L) '.txt']);
    plot(values(1,:), values(2,:), colors_cluster{i});
    plot(values(1,:), values(3,:), colors_infty{i});
    plot(values(1,:), values(4,:), colors_infty_all{i});
end
title('site percolation');
legend('200x200 p_{cluster}', '200x200 p_{infty}', '200x200 p_{infty/all}', 'Location', 'NorthWest');
xlabel('p');
ylabel('propability');
timesPlot;