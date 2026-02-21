// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {SchoolManagement} from "../src/SchoolManagement.sol";

contract SchoolManagementScript is Script {
    SchoolManagement public schoolManagement;

    function run() public {
        vm.startBroadcast();

        address tokenAddress = 0xB6277C6760A7b2b60136a761F2a3e990d93cEAd8;
        schoolManagement = new SchoolManagement(tokenAddress);

        vm.stopBroadcast();
    }
}
