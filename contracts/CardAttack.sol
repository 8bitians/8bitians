// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "./User.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

/// @title A contract for attacking other cards
/// @author The Creator
/// @notice This contract allows users to attack other cards

contract CardAttack is User {

  /// @notice Attack another card
  function attack(uint _cardId, uint _targetId) external onlyOwnerOf(_cardId) {

    Card storage myCard = cards[_cardId];

    require(
      _isReady(myCard),
      "Your card is not ready to attack."
    );

    Card storage enemyCard = cards[_targetId];


    if (myCard.level != enemyCard.level) {

      uint highCard = myCard.level > enemyCard.level ? myCard.level : enemyCard.level;
      uint lowCard = myCard.level < enemyCard.level ? myCard.level : enemyCard.level;

      require(
        lowCard + 10 >= highCard,
        "The enemy card level is out of the attack scope for your card level."
      );

      uint rand = randMod(myCard.level + enemyCard.level);

      if (myCard.level == highCard) {

        if (rand > lowCard) {

          _cardWin(myCard);
          _cardLoss(enemyCard);
          _logBattle(_cardId, _targetId, _cardId);
          _cardReward(enemyCard.cardType);

        } else {

          _cardWin(enemyCard);
          _cardLoss(myCard);
          _logBattle(_cardId, _targetId, _targetId);

        }

      } else {

        if (rand <= lowCard) {

          _cardWin(myCard);
          _cardLoss(enemyCard);
          _logBattle(_cardId, _targetId, _cardId);
          _cardReward(enemyCard.cardType);

        } else {

          _cardWin(enemyCard);
          _cardLoss(myCard);
          _logBattle(_cardId, _targetId, _targetId);

        }

      }

    } else {

      uint rand = randMod(2);

      if (rand == 1) {
        _cardWin(myCard);
        _cardLoss(enemyCard);
          _logBattle(_cardId, _targetId, _cardId);
        _cardReward(enemyCard.cardType);
      } else {
        _cardWin(enemyCard);
        _cardLoss(myCard);
          _logBattle(_cardId, _targetId, _targetId);
      }

    }

    _triggerCooldown(myCard);

  }

  function _cardReward(uint _enemyCardType) internal {
    uint8 rarity = types[_enemyCardType].rarity;
    uint rand = randMod(20);

    if (rand <= rarity) {
      _createCardWithType(_enemyCardType);
    }
  }

  function _cardWin(Card storage _card) internal {
    _card.winCount = uint16(_card.winCount.add(1));
    if (_cardLevelUpCheck(_card.level, _card.winCount)) {
      _card.level = uint16(_card.level.add(1));
    }
  }

  function _cardLoss(Card storage _card) internal {
    _card.lossCount = uint16(_card.lossCount.add(1));
  }

  function _neededWins(uint _level) internal pure returns(uint) {
    return _level * _level.add(1) / 2;
  }

  function _cardLevelUpCheck(uint _level, uint _wins) internal pure returns(bool) {
    if (_wins >= _neededWins(_level)) {
      return true;
    } else {
      return false;
    }
  }

  function userLevelUpCheck(uint _level, uint _wins) internal pure returns(bool) {
    if (_wins >= _neededWins(_level) * 2) {
      return true;
    } else {
      return false;
    }
  }

}