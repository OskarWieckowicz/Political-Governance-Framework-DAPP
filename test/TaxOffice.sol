// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import "forge-std/Test.sol";
import "../src/TaxOffice.sol";

contract taxOfficeTest is Test {
    event PaymentReceived(string taxIdentifier, uint amount);
    event PaymentWithdrawn(address receiver, uint amount);
    TaxOffice public taxOffice;

    function setUp() public {
        vm.prank(address(1));
        taxOffice = new TaxOffice("Test");
    }

    function test_name() public {
            string memory name = taxOffice.name();
            assertEq(name, "Test");
    }

    function test_RevertWhen_CallerIsNotOwner() public {
        vm.expectRevert(NotOwner.selector);
        vm.prank(address(0));
        taxOffice.withdraw(123);
    }

    function test_RevertWhen_ContractHasInsufficientFunds() public {
        vm.prank(address(1));
        vm.expectRevert("Insufficient contract balance");
        taxOffice.withdraw(123);
    }

        function test_RevertWhen_PaymentAmountIsZero() public {
        vm.expectRevert("Payment amount must be greater than zero");
        taxOffice.pay("id");
    }

    function test_ExpectEmit_PaymentReceived() public {
        vm.prank(address(0));
        vm.deal(address(0), 1 ether);
        vm.expectEmit(true, true, false,true);
        uint amount = 1000;
        string memory id = "id";
        emit PaymentReceived(id, amount);
        taxOffice.pay{value: amount}(id);
    }

    function test_ExpectEmit_PaymentWithdrawn() public {
        vm.prank(address(1));
        vm.deal(address(taxOffice), 1 ether);
        vm.expectEmit(true, true,false,true);
        uint amount = 1000;
        emit PaymentWithdrawn(address(1), amount);
        taxOffice.withdraw(amount);
    }
}
