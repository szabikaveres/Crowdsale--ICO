// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Token {
    string public name;
    string public symbol;
    uint public decimals = 18;
    uint public totalSupply;

    //Track balances 
    mapping (address => uint) public balanceOf; //mapping lets you store information with key-value pairs
    mapping (address => mapping (address => uint )) public allowance;
    
    // send tokens 
    event Transfer(
        address indexed from, 
        address indexed to, 
        uint value
        );

    event Approval(
        address indexed owner,
        address indexed spender,
        uint value
    );

    constructor(
        string memory _name, 
        string memory _symbol, 
        uint _totalSupply
        ){
        name = _name;
        symbol = _symbol;
        totalSupply = _totalSupply * (10**decimals);
        balanceOf[msg.sender] = totalSupply; //update the balance of the person deploying the SC, to the entire total supplyof the tokens that we specified above(_totalSupply).
        //Basically going to take all the tokens and going to sign them to the deployer
    }

    function transfer(
        address _to, 
        uint _value) 
        public 
        returns (bool success) 
    {
        // require that sender has enough tokens to spend
        require (balanceOf[msg.sender] >= _value);

        _transfer(msg.sender, _to, _value);

        return true;

    }

    function _transfer(
        address _from,
        address _to,
        uint256 _value
    ) internal {
        require(_to != address(0));

        balanceOf[_from] = balanceOf[_from] - _value;
        balanceOf[_to] = balanceOf[_to] + _value;

        emit Transfer(_from, _to, _value);
    }

    function approve (
        address _spender, 
        uint _value) 
    public 
    returns(bool success)
    {
        require(_spender != address(0));

        allowance[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    )
        public
        returns (bool success)
    {
        //check approval-mapping, than nested maping
        require(_value <= balanceOf[_from]);// has enough tokens
        require(_value <= allowance[_from][msg.sender]);// the value of the toens doesn't exceed the allowed amount

        //Reset the allowance-to avoid doubl spent
        allowance[_from][msg.sender] = allowance[_from][msg.sender] - _value;

        //spend the amount
        _transfer(_from, _to, _value);

        return true;
    }
}
