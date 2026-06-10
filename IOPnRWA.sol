// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract IOPnRWA {
    
    string public name = "IOPn Real World Asset";
    string public symbol = "iRWA";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    
    address public owner;
    
    struct Asset {
        string assetName;
        string assetType; // Example: Property, Business Share, Gold
        uint256 valuation;
        bool isVerified;
    }
    
    mapping(address => uint256) public balanceOf;
    mapping(uint256 => Asset) public registry;
    uint256 public nextAssetId;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event AssetTokenized(uint256 indexed assetId, string assetName, uint256 valuation);
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Error: Caller is not the owner");
        _;
    }
    
    constructor() {
        owner = msg.sender;
    }
    
    // Tokenize real-world assets
    function tokenizeAsset(
        string memory _assetName, 
        string memory _assetType, 
        uint256 _valuation, 
        uint256 _tokenAmount
    ) public onlyOwner {
        uint256 assetId = nextAssetId;
        
        registry[assetId] = Asset({
            assetName: _assetName,
            assetType: _assetType,
            valuation: _valuation,
            isVerified: true
        });
        
        totalSupply += _tokenAmount * (10 ** uint256(decimals));
        balanceOf[owner] += _tokenAmount * (10 ** uint256(decimals));
        
        nextAssetId++;
        emit AssetTokenized(assetId, _assetName, _valuation);
    }
    
    // Transfer asset tokens to investors
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Error: Insufficient balance");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
}