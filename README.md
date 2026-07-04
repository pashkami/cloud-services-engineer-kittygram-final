# Kittygram CI/CD Infrastructure Project

Educational DevOps project focused on containerized application delivery, CI/CD automation and remote deployment with GitHub Actions.

## What this project demonstrates

- Dockerized multi-service application delivery.
- Production-like `docker-compose` setup with PostgreSQL, backend, frontend and nginx/gateway services.
- GitHub Actions pipeline for tests, Docker image builds, Docker Hub publishing and remote deployment.
- SSH-based deployment to a server using GitHub secrets.
- Post-deploy database migrations and static files collection.
- Automated verification after deploy and Telegram deployment notification.

## Stack

- Docker, Docker Compose
- GitHub Actions
- Docker Hub
- PostgreSQL 13
- Python / Django backend
- Node.js frontend
- nginx gateway
- SSH deploy with `appleboy/scp-action` and `appleboy/ssh-action`
- pytest, flake8

## Repository structure

- `backend/` - Django backend service.
- `frontend/` - frontend application.
- `nginx/` - gateway/nginx image context.
- `docker-compose.production.yml` - production compose file for server deployment.
- `.github/workflows/main.yml` - CI/CD workflow: test, build, push, deploy, verify, notify.
- `tests/` - post-deploy/autotest checks.

## CI/CD flow

1. Run backend linting and tests with PostgreSQL service container.
2. Run frontend tests.
3. Build backend, frontend and gateway Docker images.
4. Push images to Docker Hub.
5. Copy `docker-compose.production.yml` to the target server over SSH.
6. Create `.env` on the server from GitHub Actions secrets.
7. Pull new images and restart the stack with Docker Compose.
8. Run Django migrations and collect static files.
9. Run automated checks.
10. Send deployment result to Telegram.

## Why it is relevant for DevOps / Infrastructure roles

The project shows practical CI/CD mechanics around a real multi-service application: service composition, image build/publish flow, secret handling in CI, remote deployment, database migration step, smoke/autotest stage and operational notification.

## Notes

This is an educational project, not a commercial production system. The goal is to demonstrate deployment automation and infrastructure workflow design in a compact repository.
