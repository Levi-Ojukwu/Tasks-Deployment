// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.3;

import {Script, console} from "forge-std/Script.sol";
import {SaveAsset} from "../src/SaveAsset.sol";

contract SaveAssetScript is Script {
    SaveAsset public saveAsset;

    function setUp() public {}

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        saveAsset = new SaveAsset(address(0x0)); // Example token address

        vm.stopBroadcast();
    }
}