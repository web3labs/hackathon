pragma solidity ^0.5.2;

import "../openzeppelin/token/ERC20/ERC20.sol";
import "../openzeppelin/token/ERC20/ERC20Detailed.sol";
import "../openzeppelin/token/ERC20/ERC20Mintable.sol";

//Attributes:
//face value, maturity, yield, coupon, issuer, investors, hashes of documentation
//lead book runner e.g. NWM + additional book runners e.g. Lloyds, HSBC

contract Bond is ERC20, ERC20Detailed, ERC20Mintable {

    uint256 private _faceValue;

    // string date i.e. dd/mm/yyyy
    string private _maturity;

    // normalized to 8 decimal places
    uint256 private _yield;
    uint256 private _coupon;

    // msg.sender
    address private _issuer;

    // sha3 hash of each document associated with this bond
    bytes32[] private _documentHashes;

    address private _leadBookRunner;

    constructor(
        uint256 totalSupply,
        string memory name,
        string memory isin,
        uint8 decimals,
        uint256 faceValue,
        string memory maturity,
        uint256 yield,
        uint256 coupon,
        bytes32[] memory documentHashes,
        address bookRunner)
    public ERC20Detailed(name, isin, decimals) {

        _faceValue = faceValue;
        _maturity = maturity;
        _yield = yield;
        _coupon = coupon;
        _issuer = msg.sender;
        _documentHashes = documentHashes;
        _leadBookRunner = leadBookRunner;
        _bookRunners = bookRunners;

        _mint(_issuer, totalSupply);

    }
}
