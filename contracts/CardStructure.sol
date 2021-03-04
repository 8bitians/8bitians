// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract CardStructure is Ownable {

  using SafeMath for uint256;
  using SafeMath32 for uint32;
  using SafeMath16 for uint16;

  event NewType(uint typeId, string name, uint series);
  event NewSeries(uint seriesId, string name);

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

  function createCardType(string _name, uint _seriesId, uint _rarity) external onlyOwner {
    uint id = types.push(Type(_name, _seriesId, _rarity)) - 1;
    emit NewType(id, _name, _series, _rarity);
  }

  function createCardSeries(string _name) external onlyOwner {
    uint id = allSeries.push(Series(_name)) - 1;
    emit NewSeries(id, _name);
  }

}