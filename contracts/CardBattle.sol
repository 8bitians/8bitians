// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "./CardHelper.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/// @title A contract for tracking battles
/// @author The Creator
/// @notice This contract logs new battles

contract CardBattle is CardHelper {

  using SafeMath16 for uint16;

  event NewBattle(uint battleId);

  struct Battle {
    address attacker;
    address defender;
    uint attackingCard;
    uint defendingCard;
    uint16 attackingCardLevel;
    uint16 defendingCardLevel;
    address winner;
  }

  Battle[] public battles;

  function _createBattle(address _attacker, address _defender, uint _attackingCard, uint _defendingCard, uint16 _attackingCardLevel, uint16 _defendingCardLevel, address _winner) internal {
    uint id = battles.push(Battle(_attacker, _defender, _attackingCard, _defendingCard, _attackingCardLevel, _defendingCardLevel, _winner)) - 1;
    emit NewBattle(id);
  }

}