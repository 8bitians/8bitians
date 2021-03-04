// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/// @title A contract for structuring cards
/// @author The Creator
/// @notice This contract creates new types and series for cards

contract CardStructure is Ownable {

  using SafeMath for uint256;
  using SafeMath32 for uint32;
  using SafeMath16 for uint16;

  event NewType(uint typeId, string name, uint series);
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
  function createCardType(string _name, uint _seriesId, uint _rarity) external onlyOwner {
    uint id = types.push(Type(_name, _seriesId, _rarity)) - 1;
    emit NewType(id, _name, _series, _rarity);
  }

  /// @notice Owner can create new series
  function createCardSeries(string _name) external onlyOwner {
    uint id = allSeries.push(Series(_name)) - 1;
    emit NewSeries(id, _name);
  }

  /// @notice Owner can update type name
  function updateTypeName(uint _typeId, string _newName) external onlyOwner {
    types[_typeId].name = _newName;
    emit ChangeTypeName(_typeId, _newName);
  }

  /// @notice Owner can update series name
  function updateSeriesName(uint _seriesId, string _newName) external onlyOwner {
    series[_seriesId].name = _newName;
    emit ChangeSeriesName(_seriesId, _newName);
  }

}