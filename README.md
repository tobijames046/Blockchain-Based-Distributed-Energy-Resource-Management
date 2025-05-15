# Blockchain-Based Distributed Energy Resource Management

A decentralized system for managing distributed energy resources using Clarity smart contracts on the Stacks blockchain.

## Overview

This project implements a comprehensive system for managing distributed energy resources (DERs) on the blockchain. It enables asset verification, production tracking, grid integration, market participation, and automated settlements.

## Smart Contracts

The system consists of five core smart contracts:

1. **Asset Verification Contract** (`asset-verification.clar`)
    - Validates energy generation equipment
    - Registers new assets with metadata (type, capacity, location)
    - Provides verification by authorized administrators
    - Enables ownership transfers

2. **Production Tracking Contract** (`production-tracking.clar`)
    - Records energy generation amounts
    - Verifies production records
    - Calculates total production for assets

3. **Grid Integration Contract** (`grid-integration.clar`)
    - Manages connection to utility network
    - Controls grid connection status
    - Monitors power feed to the grid

4. **Market Participation Contract** (`market-participation.clar`)
    - Enables selling energy to the grid
    - Manages energy offers with pricing
    - Handles offer lifecycle (pending, accepted, rejected, completed)

5. **Settlement Contract** (`settlement.clar`)
    - Handles automated payment processing
    - Processes payments for accepted offers
    - Tracks payment status

## Contract Interactions

The contracts interact with each other to form a complete system:

- Asset Verification ← Production Tracking (verifies assets before recording production)
- Asset Verification ← Grid Integration (verifies assets before grid connection)
- Grid Integration ← Market Participation (ensures assets are connected to grid before creating offers)
- Market Participation ← Settlement (processes payments for accepted offers)

## Features

- **Asset Management**: Register, verify, and transfer ownership of energy-producing assets
- **Production Monitoring**: Track and verify energy production from registered assets
- **Grid Connectivity**: Manage connection status and power feed to the utility grid
- **Energy Market**: Create, accept, reject, and complete energy sale offers
- **Automated Payments**: Process payments for completed energy transactions

## Testing

Tests are implemented using Vitest and can be run with:

```bash
npm test
