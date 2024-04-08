source="source install/setup.bash"
vscode="code ./"
foxglovecmd="ros2 launch foxglove_bridge foxglove_bridge_launch.xml port:=8765"
rmcmd="ros2 launch rm_vision_bringup vision_bringup.launch.py "
foxglove="foxglove-studio"
sec=0.5

cd /home/mechax/zyb/shaobin_left/pitch/mechax_cv_trajectory
$source

echo "End self-start"
echo "mechax2024" | sudo -S sudo systemctl stop mechax.service

sleep $sec

echo "Start vscode"
$vscode

sleep $sec

echo "Start rm"
gnome-terminal -- bash -c "$rmcmd"

sleep $sec

echo "Start foxglove"
$source
gnome-terminal -- bash -c "$foxglovecmd"

sleep $sec

echo "Start foxglove-studio"
gnome-terminal -- bash -c "$foxglove"

sleep $sec

echo "End self-start"
echo "mechax2024" | sudo -S sudo systemctl stop mechax.service

sleep $sec

echo "Finished"
 


