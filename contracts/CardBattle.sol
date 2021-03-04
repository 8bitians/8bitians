// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "./CardHelper.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

/// @title A contract for tracking battles
/// @author The Creator
/// @notice This contract logs new battles

contract CardBattle is CardHelper {

  using SafeMath for uint16;

  event NewBattle(uint battleId, address attacker, address defender, uint attackingCard, uint defendingCard, address winner);

  struct Battle {
    address attacker;
    address defender;
    uint attackingCard;
    uint defendingCard;
    address winner;
  }

  Battle[] public battles;

  function _logBattle(uint _attackingCard, uint _defendingCard, uint _winner) internal {
    address attacker = cardToOwner[_attackingCard];
    address defender = cardToOwner[_defendingCard];
    address winner = cardToOwner[_winner];
    battles.push(Battle(attacker, defender, _attackingCard, _defendingCard, winner));
    uint id = battles.length - 1;
    emit NewBattle(id, attacker, defender, _attackingCard, _defendingCard, winner);
  }

}