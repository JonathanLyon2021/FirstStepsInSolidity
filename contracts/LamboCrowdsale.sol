// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract LamboCrowdsale {

    address payable mainContract;
    address payable contractOwner;

    mapping(address => uint) balances;

    event MoneyReceived(address recipient, uint amount);


    constructor() payable public {
        mainContract = address(this);
        contractOwner = msg.sender;

        emit MoneyReceived(mainContract, msg.value);
    }

    function() payable external {
        emit MoneyReceived(msg.sender, msg.value);
    }

    modifier onlyOwner() {
        require(contractOwner == msg.sender, "Only Contract Owner is authorized");
        _;
    }


    function getContractBalance() public view onlyOwner returns (uint balance) {
        return address(this).balance;
    }

    function getSenderBalance() public view returns (uint balance) {
        return msg.sender.balance;
    }

    function deposit() public payable {

    //    This could also work if you wanted to do it this way...
    //    uint balance = 0;
    //    balance += msg.value;

        balances[msg.sender] = 0;
        balances[mainContract] += msg.value;
    }

    function getCommission() public onlyOwner {
        uint commission = (address(this).balance / 5);
        require(address(this).balance >= commission, "Sender does not have enough balance.");
        balances[msg.sender] = 0;
        emit MoneyReceived(msg.sender, commission);
        msg.sender.transfer(commission);
    }

/*    //General withdraw fxn; amount must be @least 1000000000000000 wei
    function withdraw(uint amount) public returns (bool) {
        require(amount < address(this).balance, "Withdrawal cannot be equal to Total Contract Balance");
        balances[msg.sender] = 0;
        msg.sender.transfer(amount);
        return true;
    }
*/
    function killContract(address payable designatedAddress) public onlyOwner {
        selfdestruct(designatedAddress);
    }

}