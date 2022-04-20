//SPDX-License-Identifier: MIT

//    ___________   __          __   ___________
//   |___________| |   \      /   | |___________|
//       |  |      |    \    /    |     |  |    
//       |  |      |     \  /     |     |  |    
//       |__|      |__|   \/   |__|     |__|    
//

pragma solidity ^0.8.0;

/// @author tanujd.eth tmtlab.eth
/// @title SimpleNFT ERC721 Smart Contract
/// @notice This contract can be used as the base of your NFT project
/// @dev Test all functionality before deploying

// Imports
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @dev Counters help track the token ID, and allows us to avoide the ERC721Enumerable contract base
import "@openzeppelin/contracts/utils/Counters.sol";

// Contract
contract SimpleNFT is ERC721, Ownable {
    using Strings for uint256;
    using Counters for Counters.Counter;

    // Variables
    // Group variables based on type to save gas when deploying

    /// @notice defines the contract states
    /// @dev 0 Paused, contract is paused, nobody can mint.
    /// 1 Whitelist is when only those whitelisted can mint.
    /// 2 Sale, the mint is open to everyone.
    enum Status {
        Paused,
        Whitelist,
        Sale
    }
    Status public status;
    uint8 public maxMintLimit = 5; // Limit the number of items mintable in one transaction
    uint8 public whitelistMintLimit = 2;
    uint16 public maxTokens = 1000; // Total number of NFTs
    uint256 public salePrice = 10000000000000000; //value in Wei = 0.01 ETH
    uint256 public whitelistPrice = 10000000000000000; //value in Wei = 0.01 ETH
    string public baseUri;
    
    // Track the whitelist addresses and how many they minted
    mapping(address => bool) whitelist;
    mapping(address => uint256) addressMintedCount;

    /// @dev tracking the tokenId
    Counters.Counter private tokenIdCounter;

    // TODO: Reveal

    // Contract initiation - constructor
    constructor() ERC721("SimpleNFT", "SNFT") {
    //Initialise the smart contract in a paused state
        status = Status.Paused;
        tokenIdCounter.increment();
        baseUri = "ipfs://YOURURI";
    }

    // Contract Functions - Contract functionality

    /// @notice Update the contract state
    function setState(Status _state) public onlyOwner {
        status = _state;
    }

    /// @notice Set the BaseUri for the nft metadata
    /// @dev the BaseUri is the IPFS base that stores the metadata and images
    function setBaseUri(string memory _baseUri) public onlyOwner {
        baseUri = _baseUri;
    }

    // TODO: Reveal

    /// @notice Update the public mint price
    function setSalePrice(uint256 _cost) public onlyOwner {
        salePrice = _cost;
    }

    /// @notice Update the whitelist mint price
    function setwhitelistPrice(uint256 _cost) public onlyOwner {
        whitelistPrice = _cost;
    }

    /// @notice Update the whitelist mint limit
    function setWhiteListMintLimit(uint8 _mintLimit) public onlyOwner {
        whitelistMintLimit = _mintLimit;
    }

    /// @notice Adds a list of addresses to whitelist
    function addToWhitelist(address[] calldata _addresses) public onlyOwner {
        for (uint256 i = 0; i < _addresses.length; i++) {
            whitelist[_addresses[i]] = true;
        }
    }

    /// @notice Remove a list of addresses from whitelist
    /// @dev Explicitely removes a user from the whitelist
    function removeFromWhitelist(address[] calldata _addresses) public onlyOwner {
        for (uint256 i = 0; i < _addresses.length; i++) {
            whitelist[_addresses[i]] = false;
        }
    }

    // Mint
    /// @notice WhiteList Mint, checks if the whitelist and mint parameters are met
    /// @dev 1. Contract should be on Whitelist state
    ///      2. User should be whitelisted
    ///      3. Required mint should be less that what is mintable by user
    ///      4. The mint quantity is more than 0
    ///      5. There is still supply
    ///      6. Enough eth was sent to the contract
    function whiteListMint(uint256 _mintAmount) public payable {
        address minterAddress = msg.sender;
        uint256 mintTokenId = tokenIdCounter.current();

        // Check if the amount sent is correct
        // Check if the state is whitelist
        require(status == Status.Whitelist, "The contract is not currently Minting for WhiteList.");
        require(whitelist[minterAddress], "This wallet is not whitelisted.");
        require(addressMintedCount[minterAddress] + _mintAmount <= whitelistMintLimit, "Exceeded whitelist mint limit.");
        require(_mintAmount > 0, "Must Mint atleast 1.");
        require(_mintAmount <= maxTokens - mintTokenId, "Exceeded the maximum available tokens.");
        require(msg.value >= _mintAmount * whitelistPrice,"Not enough funds to mint.");

        mint(minterAddress, _mintAmount);

        delete minterAddress;
        delete mintTokenId;
    }

    /// @notice Regular Mint, checks if the public mint parameters are met
    /// @dev 1. Contract should be on PublicSale state
    ///      2. Required mint should be less that what is mintable by user
    ///      3. The mint quantity is more than 0
    ///      4. There is still supply
    ///      5. Enough eth was sent to the contract
    ///      The checks are designed to be most gas efficient for the minter if they don't meet a criteria
    function saleMint(uint256 _mintAmount) public payable {
        address minterAddress = msg.sender;
        uint256 mintTokenId = tokenIdCounter.current();

        // Check if the contract state is on sale
        require(status == Status.Sale, "The contract is not currently in Public Mint.");
        require(_mintAmount <= maxMintLimit, "Exceeded the maximum mintable limit.");
        require(_mintAmount > 0, "Must Mint atleast 1.");
        require(_mintAmount <= maxTokens - mintTokenId, "Exceeded the maximum available tokens.");
        require(msg.value >= _mintAmount * salePrice, "Not enough funds to mint.");

        mint(minterAddress, _mintAmount);

        delete minterAddress;
        delete mintTokenId;
    }

    /// @notice Function that mints the NFT
    /// @dev this is a dumb function that simply mints a number of NFTs for a given address.
    function mint(address _address, uint256 _qty) internal {
        for (uint256 i = 0; i < _qty; i++) {
            _mint(_address, tokenIdCounter.current());
            tokenIdCounter.increment();
        }
    }

    /// @notice Withdrawing all funds from the contract
    /// @dev Withdraw all balance from the contract. Can also use payment splitter from OpenZepplin, it is OOS for the SimpleNFT.
    function withdraw() public payable onlyOwner {

        // ###  START Optional  ###
        // The section is optional, and can be removed if you want.
        // Keeping this in supports both creators of this contract with 5% of the miniting value.
        // This does not include any share from the secondary market.
        // Pay tanujd.eth 2% of the mint value.
        (bool tj, ) = payable(0x9A29f401B52A47c5113E03bC30725f22327249bE).call{value: address(this).balance * 2 / 100}("");
        require(tj);
        // Pay tmtlabs 3% of the mint value.
        (bool tmt, ) = payable(0x9c3213422b5DE9223B1cdC764e3cc17249A7c033).call{value: address(this).balance * 3 / 100}("");
        require(tmt);
        // ###  END Optional    ###

        // Pays contract owner remaining balance of the contract.
        (bool success, ) = payable(owner()).call{value: address(this).balance}("");
        require(success);
    }

}
