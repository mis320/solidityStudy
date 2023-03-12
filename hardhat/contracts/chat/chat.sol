// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Chat {
    struct Message {
        address sender;
        string content;
    }
    
    Message[] public messages;
    
    function sendMessage(string memory _content) public {
        Message memory newMessage = Message(msg.sender, _content);
        messages.push(newMessage);
    }
    
    function getMessageCount() public view returns (uint256) {
        return messages.length;
    }
    
    function getMessage(uint256 _index) public view returns (address, string memory) {
        require(_index < messages.length, "Invalid message index");
        Message memory message = messages[_index];
        return (message.sender, message.content);
    }
}
