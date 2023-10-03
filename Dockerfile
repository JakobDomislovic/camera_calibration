FROM lmark1/uav_ros_stack:focal

ARG CATKIN_WORKSPACE=uav_ws
ARG DEBIAN_FRONTEND=noninteractive
ARG HOME=/root

# after every FROM statements all the ARGs get collected and are no longer available. 
ARG ROS_DISTRO=noetic
ARG CATKIN_WORKSPACE=uav_ws
ARG DEBIAN_FRONTEND=nointeractive
ARG HOME=/root

ARG ROS_HOSTNAME=hawk2
ARG ROS_MASTER_URI=http://$ROS_HOSTNAME.local:11311
ARG ROS_IP=$ROS_HOSTNAME.local

# Kalibr stuff
RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
    git wget autoconf automake nano \
    python3-dev python3-pip python3-scipy python3-matplotlib \
    ipython3 python3-wxgtk4.0 python3-tk python3-igraph python3-pyx \
    libeigen3-dev libboost-all-dev libsuitesparse-dev \
    doxygen \
    libopencv-dev \
    libpoco-dev libtbb-dev libblas-dev liblapack-dev libv4l-dev \
    python3-catkin-tools python3-osrf-pycommon

# calibration folder -- this one will be mounted on local machine
RUN mkdir $HOME/calibration

# SSH and Github 
RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

WORKDIR $HOME/$CATKIN_WORKSPACE/src
RUN --mount=type=ssh git clone git@github.com:JakobDomislovic/camera_calibration.git && \
    git clone https://github.com/ethz-asl/kalibr.git


# --------------- build ROS packages ---------------
#WORKDIR $HOME/$CATKIN_WORKSPACE/src
#RUN catkin build --limit-status-rate 0.2 --jobs ${nproc-1}
#RUN rosdep init
#RUN rosdep update

# --------------- install programs ---------------
#RUN sudo apt-get update && sudo apt-get install -q -y \
#    nano


ARG ROS_HOSTNAME=localhost.local
ARG ROS_MASTER_URI=http://localhost.local:11311
ARG ROS_IP=localhost.local

RUN echo " \
export ROS_HOSTNAME=$ROS_HOSTNAME" >> $HOME/.bashrc
RUN echo " \
export ROS_MASTER_URI=$ROS_MASTER_URI" >> $HOME/.bashrc
RUN echo " \
export ROS_IP=$ROS_IP" >> $HOME/.bashrc
