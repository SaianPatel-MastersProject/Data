%% CTE triplet violin

figure;


%% rCTE
subplot(1,3,1)
hold on
for i = 1:3
    violinplot(obj.runData(i).metricsCTE.rCTE_pct);
end

%% wCTE
subplot(1,3,2)
hold on
for i = 1:3
    violinplot(obj.runData(i).metricsCTE.wCTE_pct');
end

%% hCTE
subplot(1,3,3)
hold on
for i = 1:3
    violinplot(obj.runData(i).metricsCTE.hCTE_pct');
end


