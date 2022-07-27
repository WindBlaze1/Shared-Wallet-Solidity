import './owned.sol';
import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol';

contract Allowance is Owned {
    event AllowanceChanged(address indexed _by, address indexed _of,uint _from, uint _to);

    mapping(address=>uint) public allowance;

    function changeAllowance(address _to, uint _value) onlyOwner public {
        emit AllowanceChanged(msg.sender,_to,allowance[_to],_value);
        allowance[_to] = _value;
    }

}

contract Wallet is Allowance{
    using SafeMath for uint;

    function funds() view public returns(uint){
        return (uint)(address(this).balance);
    }

    event DepositedFunds(address _by, uint _amount);
    event PaymentDone(address _to, uint _of);

    fallback() external payable {
        emit DepositedFunds(msg.sender,msg.value);
    }

    function withdraw(address payable _to, uint _amount) payable public {
        require(_amount<=address(this).balance,'Insufficient Funds. Try again with a smaller amount.');
        if(msg.sender==owner){
            emit PaymentDone(_to,_amount);
            _to.transfer(_amount);
            return;
        }

        require(allowance[msg.sender]>=_amount,'Amount exceeds the allowed withdrawal limit. Try again with a smaller amount.');
        emit PaymentDone(_to,_amount);
        emit AllowanceChanged(msg.sender,msg.sender,allowance[msg.sender],allowance[msg.sender]-_amount);
        allowance[msg.sender].trySub(_amount)
        _to.transfer(_amount);
        
    }
}
