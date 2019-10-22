clc;
clear
%% parameters
rng(5000)

epsilon = [0.4, 0.7, 0.85];
significanceLevel = [0.01, 0.05];
delta = [4, 5, 6];
number_of_simulation = 100;
%%

load_system('narmaSim')
j = 0;
for i_e = 1 : length(epsilon)
    for i_s = 1 : length(significanceLevel)
        for i_d = 1 : length(delta)
            j = j +1;
            Pr(j).delta = delta(i_d);% Specification threshold
            Pr(j).epsilon = epsilon(i_e);% Probability threshold
            Pr(j).dSigLev = significanceLevel(i_s);% Desired significance level
            for i = 1 : number_of_simulation
                [ratio,N,A,exTimeAverage,totalTime]= HPSTL(epsilon(i_e),significanceLevel(i_s),delta(i_d));
                Pr(j).time(i) = totalTime;% Sampling + execution of the algorithm
                Pr(j).ratio(i) = ratio;
                Pr(j).N(i) = N; % Sampling cost
                Pr(j).A(i) = A; % The obtained assertation by the propose algorithm
                Pr(j).exTimeAverage(i) = exTimeAverage; % Total sampling time for the given parameters
                Pr(j).algTime(i) = totalTime - exTimeAverage;
                [sum(Pr(j).A)/length(Pr(j).A) Pr(j).dSigLev j i]
            end
            save('timeRespon6.mat')
            
        end
    end
end
