FROM ubuntu:20.04

# Set environment to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    python3.10 python3.10-dev python3-pip \
    ffmpeg git curl wget unzip libgl1 libglib2.0-0 libsm6 libxrender1 libxext6 \
    && rm -rf /var/lib/apt/lists/*

# Set Python 3.10 as default
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.10 1

# Upgrade pip
RUN python -m pip install --upgrade pip

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Install required Python dependencies
RUN pip install torch==1.12.1 torchvision==0.13.1 --extra-index-url https://download.pytorch.org/whl/cpu
RUN pip install -r requirements.txt

# If you have model downloader script, run it here (optional)
# RUN python sadtalker_models_windows.py

CMD ["python", "inference.py", "--driven_audio", "telugu_audio.wav", "--source_image", "myavatar.jpg", "--enhancer", "gfpgan", "--result_dir", "results/"]
