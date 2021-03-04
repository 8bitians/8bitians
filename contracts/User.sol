// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "./CardBattle.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/// @title A contract for tracking user details
/// @author The Creator
/// @notice This contract tracks user stats

contract User is CardBattle {

  mapping (address => uint) public userWinCount;
  mapping (address => uint) public userLossCount;

  /// @notice Retrieve number of wins a user has
  function getUserWins(address _user) external view returns(uint memory) {
    uint[] memory result = new uint[](userWinCount[_owner]);
    uint counter = 0;
    for (uint i = 0; i < battles.length; i++) {
      if ((battles[i].attacker == address || battles[i].defender == address) && battles[i].winner == address) {
        result[counter] = i;
        counter++;
      }
    }
    return result;
  }

  /// @notice Retrieve number of losses a user has
  function getUserLosses(address _user) external view returns(uint memory) {
    uint[] memory result = new uint[](userLossCount[_owner]);
    uint counter = 0;
    for (uint i = 0; i < battles.length; i++) {
      if ((battles[i].attacker == address || battles[i].defender == address) && battles[i].winner != address) {
        result[counter] = i;
        counter++;
      }
    }
    return result;
  }

}