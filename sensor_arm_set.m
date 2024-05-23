%%Load robot info
% UR5e = loadrobot('universalUR5e');
% initialIKGuess = homeConfiguration(UR5e);
% % Adjust body transformations from previous URDF version
% tform=UR5e.Bodies{3}.Joint.JointToParentTransform;
% UR5e.Bodies{3}.Joint.setFixedTransform(tform*eul2tform([pi/2,0,0]));
% tform=UR5e.Bodies{4}.Joint.JointToParentTransform;
% UR5e.Bodies{4}.Joint.setFixedTransform(tform*eul2tform([-pi/2,0,0]));
% tform=UR5e.Bodies{7}.Joint.JointToParentTransform;
% UR5e.Bodies{7}.Joint.setFixedTransform(tform*eul2tform([-pi/2,0,0]));
% 
% ik = inverseKinematics("RigidBodyTree",UR5e); % Create Inverse kinematics solver
% ikWeights = [0.25 0.25 0.25 0.1 0.1 .1]; % configuration weights for IK solver [Translation Orientation] see documentation
% 
% 
% initialIKGuess(1).JointPosition = -0.5; %first joint, rotating
% initialIKGuess(2).JointPosition = -0.5;
% initialIKGuess(3).JointPosition = 2.7; 
% initialIKGuess(4).JointPosition = -2.2; %lower
% initialIKGuess(5).JointPosition = 0; %swing of final joint
% trajGoal = packTrajGoal(initialIKGuess,trajGoal);
% sendGoal(trajAct,trajGoal); 

gripperTranslation = [0.05 0.25 0.15]; 
gripperRotation = [pi -pi 0]; 
tform = eul2tform(gripperRotation); 
tform(1:3,4) = gripperTranslation'; 
[configSoln, solnInfo] =ik('tool0',tform,ikWeights,initialIKGuess);
trajGoal = packTrajGoal(configSoln,trajGoal); 
sendGoal(trajAct,trajGoal); 