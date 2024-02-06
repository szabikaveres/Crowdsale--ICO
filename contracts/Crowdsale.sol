// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./Token.sol";

contract Crowdsale {
    address public owner;
    Token public token; //Token is a smart contract type
    uint public price;
    uint public maxTokens;
    uint public tokensSold;

    event Buy(uint amount, address buyer);
    event Finalize(uint tokensSold, uint ethRaised);

    constructor (
        Token _token,
        uint _price,
        uint _maxTokens
    ) {
        owner = msg.sender;
        token = _token;
        price = _price;
        maxTokens = _maxTokens; 
    }

    modifier onlyOwner(){
        require(msg.sender == owner, 'caller is NOT the owner');
        _; //_ stands for the finalize function body bellow , and says exectute the above line bfore exeuting the finalise function body
    }

    receive() external payable {
        uint amount = msg.value / price;
        buyTokens(amount * 1e18);
    }

    function buyTokens(uint _amount) public payable {
        require(msg.value == (_amount / 1e18) * price); 
        require(token.balanceOf(address(this)) >= _amount);//this corresponds to the address of the current SC that we are writing code inside of, and has enough tokens to faciliate the transfer; 
        require(token.transfer(msg.sender, _amount));
        tokensSold += _amount;

        emit  Buy(_amount, msg.sender);
    }

    function setPrice(uint _price) public onlyOwner{
        price = _price;
    }

    function finalize() public onlyOwner {
        //Send Eth to contract creator
       require(token.transfer(owner, token.balanceOf(address(this))));

        //Send remaining tokens back to Crowdsale creator
        uint value = address(this).balance;
        (bool sent, ) = owner.call{value: value}("");
        require(sent);

        emit Finalize(tokensSold, value);
    }
}
//price = 1 token / 1 ETH
//1 ETH = Tokens * price