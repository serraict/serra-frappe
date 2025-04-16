# Serra Frappe Deployment - Test Environment

This directory contains a test environment and documentation for testing the Serra Frappe deployment process.

## Directory Structure

```
work/test_deployment/
├── README.md                       # This file
├── serra-frappe-deployment/        # Symbolic link to the repository
├── config/                         # Test configuration
│   └── .env                        # Test environment variables
├── build_instructions.md           # Instructions for testing the build.sh script
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

- Changed the image name to `serra/frappe-test` to avoid conflicts with any existing images
- Set a test database password
- Changed the HTTP port to 8090 to avoid conflicts with any existing services

## Documentation

The following documentation is available:

- **build_instructions.md**: Instructions for testing the build.sh script
- **deploy_instructions.md**: Instructions for testing the deploy.sh script
- **update_instructions.md**: Instructions for testing the update.sh script
- **test_plan.md**: A comprehensive test plan for testing the deployment process
- **deployment_documentation.md**: Detailed documentation for the deployment process

## Testing Process

1. Follow the instructions in `build_instructions.md` to test the build.sh script
2. Follow the instructions in `deploy_instructions.md` to test the deploy.sh script
3. Verify that all services start correctly
4. Follow the instructions in `update_instructions.md` to test the update.sh script
5. Document any issues encountered

## Cleanup

After testing, you can clean up the test environment by:

1. Stopping and removing the containers:

   ```bash
   docker compose --project-name serra-frappe-test down
   ```

2. Removing the test images:

   ```bash
   docker rmi serra/frappe-test:v15 serra/frappe-test:v15-YYYY-MM-DD
   ```
