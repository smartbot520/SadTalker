FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies and Python
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y \
    python3.10 python3.10-dev python3.10-distutils \
    ffmpeg git curl wget unzip libgl1 libglib2.0-0 libsm6 libxrender1 libxext6 && \
    rm -rf /var/lib/apt/lists/*

# Install pip
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3.10

# Set python and pip aliases
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.10 1 && \
    update-alternatives --install /usr/bin/pip pip /usr/local/bin/pip 1

# Copy code to container
WORKDIR /app
COPY . .

# Install torch, gdown, and project requirements
RUN pip install torch==1.12.1 torchvision==0.13.1 --extra-index-url https://download.pytorch.org/whl/cpu
RUN pip install gdown
RUN pip install -r requirements.txt

# Create checkpoints folder and download files
RUN mkdir -p checkpoints && \
    gdown --id 17Zsxk2GhCZYL6DOUdsNYn2fXcNzKe6jp -O checkpoints/GFPGANv1.3.pth && \
    gdown --id 1kJkMnxPzxMqnsIZvXTHqBKm0LT5sAY6d -O checkpoints/mapping_00109-model.pth.tar && \
    gdown --id 1yM7yN9hb6Eyu-IsETkK7h-KvzIPdsARE -O checkpoints/mapping_00229-model.pth.tar && \
    gdown --id 1O3M7lXtX8EJ2T7dzEyMBcMINRcCm8Dow -O checkpoints/SadTalker_V0.0.2_256.safetensors

CMD ["python", "inference.py", "--driven_audio", "telugu_audio_shorts.wav", "--source_image", "myavatar.jpg", "--enhancer", "gfpgan", "--result_dir", "results/"]
