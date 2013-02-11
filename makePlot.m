close all;
colors_cluster = {'-r', '-b', '-k'};
colors_infty = {'--r', '--b', '--k'};
colors_infty_all = {'-.r', '-.b', '-.k'};
data = {'200-site', '200-bond'};
legends = cell(1,length(data)*3);
figure; hold on;
for i = 1:length(data)
    values = load([data{i} '.txt']);
    plot(values(1,:), values(2,:), colors_cluster{i});
    legends(3*(i-1)+1) = {[data{i} ' p_{cluster}']};
    plot(values(1,:), values(3,:), colors_infty{i});
    legends(3*(i-1)+2) = {[data{i} ' p_{\infty}']};
    plot(values(1,:), values(4,:), colors_infty_all{i});
    legends(3*(i-1)+3) = {[data{i} ' p_{\infty/all}']};
end
title('percolation');
legend(legends, 'Location', 'SouthEast');
xlabel('p');
ylabel('propability');
timesPlot;