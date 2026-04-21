<div align="center">

```
███████╗██╗   ██╗███╗   ██╗██████╗       ███╗   ███╗███████╗
██╔════╝██║   ██║████╗  ██║██╔══██╗      ████╗ ████║██╔════╝
█████╗  ██║   ██║██╔██╗ ██║██║  ██║█████╗██╔████╔██║█████╗  
██╔══╝  ██║   ██║██║╚██╗██║██║  ██║╚════╝██║╚██╔╝██║██╔══╝  
██║     ╚██████╔╝██║ ╚████║██████╔╝      ██║ ╚═╝ ██║███████╗
╚═╝      ╚═════╝ ╚═╝  ╚═══╝╚═════╝       ╚═╝     ╚═╝╚══════╝
```
</div>
<div align="center">

**A decentralized crowdfunding smart contract built with Solidity & Foundry.**  
*Trustless. Transparent. Immutable.*

[![Solidity](https://img.shields.io/badge/Solidity-%5E0.8.18-363636?style=for-the-badge&logo=solidity&logoColor=white)](https://soliditylang.org/)
[![Foundry](https://img.shields.io/badge/Foundry-FF4444?style=for-the-badge&logo=ethereum&logoColor=white)](https://book.getfoundry.sh/)
[![Ethereum](https://img.shields.io/badge/Ethereum-3C3C3D?style=for-the-badge&logo=ethereum&logoColor=white)](https://ethereum.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-2CFF05?style=for-the-badge)](https://opensource.org/licenses/MIT)
[![Sepolia](https://img.shields.io/badge/Network-Sepolia_Testnet-626890?style=for-the-badge&logo=ethereum&logoColor=white)](https://sepolia.etherscan.io/)

</div>

---

## 📖 Table of Contents

- [What Is This?](#-what-is-this)
- [How It Works](#-how-it-works)
- [Use Cases](#-use-cases)
- [Workflow Diagram](#-workflow-diagram)
- [Prerequisites](#-prerequisites)
- [Installation & Setup](#-installation--setup)
- [How to Use](#-how-to-use)
- [All Commands Explained](#-all-commands-explained)
- [Environment Variables](#-environment-variables)
- [Project Structure](#-project-structure)
- [Resources](#-resources)
- [Credits](#-credits)

---

## 🧠 What Is This?

**FundMe** is a decentralized crowdfunding smart contract deployed on the Ethereum blockchain. It allows anyone to fund a campaign using ETH, enforcing a **minimum USD contribution** via a real-time **Chainlink Price Feed** oracle.

Only the contract owner (the deployer) can withdraw the accumulated funds. No middlemen. No banks. No trust required — just code.

> *"Most people treat blockchain like a buzzword. This is what it actually looks like in practice."*

---

## ⚙️ How It Works

The contract operates on three simple pillars:

### 1. 💸 Funding
Any wallet can call `fund()` and send ETH to the contract. The contract uses **Chainlink's ETH/USD price feed** to convert the incoming ETH value into USD on-chain, and rejects any contribution that falls below the **minimum threshold of $5 USD**.

Every funder's address and their contribution amount are tracked on-chain.

### 2. 🔐 Ownership
The contract is deployed with the deployer's address set as the `owner`. This is enforced via a custom `onlyOwner` modifier — unauthorized withdrawal attempts revert the transaction instantly.

### 3. 💰 Withdrawal
The owner can call `withdraw()` to drain all collected ETH to their wallet. The contract uses two withdrawal patterns:
- **`withdraw()`** — loops through all funders and resets balances. Straightforward.
- **`cheaperWithdraw()`** — gas-optimized version using a memory array to reduce on-chain storage reads. Costs less in ETH gas fees.

Both functions reset the funders list after withdrawing.

---

## 🎯 Use Cases

| Use Case | Description |
|----------|-------------|
| 🧪 **Web3 Learning** | Perfect starter project to learn Solidity, Foundry, and Chainlink oracles |
| 🏗️ **DeFi Prototype** | Foundation for building crowdfunding dApps — GoFundMe but on-chain |
| 🔬 **Smart Contract Testing** | Demonstrates unit testing, integration testing, and fork testing patterns |
| 🚀 **Deployment Practice** | Learn how to deploy and verify contracts on Sepolia testnet using Foundry scripts |
| 📡 **Oracle Integration** | Real-world example of consuming Chainlink price feeds inside a contract |
| 🔐 **Access Control Patterns** | Study ownership patterns and custom modifiers in Solidity |

---

> *"The blockchain doesn't care who you are. It only cares what you signed."*

---

## 🗺️ Workflow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                        FUND-ME FLOW                         │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
                   ┌─────────────────┐
                   │   forge build   │  ◄── Compiles all .sol files
                   └────────┬────────┘
                            │
                            ▼
                   ┌─────────────────┐
                   │   forge test    │  ◄── Runs unit + integration tests
                   └────────┬────────┘
                            │
               ┌────────────┴────────────┐
               │                         │
               ▼                         ▼
      ┌────────────────┐       ┌──────────────────┐
      │  anvil (local) │       │  Sepolia Testnet  │
      │  Local EVM     │       │  Live testnet     │
      └───────┬────────┘       └────────┬─────────┘
              │                         │
              ▼                         ▼
     ┌─────────────────┐    ┌────────────────────────┐
     │  forge script   │    │  make deploySepolia     │
     │  (local deploy) │    │  --verify --broadcast   │
     └───────┬─────────┘    └──────────┬──────────────┘
             │                         │
             └───────────┬─────────────┘
                         │
                         ▼
              ┌─────────────────────┐
              │  FundMe.sol         │
              │  Contract Deployed  │
              └──────────┬──────────┘
                         │
           ┌─────────────┼─────────────┐
           │             │             │
           ▼             ▼             ▼
  ┌──────────────┐ ┌──────────┐ ┌──────────────┐
  │  fund()      │ │withdraw()│ │cheaperWith-  │
  │              │ │          │ │draw()        │
  │ • Check min  │ │ onlyOwner│ │ gas-optimized│
  │   $5 USD via │ │ modifier │ │ uses memory  │
  │   Chainlink  │ │          │ │ array        │
  │ • Track addr │ │ resets   │ │              │
  │ • Track amt  │ │ funders  │ │              │
  └──────┬───────┘ └────┬─────┘ └──────┬───────┘
         │              │              │
         ▼              ▼              ▼
  ┌────────────────────────────────────────────┐
  │           Chainlink Price Feed             │
  │     ETH/USD  ──►  Conversion check         │
  │     Reject if below $5 minimum             │
  └────────────────────────────────────────────┘
```

---

## 🛠️ Prerequisites

Before you install anything, make sure you have these tools ready:

| Tool | Purpose | Install |
|------|---------|---------|
| **Git** | Clone the repo | [git-scm.com](https://git-scm.com/) |
| **Foundry** | Compile, test & deploy Solidity | See below |
| **An RPC URL** | Connect to Ethereum nodes | [Alchemy](https://alchemy.com) or [Infura](https://infura.io) |
| **A Wallet Private Key** | Sign transactions | MetaMask or any EVM wallet |
| **Etherscan API Key** | Verify contracts on-chain | [etherscan.io](https://etherscan.io/apis) |
| **Sepolia ETH** | Pay for gas fees on testnet | [Sepolia Faucet](https://sepoliafaucet.com/) |

### Install Foundry

```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

Verify the install:

```bash
forge --version
cast --version
anvil --version
```

---

## 📦 Installation & Setup

### 1. Clone the repository

```bash
git clone https://github.com/nxvjot7/fund-me.git
cd fund-me
```

### 2. Install dependencies

```bash
forge install
```

This pulls in submodules (Chainlink contracts, forge-std, etc.) defined in `.gitmodules`.

### 3. Set up environment variables

Create a `.env` file in the root of the project:

```bash
touch .env
```

Add the following:

```env
SEPOLIA_RPC_URL=https://eth-sepolia.g.alchemy.com/v2/YOUR_API_KEY
PRIVATE_KEY=0xYOUR_PRIVATE_KEY_HERE
ETHERSCAN_API_KEY=YOUR_ETHERSCAN_API_KEY
```

> ⚠️ **Security warning:** Never commit your `.env` file. It's already in `.gitignore`, but double-check. Never expose your private key anywhere public.

### 4. Load env variables

```bash
source .env
```

### 5. Build the project

```bash
forge build
```

If everything compiles clean, you're ready to go.

---

> *"You don't need permission to build on a permissionless network."*

---

## 🚀 How to Use

Once the contract is deployed — locally via Anvil or live on Sepolia — here's how you interact with it end to end.

---

### Step 1 — Spin up a local node (for local testing)

```bash
anvil
```

Anvil starts a local Ethereum node at `http://localhost:8545` and hands you **10 pre-funded accounts** with their private keys printed in the terminal. Copy one of those keys to use for local deployment and testing.

---

### Step 2 — Deploy the contract

**Locally (Anvil):**

```bash
forge script script/DeployFundMe.s.sol:DeployFundMe \
  --rpc-url http://localhost:8545 \
  --private-key <ANVIL_PRIVATE_KEY> \
  --broadcast
```

**On Sepolia testnet (single command via Makefile):**

```bash
make deploySepolia
```

After a successful deploy, the **contract address** is printed in the terminal. Save it — you'll need it for every interaction below.

---

### Step 3 — Fund the contract

Send ETH to the contract's `fund()` function. Chainlink checks the live ETH/USD price on-chain and rejects anything worth less than **$5 USD**.

```bash
cast send <CONTRACT_ADDRESS> "fund()" \
  --value 0.1ether \
  --private-key $PRIVATE_KEY \
  --rpc-url $SEPOLIA_RPC_URL
```

You can send any ETH amount — as long as its USD value at the time of the tx is ≥ $5. Sending less will revert the transaction.

---

### Step 4 — Check how much a specific address has funded

```bash
cast call <CONTRACT_ADDRESS> "getAddressToAmountFunded(address)" <FUNDER_ADDRESS> \
  --rpc-url $SEPOLIA_RPC_URL
```

Returns the total contribution (in wei) from the given address.

---

### Step 5 — View the list of funders

```bash
cast call <CONTRACT_ADDRESS> "getFunder(uint256)" 0 \
  --rpc-url $SEPOLIA_RPC_URL
```

Pass an index (0, 1, 2...) to retrieve each funder's address. Increment the index until you've gone through the full list.

---

### Step 6 — Withdraw funds (owner only)

Only the wallet that originally deployed the contract can call this. Any other wallet will get an immediate revert.

**Standard withdraw:**
```bash
cast send <CONTRACT_ADDRESS> "withdraw()" \
  --private-key $PRIVATE_KEY \
  --rpc-url $SEPOLIA_RPC_URL
```

**Gas-optimized withdraw:**
```bash
cast send <CONTRACT_ADDRESS> "cheaperWithdraw()" \
  --private-key $PRIVATE_KEY \
  --rpc-url $SEPOLIA_RPC_URL
```

`cheaperWithdraw()` does the exact same job but reads the funders list into memory first instead of hitting storage on every loop iteration. Lower gas cost when there are many funders.

---

### Step 7 — Verify the contract balance is zero after withdrawal

```bash
cast balance <CONTRACT_ADDRESS> --rpc-url $SEPOLIA_RPC_URL
```

After a clean withdrawal this should return `0`.

---

### Step 8 — Convert units

```bash
# Wei to Ether
cast --to-unit 100000000000000000 ether

# Ether to Wei
cast --to-unit 0.1ether wei
```

Handy for sanity-checking amounts before you send any transaction.

---

### Step 9 — Check the contract owner

```bash
cast call <CONTRACT_ADDRESS> "getOwner()" --rpc-url $SEPOLIA_RPC_URL
```

Returns the deployer address — the only one with withdraw rights.

---

### Step 10 — Inspect on Etherscan

After any `cast send` on Sepolia, copy the tx hash from terminal output and check it at:

```
https://sepolia.etherscan.io/tx/<TX_HASH>
```

If you deployed with `--verify`, the full contract source is readable at:

```
https://sepolia.etherscan.io/address/<CONTRACT_ADDRESS>#code
```

---

> *"On-chain means forever. There's no undo button, no support ticket, no refund policy. Read before you sign."*

---

## 🧰 All Commands Explained

### 🔨 Build

```bash
forge build
```
Compiles all Solidity source files in `src/`. Outputs artifacts (ABI, bytecode) to `out/`. Always run this first — catches compilation errors before anything else.

---

### 🧪 Test

```bash
forge test
```
Runs all test functions in `test/` against a local in-memory EVM. Fast, free, no testnet needed.

```bash
forge test -vvvv
```
Maximum verbosity. Full stack traces, decoded calls, and per-test gas usage. Use this when a test fails and you need to know exactly why.

```bash
forge test --fork-url $SEPOLIA_RPC_URL
```
Forks the live Sepolia chain and runs tests against its real state. Needed for integration tests that require actual Chainlink price feed data instead of mocks.

---

### 📐 Format

```bash
forge fmt
```
Auto-formats all `.sol` files to Foundry's style guide. Think of it as `prettier` for Solidity. Run before every commit.

---

### ⛽ Gas Snapshot

```bash
forge snapshot
```
Runs all tests and writes the gas cost of each into `.gas-snapshot`. Commit this file — if gas increases after a change, the diff will catch it immediately. Essential when you're trying to optimize.

---

### ⛓️ Local Node

```bash
anvil
```
Launches a local Ethereum node at `http://localhost:8545` with 10 pre-funded accounts. Use it to test deployments and interactions without touching real or testnet ETH.

---

### 🔧 Cast

```bash
cast send   # Write — send transactions, call state-changing functions
cast call   # Read  — query contract state without spending gas
cast balance # Check ETH balance of any address
cast --to-unit # Convert between wei, gwei, and ether
```

`cast` is the CLI for everything post-deployment. Full usage covered in the [How to Use](#-how-to-use) section above with real contract examples.

---

### 🚀 Deploy (Sepolia)

```bash
make deploySepolia
```
Single command. Deploys, broadcasts, and verifies on Sepolia. Reads `SEPOLIA_RPC_URL`, `PRIVATE_KEY`, and `ETHERSCAN_API_KEY` straight from your `.env`.

---

### ❓ Need More?

These tools go way deeper than what's covered here. For anything beyond the basics:

```bash
forge --help
anvil --help
cast --help
```

Or go straight to the source → **[book.getfoundry.sh](https://book.getfoundry.sh/)**

---

## 🔑 Environment Variables

| Variable | Description |
|----------|-------------|
| `SEPOLIA_RPC_URL` | Your Alchemy/Infura RPC endpoint for Sepolia testnet |
| `PRIVATE_KEY` | Private key of the deployer wallet (with `0x` prefix) |
| `ETHERSCAN_API_KEY` | API key for contract verification on Etherscan |

---

## 🗂️ Project Structure

```
fund-me/
├── .github/
│   └── workflows/         # CI/CD pipelines (GitHub Actions)
├── lib/                   # Submodule dependencies (Chainlink, forge-std)
├── script/
│   └── DeployFundMe.s.sol # Deployment script
├── src/
│   └── FundMe.sol         # Main contract
│   └── PriceConverter.sol # Chainlink price conversion library
├── test/
│   ├── unit/              # Unit tests
│   └── integration/       # Integration / fork tests
├── .env                   # Local secrets (never commit this)
├── .gas-snapshot          # Gas usage tracking
├── foundry.toml           # Foundry configuration
├── Makefile               # Shortcut commands
└── README.md              # You are here
```

---

## 📚 Resources

- [Foundry Book](https://book.getfoundry.sh/) — official Foundry documentation
- [Chainlink Docs](https://docs.chain.link/) — price feeds and oracle network
- [Solidity Docs](https://docs.soliditylang.org/) — Solidity language reference
- [Sepolia Faucet](https://sepoliafaucet.com/) — free Sepolia ETH for testing
- [Etherscan Sepolia](https://sepolia.etherscan.io/) — explore testnet transactions

---

## 🏴 Credits

<div align="center">

```
╔══════════════════════════════════════════════╗
║                                              ║
║   Built & maintained by                      ║
║                                              ║
║      NAVJOT SINGH                            ║
║          AKA- nxvjot7 / Ghost                ║
║                                              ║
║   "TRANSPARENT,                              ║
║           TRUSTLESS,                         ║
║                   IMMUTABLE,                 ║
║                            SECURE.           ║
║                                              ║
║          < PROJECT - FUNDME  >               ║
║                                              ║
╚══════════════════════════════════════════════╝
 ```
</div>

<div align="center">
║  SPECIAL THANKS TO <a href="https://github.com/patrickalphac">@patrickalphac</a>  ║

[![GitHub](https://img.shields.io/badge/GitHub-nxvjot7-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/nxvjot7)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-nxvjot7-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/nxvjot7)
[![Medium](https://img.shields.io/badge/Medium-nxvjot7-12100E?style=for-the-badge&logo=medium&logoColor=white)](https://medium.com/@nxvjot7)
[![YouTube](https://img.shields.io/badge/YouTube-nxvjot7-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://youtube.com/@nxvjot7)

---

![visitor badge](https://komarev.com/ghpvc/?username=nxvjot7&color=2CFF05&style=for-the-badge&label=VISITORS)

<sub>Built with ⚡ using Solidity + Foundry on Ethereum</sub>

---

<b><i>~ Ghost was here ;</b></i>

</div>
