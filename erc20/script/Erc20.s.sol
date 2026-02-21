// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.3;

import {Script, console} from "forge-std/Script.sol";
import {ERC20} from "../src/erc20.sol";

contract ERC20Script is Script {
    ERC20 public erc20;

    function setUp() public {}

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        erc20 = new ERC20();

        vm.stopBroadcast();
    }
}