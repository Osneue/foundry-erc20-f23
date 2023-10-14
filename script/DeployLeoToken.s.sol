// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {LeoToken} from "src/LeoToken.sol";

contract DeployLeoToken is Script {
    uint256 constant INITIAL_SUPPLY = 100 ether;

    function run() external returns (LeoToken, uint256) {
        vm.startBroadcast();
        LeoToken token = new LeoToken(INITIAL_SUPPLY);
        vm.stopBroadcast();
        return (token, INITIAL_SUPPLY);
    }
}
