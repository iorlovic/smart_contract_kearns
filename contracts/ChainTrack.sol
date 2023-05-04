// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ChainTrack {

    // Define roles
    enum Role { Manufacturer, Distributor, Retailer, Consumer }

    // Define a Material
    struct Material {
        uint256 id;
        string description;
        Role lastRole;
        address lastVisited;
        address currentDestination;
    }

    // Mapping of material ID to Material
    mapping(uint256 => Material) public materials;

    // Mapping of user addresses to roles
    mapping(address => Role) public users;

    // Material counter
    uint256 public materialCounter;

    // Events
    event MaterialCreated(uint256 id, string description);
    event MaterialMoved(uint256 id, address indexed from, address indexed to, Role fromRole, Role toRole);

    // Modifier to check if a user has a specific role
    modifier onlyRole(Role role) {
        require(users[msg.sender] == role, "You don't have the required role");
        _;
    }

    // Assign a role to a user
    function setUserRole(address user, Role role) public {
        users[user] = role;
    }

    // Create a new material
    function createMaterial(string memory description) public onlyRole(Role.Manufacturer) {
        materialCounter++;
        materials[materialCounter] = Material({
            id: materialCounter,
            description: description,
            lastRole: Role.Manufacturer,
            lastVisited: msg.sender,
            currentDestination: msg.sender
        });
        emit MaterialCreated(materialCounter, description);
    }

    // Add this function to ChainTrack.sol
    function getMaterial(uint256 _id) public view returns (Material memory) {
        return materials[_id];
    }



    // Transfer a material to the next role in the supply chain
    function transferMaterial(uint256 id, address to) public {
        require(materials[id].currentDestination == msg.sender, "Material not at your location");

        // Ensure the next role in the supply chain is valid
        Role currentRole = users[msg.sender];
        Role nextRole = users[to];
        require(
            (currentRole == Role.Manufacturer && nextRole == Role.Distributor) ||
            (currentRole == Role.Distributor && nextRole == Role.Retailer) ||
            (currentRole == Role.Retailer && nextRole == Role.Consumer),
            "Invalid role transfer"
        );

        // Update material details
        materials[id].lastRole = currentRole;
        materials[id].lastVisited = msg.sender;
        materials[id].currentDestination = to;

        emit MaterialMoved(id, msg.sender, to, currentRole, nextRole);
    }
}
