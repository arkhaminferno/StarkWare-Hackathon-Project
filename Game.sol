pragma solidity ^0.5.2;

contract Beacon{
    function getLatestRandomness() external view returns (uint256, bytes32) { }
}

contract Game {
    
//=============================================================================

// Variables Declaration

//=============================================================================

    //owner's address
    address payable owner;
    
    // Pausable Contract
    bool isContractPaused;
    
    // rng contract's address    
    address public  BeaconContractAddress = 0x79474439753C7c70011C3b00e06e559378bAD040;
    
    // Number of Contests happened
    uint public gameCounter = 1;
    
    //total amount staked for a contest
    
    mapping(uint=>uint) public stakedAmountforContest; 
    
    // User Balance Check 
    mapping(address=>uint) public UserDetails;
    
    // check winner for a specific game 
    mapping(uint=>address) public winnerForaGame; 
    
    // Bet Details for a specific contest
    mapping(uint=>BetDetail[]) public BetDetails;
    
    // lock timestamp
    uint locktimestamp;
    
    
    // Bet Detail Struct
    struct BetDetail  {
        address payable userAddress;
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
    
    
    constructor() public payable{
        owner = msg.sender;
        locktimestamp = now;
    }
    

//=============================================================================

// Modifiers Declaration

//=============================================================================
    modifier onlyOwner(){
    require(msg.sender == owner);
        _;
    }
    
    modifier timestampCheck(){
        require(now > locktimestamp);
        isContractPaused = false;
        _;
        
    }
   

//=============================================================================

// Function Declaration

//=============================================================================
    
    
     
   /** @dev Store some ether into the bankRollBalance
    */ 
   
   function depositInBankRoll() public payable onlyOwner {
       require(isContractPaused == false);
       require(msg.value != 0 ether);
   }
   
    
   /** @dev Check Bankroll Balance
    */ 
   
   function bankRollBalance() public view onlyOwner returns(uint) {
       return address(this).balance;
   }
   
    
   /** @dev Checking whether user already exists on the game or not
    */ 
    
   function checkBet(uint contestNumber,uint choosennum) internal view returns(bool success){
       require(isContractPaused == false);
       for(uint i=0;i<BetDetails[contestNumber].length;i++){
           if(BetDetails[contestNumber][i].numberChoosen == choosennum){
               return false;
               revert("Someone already Choosed this number");
           }
           else{
               return true;
           }
       }
   }
   
   
     /** @dev Set Beacon Contract's Address
    */ 
    
   function setBeaconContractAddress(address _address) public onlyOwner {
       BeaconContractAddress = _address;
   }
   
   
     /** @dev Generate Random Number using Beacon Contract
    */ 
    
   function generateRandomNumber() public view returns (uint) {
       uint blockNumber;
       bytes32 randomNumber;
       Beacon beacon = Beacon(BeaconContractAddress);
       (blockNumber,randomNumber) = beacon.getLatestRandomness();
       return uint(randomNumber);
       
   }
   
   /** Picking Winner by checking bet Details 
    */
    function pickWinner(uint randomNumber,uint currentGameCounter) internal  returns(address winner) {
        for(uint i=0;i<BetDetails[currentGameCounter].length;i++){
            if(BetDetails[currentGameCounter][i].numberChoosen == randomNumber){
                gameCounter++;
                return BetDetails[currentGameCounter][i].userAddress;
            }
            else{
                revert("No one has bet on this number");
            }
        }
    }
   
     /** @dev Bet Amount 
    */ 
   
   function bet(uint choosenNumber ) payable public timestampCheck returns (bool success){
       require(isContractPaused == false,"Contract is paused please try again in some time");
       
       require(choosenNumber>=0 && choosenNumber<=9,"Please Choose Number Between 0 and 9!");
       require(msg.value == 0.1 ether , "Please Enter Amount equal to 0.1 ether");
      
       require(checkBet(gameCounter,choosenNumber) == true);
       
       BetDetail memory  newBet;
       newBet.userAddress = msg.sender;
       newBet.numberChoosen = choosenNumber;
       newBet.betAmount  = msg.value;
       
       BetDetails[gameCounter].push(newBet);
       
       delete newBet;
       
       
       emit depositMade(msg.sender,msg.value,choosenNumber);
       
       
       if(BetDetails[gameCounter].length == 10){
           uint generatedNumber = generateRandomNumber();
           uint lastDigitofGeneratedNumber = generatedNumber%10;
            address winner = pickWinner(lastDigitofGeneratedNumber,gameCounter);
       
       winnerForaGame[gameCounter] = winner;
       UserDetails[winner] += 0.7 ether;
       owner.transfer(0.3 ether);
       gameCounter++;
       locktimestamp = now + 1 hours;
       isContractPaused = true;
       return true;
           
       }
       return true;
     

      
       
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
   
   
   function PauseContract() public onlyOwner returns(bool success){
       isContractPaused = true;
       return true;
   }
    
    
    function unPauseContract() public onlyOwner returns(bool success){
        isContractPaused =false;
        return true;
    }
    
    
}
