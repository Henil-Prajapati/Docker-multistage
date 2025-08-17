#!/bin/bash

# Animated Chatbot - Docker Multistage Build Script
# This script helps build different stages of the Docker multistage build

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [OPTION]"
    echo ""
    echo "Options:"
    echo "  dev           Build development stage"
    echo "  build         Build build stage"
    echo "  prod          Build production stage"
    echo "  optimized     Build production-optimized stage"
    echo "  multiarch     Build multi-architecture stage"
    echo "  all           Build all stages"
    echo "  clean         Clean all images"
    echo "  run-dev       Run development container"
    echo "  run-prod      Run production container"
    echo "  compose-dev   Run with docker-compose (dev profile)"
    echo "  compose-prod  Run with docker-compose (prod profile)"
    echo "  help          Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 dev"
    echo "  $0 prod"
    echo "  $0 compose-dev"
}

# Function to build a specific stage
build_stage() {
    local stage=$1
    local tag="chatbot-${stage}"
    
    print_status "Building ${stage} stage..."
    docker build --target ${stage} -t ${tag} .
    
    if [ $? -eq 0 ]; then
        print_success "Successfully built ${stage} stage as ${tag}"
        
        # Show image size
        local size=$(docker images ${tag} --format "table {{.Size}}" | tail -n 1)
        print_status "Image size: ${size}"
    else
        print_error "Failed to build ${stage} stage"
        exit 1
    fi
}

# Function to build all stages
build_all() {
    print_status "Building all stages..."
    
    build_stage "development"
    build_stage "build"
    build_stage "production"
    build_stage "production-optimized"
    
    print_success "All stages built successfully!"
}

# Function to clean images
clean_images() {
    print_status "Cleaning Docker images..."
    
    # Remove chatbot images
    docker images | grep chatbot | awk '{print $3}' | xargs -r docker rmi -f
    
    # Remove dangling images
    docker image prune -f
    
    print_success "Cleanup completed!"
}

# Function to run container
run_container() {
    local stage=$1
    local tag="chatbot-${stage}"
    local port=${2:-3000}
    
    print_status "Running ${stage} container on port ${port}..."
    
    # Check if image exists
    if ! docker images | grep -q ${tag}; then
        print_warning "Image ${tag} not found. Building first..."
        build_stage ${stage}
    fi
    
    # Run container
    docker run -d --name chatbot-${stage} -p ${port}:3000 ${tag}
    
    if [ $? -eq 0 ]; then
        print_success "Container started successfully!"
        print_status "Access the application at: http://localhost:${port}"
        print_status "To stop: docker stop chatbot-${stage}"
        print_status "To remove: docker rm chatbot-${stage}"
    else
        print_error "Failed to start container"
        exit 1
    fi
}

# Function to run docker-compose
run_compose() {
    local profile=$1
    
    print_status "Running docker-compose with ${profile} profile..."
    
    docker-compose --profile ${profile} up --build -d
    
    if [ $? -eq 0 ]; then
        print_success "Docker Compose started successfully!"
        print_status "Access the application at: http://localhost:3000"
        print_status "To stop: docker-compose down"
        print_status "To view logs: docker-compose logs -f"
    else
        print_error "Failed to start Docker Compose"
        exit 1
    fi
}

# Function to build multi-architecture
build_multiarch() {
    print_status "Building multi-architecture images..."
    
    # Check if buildx is available
    if ! docker buildx version > /dev/null 2>&1; then
        print_error "Docker buildx is not available. Please install Docker Buildx."
        exit 1
    fi
    
    # Create and use new builder if needed
    docker buildx create --name chatbot-builder --use 2>/dev/null || true
    
    # Build for multiple architectures
    docker buildx build --platform linux/amd64,linux/arm64 \
        --target multiarch \
        -t chatbot-multiarch:latest \
        --push .
    
    if [ $? -eq 0 ]; then
        print_success "Multi-architecture build completed!"
    else
        print_error "Failed to build multi-architecture images"
        exit 1
    fi
}

# Main script logic
case "${1:-help}" in
    "dev")
        build_stage "development"
        ;;
    "build")
        build_stage "build"
        ;;
    "prod")
        build_stage "production"
        ;;
    "optimized")
        build_stage "production-optimized"
        ;;
    "multiarch")
        build_multiarch
        ;;
    "all")
        build_all
        ;;
    "clean")
        clean_images
        ;;
    "run-dev")
        run_container "development" 3000
        ;;
    "run-prod")
        run_container "production" 3000
        ;;
    "compose-dev")
        run_compose "dev"
        ;;
    "compose-prod")
        run_compose "prod"
        ;;
    "compose-optimized")
        run_compose "optimized"
        ;;
    "compose-monitoring")
        run_compose "monitoring"
        ;;
    "help"|*)
        show_usage
        ;;
esac
