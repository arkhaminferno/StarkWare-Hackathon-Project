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
    
    struct User{
        address userAddress;
        uint amountWon;
    }
    
    struct BetDetail {
        address userAddress;
        uint numberChoosen;
        uint betAmount;
    }
    
    mapping(address=>User) public userDetail;
    mapping(uint=>address) public winnerForaGame; // check who was the winner for a specific game
    
    mapping(uint=>BetDetail) public BetDetails;
    
    
    event depositMade(address indexed ,uint amount,uint choosenNumber);
    event widthdrawMade(address indexed,uint amount);
   
   
   function depositInBankRoll() public payable onlyOwner {
       require(msg.value != 0 ether);
   }
   
   
   function bankRollBalance() public view onlyOwner returns(uint) {
       return address(this).balance;
   }
   
   
   function bet(uint choosenNumber ) payable public {
       require(choosenNumber>=0 && choosenNumber<=9,"Please Choose Number Between 0 and 9!");
       require(msg.value >= 0.2 ether , "Please Enter Amount Greater than 0.2 ether");
       /* TODO 
       * check whether a user already in game or not 
        require(msg.sender,"You have already participated for the game");
       */
       gameCounter++;
       BetDetail memory newBet;
       newBet.userAddress = msg.sender;
       newBet.numberChoosen = choosenNumber;
       newBet.betAmount = msg.value;
       
       /* TODO
       * store bet details for the game in the Betdetails mapping
       and store user detials in the user struct as well
       * Betdetails[gameCounter] =   newBet;
       */
       
       
       
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
   
   function withdraw() public {
       /* TODO
       * check user Amount is greater than 0 or not in to the USer struct
       * check withdraw amount is lesser than bankroll's amount
       * if all conditiin satisfies then withdraw all the balance 
       */
   }
   
   
    
    
    
    
    
}