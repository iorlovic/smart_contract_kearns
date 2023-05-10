// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../contracts/ChainTrack.sol";

contract ChainTrackTest {
    ChainTrack chainTrack;

    // Deploy a new ChainTrack contract before each test
    function beforeEach() public {
        chainTrack = new ChainTrack();
    }

    struct MaterialStruct {
        uint id;
        string description;
        ChainTrack.Role lastRole;
        address lastVisited;
        address currentDestination;
    }

    // Test creating a new material
    function testCreateMaterial() public {
        chainTrack.setUserRole(address(this), ChainTrack.Role.Manufacturer);
        chainTrack.createMaterial("Material 1");
        ChainTrack.Material memory material = chainTrack.getMaterial(1);

        require(material.id == 1, "Material ID should be 1");
        require(keccak256(abi.encodePacked(material.description)) == keccak256(abi.encodePacked("Material 1")), "Material description should be 'Material 1'");
        require(material.lastRole == ChainTrack.Role.Manufacturer, "Material lastRole should be Manufacturer");
        require(material.lastVisited == address(this), "Material lastVisited should be the test contract address");
        require(material.currentDestination == address(this), "Material currentDestination should be the test contract address");
    }

    // Test transferring a material to the next role
    function testTransferMaterial() public {
        chainTrack.setUserRole(address(this), ChainTrack.Role.Manufacturer);
        chainTrack.createMaterial("Material 1");
        chainTrack.setUserRole(address(0x1), ChainTrack.Role.Distributor);

        chainTrack.transferMaterial(1, address(0x1));
        ChainTrack.Material memory material = chainTrack.getMaterial(1);

        require(material.lastRole == ChainTrack.Role.Manufacturer, "Material lastRole should be Manufacturer");
        require(material.lastVisited == address(this), "Material lastVisited should be the test contract address");
        require(material.currentDestination == address(0x1), "Material currentDestination should be address(0x1)");
    }
}
