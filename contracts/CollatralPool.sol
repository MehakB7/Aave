//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.5;

import "@aave/core-v3/contracts/interfaces/IPool.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract CollatralPool {
    IPool pool = IPool(0x7d2768dE32b0b80b7a3454c06BdAc94A69DDc7A9);
    IERC20 dai = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    IERC20 aDai = IERC20(0x028171bCA77440897B824Ca71D1c56caC55b68A3);

    uint depositAmount = 10000e18;
    address[] members;

    constructor(address[] memory _members) {
        members = _members;

        for (uint i = 0; i < members.length; i++) {
            dai.transferFrom(members[i], address(this), depositAmount);
        }
        uint balance = dai.balanceOf(address(this));
        dai.approve(address(pool), balance);
        pool.deposit(address(dai), balance, address(this), 0);
    }

    function withdraw() external {
        uint totalBalance = aDai.balanceOf(address(this));
        uint share = totalBalance / members.length;
        aDai.approve(address(pool), share);

        for (uint i = 0; i < members.length; i++) {
            pool.withdraw(address(dai), share, members[i]);
        }
    }

    function borrow(address asset, uint amount) external {
        pool.borrow(asset, amount, 1, 0, address(this));
        (, , , , , uint heathFactor) = pool.getUserAccountData(address(this));
        require(heathFactor > 2e18);
        IERC20(asset).transfer(msg.sender, amount);
    }

    function repay(address asset, uint amount) external {
        IERC20(asset).transferFrom(msg.sender, address(this), amount);
        IERC20(asset).approve(address(pool), amount);
        pool.repay(asset, amount, 1, address(this));
    }
}
