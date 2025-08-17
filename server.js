const express = require('express');
const http = require('http');
const socketIo = require('socket.io');
const cors = require('cors');
const helmet = require('helmet');
const compression = require('compression');
const path = require('path');

const app = express();
const server = http.createServer(app);
const io = socketIo(server, {
  cors: {
    origin: "*",
    methods: ["GET", "POST"]
  }
});

// Middleware
app.use(helmet());
app.use(compression());
app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

// Chatbot responses
const chatbotResponses = {
  greetings: [
    "Hello! How can I help you today?",
    "Hi there! What can I assist you with?",
    "Greetings! How may I be of service?",
    "Hey! What's on your mind?"
  ],
  farewells: [
    "Goodbye! Have a great day!",
    "See you later! Take care!",
    "Farewell! Come back anytime!",
    "Bye! It was nice chatting with you!"
  ],
  thanks: [
    "You're welcome!",
    "My pleasure!",
    "Glad I could help!",
    "Anytime!"
  ],
  default: [
    "That's interesting! Tell me more.",
    "I see. Can you elaborate on that?",
    "Interesting point! What else would you like to discuss?",
    "I'm here to listen. What's on your mind?"
  ]
};

// Simple chatbot logic
function getChatbotResponse(message) {
  const lowerMessage = message.toLowerCase();
  
  if (lowerMessage.includes('hello') || lowerMessage.includes('hi') || lowerMessage.includes('hey')) {
    return chatbotResponses.greetings[Math.floor(Math.random() * chatbotResponses.greetings.length)];
  }
  
  if (lowerMessage.includes('bye') || lowerMessage.includes('goodbye') || lowerMessage.includes('see you')) {
    return chatbotResponses.farewells[Math.floor(Math.random() * chatbotResponses.farewells.length)];
  }
  
  if (lowerMessage.includes('thank') || lowerMessage.includes('thanks')) {
    return chatbotResponses.thanks[Math.floor(Math.random() * chatbotResponses.thanks.length)];
  }
  
  if (lowerMessage.includes('docker') || lowerMessage.includes('container')) {
    return "Docker is amazing! It helps create consistent environments across different machines. Are you working on containerization?";
  }
  
  if (lowerMessage.includes('multistage') || lowerMessage.includes('multi-stage')) {
    return "Multistage Docker builds are great for optimizing image size! They allow you to use multiple FROM statements in a single Dockerfile.";
  }
  
  return chatbotResponses.default[Math.floor(Math.random() * chatbotResponses.default.length)];
}

// Socket.IO connection handling
io.on('connection', (socket) => {
  console.log('User connected:', socket.id);
  
  // Send welcome message
  socket.emit('chat message', {
    text: "Hello! I'm your AI assistant. How can I help you today?",
    sender: 'bot',
    timestamp: new Date().toISOString()
  });
  
  // Handle incoming messages
  socket.on('chat message', (data) => {
    console.log('Message received:', data.text);
    
    // Echo user message
    socket.emit('chat message', {
      text: data.text,
      sender: 'user',
      timestamp: new Date().toISOString()
    });
    
    // Simulate typing delay
    setTimeout(() => {
      const botResponse = getChatbotResponse(data.text);
      socket.emit('chat message', {
        text: botResponse,
        sender: 'bot',
        timestamp: new Date().toISOString()
      });
    }, 1000 + Math.random() * 2000);
  });
  
  // Handle disconnection
  socket.on('disconnect', () => {
    console.log('User disconnected:', socket.id);
  });
});

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ status: 'OK', timestamp: new Date().toISOString() });
});

// Serve the main page
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
  console.log(`🚀 Chatbot server running on port ${PORT}`);
  console.log(`📱 Open http://localhost:${PORT} in your browser`);
});
