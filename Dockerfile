# Base image
FROM nvidia/cuda:11.7.1-cudnn8-devel-ubuntu20.04

ENV CUDA_VERSION 11.7

ENV PYTHONUNBUFFERED=1
ENV TZ America/Los_Angeles

# Enable nvcc and tmux everytime ssh connected
COPY add_to_bashrc.sh .
RUN cat add_to_bashrc.sh >> /root/.bashrc \
    && rm add_to_bashrc.sh

# Essential softwares
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl \
    git \
    git-lfs \
    nano \
    htop \
    tmux \
    wget \
    file \
    tree \
    openssh-server \
    build-essential \
    apt-utils \
    ca-certificates \
    python3.10 \
    python3-pip \
    python-is-python3 \
    nvidia-driver-525 \
    cuda-cudart-11-7 \
    nvidia-docker2 \
    software-properties-common \
    nvidia-container-toolkit \
    && rm -rf /var/lib/apt/lists/*

# ssh
RUN mkdir /var/run/sshd \
    && echo 'root:password' | chpasswd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

EXPOSE 22

RUN pip install --upgrade pip

# Install conda
RUN curl https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o /miniconda.sh \
    && bash /miniconda.sh -b -p /root/miniconda3 \
    && rm /miniconda.sh

ENV PATH="/root/miniconda3/bin:$PATH"

RUN conda update -n base -c defaults conda

# Install nvitop tool
RUN conda init bash \
    && . /root/.bashrc \
    && pip install --upgrade nvitop

RUN mkdir -p /root/github \
    && mkdir /root/download

WORKDIR /root/github

# Download LLaMA Efficient Tuning repo
RUN git clone https://github.com/hiyouga/LLaMA-Efficient-Tuning.git

# Setup llama_etuning venv
RUN conda init bash \
    && . /root/.bashrc \
    && conda create -n llama_etuning python=3.10 \
    && conda activate llama_etuning \
    && cd LLaMA-Efficient-Tuning \
    && pip install -r requirements.txt \
    && pip install --upgrade huggingface_hub \
    && pip install bitsandbytes \
    && conda deactivate

WORKDIR /

# start sshd
CMD ["/usr/sbin/sshd","-D"]
