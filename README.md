<div align="center">

# ✨ Real-Time Chat Application

### 💬 Seamless Messaging, Powered by Modern Tech

**A production-ready, full-stack chat platform built for speed, security, and seamless user experience**

---

[![Django](https://img.shields.io/badge/Django-5.2.8-0C3C26?logo=django&logoColor=white&style=flat-square)]()
[![React](https://img.shields.io/badge/React-19.2.0-61DAFB?logo=react&logoColor=white&style=flat-square)]()
[![Django REST](https://img.shields.io/badge/DRF-Latest-A30000?logo=django&logoColor=white&style=flat-square)]()
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-336791?logo=postgresql&logoColor=white&style=flat-square)]()
[![Docker](https://img.shields.io/badge/Docker-Enabled-2496ED?logo=docker&logoColor=white&style=flat-square)]()
[![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)]()

<a href="#-quick-start">
  <img src="https://img.shields.io/badge/⚡_GET_STARTED-blue?style=for-the-badge" alt="Get Started">
</a>

</div>

---

## 📖 Table of Contents

- [🎯 Overview](#-overview)
- [✨ Core Features](#-core-features)
- [🏗️ Architecture](#️-architecture)
- [💻 Tech Stack](#-tech-stack)
- [📋 Prerequisites](#-prerequisites)
- [⚡ Quick Start](#-quick-start)
- [🔧 Configuration](#-configuration)
- [📁 Project Structure](#-project-structure)
- [🚀 Deployment](#-deployment)
- [📚 Documentation](#-documentation)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)
- [👨‍💼 Author](#-author)

---

## 🎯 Overview

**Real-Time Chat Application** is a modern, production-ready messaging platform that combines the robustness of Django with the interactivity of React. Whether you're building an internal communication system or a customer engagement platform, this application provides a solid foundation with all the features you'd expect from a professional chat application.

### Why This Project?

| Problem | Solution |
|---------|----------|
| Complex messaging systems are hard to build from scratch | Modular, well-structured codebase with clear patterns |
| Real-time updates require WebSocket expertise | Efficient polling architecture (upgradable to WebSockets) |
| Security concerns with user data | JWT authentication with refresh tokens & rate limiting |
| Scaling chat platforms is expensive | Docker-ready infrastructure with PostgreSQL optimization |
| Responsive design across devices | Mobile-first React UI with Bootstrap 5 |

### Who Is This For?

- ✅ **Developers** looking for a modern full-stack chat template
- ✅ **Startups** needing a rapid MVP for messaging features
- ✅ **DevOps Engineers** seeking production-ready Docker setup
- ✅ **Students** learning full-stack development with best practices

---

## ✨ Core Features

<table>
  <tr>
    <td width="50%">
      <h4>🔐 Authentication & Security</h4>
      <ul>
        <li>JWT-based secure login/register</li>
        <li>Refresh token support</li>
        <li>Rate limiting on auth endpoints</li>
        <li>CORS-enabled API</li>
      </ul>
    </td>
    <td width="50%">
      <h4>💬 Messaging Features</h4>
      <ul>
        <li>Real-time message polling</li>
        <li>Message history retrieval</li>
        <li>Read receipts with timestamps</li>
        <li>Typing indicators ready</li>
      </ul>
    </td>
  </tr>
  <tr>
    <td width="50%">
      <h4>🚫 User Management</h4>
      <ul>
        <li>Block/unblock users</li>
        <li>User online status tracking</li>
        <li>Last seen timestamps</li>
        <li>Contact list with search</li>
      </ul>
    </td>
    <td width="50%">
      <h4>📱 User Experience</h4>
      <ul>
        <li>Responsive mobile-first design</li>
        <li>WhatsApp-like UI/UX</li>
        <li>Real-time notification badges</li>
        <li>Dark mode ready</li>
      </ul>
    </td>
  </tr>
</table>

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────┐
│                   FRONTEND (React)                      │
│  ┌─────────────────────────────────────────────────┐    │
│  │  ChatWindow  │  Sidebar  │  Auth Pages          │    │
│  │  (Vite Build & Hot Reload)                      │    │
│  └─────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────┘
                         ↓ (Axios)
┌──────────────────────────────────────────────────────────┐
│            API Gateway & CORS Handler                    │
└──────────────────────────────────────────────────────────┘
                         ↓
┌──────────────────────────────────────────────────────────┐
│              BACKEND (Django REST)                       │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐    │
│  │  Accounts    │  │   Chat       │  │  Throttling  │    │
│  │  (Auth, JWT) │  │  (Messages)  │  │  (DRF)       │    │
│  └──────────────┘  └──────────────┘  └──────────────┘    │
└──────────────────────────────────────────────────────────┘
                         ↓
┌──────────────────────────────────────────────────────────┐
│        DATABASE LAYER (PostgreSQL / SQLite)              │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐                │
│  │  Users   │  │ Messages │  │  Blocks  │                │
│  └──────────┘  └──────────┘  └──────────┘                │
└──────────────────────────────────────────────────────────┘
```

**Design Pattern**: MVT (Model-View-Template) → REST API
**Communication**: HTTP/JSON with JWT Bearer tokens
**Real-time Strategy**: Client-side polling with 1s interval

---

## 💻 Tech Stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| **Frontend** | React 19.2.0 | UI Components & State Management |
| | Vite | Lightning-fast bundler & dev server |
| | Axios | HTTP client with interceptors |
| | Bootstrap 5.3.8 | Responsive CSS framework |
| **Backend** | Django 5.2.8 | Web framework & ORM |
| | Django REST Framework | RESTful API development |
| | Simple JWT | Token-based authentication |
| | Django CORS Headers | Cross-origin request handling |
| **Database** | PostgreSQL 15 | Production data storage |
| | SQLite | Development database |
| **DevOps** | Docker | Container orchestration |
| | Docker Compose | Multi-container setup |
| | Gunicorn | WSGI application server |

---

## 📋 Prerequisites

Before you begin, ensure you have installed:

| Tool | Version | Purpose |
|------|---------|---------|
| **Python** | 3.8+ | Backend runtime |
| **Node.js** | 16+ | Frontend package manager |
| **npm/yarn** | Latest | JavaScript dependency manager |
| **Docker** | 24.0+ | (Optional) Container runtime |
| **Docker Compose** | 2.0+ | (Optional) Multi-container orchestration |
| **PostgreSQL** | 15+ | (Production) Database server |

---

## ⚡ Quick Start

### Option 1: Local Development (Fastest)

#### 1️⃣ **Clone & Setup Backend**

```bash
# Clone the repository
git clone https://github.com/mdskun/Real-Time-Chat-Application.git
cd Real-Time-Chat-Application

# Navigate to backend
cd backend

# Create virtual environment
python -m venv venv

# Activate virtual environment
# On macOS/Linux:
source venv/bin/activate
# On Windows:
venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Create .env file
cp .env.example .env
# Edit .env with your configuration
```

#### 2️⃣ **Initialize Database & Run Backend**

```bash
# Run migrations
python manage.py migrate

# (Optional) Create superuser
python manage.py createsuperuser

# Start development server
python manage.py runserver

# Backend runs at: http://127.0.0.1:8000/
```

#### 3️⃣ **Setup Frontend**

```bash
# In a new terminal, navigate to frontend
cd frontend

# Install dependencies
npm install

# Create environment file
echo "VITE_API_BASE_URL=http://localhost:8000" > .env.local

# Start Vite dev server
npm run dev

# Frontend runs at: http://localhost:5173/
```

#### 4️⃣ **Test the Application**


- ✅ Open http://localhost:5173/ in your browser
- ✅ Register a new account
- ✅ Create another account in incognito mode
- ✅ Start messaging between accounts
- ✅ Test blocking features


---

### Option 2: Docker (Recommended for Production)

```bash
# Clone repository
git clone https://github.com/mdskun/Real-Time-Chat-Application.git
cd Real-Time-Chat-Application

# Copy and configure environment
cp .env.example .env
# Edit .env with your credentials

# Start all services
docker-compose up -d

# Run migrations
docker-compose exec backend python manage.py migrate

# Create superuser
docker-compose exec backend python manage.py createsuperuser

# Access the application
# Frontend: http://localhost/
# Backend API: http://localhost:8000/
# Admin: http://localhost:8000/admin/
```

---

## 🔧 Configuration

### Backend Environment Variables

Create a `.env` file in the `backend` directory:

```env
# Django Security
DJANGO_SECRET_KEY=your-secret-key-change-in-production
REGISTRATION_SECRET=your-registration-secret-key
DEBUG=False

# Database Configuration
DB_ENGINE=django.db.backends.postgresql
DB_NAME=chatdb
DB_USER=chatuser
DB_PASSWORD=secure-password
DB_HOST=localhost
DB_PORT=5432

# CORS & Hosts
DJANGO_ALLOWED_HOSTS=localhost,127.0.0.1,yourdomain.com
```

### Frontend Environment Variables

Create a `.env.local` file in the `frontend` directory:

```env
VITE_API_BASE_URL=http://localhost:8000
```

### Docker Environment Variables

The `.env` file is shared between services. Key variables for Docker:

```env
# PostgreSQL
POSTGRES_DB=chatdb
POSTGRES_USER=chatuser
POSTGRES_PASSWORD=secure-password
```

---

## 📁 Project Structure

```
Real-Time-Chat-Application/
├── 📄 README.md                          # You are here
├── 📄 docker-compose.yml                 # Docker orchestration
├── 📄 .env.example                       # Environment template
├── 📁 backend/                           # Django REST API
│   ├── 📄 manage.py                      # Django CLI
│   ├── 📄 requirements.txt                # Python dependencies
│   ├── 📄 dockerfile                      # Backend Docker image
│   ├── 📁 coreBackend/                   # Main project config
│   │   ├── settings.py                   # Django settings
│   │   ├── urls.py                       # URL routing
│   │   └── wsgi.py                       # WSGI config
│   ├── 📁 accounts/                      # User management
│   │   ├── models.py                     # User & Profile models
│   │   ├── views.py                      # Auth endpoints
│   │   ├── serializers.py                # Data serialization
│   │   ├── urls.py                       # Auth routes
│   │   └── throttling.py                 # Rate limiting
│   └── 📁 chat/                          # Messaging system
│       ├── models.py                     # Message & Block models
│       ├── views.py                      # Chat endpoints
│       ├── serializers.py                # Message serialization
│       └── urls.py                       # Chat routes
│
├── 📁 frontend/                          # React + Vite
│   ├── 📄 package.json                   # Node.js dependencies
│   ├── 📄 vite.config.js                 # Vite configuration
│   ├── 📄 dockerfile                      # Frontend Docker image
│   ├── 📄 index.html                      # Entry point
│   └── 📁 src/
│       ├── App.jsx                       # Root component
│       ├── main.jsx                      # React bootstrap
│       ├── config/
│       │   └── api.js                    # API client config
│       ├── 📁 components/
│       │   ├── ChatWindow.jsx            # Chat interface
│       │   └── Sidebar.jsx               # User list
│       ├── 📁 pages/
│       │   ├── Login.jsx                 # Login page
│       │   ├── Register.jsx              # Registration page
│       │   └── Contact.jsx               # Contact page
│       └── 📁 assets/                    # Images & styles
│
└── 📁 terraform/                         # Infrastructure as Code (Optional)
    └── main.tf                           # Cloud deployment config
```

### Key Files Explained

| File | Purpose |
|------|---------|
| `backend/coreBackend/settings.py` | Django configuration, database, middleware, CORS |
| `backend/accounts/models.py` | User Profile model with online status tracking |
| `backend/chat/models.py` | Message and Block models with relationships |
| `frontend/src/components/ChatWindow.jsx` | Main messaging UI with polling logic |
| `frontend/src/components/Sidebar.jsx` | User list, presence indicators, unread counts |

---

## 🚀 Deployment

### Heroku / Railway (Backend)

```bash
# Create Procfile
echo "web: gunicorn coreBackend.wsgi" > backend/Procfile

# Deploy
git push heroku main

# Run migrations
heroku run python backend/manage.py migrate
```

### Vercel / Netlify (Frontend)

```bash
# Install Vercel CLI
npm install -g vercel

# Deploy
cd frontend
vercel

# Set environment variable in dashboard:
# VITE_API_BASE_URL = https://your-backend-api.com
```

### Full Docker Stack (Recommended)

```bash
# Build images
docker-compose build

# Start services
docker-compose up -d

# Verify services
docker-compose ps

# View logs
docker-compose logs -f
```

---

## 📚 Documentation

### API Endpoints Reference

#### Authentication
```
POST   /api/register/           # Register new user
POST   /api/login/              # Get JWT tokens
POST   /api/refresh/            # Refresh access token
GET    /api/me/                 # Get current user
```

#### Messaging
```
GET    /api/chat/messages/      # Get conversation with user
POST   /api/chat/messages/      # Send message
GET    /api/chat/unread_counts/ # Get unread badge counts
```

#### User Management
```
GET    /api/users/              # Get all users with last message
GET    /api/presence/           # Get all users' online status
POST   /api/chat/block/         # Block a user
DELETE /api/chat/block/         # Unblock a user
GET    /api/chat/block/status/  # Check block status
```

### Database Schema

```
┌─────────────┐          ┌──────────────┐
│   User      │          │   Profile    │
├─────────────┤          ├──────────────┤
│ id (PK)     │◄────────►│ user_id (FK) │
│ username    │  1:1     │ last_seen    │
│ email       │          │ online       │
│ password    │          └──────────────┘
└─────────────┘

┌─────────────┐          ┌──────────────┐
│  Message    │          │    Block     │
├─────────────┤          ├──────────────┤
│ id (PK)     │          │ id (PK)      │
│ sender_id   │─────┐    │ blocker_id   │
│ receiver_id │──┐  └───►│ User (FK)    │
│ content     │  └──────►│ blocked_id   │
│ timestamp   │          │ User (FK)    │
│ is_read     │          │ created_at   │
└─────────────┘          └──────────────┘
```

### Common Tasks

**🔄 Upgrade to WebSockets (Django Channels)**
```bash
pip install channels channels-redis
# Configure in settings.py
# Update frontend to use WebSocket instead of polling
```

**📊 Enable Caching (Redis)**
```bash
pip install django-redis
# Configure in settings.py for faster presence updates
```

**🔍 Add Message Search**
```python
# In chat/views.py - Add search filter
messages = Message.objects.filter(
    content__icontains=search_query
).filter(
    sender__in=[user, other_user],
    receiver__in=[user, other_user]
)
```

---
<!--
## 🤝 Contributing

We love contributions! Here's how to get started: -->

<!--
### 1️⃣ Fork & Clone
```bash
git clone https://github.com/your-fork/Real-Time-Chat-Application.git
cd Real-Time-Chat-Application
git checkout -b feature/your-feature-name
```

### 2️⃣ Make Changes
```bash
# Backend
cd backend
python manage.py test

# Frontend
cd frontend
npm run lint
npm run build
```

### 3️⃣ Commit & Push
```bash
git commit -am "Add amazing feature"
git push origin feature/your-feature-name
```

### 4️⃣ Create Pull Request
- Go to GitHub and create a pull request
- Describe your changes in detail
- Wait for review and feedback

### Development Guidelines

- ✅ Follow PEP 8 for Python code
- ✅ Use functional components in React with hooks
- ✅ Write meaningful commit messages
- ✅ Add comments for complex logic
- ✅ Test your changes before submitting
- ✅ Update documentation if needed

### Areas We Need Help With

- 🚀 **WebSocket implementation** - Real-time without polling
- 📱 **Mobile app** - React Native version
- 🎨 **Dark mode** - Complete theme system
- 🌍 **Internationalization** - Multi-language support
- 🧪 **Test coverage** - Unit & integration tests
- 📖 **Documentation** - API docs, video tutorials

---

-->

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2024 Real-Time Chat Application Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
```

---

## 👨‍💼 Author

<div align="center">

**Created with ❤️ by [Manthan D Soni]**

[![GitHub](https://img.shields.io/badge/GitHub-Profile-181717?logo=github&logoColor=white&style=flat-square)](https://github.com/mdskun)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0A66C2?logo=linkedin&logoColor=white&style=flat-square)](https://www.linkedin.com/in/manthan-soni-595641243/)
<!-- [![Twitter](https://img.shields.io/badge/Twitter-Follow-1DA1F2?logo=twitter&logoColor=white&style=flat-square)](https://twitter.com/yourhandle) -->


<!-- ### 📈 Project Stats

![GitHub stars](https://img.shields.io/github/stars/mdskun/Real-Time-Chat-Application?style=social)
![GitHub forks](https://img.shields.io/github/forks/mdskun/Real-Time-Chat-Application?style=social)
![GitHub watchers](https://img.shields.io/github/watchers/mdskun/Real-Time-Chat-Application?style=social) -->

<div align="center">

**Made with 🔥 for developers, by developers**

</div>
