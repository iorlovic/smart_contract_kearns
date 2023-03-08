// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

//import "remix_tests.sol"; // this import is automatically injected by Remix.

contract CountContract {
  uint public count;

  constructor (uint _count) {
    count = _count;
  }

  function setCount (uint _count) public {
    count = _count;
  }

  function increment() public {
    count++;
  }

  function decrement() public {
    count--;
  }

  function getCount() public view returns (uint) {
    return count;
  }

  function testGetCount() public {
    // set count to desired number
    setCount(42);
    
    // get the actual value returned by getCount()
    uint actualCount = getCount();
    
    // check if the actual value matches the expected value
    require(actualCount == 42, "getCount should return 42");
  }

}