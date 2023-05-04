// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//import "remix_tests.sol"; // This import is required for Remix testing
import "../contracts/ChainTrack.sol"; // Adjust the path to your ChainTrack.sol file

contract ChainTrackTest {
    ChainTrack chainTrack;

    // Deploy a new ChainTrack contract before each test
    function beforeEach() public {
        chainTrack = new ChainTrack();
    }

    // Test creating a new material
    function testCreateMaterial() public {
        chainTrack.setUserRole(address(this), ChainTrack.Role.Manufacturer);
        chainTrack.createMaterial("Material 1");
        ChainTrack.Material memory material = chainTrack.materials(1);

        require(material.id == 1, "Material ID should be 1");
        require(material.description == "Material 1", "Material description should be 'Material 1'");
        require(uint(material.lastRole) == 0, "Material lastRole should be Manufacturer");
        require(material.lastVisited == address(this), "Material lastVisited should be the test contract address");
        require(material.currentDestination == address(this), "Material currentDestination should be the test contract address");

    }

    // function getMaterial(uint256 _id) public view returns (Material memory) {
    //     return materials[_id];
    // }

    // Test transferring a material to the next role
    function testTransferMaterial() public {
        chainTrack.setUserRole(address(this), ChainTrack.Role.Manufacturer);
        chainTrack.createMaterial("Material 1");
        chainTrack.setUserRole(address(0x1), ChainTrack.Role.Distributor);

        chainTrack.transferMaterial(1, address(0x1));
        ChainTrack.Material memory material = chainTrack.getMaterial(1);

        assert.equal(material.lastRole, 0, "Material lastRole should be Manufacturer");
        assert.equal(material.lastVisited, address(this), "Material lastVisited should be the test contract address");
        assert.equal(material.currentDestination, address(0x1), "Material currentDestination should be address(0x1)");
    }
}
