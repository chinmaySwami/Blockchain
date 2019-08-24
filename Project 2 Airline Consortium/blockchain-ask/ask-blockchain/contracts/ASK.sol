pragma solidity ^0.5.0;

// response = 0 --> initiated
// response = 1 --> Confirmed
// response = 2 --> Declined
contract ASK {

    struct Airline {
        bool isActive;
        bool isChairperson;
    }

    struct Transaction {
        address toAirline;
        uint hashedData;
        uint price;
        uint response;
        uint noOfSeats;
    }
    address chairpersonAddress;
    uint constant membershipFees = 50 ether;
    mapping(address => Airline) airlines;
    mapping(address => Transaction) transaction;
    uint x;
    modifier isUserAlreadyRegistered(address _userAdd) {
        require(
            airlines[_userAdd].isActive == true,
            "Sorry the user is not registered"
        );
        _;
    }

    modifier isUserAlreadyUnRegistered(address _userAdd) {
        require(
            airlines[_userAdd].isActive == false,
            "Sorry the user is already registered"
        );
        _;
    }

    modifier isHeChairperson(){
        require(
            msg.sender == chairpersonAddress,
            "The user is not a chairperson"
        );
        _;
    }

    modifier membershipFeesCheck(uint _value){
        require(
            _value > 49 ether,
            "The value should be atleast 50 ether"
            );
        _;
    }

     modifier amountTransferredCheck(uint _price){
        require(
            msg.value == _price,
            "The amount being transferred doesnt match the transaction amount"
            );
        _;
    }

    //function() payable external   {

   // }

    constructor() public{
       chairpersonAddress = msg.sender;
        airlines[chairpersonAddress].isActive = true;
        airlines[chairpersonAddress].isChairperson = true;
    }

    function registerMember() public payable isUserAlreadyUnRegistered(msg.sender){
        airlines[msg.sender].isActive = true;
        airlines[msg.sender].isChairperson = false;
        //uint finalFees = msg.value + membershipFees;
        address(uint160(chairpersonAddress)).transfer(msg.value);
        //chairpersonAddress.call.value(membershipFees);
    }

    function unregisterUser(address _userAddress) public payable isHeChairperson isUserAlreadyRegistered(_userAddress) {
        airlines[_userAddress].isActive = false;
        address(uint160(_userAddress)).transfer(msg.value);
    }

    function request(string memory _date, string memory _toCity, string memory _fromCity, uint _response,uint _noSeats) public payable isUserAlreadyRegistered(msg.sender) {
        uint hashedValues = uint(keccak256(abi.encodePacked(_date,_toCity,_fromCity)));
        _request(hashedValues,_response,_noSeats);
    }

    function _request( uint _hashedData,uint _response,uint _noSeats) private  isUserAlreadyRegistered(msg.sender) {
        transaction[msg.sender].hashedData = _hashedData;
        transaction[msg.sender].price = msg.value;
        transaction[msg.sender].response = _response;
        transaction[msg.sender].noOfSeats = _noSeats;
    }
    function response(address _toAirline,uint _response) public payable isUserAlreadyRegistered(msg.sender) {
        transaction[msg.sender].toAirline = _toAirline;
        transaction[msg.sender].price = msg.value;
        transaction[msg.sender].response = _response;
        settlePayment(_toAirline);
    }
    function settlePayment(address _toAirline) public payable isUserAlreadyRegistered(msg.sender) amountTransferredCheck(msg.value) {
        address(uint160(_toAirline)).transfer(msg.value);
    }
    function getBalance(address _addr) public view returns(uint) {
        return(address(_addr).balance);
    }
}
