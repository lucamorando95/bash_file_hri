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

session="test"

tmux new-session -d -s $session -n home





read -p "Choose the desired Experiments to play:
        - RRT RVIZ Real Voxl: press 1
        - Mapping Rviz Real Voxl: press 2
        - Complete Mapping Rviz Voxl3 + Holo: Not  available" n1

echo "You pressed  - $n1"
read -p "Continuing in 1.0 seconds..." -t 1.0

if [[ "$n1" -eq 1 ]]; then
   tmux split-window -t $session:1.1 -h 
   tmux split-window -t $session:1.1 -v
   #tmux split-window -t $session:1.3 
   #tmux split-window -t $session:1.3 -v -p 33 
   
   # launch arpl quadrotor control
   tmux send-keys -t $session:1.1 'bash' C-m
   tmux send-keys -t $session:1.1 'cd luca_ws/' C-m
   tmux send-keys -t $session:1.1 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.1 'roslaunch scene_understanding_pkg Kimera_data_rosbag_experiment.launch' C-m
   

   
  read -p "Continuing in 1.5 seconds before launch The recorded Rosbag.." -t 2.5
   
   #Launch the admittance control tele_control_voxl_sim.launch
   tmux send-keys -t $session:1.2 'bash' C-m
   tmux send-keys -t $session:1.2 'cd luca_ws/' C-m
   tmux send-keys -t $session:1.2 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.2 'cd rosbag/voxl3/' C-m
   tmux send-keys -t $session:1.2 'rosbag play 2022-07-19-16-39-05.bag' C-m #This script wait some seconds then roslaunch drone_teleoperation tele_control_voxl_sim.launch
   
     read -p "Continuing in 1.5 seconds before launch RVIZ Drone Teleoperation..." -t 1.5
   
  

   #Launch rviz in another session 
    #Launch the 
   tmux send-keys -t $session:1.3 'bash' C-m
   tmux send-keys -t $session:1.3 'cd voxblox_ws/' C-m
   tmux send-keys -t $session:1.3 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.3 'rosrun rviz rviz -d /home/luca/luca_ws/src/rviz/rrt_voxl3_real_rosbag_1.rviz' C-m
   

  tmux attach-session -t $session

elif  [[ "$n1" -eq 2 ]]; then
  #Launch all the related script for the drone teleoperation in real world using rviz + the mapping techniques 
   tmux split-window -t $session:1.1 -h 
   tmux split-window -t $session:1.1 -v
   tmux split-window -t $session:1.1 -v 
   tmux split-window -t $session:1.3 


    # launch arpl quadrotor control
   tmux send-keys -t $session:1.1 'bash' C-m
   tmux send-keys -t $session:1.1 'cd luca_ws/' C-m
   tmux send-keys -t $session:1.1 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.1 'roslaunch scene_understanding_pkg Kimera_data_rosbag_experiment.launch' C-m
   
    read -p "Continuing in 1.5 seconds ..." -t 1.5
  # launch arpl quadrotor control
   tmux send-keys -t $session:1.2 'bash' C-m
   tmux send-keys -t $session:1.2 'cd luca_ws/' C-m
   tmux send-keys -t $session:1.2 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.2 'rosrun tf2_ros static_transform_publisher 0 0 0 0 0 0 1 /mocap /mocap_sr' C-m
  
   
   read -p "Continuing in 1.5 seconds before launch Voxblox Voxl3..." -t 1.5

    # launch rqt mav manager
   tmux send-keys -t $session:1.3 'bash' C-m
   tmux send-keys -t $session:1.3 'cd voxblox_ws/' C-m
   tmux send-keys -t $session:1.3 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.3 'roslaunch voxblox_ros voxl3.launch' C-m
   
    read -p "Continuing in 1.5 seconds before launch The recorded Rosbag.." -t 2.5
   
   #Launch the admittance control tele_control_voxl_sim.launch
   tmux send-keys -t $session:1.4 'bash' C-m
   tmux send-keys -t $session:1.4 'cd luca_ws/' C-m
   tmux send-keys -t $session:1.4 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.4 'cd rosbag/voxl3/' C-m
   tmux send-keys -t $session:1.4 'rosbag play 2022-07-19-09-48-16.bag' C-m #This script wait some seconds then roslaunch drone_teleoperation tele_control_voxl_sim.launch
   
  
  

   read -p "Continuing in 1.5 seconds before launch RVIZ Drone Teleoperation..." -t 1.5


       #Launch rviz in another session 
    #Launch the 
   tmux send-keys -t $session:1.5 'bash' C-m
   tmux send-keys -t $session:1.5 'cd voxblox_ws/' C-m
   tmux send-keys -t $session:1.5 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.5 'rosrun rviz rviz -d /home/luca/luca_ws/src/rviz/map_voxl3_real_rosbag_1.rviz' C-m

 
  tmux attach-session -t $session

   
else 
    #Launch the complete system Drone + Rviz + Holo
    #In this case Kimera vio (Drone Mapping node) and display mesh rviz are in the same launch file 
    #Moreover also voxblox voxl3 and voxblox holo are in the same launch file
    

   tmux split-window -t $session:1.1 -h 
   tmux split-window -t $session:1.1 -v
   tmux split-window -t $session:1.3 -v -p 33 
   tmux split-window -t $session:1.3 -v -p 33 
   tmux split-window -t $session:1.2 -v -p 33 


      # launch Kimera Vio data 
   tmux send-keys -t $session:1.1 'bash' C-m
   tmux send-keys -t $session:1.1 'cd luca_ws/' C-m
   tmux send-keys -t $session:1.1 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.1 'roslaunch scene_understanding_pkg Kimera_data.launch' C-m #Lancia anche lo script per mesh hololens in rviz
   
   read -p "Mapping voxl Node Launched: 
   Continuing in 1.5 seconds before to launch rviz..." -t 1.5

    #Launch rviz in another session 
    #Launch the 
   tmux send-keys -t $session:1.2 'bash' C-m
   tmux send-keys -t $session:1.2 'cd voxblox_ws/' C-m
   tmux send-keys -t $session:1.2 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.2 'rosrun rviz rviz -d /home/luca/luca_ws/src/rviz/admittance_rviz.rviz' C-m
   
    read -p "Rviz Node Launched: 
   Continuing in 1.5 seconds before to launch rqt mav manager..." -t 1.5
   
   
     # launch rqt mav manager
   tmux send-keys -t $session:1.3 'bash' C-m
   tmux send-keys -t $session:1.3 'cd luca_ws/' C-m
   tmux send-keys -t $session:1.3 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.3 'rosrun rqt_mav_manager rqt_mav_manager' C-m

  read -p "Rqt Node Launched: 
   Continuing in 1.5 seconds before to launch Voxblox..." -t 1.5
   
    # launch rqt mav manager
   tmux send-keys -t $session:1.4 'bash' C-m
   tmux send-keys -t $session:1.4 'cd voxblox_ws/' C-m
   tmux send-keys -t $session:1.4 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.4 'roslaunch voxblox_ros voxl3.launch' C-m

   read -p "Voxblox Launched: 
   Continuing in 1.5 seconds before to the Voxblox Holo node..." -t 1.5
   
    # launch rqt mav manager
   tmux send-keys -t $session:1.5 'bash' C-m
   tmux send-keys -t $session:1.5 'cd voxblox_ws/' C-m
   tmux send-keys -t $session:1.5 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.5 'roslaunch voxblox_ros holo_pointcloud.launch' C-m
   
   read -p "Voxblox Launched: 
   Continuing in 1.5 seconds before to the admittance control node..." -t 1.5


   #Launch the admittance control tele_control_voxl_sim.launch
   tmux send-keys -t $session:1.6 'bash' C-m
   tmux send-keys -t $session:1.6 'cd luca_ws/' C-m
   tmux send-keys -t $session:1.6 './waiting_time_before_launching_admittance_real_holo.bash' C-m #This script wait some seconds then roslaunch drone_teleoperation tele_control_voxl_sim.launch
   




    tmux attach-session -t $session
fi



