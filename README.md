# Folding@Home for Docker
A couple of bash scripts to generate and use the [folding@home](https://foldingathome.org/) project from within a [Docker](https://www.docker.com/) container.

## Usage
```
git clone https://github.com/lucastoro/fahclient-docker.git
cd fahclient-docker
./fahclient-docker-build.sh
./fahclient-docker.sh ...
```

`fahclient-docker-build.sh` will generate a `foldingathome` docker image. The image [entrypoint](https://docs.docker.com/engine/reference/builder/#entrypoint) is the `FAHClient` binary.  
`fahclient-docker.sh` will start a container with the generated `foldingathome` image, passing any argument to the container, but tweaking some of them so to simplify sharing resources through the `-v` docker option, so that invoking in the host:
```
run.sh --config whatever/folder/config.xml
```
will work in the container as well (paths will not preserved tho).

## Requirements
This project uses [nvidia-docker](https://github.com/NVIDIA/nvidia-docker) as runtime, while not strictly needed for building the image, it is required for running it.

## References
The image is built on top of [nvidia/cuda](https://hub.docker.com/r/nvidia/cuda/) with some OpenCL additions from [nvidia/opencl](https://hub.docker.com/r/nvidia/opencl).