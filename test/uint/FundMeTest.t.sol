//License Identifier: MIT
pragma solidity ^0.8.18;

//this is a uint test, purpose is to check each function is working perfect individually

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

//the purpose of this test is to check/test our fundMe contract before real deployment, so we can find flaws in our code 

contract FundMeTest is Test{

    FundMe fundMe;  //creating copy of FundMe contract in storage 
    address USER = makeAddr("user"); //making fake address for testing and storing it in USER variable
    uint256 SEND_VALUE = 2 ether; //SEND_VALUE now means 2 ether 
    uint256 STARTING_BALANCE = 10 ether; //STARTING_BALANCE now means 10 ether
    uint256 public constant GAS_PRICE = 1; //1 gwei

function setUp() external { // Foundry test lifecycle: Snapshot state -> run setUp() -> execute test -> revert to snapshot (repeats for every test) same loop for next function test
 DeployFundMe deployFundMe = new DeployFundMe(); //storing copy of DeployFundMe script in memory
 fundMe = deployFundMe.run(); // calling run function of DeployFundMe script (run function) to deploy FundMe contract and storing the address of deployed FundMe contract in fundme variable that we declared in storage above
 vm.deal(USER, STARTING_BALANCE); //CHEATCODE- GIVE USER STARTING BALANCE THAT WE SET ABOVE
    
}

function testthatminimumusdis5() external view{
assertEq(fundMe.MINIMUM_USD(), 5e18); //tests that fundMe.MINIMUM_USD variable is storing value same as 5e18, passes if equal, fails if not equal
}

function testOwnerisMsgSender() external view{
    assertEq(fundMe.GetOwner(), msg.sender); //calling GetOwner function of fundMe contract and checking if it is same as msg.sender now, passes if equal, fails if not equal
}

function testPriceFeedVersion() external view{
  uint version = fundMe.getVersion(); //calling GetVersion() from fundMe contract and storing its value in version variable
  console.log(version); //printing version in console
  assertEq(version, 4); //checks if version is equals to 4 (version == 4) , if yes then test passed, if not then test failed
}

function testFundsFailIfNotEnoughEth() external {
    vm.expectRevert(); //next function we exceute after declaring this should revert, if not reverted it'll fail the test
    fundMe.fund();// calling fund() from fundMe it'll fail cuz we are not sending any funds, so this test willl pass because it expected a revert here and revert happend
}

function testFundsUpdatesFundedDataStructure() public {
    vm.prank(USER); //TELLS TO SEND NEXT TX FROM THIS ADDRESS
    fundMe.fund{value: SEND_VALUE}(); //calling fund() of fundMe contract and sending 2 ether.

    uint256 amountFunded = fundMe.GetAddressToAmountFunded(USER);  //checking mapping of address(USER) how much value it have, and storing it in amountfunded variable
    assertEq(amountFunded, SEND_VALUE); //checking if amountFunded is equals to SEND_VALUE (2 ether), if yes then test passed, if not then test failed
}

function testAddsFunderstoFundersArray() public {

vm.prank(USER); //tells to send next transaction from USER address
fundMe.fund{value: SEND_VALUE}(); //funded by "USER" with 2 ether(SEND_VALUE)
address funder = fundMe.GetFunders(0); //checking array at zero index, and storing its address in funder variable
assertEq(funder , USER); //checking if funder is Same as USER, if yes then test passed, if not then test failed
}

modifier funded() { //modifier that automatically funds fund() from fundMe contract with 2 ether(SEND_VALUE) avoiding repititive coding
    vm.prank(USER); //tells to send next transaction from USER address
    fundMe.fund{value: SEND_VALUE}(); //funded by "USER" with 2 ether(SEND_VALUE)
    _; //next piece of code will execute from here
}

function testOnlyOwnerCanWithdraw() public funded {
vm.prank(USER); //telling to do next tx from USER address
vm.expectRevert(); //tells that next function should revert, if not then test will fail
fundMe.withdraw(); //trying to withdraw from USER address, IF USER is not owner so it'll revert, if USER is owner then it won't revert and test will fail because we expected a revert here
}

function testWithdrawWithASingleFunder() public funded {

//arrange
uint256 startingOwnerBalance = fundMe.GetOwner().balance; //storing starting balance of owner before withdraw happens
uint256 startingFundMeBalance = address(fundMe).balance; //storing balance of fundMe contract before withdraw happens

//Act
vm.prank(fundMe.GetOwner()); //telling to do next transaction from Owner's address
fundMe.withdraw(); //calling withdraw function from fundMe contract

//assert
uint256 endingOwnerBalance = fundMe.GetOwner().balance; //now storing balance of owner after withdraw happens
uint256 endingFundMeBalance = address(fundMe).balance; //now storing balance of fundMe contract after withdraw happens

assertEq(endingFundMeBalance, 0); //checking if ending balance of FundMeBalance is 0, if yes then test passed, if not then test failed
assertEq(startingFundMeBalance + startingOwnerBalance, endingOwnerBalance); // checking if starting fundmeBalance+startingOwnerBalance == endingOwnerbalance if yes then test passed, if not then test failed
}

function testWithdrawFromMultipleFunders() public funded {
    //arrange
uint160 numbersOfFunders = 10;
uint256 startingFunderIndex = 2;

for(uint256 i = startingFunderIndex; i < numbersOfFunders; i++){ //created a for loop to fund the contract from multiple addresses, starting from 2 because 0 and 1 are used in other tests, and we want to avoid confusion
hoax (address(uint160(i)), SEND_VALUE);
fundMe.fund{value: SEND_VALUE}();
}

uint256 startingOwnerBalance = fundMe.GetOwner().balance; //starting balance of owner before withdraw happens
uint256 startingFundMeBalance = address(fundMe).balance; //starting balance of fundMe contract before withdraw happens

//Act

vm.startPrank(fundMe.GetOwner()); //telling to do next tx from owner's address
fundMe.withdraw(); //calling withdraw function from fundMe contract to withdraw all funds
vm.stopPrank();  //telling to stop doing next tx from owner's address, now next tx will be from default address which is address(this) in this case


//assert
assert(address(fundMe).balance == 0); //checking if balance of fundMe contract is 0 after withdraw, if yes then test passed, if not then test failed
assert(startingFundMeBalance + startingOwnerBalance == fundMe.GetOwner().balance); //checking if starting fundmeBalance+startingOwnerBalance == endingOwnerbalance if yes then test passed, if not then test failed
}

function testWithdrawFromMultipleFundersCheaper() public funded { 
    //arrange
uint160 numbersOfFunders = 10;
uint256 startingFunderIndex = 2;

for(uint256 i = startingFunderIndex; i < numbersOfFunders; i++){
hoax (address(uint160(i)), SEND_VALUE);
fundMe.fund{value: SEND_VALUE}();
}

uint256 startingOwnerBalance = fundMe.GetOwner().balance;
uint256 startingFundMeBalance = address(fundMe).balance;

//Act

vm.startPrank(fundMe.GetOwner());
fundMe.withdrawCheaper(); //same as above just calling withdrawCheaper 
vm.stopPrank();


//assert
assert(address(fundMe).balance == 0);
assert(startingFundMeBalance + startingOwnerBalance == fundMe.GetOwner().balance);

}
}