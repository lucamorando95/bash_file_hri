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

session="record_rosbag"

tmux new-session -d -s $session -n home





read -p "Choose the desired launching session:
        - Rviz + Drone: Press 1
        - Rviz + Drone + Holo: Press 2
        !!!! [Remember] in case 2 and 3 launch Vicon node and fkie separately" n1

echo "You pressed  - $n1"
read -p "Continuing in 1.0 seconds..." -t 1.0

if [[ "$n1" -eq 1 ]]; then
   tmux -t $session:1.1 
  
   
   #Record Rosbag For Rviz Visualization

   # launch arpl quadrotor control
   tmux send-keys -t $session:1.1 'bash' C-m
   tmux send-keys -t $session:1.1 'cd luca_ws/' C-m
   tmux send-keys -t $session:1.1 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.1 'cd rosbag/voxl3' C-m
   tmux send-keys -t $session:1.1 'rosbag record /voxl3/odom /voxl3/dfs_point_cloud_GF /visualization_marker/line_to_follow /rrt/virtual_obstacle_marker_1 /rrt/virtual_obstacle_marker_2 /rrt/virtual_obstacle_marker_3 /tele_control/robot /rrt/final_goal_marker /visualization_marker/force_arrow' C-m
   
    tmux attach-session -t $session
else 
 tmux -t $session:1.1
   
   # launch arpl quadrotor control
   tmux send-keys -t $session:1.1 'bash' C-m
   tmux send-keys -t $session:1.1 'cd luca_ws/' C-m
   tmux send-keys -t $session:1.1 'source devel/setup.bash' C-m
   tmux send-keys -t $session:1.1 'cd rosbag/voxl3' C-m
   tmux send-keys -t $session:1.1 'rosbag record /voxl3/odom /voxl3/dfs_point_cloud_GF /visualization_marker/line_to_follow /rrt/virtual_obstacle_marker_1 /rrt/virtual_obstacle_marker_2 /rrt/virtual_obstacle_marker_3 /from_unity/mocap_frame_in_unity_world_coo /holo_mesh_pointcloud_world /hololens_frame /hololens_position /mesh_triangles_vertices_marker /mesh_triangles_marker_wireframe /tele_control/robot /rrt/final_goal_marker /visualization_marker/force_arrow /interactive_marker_position /unity_to_ros/interactive_marker_position /rrt/fxed_marker_for_manouver /from_Unity/start_stop_mapping /from_Unity/restart_mapping /rrt/fxed_marker_for_manouver_to_unity /rrt/path2D_to_unity /meshes_vertices_coo /meshes_vertices_indices_list /meshes_vertices_number /meshes_indices_number' C-m

   

    tmux attach-session -t $session
fi



