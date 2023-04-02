# Backend - Smart Contracts con Hardhat Environment

Construimos el backend utilizando smart contracts escritos en Solidity en el ambiente de desarrollo "Hardhat". El proyecto se compone por dos smart contracts: ```BookNft.sol``` y ```Space.sol```.

El autor interactúa con ellos de la siguiente manera:
1. Mintea un bookNft cargando los datos del libro en el tokenURI.
2. Lista el bookNft en el Space aclarando la cantidad de unidades (horas, ejemplares) quiere que le financien y el precio por unidad (ETH).
3. Retira los fondos asociados al bookNft que listó.

El lector interactúa con ellos de la siguiente manera:
1. Financia a una cierta cantidad de unidades (horas, ejemplares) asociadas al bookNft que desea financiar. ACLARACIÓN: el bookNft es usado para referenciar la data del libro on-chain únicamente, no funciona como token transaccionable.
2. Likea un libro listado en el space.

### Deployment en Sepolia Testnet

```BookNft.sol``` : https://sepolia.etherscan.io/address/0xF34F226BFFCadF0CB92f59514eDe055ea97caE3C

```Space.sol```   : https://sepolia.etherscan.io/address/0x51FF5920E31BD0e2944d4DBC18DC413d779164B0

## Librerías y recursos :books:

- [Hardhat](https://github.com/nomiclabs/hardhat) : deploy - test - local network
- [Ethers](https://github.com/ethers-io/ethers.js/) 
- [OpenZeppelin Contracts](https://github.com/OpenZeppelin/openzeppelin-contracts) : ER721URIStorage.sol (BookNft) - nonReentrant (Space)
- [Chai](https://www.npmjs.com/package/chai) : test

## Uso

### Pre Requisitos
```sh
cd hardhat
```

Antes de correr cualquier comando, asegurate de instalar las dependencias:

```sh
yarn install
```
y configurá tu archivo ```.env``` usando como ejemplo: ```.env.example```

### Compilación :gear:

Compila el smart contract con hardhat:

```sh
yarn hardhat compile
```

### Test :memo:

Corré los tests:

```sh
yarn hardhat test
```

### Hardhat network :link:

Si querés realizar un deploy de los contratos localmente, podés usar la red local de hardhat corriendo:

```sh
yarn hardhat node
```

### Deploy del contrato a la red :airplane: (requiere Private KEY y Network RPC URL)

```
yarn hardhat deploy --network sepolia
```
### Scripts :computer:
```sh
yarn hardhat run scripts/mint-and-list.js --network sepolia
```
```sh
yarn hardhat run scripts/fund-book.js --network sepolia
```
ó ```--network localhost``` para hardhat network

## License

MIT
