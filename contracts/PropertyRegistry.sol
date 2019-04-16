pragma solidity ^0.4.24;

import "./Tokens/ERC721.sol";

/**
 * This contract inherits from ERC721 and implements and
 * contains the list of property-items registered by clients.
 */

contract PropertyRegistry is ERC721 {
  string public constant contractName = 'PropertyRegistry'; // For testing.

  event PropertyRegistered(
    address indexed owner,
    uint256 indexed tokenId
  );
  /**
  *
  **/

  function PropertyRegistry(string _name, string _symbol)
    public ERC721Token(_name, _symbol) {}

  function registerProperty(uint256 _tokenId, string _uri) public {
    _mint(msg.sender, _tokenId);
    addPropertyMetadata(_tokenId, _uri);
    //TODO: Emit Property registered event
    emit PropertyRegistered(msg.sender,_tokenId);
  }

  function addPropertyMetadata(uint256 _tokenId, string _uri) public returns(bool){
    _setTokenURI(_tokenId, _uri);
    return true;
  }

}
