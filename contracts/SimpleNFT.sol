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

// Contract
contract SimpleNFT is ERC721, Ownable {

  // Variables
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

  // Contract initiation - constructor
  constructor() ERC721("SimpleNFT", "SNFT") {
    //Initialise the smart contract in a paused state
    status = Status.Paused;
  }

  // Contract Functions - Contract functionality

  // State
  // WhiteList
  // Mint
  // Withdraw

}
