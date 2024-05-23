%%Trial
%gripperTranslation = [-0.42 0.75 0.125]; 
drop_location = [-0.42 0.75 0.15];
pick_location = [-0.42 0.75 0.125];
%gripperTranslation = drop_location; 
%gripperTranslation = pick_location; 
gripperTranslation = [-0.21 0.89 0.07]; 
gripperRotation = [-pi/2 -pi 0]; %  [Z Y X]radian [ Z=on the side y=further away from the arm X=hieght of the table]

tform = eul2tform(gripperRotation); tform(1:3,4) = gripperTranslation'; % set translation in homogeneous transform
[configSoln, solnInfo] =ik('tool0',tform,ikWeights,initialIKGuess);
trajGoal = packTrajGoal(configSoln,trajGoal); sendGoal(trajAct,trajGoal); 

