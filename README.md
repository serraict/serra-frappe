# Serra Frappe Deployment

This repository contains deployment configuration and scripts for Serra's Frappe applications. It leverages the official [frappe_docker](https://github.com/frappe/frappe_docker) infrastructure while adding our custom applications and deployment workflow.

## Design Philosophy

Our deployment approach follows these key principles:

1. **Don't Reinvent the Wheel**
   - Use frappe_docker as a submodule
   - Leverage existing container architecture and best practices
   - Minimize maintenance overhead

2. **Configuration at the Edge**
   - Keep sensitive configuration at client sites
   - No client-specific data in this repository
   - Clear separation between code and configuration

3. **Consistent Deployment Process**
   - Same deployment mechanism for all environments
   - Environment differences only in configuration values
   - Simple, reproducible process

## Repository Structure

```text
serra-frappe-deployment/
├── README.md
├── .gitignore
├── apps.json                    # Our custom apps
├── frappe_docker/              # Submodule
├── env.example                 # Single example template
└── scripts/
    ├── build.sh               # Build custom image
    ├── deploy.sh              # Deployment script
    └── update.sh              # Update script
```

## Client Setup Structure

On any machine (staging or production):

```text
~/serra-frappe/
├── serra-frappe-deployment/    # This repo
└── config/                    # Machine-specific (git-ignored)
    └── .env                   # Environment variables
```

## Design Decisions

1. **Use of frappe_docker Submodule**
   - Avoid duplicating complex container orchestration
   - Stay aligned with Frappe's best practices
   - Easy to incorporate upstream improvements

2. **Single Environment Template**
   - One env.example file serves all use cases
   - Simpler maintenance
   - Clear documentation of all possible configurations

3. **Local Configuration Storage**
   - Each machine owns its configuration
   - Sensitive data never enters version control
   - Clients maintain their own environment settings

4. **Unified Deployment Process**
   - Same scripts work for staging and production
   - Differences only in configuration values
   - Reduces complexity and potential for errors

## Getting Started

### Building the Custom Image

The `build.sh` script creates a custom Docker image that includes Frappe and our custom apps (defined in `apps.json`).

```bash
# Build with default parameters
./scripts/build.sh

# Build with custom parameters
./scripts/build.sh --frappe-branch version-14
./scripts/build.sh --image-name custom/frappe
./scripts/build.sh --image-tag custom-tag

# Show help
./scripts/build.sh --help
```

The script will:
1. Build a Docker image with Frappe and the apps defined in `apps.json`
2. Tag the image with both a version tag (including date) and a main tag
3. Provide instructions for using the image in your deployment

### Testing

A comprehensive test suite is available in the `work/tests/` directory to verify the functionality of the build script:

```bash
# Run all tests
cd work/tests
./run_all_tests.sh

# Run a specific test
cd work/tests
./test_default_params.sh
```

See the [test suite README](work/tests/README.md) for more details.

## Future Considerations

- Backup and restore procedures
- Update and rollback processes
- Monitoring and logging setup
