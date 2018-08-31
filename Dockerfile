FROM manuelilg/lidar_turtlebot:latest

WORKDIR catkin_ws/src

ADD https://api.github.com/repos/manuelilg/multi_map_navigation/git/refs/heads/master /tmp/git-json/multi_map_navigation.json
RUN git clone https://github.com/manuelilg/multi_map_navigation.git

ADD https://api.github.com/repos/utexas-bwi/bwi_common/git/refs/heads/master /tmp/git-json/bwi_common.json
#RUN git clone -b kinetic --single-branch https://github.com/utexas-bwi/bwi_common.git
RUN git init bwi_common && \
    cd bwi_common && \
    git remote add -f origin https://github.com/utexas-bwi/bwi_common.git && \
    git config core.sparseCheckout true && \
    echo "bwi_tools/" >> .git/info/sparse-checkout && \
    echo "multi_level_map_msgs/" >> .git/info/sparse-checkout && \
    echo "multi_level_map_utils/" >> .git/info/sparse-checkout && \
    echo "multi_level_map_server/" >> .git/info/sparse-checkout && \
    git pull origin kinetic

WORKDIR ../

RUN apt-get update && \
    rosdep update && \
    rosdep install -n --from-paths src --ignore-src -y && \
    . /opt/cartographer_ros/setup.sh && \
    catkin build && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /
