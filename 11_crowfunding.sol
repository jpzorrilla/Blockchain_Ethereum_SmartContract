/**
* Contrato inteligente de Crowfunding que permite crear y fondear proyectos mediante contribuciones de los usuarios
*/

// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

/**
* Define un tipo enumerado fundRaisingState que tiene dos posibles valores: Opened y Closed.
* Este tipo se usa para indicar el estado de un proyecto, si está abierto o cerrado para recibir fondos.
*/
contract crowfunding {
    enum fundRaisingState { Opened, Closed }

/**
* Define una estructura Contribution que representa una contribución hecha por un usuario a un proyecto.
* Tiene dos campos: contributor, que es la dirección del usuario que hizo la contribución, y value, que es el valor en ether de la contribución.
*/
    struct Contribution {
        address contributor;
        uint value;
    }

/**
* Define una estructura Project que representa un proyecto creado por un usuario.
* Tiene los siguientes campos: id, que es un identificador único del proyecto;
* name, que es el nombre del proyecto;
* description, que es una breve descripción del proyecto;
* author, que es la dirección del usuario que creó el proyecto;
* state, que es el estado del proyecto según el tipo fundRaisingState;
* funds, que es el total de fondos recaudados por el proyecto;
* fundRaisingGoal, que es el objetivo de financiamiento del proyecto en ether.
*/
    struct Project {
        string id;
        string name;
        string description;
        address payable author;
        fundRaisingState state;
        uint funds;
        uint fundRaisingGoal;
    }

/**
* Declara un array público projects que almacena todos los proyectos creados en el contrato.
* Declara un mapeo público contributions que asocia cada id de proyecto con un arreglo de contribuciones hechas a ese proyecto.
*/
    Project[] public projects;
    mapping( string => Contribution[]) public contributions;

/**
* Declara tres eventos: ProjectCreated, ProjectFunded y ProjectStateChanged.
* Estos eventos se emiten cuando se crea un nuevo proyecto,
* cuando se fondea un proyecto existente y cuando se cambia el estado de un proyecto, respectivamente.
* Los eventos sirven para informar a los usuarios sobre las acciones que ocurren en el contrato y facilitar su seguimiento.
*/
    event ProjectCreated(
        string projectId,
        string name,
        string description,
        uint fundRaisingGoal
    );

    event ProjectFunded(
        string projectId,
        uint value
    );

    event ProjectStateChanged(
        string id,
        fundRaisingState state
    );

/**
* Declara dos modificadores: isAuthor y isNotAuthor.
* Estos modificadores se usan para restringir el acceso a ciertas funciones del contrato
* según si el usuario que las llama es o no el autor del proyecto al que se refieren.
* Los modificadores verifican la condición requerida y ejecutan la función si se cumple, o lanzan una excepción si no se cumple.
*/
    modifier isAuthor(
        uint256 projectIndex
    ) {
        require(
            projects[projectIndex].author == msg.sender,
            "Tu necesitas ser el autor del proyecto"
        );
        _;
    }

    modifier isNotAuthor(
        uint projectIndex
    ) {
        require(
            projects[projectIndex].author != msg.sender,
            "Como autor tu no pudes fondear tu propio proyecto"
        );
        _;
    }

/**
* Define una función createProject que permite a un usuario crear un nuevo proyecto y añadirlo al arreglo projects.
* La función recibe como parámetros el id, el name, el description y el fundRaisingGoal del proyecto.
* La función verifica que el fundRaisingGoal sea mayor a cero y crea una instancia de la estructura Project con los datos recibidos y
* la dirección del usuario que llama a la función como autor. La función emite el evento ProjectCreated con los datos del proyecto creado.
*/
    function createProject(
        string calldata id,
        string calldata name,
        string calldata description,
        uint256 fundRaisingGoal
    ) public {
        require(fundRaisingGoal > 0, "El objetivo de financiamiento debe de ser mayor a 0");
        Project memory project = Project(
            id,
            name,
            description,
            payable(msg.sender),
            fundRaisingState.Opened,
            0,
            fundRaisingGoal
        );
        
        projects.push(project);
        
        emit ProjectCreated(id, name, description, fundRaisingGoal);
    }

/**
Esta función permite a cualquier persona enviar fondos a un proyecto específico, identificado por su índice en el array `projects`.
* La función tiene las siguientes características:
* Tiene el modificador `payable`, lo que significa que puede recibir ether junto con la llamada.
* Tiene el modificador `isNotAuthor(projectIndex)`, lo que significa que sólo se puede ejecutar si el emisor de la llamada no es el autor del proyecto.
* Utiliza la variable global `msg`, que contiene información sobre la llamada, como el emisor (`msg.sender`) y el valor enviado (`msg.value`).
* Obtiene el proyecto del array `projects` usando el parámetro `projectIndex` y lo almacena en una variable de memoria llamada `project`.
* Comprueba dos condiciones usando la sentencia `require`:
* Que el estado del proyecto no sea `fundRaisingState.Closed`, lo que significa que el proyecto aún puede recibir fondos.
* Que el valor enviado sea mayor que cero, lo que significa que se envía algún ether.
* Transfiere el valor enviado al autor del proyecto usando la función `transfer` del tipo `address`.
* Actualiza el campo `funds` del proyecto con el valor enviado.
* Actualiza el array `projects` con el proyecto modificado.
* Añade una nueva entrada al mapping `contributions`, que almacena las contribuciones de cada persona a cada proyecto, usando el identificador del proyecto y los datos del emisor y del valor.
* Emite un evento llamado `ProjectFunded`, que registra el identificador del proyecto y el valor enviado.
*/
    function fundProject(uint256 projectIndex)
        public payable isNotAuthor(projectIndex)
    {
        Project memory project = projects[projectIndex];
        require(
            project.state != fundRaisingState.Closed,
            "El ptoyecto no puede recibir fondos"
        );
        require(msg.value > 0, "El valor de fondos debe de ser mayor a 0");
        project.author.transfer(msg.value);
        project.funds += msg.value;
        projects[projectIndex] = project;

        contributions[project.id].push(Contribution(msg.sender, msg.value));

        emit ProjectFunded(project.id, msg.value);
    }

/**
* Esta función permite al autor de un proyecto cambiar su estado a uno nuevo, identificado por un parámetro de tipo enumerado `fundRaisingState`.
* La función tiene las siguientes características:
* Tiene el modificador `isAuthor(projectIndex)`, lo que significa que sólo se puede ejecutar si el emisor de la llamada es el autor del proyecto.
* Obtiene el proyecto del array `projects` usando el parámetro `projectIndex` y lo almacena en una variable de memoria llamada `project`.
* Comprueba una condición usando la sentencia `require`:
* Que el estado nuevo sea diferente del estado actual del proyecto, lo que significa que se produce algún cambio.
* Actualiza el campo `state` del proyecto con el parámetro `newState`.
* Actualiza el array `projects` con el proyecto modificado.
* Emite un evento llamado `ProjectStateChanged`, que registra el identificador del proyecto y el estado nuevo.
*/
    function changeProjectState(fundRaisingState newState, uint256 projectIndex)
        public isAuthor(projectIndex)
    {
        Project memory project = projects[projectIndex];
        require(project.state != newState, "Nuevo estado debe de ser diferente");
        project.state = newState;
        projects[projectIndex] = project;
        
        emit ProjectStateChanged(project.id, newState);
    }
}