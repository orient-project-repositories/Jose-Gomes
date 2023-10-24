#! /bin/bash
EKLT_BATCH_SIZE=( 50 100 150 200 250 300 350 400 )
EKLT_BLOCK_SIZE=(3 10 20 30 40 50)
EKLT_DISPLACEMENT_PX=0.6
EKLT_LK_WINDOW_SIZE=(10 20 30 40)
EKLT_MAX_CORNERS=100
EKLT_MAX_NUM_ITERATIONS=10
EKLT_MIN_CORNERS=30
EKLT_MIN_DISTANCE=(5 10 15 20 25 30)
EKLT_NUM_PYRAMIDAL_LAYERS=(1 2 3 4 5)
EKLT_PATCH_SIZE=(15 20 25 30 35)
EKLT_QUALITY_LEVEL=(0.01 0.05 0.1 0.2 0.3 0.4 0.5)
EKLT_SCALE=4
EKLT_TRACKING_QUALITY=(0.1 0.3 0.6)

for batches in "${EKLT_BATCH_SIZE[@]}" ; do
    for blocks in "${EKLT_BLOCK_SIZE[@]}" ; do
        for windows in "${EKLT_LK_WINDOW_SIZE[@]}" ; do
            for min_dists in "${EKLT_MIN_DISTANCE[@]}" ; do
                for pyr_layers in "${EKLT_NUM_PYRAMIDAL_LAYERS[@]}" ; do
                    for patches in "${EKLT_PATCH_SIZE[@]}" ; do
                        for quals in "${EKLT_QUALITY_LEVEL[@]}" ; do
                            for track_quals in "${EKLT_TRACKING_QUALITY[@]}" ; do
                                echo "tracks_batch${batches}_block${blocks}_dispx${EKLT_DISPLACEMENT_PX}_lk${windows}_maxc${EKLT_MAX_CORNERS}_min${EKLT_MIN_CORNERS}_maxiter${EKLT_MAX_NUM_ITERATIONS}_mindist${min_dists}_pyr${pyr_layers}_patch${patches}_qual${quals}_scale${EKLT_SCALE}_trqual${track_quals}"
                                xterm -hold -e "roscore"&
                                sleep 5 
                                echo "launching"
                                xterm -hold -e "roslaunch eklt eklt.launch batch_size:=${batches} block_size:=${blocks} displacement_px:=${EKLT_DISPLACEMENT_PX} lk_window_size:=${windows} max_corners:=${EKLT_MAX_CORNERS} min_corners:=${EKLT_MIN_CORNERS} max_num_iterations:=${EKLT_MAX_NUM_ITERATIONS} min_distance:=${min_dists} num_pyramidal_layers:=${pyr_layers} patch_size:=${patches} quality_level:=${quals} scale:=${EKLT_SCALE} tracking_quality:=${track_quals} tracks_file_txt:=/tmp/eklt_example/tracks_batch${batches}_block${blocks}_dispx${EKLT_DISPLACEMENT_PX}_lk${windows}_maxc${EKLT_MAX_CORNERS}_min${EKLT_MIN_CORNERS}_maxiter${EKLT_MAX_NUM_ITERATIONS}_mindist${min_dists}_pyr${pyr_layers}_patch${patches}_qual${quals}_scale${EKLT_SCALE}_trqual${track_quals}.txt v:=1"&
                                sleep 5 
                                xterm -hold -e "rosbag play /home/MSc/data/Rosbags/rotation_18_y.bag /cam0/image_raw:=/dvs/image_raw /cam0/events:=/dvs/events"&
                            done
                        done
                    done
                done
            done
        done
    done
done