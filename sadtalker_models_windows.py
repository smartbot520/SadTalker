import os
import urllib.request

# Define model files and their URLs
MODEL_URLS = {
    "checkpoints/mapping_00109-model.pth.tar": "https://github.com/OpenTalker/SadTalker/releases/download/v0.0.2-rc/mapping_00109-model.pth.tar",
    "checkpoints/mapping_00229-model.pth.tar": "https://github.com/OpenTalker/SadTalker/releases/download/v0.0.2-rc/mapping_00229-model.pth.tar",
    "checkpoints/SadTalker_V0.0.2_256.safetensors": "https://github.com/OpenTalker/SadTalker/releases/download/v0.0.2-rc/SadTalker_V0.0.2_256.safetensors",
    # Optional GFPGAN (used for face enhancement)
    "checkpoints/gfpgan/GFPGANv1.3.pth": "https://github.com/TencentARC/GFPGAN/releases/download/v1.3.8/GFPGANv1.3.pth"
}

def ensure_directories():
    os.makedirs("checkpoints", exist_ok=True)
    os.makedirs("checkpoints/gfpgan", exist_ok=True)

def download_file(dest_path, url):
    if os.path.exists(dest_path):
        print(f"✅ Already downloaded: {dest_path}")
        return
    print(f"⬇️ Downloading {os.path.basename(dest_path)}...")
    try:
        urllib.request.urlretrieve(url, dest_path)
        print(f"✅ Downloaded: {dest_path}")
    except Exception as e:
        print(f"❌ Failed to download {url}: {e}")

def main():
    ensure_directories()
    for path, url in MODEL_URLS.items():
        download_file(path, url)

if __name__ == "__main__":
    main()
