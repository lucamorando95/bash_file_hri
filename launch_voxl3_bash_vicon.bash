#!/bin/bash
#
# tumx启动脚本
# mushan 2016-05-20

# 兼容zsh

###########################################
# If case 1 is selected: Simulation
# - frames: simulator -> mocap_sr (rigid)
# - Admittance: publish on mocap_sr
# - rrt: publish on Mocap src

# if case 2 is selected: Teleoperation in Real World via Rviz + Voxl Mapping
# - frames: mocap -> world -> mocap_sr (rigid mocap World)
# - Admittance: publish on mocap_sr
# - rrt: publish on mocap_sr
# - mapping (Voxblox [In: pointcloud Mocap_sr] [Out: Mesh in World traslata su Mocap_sr])


# if case 3 is selected: Teleoperation in Real World via Holo + Voxl Mapping + Holo Mapping
# - frames: mocap -> world -> mocap_sr (rigid)
# - 



############################################
export DISABLE_AUTO_TITLE="true"

session="Vicon_and_Voxl3"

tmux new-session -d -s $session -n home





   tmux split-window -t $session:1.1 -h 
   tmux split-window -t $session:1.1 -v
   tmux split-window -t $session:1.1 -v
  
  
   tmux send-keys -t $session:1.1 'bash' C-m
   tmux send-keys -t $session:1.1 'cd luca_ws/' C-m
   tmux send-keys -t $session:1.1 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.1 'roscore' C-m

  read -p "Continuing in 1.5 seconds before launch Vicon Node.." -t 0.5
   # launch arpl quadrotor control
   tmux send-keys -t $session:1.2 'bash' C-m
   tmux send-keys -t $session:1.2 'cd luca_ws/' C-m
   tmux send-keys -t $session:1.2 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.2 'roslaunch mocap_vicon vicon.launch' C-m
   

   
    read -p "Continuing in 1.5 seconds before launch Fkie Sync.." -t 0.5
   
#    #Launch the admittance control tele_control_voxl_sim.launch
   tmux send-keys -t $session:1.3 'bash' C-m
   tmux send-keys -t $session:1.3 'cd luca_ws/' C-m
   tmux send-keys -t $session:1.3 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.3 'rosrun master_sync_fkie master_sync' C-m
   
     read -p "Continuing in 1.5 seconds before launch FKie Dicsovery..." -t 0.5
   
  
#  #Launch the admittance control tele_control_voxl_sim.launch
   tmux send-keys -t $session:1.4 'bash' C-m
   tmux send-keys -t $session:1.4 'cd luca_ws/' C-m
   tmux send-keys -t $session:1.4 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.4 'rosrun master_discovery_fkie master_discovery' C-m

#   read -p "Continuing in 1.5 seconds before launch tcp_unity_connector..." -t 0.5
   
  
#  #Launch the admittance control tele_control_voxl_sim.launch
#    tmux send-keys -t $session:1.4 'bash' C-m
#    tmux send-keys -t $session:1.4 'cd luca_ws/' C-m
#    tmux send-keys -t $session:1.4 'source devel/setup.bash' C-m
#    tmux send-keys -t $session:1.4 'roslaunch scene_understanding_pkg tcp_unity_connector.launch' C-m
   


   



  tmux attach-session -t $session




