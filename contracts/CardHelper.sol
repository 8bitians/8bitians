// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "./CardFactory.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract CardHelper is CardFactory {

  function getCardsByOwner(address _owner) external view returns(uint[] memory) {
    uint[] memory result = new uint[](ownerCardCount[_owner]);
    uint counter = 0;
    for (uint i = 0; i < cards.length; i++) {
      if (cardToOwner[i] == _owner) {
        result[counter] = i;
        counter++;
      }
    }
    return result;
  }

}