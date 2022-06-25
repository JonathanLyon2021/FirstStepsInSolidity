// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract StudentTracker {

    address ID;

    struct Student {
        string student;
        address ID;
        string GPA;
        uint grade;
        uint index;
    }

    event LogNewStudent (string student, address ID, string GPA, uint grade, uint index);
    event LogUpdateStudent (string student, address ID, string GPA, uint grade, uint index);


    string[] private studentIndex;
    address[] private addressIndex;

    mapping (address => string) Class;
    mapping (address => bool) Teacher;
    mapping (address => string) private Instructor;

    mapping (string => Student) private Students;
    mapping (address => Student) private Addresses;

    constructor() public {
        require(msg.sender == 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c, "Must be Instructor of the Class");
        Instructor[msg.sender] = "Jonathan";
        Teacher[msg.sender] = true;
    }

    modifier onlyInstructor() {

       require(Teacher[msg.sender], "Only the Instructor is authorized to make changes");
        _;
    }

    function gpaChecker(uint grade) internal pure returns(string memory) {
        string memory GPA;
        if (grade <= 60){
            GPA = "F";
        }
        else if (grade <= 69){
            GPA = "D";
        }
        else if (grade <= 79){
            GPA = "C";
        }
        else if (grade <= 89){
            GPA = "B";
        }
        else {
            GPA = "A";
        }
        return GPA;
    }

    function hashCompareWithLengthCheck(string memory a, string memory b) internal pure returns (bool) {
        if(bytes(a).length != bytes(b).length) {
            return false;
        } else {
            return keccak256(bytes(a)) == keccak256(bytes(b));
        }
    }

    function isStudent(string memory student) //USE for address TRUE mapping for allowing authorization
    public
    view
    returns(bool isIndeed)
    {
        if(studentIndex.length == 0) return false;

        return keccak256(bytes(student)) == keccak256(bytes(studentIndex[Students[student].index]));

    }

    function isAddress(address ID) //USE for address TRUE mapping for allowing authorization
    internal
    returns(bool isIndeed)
    {
        if(addressIndex.length == 0) return false;

        return ((ID) == (addressIndex[Addresses[ID].index]));

    }

    function addStudent(
        string memory student,
        address ID,
        //string memory GPA,
        uint grade
        )
    public onlyInstructor
    returns(uint index)
    {
        require(!isStudent(student), "Will not allow duplicate Names");
        require(!isAddress(ID), "Will not allow duplicate IDs");
        require(hashCompareWithLengthCheck(student,Instructor[msg.sender]) != true, "Student cannot be the Teacher");
        require((ID) != msg.sender, "Student cannot be the Teacher");

        string memory GPA = gpaChecker(grade);

        Addresses[ID].index = addressIndex.push(ID)-1;
        Students[student].ID    = ID;
        Students[student].GPA   = GPA;
        Students[student].index = studentIndex.push(student)-1;
        Students[student].grade = grade;
        emit LogNewStudent (student, ID, GPA, grade, Students[student].index);
        return studentIndex.length-1;
    }

    function getStudentInfo(string memory student)
    public
    view
    returns(address ID, string memory GPA, uint grade, uint index)
    {
      require(isStudent(student), "Student requested is not in my Class");

        return(
        Students[student].ID,
        Students[student].GPA,
        Students[student].grade,
        Students[student].index);
    }

    function updateStudent(string memory student, uint grade)
    public onlyInstructor
    returns(bool success)
    {
        require(isStudent(student), "Student requested is not in my Class");

        string memory GPA = gpaChecker(grade);

        Students[student].grade = grade;
        Students[student].GPA   = GPA;

        emit LogUpdateStudent (student, ID, GPA, grade, Students[student].index);
        return true;

    }

    function getStudentCount()
    public
    view
    returns(uint count)
    {
        return studentIndex.length;
    }

    function getStudentAtIndex(uint index)
    public
    view
    returns(string memory student)
    {
        require(index < studentIndex.length, "Student index must be within range");
        return studentIndex[index];
    }

    function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
        bytes memory _ba = bytes(_a);
        bytes memory _bb = bytes(_b);
        string memory ab = new string(_ba.length + _bb.length);
        bytes memory bab = bytes(ab);
        uint k = 0;
        for (uint i = 0; i < _ba.length; i++) bab[k++] = _ba[i];
        for (uint i = 0; i < _bb.length; i++) bab[k++] = _bb[i];
        return string(bab);
    }


    function getClass() public view returns(string memory) {
        require(gasleft()>20,
        "Not enough gas");
        string memory rString;

        for(uint i = 0; i < studentIndex.length; i++) {
            rString = strConcat(rString,studentIndex[i]);
            rString = strConcat(rString,",");
        }
        return rString;
    }

    function getInstructor() public view  returns(string memory name) {

        return (Instructor[msg.sender]);

    }

}