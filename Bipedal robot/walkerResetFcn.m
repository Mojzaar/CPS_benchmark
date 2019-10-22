% Helper function to reset walking robot simulation with different initial conditions
%
% Copyright 2019 The MathWorks, Inc.

function walkerResetFcn(in)

% Randomization Parameters
% Note: Y-direction parameters are only used for the 3D walker model
upper_leg_length = 10;
lower_leg_length = 10;
h = 18;
init_height = h;
dim = '2D';
max_displacement_x = 0.05;
max_speed_x = 0.05;
max_displacement_y = 0.025;
max_speed_y = 0.025;

vel_rv1 = normrnd(-0.5/2,sqrt(0.0064));
vel_rv2 = normrnd(-0.5/2,sqrt(0.0064));
xPos_rv1 = normrnd(-0.5/2,sqrt(0.0064));
xPos_rv2 = normrnd(0.5,sqrt(0.028));
yPos_rv = normrnd(0.5,sqrt(0.028));

vel_rv1 = min(max(vel_rv1,-0.5),0);
vel_rv2 = min(max(vel_rv2,-0.5),0);
xPos_rv1 = min(max(xPos_rv1,-0.5),0.5);
xPos_rv2 = min(max(xPos_rv2,0),1);
yPos_rv = min(max(yPos_rv,0),1);

% Chance of randomizing initial conditions

in = in.setVariable('vx0',2*max_speed_x *(vel_rv1));
in = in.setVariable('vy0',2*max_speed_y *(vel_rv2));

leftinit  = [[xPos_rv1;xPos_rv2].*[2*max_displacement_x; max_displacement_y]; -init_height];
rightinit = [-leftinit(1); -yPos_rv*max_displacement_y ; -init_height]; % Ensure feet are symmetrically positioned for stability

% Chance of starting from zero initial conditions

if vel_rv1 == 0
    leftinit  = [0;0;-init_height];
    rightinit = [0;0;-init_height];
end


% Solve Inverse Kinematics for both left and right foot positions
init_angs_L = walkerInvKin(leftinit, upper_leg_length, lower_leg_length, dim);
in = in.setVariable('leftinit',leftinit);
in = in.setVariable('init_angs_L',init_angs_L);

init_angs_R = walkerInvKin(rightinit, upper_leg_length, lower_leg_length, dim);
in = in.setVariable('rightinit',rightinit);
in = in.setVariable('init_angs_R',init_angs_R);
%
set_param('walkingRobotRL2D/Walking Robot/6-DOF Joint','PxVelocityTargetValue',num2str(2*max_speed_x *(vel_rv1)))
%
set_param('walkingRobotRL2D/Walking Robot/Robot Leg R/Ankle Joint','initAngle',num2str(init_angs_R(2)))
set_param('walkingRobotRL2D/Walking Robot/Robot Leg R/Knee Joint','initAngle',num2str(init_angs_R(3)))
set_param('walkingRobotRL2D/Walking Robot/Robot Leg R/Hip Joint','initAngle',num2str(init_angs_R(5)))
% 
set_param('walkingRobotRL2D/Walking Robot/Robot Leg L/Ankle Joint','initAngle',num2str(init_angs_L(2)))
set_param('walkingRobotRL2D/Walking Robot/Robot Leg L/Knee Joint','initAngle',num2str(init_angs_L(3)))
set_param('walkingRobotRL2D/Walking Robot/Robot Leg L/Hip Joint','initAngle',num2str(init_angs_L(5)))

end