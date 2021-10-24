pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract humanToken {
    uint32 public timestamp;

    struct Human {
        string name;
        string sex;
        string specialization;
        uint8 age;
        uint8 weight;
        uint8 height;  
    }

    Human[] humansArr;
    mapping (uint => uint) public humanToOwner;
    mapping (uint => uint) humanToPrice;

    modifier accept() {
        tvm.accept();
        _;
    }

    function createHuman(string name, string sex, string specialization, uint8 age, uint8 weight, uint8 height) public accept {
        humansArr.push(Human(name, sex, specialization, age, weight, height));
        uint keyAsLastNum = humansArr.length - 1;
        humanToOwner[keyAsLastNum] = msg.pubkey();
    }

    function getHumanOwner(uint humanId) public view returns (uint) {
        return humanToOwner[humanId];
    }

    function getHumanPrice(uint humanId) public view returns (uint) {
        return humanToPrice[humanId];
    }

    function getTokenInfo(uint humanId) public view returns (string humanName, string humanSex, string humanSpecialization, uint8 humanAge, uint8 humanHeight, uint8 humanWeight) {
        humanName = humansArr[humanId].name;
        humanSex = humansArr[humanId].sex;
        humanSpecialization = humansArr[humanId].specialization;
        humanAge = humansArr[humanId].age;
        humanName = humansArr[humanId].name;
        humanWeight = humansArr[humanId].weight;
        humanHeight = humansArr[humanId].height;
    }

    function changeOwner(uint humanId, uint pubKeyOfNewOwner) public accept {
        require(msg.pubkey() == humanToOwner[humanId], 101);
        humanToOwner[humanId] = pubKeyOfNewOwner;
    }

    function setHumanPrice(uint humanId, uint price) public accept {
        require(msg.pubkey() == humanToOwner[humanId], 1337);
        humanToPrice[humanId] = price;
    }

    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();

        timestamp = now;
    }
}
