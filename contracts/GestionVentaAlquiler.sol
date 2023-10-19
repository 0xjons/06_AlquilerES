// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import "./CasaNFTBase.sol";

contract GestionVentaAlquiler is CasaNFTBase {

    function estaEnAlquiler(uint256 tokenId) public view returns (bool) {
        Casa memory casa = _casas[tokenId];
        require(casa.datosVenta.enVenta == false, "La casa NO esta en venta");
        return (block.timestamp >= casa.datosVenta.fechaInicioAlquiler &&
            block.timestamp <= casa.datosVenta.fechaFinAlquiler);
    }

    function alquilarCasa(
        uint256 tokenId,
        uint256 fechaInicio,
        uint256 fechaFin
    ) public payable onlyTenant {
        Casa storage casa = _casas[tokenId];

        require(
            msg.value >= casa.precio,
            "El valor enviado es menor que el precio de alquiler"
        );
        require(!casa.datosVenta.enVenta, "La casa esta en venta");
        require(
            !estaEnAlquiler(tokenId),
            "La casa ya esta alquilada en este periodo"
        );

        uint256 pagoPropietario = (msg.value * 97) / 100;
        payable(casa.propietario).transfer(pagoPropietario); // Transferir el 97% al propietario original

        casa.datosVenta.fechaInicioAlquiler = fechaInicio;
        casa.datosVenta.fechaFinAlquiler = fechaFin;
        casa.inquilinoActual = msg.sender;
    }

    function ponerEnVenta(uint256 tokenId) public onlyTokenOwner(tokenId) {
        require(
            !estaEnAlquiler(tokenId),
            "La casa esta en periodo de alquiler, no se puede poner en venta"
        );

        _casas[tokenId].datosVenta.enVenta = true;
        _casas[tokenId].datosVenta.fechaInicioAlquiler = 0;
        _casas[tokenId].datosVenta.fechaFinAlquiler = 0;
    }

    // Aquí puedes agregar más funciones relacionadas con la venta y alquiler si lo necesitas.
}
