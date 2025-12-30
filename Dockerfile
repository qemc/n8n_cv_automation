# 1. Base Image: Lightweight Python for ARM64 (works on Pi)
FROM python:3.11-slim

# 2. Set Environment Variables
# Prevents Python from buffering stdout/stderr (so logs show up immediately)
ENV PYTHONUNBUFFERED=1
# Prevents Python from writing pyc files to disc
ENV PYTHONDONTWRITEBYTECODE=1

# 3. Install System Dependencies
# Camoufox is based on Firefox, which needs these system libraries to run headless.
# We also install 'curl' to help with healthchecks if needed.
RUN apt-get update && apt-get install -y \
    git \            
    wget \
    curl \
    gnupg \
    procps \
    libgtk-3-0 \          
    libdbus-glib-1-2 \
    libglib2.0-0 \
    libnss3 \
    libnspr4 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libdbus-1-3 \
    libxcb1 \
    libxkbcommon0 \
    libx11-6 \
    libxcomposite1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libpango-1.0-0 \
    libcairo2 \
    libasound2 \
    && rm -rf /var/lib/apt/lists/*

# 4. Set Work Directory
WORKDIR /app

# 5. Install Python Dependencies
# We COPY only requirements.txt first to leverage Docker caching.
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 6. Install Camoufox Browser Engine
# This downloads the actual browser binary (~200MB) into the image
RUN python -m camoufox fetch

# 7. (Optional) Copy Code
# Even though you use volumes, keeping this line is best practice.
# It ensures the image works even if you forget to mount the volume later.
COPY . .

# 8. Start the Application
# We use "--host 0.0.0.0" so the container is accessible from outside
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]