#!/bin/bash
#
# tumx启动脚本
# mushan 2016-05-20

# 兼容zsh




  #  #Launch Voxl Rosbag


rosbag=$1
STR1="rosbag play --clock "
STR2=$rosbag
STR3=".bag /tf:=/tf_null /from_unity/mocap_frame_in_unity_world_coo:=/from_unity/mocap_frame_in_unity_world_coo_dev_null /holo_mesh_pointcloud_world:=/holo_mesh_pointcloud_world_dev_null  /hololens_position:=/hololens_position_dev_null /mesh_triangles_vertices_marker:=/mesh_triangles_vertices_marker_dev_null /meshes_indices_number:=/meshes_indices_number_dev_null /meshes_vertices_coo:=/meshes_vertices_coo_dev_null /meshes_vertices_indices_list:=/meshes_vertices_indices_list_dev_null /meshes_vertices_number:=/meshes_vertices_number_dev_null"
STRV="$STR1$STR2$STR3"
echo $STRV

source devel/setup.bash
cd rosbag/voxl3
ls
read -p "Press (y) when ready to launch voxl3 rosbag?" n2
  
#Launching RRT WIth vxels or virtual obstacles 

$STRV


