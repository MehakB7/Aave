//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.5;

import "@aave/core-v3/contracts/interfaces/IPool.sol"
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


// to purshase ticket we are using dai stable coin
// and to earn interest we are using ava liquidity pool
// we will draw the winner after 7 days
// user need to allow contract to able to transfer money from there account so user need
// to approve Dai contract ;

contract InterestLottartAava{
    uint drawing;
    uint ticketPrice = 100e18;

    mapping (address=> bool) players;

    IPool pool = IPool("0x7d2768dE32b0b80b7a3454c06BdAc94A69DDc7A9");
    IERC20 dai = IERC20("0x6B175474E89094C44Da98b954EedeAC495271d0F");

   event Winner(address winner);


     constructor(){
        drawing = block.timestamp + 7 days;
     }

// A user can purchase one ticket at max
     function purchase() external{
        require(!player[msg.sender]);
        dai.transferFrom(msg.sender, address(this), ticketPrice);
        player[msg.sender] =true;
        dai.approve(pool, ticketPrice);
        pool.deposit(address(this), ticketPrice, address(this), 0);


     }

     function pickWinner() external{

     }



}