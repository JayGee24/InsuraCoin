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
      uint256 indexed client;
      uint256 indexed company;
  );
  event ExchangeSuccessful(
      uint256 indexed client;
      uint256 indexed company;
  );
  event ExchangeAborted(
      uint256 indexed client;
      uint256 indexed company;
  );

  //Insurance Coupon Registry Instance Address
  address public _icr;

  //Client Contract Instance Address
  address public _clientAPI;

  //Company Contract Instance Address
  address public _companyAPI;

  //List of Agreements Received
  Agreement[] internal _agreements;

  constuctor (
    address insuranceCouponRegistry,
    address clientContract,
    address companyContract
  ) {
    _icr        = insuranceCouponRegistry;
    _clientAPI  = clientContract;
    _companyAPI = companyContract;
  }

  modifier onlyClient(){
    //require(_clientAPI.isRegisteredClient(msg.sender),
    //"caller needs to be a registered client");
    _;
  }

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
    uint256 clientId       = newAgreement.client;
    uint256 companyId      = newAgreement.company;
    uint256 newAgreementId = _agreements.length; //monotonically increasing index
    newAgreement.id = newAgreementId;
    _agreements.push[newAgreement];
    _clientAPI.receiveAgreement(clientId, newAgreement);
    emit FormalAgreementCreated(_clientId, companyId);
    return newAgreementId;
  }

  /**
  * @dev Checks if contract is coupon owner, and agreement is not expired,
  * then either facilitates or aborts exchange
  * @param  _agreementId uint256 - identify agreement
  * @param _clientId uint256 - identify client paying for insurance coupon
  * @return allowed bool - indicate exchange success or abort
  **/
  function signAndPay(uint256 _agreementId, uint256 _clientId) onlyClient
  returns (bool) payable {
    Agreement ag     = _agreements[_agreementId];
    uint256 couponId = ag.couponId;
    require(_clientId == ag.clientId);
    require(address(this) == _icr.ownerOf(couponId));
    //Signatures?
    //require(ag.clientSignature == true && ag.companySignature == true);

    bool allowed = true;
    if (msg.value < ag.couponPrice){
      allowed = false;
    }
    if (now > ag.expirationDate || !_icr.isCouponValid(couponId)) {
      allowed = false;
    }
    if (allowed){//Exchange Commodities
      _icr.transferOwnershipToClient(ag.clientAddr,couponId);
      _companyAPI.receivePayment.value(msg.value)(ag.companyId);
      emit ExchangeSuccessful(ag.clientId, ag.companyId);
    }else{//Refund Ether and Burn Coupon
      _clientAPI.receiveRefund.value(msg.value)(ag.clientId);
      _icr.burnCoupon(couponId);
      emit ExchangeAborted(ag.clientId, ag.companyId);
    }
    //refund overpayment?
    if (msg.value > ag.couponPrice){
      uint256 overpayment_refund = mag.value.sub(ag.couponPrice);
      _clientAPI.receiveRefund.value(overpayment_refund)(ag.clientId);
    }
    return allowed;
  }

}
