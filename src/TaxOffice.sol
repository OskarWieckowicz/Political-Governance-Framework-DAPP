// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

error NotOwner();

contract TaxOffice {
    address public immutable owner;
    string private _name;
    
    event PaymentReceived(string taxIdentifier, uint amount);
    event PaymentWithdrawn(address receiver, uint amount);

    constructor(string memory name_) {
        owner = msg.sender;
        _name = name_;
        
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

        function name() external view returns(string memory){
        return _name;
    }
    
}
