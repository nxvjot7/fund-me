// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

//this is a library, its purpose is to do maths and give us ethAmountInUSd

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

error PriceConverter__StalePrice();
error PriceConverter__InvalidPrice();

library PriceConverter {
    function getPrice(AggregatorV3Interface priceFeed) internal view returns (uint256) {
        (, int256 answer,, uint256 updatedAt,) = priceFeed.latestRoundData();

        if (answer <= 0) revert PriceConverter__InvalidPrice();
        if (block.timestamp - updatedAt > 3 hours) revert PriceConverter__StalePrice();

        return uint256(answer * 1e10);
    }

    // 1000000000
    function getConversionRate(uint256 ethAmount, AggregatorV3Interface priceFeed) internal view returns (uint256) {
        uint256 ethPrice = getPrice(priceFeed);
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
        // the actual ETH/USD conversion rate, after adjusting the extra 0s.
        return ethAmountInUsd;
    }
}
