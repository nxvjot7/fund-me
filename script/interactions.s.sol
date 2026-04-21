//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

//the purpose of this script is to interact with the most recently deployed FundMe contract, and fund it with 0.1 ether and then withdraw that fund

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script {
    uint constant SEND_VALUE = 0.1 ether; //send_value being set to 0.1 ether

    function run() public {  //when we call run() it automatically retrieves data of most recently deployed contract from broadcast folder
    address mostRecentlyDeployedFundMe = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid); //extracts latest data from /broadcast folder
      vm.startBroadcast(); 
    fundFundME(mostRecentlyDeployedFundMe); //callls fundFundME with that data it retrieved from broadcast folder
     vm.stopBroadcast();
   } 
   
   function fundFundME(address mostRecentlyDeployedFundMe) public { //asking for address of latest Deployed FundMe contract which is being passed from DeployFundMe.s.sol 
      FundMe(payable(mostRecentlyDeployedFundMe)).fund{value: SEND_VALUE}(); //that contract getts funded by calling fund function inside it and passing 0.1 ether;
      console.log("Funded FundME with %s", SEND_VALUE); //telling that we funded that latest last deployed fundME with 0.1 ether
    }
}


contract WithdrawFundMe is Script { //new contract for withdrawing funds

    function run() public { //when we call run() it automatically retrieves data of most recently deployed contract from broadcast folder
    address mostRecentlyDeployedFundMe = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
      withdrawFundMe(mostRecentlyDeployedFundMe); //passing that data to withdrawFundME function to withdraw data
   }

      function withdrawFundMe(address mostRecentlyDeployedFundMe) public { //asks for most recently deployed fundMe contract's address
        vm.startBroadcast();
      FundMe(payable(mostRecentlyDeployedFundMe)).withdraw(); //calling withdraw function of that contract, who's address was passed to this function
      vm.stopBroadcast();
    }

  

   }



