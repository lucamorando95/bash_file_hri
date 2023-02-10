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
        - Replay Rosbag Voxl + Map + RRT + Holo: press 5
        - Replay Rosbag Voxl + Map + RRT + Holo + Map Holo: press 6
        !!!! [Remember] in case 2 and 3 launch Vicon node and fkie separately" n1


read -p "Continuing in 1.0 seconds..." -t 1.0

if [[ "$n1" -eq 1 ]]; then
   tmux split-window -t $session:1.1 -h 
   tmux split-window -t $session:1.2 -v
   tmux split-window -t $session:1.1 -v
   #tmux split-window -t $session:1.2 -h
    # tmux split-window -t $session:1.2 -v
   tmux split-window -t $session:1.4 -v   
    # tmux split-window -t $session:1.5
   #tmux split-window -t $session:1.3 -v -p 33 
   
   # launch arpl quadrotor control
  tmux send-keys -t $session:1.1 'bash' C-m
   tmux send-keys -t $session:1.1 'cd hri_ws/' C-m
   tmux send-keys -t $session:1.1 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.1 'roslaunch mav_launch single_quadrotor_sim.launch' C-m
   
   
   
  

   #Launch rviz in another session 
    #Launch the 
   read -p "Continuing in 1.5 seconds before launch RVIZ drone teleoperation..." -t 1.5 
   tmux send-keys -t $session:1.2 'bash' C-m
   tmux send-keys -t $session:1.2 'cd hri_ws/' C-m
   tmux send-keys -t $session:1.2 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.2 'roslaunch scene_understanding_pkg Kimera_data.launch' C-m

   
   
   
  
   read -p  "Continuing in 1.5 seconds to launch Rvz script for pc elaboration..." -t 0.5
    # launch Kimera script manager
   tmux send-keys -t $session:1.3 'bash' C-m
   tmux send-keys -t $session:1.3 'cd luca_ws/' C-m
   tmux send-keys -t $session:1.3 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.3 'rosrun rviz rviz -d /home/luca/luca_ws/src/rviz/rrt_admittance_sim.rviz' C-m
    


  read -p  "Continuing in 1.5 seconds to launch Mapping ..." -t 0.5
    # launch Kimera script manager
   tmux send-keys -t $session:1.4 'bash' C-m
   tmux send-keys -t $session:1.4 'cd hri_ws/' C-m
   tmux send-keys -t $session:1.4 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.4 'roslaunch scene_understanding_pkg mapping.launch' C-m


   read -p  "Continuing in 1.5 seconds before launch Drone Admiyttance Control script for pc elaboration..." -t 2.5
   #Launch the admittance control tele_control_voxl_sim.launch
   tmux send-keys -t $session:1.5 'bash' C-m
   tmux send-keys -t $session:1.5 'cd hri_ws' C-m
   tmux send-keys -t $session:1.5 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.5 'roslaunch drone_teleoperation tele_control_voxl_rviz_real.launch' C-m #This script wait some seconds then roslaunch drone_teleoperation tele_control_voxl_sim.launch



   
  # read -p "Do you want to load a virtual map with voxels and real Obstacles?
  #          if Yes, please make sure that drone teleoperation and Pc elaboration script are in SIM mode  (y/n)" n2
  
  # if  [[ $n2 = [y] ]]; then
  #   #Launch The rosbag with the recorded pointcloud, voxblox to generate the pointcloud and Kimera for elaborating the pointcloud 
   
    
  #   read -p "Continuing in 1.5 seconds before launch Recorded rosbag..." -t 0.5
  #   tmux send-keys -t $session:1.5 'bash' C-m
  #   tmux send-keys -t $session:1.5 'cd luca_ws/' C-m
  #   tmux send-keys -t $session:1.5 'source devel/setup.bash' C-m 
  #   tmux send-keys -t $session:1.5 'cd rosbag/voxl3/' C-m
  #   tmux send-keys -t $session:1.5 'rosbag play 2022-07-31-13-25-02.bag' C-m   # /voxl3/odom:=/voxl3/odom_dev_num

 
  
  #  read -p  "Continuing in 1.5 seconds before launch VoxBlox for pc elaboration..." -t 0.5
  #  tmux send-keys -t $session:1.6 'bash' C-m
  #  tmux send-keys -t $session:1.6 'cd voxblox_ws/' C-m
  #  tmux send-keys -t $session:1.6 'source devel/setup.bash' C-m
  #  tmux send-keys -t $session:1.6 'roslaunch voxblox_ros voxl3.launch' C-m
   
  #     #Launch RRT Script
  #  tmux send-keys -t $session:1.7 'bash' C-m
  #  tmux send-keys -t $session:1.7 'cd luca_ws/' C-m
  #  tmux send-keys -t $session:1.7 'source devel/setup.bash' C-m 
  #  tmux send-keys -t $session:1.7 'cd src/drone_teleoperation/src/rrt/' C-m
  #  tmux send-keys -t $session:1.7 'python3 rrt_star_2D_with_voxels.py' C-m
   
  #  #tmux send-keys -t $session:1.3 'source devel/setup.bash' C-m
  #  #tmux send-keys -t $session:1.3 'roslaunch drone_teleoperation tele_control_voxl_sim.launch' C-m

  # else

  #    #Launch RRT Script
  #  tmux send-keys -t $session:1.5 'bash' C-m
  #  tmux send-keys -t $session:1.5 'cd luca_ws/' C-m
  #  tmux send-keys -t $session:1.5 'source devel/setup.bash' C-m 
  #  tmux send-keys -t $session:1.5 'cd src/drone_teleoperation/src/rrt/' C-m
  #  tmux send-keys -t $session:1.5 'python3 rrt_star_2D.py' C-m

  #  fi



  tmux attach-session -t $session
elif  [[ "$n1" -eq 2 ]]; then
 tmux split-window -t $session:1.1 -h 
   tmux split-window -t $session:1.1 -v
  #  tmux split-window -t $session:1.3 -v -p 33 
  #  tmux split-window -t $session:1.3 -v -p 33 
   
   # launch arpl quadrotor control
  #  tmux send-keys -t $session:1.1 'bash' C-m
  #  tmux send-keys -t $session:1.1 'cd luca_ws/' C-m
  #  tmux send-keys -t $session:1.1 'source devel/setup.bash' C-m
  #  tmux send-keys -t $session:1.1 'roscore' C-m
   
  #  read -p "Continuing in 1.5 seconds before launch RVIZ drone teleoperation..." -t 1.5
   
  

  #  #Launch rviz in another session 
  #   #Launch the 
  #  tmux send-keys -t $session:1.2 'bash' C-m
  #  tmux send-keys -t $session:1.2 'cd voxblox_ws/' C-m
  #  tmux send-keys -t $session:1.2 'source devel/setup.bash' C-m
  #  tmux send-keys -t $session:1.2 'rosrun rviz rviz -d /home/luca/luca_ws/src/rviz/rrt_voxl3_for_real_test.rviz' C-m
   
   

   
   #Launch the admittance control tele_control_voxl_sim.launch
   tmux send-keys -t $session:1.1 'bash' C-m
   tmux send-keys -t $session:1.1 'cd luca_ws' C-m
   tmux send-keys -t $session:1.1 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.1 'roslaunch drone_teleoperation tele_control_voxl_rviz_real.launch' C-m #This script wait some seconds then roslaunch drone_teleoperation tele_control_voxl_sim.launch
   
   #Launch RRT Script
   tmux send-keys -t $session:1.2 'bash' C-m
   tmux send-keys -t $session:1.2 'cd luca_ws/' C-m
   tmux send-keys -t $session:1.2 'source devel/setup.bash' C-m 
   tmux send-keys -t $session:1.2 'cd src/drone_teleoperation/src/rrt/' C-m
   tmux send-keys -t $session:1.2 'python3 rrt_star_2D.py' C-m
   
    read -p "Rviz Node Launched: 
   Continuing in 1.5 seconds before to launch rqt mav manager..." -t 1.5
   
   
     # launch rqt mav manage3
   tmux send-keys -t $session:1.3 'bash' C-m
   tmux send-keys -t $session:1.3 'cd luca_ws/' C-m
   tmux send-keys -t $session:1.3 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.3 'rosrun rqt_mav_manager rqt_mav_manager' C-m


   #tmux send-keys -t $session:1.3 'source devel/setup.bash' C-m
   #tmux send-keys -t $session:1.3 'roslaunch drone_teleoperation tele_control_voxl_sim.launch' C-m


  tmux attach-session -t $session


elif  [[ "$n1" -eq 3 ]]; then
  #Launch all the related script for the drone teleoperation in real world using rviz + the mapping techniques 
   tmux split-window -t $session:1.1 -h 
   tmux split-window -t $session:1.1 -v
   tmux split-window -t $session:1.3 -v -p 33 
   tmux split-window -t $session:1.3 -v -p 33 
   tmux split-window -t $session:1.4
   

   
   #Launch the admittance control tele_control_voxl_sim.launch
   tmux send-keys -t $session:1.1 'bash' C-m
   tmux send-keys -t $session:1.1 'cd luca_ws' C-m
   tmux send-keys -t $session:1.1 './waiting_time_before_launching_admittance_rviz_voxl.bash' C-m #This script wait some seconds then roslaunch drone_teleoperation tele_control_voxl_sim.launch



  
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
   tmux send-keys -t $session:1.3 'cd luca_ws/' C-m
   tmux send-keys -t $session:1.3 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.3 'rosrun rviz rviz -d /home/luca/luca_ws/src/rviz/rrt_admittance_sim.rviz' C-m
   
    read -p "Rviz Node Launched: 
    Continuing in 1.5 seconds before to launch rqt mav manager..." -t 1.5
   
   
     # launch rqt mav manager
   tmux send-keys -t $session:1.4 'bash' C-m
   tmux send-keys -t $session:1.4 'cd luca_ws/' C-m
   tmux send-keys -t $session:1.4 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.4 'rosrun rqt_mav_manager rqt_mav_manager' C-m

  read -p "Rqt Node Launched: 
   Continuing in 1.5 seconds before to launch Admittance Controle..." -t 1.5


 
    # launch rqt mav manager
   tmux send-keys -t $session:1.5 'bash' C-m
   tmux send-keys -t $session:1.5 'cd voxblox_ws/' C-m
   tmux send-keys -t $session:1.5 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.5 'roslaunch voxblox_ros pc_manager.launch' C-m
   
    #Launch RRT Script
   tmux send-keys -t $session:1.6 'bash' C-m
   tmux send-keys -t $session:1.6 'cd luca_ws/' C-m
   tmux send-keys -t $session:1.6 'source devel/setup.bash' C-m 
   tmux send-keys -t $session:1.6 'cd src/drone_teleoperation/src/rrt/' C-m
   tmux send-keys -t $session:1.6 'python3 rrt_star_2D_with_voxels.py' C-m   #rrt_star_2D_with_voxels

  tmux attach-session -t $session

   
elif  [[ "$n1" -eq 4 ]]; then 
    #Launch the complete roscorestem Drone + Rviz + Holo
    #In this case Kimera vio (Drone Mapping node) and display mesh rviz are in the same launch file 
    #Moreover also voxblox voxl3 and voxblox holo are in the same launch file
    

   tmux split-window -t $session:1.1 -h 
   tmux split-window -t $session:1.1 -v
   tmux split-window -t $session:1.2 
   tmux split-window -t $session:1.3 -v -p 33 
   tmux split-window -t $session:1.4 -v -p 33 
   tmux split-window -t $session:1.5 -v
   tmux split-window -t $session:1.6 -v 
   #tmux split-window -t $session:1.7



      # launch Kimera Vio data 
   tmux send-keys -t $session:1.1 'bash' C-m
   tmux send-keys -t $session:1.1 'cd luca_ws/' C-m
   tmux send-keys -t $session:1.1 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.1 'roslaunch scene_understanding_pkg Kimera_data.launch' C-m #Lancia anche lo script per mesh hololens in rviz

    read -p "Voxblox Launched: 
   Continuing in 1.5 seconds before to the admittance control node..." -t 1.5


   #Launch the admittance control tele_control_voxl_sim.launch
   tmux send-keys -t $session:1.2 'bash' C-m
   tmux send-keys -t $session:1.2 'cd luca_ws' C-m
   tmux send-keys -t $session:1.2 'source devel/setup.bash' C-m #This script wait some seconds then roslaunch drone_teleoperation tele_control_voxl_sim.launch
   tmux send-keys -t $session:1.2 'roslaunch drone_teleoperation tele_control_voxl_holo.launch' C-m



   
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




  read -p "Rqt Node Launched: 
   Continuing in 1.5 seconds before to launch Voxblox..." -t 1.5
   
  read -p "Do you want to built map from the Drone (1) or from the Hololens (2)?" n3
  
   #Launching RRT WIth vxels or virtual obstacles 
     if  [[ $n3 = [1] ]]; then
    # launch rqt mav manager
   tmux send-keys -t $session:1.5 'bash' C-m
   tmux send-keys -t $session:1.5 'cd voxblox_ws/' C-m
   tmux send-keys -t $session:1.5 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.5 'roslaunch voxblox_ros voxl3.launch' C-m
   read -p "Voxblox Drone Launched." 
   else
   tmux send-keys -t $session:1.5 'bash' C-m
   tmux send-keys -t $session:1.5 'cd voxblox_ws/' C-m
   tmux send-keys -t $session:1.5 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.5 'roslaunch voxblox_ros holo_pointcloud.launch' C-m
   echo "Voxblox Hololens Launched." 
   fi

   echo "Voxblox Launched: 
   Continuing in 1.5 seconds before to the Voxblox Holo node..." -t 1.5
   
    # launch rqt mav manager
   tmux send-keys -t $session:1.6 'bash' C-m
   tmux send-keys -t $session:1.6 'cd luca_ws/' C-m
   tmux send-keys -t $session:1.6 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.6 'rosrun scene_understanding_pkg display_received_meshes_in_rviz' C-m
   
   read -p "Voxblox Launched: 
   Continuing in 1.5 seconds before to the admittance control node..." -t 1.5
  
  
    
  read -p "Do you want to navigate with RRT in Real Obstacles (y) or with Virtual Obstacles (n)?" n2
  
   #Launching RRT WIth vxels or virtual obstacles 
     if  [[ $n2 = [y] ]]; then
                 #Launch RRT Script
   tmux send-keys -t $session:1.7 'bash' C-m
   tmux send-keys -t $session:1.7 'cd luca_ws/' C-m
   tmux send-keys -t $session:1.7 'source devel/setup.bash' C-m 
   tmux send-keys -t $session:1.7 'cd src/drone_teleoperation/src/rrt/' C-m
   tmux send-keys -t $session:1.7 'python3 rrt_star_2D_with_voxels.py' C-m
     else
   tmux send-keys -t $session:1.7 'bash' C-m
   tmux send-keys -t $session:1.7 'cd luca_ws/' C-m
   tmux send-keys -t $session:1.7 'source devel/setup.bash' C-m 
   tmux send-keys -t $session:1.7 'cd src/drone_teleoperation/src/rrt/' C-m
   tmux send-keys -t $session:1.7 'python3 rrt_star_2D.py' C-m
     fi


    tmux attach-session -t $session

elif  [[ "$n1" -eq 5 ]]; then
  # Case Launched to replay rosbag configuring the correct simulatiin environment 
   read -p "Which rosbag you would like to replay: " rosbag
   STR1="rosbag play --clock "
   STR2=$rosbag
   STR3=".bag" #/from_unity/mocap_frame_in_unity_world_coo:=/from_unity/mocap_frame_in_unity_world_coo_dev_null /unity_to_ros/interactive_marker_position:=/unity_to_ros/interactive_marker_position"
   STR="$STR1$STR2$STR3"
  


  tmux split-window -t $session:1.1 -h 
   tmux split-window -t $session:1.1 -v
   tmux split-window -t $session:1.2
  

       # launch Kimera Vio data 
   tmux send-keys -t $session:1.1 'bash' C-m
   tmux send-keys -t $session:1.1 'cd luca_ws/' C-m
   tmux send-keys -t $session:1.1 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.1 'cd rosbag/voxl3' C-m
   tmux send-keys -t $session:1.1 "$STR" C-m 
   
      # launch Kimera Vio data 
   tmux send-keys -t $session:1.2 'bash' C-m
   tmux send-keys -t $session:1.2 'cd luca_ws/' C-m
   tmux send-keys -t $session:1.2 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.2 'roslaunch scene_understanding_pkg Kimera_data_for_rosbag.launch' C-m #Lancia anche lo script per mesh hololens in rviz
   
    # launch rqt mav manager
   tmux send-keys -t $session:1.3 'bash' C-m
   tmux send-keys -t $session:1.3 'cd voxblox_ws/' C-m
   tmux send-keys -t $session:1.3 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.3 'roslaunch voxblox_ros voxl3.launch' C-m

   #Launch rviz in another session 
    #Launch the 
   tmux send-keys -t $session:1.4 'bash' C-m
   tmux send-keys -t $session:1.4 'cd voxblox_ws/' C-m
   tmux send-keys -t $session:1.4 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.4 'rosrun rviz rviz -d /home/luca/luca_ws/src/rviz/admittance_rviz_for_rosbag.rviz' C-m
 
   tmux attach-session -t $session

else
  # Case Launched to replay rosbag configuring the correct simulatiin environment 
      read -p "Select the Voxl3 Rosbag you wish to replay: " rosbag
   STR1="rosbag play --clock "
   STR2_=$rosbag
   STR3=".bag /tf:=/tf_null /from_unity/mocap_frame_in_unity_world_coo:=/from_unity/mocap_frame_in_unity_world_coo_dev_null /holo_mesh_pointcloud_world:=/holo_mesh_pointcloud_world_dev_null  /hololens_position:=/hololens_position_dev_null /mesh_triangles_vertices_marker:=/mesh_triangles_vertices_marker_dev_null /meshes_indices_number:=/meshes_indices_number_dev_null /meshes_vertices_coo:=/meshes_vertices_coo_dev_null /meshes_vertices_indices_list:=/meshes_vertices_indices_list_dev_null /meshes_vertices_number:=/meshes_vertices_number_dev_null"
   STRV="$STR1$STR2_$STR3"
   
   read -p "Select the Holo Map Rosbag you wish to replay: " rosbag_
   STR1="rosbag play --clock "
   STR2=$rosbag_
   STR3=".bag /holo_mesh_pointcloud_world:=/holo_mesh_pointcloud_world_dev_null /hololens_frame:=/hololens_frame_dev_null /voxblox_node_holo/occupied_nodes:=/voxblox_node_holo/occupied_nodes_dev_null /voxblox_node_holo/surface_pointcloud:=/voxblox_node_holo/surface_pointcloud_dev_null /voxblox_node_holo/traversable:=/voxblox_node_holo/traversable_dev_null /mesh_triangles_vertices_marker:=/mesh_triangles_vertices_marker_dev_null /mesh_triangles_marker_wireframe:=/mesh_triangles_marker_wireframe_dev_null"
   STRH="$STR1$STR2$STR3"
   

   tmux split-window -t $session:1.1 -h 
   tmux split-window -t $session:1.1 -v
   tmux split-window -t $session:1.3 -v
   tmux split-window -t $session:1.3 -v
   tmux split-window -t $session:1.1 -v
   tmux split-window -t $session:1.3 -h
  #  tmux split-window -t $session:1.4 

  
    # launch Kimera Vio data 
   tmux send-keys -t $session:1.1 'bash' C-m
   tmux send-keys -t $session:1.1 'cd luca_ws/' C-m
   tmux send-keys -t $session:1.1 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.1 'roslaunch scene_understanding_pkg Kimera_data_for_rosbag.launch' C-m #Lancia anche lo script per mesh hololens in rviz
   
    read -p "Kimera Vio Launched: 
   Continuing in 0.5 seconds before to the Rosbag Voxl node..." -t 0.5
   
  #  #Launch Voxl Rosbag
   tmux send-keys -t $session:1.2 'bash' C-m
   tmux send-keys -t $session:1.2 'cd luca_ws/' C-m
   tmux send-keys -t $session:1.2 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.2 './launch_voxl3_rosbag.bash' " $STR2_" C-m
 
   
    read -p "Rosbag Voxl Launched: 
   Continuing in 0.5 seconds before to the Rosbag Holo node..." -t 0.5

    #Launch Voxl Rosbag
   tmux send-keys -t $session:1.3 'bash' C-m
   tmux send-keys -t $session:1.3 'cd luca_ws/' C-m
   tmux send-keys -t $session:1.3 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.3 'cd rosbag/holo' C-m
   tmux send-keys -t $session:1.3 "$STRH" C-m 
   
    read -p "Rosbag Holo Launched: 
   Continuing in 0.5 seconds before to the Map Holo node..." -t 0.5

 


      
   tmux send-keys -t $session:1.4 'bash' C-m
   tmux send-keys -t $session:1.4 'cd luca_ws/' C-m
   tmux send-keys -t $session:1.4 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.4 'rosrun scene_understanding_pkg display_received_meshes_in_rviz' C-m #Lancia anche lo script per mesh hololens in rviz
   
    read -p "Map Holo Launched: 
   Continuing in 0.5 seconds before to the Voxblox Voxl node..." -t 0.5
 
   tmux send-keys -t $session:1.5 'bash' C-m
   tmux send-keys -t $session:1.5 'cd voxblox_ws/' C-m
   tmux send-keys -t $session:1.5 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.5 'roslaunch voxblox_ros voxl3.launch' C-m

    read -p "Voxblox Voxl Launched: 
   Continuing in 0.5 seconds before to the Voxblox Holo node..." -t 0.5

   tmux send-keys -t $session:1.6 'bash' C-m
   tmux send-keys -t $session:1.6 'cd voxblox_ws/' C-m
   tmux send-keys -t $session:1.6 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.6 'roslaunch voxblox_ros holo_pointcloud.launch' C-m

   read -p "Voxblox Holo Launched: 
   Continuing in 0.5 seconds before to the RVIZ node..." -t 0.5

   tmux send-keys -t $session:1.7 'bash' C-m
   tmux send-keys -t $session:1.7 'cd voxblox_ws/' C-m
   tmux send-keys -t $session:1.7 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.7 'rosrun rviz rviz -d /home/luca/luca_ws/src/rviz/admittance_rviz_holo_map_rosbag.rviz' C-m


  tmux attach-session -t $session

fi



