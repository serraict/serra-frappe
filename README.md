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

```
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
```
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

Documentation for setup and deployment will be added as we implement the components.

## Future Considerations

- Automated testing strategy
- Backup and restore procedures
- Update and rollback processes
- Monitoring and logging setup
