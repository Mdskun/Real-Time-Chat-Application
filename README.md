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
[![Kubernetes](https://img.shields.io/badge/Kubernetes-Ready-326CE5?logo=kubernetes&logoColor=white&style=flat-square)]()
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
  - [Docker Compose](#option-2-docker-compose-recommended-for-production)
  - [Kubernetes](#option-3-kubernetes)
- [📚 API Documentation](#-api-documentation)
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
- ✅ **DevOps Engineers** seeking production-ready Docker & Kubernetes setup
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
| **DevOps** | Docker | Containerization |
| | Docker Compose | Multi-container local/production setup |
| | Kubernetes | Container orchestration at scale |
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
| **kubectl** | 1.26+ | (Optional) Kubernetes CLI |
| **Minikube** | Latest | (Optional) Local Kubernetes cluster |
| **PostgreSQL** | 15+ | (Production) Database server |

---

## ⚡ Quick Start

### Option 1: Local Development (Fastest)

#### 1️⃣ Clone & Setup Backend

```bash
git clone https://github.com/mdskun/Real-Time-Chat-Application.git
cd Real-Time-Chat-Application

cd backend
python -m venv venv
source venv/bin/activate        # Windows: venv\Scripts\activate
pip install -r requirements.txt
cp ../.env.example .env         # Edit .env with your config
```

#### 2️⃣ Initialize Database & Run Backend

```bash
python manage.py migrate
python manage.py createsuperuser   # Optional
python manage.py runserver
# Backend: http://127.0.0.1:8000/
```

#### 3️⃣ Setup & Run Frontend

```bash
# In a new terminal
cd frontend
npm install
echo "VITE_API_BASE_URL=http://localhost:8000" > .env.local
npm run dev
# Frontend: http://localhost:3000/
```

#### 4️⃣ Test the Application

- ✅ Open http://localhost:3000/ in your browser
- ✅ Register a new account
- ✅ Create another account in incognito mode
- ✅ Start messaging between accounts

---

### Option 2: Docker Compose (Recommended for Production)

```bash
git clone https://github.com/mdskun/Real-Time-Chat-Application.git
cd Real-Time-Chat-Application

cp .env.example .env
# Edit .env with your credentials

docker-compose up -d
docker-compose exec backend python manage.py migrate
docker-compose exec backend python manage.py createsuperuser

# Frontend: http://localhost:3000/
# Backend:  http://localhost:8000/
# Admin:    http://localhost:8000/admin/
```

---

### Option 3: Kubernetes

See the full [Kubernetes Deployment](#-kubernetes-deployment) section below.

---

## 🔧 Configuration

### Environment Variables

Create a `.env` file from the provided template:

```bash
cp .env.example .env
```

| Variable | Description | Example |
|----------|-------------|---------|
| `DJANGO_SECRET_KEY` | Django secret key | `your-secret-key` |
| `REGISTRATION_SECRET` | Secret for registration endpoint | `your-reg-secret` |
| `DJANGO_ALLOWED_HOSTS` | Comma-separated allowed hosts | `localhost,yourdomain.com` |
| `DB_ENGINE` | Django database engine | `django.db.backends.postgresql` |
| `DB_NAME` | Database name | `chatdb` |
| `DB_USER` | Database user | `chatuser` |
| `DB_PASSWORD` | Database password | `securepassword` |
| `DB_HOST` | Database host | `db` (Docker) / `localhost` |
| `DB_PORT` | Database port | `5432` |
| `POSTGRES_DB` | PostgreSQL DB name | `chatdb` |
| `POSTGRES_USER` | PostgreSQL user | `chatuser` |
| `POSTGRES_PASSWORD` | PostgreSQL password | `securepassword` |
| `VITE_API_BASE_URL` | Frontend API URL | `http://backend:8000` |

---

## 📁 Project Structure

```
Real-Time-Chat-Application/
├── 📄 README.md
├── 📄 docker-compose.yml
├── 📄 .env.example
├── 📁 backend/
│   ├── 📄 manage.py
│   ├── 📄 requirements.txt
│   ├── 📄 dockerfile
│   ├── 📁 coreBackend/
│   │   ├── settings.py
│   │   ├── urls.py
│   │   └── wsgi.py
│   ├── 📁 accounts/
│   │   ├── models.py
│   │   ├── views.py
│   │   ├── serializers.py
│   │   ├── urls.py
│   │   ├── middleware.py
│   │   └── throttling.py
│   └── 📁 chat/
│       ├── models.py
│       ├── views.py
│       ├── serializers.py
│       └── urls.py
├── 📁 frontend/
│   ├── 📄 package.json
│   ├── 📄 vite.config.js
│   ├── 📄 dockerfile
│   └── 📁 src/
│       ├── App.jsx
│       ├── main.jsx
│       ├── config/api.js
│       ├── 📁 components/
│       │   ├── ChatWindow.jsx
│       │   └── Sidebar.jsx
│       └── 📁 pages/
│           ├── Login.jsx
│           ├── Register.jsx
│           └── Contact.jsx
├── 📁 k8s/
│   ├── 📄 namespace.yml
│   ├── 📄 configmaps.yml          ⚠️  gitignored — see below
│   ├── 📄 db_stateful.yml
│   ├── 📄 db_service.yml
│   ├── 📄 db_service2.yml
│   ├── 📄 back_deployment.yml
│   ├── 📄 back_service.yml
│   ├── 📄 front_deployment.yml
│   ├── 📄 front_service.yml
│   └── 📄 jenkin(freestyle)
└── 📁 terraform/
    └── main.tf
```

---

## 🚀 Deployment

### Kubernetes Deployment

The `k8s/` directory contains all manifests to run the full application on any Kubernetes cluster (tested on Minikube).

#### Cluster Layout

```
Namespace: chatapp
│
├── ConfigMaps
│   ├── env-back     → backend env vars (DB creds, Django settings)
│   └── env-front    → frontend env vars (API URL)
│
├── StatefulSet: chat-db (postgres:15)
│   ├── Service: chat-db          (Headless — stable DNS for StatefulSet)
│   └── Service: chat-db-svc      (ClusterIP — used by backend)
│
├── Deployment: chat-backend (2 replicas)
│   └── Service: chat-backend-svc (ClusterIP — internal only)
│
└── Deployment: chat-frontend (2 replicas)
    └── Service: chat-frontend-svc (NodePort 30088 — external access)
```

#### ⚠️ Step 0 — Create configmaps.yml (not in repo)

`k8s/configmaps.yml` is **gitignored** because it contains credentials. You must create it manually before deploying.

Create `k8s/configmaps.yml` with the following structure:

```yaml
# ConfigMap for backend (Django + DB connection)
apiVersion: v1
kind: ConfigMap
metadata:
  name: env-back
  namespace: chatapp
data:
  DJANGO_SECRET_KEY: "your-secret-key-here"
  REGISTRATION_SECRET: "your-registration-secret-here"
  DJANGO_ALLOWED_HOSTS: "chat-backend-svc,chat-backend-svc.chatapp.svc.cluster.local,chat-frontend-svc"
  DB_ENGINE: "django.db.backends.postgresql"
  DB_NAME: "chatdb"
  DB_USER: "chatuser"
  DB_PASSWORD: "your-db-password"
  DB_HOST: "chat-db"
  DB_PORT: "5432"
  POSTGRES_DB: "chatdb"
  POSTGRES_USER: "chatuser"
  POSTGRES_PASSWORD: "your-db-password"
---
# ConfigMap for frontend (Vite env)
apiVersion: v1
kind: ConfigMap
metadata:
  name: env-front
  namespace: chatapp
data:
  VITE_API_BASE_URL: "http://chat-backend-svc:8000"
```

> 💡 **Production tip**: Move sensitive values (`DJANGO_SECRET_KEY`, `DB_PASSWORD`, etc.) into a [Kubernetes Secret](https://kubernetes.io/docs/concepts/configuration/secret/) instead of a ConfigMap.

#### Step 1 — Apply manifests in order

```bash
kubectl apply -f k8s/namespace.yml
kubectl apply -f k8s/configmaps.yml
kubectl apply -f k8s/db_service.yml
kubectl apply -f k8s/db_service2.yml
kubectl apply -f k8s/db_stateful.yml
kubectl apply -f k8s/back_deployment.yml
kubectl apply -f k8s/back_service.yml
kubectl apply -f k8s/front_deployment.yml
kubectl apply -f k8s/front_service.yml
```

#### Step 2 — Run database migrations

Wait for the DB pod to be ready, then:

```bash
kubectl wait --for=condition=ready pod -l app=chatapp,tier=db -n chatapp --timeout=60s

kubectl exec -n chatapp deployment/chat-backend -- python manage.py migrate
```

#### Step 3 — Access the application

**On Minikube:**

```bash
# Open frontend directly in browser
minikube service chat-frontend-svc -n chatapp

# Or get the URL manually
minikube ip
# Then open: http://<minikube-ip>:30088
```

**On a cloud cluster (EKS / GKE / AKS):**

```bash
# Get the NodePort URL
kubectl get nodes -o wide         # grab the external IP
# Open: http://<node-external-ip>:30088
```

**Backend health check (port-forward):**

```bash
kubectl port-forward svc/chat-backend-svc 8000:8000 -n chatapp
# Then: http://localhost:8000/api/health/
```

#### Verify everything is running

```bash
# All pods should show Running + Ready
kubectl get pods -n chatapp

# All services
kubectl get svc -n chatapp

# Rollout status
kubectl rollout status deployment/chat-backend -n chatapp
kubectl rollout status deployment/chat-frontend -n chatapp
```

Expected output:

```
NAME                                READY   STATUS    RESTARTS   AGE
chat-backend-xxxx-xxxx              1/1     Running   0          2m
chat-backend-xxxx-xxxx              1/1     Running   0          2m
chat-db-0                           1/1     Running   0          3m
chat-frontend-xxxx-xxxx             1/1     Running   0          1m
chat-frontend-xxxx-xxxx             1/1     Running   0          1m
```

#### Useful kubectl commands

```bash
# View logs
kubectl logs -f deployment/chat-backend -n chatapp
kubectl logs -f deployment/chat-frontend -n chatapp
kubectl logs -f statefulset/chat-db -n chatapp

# Describe a crashing pod
kubectl describe pod <pod-name> -n chatapp

# Restart a deployment
kubectl rollout restart deployment/chat-backend -n chatapp
kubectl rollout restart deployment/chat-frontend -n chatapp

# Scale replicas
kubectl scale deployment chat-backend --replicas=3 -n chatapp

# Delete everything (clean slate)
kubectl delete namespace chatapp
```

---

## 📚 API Documentation

### Endpoints Reference

#### Authentication
```
POST   /api/register/           Register new user
POST   /api/login/              Get JWT tokens
POST   /api/refresh/            Refresh access token
GET    /api/me/                 Get current user
GET    /api/health/             Health check (used by k8s probes)
```

#### Messaging
```
GET    /api/chat/messages/      Get conversation with user
POST   /api/chat/messages/      Send message
GET    /api/chat/unread_counts/ Get unread badge counts
```

#### User Management
```
GET    /api/users/              Get all users with last message
GET    /api/presence/           Get all users' online status
POST   /api/chat/block/         Block a user
DELETE /api/chat/block/         Unblock a user
GET    /api/chat/block/status/  Check block status
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

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

---

## 👨‍💼 Author

<div align="center">

**Created with ❤️ by [Manthan D Soni]**

[![GitHub](https://img.shields.io/badge/GitHub-Profile-181717?logo=github&logoColor=white&style=flat-square)](https://github.com/mdskun)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0A66C2?logo=linkedin&logoColor=white&style=flat-square)](https://www.linkedin.com/in/manthan-soni-595641243/)

<div align="center">

**Made with 🔥 for developers, by developers**

</div>

</div>
