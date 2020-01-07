clearvars -except Pr
for j = 1 : length(Pr)
    epsilon(j,1) = Pr(j).epsilon;
    Time{j,1} = num2str(mean(Pr(j).algTime),'%1.1e');
    Acc(j,1) = Pr(j).acc;
    Ans{j,1} = Pr(j).res;
    alpha(j,1) = Pr(j).dSigLev;
    delta(j,1) = Pr(j).delta;
    Sam{j,1} = num2str(mean(Pr(j).N),'%1.1e');
end
table(delta,epsilon,alpha,Acc,Sam,Time,Ans)