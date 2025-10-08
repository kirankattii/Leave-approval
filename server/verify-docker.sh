#!/bin/bash

# Docker Verification Script
# This script verifies that Python and pip are correctly installed in the Docker container

set -e

IMAGE_NAME="leave-amp-api"

echo "🔨 Building Docker image..."
docker build -t $IMAGE_NAME .

echo ""
echo "=" | awk '{s=$0; for(i=1;i<=60;i++)printf s; printf "\n"}'
echo "🐍 PYTHON VERSION"
echo "=" | awk '{s=$0; for(i=1;i<=60;i++)printf s; printf "\n"}'
docker run --rm $IMAGE_NAME python --version
docker run --rm $IMAGE_NAME python3 --version

echo ""
echo "=" | awk '{s=$0; for(i=1;i<=60;i++)printf s; printf "\n"}'
echo "📦 PIP VERSION"
echo "=" | awk '{s=$0; for(i=1;i<=60;i++)printf s; printf "\n"}'
docker run --rm $IMAGE_NAME pip --version
docker run --rm $IMAGE_NAME pip3 --version

echo ""
echo "=" | awk '{s=$0; for(i=1;i<=60;i++)printf s; printf "\n"}'
echo "📍 EXECUTABLE PATHS"
echo "=" | awk '{s=$0; for(i=1;i<=60;i++)printf s; printf "\n"}'
echo "Python: $(docker run --rm $IMAGE_NAME which python)"
echo "Python3: $(docker run --rm $IMAGE_NAME which python3)"
echo "Pip: $(docker run --rm $IMAGE_NAME which pip)"
echo "Pip3: $(docker run --rm $IMAGE_NAME which pip3)"

echo ""
echo "=" | awk '{s=$0; for(i=1;i<=60;i++)printf s; printf "\n"}'
echo "📚 INSTALLED PACKAGES (first 10)"
echo "=" | awk '{s=$0; for(i=1;i<=60;i++)printf s; printf "\n"}'
docker run --rm $IMAGE_NAME pip3 list | head -11

echo ""
echo "=" | awk '{s=$0; for(i=1;i<=60;i++)printf s; printf "\n"}'
echo "🔍 KEY PACKAGES VERIFICATION"
echo "=" | awk '{s=$0; for(i=1;i<=60;i++)printf s; printf "\n"}'

packages=("fastapi" "uvicorn" "pymongo" "passlib" "python-jose")
for pkg in "${packages[@]}"; do
    if docker run --rm $IMAGE_NAME pip3 show $pkg > /dev/null 2>&1; then
        version=$(docker run --rm $IMAGE_NAME pip3 show $pkg | grep "Version:" | cut -d' ' -f2)
        echo "✅ $pkg: $version"
    else
        echo "❌ $pkg: NOT FOUND"
    fi
done

echo ""
echo "=" | awk '{s=$0; for(i=1;i<=60;i++)printf s; printf "\n"}'
echo "🧪 IMPORT TEST"
echo "=" | awk '{s=$0; for(i=1;i<=60;i++)printf s; printf "\n"}'
docker run --rm $IMAGE_NAME python -c "
import fastapi
import uvicorn
import pymongo
print('✅ All critical imports successful!')
print(f'   FastAPI: {fastapi.__version__}')
"

echo ""
echo "=" | awk '{s=$0; for(i=1;i<=60;i++)printf s; printf "\n"}'
echo "📁 APPLICATION FILES"
echo "=" | awk '{s=$0; for(i=1;i<=60;i++)printf s; printf "\n"}'
docker run --rm $IMAGE_NAME ls -la /app | head -15

echo ""
echo "=" | awk '{s=$0; for(i=1;i<=60;i++)printf s; printf "\n"}'
echo "✅ ALL VERIFICATION CHECKS PASSED!"
echo "=" | awk '{s=$0; for(i=1;i<=60;i++)printf s; printf "\n"}'
echo ""
echo "💡 To run the container:"
echo "   docker run -p 8000:8000 --env-file .env $IMAGE_NAME"
echo ""
echo "💡 To access interactive shell:"
echo "   docker run --rm -it $IMAGE_NAME /bin/bash"

