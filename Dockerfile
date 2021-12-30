FROM ubuntu:20.04

# for tzdata
ENV DEBIAN_FRONTEND=noninteractive

# https://wiki.blender.org/wiki/Building_Blender/Linux/Ubuntu
RUN apt-get update
RUN apt-get install -y build-essential git subversion cmake libx11-dev libxxf86vm-dev libxcursor-dev libxi-dev libxrandr-dev libxinerama-dev libglew-dev

RUN mkdir -p ~/blender-git
RUN git clone --depth 1 https://git.blender.org/blender.git ~/blender-git/blender
RUN mkdir -p ~/blender-git/lib
RUN cd ~/blender-git/lib && svn checkout https://svn.blender.org/svnroot/bf-blender/trunk/lib/linux_centos7_x86_64

RUN apt-get install software-properties-common -y && add-apt-repository ppa:deadsnakes/ppa && apt-get install python3.8 -y

# for fix link error
RUN rm -rf /usr/lib/gcc/x86_64-linux-gnu/10/libgomp.a
RUN cd ~/blender-git/blender && make update
# `WITH_MEM_JEMALLOC=OFF` for ImportError: /root/blender-git/build_linux_bpy/bin/bpy.so: cannot allocate memory in static TLS block
RUN cd ~/blender-git/blender && make bpy BUILD_CMAKE_ARGS="-DWITH_MEM_JEMALLOC=OFF"
