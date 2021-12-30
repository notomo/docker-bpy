FROM ubuntu:20.04 AS builder

# for tzdata
ENV DEBIAN_FRONTEND=noninteractive

# https://wiki.blender.org/wiki/Building_Blender/Linux/Ubuntu
RUN apt-get update
RUN apt-get install -y build-essential git subversion cmake libx11-dev libxxf86vm-dev libxcursor-dev libxi-dev libxrandr-dev libxinerama-dev libglew-dev
# for fix link error
RUN rm -rf /usr/lib/gcc/x86_64-linux-gnu/10/libgomp.a

COPY ./blender-git /blender-git
# `WITH_MEM_JEMALLOC=OFF` for ImportError: /root/blender-git/build_linux_bpy/bin/bpy.so: cannot allocate memory in static TLS block
RUN cd /blender-git/blender && make bpy BUILD_CMAKE_ARGS="-DWITH_MEM_JEMALLOC=OFF -DWITH_INSTALL_PORTABLE=ON -DCMAKE_INSTALL_PREFIX=/blender-git/bpy/lib/python3.9/site-packages"
RUN cd /blender-git/build_linux_bpy && make install

FROM alpine:3.15
COPY --from=builder /blender-git/bpy ./bpy
