pragma solidity  >=0.5.0 < 0.6.0;
contract Arca {
 
    struct gatito{
        string color;
        string raza;
        uint edad;
        string nombre;
        string sexo;
        string foto_url;
        uint id;
        address adoptante; 
        bool adoptado;
    }
    
    mapping (address => gatito[]) public adoptantes;
    mapping (uint => gatito) public todosGatitos;
    
    uint public c_gatitos;
    
    address public owner;
    
    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }
    constructor() public { 
        owner = msg.sender;
    }
    
    function recibirGatito(
        string memory _color, 
        string memory _raza,
        string memory _nombre,
        string memory _sexo,
        string memory _url,
        uint _edad 
        ) public onlyOwner returns(bool){
        
        gatito memory nuevoGatito = gatito({color: _color, 
        raza: _raza, 
        edad: _edad, 
        foto_url: _url,
        nombre: _nombre, 
        sexo: _sexo, 
        adoptante: address(0), 
        id: c_gatitos++,
        adoptado: false
        });
        //adoptantes[msg.sender].push(nuevoGatito);
        //Guardamos el gatito en el mapping de todos los gatitos
        todosGatitos[nuevoGatito.id] = nuevoGatito;
        
        return true;
            
        }   
        
        function adoptarGatito(uint _idGatito)public {
        require(_idGatito <= c_gatitos, "No existe gatito");
        require(todosGatitos[_idGatito].adoptado == false, "Gatito adoptado");
        todosGatitos[_idGatito].adoptante = msg.sender;
        todosGatitos[_idGatito].adoptado = true;
        adoptantes[msg.sender].push(todosGatitos[_idGatito]);
        }
}