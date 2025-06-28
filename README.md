# Ryjin Racing Application

A comprehensive racing-themed web application featuring real-time chat, racing statistics, live data feeds, and interactive racing world simulation. Built with a hybrid architecture combining Node.js, Java WebSocket server, and modern web technologies.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [Technology Stack](#technology-stack)
- [Project Structure](#project-structure)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [API Endpoints](#api-endpoints)
- [Development](#development)
- [Deployment](#deployment)
- [Contributing](#contributing)
- [License](#license)

## Overview

Ryjin is a sophisticated racing application that combines real-time communication, racing data visualization, and interactive racing world simulation. The application features a modern, racing-themed UI with WebSocket-based real-time chat, comprehensive racing statistics, live data feeds, and an immersive racing environment.

## Features

### Core Features
- **Real-time Chat System**: WebSocket-based chat rooms with user authentication
- **Racing Statistics**: Comprehensive racing data visualization and analysis
- **Live Data Feeds**: Real-time racing data and telemetry
- **Interactive Racing World**: 3D racing environment with particle effects
- **User Authentication**: Secure login and registration system
- **Room Management**: Create, join, and manage chat rooms
- **Responsive Design**: Modern UI optimized for various screen sizes

### Advanced Features
- **Speedometer Visualization**: Real-time speed and performance metrics
- **Headlight Effects**: Dynamic lighting and visual effects
- **Track Effects**: Immersive racing track visualizations
- **Racing API Integration**: External racing data sources
- **Database Integration**: MySQL backend for data persistence
- **Session Management**: Persistent user sessions and preferences

## Architecture

The application follows a hybrid architecture pattern:

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Frontend      │    │   Node.js       │    │   Java          │
│   (HTML/CSS/JS) │◄──►│   Express       │◄──►│   WebSocket     │
│                 │    │   Server        │    │   Server        │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                              │                        │
                              ▼                        ▼
                       ┌─────────────────┐    ┌─────────────────┐
                       │   MySQL         │    │   File System   │
                       │   Database      │    │   Storage       │
                       └─────────────────┘    └─────────────────┘
```

## Technology Stack

### Frontend
- **HTML5**: Semantic markup and structure
- **CSS3**: Advanced styling with custom properties and animations
- **JavaScript (ES6+)**: Modern JavaScript with async/await
- **WebSocket API**: Real-time bidirectional communication
- **Canvas API**: Dynamic graphics and animations

### Backend
- **Node.js**: JavaScript runtime environment
- **Express.js**: Web application framework
- **Java**: Core server implementation
- **WebSocket Server**: Real-time communication handling
- **MySQL**: Relational database management

### Development Tools
- **Maven**: Java project management and build tool
- **npm**: Node.js package management
- **Git**: Version control system

## Project Structure

```
Ryn/
├── src/                    # Java source files
│   ├── com/               # Java package structure
│   ├── WebSocketServer.java
│   ├── ClientHandler.java
│   ├── Room.java
│   ├── User.java
│   └── DatabaseManager.java
├── target/                # Maven build output
├── node_modules/          # Node.js dependencies
├── WEB-INF/              # Web application configuration
├── META-INF/             # Application metadata
├── lib/                  # External libraries
├── imgs/                 # Image assets
├── app.js                # Main application logic
├── server.js             # Express server
├── index.html            # Main HTML file
├── style.css             # Primary stylesheet
├── racingWorld.jsp       # Racing world interface
├── raceData.jsp          # Racing data interface
├── racing-api.js         # Racing API integration
├── livefeed.js           # Live data feed handling
├── speedometers.js       # Speedometer visualization
├── headlights.js         # Lighting effects
├── particles.js          # Particle system
├── track-effects.js      # Track visual effects
├── package.json          # Node.js dependencies
├── pom.xml              # Maven configuration
└── README.md            # This file
```

## Installation

### Prerequisites
- Node.js (v16 or higher)
- Java JDK 17 or higher
- MySQL Server (v8.0 or higher)
- Maven (v3.6 or higher)

### Step 1: Clone the Repository
```bash
git clone <repository-url>
cd Ryn
```

### Step 2: Install Node.js Dependencies
```bash
npm install
```

### Step 3: Install Java Dependencies
```bash
mvn clean install
```

### Step 4: Database Setup
1. Create a MySQL database named `ryjin_db`
2. Import the database schema (if provided)
3. Update database configuration in `db.js`

### Step 5: Configuration
1. Copy `.env.example` to `.env` (if available)
2. Update configuration variables:
   - Database connection details
   - WebSocket server port
   - API endpoints

## Configuration

### Environment Variables
```bash
# Database Configuration
DB_HOST=localhost
DB_PORT=3306
DB_NAME=ryjin_db
DB_USER=your_username
DB_PASSWORD=your_password

# Server Configuration
PORT=3000
WS_PORT=12345
NODE_ENV=development

# API Configuration
RACING_API_KEY=your_api_key
RACING_API_URL=https://api.racing.com
```

### Database Configuration
Update `db.js` with your MySQL connection details:
```javascript
const mysql = require('mysql2');

const pool = mysql.createPool({
    host: 'localhost',
    user: 'your_username',
    password: 'your_password',
    database: 'ryjin_db',
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});
```

## Usage

### Starting the Application

1. **Start the Java WebSocket Server**:
   ```bash
   java -cp target/classes com.ryjinwebapp.WebSocketServer
   ```

2. **Start the Node.js Express Server**:
   ```bash
   npm start
   ```

3. **Access the Application**:
   Open your browser and navigate to `http://localhost:3000`

### Application Flow

1. **Authentication**: Users must register or login to access the application
2. **Dashboard**: After authentication, users see the main dashboard
3. **Room Selection**: Users can join existing chat rooms or create new ones
4. **Chat Interface**: Real-time messaging within selected rooms
5. **Racing Features**: Access to racing statistics, live feeds, and racing world

### Key Features Usage

#### Real-time Chat
- Join existing rooms or create new ones
- Send and receive messages in real-time
- View participant count and room information
- Persistent session management

#### Racing Statistics
- View comprehensive racing data
- Interactive charts and graphs
- Historical performance analysis
- Real-time telemetry data

#### Racing World
- Immersive 3D racing environment
- Dynamic particle effects
- Interactive track elements
- Real-time performance visualization

## API Endpoints

### Express Server Endpoints

#### POST /api/suggestions
Save user suggestions to the database
```javascript
{
    "suggestion": "User suggestion text"
}
```

#### GET /*
Serves the main application (SPA fallback)

### WebSocket Server Events

#### Connection Events
- `connect`: Client connects to WebSocket server
- `disconnect`: Client disconnects from server

#### Authentication Events
- `login`: User login request
- `register`: User registration request
- `logout`: User logout request

#### Room Events
- `join_room`: Join a specific chat room
- `leave_room`: Leave current room
- `create_room`: Create a new chat room
- `get_rooms`: Retrieve available rooms

#### Message Events
- `send_message`: Send a message to current room
- `receive_message`: Receive a message from another user

## Development

### Development Setup

1. **Install Development Dependencies**:
   ```bash
   npm install --save-dev nodemon
   ```

2. **Configure Development Scripts**:
   Add to `package.json`:
   ```json
   {
     "scripts": {
       "dev": "nodemon server.js",
       "build": "mvn clean package",
       "test": "echo \"Error: no test specified\" && exit 1"
     }
   }
   ```

3. **Start Development Server**:
   ```bash
   npm run dev
   ```

### Code Structure

#### Frontend Architecture
- **Modular JavaScript**: Separate modules for different features
- **Event-driven Design**: WebSocket-based real-time updates
- **Responsive CSS**: Mobile-first responsive design
- **Component-based**: Reusable UI components

#### Backend Architecture
- **MVC Pattern**: Model-View-Controller separation
- **WebSocket Handler**: Real-time communication management
- **Database Layer**: MySQL integration with connection pooling
- **API Layer**: RESTful endpoints for data operations

### Testing

#### Manual Testing
1. Test user registration and login
2. Verify WebSocket connections
3. Test chat room functionality
4. Validate racing data display
5. Check responsive design on different devices

#### Automated Testing
```bash
# Run tests (when implemented)
npm test

# Run Maven tests
mvn test
```

## Deployment

### Production Deployment

1. **Build the Application**:
   ```bash
   mvn clean package
   npm run build
   ```

2. **Deploy to Web Server**:
   - Copy `target/ryjin-webapp.war` to Tomcat webapps directory
   - Configure production database
   - Set up reverse proxy (nginx/Apache)

3. **Environment Configuration**:
   - Set `NODE_ENV=production`
   - Configure production database credentials
   - Set up SSL certificates
   - Configure firewall rules

### Docker Deployment (Optional)

```dockerfile
FROM openjdk:17-jdk-slim
COPY target/ryjin-webapp.war /app/
EXPOSE 8080
CMD ["java", "-jar", "/app/ryjin-webapp.war"]
```

## Contributing

### Development Guidelines

1. **Code Style**: Follow existing code formatting and naming conventions
2. **Documentation**: Add comments for complex logic
3. **Testing**: Write tests for new features
4. **Git Workflow**: Use feature branches and pull requests

### Pull Request Process

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Update documentation
6. Submit a pull request

## License

This project is licensed under the ISC License. See the LICENSE file for details.

## Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the documentation

## Changelog

### Version 1.0.0
- Initial release
- Real-time chat functionality
- Racing statistics and data visualization
- WebSocket-based communication
- User authentication system
- Responsive design implementation 
