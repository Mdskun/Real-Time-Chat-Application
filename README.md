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
[![Jenkins](https://img.shields.io/badge/Jenkins-CI%2FCD-D24939?logo=jenkins&logoColor=white&style=flat-square)]()
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
  - [Local Development](#option-1-local-development-fastest)
  - [Docker Compose](#option-2-docker-compose)
  - [Kubernetes](#option-3-kubernetes)
- [🔧 Configuration](#-configuration)
- [📁 Project Structure](#-project-structure)
- [🚀 CI/CD Pipeline](#-cicd-pipeline-jenkins)
- [☸️ Kubernetes Reference](#️-kubernetes-reference)
- [📚 API Documentation](#-api-documentation)
- [📄 License](#-license)
- [👨‍💼 Author](#-author)

---

## 🎯 Overview

**Real-Time Chat Application** is a modern, production-ready messaging platform combining the robustness of Django with the interactivity of React — fully containerised and deployable on Kubernetes with a Jenkins CI/CD pipeline.

### Why This Project?

| Problem | Solution |
|---------|----------|
| Complex messaging systems are hard to build from scratch | Modular, well-structured codebase with clear patterns |
| Real-time updates require WebSocket expertise | Efficient polling architecture (upgradable to WebSockets) |
| Security concerns with user data | JWT authentication with refresh tokens & rate limiting |
| Scaling chat platforms is expensive | Kubernetes-ready with horizontal scaling support |
| Manual deployments are error-prone | Full Jenkins CI/CD pipeline with automatic migrations |

### Who Is This For?

- ✅ **Developers** looking for a modern full-stack chat template
- ✅ **Startups** needing a rapid MVP for messaging features
- ✅ **DevOps Engineers** seeking a production-ready Docker + Kubernetes + Jenkins setup
- ✅ **Students** learning full-stack development and container orchestration

---

## ✨ Core Features

<table>
  <tr>
    <td width="50%">
      <h4>🔐 Authentication & Security</h4>
      <ul>
        <li>JWT-based secure login/register</li>
        <li>Refresh token support with rotation</li>
        <li>Rate limiting on auth endpoints</li>
        <li>CORS-enabled API</li>
        <li>Registration secret key protection</li>
      </ul>
    </td>
    <td width="50%">
      <h4>💬 Messaging Features</h4>
      <ul>
        <li>Real-time message polling (1s interval)</li>
        <li>Incremental message fetch (after ID)</li>
        <li>Read receipts with timestamps</li>
        <li>Unread message badge counts</li>
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
        <li>Contact list with presence indicators</li>
      </ul>
    </td>
    <td width="50%">
      <h4>🚢 DevOps Ready</h4>
      <ul>
        <li>Multi-stage Docker builds</li>
        <li>Kubernetes manifests (StatefulSet, Deployments)</li>
        <li>Jenkins declarative pipeline</li>
        <li>Secrets separated from config</li>
        <li>Health check endpoints for probes</li>
      </ul>
    </td>
  </tr>
</table>

---

## 🏗️ Architecture

```
┌──────────────────────────────────────────────────────────┐
│                  BROWSER (React SPA)                     │
│   ChatWindow │ Sidebar │ Auth Pages                      │
│   Vite build — VITE_API_BASE_URL baked at build time     │
└──────────────────────────┬───────────────────────────────┘
                           │ HTTP/JSON + JWT Bearer
                           ▼
┌──────────────────────────────────────────────────────────┐
│           BACKEND (Django REST Framework)                │
│   Accounts app (Auth, JWT)  │  Chat app (Messages)       │
│   LastSeenMiddleware        │  DRF Throttling             │
│   Gunicorn WSGI server                                   │
└──────────────────────────┬───────────────────────────────┘
                           │ psycopg2
                           ▼
┌──────────────────────────────────────────────────────────┐
│              DATABASE (PostgreSQL 15)                    │
│   Users & Profiles │ Messages │ Blocks                   │
└──────────────────────────────────────────────────────────┘
```

**In Kubernetes**, this maps to:

```
NodePort :30088          ClusterIP :8000         Headless + ClusterIP :5432
chat-frontend-svc   →   chat-backend-svc    →   chat-db / chat-db-svc
[Deployment ×2]         [Deployment ×2]          [StatefulSet ×1]
```

**Design Pattern**: Django MVT → REST API  
**Auth**: JWT access (6h) + refresh (7d) tokens  
**Real-time**: Client-side polling every 1 second

---

## 💻 Tech Stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| **Frontend** | React 19.2.0 | UI components & state |
| | Vite 7 | Build tool & dev server |
| | Axios | HTTP client with interceptors |
| | Bootstrap 5.3.8 | Responsive CSS framework |
| **Backend** | Django 5.2.8 | Web framework & ORM |
| | Django REST Framework | RESTful API |
| | Simple JWT | Token authentication |
| | Gunicorn | Production WSGI server |
| **Database** | PostgreSQL 15 | Production storage |
| | SQLite | Development fallback |
| **DevOps** | Docker | Containerisation |
| | Docker Compose | Local multi-container setup |
| | Kubernetes | Production orchestration |
| | Jenkins | CI/CD pipeline |

---

## 📋 Prerequisites

| Tool | Version | Required For |
|------|---------|-------------|
| Python | 3.8+ | Local backend dev |
| Node.js | 16+ | Local frontend dev |
| Docker | 24.0+ | Container builds |
| Docker Compose | 2.0+ | Local stack |
| kubectl | 1.26+ | Kubernetes deploys |
| Minikube | Latest | Local k8s cluster |
| Jenkins | 2.400+ | CI/CD pipeline |

---

## ⚡ Quick Start

### Option 1: Local Development (Fastest)

```bash
# 1. Clone
git clone https://github.com/mdskun/Real-Time-Chat-Application.git
cd Real-Time-Chat-Application

# 2. Backend
cd backend
python -m venv venv && source venv/bin/activate   # Windows: venv\Scripts\activate
pip install -r requirements.txt
cp ../.env.example .env    # fill in your values
python manage.py migrate
python manage.py runserver
# → http://127.0.0.1:8000/

# 3. Frontend (new terminal)
cd frontend
npm install
echo "VITE_API_BASE_URL=http://localhost:8000" > .env.local
npm run dev
# → http://localhost:3000/
```

---

### Option 2: Docker Compose

```bash
git clone https://github.com/mdskun/Real-Time-Chat-Application.git
cd Real-Time-Chat-Application

cp .env.example .env        # edit with real credentials
docker-compose up -d
docker-compose exec backend python manage.py migrate
docker-compose exec backend python manage.py createsuperuser   # optional

# Frontend:  http://localhost:3000/
# Backend:   http://localhost:8000/
# Admin:     http://localhost:8000/admin/
```

---

### Option 3: Kubernetes

> Full details in [☸️ Kubernetes Reference](#️-kubernetes-reference) below.

```bash
# One-time manual deploy (CI/CD does this automatically)
kubectl apply -f k8s/namespace.yml
kubectl apply -f k8s/configmaps.yml   # ⚠️ create this file first — see below
kubectl apply -f k8s/secret.yml       # ⚠️ gitignored — create manually
kubectl apply -f k8s/db_service.yml
kubectl apply -f k8s/db_service2.yml
kubectl apply -f k8s/db_stateful.yml
kubectl apply -f k8s/back_deployment.yml
kubectl apply -f k8s/back_service.yml
kubectl apply -f k8s/front_deployment.yml
kubectl apply -f k8s/front_service.yml

# Access on Minikube
minikube service chat-frontend-svc -n chatapp
```

---

## 🔧 Configuration

### Environment Variables

| Variable | Description | Used By |
|----------|-------------|---------|
| `DJANGO_SECRET_KEY` | Django cryptographic key | Backend |
| `REGISTRATION_SECRET` | Protects the register endpoint | Backend |
| `DJANGO_ALLOWED_HOSTS` | Comma-separated allowed hostnames | Backend |
| `DB_ENGINE` | Django DB engine string | Backend |
| `DB_NAME` | Database name | Backend |
| `DB_USER` | Database user | Backend + Postgres |
| `DB_PASSWORD` | Database password | Backend + Postgres |
| `DB_HOST` | Database hostname | Backend |
| `DB_PORT` | Database port (default 5432) | Backend |
| `POSTGRES_DB` | Postgres init DB name | Postgres image |
| `POSTGRES_USER` | Postgres init user | Postgres image |
| `POSTGRES_PASSWORD` | Postgres init password | Postgres image |
| `VITE_API_BASE_URL` | Backend URL baked into frontend bundle | Frontend build |

### Local `.env` example

```env
DJANGO_SECRET_KEY=your-very-long-random-secret-key
REGISTRATION_SECRET=your-registration-secret
DJANGO_ALLOWED_HOSTS=localhost,127.0.0.1
DB_ENGINE=django.db.backends.postgresql
DB_NAME=chatdb
DB_USER=chatuser
DB_PASSWORD=chatpass
DB_HOST=db
DB_PORT=5432
POSTGRES_DB=chatdb
POSTGRES_USER=chatuser
POSTGRES_PASSWORD=chatpass
VITE_API_BASE_URL=http://localhost:8000
```

---

## 📁 Project Structure

```
Real-Time-Chat-Application/
├── 📄 docker-compose.yml              Local multi-container stack
├── 📄 .env.example                    Environment variable template
│
├── 📁 backend/
│   ├── 📄 dockerfile                  python:3.11-slim, gunicorn
│   ├── 📄 entrypoint.sh               Waits for postgres, runs migrate + collectstatic
│   ├── 📄 requirements.txt
│   ├── 📄 manage.py
│   ├── 📁 coreBackend/
│   │   ├── settings.py                All Django config (reads from env)
│   │   ├── urls.py                    Root URL config incl. /api/health/
│   │   └── wsgi.py
│   ├── 📁 accounts/                   Auth, JWT, presence, throttling
│   │   ├── models.py                  User Profile (last_seen, online)
│   │   ├── views.py                   register, login, refresh, me, users, presence
│   │   ├── serializers.py
│   │   ├── urls.py
│   │   ├── middleware.py              LastSeenMiddleware (updates on every request)
│   │   └── throttling.py             RegisterThrottle, LoginThrottle
│   └── 📁 chat/                       Messaging & blocking
│       ├── models.py                  Message, Block
│       ├── views.py                   messages, unread_counts, block/unblock
│       ├── serializers.py
│       └── urls.py
│
├── 📁 frontend/
│   ├── 📄 dockerfile                  Multi-stage: build with node, serve with vite preview
│   ├── 📄 vite.config.js              Port 3000, host 0.0.0.0
│   ├── 📄 package.json
│   └── 📁 src/
│       ├── App.jsx                    Root — auth state, routing
│       ├── main.jsx
│       ├── config/api.js              Axios instance + JWT interceptors
│       ├── 📁 components/
│       │   ├── ChatWindow.jsx         Chat UI + 1s polling loop
│       │   └── Sidebar.jsx            User list, presence, unread badges
│       └── 📁 pages/
│           ├── Login.jsx
│           ├── Register.jsx
│           └── Contact.jsx
│
├── 📁 k8s/
│   ├── 📄 namespace.yml               namespace: chatapp
│   ├── 📄 configmaps.yml              ⚠️ GITIGNORED — create manually (see below)
│   ├── 📄 secret.yml                  ⚠️ GITIGNORED — create manually (see below)
│   ├── 📄 db_service.yml              Headless Service for StatefulSet DNS
│   ├── 📄 db_service2.yml             ClusterIP Service for backend → postgres
│   ├── 📄 db_stateful.yml             PostgreSQL StatefulSet + PVC (5Gi)
│   ├── 📄 back_deployment.yml         Django backend, 2 replicas, health probes
│   ├── 📄 back_service.yml            ClusterIP :8000
│   ├── 📄 front_deployment.yml        React frontend, 2 replicas
│   ├── 📄 front_service.yml           NodePort :30088
│   └── 📄 jenkinfile                  Declarative Jenkins pipeline (CI/CD)
│
└── 📁 terraform/
    └── main.tf                        Cloud infrastructure (optional)
```

---

## 🚀 CI/CD Pipeline (Jenkins)

The pipeline lives in `k8s/jenkinfile` and is a **Jenkins Declarative Pipeline** with two stages.

### How it works

```
Git push
   │
   ▼
┌─────────────────────────────────┐
│  Stage 1: Build & Push Images   │
│                                 │
│  docker build frontend          │
│    --build-arg VITE_API_BASE_URL│  ← baked into JS bundle at build time
│  docker push :latest + :BUILD#  │
│                                 │
│  docker build backend           │
│  docker push :latest + :BUILD#  │
└────────────────┬────────────────┘
                 │ SSH into k-slave
                 ▼
┌─────────────────────────────────┐
│  Stage 2: Deploy to K8s         │
│                                 │
│  git pull on slave              │
│  kubectl apply namespace        │
│  kubectl apply configmaps       │
│  kubectl create secret          │  ← from Jenkins credentials store
│  kubectl apply db services      │
│  kubectl apply db statefulset   │
│  kubectl wait db ready          │
│  kubectl apply backend          │
│  kubectl rollout status         │
│  kubectl exec manage.py migrate │  ← runs automatically on every deploy
│  kubectl apply frontend         │
│  kubectl rollout status         │
└─────────────────────────────────┘
```

### Jenkins Credentials Required

Set these up in **Jenkins → Manage Jenkins → Credentials** before running the pipeline:

| Credential ID | Type | Value |
|--------------|------|-------|
| `6bb7cd36-f983-497a-bae2-c55ce36c04fb` | Username + Password | DockerHub username & password |
| `DJANGO_SECRET_KEY` | Secret text | Your Django secret key |
| `REGISTRATION_SECRET` | Secret text | Your registration secret |
| `DB_PASSWORD` | Secret text | PostgreSQL password |
| `POSTGRES_PASSWORD` | Secret text | PostgreSQL password (same value) |

### Infrastructure assumptions

| What | Where |
|------|-------|
| Jenkins node with Docker | Builds & pushes images |
| SSH key | `/var/lib/jenkins/key` |
| Kubernetes slave | Hostname `k-slave`, user `ec2-user` |
| kubectl configured | On the `k-slave` node pointing at your cluster |

> To change the slave host, user, or SSH key path, edit the `environment {}` block at the top of `k8s/jenkinfile`.

---

## ☸️ Kubernetes Reference

### Gitignored files — create these manually

Both files contain credentials and are listed in `.gitignore`. You must create them on any machine before deploying.

#### `k8s/configmaps.yml`

Holds non-sensitive config. Sensitive values (`DJANGO_SECRET_KEY`, `DB_PASSWORD`, `POSTGRES_PASSWORD`, `REGISTRATION_SECRET`) are intentionally **absent** — they come from the Secret.

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: env-back
  namespace: chatapp
data:
  DJANGO_ALLOWED_HOSTS: "chat-backend-svc,chat-backend-svc.chatapp.svc.cluster.local,chat-frontend-svc"
  DB_ENGINE: "django.db.backends.postgresql"
  DB_NAME: "chatdb"
  DB_USER: "chatuser"
  DB_HOST: "chat-db"
  DB_PORT: "5432"
  POSTGRES_DB: "chatdb"
  POSTGRES_USER: "chatuser"
  PGDATA: "/var/lib/postgresql/data/pgdata"
```

#### `k8s/secret.yml`

Holds sensitive values. Jenkins creates/updates this automatically via `kubectl create secret --dry-run=client | kubectl apply`, so you only need this file for manual deploys.

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: env-secrets
  namespace: chatapp
type: Opaque
stringData:
  DJANGO_SECRET_KEY: "your-secret-key"
  REGISTRATION_SECRET: "your-registration-secret"
  DB_PASSWORD: "your-db-password"
  POSTGRES_PASSWORD: "your-db-password"
```

### Cluster layout

```
Namespace: chatapp
│
├── ConfigMap: env-back          Non-sensitive backend + postgres config
├── Secret: env-secrets          DJANGO_SECRET_KEY, DB_PASSWORD, etc.
│
├── Service: chat-db             Headless — gives StatefulSet pods stable DNS
│                                (chat-db-0.chat-db.chatapp.svc.cluster.local)
├── Service: chat-db-svc         ClusterIP — backend connects here
├── StatefulSet: chat-db         postgres:15, PVC 5Gi, readiness: pg_isready
│
├── Service: chat-backend-svc    ClusterIP :8000 — internal only
├── Deployment: chat-backend     2 replicas, liveness + readiness on /api/health/
│
├── Service: chat-frontend-svc   NodePort :30088 — external access
└── Deployment: chat-frontend    2 replicas, readiness on /
```

### Why two DB services?

| Service | Type | Purpose |
|---------|------|---------|
| `chat-db` | Headless (`clusterIP: None`) | Required by StatefulSet — gives pods stable DNS hostnames. `entrypoint.sh` waits on this name with `nc`. |
| `chat-db-svc` | ClusterIP | Standard service used by backend to connect to postgres. |

### Important: VITE_API_BASE_URL is a build-time variable

Vite replaces `import.meta.env.VITE_*` **at bundle build time**, not at runtime. This means:

- A Kubernetes ConfigMap or env var injected at runtime has **zero effect** on the compiled JS bundle.
- The URL must be passed as a Docker `--build-arg` during `docker build`.
- The Jenkins pipeline handles this automatically via `--build-arg VITE_API_BASE_URL=...`.
- If you need to change the backend URL, you must **rebuild and repush the frontend image**.

### Accessing the app

**Minikube:**
```bash
minikube service chat-frontend-svc -n chatapp
# or
echo "http://$(minikube ip):30088"
```

**Cloud cluster (EKS / GKE / AKS):**
```bash
kubectl get nodes -o wide   # grab EXTERNAL-IP
# open http://<EXTERNAL-IP>:30088
```

**Backend port-forward (testing):**
```bash
kubectl port-forward svc/chat-backend-svc 8000:8000 -n chatapp
# http://localhost:8000/api/health/
```

### Useful kubectl commands

```bash
# Status
kubectl get pods -n chatapp
kubectl get svc  -n chatapp

# Logs
kubectl logs -f deployment/chat-backend  -n chatapp
kubectl logs -f deployment/chat-frontend -n chatapp
kubectl logs -f statefulset/chat-db      -n chatapp

# Debug a crashing pod
kubectl describe pod <pod-name> -n chatapp

# Restart after config change
kubectl rollout restart deployment/chat-backend  -n chatapp
kubectl rollout restart deployment/chat-frontend -n chatapp

# Scale
kubectl scale deployment chat-backend --replicas=3 -n chatapp

# Run a one-off command
kubectl exec -n chatapp deployment/chat-backend -- python manage.py createsuperuser

# Nuclear option — delete everything
kubectl delete namespace chatapp
```

---

## 📚 API Documentation

### Endpoints

#### Auth & Users
```
POST   /api/register/           Register (requires REGISTRATION_SECRET header)
POST   /api/login/              Returns {access, refresh} JWT tokens
POST   /api/refresh/            Refresh access token
GET    /api/me/                 Current authenticated user
GET    /api/users/              All users + last message preview
GET    /api/presence/           All users' online status
GET    /api/health/             Health check — used by Kubernetes probes
```

#### Messaging
```
GET    /api/chat/messages/?user_id=X&after=Y    Fetch messages (incremental)
POST   /api/chat/messages/                      Send a message
GET    /api/chat/unread_counts/                 Unread counts per user
```

#### Blocking
```
POST   /api/chat/block/         Block a user
DELETE /api/chat/block/         Unblock a user
GET    /api/chat/block/status/  Check if blocked (either direction)
```

### Request / Response example

```json
// POST /api/chat/messages/
// Headers: Authorization: Bearer <access_token>
{ "receiver": 2, "content": "Hello!" }

// 201 Created
{
  "id": 123,
  "sender": 1,
  "receiver": 2,
  "content": "Hello!",
  "timestamp": "2026-06-11T14:00:00Z",
  "is_read": false
}
```

### Database Schema

```
User (Django built-in)          Profile
├── id                          ├── user (1:1 → User)
├── username                    ├── last_seen (DateTime)
├── email                       └── online (computed)
└── password (hashed)

Message                         Block
├── id                          ├── id
├── sender   (FK → User)        ├── blocker (FK → User)
├── receiver (FK → User)        ├── blocked (FK → User)
├── content                     └── created_at
├── timestamp
└── is_read
```

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

---

## 👨‍💼 Author

<div align="center">

**Created with ❤️ by Manthan D Soni**

[![GitHub](https://img.shields.io/badge/GitHub-mdskun-181717?logo=github&logoColor=white&style=flat-square)](https://github.com/mdskun)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0A66C2?logo=linkedin&logoColor=white&style=flat-square)](https://www.linkedin.com/in/manthan-soni-595641243/)

**Made with 🔥 for developers, by developers**

</div>
