function [ratio, N, A, exTimeAverage, totalTime] = HPSTL(in, b_u,dSingnificanceLevel,delta)
tic1 = tic;
global rightinit init_angs_R leftinit init_angs_L vx0 vy0
% 
%Initial Values will be set here
I_1 = [0,b_u]; % interval between 0 to b_u
I_2 = [b_u,1]; % interval between b_u to 1
sigLevel = 1;
exTime = [];
cnt = 0;
s = [];
%
while sigLevel > dSingnificanceLevel
    %
    cnt = cnt +1;
    tic
    for sampling = 1 : 1 % sampling from the model
        walkerResetFcn(in);
        simOut  = sim('walkingRobotRL2D','SaveTime','on','TimeSaveName','tout');
        time = simOut.tout(end);
    end
    exTime(1,cnt)= toc; %consumed time for sampling
    %
    s(cnt) = (time < delta);% inteded specification 
    Nk = length(s);
    T = sum(s);
    if T / Nk < b_u
        z = 1; % interval [0 b]
    else
        z = 2; % interval [b 1]
    end
    if T == 0
        Alpha = (1 - I_1(z))^Nk - (1 - I_2(z))^Nk;
    elseif T == Nk
        Alpha = I_2(z)^Nk-I_1(z)^Nk;
    else
        alpha_a = T;
        beta_a = Nk - T +1;
        alpha_b = T +1;
        beta_b = Nk - T;
        pd_a = makedist('Beta','a',alpha_a,'b',beta_a);
        pd_b = makedist('Beta','a',alpha_b,'b',beta_b);
        Alpha = cdf(pd_b,I_2(z)) - cdf(pd_a,I_1(z));
    end
    sigLevel = 1 - Alpha; %the calculated significance level
end
T / Nk
if (T / Nk) < b_u
    A = 1; %assertation is true
else
    A = 0; %assertation is false
end
ratio = T / Nk;
N = Nk; %sampling cost
exTimeAverage = sum(exTime);% total sampling time
totalTime = toc(tic1);
