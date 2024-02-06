// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./Token.sol";

contract Crowdsale {
    Token public token; //Token is a smart contract type
    uint public price;
    uint public maxTokens;
    uint public tokensSold;

    event Buy(uint amount, address buyer);

    constructor (
        Token _token,
        uint _price,
        uint _maxTokens
    ) {
        token = _token;
        price = _price;
        maxTokens = _maxTokens;
        
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
}

//price = 1 token / 1 ETH
//1 ETH = Tokens * price