pragma solidity ^0.4.24;

import "./Support/Agreement.sol";
import "./InsuranceCouponRegistry.sol";
//import "./ClientContract.sol"
//import "./CompanyContract.sol"

/**
* @title This contract serves as the arbitrator
* to manage and settle each insurance transaction between
* insurance companies and clients for
**/

contract ArbitrationContract {

  string public constant contractName = "ArbitrationContract";

  event FormalAgreementCreated(
      address indexed client;
      address indexed company;
  );
  event ExchangeSuccessful(
      address indexed client;
      address indexed company;
  );
  event ExchangeAborted(
      address indexed client;
      address indexed company;
  );

  //Insurance Coupon Registry Instance Address
  address public _icr;

  //List of Agreements Received
  Agreement[] internal _agreements;

  //List of registered insurance companies
  mapping(address => bool) registedInsurers;


  constuctor (
    address insuranceCouponRegistry,
  ) {
    _icr = insuranceCouponRegistry;
  }

  //Register with ArbitrationContract?
  modifier onlyClient(){
    //require(_clientAPI.isRegisteredClient(msg.sender),
    //"caller needs to be a registered client");
    _;
  }

  //Register with ArbitrationContract?
  modifier onlyInsuranceCompany(){
    //require(_companyAPI.isRegisteredCompany(msg.sender));
    //"caller needs to be a registered company");
    _;
  }

  /**
  * @dev Receive unidentified agreement and create an identified agreement
  * between a client and a company
  * @param newAgreement Agreement - agreement received from insurer to
  * arbitrate
  * @return newAgreementId uint256 - informs insurer of actual agreement id
  **/
  function receiveAndCreateFormalAgreement(Agreement newAgreement)
   onlyInsuranceCompany return(uint256) {
    address clientAddr     = newAgreement.clientAddr;
    address companyAddr    = newAgreement.companyAddr;
    uint256 newAgreementId = _agreements.length; //monotonically increasing index
    newAgreement.id = newAgreementId;
    _agreements.push[newAgreement];
    clientAddr.receiveAgreement(newAgreement);
    emit FormalAgreementCreated(clientAddr, companyAddr);
    return newAgreementId;
  }

  /**
  * @dev Checks if contract is coupon owner, and agreement is not expired,
  * then either facilitates or aborts exchange
  * @param  _agreementId uint256 - identify agreement
  * @return allowed bool - indicate exchange success or abort
  **/
  function signAndPay(uint256 _agreementId)
  returns (bool) payable {
    Agreement ag       = _agreements[_agreementId];
    require(msg.sender == clientAddr);
    require(address(this) == _icr.ownerOf(ag.couponId));
    //Signatures?
    //require(ag.clientSignature == true && ag.companySignature == true);

    bool allowed = true;
    if (msg.value < ag.couponPrice){
      allowed = false;
    }
    if (now > ag.expirationDate || !_icr.isCouponValid(ag.couponId)) {
      allowed = false;
    }
    if (allowed){//Exchange Commodities
      _icr.transferOwnershipToClient(ag.clientAddr,ag.couponId);
      ag.companyAddr.transfer(msg.value);
      emit ExchangeSuccessful(ag.clientAddr, ag.companyAddr);
    }else{//Refund Ether and Burn Coupon
      ag.clientAddr.transfer(msg.value);
      _icr.burnCoupon(ag.couponId);
      emit ExchangeAborted(ag.clientAddr, ag.companyAddr);
    }
    //refund overpayment?
    if (msg.value > ag.couponPrice){
      uint256 sentAmount = msg.value;
      uint256 overpayment_refund = sentAmount.sub(ag.couponPrice);
      ag.clientAddr.transfer(overpayment_refund);
    }
    return allowed;
  }

  /**
  * @dev Registers company as an insurer with this registry
  * @param insurer address
  **/
  function registerInsurer(address insurer) public{
    //Deliberately skip practical validation that insurance company
    //physically/legally exists.
    registeredInsurers[insurer] = true;
  }

  /**
  * @dev checks if an address is an insurance company
  * @param insurer address
  **/
  function isRegisteredInsurer(address insurer) view public{
    return registeredInsurers[insurer];
  }

  /**
  * @dev returns a registered an insurance company
  * @param insurer address
  **/
  function findRegisteredInsurer() view public returns (address) {
    uint256 modVal =  registeredInsurers[insurer].length;
    if (modVal == 0) {
      return address(0);
    }
    uint256 idx = mod(now,modVal)
    return registeredInsurer[idx];
  }
}
