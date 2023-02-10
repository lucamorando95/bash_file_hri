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





read -p "Choose the desired launching session:
        - Drone Teleoperation in Simulation: press 1
        - Drone Teleoperation in Rviz Real: press 2
        - Drone Teleoperation in Real World using Rviz: press 3
        - Drone Teleoperation in Real World using Hololens: press 4
        !!!! [Remember] in case 2 and 3 launch Vicon node and fkie separately" n1

echo "You pressed  - $n1"
read -p "Continuing in 1.0 seconds..." -t 1.0

if [[ "$n1" -eq 1 ]]; then
   tmux split-window -t $session:1.1 -h 
   tmux split-window -t $session:1.1 -v
   tmux split-window -t $session:1.3 -v -p 33 
    tmux split-window -t $session:1.1 -v
    tmux split-window -t $session:1.4 -v -p 33  
    tmux split-window -t $session:1.5
   #tmux split-window -t $session:1.3 -v -p 33 
   
   # launch arpl quadrotor control
   tmux send-keys -t $session:1.1 'bash' C-m
   tmux send-keys -t $session:1.1 'cd luca_ws/' C-m
   tmux send-keys -t $session:1.1 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.1 'roslaunch mav_launch single_quadrotor_sim.launch' C-m
   
    read -p "Continuing in 1.5 seconds before launch RVIZ drone teleoperation..." -t 1.5
   
  

   #Launch rviz in another session 
    #Launch the 
   tmux send-keys -t $session:1.2 'bash' C-m
   tmux send-keys -t $session:1.2 'cd voxblox_ws/' C-m
   tmux send-keys -t $session:1.2 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.2 'rosrun rviz rviz -d /home/luca/luca_ws/src/rviz/rrt_admittance_sim.rviz' C-m
   
   

   
   #Launch the admittance control tele_control_voxl_sim.launch
   tmux send-keys -t $session:1.3 'bash' C-m
   tmux send-keys -t $session:1.3 'cd luca_ws/bash_scripts' C-m
   tmux send-keys -t $session:1.3 './waiting_time_before_launching_admittance.bash' C-m #This script wait some seconds then roslaunch drone_teleoperation tele_control_voxl_sim.launch
   
  
  read -p  "Continuing in 1.5 seconds before launch Kimera script for pc elaboration..." -t 0.5
    # launch Kimera script manager
   tmux send-keys -t $session:1.5 'bash' C-m
   tmux send-keys -t $session:1.5 'cd luca_ws/' C-m
   tmux send-keys -t $session:1.5 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.5 'roslaunch scene_understanding_pkg Kimera_data.launch' C-m
   
  read -p "Do you want to load a virtual map with voxels and real Obstacles?
           if Yes, please make sure that drone teleoperation and Pc elaboration script are in SIM mode  (y/n)" n2
  
  if  [[ $n2 = [y] ]]; then
    #Launch The rosbag with the recorded pointcloud, voxblox to generate the pointcloud and Kimera for elaborating the pointcloud 
   
    
    read -p "Continuing in 1.5 seconds before launch Recorded rosbag..." -t 0.5
    tmux send-keys -t $session:1.4 'bash' C-m
    tmux send-keys -t $session:1.4 'cd luca_ws/' C-m
    tmux send-keys -t $session:1.4 'source devel/setup.bash' C-m 
    tmux send-keys -t $session:1.4 'cd rosbag/voxl3/' C-m
    tmux send-keys -t $session:1.4 'rosbag play 2022-07-31-13-25-02.bag' C-m   # /voxl3/odom:=/voxl3/odom_dev_num

  
  
   read -p  "Continuing in 1.5 seconds before launch VoxBlox for pc elaboration..." -t 0.5
   tmux send-keys -t $session:1.6 'bash' C-m
   tmux send-keys -t $session:1.6 'cd voxblox_ws/' C-m
   tmux send-keys -t $session:1.6 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.6 'roslaunch voxblox_ros voxl3.launch' C-m
   
      #Launch RRT Script
   tmux send-keys -t $session:1.7 'bash' C-m
   tmux send-keys -t $session:1.7 'cd luca_ws/' C-m
   tmux send-keys -t $session:1.7 'source devel/setup.bash' C-m 
   tmux send-keys -t $session:1.7 'cd src/drone_teleoperation/src/rrt/' C-m
   tmux send-keys -t $session:1.7 'python3 rrt_star_2D_with_voxels.py' C-m
   
   #tmux send-keys -t $session:1.3 'source devel/setup.bash' C-m
   #tmux send-keys -t $session:1.3 'roslaunch drone_teleoperation tele_control_voxl_sim.launch' C-m

  else

     #Launch RRT Script
   tmux send-keys -t $session:1.4 'bash' C-m
   tmux send-keys -t $session:1.4 'cd luca_ws/' C-m
   tmux send-keys -t $session:1.4 'source devel/setup.bash' C-m 
   tmux send-keys -t $session:1.4 'cd src/drone_teleoperation/src/rrt/' C-m
   tmux send-keys -t $session:1.4 'python3 rrt_star_2D.py' C-m

   fi



  tmux attach-session -t $session
elif  [[ "$n1" -eq 2 ]]; then
 tmux split-window -t $session:1.1 -h 
   tmux split-window -t $session:1.1 -v
   tmux split-window -t $session:1.3 -v -p 33 
   tmux split-window -t $session:1.3 -v -p 33 
   
   # launch arpl quadrotor control
   tmux send-keys -t $session:1.1 'bash' C-m
   tmux send-keys -t $session:1.1 'cd luca_ws/' C-m
   tmux send-keys -t $session:1.1 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.1 'roscore' C-m
   
    read -p "Continuing in 1.5 seconds before launch RVIZ drone teleoperation..." -t 1.5
   
  

   #Launch rviz in another session 
    #Launch the 
   tmux send-keys -t $session:1.2 'bash' C-m
   tmux send-keys -t $session:1.2 'cd voxblox_ws/' C-m
   tmux send-keys -t $session:1.2 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.2 'rosrun rviz rviz -d /home/luca/luca_ws/src/rviz/rrt_voxl3_for_real_test.rviz' C-m
   
   

   
   #Launch the admittance control tele_control_voxl_sim.launch
   tmux send-keys -t $session:1.3 'bash' C-m
   tmux send-keys -t $session:1.3 'cd luca_ws/bash_scripts' C-m
   tmux send-keys -t $session:1.3 './waiting_time_before_launching_admittance_rviz_voxl.bash' C-m #This script wait some seconds then roslaunch drone_teleoperation tele_control_voxl_sim.launch
   
   #Launch RRT Script
   tmux send-keys -t $session:1.4 'bash' C-m
   tmux send-keys -t $session:1.4 'cd luca_ws/' C-m
   tmux send-keys -t $session:1.4 'source devel/setup.bash' C-m 
   tmux send-keys -t $session:1.4 'cd src/drone_teleoperation/src/rrt/' C-m
   tmux send-keys -t $session:1.4 'python3 rrt_star_2D.py' C-m
   
    read -p "Rviz Node Launched: 
   Continuing in 1.5 seconds before to launch rqt mav manager..." -t 1.5
   
   
     # launch rqt mav manager
   tmux send-keys -t $session:1.5 'bash' C-m
   tmux send-keys -t $session:1.5 'cd luca_ws/' C-m
   tmux send-keys -t $session:1.5 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.5 'rosrun rqt_mav_manager rqt_mav_manager' C-m


   #tmux send-keys -t $session:1.3 'source devel/setup.bash' C-m
   #tmux send-keys -t $session:1.3 'roslaunch drone_teleoperation tele_control_voxl_sim.launch' C-m


  tmux attach-session -t $session


elif  [[ "$n1" -eq 3 ]]; then
  #Launch all the related script for the drone teleoperation in real world using rviz + the mapping techniques 
   tmux split-window -t $session:1.1 -h 
   tmux split-window -t $session:1.1 -v
   tmux split-window -t $session:1.3 -v -p 33 
   tmux split-window -t $session:1.3 -v -p 33 
   
    # launch rqt mav manager
   tmux send-keys -t $session:1.1 'bash' C-m
   tmux send-keys -t $session:1.1 'cd voxblox_ws/' C-m
   tmux send-keys -t $session:1.1 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.1 'roslaunch voxblox_ros voxl3.launch' C-m
  
  read -p "Voxblox voxl Node Launched: 
   Continuing in 1.5 seconds before to launch Kimera data.." -t 1.5

     # launch rqt mav manager
   tmux send-keys -t $session:1.2 'bash' C-m
   tmux send-keys -t $session:1.2 'cd luca_ws/' C-m
   tmux send-keys -t $session:1.2 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.2 'roslaunch scene_understanding_pkg Kimera_data.launch' C-m


   read -p "Voxblox voxl Node Launched: 
   Continuing in 1.5 seconds before to launch rviz..." -t 1.5

    #Launch rviz in another session 
    #Launch the 
   tmux send-keys -t $session:1.3 'bash' C-m
   tmux send-keys -t $session:1.3 'cd voxblox_ws/' C-m
   tmux send-keys -t $session:1.3 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.3 'rosrun rviz rviz -d /home/luca/luca_ws/src/rviz/map_voxl3_for_real_test.rviz' C-m
   
    read -p "Rviz Node Launched: 
   Continuing in 1.5 seconds before to launch rqt mav manager..." -t 1.5
   
   
     # launch rqt mav manager
   tmux send-keys -t $session:1.4 'bash' C-m
   tmux send-keys -t $session:1.4 'cd luca_ws/' C-m
   tmux send-keys -t $session:1.4 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.4 'rosrun rqt_mav_manager rqt_mav_manager' C-m

  read -p "Rqt Node Launched: 
   Continuing in 1.5 seconds before to launch Admittance Controle..." -t 1.5


   #Launch the admittance control tele_control_voxl_sim.launch
   tmux send-keys -t $session:1.5 'bash' C-m
   tmux send-keys -t $session:1.5 'cd luca_ws/bash_scripts' C-m
   tmux send-keys -t $session:1.5 './waiting_time_before_launching_admittance_rviz_voxl.bash' C-m #This script wait some seconds then roslaunch drone_teleoperation tele_control_voxl_sim.launch
   
  

  tmux attach-session -t $session

   
else 
    #Launch the complete system Drone + Rviz + Holo
    #In this case Kimera vio (Drone Mapping node) and display mesh rviz are in the same launch file 
    #Moreover also voxblox voxl3 and voxblox holo are in the same launch file
    

   tmux split-window -t $session:1.1 -h 
   tmux split-window -t $session:1.1 -v
   tmux split-window -t $session:1.2 
   tmux split-window -t $session:1.3 -v -p 33 
   tmux split-window -t $session:1.4 -v -p 33 
   tmux split-window -t $session:1.5 -v
   tmux split-window -t $session:1.6 -v 



      # launch Kimera Vio data 
   tmux send-keys -t $session:1.1 'bash' C-m
   tmux send-keys -t $session:1.1 'cd luca_ws/' C-m
   tmux send-keys -t $session:1.1 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.1 'roslaunch scene_understanding_pkg Kimera_data.launch' C-m #Lancia anche lo script per mesh hololens in rviz

    read -p "Voxblox Launched: 
   Continuing in 1.5 seconds before to the admittance control node..." -t 1.5


   #Launch the admittance control tele_control_voxl_sim.launch
   tmux send-keys -t $session:1.2 'bash' C-m
   tmux send-keys -t $session:1.2 'cd luca_ws/bash_scripts' C-m
   #tmux send-keys -t $session:1.4 './waiting_time_before_launching_admittance_real_holo.bash' C-m #This script wait some seconds then roslaunch drone_teleoperation tele_control_voxl_sim.launch
   tmux send-keys -t $session:1.2 './waiting_time_before_launching_admittance_real_holo.bash' C-m



   
   read -p "Mapping voxl Node Launched: 
   Continuing in 1.5 seconds before to launch rviz..." -t 1.5

    #Launch rviz in another session 
    #Launch the 
   tmux send-keys -t $session:1.3 'bash' C-m
   tmux send-keys -t $session:1.3 'cd voxblox_ws/' C-m
   tmux send-keys -t $session:1.3 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.3 'rosrun rviz rviz -d /home/luca/luca_ws/src/rviz/admittance_rviz.rviz' C-m



   
    read -p "Rviz Node Launched: 
   Continuing in 1.5 seconds before to launch rqt mav manager..." -t 1.5
   
   
     # launch rqt mav manager
   tmux send-keys -t $session:1.4 'bash' C-m
   tmux send-keys -t $session:1.4 'cd luca_ws/' C-m
   tmux send-keys -t $session:1.4 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.4 'rosrun rqt_mav_manager rqt_mav_manager' C-m




  # read -p "Rqt Node Launched: 
  #  Continuing in 1.5 seconds before to launch Voxblox..." -t 1.5
   
  #   # launch rqt mav manager
  #  tmux send-keys -t $session:1.5 'bash' C-m
  #  tmux send-keys -t $session:1.5 'cd voxblox_ws/' C-m
  #  tmux send-keys -t $session:1.5 'source devel/setup.bash' C-m
  #  tmux send-keys -t $session:1.5 'roslaunch voxblox_ros voxl3.launch' C-m

  #  read -p "Voxblox Launched: 
  #  Continuing in 1.5 seconds before to the Voxblox Holo node..." -t 1.5
   
  #   # launch rqt mav manager
  #  tmux send-keys -t $session:1.6 'bash' C-m
  #  tmux send-keys -t $session:1.6 'cd voxblox_ws/' C-m
  #  tmux send-keys -t $session:1.6 'source devel/setup.bash' C-m
  #  tmux send-keys -t $session:1.6 'roslaunch voxblox_ros holo_pointcloud.launch' C-m
   
  #  read -p "Voxblox Launched: 
  #  Continuing in 1.5 seconds before to the admittance control node..." -t 1.5

  
    
  read -p "Do you want to navigate with RRT in Real Obstacles (y) or with Virtual Obstacles (n)?" n2
  
   #Launching RRT WIth vxels or virtual obstacles 
     if  [[ $n2 = [y] ]]; then
                 #Launch RRT Script
   tmux send-keys -t $session:1.5 'bash' C-m
   tmux send-keys -t $session:1.5 'cd luca_ws/' C-m
   tmux send-keys -t $session:1.5 'source devel/setup.bash' C-m 
   tmux send-keys -t $session:1.5 'cd src/drone_teleoperation/src/rrt/' C-m
   tmux send-keys -t $session:1.5 'python3 rrt_star_2D_with_voxels.py' C-m
     else
   tmux send-keys -t $session:1.5 'bash' C-m
   tmux send-keys -t $session:1.5 'cd luca_ws/' C-m
   tmux send-keys -t $session:1.5 'source devel/setup.bash' C-m 
   tmux send-keys -t $session:1.5 'cd src/drone_teleoperation/src/rrt/' C-m
   tmux send-keys -t $session:1.5 'python3 rrt_star_2D.py' C-m
     fi


    tmux attach-session -t $session
fi



