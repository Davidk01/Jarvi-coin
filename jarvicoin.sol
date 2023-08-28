// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;


interface IERC20 {

    function transfer(address to, uint256 amount) external returns (bool);

    function transferFrom(address from, address to, uint256 amount) external returns (bool);

    function balanceOf(address account) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

}


contract JRC_Token {

    string public name = "jarvi coin";

    string public symbol = "JRC";

    uint8 public decimals = 18;

    uint256 public totalSupply = 160 * 10**6 * 10**uint256(decimals);

    address public owner = 0x8c607facE7a4469C5b8BD6dfF2eE662195C55Ceb;

    address public feeWallet = 0xC7f94EAaFfDB25613A091B2DB276C1c409d1ee23;


    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    

    uint256 public buyFeePercentage = 4; // 4% buy fee

    uint256 public sellFeePercentage = 6; // 6% sell fee

    

    constructor() {

        _balances[owner] = totalSupply;

        emit Transfer(address(0), owner, totalSupply);

    }


    modifier onlyOwner() {

        require(msg.sender == owner, "Only the owner can call this function");

        _;

    }


    function balanceOf(address account) external view returns (uint256) {

        return _balances[account];

    }


    function transfer(address to, uint256 amount) external returns (bool) {

        _transfer(msg.sender, to, amount);

        return true;

    }


    function transferFrom(address from, address to, uint256 amount) external returns (bool) {

        _transfer(from, to, amount);

        _approve(from, msg.sender, _allowances[from][msg.sender] - amount);

        return true;

    }


    function approve(address spender, uint256 amount) external returns (bool) {

        _approve(msg.sender, spender, amount);

        return true;

    }


    function _approve(address ownerAddr, address spender, uint256 amount) private {

        _allowances[ownerAddr][spender] = amount;

        emit Approval(ownerAddr, spender, amount);

    }


    function _transfer(address from, address to, uint256 amount) private {

        require(from != address(0), "Transfer from the zero address");

        require(to != address(0), "Transfer to the zero address");

        require(amount > 0, "Transfer amount must be greater than zero");

        require(_balances[from] >= amount, "Insufficient balance");


        uint256 feeAmount = 0;

        if (to != owner) {

            if (msg.sender == owner) {

                feeAmount = (amount * buyFeePercentage) / 100;

            } else {

                feeAmount = (amount * sellFeePercentage) / 100;

            }

            _balances[feeWallet] += feeAmount;

        }


        _balances[from] -= (amount + feeAmount);

        _balances[to] += amount;


        emit Transfer(from, to, amount);

        if (feeAmount > 0) {

            emit Transfer(from, feeWallet, feeAmount);

        }

    }


    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);

}