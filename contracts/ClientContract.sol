pragma solidity ^0.4.24;

import "./Support/Agreement.sol";
import "./PropertyRegistry.sol";

contract ClientContract{

  string public constant contractName = 'ClientContract'; // For testing.

  event ClientCreated(
    address indexed addr,
    string  indexed name,
  );

  //List of Agreements
  Agreement[] internal _agreements;

  address public _ab;
  address public _pr;
  string  public _name;

  constructor(
    address arbitrationContract,
    address propertyRegistry,
    string  name
  ) public (
    _ab = arbitrationContract;
    _pr = propertyRegistry;
    _name = name;
    emit ClientCreated(address(this),name);
  )

  modifier onlyArbitrationContract() {
    require(msg.sender == _ab, "msg.sender is an arbitration contract");
    _;
  }

  function registerProperty(uint256 propertyId, string uri) {
    _pr.registerProperty(propertyId, uri);
  }

  function receiveAgreement(Agreement _agreement)
  onlyArbitrationContract {
    _agreements.push(_agreement);
  }

  function findInsurer() return (address) {
    address insurer  =  _ab.findRegisteredInsurer();
    return insurer;
  }

  function getInsurerTerms(address insurer) returns (string) {
    string terms = insurer.getTerms();
    return terms;
  }

  function acceptInsurerTerms(address insurer) {
    insurer.acceptTermsAndProceed(address(this));
  }

  function pleaseInsureProperty(uint256 propertyId, address insurer) returns bool {
    bool instantRejection = insurer.queueInsuranceRequest(propertyId, address(this));
    //client meets standards or not.
    return instantRejection;
  }

  function signAndPay(uint256 agreementId) {
    Agreement ag = _agreements[agreementId];
    _ab.signAndPay.value(agreement.couponPrice)(agreementId);
  }

  function() payable {}

}
