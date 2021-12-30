PYTHON:=python3.9

blender-git: blender-git/blender blender-git/lib blender-git/bpy
	mkdir -p $@
blender-git/blender:
	git clone --depth 1 https://github.com/blender/blender.git $@
	${MAKE} -C $@ update_code
blender-git/lib:
	mkdir -p $@
	cd $@ && svn checkout https://svn.blender.org/svnroot/bf-blender/trunk/lib/linux_centos7_x86_64

VENV_DIR:=bpy
blender-git/bpy:
	rm -rf blender-git/${VENV_DIR}
	cd blender-git && ${PYTHON} -m venv ${VENV_DIR}

IMAGE_NAME:=notomo/bpy:1.0
build: blender-git
	DOCKER_BUILDKIT=1 docker build --progress=plain -t ${IMAGE_NAME} .
	${MAKE} copy_bpy

TMP_CONTAINER:=tmp_bpy
copy_bpy:
	rm -rf ${VENV_DIR}
	docker create -it --name ${TMP_CONTAINER} ${IMAGE_NAME} sh
	docker cp ${TMP_CONTAINER}:/${VENV_DIR} ${VENV_DIR}
	docker rm -f ${TMP_CONTAINER}

start:
	docker run --rm -it ${IMAGE_NAME} sh

test:
	./${VENV_DIR}/bin/${PYTHON} -c "import bpy"
