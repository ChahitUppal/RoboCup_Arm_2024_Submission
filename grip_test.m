[gripAct,gripGoal] = rosactionclient('/gripper_controller/follow_joint_trajectory','control_msgs/FollowJointTrajectory');
gripAct.FeedbackFcn = [];
gripGoal=packGripGoal(pouch_grip ,gripGoal);
gripGoal=packGripGoal(0. ,gripGoal);
sendGoal(gripAct,gripGoal);