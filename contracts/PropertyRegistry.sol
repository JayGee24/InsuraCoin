pragma solidity ^0.4.24;

import "./Tokens/ERC721Token.sol";

/**
* @title This contract inherits from ERC721 and implements and
* contains the list of property-items registered by clients.
* Acts as a contract that mints, stores, transfers
* and burns property tokens.
* Provides functions for manipulating property tokens.
**/

contract PropertyRegistry is ERC721Token {
  string public constant contractName = 'PropertyRegistry'; // For testing.

  constructor(string _name, string _symbol)
    public ERC721Token(_name, _symbol) {}

  /**
  * @dev Public function to register a new property token
  * @dev Call the ERC721Token minter
  * @param _tokenId uint256 represents a specific deed
  * @param _uri string containing metadata/uri
  */
  function registerProperty(uint256 _tokenId, string _uri) public {
    _mint(msg.sender, _tokenId);
    addPropertyMetadata(_tokenId, _uri);
    emit PropertyRegistered(msg.sender,_tokenId);
  }

  /**
  * @dev Public function to add metadata to a property token
  * @param _tokenId represents a specific property token
  * @param _uri text which describes the characteristics of a given property
  *        token
  * @return whether the property token metadata was added to the registry
  */
  function addPropertyMetadata(uint256 _tokenId, string _uri) public
  returns(bool){
    _setTokenURI(_tokenId, _uri);
    return true;
  }

  /**
  * @dev Public function to verify that property belongs to a client
  * @param client uint256 client in question
  * @param _token uint256  propery being checked against client.
  * @return: bool for whether client owns token
  **/
  function verifyPropertyOwnership(uint256 client, uint256 _tokenId) public
  returns(bool){
    uint256 tokenIndex = ownedTokensIndex[_tokenId];
    uint256 trackedClientToken =  ownedTokens[client][tokenIndex]
    return trackedClientToken == _tokenId;
  }

  /**
  * @dev Event is triggered if property token is registered
  * @param _by address of the registrar
  * @param _tokenId uint256 represents a specific propety token
  */
  event ProperyRegistered(address _by, uint256 _tokenId);

}
