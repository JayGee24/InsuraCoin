pragma solidity ^0.4.24;

library Agreement{
//Agreement struct to hold agreement info
  struct Agreement{
    uint256 id;
    address clientAddr;
    uint256 clientId;
    address companyAddr;
    uint256 companyId;
    string  terms;
    bool    clientSignature;
    bool    companySignature;
    uint256 couponId;
    uint256 couponPrice;
    uint256 expirationDate;
  }
}
