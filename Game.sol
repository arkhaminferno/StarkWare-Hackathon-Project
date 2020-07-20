pragma solidity ^0.5.2;


contract Game {
    address owner;
    uint gameCounter; // Number of matches happened
    
    constructor() public{
        owner = msg.sender;
    }
    
    
    
    modifier onlyOwner(){
    require(msg.sender == owner);
        _;
    }
    
   
    
    struct BetDetail {
        address userAddress;
        uint numberChoosen;
        uint betAmount;
    
    }
    
    
     
    mapping(address=>uint) private UserDetails;
    
    mapping(uint=>address) public winnerForaGame; // check who was the winner for a specific game
    
    mapping(uint=>BetDetail[]) public BetDetails;
    
    
    event depositMade(address indexed ,uint amount,uint choosenNumber);
    event widthdrawMade(address indexed,uint amount);
   
   
   function depositInBankRoll() public payable onlyOwner {
       require(msg.value != 0 ether);
   }
   
   
   function bankRollBalance() public view onlyOwner returns(uint) {
       return address(this).balance;
   }
   
   function checkBet(uint contestNumber,address better) internal returns(bool success){
       for(uint i=0;i<BetDetails[contestNumber].length;i++){
           if(BetDetails[contestNumber][i].userAddress == better){
               return false;
               revert("you have already participated this contest");
           }
           else{
               return true;
           }
       }
   }
   
   
   
   function bet(uint choosenNumber ) payable public {
       require(choosenNumber>=0 && choosenNumber<=9,"Please Choose Number Between 0 and 9!");
       require(msg.value >= 0.2 ether , "Please Enter Amount Greater than 0.2 ether");
       gameCounter++;
       require(checkBet(gameCounter,msg.sender) == true);
       
       BetDetail memory newBet;
       newBet.userAddress = msg.sender;
       newBet.numberChoosen = choosenNumber;
       newBet.betAmount = msg.value;
       
       BetDetails[gameCounter].push(newBet);
       delete newBet;
       
       /* TODO
       * random number generation logic
       */
       
       
       /* TODO
       * if number number of bets for a match has been full generate random number else not
       */
       
       /* TODO 
       * if user is the winner then store the winning amount into User structs
       */
       
       
   }
   
   function withdraw() public returns (bool success){
       require(UserDetails[msg.sender] > 0 , "Whoops! You are trying to withdraw zero ETH");
       require(UserDetails[msg.sender]<address(this).balance,"Please try again, Bankroll is out of Balance");
       uint amount = UserDetails[msg.sender];
       UserDetails[msg.sender] = 0;
       msg.sender.transfer(amount);
       return true;
   }
   
   
    
    
    
    
    
}
