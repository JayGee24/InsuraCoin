pragma solidity ^0.4.24;

import "./Support/Agreement.sol";
import "./PropertyRegistry.sol";

contract InsurerContract{

  string public constant contractName = 'InsurerContract'; // For testing.

  event InsurerCreated(
    address indexed addr,
    string  indexed name,
  );

  event ClientReimbursed(
    address indexed client,
    string  indexed company,
    uint256 indexed ether,
  );

  struct Request {
    address client;
    uint256 propertyId;
    uint256 propertyPrice;
  }

  //mapping of ids to agreements.
  mapping(uint256 => Agreement) _agreements;

  //mapping of couponId to Agreement ID
  mapping(uint256 => uint256) _couponToAgreementId;

  //List of insurance requestInsurance
  Request[] internal _requestList;

  mapping(ui)

  address public _ab;
  address public _pr;
  address public _icr;
  string  public _name;

  constructor(
    address arbitrationContract,
    address propertyRegistry,
    address insuranceCouponRegistry,
    address insurerRegistry;
    address clientRegistry;
    string  name,
    string  terms,
  ) public (
    _ab   = arbitrationContract;
    _pr   = propertyRegistry;
    _icr  = insuranceCouponRegistry;
    _ireg = insurerRegistry;
    _creg = clientRegistry;
    _name = name;
    _terms = terms;
    emit InsurerCreated(address(this),name);
  )

  modifier onlyClient(){
    require(_creg.isRegisteredClient(msg.sender),
    "caller needs to be a registered client");
    _;
  }

  function queueInsuranceRequest(uint256 propertyId, uint256 propertyPrice,
     address client)
  onlyClient returns(bool) {
    bool doBiz = isQualifiedForBusiness(client,address(this));
    if (!doBiz) {
      return false;
    }
    Request memory newRequest;
    newRequest.client = client;
    newRequest.propertyId = propertyId;
    newRequest.propertyPrice = propertyPrice;
    _requestList.push(newRequest);
    return true;
  }

  function acceptTermsAndProceed(address client) onlyClient {
    //Check off client as 'qualified for business relations'
    _creg.qualifyForBusiness(client,address(this));
  }
  function verifyClientProperty(uint256 propertyId, address client)
   internal returns (bool) {
    return _pr.verifyPropertyOwnership(propertyId, client);
  }

  function processRequest(uint256 index) internal returns (bool) {
    //Get Request
    if (index >= _requestList.length) {
      return false;
    }
    Request r = _requestList[index];
    for (uint256 i = 0; i < _requestList.length - 1; i++) {
      _requestList[i] = _requestList[i+1];
    }
    _requestList.length--;

    //verifyPropertyOwnership
    verifyClientProperty(r.propertyId,r.clientAddr);

    //Mint Coupon
    uint256 daysToExpire = 365;
    uint256 couponId = _icr.createInsuranceCoupon("",daysToExpire,
                        address(this),r.propertyId,_pr);

    //Create Agreement
    Agreement memory a;
    a.clientAddr = r.client;
    a.companyAddr = address(this);
    a.terms = getTerms();
    a.companySignature = 1;
    a.couponId = couponId;
    a.couponPrice = 10;
    a.expirationDate = daysToExpire;
    a.propertyPrice = r.propertyPrice;

    //transfer ownership
    transferOwnershipToArbitrationContract(couponId);

    //Send to Arbitration Contrat.
    uint256 formalId = _ab.receiveAndCreateFormalAgreement(a);
    a.id = formalId;
    _agreements[a.id] = a;
    _couponToAgreement[couponId]= a.id;
  }

  function setTerms(string terms) internal {
    _terms = terms;
  }

  function getTerms() view returns (string) {
    return _terms;
  }

  function reimburse(uint256 couponId, address client) returns(bool){
    if (!_icr.isCouponValid(couponId)){
      returns false;
    } else {

    }
    uint256 aId _couponToAgreementId[couponId]
    Agreement a = _agreements[aId];

    //expect token to be transferred to owner
    if (_icr.getCouponOwner(couponId) != address(this)){
      return false;
    }
    //Burn coupon
    _icr.burnCoupon(couponId);

    //Pay reimbursement
    client.transfer(a.propertyPrice);

  }

  function() payable {}

}
