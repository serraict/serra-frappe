#!/bin/bash
set -e

# Change to the repository root directory
cd "$(dirname "$0")/.."
REPO_ROOT=$(pwd)

# Default values
ENV_FILE="../config/.env"
COMPOSE_PROJECT_NAME="serra-frappe"
SKIP_PULL=false
SKIP_BUILD=false
SKIP_BACKUP=false

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
    --skip-pull)
      SKIP_PULL=true
      shift
      ;;
    --skip-build)
      SKIP_BUILD=true
      shift
      ;;
    --skip-backup)
      SKIP_BACKUP=true
      shift
      ;;
    --help)
      echo "Usage: $0 [options]"
      echo "Options:"
      echo "  --env-file FILE           Path to environment file (default: ../config/.env)"
      echo "  --project-name NAME       Docker Compose project name (default: serra-frappe)"
      echo "  --skip-pull               Skip pulling latest changes from git"
      echo "  --skip-build              Skip building new image"
      echo "  --skip-backup             Skip backing up sites before update"
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

echo "Updating Serra Frappe deployment with the following configuration:"
echo "=============================================================="
echo "Environment file: $ENV_FILE"
echo "Project name: $COMPOSE_PROJECT_NAME"
echo

# Load environment variables
source "$ENV_FILE"

# Pull latest changes from git
if [ "$SKIP_PULL" = false ]; then
  echo "Pulling latest changes from git..."
  git pull
  git submodule update --init --recursive
fi

# Build new image if needed
if [ "$SKIP_BUILD" = false ]; then
  echo "Building new image..."
  ./scripts/build.sh
fi

# Backup sites before update
if [ "$SKIP_BACKUP" = false ]; then
  echo "Backing up sites..."
  docker compose --project-name "$COMPOSE_PROJECT_NAME" exec backend bench --site all backup
fi

# Update containers
echo "Updating containers..."
docker compose --project-name "$COMPOSE_PROJECT_NAME" down
docker compose --project-name "$COMPOSE_PROJECT_NAME" -f docker-compose.yml up -d

# Migrate sites
echo "Migrating sites..."
docker compose --project-name "$COMPOSE_PROJECT_NAME" exec backend bench --site all migrate

echo
echo "Update completed successfully!"
