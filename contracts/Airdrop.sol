//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.5;
import { IAaveGateway, IAaveERC20 } from '@aave/protocol-v2/contracts/interfaces';



contract Escrow {
    address arbiter;
    address depositor;
    address beneficiary;
    uint initialBalance;
    
    IWETHGateway gateway = IAaveGateway(0xDcD33426BA191383f1c9B431A342498fdac73488);
    IERC20 aWETH = IAaveERC20(0x030bA81f1c18d280636F32af80b9AAd02Cf0854e);

    constructor(address _arbiter, address _beneficiary) payable {
        arbiter = _arbiter;
        beneficiary = _beneficiary;
        depositor = msg.sender;
        initialBalance =msg.value;

        gateway.depositETH{value: address(this).balance}(address(this), 0);
        
        
    }

    function approve() external {
    require(msg.sender == arbiter);
    aWETH.approve(0xDcD33426BA191383f1c9B431A342498fdac73488, uint(-1));
    gateway.withdrawETH(type(uint256).max, address(this));
    (bool s,)=beneficiary.call{value:initialBalance}("");
    require(s);
    selfdestruct(payable(depositor));
    
   


    }

    fallback() external payable {}
     receive() external payable {}
}
