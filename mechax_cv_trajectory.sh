#!/bin/bash
### BEGIN INIT INFO
# Provides:          watchDog
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: start watchDog
# Description:       start watchDog
### END INIT INFO

sec=2
cnt=0
PROC_NAME=rm_serial_driver

cd /home/mechax/ylh/sv_with_no_nav
echo "Starting colcon build"
colcon build
echo "Colcon build finished"

allsource="source /opt/ros/humble/setup.bash"
source="source install/setup.bash"
cmd=("ros2 launch rm_vision_bringup addMVlaunch.py"
	"ros2 launch rm_bringup bringup.launch.py"
	"ros2 launch livox_ros_driver2 msg_MID360_launch.py"
	"ros2 launch linefit_ground_segmentation_ros segmentation.launch.py" 
	"ros2 launch fast_lio mapping.launch.py"
	"ros2 launch imu_complementary_filter complementary_filter.launch.py"
	"ros2 launch pointcloud_to_laserscan pointcloud_to_laserscan_launch.py"
	"ros2 launch icp_localization_ros2 bringup.launch.py"
	"ros2 launch rm_navigation bringup_launch.py "
	"ros2 launch rm_serial_driver serial_driver.launch.py")
echo "Starting launch"
$allsource
$source
$cmd
echo "Launch finished"


sleep $sec

while [ 1 ]
do 
count=$(ps -ef | grep $PROC_NAME | grep -v grep | wc -l)
echo "Thread count: $count"
if [ $count -ne 2 ];then
	echo "Starting $PROC_NAME"
	echo "mechax2024" | sudo -S sudo chmod +777 /dev/ttyUSB0
	$allsource
	$source
	$cmd
	echo "$PROC_NAME has started!"
	sleep $sec
else
	echo "The $PROC_NAME is still alive!"
	sleep $sec
	
fi
done
