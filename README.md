# 🚀 Animated Chatbot - Docker Multistage Project

A high-performance, interactive chatbot with stunning animated backgrounds, built specifically to demonstrate Docker multistage builds for optimized containerization.

![Chatbot Demo](https://img.shields.io/badge/Status-Ready-brightgreen)
![Docker](https://img.shields.io/badge/Docker-Multistage-blue)
![Node.js](https://img.shields.io/badge/Node.js-18+-green)
![Socket.IO](https://img.shields.io/badge/Socket.IO-Real--time-orange)

## ✨ Features

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
**Made with ❤️ for Docker multistage builds and animated chatbots!**
