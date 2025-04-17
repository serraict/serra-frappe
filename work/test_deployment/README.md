# Serra Frappe Deployment - Test Environment

This directory contains a test environment and documentation for testing the Serra Frappe deployment process.

## Directory Structure

```
work/test_deployment/
├── README.md                       # This file
├── serra-frappe-deployment/        # Symbolic link to the repository
├── config/                         # Test configuration
│   └── .env                        # Test environment variables
├── build_instructions.md           # Instructions for testing with GitHub Actions
├── deploy_instructions.md          # Instructions for testing the deploy.sh script
├── update_instructions.md          # Instructions for testing the update.sh script
├── test_plan.md                    # Comprehensive test plan
└── deployment_documentation.md     # Detailed deployment documentation
```

## Test Environment Setup

The test environment is set up to mirror the recommended client setup structure:

```
~/serra-frappe/
├── serra-frappe-deployment/    # This repo
└── config/                    # Machine-specific (git-ignored)
    └── .env                   # Environment variables
```

In our test environment, we've created a symbolic link to the repository and a test configuration directory.

## Test Configuration

The test configuration file (`config/.env`) is based on the `env.example` file from the repository, with the following modifications:

- Changed the image name to use the GitHub Container Registry image
- Set a test database password
- Changed the HTTP port to 8090 to avoid conflicts with any existing services
- Set `PULL_POLICY=always` to ensure Docker always pulls the latest version of the image

## GitHub Actions Workflow

We've added a GitHub Actions workflow (`.github/workflows/docker-build.yml`) to build and publish the Docker image to GitHub Container Registry. This approach avoids platform mismatch issues and provides a more production-like workflow.

## Documentation

The following documentation is available:

- **build_instructions.md**: Instructions for using GitHub Actions to build the Docker image
- **deploy_instructions.md**: Instructions for testing the deploy.sh script
- **update_instructions.md**: Instructions for testing the update.sh script
- **test_plan.md**: A comprehensive test plan for testing the deployment process
- **deployment_documentation.md**: Detailed documentation for the deployment process

## Testing Process

For a step-by-step guide to executing the test plan, see the `execution_guide.md` file. This guide will walk you through:

1. Building the Docker image with GitHub Actions
2. Testing the deploy.sh script
3. Verifying services
4. Testing the update.sh script
5. Testing different deployment options
6. Cleaning up
7. Updating documentation

Alternatively, you can follow the individual instruction files:

- `build_instructions.md`: Instructions for using GitHub Actions to build the Docker image
- `deploy_instructions.md`: Instructions for testing the deploy.sh script
- `update_instructions.md`: Instructions for testing the update.sh script

## Cleanup

After testing, you can clean up the test environment by:

1. Stopping and removing the containers:

   ```bash
   docker compose --project-name serra-frappe-test down
   ```

2. Removing the pulled image:

   ```bash
   docker rmi ghcr.io/YOUR_GITHUB_USERNAME/frappe-test:v15
   ```

   Replace `YOUR_GITHUB_USERNAME` with your actual GitHub username or organization name.
