#!/bin/bash
#
# tumx启动脚本
# mushan 2016-05-20

# 兼容zsh

read -p "[Waiting for admittance voxl rviz real] Press s key to launch the script..." n1
if [[ "$n1" -eq 's' ]]; then
source devel/setup.bash
roslaunch drone_teleoperation tele_control_voxl_rviz_real.launch

fi
