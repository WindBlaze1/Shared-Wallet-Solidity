pragma solidity >0.7.0 <0.9.0;

contract Owned{
    address public owner;
    constructor(){
        owner = msg.sender;
    }
    modifier onlyOwner {
        require(msg.sender==owner,'You are not Authorised to use this functionality!');
        _;
    }
}
