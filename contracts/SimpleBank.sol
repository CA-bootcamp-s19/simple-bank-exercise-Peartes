/*
    This exercise has been updated to use Solidity version 0.6.12
    Breaking changes from 0.5 to 0.6 can be found here: 
    https://solidity.readthedocs.io/en/v0.6.12/060-breaking-changes.html
*/

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.12;

contract SimpleBank {
    //
    // State variables
    //

    /* Fill in the keyword. Hint: We want to protect our users balance from other contracts*/
    mapping(address => uint256) private balances;

    /* Fill in the keyword. We want to create a getter function and allow contracts to be able to see if a user is enrolled.  */
    mapping(address => bool) public enrolled;

    /* Let's make sure everyone knows who owns the bank. Use the appropriate keyword for this*/
    address public owner;

    //
    // Events - publicize actions to external listeners
    //

    /* Add an argument for this event, an accountAddress */
    event LogEnrolled(address accountAddress);

    /* Add 2 arguments for this event, an accountAddress and an amount */
    event LogDepositMade(address accountAddress, uint256 amount);

    /* Create an event called LogWithdrawal */
    /* Add 3 arguments for this event, an accountAddress, withdrawAmount and a newBalance */
    event LogWithdrawal(
        address accountAdress,
        uint256 withdrawalAmount,
        uint256 newBalance
    );

    //
    // Functions
    //

    /* Use the appropriate global variable to get the sender of the transaction */
    constructor() public {
        /* Set the owner to the creator of this contract */
        owner = msg.sender;
    }

    // Fallback function - Called if other functions don't match call or
    // sent ether without data
    // Typically, called when invalid data is sent
    // Added so ether sent to this contract is reverted if the contract fails
    // otherwise, the sender's money is transferred to contract
    fallback() external payable {
        revert();
    }

    /// @notice Get balance
    /// @return The balance of the user
    // A SPECIAL KEYWORD prevents function from editing state variables;
    // allows function to run locally/off blockchain
    function getBalance() public view returns (uint256) {
        /* Get the balance of the sender of this transaction */
        return balances[msg.sender];
    }

    /// @notice Enroll a customer with the bank
    /// @return The users enrolled status
    // Emit the appropriate event
    function enroll() public returns (bool) {
        // Set the user as enrolled
        enrolled[msg.sender] = true;
        // Set the users balance to 0
        balances[msg.sender] = 0;
        // Emit an enrolled event
        emit LogEnrolled(msg.sender);
        // Return the user enrolled status
        return enrolled[msg.sender];
    }

    /// @notice Deposit ether into bank
    /// @return The balance of the user after the deposit is made
    // Add the appropriate keyword so that this function can receive ether
    // Use the appropriate global variables to get the transaction sender and value
    // Emit the appropriate event
    // Users should be enrolled before they can make deposits
    function deposit() public payable returns (uint256) {
        /* Add the amount to the user's balance, call the event associated with a deposit,
          then return the balance of the user */
        // Firt only enrolled users can deposit
        require(enrolled[msg.sender], "Only Enrolled users can deposit");
        // Let's add to the users account
        balances[msg.sender] += msg.value;
        // Let's log the event
        emit LogDepositMade(msg.sender, msg.value);
        // Let's return the value of the user
        return balances[msg.sender];
    }

    /// @notice Withdraw ether from bank
    /// @dev This does not return any excess ether sent to it
    /// @param withdrawAmount amount you want to withdraw
    /// @return The balance remaining for the user
    // Emit the appropriate event
    function withdraw(uint256 withdrawAmount) public returns (uint256) {
        /* If the sender's balance is at least the amount they want to withdraw,
           Subtract the amount from the sender's balance, and try to send that amount of ether
           to the user attempting to withdraw. 
           return the user's balance.*/

        // User must have enough money
        require(balances[msg.sender] >= withdrawAmount, "Insufficient Funds");

        // Let's first subtract the amount from the user balance
        balances[msg.sender] -= withdrawAmount;
        // Now let's log the event of transfer
        emit logWithdrawal(msg.sender, withdrwalAmount, balances[msg.sender]);
        // Now lets send the ether to the user
        return balances[msg.sender];
    }

    /// @notice Check if address is enrolled
    /// @return If the address is enrolled in the bank
    function checkEnrolled() public view returns (bool) {
        return enrolled[msg.sender] ? true : false;
    }
}
