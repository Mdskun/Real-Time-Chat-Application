# 🏗️ Architecture & Design Documentation

> **Comprehensive guide to understanding the Real-Time Chat Application's architecture, design patterns, and internal workings**

---

## 📖 Table of Contents

1. [System Architecture](#system-architecture)
2. [Technology Choices](#technology-choices)
3. [Design Patterns](#design-patterns)
4. [Backend Architecture](#backend-architecture)
5. [Frontend Architecture](#frontend-architecture)
6. [Data Flow](#data-flow)
7. [Database Design](#database-design)
8. [API Design](#api-design)
9. [Security Architecture](#security-architecture)
10. [Scalability Considerations](#scalability-considerations)
11. [Performance Optimization](#performance-optimization)

---

## 🏛️ System Architecture

### High-Level Overview

```
┌──────────────────────────────────────────────────────────────┐
│                     CLIENT LAYER (Browser)                   │
│                                                              │
│  ┌────────────────────────────────────────────────────────┐  │
│  │  React SPA (Single Page Application)                   │  │
│  │  - ChatWindow.jsx (Messaging UI)                       │  │
│  │  - Sidebar.jsx (User List & Presence)                  │  │
│  │  - Auth Pages (Login, Register)                        │  │
│  │  - Vite (Hot Module Replacement)                       │  │
│  └────────────────────────────────────────────────────────┘  │
│                                                              │
│           ↕ (HTTP/JSON with JWT Bearer Tokens)               │
└──────────────────────────────────────────────────────────────┘
                              ↓
┌──────────────────────────────────────────────────────────────┐
│                  TRANSPORT LAYER (Internet)                  │
│                                                              │
│  - CORS (Cross-Origin Resource Sharing)                      │
│  - TLS/HTTPS (Optional in production)                        │
│  - TCP/IP Network Protocol                                   │
└──────────────────────────────────────────────────────────────┘
                              ↓
┌──────────────────────────────────────────────────────────────┐
│                  API LAYER (REST Gateway)                    │
│                                                              │
│  Gunicorn WSGI Server (Production)                           │
│  Django Development Server (Development)                     │
└──────────────────────────────────────────────────────────────┘
                              ↓
┌──────────────────────────────────────────────────────────────┐
│              APPLICATION LAYER (Business Logic)              │
│                                                              │
│  ┌──────────────────┐  ┌──────────────────┐                  │
│  │  Accounts App    │  │  Chat App        │                  │
│  │  ├─ Auth Views   │  │  ├─ Message Ops  │                  │
│  │  ├─ Throttling   │  │  ├─ Block Ops    │                  │
│  │  ├─ Middleware   │  │  └─ Presence     │                  │
│  │  └─ Models       │  └─ Models          │                  │
│  └──────────────────┘  └──────────────────┘                  │
│                                                              │
│  Django REST Framework (DRF)                                 │
│  - Serializers (Data Validation & Transformation)            │
│  - Views (APIView, ViewSets)                                 │
│  - Routers (URL Routing)                                     │
│  - Permissions & Authentication                              │
└──────────────────────────────────────────────────────────────┘
                              ↓
┌──────────────────────────────────────────────────────────────┐
│                   DATA LAYER (Database)                      │
│                                                              │
│  PostgreSQL (Production) | SQLite (Development)              │
│  ├─ User Model & Profile                                     │
│  ├─ Message Table                                            │
│  ├─ Block Relationships                                      │
│  └─ Indexes (Performance Optimization)                       │
└──────────────────────────────────────────────────────────────┘
```

### Communication Protocol

```
                CLIENT                              SERVER
                  │                                  │
                  │  1. POST /api/login/             │
                  ├─────────────────────────────────>│
                  │     {username, password}         │
                  │                                  │
                  │  2. 200 OK + JWT Token           │
                  │<─────────────────────────────────┤
                  │     {access, refresh}            │
                  │                                  │
                  │  3. GET /api/chat/messages/      │
                  ├─────────────────────────────────>│
                  │     (Bearer: {token})            │
                  │                                  │
                  │  4. 200 OK + Messages Array      │
                  │<─────────────────────────────────┤
                  │                                  │
                  │  ↓ Polling every 1 second ↓      │
```

---

## 🔬 Technology Choices

### Why Django + React?

| Technology | Why Chosen | Alternatives Considered |
|-----------|-----------|------------------------|
| **Django** | Monolithic, batteries-included, ORM, rapid development | FastAPI, Node.js/Express |
| **React** | Large ecosystem, component reusability, hot reload | Vue.js, Svelte, Angular |
| **PostgreSQL** | Reliable, ACID-compliant, JSON support, scalable | MySQL, MongoDB, DynamoDB |
| **JWT** | Stateless, scalable, works with distributed systems | Sessions, OAuth2 |
| **REST API** | Simple, cacheable, standardized HTTP methods | GraphQL, gRPC |
| **Docker** | Consistent environments, easy deployment, isolation | Kubernetes, manual setup |

### Architecture Pattern: MVT → REST API

```
Traditional Django (MVT):
Views → Render HTML Templates → Browser

Our Approach (Rest API):
Models → Serializers → Views → JSON Response → JavaScript
```

---

## 🎨 Design Patterns

### 1. **Model-View-Template (MVT) → REST API**

```python
# Models: Define data structure
class Message(models.Model):
    sender = ForeignKey(User, ...)
    receiver = ForeignKey(User, ...)
    content = TextField()
    timestamp = DateTimeField(auto_now_add=True)

# Serializers: Transform models to JSON
class MessageSerializer(ModelSerializer):
    class Meta:
        model = Message
        fields = ['id', 'sender', 'receiver', 'content', 'timestamp']

# Views: Handle HTTP requests
class MessageListCreateView(APIView):
    def get(self, request):
        messages = Message.objects.filter(...)
        return Response(MessageSerializer(messages, many=True).data)

    def post(self, request):
        serializer = MessageSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save(sender=request.user)
            return Response(serializer.data, status=201)
```

### 2. **Authentication with JWT**

```python
# Token Generation (Login)
1. User submits credentials
2. Django verifies against hashed password
3. Creates access token (6-hour expiry)
4. Creates refresh token (7-day expiry)

# Token Usage (Subsequent Requests)
Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGc...

# Token Refresh
1. Access token expires
2. Client uses refresh token to get new access token
3. Continues without re-login
```

### 3. **Throttling (Rate Limiting)**

```python
# Custom throttle class
class RegisterThrottle(SimpleRateThrottle):
    scope = 'register'
    THROTTLE_RATES = {'register': '5/hour'}

# Applied at view level
class RegisterView(APIView):
    throttle_classes = [RegisterThrottle]
```

### 4. **Real-Time with Polling**

```javascript
// Frontend: Polls every 1 second
useEffect(() => {
    const interval = setInterval(() => {
        fetchMessages(afterId);  // Only fetch new messages
    }, 1000);

    return () => clearInterval(interval);
}, [otherUserId]);
```

### 5. **Presence Tracking (Online Status)**

```python
# Middleware updates last_seen on each request
class LastSeenMiddleware:
    def __call__(self, request):
        if request.user.is_authenticated:
            profile = Profile.objects.get(user=request.user)
            profile.last_seen = timezone.now()
            profile.save()
```

---

## 🔧 Backend Architecture

### Django Project Structure

```
backend/
├── coreBackend/                 # Main Django Project Config
│   ├── __init__.py
│   ├── settings.py              # Configuration (databases, apps, middleware)
│   ├── urls.py                  # Root URL routing
│   ├── asgi.py                  # ASGI config (async)
│   └── wsgi.py                  # WSGI config (production)
│
├── accounts/                    # User Management App
│   ├── models.py                # User, Profile
│   ├── views.py                 # Auth endpoints (register, login, me)
│   ├── serializers.py           # UserSerializer, RegisterSerializer
│   ├── urls.py                  # /api/register, /api/login, etc.
│   ├── middleware.py            # LastSeenMiddleware
│   ├── throttling.py            # RegisterThrottle, LoginThrottle
│   ├── migrations/              # Database migrations
│   └── admin.py                 # Admin interface configuration
│
├── chat/                        # Messaging App
│   ├── models.py                # Message, Block
│   ├── views.py                 # Message CRUD, Block operations
│   ├── serializers.py           # MessageSerializer
│   ├── urls.py                  # /api/chat/messages, /api/chat/block
│   ├── migrations/              # Database migrations
│   ├── tests.py                 # Unit tests
│   └── admin.py                 # Admin interface
│
├── manage.py                    # Django CLI
├── requirements.txt             # Python dependencies
├── db.sqlite3                   # SQLite database (development)
└── dockerfile                   # Docker image definition
```

### Key Django Settings

```python
# settings.py

INSTALLED_APPS = [
    'django.contrib.auth',          # User authentication
    'django.contrib.contenttypes',  # Content types
    'django.contrib.sessions',      # Session management
    'rest_framework',               # REST API framework
    'corsheaders',                  # CORS support
    'accounts',                     # Custom user app
    'chat',                         # Custom chat app
]

MIDDLEWARE = [
    'corsheaders.middleware.CorsMiddleware',  # Must be first
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'accounts.middleware.LastSeenMiddleware',  # Custom
]

REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': (
        'rest_framework_simplejwt.authentication.JWTAuthentication',
    ),
    'DEFAULT_PERMISSION_CLASSES': (
        'rest_framework.permissions.IsAuthenticated',
    ),
}
```

### Views (APIView Pattern)

```python
class MessageListCreateView(APIView):
    permission_classes = [IsAuthenticated]
    throttle_classes = [SendMessageThrottle]

    def get(self, request):
        # Business logic for retrieving messages
        # Returns serialized data

    def post(self, request):
        # Business logic for creating messages
        # Validates, saves, returns response
```

---

## 🎬 Frontend Architecture

### React Component Hierarchy

```
App.jsx (Root)
├── Navbar (Header)
├── Layout Wrapper
│   ├── Sidebar.jsx
│   │   ├── ChatList
│   │   │   └── ChatItem[] (Reusable)
│   │   └── SearchBar
│   │
│   └── ChatWindow.jsx
│       ├── ChatHeader
│       ├── MessagesList
│       │   └── MessageBubble[] (Reusable)
│       └── MessageInput (Form)
│
└── Auth Routes (when not logged in)
    ├── Login.jsx
    ├── Register.jsx
    └── Contact.jsx
```

### State Management

```javascript
// App.jsx - Root state
const [loggedIn, setLoggedIn] = useState(false);
const [currentUser, setCurrentUser] = useState(null);
const [selectedUser, setSelectedUser] = useState(null);

// Sidebar.jsx - Local state
const [users, setUsers] = useState([]);
const [presence, setPresence] = useState({});
const [unreadCounts, setUnreadCounts] = useState({});

// ChatWindow.jsx - Local state
const [messages, setMessages] = useState([]);
const [text, setText] = useState('');
const [blockInfo, setBlockInfo] = useState({});
```

### API Client (Axios)

```javascript
// config/api.js
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL;

const apiClient = axios.create({
    baseURL: API_BASE_URL,
    timeout: 10000,
});

// Interceptor: Add token to every request
apiClient.interceptors.request.use((config) => {
    const token = localStorage.getItem('access');
    if (token) {
        config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
});

// Interceptor: Handle 401 (token expired)
apiClient.interceptors.response.use(
    response => response,
    error => {
        if (error.response?.status === 401) {
            // Attempt token refresh
            // Or logout user
        }
        return Promise.reject(error);
    }
);
```

### Polling Logic

```javascript
// ChatWindow.jsx - Polling for new messages
useEffect(() => {
    const interval = setInterval(async () => {
        const response = await axios.get(
            `${API_BASE_URL}/api/chat/messages/?user_id=${otherUser.id}&after=${lastMessageIdRef.current}`
        );

        // Only updates with newer messages
        if (response.data.length > 0) {
            setMessages(prev => [...prev, ...response.data]);
        }
    }, 1000);  // Every 1 second

    return () => clearInterval(interval);
}, [otherUser]);
```

---

## 📊 Data Flow

### Complete Message Flow

```
SENDER                          SERVER                          RECEIVER
   │                               │                               │
   │ 1. User types message         │                               │
   ├──────────────────────────────────────────────────────────────>|
   │ POST /api/chat/messages/                                      │
   │ {receiver_id: 2, content: "Hi"}                               │
   │                               │                               │
   │                   2. Validate data                            │
   │                   3. Check blocks                             │
   │                   4. Save to database                         │
   │                               │                               │
   │ 5. 201 Created                │                               │
   │ {id: 123, sender: 1, ...}     │                               │
   │<──────────────────────────────────────────────────────────────|
   │                               │                               │
   │ 6. Add to UI immediately      │                               │
   │ (Optimistic update)           │                               │
   │                               │                               │
   │                               │  7. Polling request (every 1s)|
   │                               │<──────────────────────────────|
   │                               │  GET /api/chat/messages/      |
   │                               │  ?user_id=1&after=122         |
   │                               │                               |
   │                               │  8. Query database            |
   │                               │  9. Find messages after ID 122|
   │                               │                               |
   │                               │  10. Return new messages      |
   │                               │  {id: 123, content: "Hi", ...}|
   │                               ├──────────────────────────────>|
   │                               │                               |
   │                               │  11. Add to UI                |
   │                               │  12. Mark as read             |
   │                               │                               |
   │                               │  13. Polling request          |
   │                               │<──────────────────────────────|
   │                               │  (No new messages)            |
   │                               │  Return []                    |
   │                               ├──────────────────────────────>|
```

### Authentication Flow

```
USER                        CLIENT                          SERVER
 │                             │                              │
 │ 1. Enter credentials        │                              │
 ├────────────────────────────>│                              │
 │                             │ 2. POST /api/login/          │
 │                             ├─────────────────────────────>│
 │                             │                              │
 │                             │ 3. Verify password (bcrypt)  │
 │                             │ 4. Generate JWT tokens       │
 │                             │ 5. Return tokens             │
 │                             │<─────────────────────────────┤
 │ 6. Store tokens in          │                              │
 │    localStorage             │                              │
 │<────────────────────────────┤                              │
 │                             │                              │
 │ 7. Navigate to chat         │                              │
 │ 8. Make API request         │                              │
 ├────────────────────────────>│                              │
 │                             │ 9. Include token             │
 │                             │    Authorization: Bearer..   │
 │                             ├─────────────────────────────>│
 │                             │                              │
 │                             │ 10. Verify token signature   │
 │                             │ 11. Extract user from token  │
 │                             │ 12. Verify not expired       │
 │                             │ 13. Process request          │
 │                             │ 14. Return data              │
 │                             │<─────────────────────────────┤
 │ 15. Receive & display data  │                              │
 │<────────────────────────────┤                              │
```

---

## 🗄️ Database Design

### Entity Relationship Diagram (ERD)

```
┌─────────────────────┐
│      User           │
├─────────────────────┤
│ id (PK)             │
│ username            │
│ email               │
│ password            │
│ first_name          │
│ last_name           │
│ date_joined         │
│ is_active           │
└────────┬────────────┘
         │ 1:1
         │
         └──────────┐
                    │
         ┌──────────▼──────────┐
         │      Profile        │
         ├─────────────────────┤
         │ id (PK)             │
         │ user_id (FK)        │
         │ last_seen (DateTime)│
         │ online (computed)   │
         └─────────────────────┘

┌────────────────────────────────────────────────┐
│              Message                           │
├────────────────────────────────────────────────┤
│ id (PK)                                        │
│ sender_id (FK) ────────────> User(id)          │
│ receiver_id (FK) ─────────> User(id)           │
│ content (TextField)                            │
│ timestamp (DateTimeField)                      │
│ is_read (BooleanField, default=False)          │
├────────────────────────────────────────────────┤
│ Indexes:                                       │
│ - (sender, receiver, timestamp)                │
│ - (receiver, is_read)                          │
│ - timestamp (for sorting)                      │
└────────────────────────────────────────────────┘

┌────────────────────────────────────┐
│          Block                     │
├────────────────────────────────────┤
│ id (PK)                            │
│ blocker_id (FK) ──────> User(id)   │
│ blocked_id (FK) ──────> User(id)   │
│ created_at (DateTimeField)         │
├────────────────────────────────────┤
│ Unique Constraint:                 │
│ (blocker_id, blocked_id)           │
└────────────────────────────────────┘
```

### Key Indexes (Performance)

```python
# Improves query performance significantly

Message table:
- Index on (sender, receiver)  # For conversation queries
- Index on (receiver, is_read) # For unread count queries
- Index on timestamp           # For sorting/pagination

User table:
- Index on username            # For login queries
- Index on email               # For uniqueness check

Profile table:
- Foreign key index on user_id
- Index on last_seen          # For online status queries
```

---

## 🔌 API Design

### RESTful Principles

```
Resource          HTTP Method    Endpoint                    Action
─────────────────────────────────────────────────────────────────────
User              POST           /api/register/              Create
                  POST           /api/login/                 Login
                  POST           /api/refresh/               Refresh token
                  GET            /api/me/                    Get current
                  GET            /api/users/                 List all

Message           POST           /api/chat/messages/         Create
                  GET            /api/chat/messages/         List
                  GET            /api/chat/unread_counts/    Count unread

Block             POST           /api/chat/block/            Create
                  DELETE         /api/chat/block/            Delete
                  GET            /api/chat/block/status/     Check status

Presence          GET            /api/presence/              Get all online
```

### Request/Response Format

```json
// Request
POST /api/chat/messages/
Content-Type: application/json
Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGc...

{
  "receiver": 2,
  "content": "Hello!"
}

// Response
HTTP/1.1 201 Created
Content-Type: application/json

{
  "id": 123,
  "sender": 1,
  "receiver": 2,
  "content": "Hello!",
  "timestamp": "2024-01-15T10:30:45.123456Z",
  "is_read": false
}

// Error Response
HTTP/1.1 400 Bad Request
Content-Type: application/json

{
  "receiver": ["This field is required."],
  "detail": "receiver is required"
}
```

---

## 🔒 Security Architecture

### Layers of Security

#### 1. **Transport Layer (HTTPS in Production)**
```
- TLS 1.3 for encryption
- Certificates from Let's Encrypt
- HSTS headers
```

#### 2. **Authentication Layer (JWT)**
```
- Tokens are signed with SECRET_KEY
- Access tokens expire in 6 hours
- Refresh tokens expire in 7 days
- Tokens stored in localStorage (vulnerable to XSS)
- Alternative: HttpOnly cookies
```

#### 3. **Authorization Layer (Permissions)**
```python
# View-level permissions
class MessageListCreateView(APIView):
    permission_classes = [IsAuthenticated]  # Only logged in users

    def get(self, request):
        # Only allow user to see their own messages
        messages = Message.objects.filter(
            Q(sender=request.user) | Q(receiver=request.user)
        )
```

#### 4. **Input Validation (Serializers)**
```python
class MessageSerializer(ModelSerializer):
    class Meta:
        model = Message
        fields = ['id', 'sender', 'receiver', 'content', 'timestamp', 'is_read']

    def validate_content(self, value):
        if len(value.strip()) == 0:
            raise ValidationError("Message cannot be empty")
        if len(value) > 5000:
            raise ValidationError("Message too long")
        return value
```

#### 5. **Rate Limiting (Throttling)**
```python
# Prevents brute force attacks
class RegisterThrottle(SimpleRateThrottle):
    scope = 'register'
    THROTTLE_RATES = {
        'register': '5/hour',     # 5 registrations per hour per IP
        'login': '10/minute'      # 10 login attempts per minute
    }
```

#### 6. **CORS (Cross-Origin Resource Sharing)**
```python
# Whitelist allowed origins
CORS_ALLOWED_ORIGINS = [
    "http://localhost:3000",    # Development
    "https://app.example.com",  # Production
]
```

#### 7. **Data Validation (Business Logic)**
```python
# Prevent sending messages to blocked users
if Block.objects.filter(blocker=request.user, blocked=receiver).exists():
    return Response(
        {"detail": "You blocked this user."},
        status=status.HTTP_403_FORBIDDEN
    )

if Block.objects.filter(blocker=receiver, blocked=request.user).exists():
    return Response(
        {"detail": "This user has blocked you."},
        status=status.HTTP_403_FORBIDDEN
    )
```

### Security Checklist

- [ ] Use HTTPS in production
- [ ] Set `DEBUG = False` in production
- [ ] Use strong `SECRET_KEY` (random 50+ characters)
- [ ] Use environment variables for secrets (not in code)
- [ ] Set secure CORS origins (whitelist)
- [ ] Implement rate limiting
- [ ] Hash passwords with bcrypt (Django default)
- [ ] Validate all user inputs
- [ ] Use CSRF tokens for form submissions
- [ ] Set security headers (HSTS, CSP, X-Frame-Options)
- [ ] Keep dependencies updated
- [ ] Use HTTPS-only cookies
- [ ] Implement proper logging & monitoring

---

## 📈 Scalability Considerations

### Current Limitations

```
Current Setup:
- Single Django server
- Single database
- File-based caching (or no caching)
- Polling (inefficient at scale)
- Synchronous request handling
```

### Scaling Strategies

#### 1. **Horizontal Scaling (Multiple Servers)**
```
                    Load Balancer (nginx)
                            │
                ┌───────────┬───────────┐
                │           │           │
            Django 1    Django 2    Django 3
                │           │           │
                └───────────┬───────────┘
                            │
                    PostgreSQL (Shared)
```

**Implementation:**
```bash
# Use Gunicorn workers
gunicorn --workers 4 --bind 0.0.0.0:8000 coreBackend.wsgi

# Or Docker scaling
docker-compose up --scale backend=3
```

#### 2. **Database Optimization**
```
# Add indexes for frequently queried fields
Message.objects.filter(receiver=user, is_read=False).count()

# Add connection pooling
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'CONN_MAX_AGE': 600,  # Connection pooling
    }
}
```

#### 3. **Caching Layer (Redis)**
```python
# Cache user presence data
import redis

redis_client = redis.Redis(host='localhost', port=6379)

def get_presence(user_id):
    # Check cache first
    cached = redis_client.get(f'presence:{user_id}')
    if cached:
        return json.loads(cached)

    # Query database
    profile = Profile.objects.get(user_id=user_id)

    # Cache for 5 minutes
    redis_client.setex(
        f'presence:{user_id}',
        300,  # 5 minutes
        json.dumps({...})
    )
    return profile
```

#### 4. **Upgrade from Polling to WebSockets**
```
Current (Polling):
- Client polls server every 1 second
- Server processes N*1000 requests per second for N users
- Wasteful for low-activity chat rooms

With WebSockets (Django Channels):
- Persistent connection
- Server pushes messages in real-time
- Much more efficient
```

**Implementation with Django Channels:**
```bash
pip install channels channels-redis

# In settings.py:
ASGI_APPLICATION = 'coreBackend.asgi.application'

CHANNEL_LAYERS = {
    'default': {
        'BACKEND': 'channels_redis.core.RedisChannelLayer',
        'CONFIG': {
            'hosts': [('127.0.0.1', 6379)],
        },
    },
}
```

#### 5. **Message Queue (Celery)**
```python
# For async tasks (notifications, emails)
from celery import shared_task

@shared_task
def send_notification(user_id, message):
    # Run in background
    notify_user(user_id, message)

# In view:
send_notification.delay(user_id, message_text)
```

#### 6. **CDN for Static Assets**
```
Frontend assets → CloudFlare CDN
- Caches CSS, JS, images globally
- Reduces server bandwidth
- Faster loading for users worldwide
```

---

## ⚡ Performance Optimization

### Frontend Optimization

```javascript
// 1. Code Splitting with Vite
import { lazy, Suspense } from 'react';
const ChatWindow = lazy(() => import('./components/ChatWindow'));

// 2. Memoization (prevent unnecessary re-renders)
const ChatItem = memo(({ user, onClick }) => (
    <div onClick={onClick}>{user.name}</div>
));

// 3. Virtual Scrolling (for large lists)
// Only render visible messages

// 4. Debouncing (search, typing)
const [search, setSearch] = useState('');
const debouncedSearch = debounce(search, 300);

// 5. Lazy loading images
<img loading="lazy" src="avatar.jpg" />
```

### Backend Optimization

```python
# 1. Select related (reduce queries)
messages = Message.objects.select_related('sender', 'receiver')

# 2. Prefetch related (for reverse FK)
users = User.objects.prefetch_related('messages_sent')

# 3. Only select needed fields
Message.objects.only('id', 'content', 'timestamp')

# 4. Pagination
from rest_framework.pagination import PageNumberPagination

class StandardPagination(PageNumberPagination):
    page_size = 20

# 5. Filtering with database
Message.objects.filter(timestamp__gte=cutoff_time)

# 6. Aggregation
from django.db.models import Count
User.objects.annotate(message_count=Count('sent_messages'))
```

### Database Optimization

```sql
-- Add composite indexes
CREATE INDEX idx_message_sender_receiver
ON chat_message(sender_id, receiver_id, timestamp DESC);

CREATE INDEX idx_message_receiver_unread
ON chat_message(receiver_id, is_read);

-- Analyze query performance
EXPLAIN ANALYZE SELECT * FROM chat_message
WHERE sender_id = 1 AND receiver_id = 2;

-- Vacuum (clean up dead rows)
VACUUM ANALYZE;
```

---

## 🎯 Future Enhancements

### Phase 1: Foundation ✅
- [x] User authentication
- [x] Basic messaging
- [x] User presence

### Phase 2: Advanced Features
- [ ] WebSocket real-time (replace polling)
- [ ] Message search
- [ ] Group chats
- [ ] File/image sharing

### Phase 3: Enterprise Features
- [ ] End-to-end encryption
- [ ] Call integration (audio/video)
- [ ] Message threading
- [ ] Reactions & emojis

### Phase 4: Scale
- [ ] Horizontal scaling (multiple servers)
- [ ] Database replication
- [ ] Global CDN
- [ ] Analytics & monitoring

---

## 📚 Reference Documentation

- [Django Official Docs](https://docs.djangoproject.com/)
- [DRF Authentication](https://www.django-rest-framework.org/api-guide/authentication/)
- [React Docs](https://react.dev/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [JWT.io](https://jwt.io/)

---

**Last Updated**: January 2024
**Version**: 1.0
**Architecture Type**: Microservices-ready MVT → REST API
