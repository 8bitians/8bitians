// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "./CardHelper.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/// @title A contract for tracking battles
/// @author The Creator
/// @notice This contract logs new battles

contract CardBattle is CardHelper {

  using SafeMath16 for uint16;

  event NewBattle(uint battleId, address attacker, address defender, uint attackingCard, uint defendingCard, address winner);

  struct Battle {
    address attacker;
    address defender;
    uint attackingCard;
    uint defendingCard;
    address winner;
  }

  Battle[] public battles;

  function _logBattle(Card storage _attackingCard, Card storage _defendingCard, uint _winner) internal {
    address attacker = cardToOwner[_attackingCard.id];
    address defender = cardToOwner[_defendingCard.id];
    address winner = cardToOwner[_winner];
    uint id = battles.push(Battle(attacker, defender, _attackingCard.id, _defendingCard.id, winner)) - 1;
    emit NewBattle(attacker, defender, _attackingCard.id, _defendingCard.id, winner);
  }

}