//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

//the purpose of this HelperConfig.s.sol is to detect which network we are using and store pricefeed address of that network inside ActiveNetworkConfig sturct inside {pricefeed : 0xifh92i9ruif}

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "test/mock/MockV3Aggregator.sol";

contract HelperConfig is Script {
    NetworkConfig public ActiveNetworkConfig; //ActiveNetworkConfig is a struct state variable
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    struct NetworkConfig {
        address priceFeed;
    }

    constructor() {
        if (block.chainid == 11155111) {
            ActiveNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 1) {
            ActiveNetworkConfig = getEthMainnetConfig();
        } else {
            ActiveNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return sepoliaConfig;
    }

    function getEthMainnetConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory EthMainnetConfigConfig =
            NetworkConfig({priceFeed: 0xEe9F2375b4bdF6387aa8265dD4FB8F16512A1d46});
        return EthMainnetConfigConfig;
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        if (ActiveNetworkConfig.priceFeed != address(0)) {
            return ActiveNetworkConfig;
        }

        vm.startBroadcast(); // Added ()
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();

        // Removed 'new' and fixed 'priceFeed' casing
        NetworkConfig memory anvilConfig = NetworkConfig({priceFeed: address(mockPriceFeed)});
        return anvilConfig;
    }
}

