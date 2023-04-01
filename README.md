# Backend - Smart Contracts using Hardhat Environment

- [Hardhat](https://github.com/nomiclabs/hardhat): compile and run the smart contracts on a local development network
- [Ethers](https://github.com/ethers-io/ethers.js/): renowned Ethereum library and wallet implementation

## Usage

### Pre Requisites
```sh
cd hardhat
```

Before running any command, make sure to install dependencies:

```sh
yarn install
```
and configure your ```.env``` file using the ```.env.example```

### Compile

Compile the smart contracts with Hardhat:

```sh
yarn hardhat compile
```

### Test

Run the tests:

```sh
yarn hardhat test
```

### Hardhat network

If you want to deploy the contracts locally, you can use hardhat network by running:

```sh
yarn hardhat node
```
switch to another terminal and run the scripts:

```sh
yarn hardhat run scripts/mint-and-list.js --network localhost
```
```sh
yarn hardhat run scripts/fund-book.js --network localhost
```

### Deploy contract to network (requires Mnemonic and Netowork RPC URL)

```
yarn hardhat deploy --network sepolia
```
run scripts:
```sh
yarn hardhat run scripts/mint-and-list.js --network sepolia
```
```sh
yarn hardhat run scripts/fund-book.js --network sepolia
```


## License

MIT
