// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "./CardBattle.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

/// @title A contract for tracking user details
/// @author The Creator
/// @notice This contract tracks user stats

contract User is CardBattle {

  mapping (address => uint) public userWinCount;
  mapping (address => uint) public userLossCount;

  /// @notice Retrieve number of wins a user has
  function getUserWins(address _user) external view returns(uint[] memory) {
    uint[] memory result = new uint[](userWinCount[_user]);
    uint counter = 0;
    for (uint i = 0; i < battles.length; i++) {
      if ((battles[i].attacker == _user || battles[i].defender == _user) && battles[i].winner == _user) {
        result[counter] = i;
        counter++;
      }
    }
    return result;
  }

  /// @notice Retrieve number of losses a user has
  function getUserLosses(address _user) external view returns(uint[] memory) {
    uint[] memory result = new uint[](userLossCount[_user]);
    uint counter = 0;
    for (uint i = 0; i < battles.length; i++) {
      if ((battles[i].attacker == _user || battles[i].defender == _user) && battles[i].winner != _user) {
        result[counter] = i;
        counter++;
      }
    }
    return result;
  }

}