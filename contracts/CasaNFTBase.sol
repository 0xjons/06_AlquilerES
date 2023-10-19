// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract CasaNFTBase is ERC721, ReentrancyGuard {
    uint256 internal _tokenIdCounter;


    address public goon;

    struct Casa {
        string direccion;
        uint256 precio;
        uint256 area;
        uint256 habitaciones;
        uint256 banos;
        string descripcion;
        string imagenURI;
        address propietario;
        address inquilinoActual;
        DatosVenta datosVenta;
    }

    struct DatosVenta {
        bool enVenta;
        uint256 tiempoMinimoAlquiler;
        uint256 tiempoMaximoAlquiler;
        uint256 fechaInicioAlquiler;
        uint256 fechaFinAlquiler;
    }

    mapping(uint256 => Casa) internal _casas;

    uint256 public tasaPropietario = 1 ether;

    mapping(address => bool) internal _propietarios;
    mapping(address => bool) internal _inquilinos;

    modifier onlyPropietario() {
        require(_propietarios[msg.sender], "Solo los propietarios pueden realizar esta operacion");
        _;
    }

    modifier onlyTokenOwner(uint256 tokenId) {
        require(ownerOf(tokenId) == msg.sender, "Solo el propietario del tokenId puede realizar esta operacion");
        _;
    }

    modifier onlyTenant() {
        require(_inquilinos[msg.sender], "Solo los inquilinos pueden realizar esta operacion");
        _;
    }

    modifier onlyGoon() {
        require(msg.sender == goon, "Solo el goon puede realizar esta operacion");
        _;
    }

    constructor() ERC721("CasaNFTBase", "CASA_BASE") {
        goon = msg.sender;
    }

    function _createToken() internal returns (uint256) {
        _tokenIdCounter += 1;
        return _tokenIdCounter;
    }
}
