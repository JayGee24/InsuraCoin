pragma solidity ^0.4.24;

import "./Tokens/ERC721.sol";
import "./PropertyRegistry.sol";
import "./CouponRegistry.sol";


/**
* @title This contract inherits from ERC721 and implements and
* contains functions for the insurance company.
* Handles registring insurar, creating coupons for clients
* and interacting with both the Arbitration Contract, 
* CouponRegistry Contract, and PropertyRegistry.
**/

contract CompanyContract is ERC721 {

	PropertyRegistry public _PropertyRegistryContract;
	CouponRegistry 	 public _CouponRegistryContract;

	event InsurarRegistered(
    	address owner
  	);
  	event ClientReimpursed(
    	address client, uint256 _couponId
  	);

	struct Insurar {
		address insurarAddress;
		string	name;
	}

	Insurar[] internal_insurar;
	mapping(address => bool) internal_registered;

  /**
  * @dev Public function to register a new insurar
  * @param insurar name represents insurar' name
  */

  function registerInsurar(string name) public {
  	internal_insurar[msg.sender, name];
  	internal_registered[msg.sender] = true;

    emit InsurarRegistered(msg.sender);
  }

 /**
  * @dev External function called by client 
  * to request a new insurace.
  * @param client address represents client that owns property
  * @param _tokenId uint256 represents the property ID 
  * to be insured.
  */
  function requestInsurance(address client, uint256 _tokenId) external {
  	// verify that client owns property
  	if (verifyOwnership(client, _tokenId)){
  		
  		//Create a new coupon
  		// To Do: metadata
  		CouponID = _CouponRegistryContract.createInsuranceCoupon("", 356,
  			 client, _tokenId, _propertyRegistryAddress);

  		_CouponRegistryContract.transferOwnershipToArbitrationContract(CouponID);
  	}
  }
  /**
  * @dev private internal function to verify client's ownership
  * @param client address represents client that owns property
  * @param _tokenId uint256 represents the property ID
  */
  function verifyOwnership(address client, uint256 _tokenId) private returns (bool) {

  	return _PropertyRegistryContract.verifyPropertyOwnership(client, _tokenId);

  }

/**
  * @dev Public function to reimpurse a client in case 
  * of accidents 
  * @param client address represents client that owns property
  * @param _couponId uint256 represents the coupon ID originally
  * issued by the Insurar
  */
  function reimburse(address client, uint256 _couponId){
  	require(msg.sender == ownerOf(_couponId));

  	if (_CouponRegistryContract.isCouponValid(_couponId)){

  		Insurar = _CouponRegistryContract.getCouponInsurar(_couponId);
  		transferFrom(Insurar, client, _tokenId);

  		emit ClientReimpursed(client, _couponId);
  	}
  }

  /* Payable function to receive funds from client
  * through arbitration contract
  */
  function() public payable {}

}
