# AssetTracker

A decentralized system for tracking digital asset ownership on the Stacks blockchain.

## Overview

AssetTracker provides a secure and transparent way to register, transfer, and manage ownership of digital assets using blockchain technology. By utilizing cryptographic hashes as unique identifiers, the system ensures that assets cannot be duplicated or falsely claimed.

## Features

- **Claim Assets**: Register new assets with unique cryptographic hashes
- **Verify Ownership**: Check who currently owns a specific asset
- **Transfer Assets**: Securely transfer asset ownership to other entities
- **Release Assets**: Remove assets from the registry when no longer needed
- **Asset Counting**: Track how many assets each entity owns

## Functions

The contract exposes the following public functions:

- `claim-asset`: Register a new asset with your account
- `is-asset-registered`: Check if an asset is already in the registry
- `get-asset-holder`: Get the current owner of an asset
- `transfer-asset`: Transfer asset ownership to another entity
- `release-asset`: Remove an asset from the registry
- `get-entity-asset-count`: Get the number of assets owned by an entity
- `entity-has-assets`: Check if an entity owns any assets

## Error Codes

- `u100`: Asset already claimed
- `u101`: Asset not found in registry
- `u102`: Invalid asset hash
- `u103`: Not the owner of the asset

## Development

This project is built on Clarity, the smart contract language for the Stacks blockchain. To get started with development:

1. Install the [Clarinet](https://github.com/hirosystems/clarinet) development environment
2. Clone this repository
3. Run `clarinet console` to interact with the contract
