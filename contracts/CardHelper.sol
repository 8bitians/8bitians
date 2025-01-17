// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "./CardFactory.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

/// @title A contract for card helpers
/// @author The Creator
/// @notice This contract contains various helpers for cards

contract CardHelper is CardFactory {

  /// @notice Owner can withdraw contract balance
  function withdraw() external payable onlyOwner {
    address payable _owner = msg.sender;
    _owner.transfer(address(this).balance);
  }

  function _triggerCooldown(Card storage _card) internal {
    _card.readyTime = uint64(now + cooldownTime * _card.level);
  }

  function _isReady(Card storage _card) internal view returns (bool) {
    return (_card.readyTime <= now);
  }

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

  /// @notice Retrieve overall quantity of a certain card
  function getCardsTypeCount(uint _typeId) external view returns(uint[] memory) {
    uint[] memory result = new uint[](cards.length);
    uint counter = 0;
    for (uint i = 0; i < cards.length; i++) {
      if (cards[i].cardType == _typeId) {
        result[counter] = i;
        counter++;
      }
    }
    return result;
  }

}