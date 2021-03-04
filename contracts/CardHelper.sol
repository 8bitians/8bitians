// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "./CardFactory.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/// @title A contract for card helpers
/// @author The Creator
/// @notice This contract contains various helpers for cards

contract CardHelper is CardFactory {

  /// @notice Retrieve cards for an owner
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