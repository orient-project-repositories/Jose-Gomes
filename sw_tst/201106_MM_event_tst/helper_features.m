function helper_features(loc, val)

figure
hold on
for i = 1:46
    plot3(zeros(185,1)+i, loc{i}(:,1), loc{i}(:,2), '.');
end

end