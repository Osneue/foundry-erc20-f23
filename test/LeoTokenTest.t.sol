// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {DeployLeoToken} from "script/DeployLeoToken.s.sol";
import {LeoToken} from "src/LeoToken.sol";

contract LeoTokenTest is Test {
    LeoToken public token;
    uint256 public initialSupply;
    uint256 public transferAmount;
    address public owner;
    address public recipient = makeAddr("recipient");
    uint256 constant DECIMALS = 18;

    function setUp() public {
        DeployLeoToken deployer = new DeployLeoToken();
        (token, initialSupply) = deployer.run();
        owner = msg.sender;
        transferAmount = initialSupply / 2;
    }

    function test_tokenNameIsLeo() public {
        assertEq(token.name(), "Leo");
    }

    function test_tokenSymbolIsLEO() public {
        assertEq(token.symbol(), "LEO");
    }

    function test_tokenDecimalsAre18() public {
        assertEq(token.decimals(), DECIMALS);
    }

    function test_initialTotalSupply() public {
        assertEq(token.totalSupply(), initialSupply); // Assuming an initial supply of 1,000,000 LEO
    }

    function test_balanceOfOwner() public {
        assertEq(token.balanceOf(owner), initialSupply); // Owner's initial balance
    }

    function test_transfer() public {
        uint256 amount = transferAmount; // Amount to transfer
        vm.prank(owner);
        token.transfer(recipient, amount);
        assertEq(token.balanceOf(owner), initialSupply - amount); // Owner's balance after transfer
        assertEq(token.balanceOf(recipient), amount); // Recipient's balance after transfer
    }

    function test_transferFrom() public {
        uint256 amount = initialSupply;
        address spender = recipient;
        vm.prank(owner);
        token.approve(spender, amount);
        vm.prank(spender);
        token.transferFrom(owner, spender, amount);
        assertEq(token.balanceOf(owner), initialSupply - amount); // Owner's balance after transfer
        assertEq(token.balanceOf(spender), amount); // Recipient's balance after transfer
    }

    function test_allowance() public {
        uint256 amount = initialSupply;
        address spender = recipient;
        vm.prank(owner);
        token.approve(spender, amount);
        assertEq(token.allowance(owner, spender), amount); // Allowance granted by owner
    }
}
