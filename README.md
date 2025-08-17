# 🚀 Animated Chatbot - Docker Multistage Project

A high-performance, interactive chatbot with stunning animated backgrounds, built specifically to demonstrate Docker multistage builds for optimized containerization.

![Chatbot Demo](https://img.shields.io/badge/Status-Ready-brightgreen)
![Docker](https://img.shields.io/badge/Docker-Multistage-blue)
![Node.js](https://img.shields.io/badge/Node.js-18+-green)
![Socket.IO](https://img.shields.io/badge/Socket.IO-Real--time-orange)

## ✨ Features

### 🎨 Visual Features
- **Full-screen animated background** with multiple layers:
  - Twinkling stars animation
  - Floating particles
  - Grid overlay with movement
  - Interactive orbs
  - Data stream effects
- **Black theme** with cyan accents
- **Responsive design** for all devices
- **Interactive elements**:
  - Mouse trail effects
  - Click ripple animations
  - Floating orbs
  - Particle systems

### 🤖 Chatbot Features
- **Real-time messaging** using Socket.IO
- **Intelligent responses** with context awareness
- **Typing indicators** for realistic interaction
- **Message animations** with typewriter effects
- **Connection status** indicators
- **Auto-reconnect** functionality

### 🐳 Docker Features
- **Multistage builds** for optimized images
- **Multiple target stages**:
  - Development (with hot reloading)
  - Build (for testing and building)
  - Production (optimized for deployment)
  - Production-optimized (minimal size)
  - Multi-architecture support
- **Security best practices**:
  - Non-root user execution
  - Health checks
  - Proper signal handling

## 🏗️ Docker Multistage Build Architecture

This project demonstrates advanced Docker multistage build techniques:

### Stage 1: Development
```dockerfile
FROM node:18-alpine AS development
```
- Includes all development dependencies
- Hot reloading with nodemon
- Volume mounting for live code changes
- Git and curl for development tools

### Stage 2: Build
```dockerfile
FROM node:18-alpine AS build
```
- Build dependencies (python3, make, g++)
- Runs tests and builds application
- Prepares optimized assets

### Stage 3: Production
```dockerfile
FROM node:18-alpine AS production
```
- Only production dependencies
- Non-root user for security
- Health checks
- Optimized for deployment

### Stage 4: Production-Optimized
```dockerfile
FROM node:18-alpine AS production-optimized
```
- Minimal base image
- Dumb-init for proper signal handling
- Smallest possible image size

### Stage 5: Multi-Architecture
```dockerfile
FROM --platform=$BUILDPLATFORM node:18-alpine AS multiarch
```
- Supports multiple CPU architectures
- Cross-platform compatibility

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose
- Node.js 18+ (for local development)

### Development Mode
```bash
# Start development environment
docker-compose --profile dev up --build

# Or build specific development stage
docker build --target development -t chatbot-dev .
docker run -p 3000:3000 -v $(pwd):/app chatbot-dev
```

### Production Mode
```bash
# Start production environment
docker-compose --profile prod up --build

# Or build specific production stage
docker build --target production -t chatbot-prod .
docker run -p 3000:3000 chatbot-prod
```

### Optimized Production
```bash
# Start optimized production environment
docker-compose --profile optimized up --build

# Or build optimized stage
docker build --target production-optimized -t chatbot-optimized .
docker run -p 3000:3000 chatbot-optimized
```

### Multi-Architecture Build
```bash
# Build for multiple architectures
docker buildx build --platform linux/amd64,linux/arm64 --target multiarch -t chatbot-multiarch .
```

## 📁 Project Structure

```
Docker-multistage-project/
├── public/
│   ├── index.html          # Main HTML file
│   ├── styles.css          # Animated CSS styles
│   └── script.js           # Frontend JavaScript
├── server.js               # Express + Socket.IO server
├── package.json            # Node.js dependencies
├── Dockerfile              # Multistage Docker build
├── docker-compose.yml      # Docker Compose configuration
├── .dockerignore           # Docker ignore file
└── README.md              # This file
```

## 🎯 Docker Compose Profiles

### Development Profile
```bash
docker-compose --profile dev up
```
- Hot reloading enabled
- Volume mounting for live development
- All development tools included

### Production Profile
```bash
docker-compose --profile prod up
```
- Optimized production build
- Nginx reverse proxy
- SSL support (if configured)

### Monitoring Profile
```bash
docker-compose --profile monitoring up
```
- Prometheus metrics collection
- Grafana dashboards
- Application monitoring

### Redis Profile
```bash
docker-compose --profile redis up
```
- Redis for session storage
- Enhanced scalability

## 🔧 Configuration

### Environment Variables
```bash
NODE_ENV=production    # Environment mode
PORT=3000             # Application port
```

### Nginx Configuration
Create `nginx.conf` for reverse proxy:
```nginx
events {
    worker_connections 1024;
}

http {
    upstream chatbot {
        server chatbot-prod:3000;
    }
    
    server {
        listen 80;
        server_name localhost;
        
        location / {
            proxy_pass http://chatbot;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection 'upgrade';
            proxy_set_header Host $host;
            proxy_cache_bypass $http_upgrade;
        }
    }
}
```

## 🎮 Interactive Features

### Keyboard Shortcuts
- `Enter` - Send message
- `Ctrl/Cmd + Enter` - Send message
- `Escape` - Clear input

### Easter Eggs
- **Konami Code**: ↑↑↓↓←→←→BA
- **Mouse Effects**: Move mouse to see trails
- **Click Effects**: Click anywhere for ripples

### Chatbot Commands
- Say "hello", "hi", or "hey" for greetings
- Ask about "docker" or "multistage" for special responses
- Say "bye" or "goodbye" for farewells
- Say "thanks" or "thank you" for acknowledgments

## 📊 Performance Optimization

### Image Size Comparison
- **Development**: ~500MB (with dev tools)
- **Production**: ~150MB (optimized)
- **Production-Optimized**: ~120MB (minimal)

### Build Time Optimization
- Layer caching for dependencies
- Parallel stage building
- Selective file copying

### Runtime Optimization
- Non-root user execution
- Health checks
- Proper signal handling
- Memory limits

## 🔍 Monitoring and Debugging

### Health Checks
```bash
# Check container health
docker ps
curl http://localhost:3000/health
```

### Logs
```bash
# View application logs
docker-compose logs chatbot-prod

# Follow logs in real-time
docker-compose logs -f chatbot-prod
```

### Metrics
```bash
# Access Prometheus metrics
curl http://localhost:9090

# Access Grafana dashboard
open http://localhost:3001
```

## 🛠️ Development

### Local Development
```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Build for production
npm run build
```

### Testing
```bash
# Run tests
npm test

# Run tests in Docker
docker build --target build .
```

## 🚀 Deployment

### Docker Hub
```bash
# Build and push to Docker Hub
docker build -t yourusername/chatbot:latest .
docker push yourusername/chatbot:latest
```

### Kubernetes
```bash
# Deploy to Kubernetes
kubectl apply -f k8s/
```

### Cloud Platforms
- **AWS ECS**: Use the production stage
- **Google Cloud Run**: Use the optimized stage
- **Azure Container Instances**: Use the multiarch stage

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with Docker multistage builds
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- **Socket.IO** for real-time communication
- **Express.js** for the web server
- **Docker** for containerization
- **CSS Animations** for visual effects

---

**Made with ❤️ for Docker multistage builds and animated chatbots!**
