//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.5;
import "@aave/core-v3/contracts/interfaces/IPool.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract AavaDaiEscrow{
    address public depositor;
    address public beneficiary;
    address public arbiter;
    uint initialDeposit;

    IPool POOL = IPool("0xb13Cfa6f8B2Eed2C37fB00fF0c1A59807C585810");  //sepolia test network;
    IERC20 dai = IERC20("0x3e622317f8C93f7328350cF0B56d9eD4C620C5d6"); // sepolia test network;
    

  // dai assets 
  
    constructor( address _arbiter,address _beneficiary, uint _amount){
        beneficiary = _beneficiary;
        arbiter= _arbiter;
        initialDeposit = _amount;

        // we are considering that the depsitor approve it's dai to be spent by contract;
        dai.transferFrom(msg.sender, address(this), _amount);
        // now we want to transfer that amount to POOL 
        //Step 1: approve pool to tansfer money
        //Step2: pool to take dai from contract -> POOL 
        dai.approve(address(POOL), _amount);
        POOL.deposit(address(dai), _amount, address(this), 0);
    }

    function approve(){
        require(msg.sender === arbiter)
        // If  approve we will give inital amount of dai to beneficier 
        POOL.withdraw(address(dai),address(this), beneficiary, initialDeposit);
        POOL.withdraw(address(dai), address(this), address(this), type(int).max) 
    }

}