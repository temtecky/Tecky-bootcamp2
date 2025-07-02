# 3-Tier CI/CD Demo Application

## Overview

A complete 3-tier Node.js web application demonstrating modern CI/CD practices with automated testing, Docker containerization, and CircleCI deployment pipeline.

### Architecture
- **Presentation Tier**: Interactive HTML dashboard with real-time data
- **Business Logic Tier**: Express.js REST API with comprehensive endpoints
- **Data Tier**: In-memory storage with relational data management

## Features

### Core Functionality
- **User Management**: Create and manage user accounts with role-based access
- **Content Management**: Blog post creation and management with author linking
- **Real-time Dashboard**: Live statistics and data visualization
- **Health Monitoring**: System status and performance tracking
- **Interactive UI**: Responsive web interface with dynamic content updates

### API Endpoints
- `GET /` - Main web application
- `GET /health` - System health check with database stats
- `GET /version` - Build and deployment information
- `GET /api/users` - List all users
- `POST /api/users` - Create new user
- `GET /api/users/:id` - Get specific user
- `GET /api/posts` - List all posts with authors
- `POST /api/posts` - Create new post
- `GET /api/posts/:id` - Get specific post
- `GET /api/dashboard` - Combined dashboard statistics
- `POST /api/reset` - Reset all data to initial state

### Tech Stack
- **Backend**: Node.js 18+ with Express.js
- **Frontend**: HTML5, CSS3, JavaScript (Vanilla)
- **Storage**: In-memory data store
- **Testing**: Jest with Supertest (17 test cases, 88%+ coverage)
- **Code Quality**: ESLint + Prettier
- **Containerization**: Docker with Alpine Linux
- **CI/CD**: CircleCI with automated testing and deployment

## Local Development

### Prerequisites
- Node.js 18+ and npm 8+
- Git
- Docker (optional)

### Quick Start

1. **Clone and Install**
   ```bash
   git clone <your-repo-url>
   cd project-2-cicd-pipeline
   npm install
   ```

2. **Run Application**
   ```bash
   npm start          # Production mode
   npm run dev        # Development mode with auto-reload
   ```

3. **Run Tests**
   ```bash
   npm test           # Run all tests with coverage
   npm run lint       # Check code quality
   ```

### Local Access

**Web Interface**: http://localhost:3000
- Interactive dashboard with user and post management
- Real-time statistics and data visualization
- Forms to create users and blog posts
- Live updates without page refresh

**API Endpoints**:
- Health Check: http://localhost:3000/health
- Version Info: http://localhost:3000/version
- Users API: http://localhost:3000/api/users
- Posts API: http://localhost:3000/api/posts
- Dashboard Data: http://localhost:3000/api/dashboard

### Docker Development
```bash
# Build and run with Docker
docker build -t 3tier-app .
docker run -p 3000:3000 3tier-app

# Or use Docker Compose (if available)
docker-compose up --build
```

## CI/CD Pipeline with CircleCI

### Setup Requirements
1. **GitHub Repository** with this code
2. **CircleCI Account** (free tier available)
3. **Docker Hub Account** for image storage

### CircleCI Configuration

#### 1. Connect Repository
1. Login to [CircleCI](https://circleci.com) with GitHub
2. Add your project repository
3. CircleCI auto-detects `.circleci/config.yml`

#### 2. Environment Variables
Set in CircleCI Project Settings → Environment Variables:

**Required:**
```
DOCKER_HUB_USERNAME=your-dockerhub-username
DOCKER_HUB_PASSWORD=your-dockerhub-token
NODE_ENV=production
APP_VERSION=1.0.0
```



#### 3. Docker Hub Setup
1. Create account at [Docker Hub](https://hub.docker.com)
2. Create repository: `your-username/3tier-cicd-app`
3. Generate access token for `DOCKER_HUB_PASSWORD`

### Pipeline Workflow

**Automatic Triggers:**
- **Push to any branch**: Runs tests and linting
- **Push to main**: Full pipeline (test → build → deploy)

**Pipeline Stages:**
1. **Test Stage**
   - Install dependencies
   - Run Jest tests (17 test cases)
   - ESLint code quality checks
   - Coverage validation (88%+ required)

2. **Build Stage** (main branch only)
   - Build Docker image with commit SHA tag
   - Push to Docker Hub registry
   - Tag as `latest` for main branch
   - Image available for deployment anywhere

### Docker Image Details
- **Base**: `node:18-alpine` (lightweight)
- **Size**: ~150MB optimized
- **Security**: Non-root user, health checks
- **Tags**: `latest` and commit SHA
- **Registry**: Docker Hub public repository

## Deployment & Access

### Deploy Anywhere with Docker

After CircleCI builds and pushes the image to Docker Hub, deploy on any platform:

**Local Deployment:**
```bash
# Pull and run latest image
docker pull your-username/3tier-cicd-app:latest
docker run -p 3000:3000 your-username/3tier-cicd-app:latest
```

**Cloud Platforms:**
- **AWS ECS/Fargate**: Use Docker image directly
- **Google Cloud Run**: Deploy from Docker Hub
- **Azure Container Instances**: One-click deployment
- **DigitalOcean App Platform**: Connect Docker Hub repository
- **Heroku**: Deploy using container registry

**VPS/Server Deployment:**
```bash
# On any server with Docker
ssh user@your-server
docker pull your-username/3tier-cicd-app:latest
docker run -d -p 3000:3000 --name 3tier-app your-username/3tier-cicd-app:latest
```

### Access Your Deployed App

**Web Interface**: `http://your-domain-or-ip:3000`
- Complete dashboard with user/post management
- Real-time statistics and interactive forms
- Responsive design works on mobile/desktop

**API Access**: `http://your-domain-or-ip:3000/api/`
- RESTful endpoints for integration
- JSON responses for all operations
- Health monitoring at `/health`

**No SSH Required**: CircleCI builds Docker images that can be deployed anywhere without server access

## Testing

### Test Suite
- **17 test cases** covering all API endpoints
- **88%+ code coverage** (statements, functions, lines)
- **Integration tests** for complete user/post workflows
- **Error handling** validation
- **Health check** monitoring

### Running Tests
```bash
npm test              # Full test suite with coverage
npm run test:watch    # Watch mode for development
npm run lint          # Code quality checks
```

### API Testing Examples
```bash
# Health check
curl http://localhost:3000/health

# Create user
curl -X POST http://localhost:3000/api/users \
  -H "Content-Type: application/json" \
  -d '{"name":"John Doe","email":"john@example.com","role":"admin"}'

# Create post
curl -X POST http://localhost:3000/api/posts \
  -H "Content-Type: application/json" \
  -d '{"title":"My Post","content":"Post content","userId":1}'

# Get dashboard
curl http://localhost:3000/api/dashboard

# Reset all data
curl -X POST http://localhost:3000/api/reset
```

## Troubleshooting

### Common Issues

**Tests hanging**: Fixed - server only starts when run directly, not during testing

**Port 3000 in use**:
```bash
lsof -i :3000          # Find process using port
pkill -f node          # Kill Node processes
```

**Docker build fails**: Check Docker Hub credentials in CircleCI environment variables

**Pipeline fails**: Verify `.circleci/config.yml` syntax and environment variables

**Coverage below threshold**: Current threshold set to 60% branches, 70% other metrics

## Project Structure
```
.
├── .circleci/
│   └── config.yml          # CircleCI pipeline configuration
├── public/
│   └── index.html          # Frontend dashboard
├── test/
│   └── server.test.js      # Jest test suite (17 tests)
├── .env                    # Environment variables
├── .eslintrc.js           # ESLint configuration
├── .prettierrc            # Prettier configuration
├── Dockerfile             # Docker container definition
├── package.json           # Dependencies and scripts
├── server.js              # Main application server
└── README.md              # This file
```

## License
MIT License - Feel free to use for learning and development.
