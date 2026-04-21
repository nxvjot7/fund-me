pragma solidity ^0.8.18;

//this is a integration test

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/interactions.s.sol";


contract FundMeTestIntegration is Test{
    FundMe fundMe; //creating a variable of type FundMe 
address USER = makeAddr("user"); //creating a fake address and storing it in USER variable
uint256 constant SEND_VALUE = 0.1 ether; //SEND_VALUE now means 0.1 ether
uint256 constant STARTING_VALUE = 10 ether; //STARTING_VALUE now means 10 ether
uint256 constant GAS_PRICE = 1; //GAS PRICE now means 1  (Assume it as 1 gwei for easy calculation)


function setUp() external { // Foundry test lifecycle: Snapshot state -> run setUp() -> execute test -> revert to snapshot (repeats for every test) same loop for next function test
    DeployFundMe deployFundMe = new DeployFundMe(); //creating a copy of DeployFundMe contract in memory and storing it in deployFundMe variable
    fundMe = deployFundMe.run(); //calling run function of DeployFundMe contract to deploy FundMe contract and storing the address of deployed FundMe contract in fundMe variable that we declared above in the storage
    vm.deal(USER, STARTING_VALUE); //GIVING USER address 10 ether balance to start with
}

function testUsersCanFundInteractions() external {
    FundFundMe fundFundMe = new FundFundMe(); //creating copy of FundFundMe contract in memory and storing it in fundFundMe variable
 vm.deal(address(fundFundMe), SEND_VALUE); //giving 0.1 ether balance to fundFundMe contract, now funFundMe contract have 0.1 ether balance
    fundFundMe.fundFundME(address(fundMe)); //calling fundFundMe function inside of fundFundMe contract passing it address of fundMe contract
 
 
   WithdrawFundMe withdrawFundMe = new WithdrawFundMe(); //creating copy of WithdrawFundMe contract in memory and storing it in withdrawFundMe variable
    withdrawFundMe.withdrawFundMe(address(fundMe)); //calling withdrawFundMe function inside of WithdrawFundMe contract and passing it address of fundMe contract
   
  // address funder = fundMe.GetFunders(0); //getting the first funder from the funders array of FundMe contract and storing it in funder variable
    assert(address(fundMe).balance == 0); //checking if balance of fundMe contract is 0, if yes then test passed, if not then test failed
}
}