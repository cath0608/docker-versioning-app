# -------- STAGE 1: Build Stage --------
FROM python:3.10-slim AS builder

WORKDIR /app

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install packages
COPY requirements.txt .
RUN pip install --upgrade pip \
    && pip install --prefix=/install -r requirements.txt

# Copy app code
COPY . .

# -------- STAGE 2: Production Image --------
FROM python:3.10-slim

WORKDIR /app

# Copy installed packages from builder stage
COPY --from=builder /install /usr/local
COPY --from=builder /app /app

# Expose port and run
EXPOSE 5000
CMD ["python", "app.py"]
