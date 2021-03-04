// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

/// @title A contract for structuring cards
/// @author The Creator
/// @notice This contract creates new types and series for cards

contract CardStructure is Ownable {

  using SafeMath for uint256;
  using SafeMath for uint16;
  using SafeMath for uint8;

  event NewType(uint typeId, string name, uint series, uint rarity);
  event NewSeries(uint seriesId, string name);
  event ChangeTypeName(uint typeId, string newName);
  event ChangeSeriesName(uint seriesId, string newName);

  struct Type {
    string name;
    uint16 series;
    uint8 rarity;
  }

  struct Series {
    string name;
  }

  Type[] public types;
  Series[] public allSeries;

  /// @notice Owner can create new card types
  function createCardType(string memory _name, uint16 _seriesId, uint8 _rarity) external onlyOwner {
    require (
      _seriesId < allSeries.length && _seriesId >= 0,
      "No series exists with that ID."
    );
    require(
      _rarity <= 5,
      "Invalid rarity for card. Must be 5 or less."
    );
    types.push(Type(_name, uint16(_seriesId), uint8(_rarity)));
    uint id = types.length - 1;
    emit NewType(id, _name, _seriesId, _rarity);
  }

  /// @notice Owner can create new series
  function createCardSeries(string memory _name) external onlyOwner {
    allSeries.push(Series(_name));
    uint id = allSeries.length - 1;
    emit NewSeries(id, _name);
  }

  /// @notice Owner can update type name
  function updateTypeName(uint _typeId, string memory _newName) external onlyOwner {
    types[_typeId].name = _newName;
    emit ChangeTypeName(_typeId, _newName);
  }

  /// @notice Owner can update series name
  function updateSeriesName(uint _seriesId, string memory _newName) external onlyOwner {
    allSeries[_seriesId].name = _newName;
    emit ChangeSeriesName(_seriesId, _newName);
  }

}