pragma solidity ^0.5.2;

import "../openzeppelin/token/ERC20/ERC20.sol";
import "../openzeppelin/token/ERC20/ERC20Detailed.sol";
import "../openzeppelin/token/ERC20/ERC20Mintable.sol";

contract BondIssuer is ERC20, ERC20Detailed, ERC20Mintable {

    // assume faceValue is constant throughout the lifetime of the bond
    uint256 private _faceValue;

    // string date i.e. dd/mm/yyyy
    string private _maturity;

    // calculated from the provided maturity
    uint256 private _term;

    // normalized to 8 decimal places
    uint256 private _coupon;

    // msg.sender
    address private _issuer;

    // the bank allocation the tokens - msg.sender
    address private _leadBookRunner;

    // sha3 hash of each document associated with this bond
    bytes32[] private _documentHashes;

    address payable[] private _investors;
    uint32[] private _bonds;


    constructor(
        uint256 totalSupply,
        string memory name,
        string memory isin,
        uint8 decimals,
        uint256 faceValue,
        string memory maturity,
        uint256 coupon,
        address issuer,
        bytes32[] memory documentHashes,
        address payable[] memory investors,
        uint256[] memory bonds)
    public ERC20Detailed(name, isin, decimals) {

        _faceValue = faceValue;
        _maturity = maturity;
        _coupon = coupon;
        _issuer = issuer;
        _leadBookRunner = msg.sender;
        _documentHashes = documentHashes;

        _mint(_issuer, totalSupply);
        _createPrimaryMarket(investors, bonds);
    }

    function makePayment() public payable onlyIssuer returns (bool) {
        for (uint i=0; i < _investors.length; i++) {
            _investors[i].transfer(_coupon * balanceOf(_investors[i]));
        }
    }

    function makeFinalPayment() public payable onlyIssuer returns (uint256) {
        for (uint i=0; i < _investors.length; i++) {
            _investors[i].transfer((_faceValue * balanceOf(_investors[i])) + (_coupon * balanceOf(_investors[i])));
        }
    }

    function _createPrimaryMarket(address payable[] memory investors, uint256[] memory bonds) private {
        for (uint i=0; i < investors.length; i++) {
            transfer(_investors[i], bonds[i]);
        }
        require(balanceOf(_leadBookRunner) == 0);
        _investors = investors;

    }

    modifier onlyIssuer() {
        require(msg.sender == _issuer);
        require(msg.value < _issuer.balance);
        _;
    }
}
