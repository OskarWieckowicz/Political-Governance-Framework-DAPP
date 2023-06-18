// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

error NotOwner();

contract PaymentGateway {
    address public immutable owner;
    
    event PaymentReceived(string indexed taxIdentifier, uint amount);
    event PaymentWithdrawn(address indexed receiver, uint amount);

    constructor() {
        owner = msg.sender;
    }
    modifier onlyOwner() {
         if (msg.sender != owner) {
            revert NotOwner();
        }
        _;
    }

    function pay(string memory taxIdentifier) external payable {
        require(msg.value > 0, "Payment amount must be greater than zero");

        emit PaymentReceived(taxIdentifier, msg.value);
    }

    function withdraw(uint amount) external onlyOwner {
        require(amount <= address(this).balance, "Insufficient contract balance");
        (bool success, ) = msg.sender.call{ value: amount } ("");
        require(success, "Transfer failed.");
        emit PaymentWithdrawn(owner, amount);
    }
    
}
