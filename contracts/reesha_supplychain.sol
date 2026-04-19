// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";

contract reesha_supplychain is Ownable {

    enum Role { Manufacturer, Distributor, Retailer, Customer }
    enum Status { Manufactured, InTransit, Delivered }

    struct Product {
        uint id;
        string name;
        string description;
        address currentOwner;
        Status status;
    }

    mapping(address => Role) public roles;
    mapping(uint => Product) public products;
    mapping(uint => address[]) public productHistory;

    uint public productCount;

    modifier onlyRole(Role _role) {
        require(roles[msg.sender] == _role, "Unauthorized role");
        _;
    }

    constructor() Ownable(msg.sender) {}

    // Assign roles (only contract owner)
    function assignRole(address user, Role role) public onlyOwner {
        roles[user] = role;
    }

    // Register product (Manufacturer only)
    function registerProduct(string memory name, string memory description)
        public
    {
        productCount++;

        products[productCount] = Product({
            id: productCount,
            name: name,
            description: description,
            currentOwner: msg.sender,
            status: Status.Manufactured
        });

        productHistory[productCount].push(msg.sender);
    }

    // Transfer product
    function transferProduct(uint productId, address newOwner)
        public
    {
        Product storage product = products[productId];

        require(product.currentOwner == msg.sender, "Not owner");

        product.currentOwner = newOwner;
        product.status = Status.InTransit;

        productHistory[productId].push(newOwner);
    }

    // Mark delivered
    function markDelivered(uint productId)
        public
    {
        Product storage product = products[productId];

        require(product.currentOwner == msg.sender, "Not owner");

        product.status = Status.Delivered;
    }

    // View product history
    function getProductHistory(uint productId)
        public
        view
        returns (address[] memory)
    {
        return productHistory[productId];
    }

    // View product details
    function getProduct(uint productId)
        public
        view
        returns (Product memory)
    {
        return products[productId];
    }
}
