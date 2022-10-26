//SPDX-License-Identifier:MIT

pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";


contract CryptomanoBattle is ERC721URIStorage {
    
    
    using Strings for uint256;
    
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    

     struct Character {
        uint256 level;      // track level
        uint256 health;     // track health
        uint256 speed;      // track speed
    }

    mapping(uint256 => Character) public tokenIdLevels;

    constructor () ERC721("CryptomanoGame","CRT"){

    }

    function generateCharacter (uint256 tokenId) public view returns(string memory){
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            '<style>.base { fill: black; font-family: serif; font-size: 18px; }</style>',
            '<linearGradient  gradientTransform="rotate(-70)" id="gradient" gradientUnits="objectBoundingBox" x1="0" y1="0" x2="0" y2="1" >',
            '<stop  offset="0" style="stop-color:#100;stop-opacity:0.1"/>',
            '<stop  offset="0" style="stop-color:#198"/>',
            '<stop  offset="1" style="stop-color:#150;stop-opacity:0.5"/>',
            '</linearGradient>',
            '<rect width="100%" height="100%" fill="url(#gradient)" />',
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">', "Cryptomano",'</text>',
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Levels: ", getLevel(tokenId),'</text>',
            '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">', "Health: ", getHealth(tokenId),'</text>',
            '<text x="50%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">', "Speed: ", getSpeed(tokenId),'</text>',
            '</svg>'
        );


        return string(
            abi.encodePacked(
                "data:image/svg+xml;base64,",
                Base64.encode(svg)

            )
        );
    }

    function getLevel(uint256 tokenId) public view returns(string memory){
        uint256 levels = tokenIdLevels[tokenId].level;
        return levels.toString();

    }

    function getHealth(uint256 tokenId) public view returns(string memory){
        uint256 health = tokenIdLevels[tokenId].health;
        return health.toString();

    }

    function getSpeed(uint256 tokenId) public view returns(string memory){
        uint256 speed = tokenIdLevels[tokenId].speed;
        return speed.toString();

    }

    function getTokenURI(uint256 tokenId) public returns (string memory){
    bytes memory dataURI = abi.encodePacked(
        '{',
            '"name": "Cryptomano Battles #', tokenId.toString(), '",',
            '"description": "Battles on chain",',
            '"image": "', generateCharacter(tokenId), '"',
        '}'
    );
    return string(
        abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(dataURI)
        )
    );
}
    function mint() public{
        _tokenIds.increment(); //incrementa cada vez que se llama a la funcion el token
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);  //funcion del mint heredado
        tokenIdLevels[newItemId].level = 0;
        tokenIdLevels[newItemId].health = 10;
        tokenIdLevels[newItemId].speed = 8;

        _setTokenURI(newItemId, getTokenURI(newItemId) );



    }

    function train(uint256 tokenId) public{
        require(_exists(tokenId), "Please use a existing Token");
        require(ownerOf(tokenId) == msg.sender, "Are you not owner");

        uint256 currentLevel =  tokenIdLevels[tokenId].level;
        uint256 currentHealth = tokenIdLevels[tokenId].health;
        uint256 currentSpeed =  tokenIdLevels[tokenId].speed;
        
        tokenIdLevels[tokenId].level = currentLevel +1 ;

        tokenIdLevels[tokenId].health = currentHealth + uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty,msg.sender))) % 60;
        tokenIdLevels[tokenId].speed = currentSpeed + uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty,msg.sender))) % 30;

        _setTokenURI(tokenId, getTokenURI(tokenId) );
        
    }




}
