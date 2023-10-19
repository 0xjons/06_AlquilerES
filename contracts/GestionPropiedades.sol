// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import "./CasaNFTBase.sol";

contract GestionPropiedades is CasaNFTBase {

    function crearCasa(
        string memory direccion,
        uint256 precio,
        uint256 area,
        uint256 habitaciones,
        uint256 banos,
        string memory descripcion,
        string memory imagenURI,
        DatosVenta memory datosVenta
    ) public onlyPropietario returns (uint256) {
        require(
            bytes(direccion).length > 0,
            "La direccion no puede estar vacia"
        );
        require(precio > 0, "El precio debe ser mayor que 0");
        require(area > 0, "El area debe ser mayor que 0");
        require(habitaciones > 0, "Debe tener al menos una habitacion");
        require(banos > 0, "Debe tener al menos un banno");
        require(
            bytes(descripcion).length > 0,
            "La descripcion no puede estar vacia"
        );
        require(
            bytes(imagenURI).length > 0,
            "El URI de la imagen no puede estar vacio"
        );

        _tokenIdCounter += 1;
        uint256 nuevoTokenId = _tokenIdCounter;

        _casas[nuevoTokenId] = Casa(
            direccion,
            precio,
            area,
            habitaciones,
            banos,
            descripcion,
            imagenURI,
            msg.sender, // propietario
            address(0), // Inquilino actual inicializado a dirección nula
            datosVenta
        );

        _safeMint(msg.sender, nuevoTokenId);
        return nuevoTokenId;
    }

    function getCasa(uint256 tokenId) public view returns (Casa memory) {
        return _casas[tokenId];
    }

    function setDireccion(uint256 tokenId, string memory direccion)
        public
        onlyTokenOwner(tokenId)
    {
        _casas[tokenId].direccion = direccion;
    }

    function setPrecio(uint256 tokenId, uint256 precio)
        public
        onlyTokenOwner(tokenId)
    {
        _casas[tokenId].precio = precio;
    }

    function setArea(uint256 tokenId, uint256 area)
        public
        onlyTokenOwner(tokenId)
    {
        _casas[tokenId].area = area;
    }

    function setHabitaciones(uint256 tokenId, uint256 nuevasHabitaciones)
        public
        onlyTokenOwner(tokenId)
    {
        _casas[tokenId].habitaciones = nuevasHabitaciones;
    }

    function setBanos(uint256 tokenId, uint256 nuevosBanos)
        public
        onlyTokenOwner(tokenId)
    {
        _casas[tokenId].banos = nuevosBanos;
    }

    function setDescripcion(uint256 tokenId, string memory nuevaDescripcion)
        public
        onlyTokenOwner(tokenId)
    {
        _casas[tokenId].descripcion = nuevaDescripcion;
    }

    function setImagenURI(uint256 tokenId, string memory nuevaImagenURI)
        public
        onlyTokenOwner(tokenId)
    {
        _casas[tokenId].imagenURI = nuevaImagenURI;
    }

    function setEnVenta(uint256 tokenId, bool enVenta)
        public
        onlyTokenOwner(tokenId)
    {
        _casas[tokenId].datosVenta.enVenta = enVenta;
    }

    function setTiempoMinimoAlquiler(
        uint256 tokenId,
        uint256 tiempoMinimoAlquiler
    ) public onlyTokenOwner(tokenId) {
        _casas[tokenId].datosVenta.tiempoMinimoAlquiler = tiempoMinimoAlquiler;
    }

    function setTiempoMaximoAlquiler(
        uint256 tokenId,
        uint256 tiempoMaximoAlquiler
    ) public onlyTokenOwner(tokenId) {
        _casas[tokenId].datosVenta.tiempoMaximoAlquiler = tiempoMaximoAlquiler;
    }

    function setFechaInicioAlquiler(
        uint256 tokenId,
        uint256 fechaInicioAlquiler
    ) public onlyTokenOwner(tokenId) {
        _casas[tokenId].datosVenta.fechaInicioAlquiler = fechaInicioAlquiler;
    }

    function setFechaFinAlquiler(uint256 tokenId, uint256 fechaFinAlquiler)
        public
        onlyTokenOwner(tokenId)
    {
        _casas[tokenId].datosVenta.fechaFinAlquiler = fechaFinAlquiler;
    }
}
