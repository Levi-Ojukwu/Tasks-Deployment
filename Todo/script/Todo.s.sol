// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.3;

import {Script, console} from "forge-std/Script.sol";
import {Todo} from "../src/Todo.sol";

contract TodoScript is Script {
    Todo public todo;

    function setUp() public {}

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        todo = new Todo();

        vm.stopBroadcast();
    }
}