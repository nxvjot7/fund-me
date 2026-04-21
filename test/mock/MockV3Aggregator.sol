// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

//creating fake chainlink aggregator incase we are running it locally on anvil

/**
 * @title MockV3Aggregator
 * @notice Based on the FluxAggregator contract
 * @notice Use this contract when you need to test
 * other contract's ability to read data from an
 * aggregator contract, but how the aggregator got
 * its answer is unimportant
 */

contract MockV3Aggregator is AggregatorV3Interface {
    uint256 public constant version = 4; //setting version is 4, nothing logical just copying as latest version of real chainlink price feed is v4

    uint8 public decimals; 
    int256 public latestAnswer;
    uint256 public latestTimestamp;
    uint256 public latestRound;

    mapping(uint256 => int256) public getAnswer;
    mapping(uint256 => uint256) public getTimestamp;
    mapping(uint256 => uint256) private getStartedAt;

    constructor(uint8 _decimals, int256 _initialAnswer) { //asking for decimals and initial answer when we deploy this contract, which are being passed by helperconfig if it detects anvil chain it passes 8 to decimals and 2000e8 to initital price take it as (2000$)
        decimals = _decimals;
        updateAnswer(_initialAnswer); //calling updateAnswer to 
    }

    function updateAnswer(int256 _answer) public {
        latestAnswer = _answer; //2000e8 that we passed
        latestTimestamp = block.timestamp;
        latestRound++; //for now it become 1, increasing round by 1 whenever we update answer
        getAnswer[latestRound] = _answer;  //getAnswer[1] = 2000e8 just a mapping 
        getTimestamp[latestRound] = block.timestamp;
        getStartedAt[latestRound] = block.timestamp;
    }

    function updateRoundData(uint80 _roundId, int256 _answer, uint256 _timestamp, uint256 _startedAt) public {
        latestRound = _roundId;
        latestAnswer = _answer;
        latestTimestamp = _timestamp;
        getAnswer[latestRound] = _answer;
        getTimestamp[latestRound] = _timestamp;
        getStartedAt[latestRound] = _startedAt;
    }

    function getRoundData(uint80 _roundId)
        external
        view
        returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound)
    {
        return (_roundId, getAnswer[_roundId], getStartedAt[_roundId], getTimestamp[_roundId], _roundId);
    }

    function latestRoundData()
        external
        view
        returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound)
    {
        return (
            uint80(latestRound),
            getAnswer[latestRound],
            getStartedAt[latestRound],
            getTimestamp[latestRound],
            uint80(latestRound)
        );
    }

    function description() external pure returns (string memory) {
        return "v0.6/test/mock/MockV3Aggregator.sol";
    }
}