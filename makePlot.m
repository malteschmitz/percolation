close all;
colors1 = {'-r', '-k', '-b'};
colors2 = {':r', ':k', ':b'};
Ls = [200];
figure; hold on;
for i = 1:length(Ls)
    L = Ls(i);
    values = load([num2str(L) '.txt']);
    plot(values(1,:), values(2,:), colors1{i});
    plot(values(1,:), values(3,:), colors2{i});
end
title('site percolation');
legend('200x200 p_{cluster}', '200x200 p_{infty}', 'Location', 'NorthWest');
xlabel('p');
ylabel('propability');
timesPlot;