#! /bin/bash
while 1>0
do
    #xterm -hold -e "roscore" &
    xterm -hold -e "rosbag play /home/MSc/data/Rosbags/rotation_18_y.bag /cam0/image_raw:=/dvs/image_raw /cam0/events:=/dvs/events" 
    sleep 56
done