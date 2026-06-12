pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = "docker.io"
        BACKEND_IMAGE   = "mdskun/chatapp2_backend"
        FRONTEND_IMAGE  = "mdskun/chatapp2_frontend"
        // VITE_API_BASE_URL is baked into the frontend bundle at build time.
        // This must match the k8s Service name the browser can reach.
        // For in-cluster traffic from frontend pod -> backend: use the svc name.
        // For browser traffic (NodePort / Ingress), update this to your external URL.
        VITE_API_URL    = "http://chat-backend-svc:8000"
        K8S_NAMESPACE   = "chatapp"
        K8S_SLAVE_HOST  = "k-slave"
        K8S_SLAVE_USER  = "ec2-user"
        SSH_KEY_PATH    = "/var/lib/jenkins/key"
        REPO_URL        = "https://github.com/Mdskun/Real-Time-Chat-Application.git"
        REPO_DIR        = "Real-Time-Chat-Application"
    }

    stages {

        // ─── Stage 1: Build & push images ────────────────────────────────────
        stage('Build & Push Images') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: '6bb7cd36-f983-497a-bae2-c55ce36c04fb',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKERPASS'
                    )
                ]) {
                    sh '''
                        sudo systemctl restart docker
                        echo "$DOCKERPASS" | docker login --username "$DOCKER_USER" --password-stdin

                        # Frontend: VITE_API_BASE_URL must be passed as a build ARG
                        # because Vite bakes import.meta.env.VITE_* into the JS bundle at build time.
                        # A runtime env var injected by Kubernetes has NO effect on an already-built bundle.
                        docker build \
                            --build-arg VITE_API_BASE_URL="${VITE_API_URL}"  --network=host\
                            -t "${DOCKER_REGISTRY}/${FRONTEND_IMAGE}:latest" \
                            -t "${DOCKER_REGISTRY}/${FRONTEND_IMAGE}:${BUILD_NUMBER}" \
                            ./frontend

                        docker push "${DOCKER_REGISTRY}/${FRONTEND_IMAGE}:latest"
                        docker push "${DOCKER_REGISTRY}/${FRONTEND_IMAGE}:${BUILD_NUMBER}"

                        docker build  --network=host \
                            -t "${DOCKER_REGISTRY}/${BACKEND_IMAGE}:latest" \
                            -t "${DOCKER_REGISTRY}/${BACKEND_IMAGE}:${BUILD_NUMBER}" \
                            ./backend

                        docker push "${DOCKER_REGISTRY}/${BACKEND_IMAGE}:latest"
                        docker push "${DOCKER_REGISTRY}/${BACKEND_IMAGE}:${BUILD_NUMBER}"
                    '''
                }
            }
        }

        // ─── Stage 2: Deploy to Kubernetes (remote slave) ────────────────────
        stage('Deploy to K8s') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: '6bb7cd36-f983-497a-bae2-c55ce36c04fb',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKERPASS'
                    ),
                    string(credentialsId: 'DJANGO_SECRET_KEY',    variable: 'DJANGO_SECRET_KEY'),
                    string(credentialsId: 'REGISTRATION_SECRET',  variable: 'REGISTRATION_SECRET'),
                    string(credentialsId: 'DB_PASSWORD',          variable: 'DB_PASSWORD'),
                    string(credentialsId: 'POSTGRES_PASSWORD',    variable: 'POSTGRES_PASSWORD')
                ]) {
                    // Pass credentials as explicit SSH -o SendEnv vars rather than inside
                    // a heredoc, so withCredentials masking works correctly on the remote side.
                    sh '''
                        # Copy repo to slave (or update it)
                        ssh -i "${SSH_KEY_PATH}" \
                            -o StrictHostKeyChecking=no \
                            "${K8S_SLAVE_USER}@${K8S_SLAVE_HOST}" \
                            "if [ -d ${REPO_DIR} ]; then cd ${REPO_DIR} && git pull; \
                             else git clone ${REPO_URL} && cd ${REPO_DIR}; fi"

                        # Write a temp env file on the slave with credentials
                        # (ssh passes the values as args — never stored in shell history)
                        ssh -i "${SSH_KEY_PATH}" \
                            -o StrictHostKeyChecking=no \
                            "${K8S_SLAVE_USER}@${K8S_SLAVE_HOST}" \
                            "cat > /tmp/deploy_env.sh << 'ENVEOF'
export DOCKER_USER='${DOCKER_USER}'
export DOCKERPASS='${DOCKERPASS}'
export DJANGO_SECRET_KEY='${DJANGO_SECRET_KEY}'
export REGISTRATION_SECRET='${REGISTRATION_SECRET}'
export DB_PASSWORD='${DB_PASSWORD}'
export POSTGRES_PASSWORD='${POSTGRES_PASSWORD}'
ENVEOF
chmod 600 /tmp/deploy_env.sh"

                        # Run the full deploy script on the slave
                        ssh -i "${SSH_KEY_PATH}" \
                            -o StrictHostKeyChecking=no \
                            "${K8S_SLAVE_USER}@${K8S_SLAVE_HOST}" bash << 'SCRIPT'
set -e
source /tmp/deploy_env.sh

echo "$DOCKERPASS" | docker login --username "$DOCKER_USER" --password-stdin

cd Real-Time-Chat-Application

# ── Apply manifests in dependency order ──────────────────────────────────────
# 1. Namespace first (everything else goes inside it)
kubectl apply -f k8s/namespace.yml

# 2. ConfigMap (non-sensitive config)
kubectl apply -f k8s/configmaps.yml

# 3. Secret — use dry-run + apply so re-runs don't error with "already exists"
kubectl create secret generic env-secrets \
  --namespace=chatapp \
  --from-literal=DJANGO_SECRET_KEY="$DJANGO_SECRET_KEY" \
  --from-literal=REGISTRATION_SECRET="$REGISTRATION_SECRET" \
  --from-literal=DB_PASSWORD="$DB_PASSWORD" \
  --from-literal=POSTGRES_PASSWORD="$POSTGRES_PASSWORD" \
  --dry-run=client -o yaml | kubectl apply -f -

# 4. DB Services must exist BEFORE StatefulSet starts (headless DNS is needed by pods)
kubectl apply -f k8s/db_service.yml
kubectl apply -f k8s/db_service2.yml

# 5. DB StatefulSet
kubectl apply -f k8s/db_stateful.yml

# 6. Wait for DB to be ready before applying backend (entrypoint.sh needs postgres up)
echo "Waiting for postgres pod to be ready..."
if ! kubectl wait --for=condition=ready pod/chat-db-0 -n chatapp --timeout=300s; then
  echo "❌ Postgres failed. Dumping logs..."
  kubectl describe pod chat-db-0 -n chatapp
  kubectl logs chat-db-0 -n chatapp
  exit 1
fi

# 7. Backend
kubectl apply -f k8s/back_deployment.yml
kubectl apply -f k8s/back_service.yml

# 8. Wait for backend, then run migrations
kubectl rollout status deployment/chat-backend -n chatapp --timeout=120s

echo "Running database migrations..."
kubectl exec -n chatapp deployment/chat-backend -- python manage.py migrate --noinput

# 9. Frontend
kubectl apply -f k8s/front_deployment.yml
kubectl apply -f k8s/front_service.yml

kubectl rollout status deployment/chat-frontend -n chatapp --timeout=120s

# ── Cleanup temp creds file ───────────────────────────────────────────────────
rm -f /tmp/deploy_env.sh

echo ""
echo "✅ Deploy complete"
kubectl get pods -n chatapp
SCRIPT
                    '''
                }
            }
        }
    }

    // ─── Post: notify on success/failure ─────────────────────────────────────
    post {
        success {
            echo "✅ Pipeline succeeded — build #${BUILD_NUMBER} is live."
        }
        failure {
            echo "❌ Pipeline failed at stage. Check logs above."
            // Add email / Slack notification here if needed:
            // slackSend channel: '#deploys', message: "❌ Build ${BUILD_NUMBER} failed."
        }
        always {
            // Clean up local docker images to avoid disk fill on the Jenkins node
            sh '''
                docker rmi "${DOCKER_REGISTRY}/${FRONTEND_IMAGE}:${BUILD_NUMBER}" || true
                docker rmi "${DOCKER_REGISTRY}/${BACKEND_IMAGE}:${BUILD_NUMBER}"  || true
            '''
        }
    }
}
