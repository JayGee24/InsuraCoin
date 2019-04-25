pragma solidity ^0.4.24;

import "./Tokens/ERC721.sol";
import "./ArbitrationContract.sol";

/**
* @title This contract inherits from ERC721 and implements and
* contains the list of insurance coupons created by insurance
* company
* An insurance company can also use this contract to mint coupons
* Provides public functions for manipulating these coupons.
**/

contract InsuranceCouponRegistry is ERC721 {
  string public constant contractName = 'InsuranceCouponRegistry'; // For testing.

  event CouponCreated(
    address indexed owner,
    uint256 indexed couponId
  );

  event CouponDestroyed(
    address indexed owner,
    uint256 indexed couponId
  );

  //Coupon struct to hold info about coupon
  struct Coupon {
    uint256 couponId;
    string  name;
    address owner;
    address company;
    uint256 expirationDate;
    uint256 propertyId;
    uint256 propertyRegistryAddress;
    bool    invalidated;
    string  metadata;
  }

  //ArbitrationContract address
  address public _ab

  //Array of all coupons
  Coupon[] internal _coupons;

  constructor(
    address _arbitrationContract,
  )
  public {
    _ab = _arbitrationContract;
  }


  modifier onlyInsuranceCompany() {
    require(_ab.isRegisteredInsurer(msg.sender) == true, "msg.sender must be an insurance company.");*/
    _;
  }

  modifier onlyArbitrationContract() {
    require(msg.sender == _ab, "msg.sender is an arbitration contract");
    _;
  }



  /**
  * @dev Creates a new coupon
  */
  function createInsuranceCoupon(string _metadata,
    uint256 _daysAfter, address _couponOwner, uint256 _propertyId,
    uint256 _propertyRegistryAddress
  ) public onlyInsuranceCompany returns (uint256){
    uint256 newCouponId  = _coupons.length;
    Coupon memory newCoupon;
    newCoupon.owner   = _couponOwner;
    newCoupon.company = msg.sender;
    newCoupon.expirationDate = now + _daysAfter * 1 days;
    newCoupon.couponID   = newCouponId;
    newCoupon.metadata   = metadata;
    newCoupon.propertyId = _propertyId;
    newCoupon.invalidated = false;
    newCoupon.propertyRegistryAddress = _propertyRegistryAddress;

    _coupons.push(newCoupon);

    _mint(msg.sender, newCouponId);
  
    emit CouponCreated(msg.sender,newCouponId);
     
    return newCouponId;
  }
  /**
  * @dev Public function called by Insurar when reimpursing
  * client
  * @param _couponId uint256
  */
  function getCouponInsurar(uint256 _couponId) public onlyInsuranceCompany(){
    Coupon coupon = _coupons[_couponId];
    return coupon.company;
  }

  /**
  * @dev Transfers coupon ownership from insurer to ArbitrationContract
  * @param _couponId uint256
  **/
  function transferOwnershipToArbitrationContract(uint256 _couponId)
   public onlyInsuranceCompany(msg.sender){
    require( ownerOf(_couponId) == msg.sender);
    _coupons[couponId].owner = _ab;
    transferFrom(msg.sender,_ab,couponId);
  }

  /**
  * @dev Transfers coupon ownership from ArbitrationContract to client
  * @param client address
  * @param _couponId uint256
  * @return
  **/
  function transferOwnershipToClient(address client,
     uint256 _couponId) public onlyArbitrationContract{
    require(ownerOf(_couponId) == _ab);
    _coupons[couponId].owner = client;
    transferFrom(_ab,client,couponId);
  }

  /**
  * @dev Destroy Coupon
  * @param _couponId uint256
  **/
  function burnCoupon(uint256 _couponId) public{
    address couponOwner = ownerOf(_couponId);
    require(msg.sender == couponOwner);
    _burn(couponOwner,_couponId);
  }

  /**
  * @dev Check if coupon is valid - still permitted for use or unexpired
  * @param _couponId uint256
  * @return isValid bool
  **/
  function isCouponValid(uint256 _couponId) public
  returns(bool){
    if (!exists(_couponId)){
      return false;
    }
    Coupon coupon = _coupons[_couponId];
    if (coupon.invalidated) {
      return false
    }
    if (now > coupon.expirationDate){
      _coupons[_couponId].invalidated = true;
      return false;
    }
    return true;
  }

  /**
  * @dev Event is triggered if property token is registered
  * @param _by address of the registrar
  * @param _tokenId uint256 represents a specific propety token
  */
  event CouponCreated(address _by, uint256 _couponId);

}
