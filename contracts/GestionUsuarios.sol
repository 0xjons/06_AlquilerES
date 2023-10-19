// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import "./CasaNFTBase.sol";

contract GestionUsuarios is CasaNFTBase {

    // Estructura para la reputación o calificaciones
    struct Reputacion {
        uint256 calificacionTotal;
        uint256 numeroCalificaciones;
    }

    mapping(address => Reputacion) reputaciones;
    mapping(address => uint256[]) historialDePropiedades;

    function agregarPropietario(address propietario) public payable {
        require(msg.value >= tasaPropietario, "El pago es insuficiente");
        require(!_propietarios[propietario], "El propietario ya esta registrado");
        require(propietario != address(0), "La direccion no puede ser 0x0");

        _propietarios[propietario] = true;
    }

    function agregarInquilino(address inquilino) public payable {
        require(msg.value == 0.05 ether, "El pago es insuficiente");
        require(!_inquilinos[inquilino], "El inquilino ya esta registrado");
        require(inquilino != address(0), "La direccion no puede ser 0x0");

        _inquilinos[inquilino] = true;
    }

    function removerInquilino(address inquilino) public onlyGoon {
        require(_inquilinos[inquilino], "El inquilino no esta registrado");
        _inquilinos[inquilino] = false;
    }

    function removerPropietario(address propietario) public onlyGoon {
        require(_propietarios[propietario], "El propietario no esta registrado");
        _propietarios[propietario] = false;
    }

    function actualizarPropietario(address propietarioAntiguo, address propietarioNuevo) public onlyGoon {
        require(_propietarios[propietarioAntiguo], "El propietario antiguo no esta registrado");
        require(!_propietarios[propietarioNuevo], "El propietario nuevo ya esta registrado");

        _propietarios[propietarioAntiguo] = false;
        _propietarios[propietarioNuevo] = true;
    }

    function actualizarInquilino(address inquilinoAntiguo, address inquilinoNuevo) public onlyGoon {
        require(_inquilinos[inquilinoAntiguo], "El inquilino antiguo no esta registrado");
        require(!_inquilinos[inquilinoNuevo], "El inquilino nuevo ya esta registrado");

        _inquilinos[inquilinoAntiguo] = false;
        _inquilinos[inquilinoNuevo] = true;
    }

    function listarPropietarios() public view returns (address[] memory) {
        // Esta funcion requeriría una estructura de datos mas compleja para almacenar y devolver todas las direcciones de propietarios.
        // Por simplicidad, no se implementa en esta versión.
    }

    function listarInquilinos() public view returns (address[] memory) {
        // Similar a listarPropietarios, requeriría una estructura de datos mas compleja.
    }

    function historialPropiedades(address usuario) public view returns (uint256[] memory) {
        return historialDePropiedades[usuario];
    }

    function calificarUsuario(address usuario, uint256 calificacion) public {
        require(calificacion <= 5 && calificacion >= 1, "Calificacion no valida");
        Reputacion storage rep = reputaciones[usuario];
        rep.calificacionTotal += calificacion;
        rep.numeroCalificaciones += 1;
    }

    function obtenerCalificacion(address usuario) public view returns (uint256) {
        if(reputaciones[usuario].numeroCalificaciones == 0) {
            return 0;
        }
        return reputaciones[usuario].calificacionTotal / reputaciones[usuario].numeroCalificaciones;
    }
}
