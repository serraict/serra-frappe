#!/bin/bash
set -e

# Change to the repository root directory
cd "$(dirname "$0")/.."
REPO_ROOT=$(pwd)

# Default values
ENV_FILE="../config/.env"
COMPOSE_PROJECT_NAME="serra-frappe"
COMPOSE_FILES="-f frappe_docker/compose.yaml -f frappe_docker/overrides/compose.mariadb.yaml -f frappe_docker/overrides/compose.redis.yaml -f frappe_docker/overrides/compose.noproxy.yaml"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --env-file)
      ENV_FILE="$2"
      shift 2
      ;;
    --project-name)
      COMPOSE_PROJECT_NAME="$2"
      shift 2
      ;;
    --with-https)
      COMPOSE_FILES="${COMPOSE_FILES} -f frappe_docker/overrides/compose.https.yaml"
      shift
      ;;
    --with-proxy)
      # Replace noproxy with proxy
      COMPOSE_FILES="${COMPOSE_FILES/compose.noproxy.yaml/compose.proxy.yaml}"
      shift
      ;;
    --help)
      echo "Usage: $0 [options]"
      echo "Options:"
      echo "  --env-file FILE           Path to environment file (default: ../config/.env)"
      echo "  --project-name NAME       Docker Compose project name (default: serra-frappe)"
      echo "  --with-https              Enable HTTPS with Let's Encrypt"
      echo "  --with-proxy              Use Traefik proxy instead of direct port publishing"
      echo "  --help                    Show this help message"
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

# Check if environment file exists
if [ ! -f "$ENV_FILE" ]; then
  echo "Error: Environment file not found: $ENV_FILE"
  echo "Please create the environment file or specify a different one with --env-file"
  exit 1
fi

echo "Deploying Serra Frappe with the following configuration:"
echo "======================================================="
echo "Environment file: $ENV_FILE"
echo "Project name: $COMPOSE_PROJECT_NAME"
echo "Compose files: $COMPOSE_FILES"
echo

# Generate the docker-compose.yml file
echo "Generating docker-compose.yml..."
docker compose --env-file "$ENV_FILE" $COMPOSE_FILES config > docker-compose.yml

# Deploy the containers
echo "Starting containers..."
docker compose --project-name "$COMPOSE_PROJECT_NAME" -f docker-compose.yml up -d

echo
echo "Deployment completed successfully!"
echo
echo "To create a new site, run:"
echo "docker compose --project-name $COMPOSE_PROJECT_NAME exec backend bench new-site --mariadb-user-host-login-scope=% --admin-password <password> <site-name>"
echo
echo "To install serra-vine-configurator app, run:"
echo "docker compose --project-name $COMPOSE_PROJECT_NAME exec backend bench --site <site-name> install-app serra_vine_configurator"
