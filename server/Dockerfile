# Production-ready Dockerfile for FastAPI Application
# Compatible with Render, Railway, Heroku, and local Docker deployments

# Use official Python 3.11 slim image as base
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Set environment variables for Python optimization
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Install system dependencies if needed (uncomment if you need additional packages)
# RUN apt-get update && \
#     apt-get install -y --no-install-recommends \
#     gcc \
#     && rm -rf /var/lib/apt/lists/*

# Copy requirements.txt first for better Docker layer caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application source code
COPY . .

# Create a non-root user for security (optional but recommended for production)
# RUN useradd -m -u 1000 appuser && chown -R appuser:appuser /app
# USER appuser

# Expose port 8000 (note: cloud platforms may override this with $PORT)
EXPOSE 8000

# Health check (optional but recommended for production)
# Uses Python's urllib to avoid external dependencies, with shell expansion for PORT
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD sh -c "python -c \"import urllib.request; urllib.request.urlopen('http://localhost:${PORT:-8000}/health', timeout=5)\" || exit 1"

# Run the application using uvicorn
# Uses sh -c for environment variable expansion
# Defaults to port 8000 if $PORT is not set (for Render/Railway compatibility)
CMD ["sh", "-c", "uvicorn app.main:app --host 0.0.0.0 --port ${PORT:-8000}"]

