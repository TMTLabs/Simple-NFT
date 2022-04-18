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
  uint16 public maxTokens = 1000; // Total number of NFTs
  uint256 public salePrice = 10000000000000000; //value in Wei = 0.01 ETH
  string public baseUri;

  /// @dev tracking the tokenId
  Counters.Counter private tokenIdCounter;

  // TODO: WhiteList, Reveal

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

  // TODO: WhiteList
  // TODO: Reveal
  // TODO: SetBaseUri

  /// @notice Update the mint price
  function setSalePrice(uint256 _cost) public onlyOwner {
      salePrice = _cost;
  }

  // Mint

  /// @notice Regular Mint, checks if the parameters are met.
  /// @dev 1. Contract should be on PublicSale state.
  ///      2. Required mint should be less that what is mintable by user.
  ///      3. The mint quantity is more than 0.
  ///      4. There is still supply.
  ///      5. Enough eth was sent to the contract
  ///      The checks are designed to be most gas efficient for the minter if they don't meet a criteria.
  function saleMint(uint256 _mintAmount) public payable {
      address minterAddress = msg.sender;
      uint256 mintTokenId = tokenIdCounter.current();

      // Check if the state is on sale
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


  // TODO: Withdraw

}
