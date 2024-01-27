// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Openzeppelin contracts
import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155SupplyUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";

// Helper contracts
import "./helper/Strings.sol";

contract AstraNovaNFT is Initializable, ERC1155Upgradeable, OwnableUpgradeable, ERC1155PausableUpgradeable, ERC1155BurnableUpgradeable, ERC1155SupplyUpgradeable, ReentrancyGuardUpgradeable {
    
    mapping(address => bool) private _admins;

    modifier onlyAdmins() {
        require(_admins[msg.sender], "only admins");
        _;
    }
    
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() initializer public {
        __ERC1155_init("");
        __Ownable_init(msg.sender);
        __ERC1155Pausable_init();
        __ERC1155Burnable_init();
        __ERC1155Supply_init();
        _admins[msg.sender] = true;
    }

    function isAdmin(address _admin) public view returns(bool){
        return _admins[_admin];
    }

    function setAdmin(address _admin) external onlyOwner {
        _admins[_admin] = true;
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function uri(uint256 id) public view override returns (string memory) {
        string memory _uri = super.uri(id);
        return string(abi.encodePacked(_uri, "/", Strings.toString(id), ".json"));
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(address account, uint256 id, uint256 amount, bytes memory data)
        public
        onlyAdmins
    {
        _mint(account, id, amount, data);
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        public
        onlyAdmins
    {
        _mintBatch(to, ids, amounts, data);
    }

    // The following functions are overrides required by Solidity.

    function _update(address from, address to, uint256[] memory ids, uint256[] memory values)
        internal
        override(ERC1155Upgradeable, ERC1155PausableUpgradeable, ERC1155SupplyUpgradeable)
    {
        super._update(from, to, ids, values);
    }

    fallback() external payable {}

    receive() external payable {}

    uint256[50] private gap;
}
