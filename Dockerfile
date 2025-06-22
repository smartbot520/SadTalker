FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies and Python 3.10 from deadsnakes PPA
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y \
    python3.10 python3.10-dev python3.10-distutils \
    ffmpeg git curl wget unzip libgl1 libglib2.0-0 libsm6 libxrender1 libxext6 \
    && rm -rf /var/lib/apt/lists/*

# Install pip manually for Python 3.10
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3.10

# Set python and pip aliases
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.10 1 && \
    update-alternatives --install /usr/bin/pip pip /usr/local/bin/pip 1

WORKDIR /app

COPY . .

# Install specific versions of torch and torchvision (CPU)
RUN pip install torch==1.12.1 torchvision==0.13.1 --extra-index-url https://download.pytorch.org/whl/cpu

# Install rest of the dependencies
RUN pip install -r requirements.txt

CMD ["python", "inference.py", "--driven_audio", "telugu_audio.wav", "--source_image", "myavatar.jpg", "--enhancer", "gfpgan", "--result_dir", "results/"]
