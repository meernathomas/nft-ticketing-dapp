// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// Import the secure OpenZeppelin contracts
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EventTicket is ERC721, Ownable {

    // 

    // using a simple uint256 for the counter.
    uint256 private _tokenIdCounter;

    uint256 public immutable ticketPrice;
    uint256 public immutable maxTickets;
    uint256 public immutable maxResalePrice;

    struct ResaleListing {
        bool isForSale;
        uint256 price;
        address seller;
    }

    mapping(uint256 => ResaleListing) public resaleListings;

    //Events 
    event TicketMinted(uint256 tokenId, address owner);
    event TicketListed(uint256 tokenId, uint256 price, address seller);
    event TicketSold(uint256 tokenId, uint256 price, address from, address to);

    /**
     * @dev The constructor runs ONCE on deployment.
     */
    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _price,
        uint256 _maxTickets
    )
        ERC721(_name, _symbol)
        Ownable(msg.sender)
    {
        ticketPrice = _price;
        maxTickets = _maxTickets;
        maxResalePrice = (_price * 150) / 100; // 1.5x original price
        
        //The first ticket minted will be ID 1.
        _tokenIdCounter = 0;
    }

    /**
     * @dev Mints a new ticket.
     */
    function mintTicket() public payable {
        uint256 currentSupply = _tokenIdCounter;
        
        require(currentSupply < maxTickets, "Sorry, this event is sold out.");
        require(msg.value == ticketPrice, "Incorrect ticket price.");

        _tokenIdCounter++;
        
        uint256 newItemId = _tokenIdCounter;
        
        _safeMint(msg.sender, newItemId);
        emit TicketMinted(newItemId, msg.sender);
    }

    /**
     * @dev Lists a ticket for resale.
     */
    function listTicketForSale(uint256 _tokenId, uint256 _price) public {
        require(ownerOf(_tokenId) == msg.sender, "You do not own this ticket.");
        require(_price <= maxResalePrice, "Price is above the 1.5x resale cap.");
        
        approve(address(this), _tokenId);
        resaleListings[_tokenId] = ResaleListing(true, _price, msg.sender);

        emit TicketListed(_tokenId, _price, msg.sender);
    }

    /**
     * @dev Buys a ticket from the resale market.
     */
    function buyResaleTicket(uint256 _tokenId) public payable {
        ResaleListing storage listing = resaleListings[_tokenId];

        require(listing.isForSale, "This ticket is not for sale.");
        require(msg.value == listing.price, "Incorrect price.");

        listing.isForSale = false;

        (bool success, ) = payable(listing.seller).call{value: msg.value}("");
        require(success, "Transfer to seller failed.");

        transferFrom(listing.seller, msg.sender, _tokenId);

        emit TicketSold(_tokenId, listing.price, listing.seller, msg.sender);
    }

    /**
     * @dev Allows the event organizer (owner) to withdraw funds.
     */
    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        (bool success, ) = payable(owner()).call{value: balance}("");
        require(success, "Withdraw failed.");
    }


    /**
     * @dev Returns the current total supply of tickets.
     */
    function currentSupply() public view returns (uint256) {
        // Just return the counter's value
        return _tokenIdCounter;
    }
}
