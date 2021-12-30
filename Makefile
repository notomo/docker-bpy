build:
	docker build -t notomo/bpy:1.0 .

test:
	docker run --workdir /root/blender-git/lib/linux_centos7_x86_64/python/bin --rm -it notomo/bpy:1.0 ./python3.9 -c "import bpy"
