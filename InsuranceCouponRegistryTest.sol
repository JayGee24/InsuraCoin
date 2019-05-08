pragma solidity ^0.4.24;

import "./Tokens/ERC721.sol";
import "./ArbitrationContract.sol";


contract PropertyRegisterTest {
  function testOwnership() public {
    PropertyRegistry propertyReg = new PropertyRegistry();
    Assert.equal(propertyReg.owner(), this, "An owner is different than a deployer");
  }

  function testAddingMetadata() public {
    PropertyRegistry propertyReg = new PropertyRegistry();
    bool truth = propertyReg.registerProperty(1, "meta");
    Assert.equal(truth, true, "Property was not registered");
  }

  function testVerifyOwnerShip() public {
    PropertyRegistry propertyReg = new PropertyRegistry();
    bool truth = propertyReg.registerProperty(2, "meta");
    bool verified = propertyReg.verifyOwnership(propertyReg.owner(), 2);
    Assert.equal(verified, true, "Property was not registered");
  }


}
