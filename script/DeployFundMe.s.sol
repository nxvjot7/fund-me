//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

//the purpose of this DeployFundMe.s.sol script is to deploy HelperConfig(checks active network and gives its pricefeed) and stores it inside PriceUsdEth, and deploys FundMe and passes that pricefeed address to its constructor

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {

    function run() public returns (FundMe) {
        HelperConfig helperConfig = new HelperConfig(); //creating copy of HelperConfig contract in memory and storing it in helperConfig variable
       address PriceUsdEth = helperConfig.ActiveNetworkConfig(); //helperconfig contract runs it runs constructor and checks active networkconfig and stores pricefeed of that network in ActiveNetworkConfig.pricefeed;
           //PriceUsdETh = {pricefeed = 0xedfijfihfajfwjqf}


        vm.startBroadcast(); //  
        FundMe fundMe = new FundMe(PriceUsdEth); //creating a copy of FundMe which passes pricefeed to constructor of fundMe whenever it runs
        vm.stopBroadcast();// 
        return fundMe; //returning fundMe
    }
}