// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "./CardStructure.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/// @title A contract for generating cards
/// @author The Creator
/// @notice This contract creates new cards and packs

contract CardFactory is CardStructure {

  using SafeMath for uint256;
  using SafeMath32 for uint32;
  using SafeMath16 for uint16;

  event NewCard(uint cardId);

  uint cooldownTime = 864 seconds;
  uint randNonce = 0;
  uint cardFee = 0.001 ether;

  struct Card {
    uint cardType;
    uint16 level;
    uint64 readyTime;
    uint16 winCount;
    uint16 lossCount;
  }

  Card[] public cards;

  mapping (uint => address) public cardToOwner;
  mapping (address => uint) ownerCardCount;

  /// @notice Owner function to modify card fee
  function setCardFee(uint _fee) external onlyOwner {
    cardFee = _fee;
  }

  function randMod(uint _modulus) internal returns(uint) {
    randNonce = randNonce.add(1);
    return uint(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % _modulus;
  }

  function generateRandomCardType() internal returns(uint) {
    uint[] memory result = new uint[];
    uint counter = 0;
    for (uint i = 0; i < types.length; i++) {
      uint rarity = types[i].rarity;
      for (uint j = 0; j < rarity; j++) {
        result[counter] = i;
        counter++;
      }
    }

    return result[randMod(result.length)];
  }

  function _createCard() internal {
    uint id = cards.push(Card(generateRandomCardType(), 1, uint32(now + cooldownTime), 0, 0)) - 1;
    cardToOwner[id] = msg.sender;
    ownerCardCount[msg.sender] = ownerCardCount[msg.sender].add(1);
    emit NewCard(id);
  }

  function _createCardWithType(uint _typeId) internal {
    uint id = cards.push(Card(_typeId, 1, uint32(now + cooldownTime), 0, 0)) - 1;
    cardToOwner[id] = msg.sender;
    ownerCardCount[msg.sender] = ownerCardCount[msg.sender].add(1);
    emit NewCard(id);
  }

  /// @notice New users can create first card
  function createInitialCard() public {
    require(
      ownerCardCount[msg.sender] == 0,
      "You already have a starter card."
    );
    _createCard();
  }

  /// @notice Users can buy card packs of various sizes
  function buyCardPack(uint _quantity) external payable {
    require(
      msg.value == _quantity * cardFee,
      "Not enough payment for quantity."
    );
    for(uint i = 0; i < _quantity; i++) {
      _createCard();
    }
  }

  modifier onlyOwnerOf(uint _cardId) {
    require(
      msg.sender == cardToOwner[_cardId],
      "Sender is not the card owner."
    );
    _;
  }

}