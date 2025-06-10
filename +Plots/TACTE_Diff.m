%% Diffs

TACTE_diff = zeros([numel(obj.runData(1).metricsCTE.TACTE), 1]);

for i = 1:numel(obj.runData(1).metricsCTE.TACTE)

    TACTE_diff(i,1) = obj.runData(1).metricsCTE.TACTE(i) - obj.runData(2).metricsCTE.TACTE(end);

end