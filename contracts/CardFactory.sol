// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "./CardStructure.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

/// @title A contract for generating cards
/// @author The Creator
/// @notice This contract creates new cards and packs

contract CardFactory is CardStructure {

  using SafeMath for uint256;
  using SafeMath for uint32;
  using SafeMath for uint16;

  event NewCard(uint cardId);
  event NewCardFee(uint fee);

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
    cardFee = uint(_fee) * (1 ether);
    emit NewCardFee(cardFee);
  }

  function randMod(uint _modulus) internal returns(uint) {
    require(
      _modulus > 0,
      "Cannot use a zero modulus."
    );
    randNonce = randNonce.add(1);
    return uint(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % _modulus;
  }

  function generateRandomCardType() internal returns(uint) {

    uint cardOptions = 0;

    for (uint x = 0; x < types.length; x++) {
      cardOptions = cardOptions.add(types[x].rarity);
    }

    uint[] memory result = new uint[](cardOptions);

    uint counter = 0;

    for (uint i = 0; i < types.length; i++) {
      uint rarity = types[i].rarity;
      for (uint j = 0; j < rarity; j++) {
        result[counter] = i;
        counter++;
      }
    }

    return uint(result[randMod(result.length)]);
  }

  function _createCard() internal {
    require(
      types.length > 0,
      "There are no card types."
    );
    cards.push(Card(generateRandomCardType(), 1, uint32(now), 0, 0));
    uint id = cards.length - 1;
    cardToOwner[id] = msg.sender;
    ownerCardCount[msg.sender] = ownerCardCount[msg.sender].add(1);
    emit NewCard(id);
  }

  function _createCardWithType(uint _typeId) internal {
    require(
      types.length > _typeId,
      "That type is not available."
    );
    cards.push(Card(_typeId, 1, uint32(now + cooldownTime), 0, 0));
    uint id = cards.length - 1;
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

  /// @notice Retrieve array of all cards
  function retrieveCards() public view returns (Card[] memory) {
    return cards;
  }

  /// @notice Retrieve current card fee
  function retrieveCardFee() public view returns (uint) {
    return cardFee;
  }

  modifier onlyOwnerOf(uint _cardId) {
    require(
      msg.sender == cardToOwner[_cardId],
      "Sender is not the card owner."
    );
    _;
  }

}