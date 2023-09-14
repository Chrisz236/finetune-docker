# Dockerfile for LLaMA Efficient Tuning

A Dockerfile to build Docker image to fine-tuning the LLaMA model, using [LLaMA-Efficient-Tuning](https://github.com/hiyouga/LLaMA-Efficient-Tuning) project

### Prerequisities


In order to run this container you'll need docker installed.

* [Windows](https://docs.docker.com/windows/started)
* [OS X](https://docs.docker.com/mac/started/)
* [Linux](https://docs.docker.com/linux/started/)


### Usage

Clone the Repo to your computer

```shell
git clone https://github.com/Chrisz236/finetune-docker.git
```

Build image with docker build command

```shell
cd finetune-docker
docker build -t fine-tuning .
```

This process may take a while to complete, the final image is around 20GB

Once build complete, you can use `docker images` command to check image

You should see

```shell
$ docker images
REPOSITORY                          TAG       IMAGE ID       CREATED        SIZE
fine-tuning                         latest    xxxxxxxxxxxx   1 minute ago   19.9GB
hello-world                         latest    9c7a54a9a43c   4 months ago   13.3kB
```

Run your image

```shell
docker run -it --gpus all --runtime=nvidia -d -p 2222:22 fine-tuning
```

You can replace `2222` to any other port number you want to ssh connect the image

**Remember change the "password" in ssh section before build image**