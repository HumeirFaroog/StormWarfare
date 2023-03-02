// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Receiver.sol";

contract LootBoxNft is Ownable, ERC721, Pausable,  IERC721Receiver, ERC1155Receiver {
    using SafeERC20 for IERC20;
    using Counters for Counters.Counter;

    Counters.Counter private _boxCounter;

    string private baseTokenURI;
    IERC20 public token;
    IERC721 public nft;

    struct LootBox {
        address[] nftContracts;
        uint256[][] nftTokenIds;
        address[] ftContracts;
        uint256[][] ftTokenIds;
        uint256[][] ftTokenAmounts;
        address[] tokenContracts;
        uint256[] tokenAmount;
        bool isOpen;
    }

    LootBox[] public lootBoxes;

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _baseTokenURI
    ) ERC721(_name, _symbol) {
        baseTokenURI = _baseTokenURI;
    }

    function currentSupply() public view returns (uint256) {
        return _boxCounter.current();
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseTokenURI;
    }

    function tokenURI() public view virtual returns  (string memory) {
        return _baseURI();
    }

    function setBaseURI(string memory _baseTokenURI) external onlyOwner {
        baseTokenURI = _baseTokenURI;
    }

    function isOpen(uint256 _boxId) public view returns (bool) {
        return lootBoxes[_boxId].isOpen;
    }

    function createLootBox(
        address _to,
        address[] memory nftContracts,
        uint256[][] memory nftTokenIds,
        address[] memory ftContracts,
        uint256[][] memory ftTokenIds,
        uint256[][] memory ftTokenAmounts,
        address[] memory tokenContracts,
        uint256[] memory tokenAmount
    ) external onlyOwner {

        for(uint i = 0; i < nftContracts.length; i++) {
            IERC721 _nft = IERC721(nftContracts[i]);
            for(uint j = 0; j < nftTokenIds[i].length; j++) {
                _nft.safeTransferFrom(msg.sender, address(this), nftTokenIds[i][j]);
            }
        }

        for(uint i = 0; i < ftContracts.length; i++) {
            IERC1155 _ft = IERC1155(ftContracts[i]);
            _ft.safeBatchTransferFrom(msg.sender, address(this), ftTokenIds[i], ftTokenAmounts[i], "");
        }

        for(uint i = 0; i < tokenContracts.length; i++) {
            IERC20 _token = IERC20(tokenContracts[i]);
            _token.safeTransferFrom(msg.sender, address(this), tokenAmount[i]);
        }

        uint256 _boxId = _boxCounter.current();
        _boxCounter.increment();

        LootBox memory _lootBox = LootBox(
            nftContracts,
            nftTokenIds,
            ftContracts,
            ftTokenIds,
            ftTokenAmounts,
            tokenContracts,
            tokenAmount,
            false
        );
        lootBoxes.push(_lootBox);
        _safeMint(_to, _boxId);
    }

    function openLootBox(uint256 _boxId) external {
        require(lootBoxes[_boxId].isOpen == false, "LootBox is already open.");
        require(ownerOf(_boxId) == msg.sender, "You are not the owner of this LootBox.");

        lootBoxes[_boxId].isOpen = true;
        address[] memory nftContracts = lootBoxes[_boxId].nftContracts;
        uint256[][] memory nftTokenIds = lootBoxes[_boxId].nftTokenIds;
        address[] memory ftContracts = lootBoxes[_boxId].ftContracts;
        uint256[][] memory ftTokenIds = lootBoxes[_boxId].ftTokenIds;
        uint256[][] memory ftTokenAmounts = lootBoxes[_boxId].ftTokenAmounts;
        address[] memory tokenContracts = lootBoxes[_boxId].tokenContracts;
        uint256[] memory tokenAmount = lootBoxes[_boxId].tokenAmount;

        for(uint i = 0; i < nftContracts.length; i++) {
            IERC721 _nft = IERC721(nftContracts[i]);
            for(uint j = 0; j < nftTokenIds[i].length; j++) {
                _nft.safeTransferFrom(address(this), msg.sender, nftTokenIds[i][j]);
            }
        }

        for(uint i = 0; i < ftContracts.length; i++) {
            IERC1155 _ft = IERC1155(ftContracts[i]);
            _ft.safeBatchTransferFrom(address(this), msg.sender, ftTokenIds[i], ftTokenAmounts[i], "");
        }

        for(uint i = 0; i < tokenContracts.length; i++) {
            IERC20 _token = IERC20(tokenContracts[i]);
            _token.safeTransfer(msg.sender, tokenAmount[i]);
        }
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
    internal
    whenNotPaused
    ()
    {
        super._beforeTokenTransfer(from, to, tokenId, 0);
    }

    // The following functions are overrides required by Solidity.

    function supportsInterface(bytes4 interfaceId)
    public
    view
    override(ERC721, ERC1155Receiver)
    returns (bool)
    {
        return interfaceId == type(IERC1155Receiver).interfaceId || super.supportsInterface(interfaceId);
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external pure override returns(bytes4) {
        return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
    }

    function onERC1155Received(
        address,
        address,
        uint256,
        uint256,
        bytes calldata
    ) external pure override returns (bytes4) {
        return bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"));
    }

    function onERC1155BatchReceived(
        address,
        address,
        uint256[] calldata,
        uint256[] calldata,
        bytes calldata
    ) external pure override returns (bytes4) {
        return bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"));
    }
}