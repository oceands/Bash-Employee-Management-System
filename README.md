# Bash-Employee-Management-System

The present directory contains 2 files:

1. employeelist.txt - a text file that contains details of employees - Employee ID, Name, Type (fulltime or parttime), Revenue generated, Commission Percentage, Hourly Wage and Hours Worked (applicable for Parttime employees) and Base Salary (applicable for full-time employees) - in the exact order mentioned. If a field is not applicable to a particular employee (for example Hourly Wage for a full-time employee), then that field is represented by a hyphen (-). All fields are separated by space. If additional rows are required to be added, make sure to enter data in the same format as the existing one.

2. main.sh - a Shell Script file that contains all functions implementing the functionality required of the Employee Management System - Adding a new employee, Removing an existing employee, Listing all fulltime employees, Listing all parttime employees, Listing all employees with calculated salaries, Increasing commission rate for an employee, or Increasing the hourly wage/base salary of a particular employee. The program offers the user an interactive menu to perform the said operations and when the user finally chooses to quit, the changes are reflected in the employeelist.txt file.

===========================================================================================================================

To run the program, 
1. Make sure both the employeelist.txt and main.sh files are in the same directory
2. Navigate to the directory where these files are stored
3. Execute the program by typing the command ./main.sh 
4. Make sure to quit the program by selecting the appropriate menu number - 8 - to save changes in the file.

