// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/PaymentGateway.sol";

contract PaymentGatewayTest is Test {
    event PaymentReceived(string indexed taxIdentifier, uint amount);
    event PaymentWithdrawn(address indexed receiver, uint amount);
    PaymentGateway public paymentGateway;

    function setUp() public {
        vm.prank(address(1));
        paymentGateway = new PaymentGateway();
    }

    function test_RevertWhen_CallerIsNotOwner() public {
        vm.expectRevert(NotOwner.selector);
        vm.prank(address(0));
        paymentGateway.withdraw(123);
    }

    function test_RevertWhen_ContractHasInsufficientFunds() public {
        vm.prank(address(1));
        vm.expectRevert("Insufficient contract balance");
        paymentGateway.withdraw(123);
    }

        function test_RevertWhen_PaymentAmountIsZero() public {
        vm.expectRevert("Payment amount must be greater than zero");
        paymentGateway.pay("id");
    }

    function test_ExpectEmit_PaymentReceived() public {
        vm.prank(address(0));
        vm.deal(address(0), 1 ether);
        vm.expectEmit(true, true, false,true);
        uint amount = 1000;
        string memory id = "id";
        emit PaymentReceived(id, amount);
        paymentGateway.pay{value: amount}(id);
    }

    function test_ExpectEmit_PaymentWithdrawn() public {
        vm.prank(address(1));
        vm.deal(address(paymentGateway), 1 ether);
        vm.expectEmit(true, true,false,true);
        uint amount = 1000;
        emit PaymentWithdrawn(address(1), amount);
        paymentGateway.withdraw(amount);
    }
}
