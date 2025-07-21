// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract UserProfile {
    struct User {
        string name;
        uint age;
        string email;
        uint registrationTime;
    }

    mapping(address => User) private users;
    mapping(address => bool) private isRegistered;

    event UserRegistered(address indexed userAddress, string name, uint registrationTime);
    event ProfileUpdated(address indexed userAddress, string name, uint age, string email);

    modifier onlyRegistered() {
        require(isRegistered[msg.sender], "User is not registered");
        _;
    }

    function register(string calldata _name, uint _age, string calldata _email) external {
        require(!isRegistered[msg.sender], "User already registered");

        users[msg.sender] = User(_name, _age, _email, block.timestamp);
        isRegistered[msg.sender] = true;

        emit UserRegistered(msg.sender, _name, block.timestamp);
    }

    function updateProfile(string calldata _name, uint _age, string calldata _email) external onlyRegistered {
        User storage user = users[msg.sender];
        user.name = _name;
        user.age = _age;
        user.email = _email;

        emit ProfileUpdated(msg.sender, _name, _age, _email);
    }

    function getProfile(address _user) external view returns (
        string memory name,
        uint age,
        string memory email,
        uint registrationTime
    ) {
        require(isRegistered[_user], "User is not registered");

        User storage user = users[_user];
        return (user.name, user.age, user.email, user.registrationTime);
    }
}
