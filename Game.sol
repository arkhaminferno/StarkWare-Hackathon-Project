pragma solidity ^0.5.2;


contract Game {
    
//=============================================================================

// Variables Declaration

//=============================================================================

    //owner's address
    address owner;
    
    // rng contract's address    
    address BeaconContract;
    
    // Number of Contests happened
    uint public gameCounter;
    
    // User Balance Check 
    mapping(address=>uint) private UserDetails;
    
    // check winner for a specific game 
    mapping(uint=>address) public winnerForaGame; 
    
    // Bet Details for a specific contest
    mapping(uint=>BetDetail[]) public BetDetails;
    
    
    // Bet Detail Struct
    struct BetDetail {
        address userAddress;
        uint numberChoosen;
        uint betAmount;
    
    }
    
    
//=============================================================================

// Events Declaration

//=============================================================================
    
    event depositMade(address indexed ,uint amount,uint choosenNumber);
    
    event widthdrawMade(address indexed,uint amount);


//=============================================================================

// Constructor Declaration

//=============================================================================
    
    
    constructor() public{
        owner = msg.sender;
    }
    

//=============================================================================

// Modifiers Declaration

//=============================================================================
    modifier onlyOwner(){
    require(msg.sender == owner);
        _;
    }
    
   

//=============================================================================

// Function Declaration

//=============================================================================
    
    
     
   /** @dev Store some ether into the bankRollBalance
    * @param amount of ether
    */ 
   
   function depositInBankRoll() public payable onlyOwner {
       require(msg.value != 0 ether);
   }
   
    
   /** @dev Check Bankroll Balance
    */ 
   
   function bankRollBalance() public view onlyOwner returns(uint) {
       return address(this).balance;
   }
   
    
   /** @dev Checking whether user already exists on the game or not
    * @param contest Number
    * @param address of the user/better
    */ 
    
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
   
   
     /** @dev Set Beacon Contract's Address
    * @param Beacon Contract Address
    */ 
    
   function setBeaconContractAddress(address _address) public onlyOwner {
       BeaconContract = _address;
   }
   
   
     /** @dev Generate Random Number using Beacon Contract
    */ 
    
   function generateRandomNumber() internal returns (uint) {
       
       
   }
   
   
     /** @dev Bet Amount 
    * @param input number between 0 to 9
    * @param input amount of ether
    */ 
   
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
   
   
   
     /** @dev Withdraw Win Amount 
    */ 
   
   function withdraw() public returns (bool success){
       require(UserDetails[msg.sender] > 0 , "Whoops! You are trying to withdraw zero ETH");
       require(UserDetails[msg.sender]<address(this).balance,"Please try again, Bankroll is out of Balance");
       uint amount = UserDetails[msg.sender];
       UserDetails[msg.sender] = 0;
       msg.sender.transfer(amount);
       emit widthdrawMade(msg.sender ,amount);
       return true;
   }
   
   
    
    
    
    
    
}
