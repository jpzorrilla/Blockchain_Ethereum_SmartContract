/**
* Este código sirve para crear un registro de alumnos de una clase
*/

// SPDX-License-Identifier: MIT
pragma solidity  >=0.7.0 <0.9.0;

/**
* Contrato llamado 'Clase' que contiene una estructura de datos llamada 'Alumno'
*/
contract Clase {
    struct Alumno {
        string nombre;
        uint documento;
    }

/**
* Array público llamado 'Alumnos', lo que significa que se puede acceder a sus elementos desde fuera del contrato
*/ 
    Alumno[] public alumnos;

/**
* El constructor inicializa el array 'alumnos' con un elemento que tiene el nombre "Juan" y el núm. de documento 12345
*/
    constructor() {
        alumnos.push(Alumno({ nombre: "Juan", documento: 12345}));
    }
}