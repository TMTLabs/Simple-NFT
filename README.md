# Simple NFT

A Simple NFT project.

This project is a simple ERC721 NFT collection.

It will be built over time and modified as and when required.

This **readme** will document all the details about the project.

The [ChangeLog](CHANGELOG.md) will track all the updates and major changed made to the project.

<br><br>

## Functionality

> More info coming soon...

### How to use

For now the easiest way to use this smart contract is to copy the code into Remix and then deploy it to the JVM there.

This gives you test accounts with test eth to do a "local" santity testing.

> More info coming soon...

### Structure

At this stage the project will have a very flat structure. As the new components and features get added this structure will get more detailed/nested.

Here is the current structure

```text
root            // Project base
└───contracts   // Smart Contract
└───dapp        // Website Front End
    │   img
```

### Technical

#### Contract Variables

| Name                | Type     | Availability  |
|-------------------- |--------- |-------------- |
| Status              | enum     | na            |
| status              | Status   | public        |
| revealed            | bool     | public        |
| whitelistPrice      | uint256  | public        |
| salePrice           | uint256  | public        |
| whitelistMintLimit  | uint8    | public        |
| maxMintLimit        | uint8    | public        |
| maxTokens           | uint16   | public        |
| baseUri             | string   | public        |
| notRevealedUri      | string   | public        |
| whitelist           | mapping  | public        |
| addressMintedCount  | mapping  | public        |
| tokenIdCounter      | counter  | private       |

#### Contract Functions

The smart contract functions.

- constructor
- setState
- setBaseUri
- setNotRevealedUri
- reveal
- tokenURI
- setWLPrice
- setSalePrice
- setWhiteListMintLimit
- addToWhitelist: Adding wallet to whitelist
- removeFromWhitelist: To ensure bad actors are removed.
- whiteListMint
- saleMint
- mint
- withdraw

### Tools

Tools used in the world of NFTs. This list includes tools used for development and testing, along with general tools needed to own, or interact with NFTs and the communities.

#### IDE and Extentions

- [Remix](https://remix.ethereum.org/) Web IDE
- [VS Code](https://code.visualstudio.com/)
  - [Solidity](https://marketplace.visualstudio.com/items?itemName=JuanBlanco.solidity)

#### Browsers

- [Chrome](https://www.google.com/chrome/)
- [Opera](https://www.opera.com/)

#### Wallets

- [Metamask](https://metamask.io/download/)

#### NFT Community Tools

- [Twitter](https://twitter.com/)
- [Discord](https://discord.com/)
- [Telegram](https://telegram.org/)

<br><br>

## RoadMap

The object of the SimpleNFT project is to be the basis for running your own NFT. This should be all encompassing. Which means it should include: the Contract, the DApp, Deploying and Testing.

This roadmap will keep growing and evolving as the NFTs and the industry as a whole keeps evolving.

Why? Let's take for example the need for Gas considerations, depending on the implementation of ETH 2.0, gas considerations might not be such a major factor. Going from pontentially saying $s to savings ¢s. So maybe we end up simplifying the contract to be more readable rather than gas efficient. Time will tell.

### 1.0

1. Build the ERC721 Smart Contract
1. Integrate HardHat
1. Contract testing
1. Contract deploying
1. Integrate ethers.js / web3.js
1. Build Minting DApp
1. Deploy Minting Dapp

More coming soon...

### Decisions

Any major decisions made will be documented here, in order to explain the reasoning.

<br><br>

## Other Information

### Resources & Info

There are many great resources to help with Smart Contract developement and deploying. We will add documents as and when required.

#### Docs

- [Solidity](https://docs.soliditylang.org/en/latest)
- [Remix IDE](https://remix-ide.readthedocs.io/en/latest/)

#### Videos

> More info coming soon...

#### Terminology

Terms used in the readme and changelog.

- **Contract** (or Smart Contract): The smart contract. The two terms will be used interchangably, unless specified.

<br>

### Creators

This project is created by TJ and TMTLabs.

#### Connect

Connect with the creators on twitter:

- TJ: [@tanujdamani](https://twitter.com/tanujdamani)
- TMTLabs: [@tmtlabs](https://twitter.com/tmtlabs)

### License

This code is provided under MIT license.

This code is provided as is. We do not provide any support or warranty. Use this code at your own risk, we are not liable for any damage or loss cause from the usage of this code.

Please refer to the [license](LICENSE.txt) for more details.
