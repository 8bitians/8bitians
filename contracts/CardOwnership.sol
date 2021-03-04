// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "./CardAttack.sol";
import "@openzeppelin/contracts/ERC271/ERC271.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/// @title A contract for card ownership
/// @author The Creator
/// @notice This contract defines ownership for a card token

contract CardOwnership is CardAttack, ERC271 {

  using SafeMath for uint256;

  mapping (uint => address) cardApprovals;

  /// @notice Retrieves the balance of an owner's account
  function balanceOf(address _owner) external view returns (uint256) {
    return ownerCardCount[_owner];
  }

  /// @notice Retrieves the owner of a card
  function ownerOf(uint256 _tokenId) external view returns (address) {
    return cardToOwner[_tokenId];
  }

  function _transfer(address _from, address _to, uint256 _tokenId) private {
    ownerCardCount[_to] = ownerCardCount[_to].add(1);
    ownerCardCount[msg.sender] = ownerCardCount[msg.sender].add(1);
    cardToOwner[_tokenId] = _to;
    emit Transfer(_from, _to, _tokenId);
  }

  /// @notice Transfer to another owner
  function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
    require (cardToOwner[_tokenId] == msg.sender || cardApprovals[_tokenId] == msg.sender);
    _transfer(_from, _to, _tokenId);
  }

  /// @notice Approve transfer to another owner
  function approve(address _approved, uint256 _tokenId) external payable onlyOwnerOf(_tokenId) {
    cardApprovals[_tokenId] = _approved;
    emit Approval(msg.sender, _approved, _tokenId);
  }

}