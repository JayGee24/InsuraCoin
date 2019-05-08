pragma solidity ^0.4.24;

library Agreement{
//Agreement struct to hold agreement info
  struct Agreement{
    uint256 id;
    address clientAddr;
    address companyAddr;
    string  terms;
    bool    clientSignature;
    bool    companySignature;
    uint256 couponId;
    uint256 couponPrice;
    uint256 propertyPrice;
    uint256 expirationDate;
  }
}
