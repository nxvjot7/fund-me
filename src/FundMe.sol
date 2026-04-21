// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

error FundMe__NotOwner(); //creating custom error

contract FundMe {
    using PriceConverter for uint256; //uint256 have all functions of PriceConvertor.sol

    mapping(address => uint256) private s_addressToAmountFunded; //mapping of address to amount
    address[] private s_funders; //array of (storage)funders

    address private immutable i_owner; /*owner of contract, immutable cannot be changed after deployment */
    uint256 public constant MINIMUM_USD = 5e18; // 5e18 == 5,000,000,000,000,000,000 which is gwei value for 5 ether
    AggregatorV3Interface public s_priceFeed; // pricefeed variable in storage

    constructor(address priceFeed) {
        //asking for pricefeed address even before deployment of contract
        i_owner = msg.sender; //setting owner as the one who deploys the contract
        s_priceFeed = AggregatorV3Interface(priceFeed); // //storing pricefeed in storage variable
    }

    function fund() public payable {
        require(msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD, "You need to spend more ETH!"); //calling getConversionRate() of PriceConvertor.sol and passing msg.value as first parameter and pricefeed as second parameter
        s_addressToAmountFunded[msg.sender] += msg.value; //setting msg.sender as key and msg.value as value in mapping, adding msg.value if he already have some funds in mapping (incase)
        s_funders.push(msg.sender); //pushing funder to array
    }

    function getVersion() public view returns (uint256) {
        return s_priceFeed.version(); //calling version, returns version() function's output
    }

    modifier onlyOwner() {
        //seting onlyOwner modifier because we have to use this alot of time, its better to use modifier than writing this condition again and again in all the code
        if (msg.sender != i_owner) revert FundMe__NotOwner(); //if msg.sender is not i_owner then revert and throw this custom error.
        _; //start piece of code from here, if not reverted by above condition
    }

    function withdrawCheaper() public onlyOwner {
        uint256 fundersLength = s_funders.length; //

        for (
            uint256 funderIndex = 0; //Reading from storage after each loop is expensive, so we stored it in a memory variable and the loop reads from it only once and stores it in stack (temp storage) which saves gas
            funderIndex < fundersLength;
            funderIndex++
        ) {
            address funder = s_funders[funderIndex]; //going through each index of funders array and storing address it gives in in funder through each iteration
            s_addressToAmountFunded[funder] = 0; //clearing the amount that funder funded
        }

        s_funders = new address[](0); //overwriting array with new empty
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}(""); //this contract's all balance being transfer to msg.sender (owner)
        require(callSuccess, "Call failed"); //revert everything above incase failed
    }

    function withdraw() public onlyOwner {
        for (uint256 funderIndex = 0; funderIndex < s_funders.length; funderIndex++) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);
        // // transfer
        // payable(msg.sender).transfer(address(this).balance);

        // // send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");

        // call
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }
    // Explainer from: https://solidity-by-example.org/fallback/
    // Ether is sent to contract
    //      is msg.data empty?
    //          /   \
    //         yes  no
    //         /     \
    //    receive()?  fallback()
    //     /   \
    //   yes   no
    //  /        \
    //receive()  fallback()

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }

    function GetAddressToAmountFunded(address FundingAddress) external view returns (uint256) {
        return s_addressToAmountFunded[FundingAddress];
    }

    function GetFunders(uint256 index) external view returns (address) {
        return s_funders[index];
    }

    function GetOwner() external view returns (address) {
        return i_owner;
    }
}

// Concepts we didn't cover yet (will cover in later sections)
// 1. Enum
// 2. Events
// 3. Try / Catch
// 4. Function Selector
// 5. abi.encode / decode
// 6. Hash with keccak256
// 7. Yul / Assembly
