// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;
import {IERC20} from "./IERC20.sol";

contract SchoolManagement {

    address public owner;
    IERC20 public token;

    uint256 public studentCount;
    uint256 public staffCount;

    // STRUCTS
    struct Student {
        uint256 id;
        string name;
        uint256 level;
        bool feesPaid;
        uint256 paymentTimestamp;
        bool isActive; 
    }

    struct Staff {
        uint256 id;
        string name;
        address wallet;
        uint256 salary;
        bool isSuspended; 
    }

    // MAPPINGS
    mapping(uint256 => Student) public students;
    mapping(uint256 => Staff) public staffs;
    mapping(uint256 => uint256) public levelFees;

    // EVENTS
    event StudentRegistered(uint256 indexed studentId, string name, uint256 level);
    event SchoolFeesPaid(uint256 indexed studentId, uint256 amount, uint256 timestamp);
    event StudentRemoved(uint256 indexed studentId);
    event StaffRegistered(uint256 indexed staffId, string name, uint256 salary);
    event StaffPaid(uint256 indexed staffId, address indexed wallet, uint256 amount);
    event StaffSuspended(uint256 indexed staffId);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor(address _tokenAddress) {
        owner = msg.sender;
        token = IERC20(_tokenAddress);

        // Set default fees per level
        levelFees[100] = 100 * 10**18;
        levelFees[200] = 150 * 10**18;
        levelFees[300] = 200 * 10**18;
        levelFees[400] = 300 * 10**18;
    }

    function registerStudent(string memory _name, uint256 _level) external {
        require(
            _level == 100 || _level == 200 || _level == 300 || _level == 400,
            "Invalid level"
        );

        studentCount++;

        students[studentCount] = Student({
            id: studentCount,
            name: _name,
            level: _level,
            feesPaid: false,
            paymentTimestamp: 0,
            isActive: true
        });

        emit StudentRegistered(studentCount, _name, _level);
    }


    function paySchoolFees(uint256 _studentId) external {
        Student memory student = students[_studentId];

        require(student.id != 0, "Student does not exist");
        require(student.isActive, "Student is removed/inactive");
        require(!student.feesPaid, "Fees already paid");

        uint256 feeAmount = levelFees[student.level];

        bool success = token.transferFrom(msg.sender, address(this), feeAmount);
        require(success, "Payment failed");

        student.feesPaid = true;
        student.paymentTimestamp = block.timestamp;

        emit SchoolFeesPaid(_studentId, feeAmount, block.timestamp);
    }


    function removeStudent(uint256 _studentId) external onlyOwner {
        Student memory student = students[_studentId];
        require(student.id != 0, "Student does not exist");
        require(student.isActive, "Student already removed");

        student.isActive = false;

        emit StudentRemoved(_studentId);
    }


    function registerStaff(string memory _name, address _wallet, uint256 _salary) external onlyOwner {
        staffCount++;

        staffs[staffCount] = Staff({
            id: staffCount,
            name: _name,
            wallet: _wallet,
            salary: _salary,
            isSuspended: false
        });

        emit StaffRegistered(staffCount, _name, _salary);
    }

    function payStaff(uint256 _staffId) external onlyOwner {
        Staff memory staffMember = staffs[_staffId];

        require(staffMember.id != 0, "Staff does not exist");
        require(!staffMember.isSuspended, "Staff is suspended");

        bool success = token.transfer(staffMember.wallet, staffMember.salary);
        require(success, "Salary payment failed");

        emit StaffPaid(_staffId, staffMember.wallet, staffMember.salary);
    }

    function suspendStaff(uint256 _staffId) external onlyOwner {
        Staff memory staffMember = staffs[_staffId];
        require(staffMember.id != 0, "Staff does not exist");
        require(!staffMember.isSuspended, "Staff already suspended");

        staffMember.isSuspended = true;

        emit StaffSuspended(_staffId);
    }

    function getStudent(uint256 _studentId) external view returns (Student memory) {
        return students[_studentId];
    }

    function getStaff(uint256 _staffId) external view returns (Staff memory) {
        return staffs[_staffId];
    }

    function getAllStudentCount() external view returns (uint256) {
        return studentCount;
    }

    function getAllStaffCount() external view returns (uint256) {
        return staffCount;
    }
}