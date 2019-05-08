pragma solidity ^0.4.24;

contract InsurerRegistry{

  string public constant contractName = 'InsurerRegistry'; // For testing.

  event InsurerRegistryCreated(
    address indexed addr,
    string  indexed name,
  );

  //List of registered insurance companies
  mapping(address => bool) registeredInsurers;

  //mapping of registered names and address of insurer
  mapping(string => address) insurerNames;

  constructor(
  ) public (
    emit InsurerRegistryCreated(address(this),name);
  )

  /**
  * @dev Registers company as an insurer with this registry
  * @param insurer address
  **/
  function registerInsurer(address insurer, string name) public{
    //Deliberately skip practical validation that insurance company
    //physically/legally exists.
    registeredInsurers[insurer] = true;
    insurerNames[name] = insurer;
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
    uint256 idx = mod(now,modVal);
    return registeredInsurer[idx];
  }

  function getInsurerAddress(address name) returns(address) public{
    return insurerNames[name];
  }

}
