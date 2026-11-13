# Taller Observabilidad y Monitoreo — DevOps

App Flask con métricas Prometheus + Prometheus + Grafana con Docker Compose, desplegados en AWS EC2 con GitHub Actions.

## Estructura

```
.
├── app/                     # Paso 1 y 2: app Flask + Dockerfile
├── monitoring/              # Paso 3: prometheus.yml + provisión de Grafana
├── docker-compose.yaml      # Paso 4
├── .github/workflows/
│   ├── build-push.yml       # Paso 5: build y push a GHCR (latest)
│   ├── deploy-app.yml       # Paso 6: workflow_dispatch -> SSH -> git pull -> up app
│   └── deploy-monitoring.yml# Paso 7: cambios en monitoring/ -> SSH -> up prometheus grafana
└── scripts/                 # setup-ec2.sh y generar-trafico.sh
```

## Guía de ejecución (para tomar las evidencias)

1. **Prueba local**: `docker compose up -d --build` → abrir http://localhost:8000, http://localhost:8000/metrics, http://localhost:9090/targets y http://localhost:3000 (admin/admin).
2. **GitHub**: crear repo público, `git init && git add . && git commit -m "Taller" && git branch -M main && git remote add origin URL && git push -u origin main`.
3. **Paso 5**: el push dispara *Build & Push App Image*. Ver la imagen en el perfil → Packages. Opcional: Package settings → Change visibility → Public.
4. **EC2**: lanzar Ubuntu t2.micro/t3.micro con un key pair. Security Group de entrada: 22, 8000, 9090, 3000. Conectarse y ejecutar `bash setup-ec2.sh URL_DEL_REPO`; salir y volver a entrar. En `~/taller-observabilidad` crear `.env` desde `.env.example`.
5. **Secrets** (Settings → Secrets and variables → Actions): `EC2_HOST` (IP pública), `EC2_USER` (`ubuntu`), `EC2_SSH_KEY` (contenido del .pem), `PROJECT_DIR` (`/home/ubuntu/taller-observabilidad`).
6. **Paso 6**: Actions → *Deploy App to EC2* → Run workflow. Abrir `http://IP:8000`.
7. **Paso 7**: editar algo en `monitoring/` (p. ej. un comentario en `prometheus.yml`), commit y push → se ejecuta *Deploy Monitoring to EC2*. Abrir `http://IP:9090` y `http://IP:3000`.
8. Generar tráfico: `bash scripts/generar-trafico.sh http://IP:8000 200` y ver el dashboard **Flask App - Observabilidad**.
