pragma solidity ^0.5.5;

contract Maketplace {
    
    struct user {
        uint balance;
        bool isValid;
        string userEmail;
        bool isChairperson;
    }
    struct product {
        string productName;
        bool isSold;
        uint productPrice;
    }
    
    mapping(address => user)  addressToUser;
    mapping(uint => address)  productToUser;

    product[] public products;
    
    bool private isChairpersonSelected = false;
    address private chairpersonAddress;
    
    modifier chairmanNotYetSelected(){
        require(
                isChairpersonSelected == false,
                "Task of nominating a chair person has already been completed"
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
    
    modifier isUserAllowedToBuySell() {
        require(
            addressToUser[msg.sender].isValid == true,
            "The user is not a valid user"
        );
        _;
    }
    
    modifier isProductAvailableForSelling(uint _id) {
        require(
            products[_id].isSold == false,
            "Sorry the product us no longer available"
        );
        _;
    }
    
    modifier isUserAlreadyRegistered(address _userAdd) {
        require(
            addressToUser[_userAdd].isValid == false,
            "Sorry the user is already registered"
        );
        _;
    }
    
    modifier isUserAlreadyUnRegistered(address _userAdd) {
        require(
            addressToUser[_userAdd].isValid == true,
            "Sorry the user is not registered"
        );
        _;
    }
    
    modifier doesUserHaveBalance (uint _prodID){
        require(
            addressToUser[msg.sender].balance >= products[_prodID].productPrice,
            "Sorry !! you do not have enough balance to buy the product"
        );
        _;
    }
    
    // This function wont go in final smart contract that will be deployed.
    function viewAddressDetails(uint _prodid) view public returns(address productOwnerAddress){
        return(productToUser[_prodid]);
    }
    
    function _addProductToSell(string memory _productName, uint _productPrice) private isUserAllowedToBuySell {
        product memory aProduct = product(_productName,false,_productPrice);
        uint productID = products.push(aProduct)-1;
        productToUser[productID] = msg.sender;
    }
    
    function Sell(string memory _productName, uint _productPrice) public isUserAllowedToBuySell{
        _addProductToSell(_productName,_productPrice);
    }
    
    function registerChairperson(string memory _email ) public chairmanNotYetSelected {
        user memory aUser = user(1000,true,_email,true);
        isChairpersonSelected = true;
        addressToUser[msg.sender] = aUser;
        chairpersonAddress = msg.sender;
    }
    
    function _createUser(string memory _email, address _address) private isHeChairperson{
        user memory aUser = user(500,true,_email,false);
        addressToUser[_address] = aUser;
    }
    
    function registerUser(string memory _userEmail, address _userAddress) public isHeChairperson 
    isUserAlreadyRegistered(_userAddress){
        _createUser(_userEmail, _userAddress);
    }
    
    function _unregisterUser(address _userAddress) private isHeChairperson {
        addressToUser[_userAddress].isValid = false;
    }
    
    function unregister(address _userAddress) public isHeChairperson isUserAlreadyUnRegistered(_userAddress){
        _unregisterUser(_userAddress);
    }
    
    function _settlePayment(address _sellAdd, uint _prodPrice, address _buyerAddress) private {
        addressToUser[_buyerAddress].balance = addressToUser[_buyerAddress].balance - _prodPrice;
        addressToUser[_sellAdd].balance = addressToUser[_sellAdd].balance + _prodPrice;
        
    }
   function _buyProduct(uint _prodID) private isUserAllowedToBuySell isProductAvailableForSelling(_prodID)
   doesUserHaveBalance (_prodID){
       address sellerAddress = productToUser[_prodID];
       uint productPrice = products[_prodID].productPrice;
       products[_prodID].isSold = true;
       productToUser[_prodID] = msg.sender;
       _settlePayment(sellerAddress, productPrice, msg.sender);
   }
   
   function buy(uint _productID) public {
       _buyProduct(_productID);
   }
   // This function wont go in final smart contract that will be deployed.
       function viewUserDetails(address _userAddress)  public view returns(uint balance,bool isValid,string memory userEmail, bool  isChairperson) {
        return (addressToUser[_userAddress].balance, addressToUser[_userAddress].isValid, addressToUser[_userAddress].userEmail,
        addressToUser[_userAddress].isChairperson);
    }
}   