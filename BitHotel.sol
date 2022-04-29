//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "./ERC2981PerTokenRoyalties.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract BitHotel is ERC721URIStorage, ERC2981PerTokenRoyalties {

  using Counters for Counters.Counter;
  address public controller;
  uint256 public replicas;
  Counters.Counter private _tokenIds;  
  event TokenMint(uint256 tokenId, address to);


  constructor(
    string memory _name,
    string memory _symbol,
    uint256 _replicas
  ) ERC721(_name, _symbol) {
    replicas = _replicas;
  }

  function mint(
    string memory uri,
    address royaltyRecipient,
    uint256 royaltyValue,
    address userAddress
  ) public {
     
    require(_tokenIds.current() <= replicas,"The token can not mint anymore.");
     _tokenIds.increment();
      uint256 newTokenId = _tokenIds.current();
     _mint(userAddress, newTokenId);
     _setTokenURI(newTokenId, uri);
    if (royaltyValue > 0) {
      _setTokenRoyalty(newTokenId, royaltyRecipient, royaltyValue);
    }
    emit TokenMint(newTokenId,userAddress);
  }

  function supportsInterface(bytes4 interfaceId)
    public
    view
    virtual
    override(ERC721, ERC165)
    returns (bool)
  {
    return super.supportsInterface(interfaceId);
  }
}
