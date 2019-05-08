pragma solidity ^0.4.24;

contract ClientRegistry{

  string public constant contractName = 'ClientRegistry'; // For testing.

  event ClientRegistryCreated(
    address indexed addr,
    string  indexed name,
  );

  //list of registered insurance companies
  mapping(address => bool) registeredClients;

  //mapping of registered names and address of client
  mapping(string => address) clientNames;

  //established working relationship between insurer and client
  //after client agrees with insurer policies.
  mapping(address => mapping(address => bool)) workingRelationship;

  constructor(
  ) public (
    emit ClientRegistryCreated(address(this),name);
  )

  /**
  * @dev Registers company as an insurer with this registry
  * @param insurer address
  **/
  function registerClients(address client, string name) public{
    //Deliberately skip practical validation that insurance company
    //physically/legally exists.
    registeredClients[client] = true;
    clientNames[name] = client;
  }

  /**
  * @dev checks if an address is an insurance company
  * @param insurer address
  **/
  function isRegisteredClient(address client) returns(bool) public{
    return registeredClients[client];
  }

  function getClientAddress(address name) returns(address) public{
    return clientNames[name];
  }

  function qualifyForBusiness(address client, address insurer)
  view public {
    return workingRelationship[client][insurer] = true;
  }

  function isQualifiedForBusiness(address client, address insurer)
  returns (bool) view public {
    return workingRelationship[client][insurer];
  }

}
