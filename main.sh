#displays the interactive menu to the user
display_menu(){
    echo -e "\nWelcome to Employee Management System. Select an operation to perform"
    echo "1. Add a new employee"
    echo "2. Remove existing employee"
    echo "3. List full-time employees"
    echo "4. List part-time employees"
    echo "5. List all employees with calculated salary"
    echo "6. Increase commission rate for an employee"
    echo "7. Increase hourly wage or base salary of an employee by certain percentage"
    echo "8. Quit"
}

#helper method - displays employee details
display_employee_array(){
	for ((a=0;a<$i;a++))
	do
		for ((b=0;b<$index;b++))
		do
			echo -e "${employee_array[$a,$b]} \c"
		done

		echo
	done
}

#reads data from file and populates employee_array
read_file(){

    file_name='employeelist.txt';
	eof=
	i=0;

	#reads data from the employee file till EOF
	while [ -z "$eof" ]; do
		read line || eof=true
		
		#tokenizes input
		IFS=' ' tokens=( $line )
		index=0

		#assigns employee fields to associative array
		for j in "${tokens[@]}"
		do
			employee_array[$i,$index]="$j"
			let "index=index+1"
		done


		let "i=i+1"

	done < $file_name

}

#writes data to file from employee_array; called at the end of the program
write_file(){

	#clears existent content in file
	echo -e "\c" > $file_name

	#populates file with employee data
	for ((a=0;a<$i;a++))
	do	
		if [ $a -gt 0 ]
			then
				echo >> $file_name
		fi
		for ((b=0;b<$index;b++))
		do

			if [ $b -gt 0 ]
			then
				echo -e " \c" >> $file_name
			fi
			echo -e "${employee_array[$a,$b]}\c" >> $file_name
		done
		
	done
}

#allows the user to add a new employee to the system - requires user to quit the program successfully to be able to reflect changes in the file
add_new_employee(){

	#asks user for employee details one at a time, and validates them

	#employee ID
    echo -e "Employee ID: \c"
	read employee_id
	employee_id_length=${#employee_id}

	#validating to make sure employee ID is exactly 7 characters long and the employee ID is not a string of 0s
	if [[ $employee_id_length -ne 7 || $employee_id -le 0 ]]
	then
		echo -e "${RED}Invalid Employee ID! ID must be a positive 7 digits long number.${NO_COLOR}"
		return
	fi

	#checks to see if there already exists an employee with this ID, if so, the user input is rejected
	id_exists=0
	for ((a=0;a<$i;a++))
	do
		temp_id=${employee_array[$a,0]}
		if [ $employee_id -eq $temp_id ]
		then
			id_exists=1
			break
		fi
	done

	if [ $id_exists -eq 1 ]
	then
		echo -e "${RED}Invalid Employee ID! Employee with this ID already exists.${NO_COLOR}"
		return
	fi

	#employee name
	echo -e "Employee Name: \c"
	read employee_name

	#checks to see if the employee name is empty
	if [ -z "$employee_name" ]
	then
		echo -e "${RED}Invalid Employee Name! Employee name is required.${NO_COLOR}"
		return
	fi

	#employee_status which is 1 for part time and 2 for full-time
	echo -e "Select Employee Status. Press 1 for part-time or 2 for full-time:  \c"
	read employee_status
	
	#validates employee status to be either 1 or 2
	if [[ $employee_status -ne 1 && $employee_status -ne 2 ]]
	then
		echo -e "${RED}Invalid Employee Status! Status must be 1 (for part-time) or 2 (for full-time).${NO_COLOR}"
		return
	fi

	#employee revenue
	echo -e "Employee Revenue: \c"
	read employee_revenue
	
	#checks to see if the employee revenue field is empty
	if [ -z "$employee_revenue" ]
	then
		echo -e "${RED}Invalid Employee Revenue! Revenue is required.${NO_COLOR}"
		return
	fi

	#checks to see if the employee revenue is negative
	if [ $employee_revenue -lt 0 ]
	then
		echo -e "${RED}Invalid Employee Revenue! Revenue must be positive.${NO_COLOR}"
		return
	fi

	#employee commission percentage
	echo -e "Employee Commission Percentage: \c"
	read employee_commission_percentage

	#checks to see if the employee commission percentage is empty
	if [ -z "$employee_commission_percentage" ]
	then
		echo -e "${RED}Invalid Employee Commission Percentage! Commission Percentage is required.${NO_COLOR}"
		return
	fi
	
	#checks to see if the employee commission percentage is a valid value between 0 and 100
	if [[ $employee_commission_percentage -lt 0 || $employee_commission_percentage -gt 100 ]]
	then
		echo -e "${RED}Invalid Employee Commission Percentage! Commission Percentage must be between 0 and 100.${NO_COLOR}"
		return
	fi
	
	
	if [ $employee_status -eq 1 ]
	then

		#for parttime employees,
		employee_type="parttime"
		echo -e "Employee Hourly Wage: \c"
		read employee_hourly_wage

		#employee hourly wage
		#checks to see if the employee hourly wage is empty
		if [ -z "$employee_hourly_wage" ]
		then
			echo -e "${RED}Invalid Employee Hourly Wage! Hourly Wage is required.${NO_COLOR}"
			return
		fi
		
		#checks to see if the employee hourly wage is negative
		if [ $employee_hourly_wage -lt 0 ]
		then
			echo -e "${RED}Invalid Employee Hourly Wage! Hourly Wage must be positive.${NO_COLOR}"
			return
		fi

		#employee working hours
		echo -e "Employee Working Hours: \c"
		read employee_hours

		#checks to see if employee working hours are empty
		if [ -z "$employee_hours" ]
		then
			echo -e "${RED}Invalid Employee Working Hours! Working Hours are required.${NO_COLOR}"
			return
		fi
		
		#checks to see if employee working hours are negative
		if [ $employee_hours -lt 0 ]
		then
			echo -e "${RED}Invalid Employee Working Hours! Working hours must be positive.${NO_COLOR}"
			return
		fi

		
	else
		
		#for fulltime employees
		employee_type="fulltime"
		echo -e "Employee Base Salary: \c"
		read employee_base_salary

		#checks to see if employee base salary is empty
		if [ -z "$employee_base_salary" ]
		then
			echo -e "${RED}Invalid Employee Base Salary! Base Salary is required.${NO_COLOR}"
			return
		fi
		
		#checks to see if employee base salary is negative
		if [ $employee_base_salary -lt 0 ]
		then
			echo -e "${RED}Invalid Employee Base Salary! Base Salary must be positive.${NO_COLOR}"
			return
		fi

	fi

	#once all validation is performed, new employee fields are set
	employee_array[$i,0]=$employee_id
	employee_array[$i,1]=$employee_name
	employee_array[$i,2]=$employee_type
	employee_array[$i,3]=$employee_revenue
	employee_array[$i,4]=$employee_commission_percentage

	if [ $employee_status -eq 1 ]
	then
		employee_array[$i,5]=$employee_hourly_wage
		employee_array[$i,6]=$employee_hours
		employee_array[$i,7]="-"
	else
		employee_array[$i,5]="-"
		employee_array[$i,6]="-"
		employee_array[$i,7]=$employee_base_salary
	fi

	#number of employees is incremented
	let "i=i+1"
	
	echo -e "${GREEN}Successfully added new employee!${NO_COLOR}"

}

#allows the user to remove an existing employee
remove_existing_employee(){

	#obtaining ID of the employee to delete
	echo -e "Enter Employee ID of the employee to remove: \c"
	read employee_id
	employee_id_length=${#employee_id}

	#validating the ID
	if [[ $employee_id_length -ne 7 || $employee_id -le 0 ]]
	then
		echo -e "${RED}Invalid Employee ID! ID must be a positive 7 digits long number.${NO_COLOR}"
		return
	fi

	#checking if the employee exists
	id_exists=-1
	for ((a=0;a<$i;a++))
	do
		temp_id=${employee_array[$a,0]}
		if [ $employee_id -eq $temp_id ]
		then
			id_exists=$a
			break
		fi
	done

	if [ $id_exists -eq -1 ]
	then
		echo -e "${RED}Invalid Employee ID! Employee with this ID does not exist.${NO_COLOR}"
		return
	fi

	#if ID exists, we copy all records - except the one for the employee to be deleted - from the current employee_array to a temporary array
	declare -A temp_employee_array

	for ((a=0;a<$id_exists;a++))
	do
		for ((b=0;b<$index;b++))
		do
			temp_employee_array[$a,$b]="${employee_array[$a,$b]}"
		done
	done

	a=$(($id_exists+1))
	for ((;a<$i;a++))
	do
		c=$(($a-1))
		for ((b=0;b<$index;b++))
		do
			temp_employee_array[$c,$b]="${employee_array[$a,$b]}"
		done
	done

	#decrement the number of employees
	let "i=i-1"

	#copy all records back to the original array 
	for ((a=0;a<$i;a++))
	do
		for ((b=0;b<$index;b++))
		do
			employee_array[$a,$b]="${temp_employee_array[$a,$b]}"
		done
	done

	#unset the temporary array
	unset temp_employee_array
	
    echo -e "${GREEN}Successfully removed the employee!${NO_COLOR}"

}

#lists full-time employees
list_full_time_employees(){

	#for all employees that exist
	for ((a=0;a<$i;a++))
	do
		#check if type of employee is fulltime
		if [ ${employee_array[$a,2]} == "fulltime" ]
		then

			#if employee has generated less than 100000 in revenue, set output color to purple
			if [ ${employee_array[$a,3]} -lt 100000 ]
			then
				echo -e "${PURPLE}\c"
			fi
			
			#display employee fields
			echo "Employee ID: ${employee_array[$a,0]}"
			echo "Employee Name: ${employee_array[$a,1]}"
			echo "Revenue: ${employee_array[$a,3]}"
			echo "Commission Percentage: ${employee_array[$a,4]}"
			echo "Base Salary: ${employee_array[$a,7]}"
			
			#set display color back to normal
			echo -e "${NO_COLOR}"

		fi
		
	done

	#notes for the user
	echo -e "${PURPLE}Employees who generated less than 100000 marked in purple${NO_COLOR}"
	echo -e "${GREEN}Successfully listed full-time employees!${NO_COLOR}"
	
}

#lists part-time employees
list_part_time_employees(){

	#for all employees that exist
    for ((a=0;a<$i;a++))
	do
		#check the ones that have type set to parttime
		if [ ${employee_array[$a,2]} == "parttime" ]
		then

			#if employee has worked less than 12 hours, set output color to yellow
			if [ ${employee_array[$a,6]} -lt 12 ]
			then
				echo -e "${YELLOW}\c"
			fi

			#if employee has worked more than 48 hours, set output color to blue
			if [ ${employee_array[$a,6]} -gt 48 ]
			then
				echo -e "${BLUE}\c"
			fi
			
			#display employee fields
			echo "Employee ID: ${employee_array[$a,0]}"
			echo "Employee Name: ${employee_array[$a,1]}"
			echo "Revenue: ${employee_array[$a,3]}"
			echo "Commission Percentage: ${employee_array[$a,4]}"
			echo "Hourly Wage: ${employee_array[$a,5]}"
			echo "Hours Worked: ${employee_array[$a,6]}"

			#set output color back to normal
			echo -e "${NO_COLOR}"

		fi
		
	done

	#notes for the user
	echo -e "${BLUE}Employees who worked more than 48 hours a month are marked in blue${NO_COLOR}"
	echo -e "${YELLOW}Employees who worked less than 12 hours a month are marked in yellow${NO_COLOR}"
	echo -e "${GREEN}Successfully listed full-time employees!${NO_COLOR}"

}

#lists all employees with their salary
list_employees_with_salary(){

	#for all the employees
	for ((a=0;a<$i;a++))
	do
		#check for fulltime employees with less than 100000 revenue and set output color to purple
		if [[ ${employee_array[$a,2]} == "fulltime" && ${employee_array[$a,3]} -lt 100000 ]]
		then
			echo -e "${PURPLE}\c"
		fi

		#check for parttime employees with less than 12 work hours and set output color to yellow
		if [[ ${employee_array[$a,2]} == "parttime" && ${employee_array[$a,6]} -lt 12 ]]
		then
			echo -e "${YELLOW}\c"
		fi

		#check for parttime employees with more than 48 work hours and set output color to blue
		if [[ ${employee_array[$a,2]} == "parttime" && ${employee_array[$a,6]} -gt 48 ]]
		then
			echo -e "${BLUE}\c"
		fi

		#output employee details
		echo "Employee ID: ${employee_array[$a,0]}"
		echo "Employee Name: ${employee_array[$a,1]}"
		echo "Employee Type: ${employee_array[$a,2]}"
		echo "Revenue: ${employee_array[$a,3]}"
		echo "Commission Percentage: ${employee_array[$a,4]}"


		#calculate salary depending on the type of employee
		if [ ${employee_array[$a,2]} == "fulltime" ]
		then
			echo "Base Salary: ${employee_array[$a,7]}"
			salary=$((${employee_array[$a,7]}+$(($((${employee_array[$a,4]}*${employee_array[$a,3]}))/100))))
			
		else
			echo "Hourly Wage: ${employee_array[$a,5]}"
			echo "Hours Worked: ${employee_array[$a,6]}"
			
			salary=$(($((${employee_array[$a,3]}*${employee_array[$a,4]}))/100))

			if [ ${employee_array[$a,6]} -gt 48 ]
			then
				salary=$(($salary+$(($((48*${employee_array[$a,5]}))+$(($(($((${employee_array[$a,6]}-48))*${employee_array[$a,5]}))/4))))))
			else
				salary=$(($salary+$((${employee_array[$a,5]}*${employee_array[$a,6]}))))
			fi

		fi

		#display calculated salary
		echo "Total Salary: $salary"

		#set output color back to normal
		echo -e "${NO_COLOR}"
	
	done

	#notes for the user
	echo -e "${PURPLE}Full-time employees who generated less than 100000 marked in purple${NO_COLOR}"
	echo -e "${BLUE}Part-time employees who worked more than 48 hours a month are marked in blue${NO_COLOR}"
	echo -e "${YELLOW}Part-time employees who worked less than 12 hours a month are marked in yellow${NO_COLOR}"
    echo -e "${GREEN}Successfully listed full-time employees!${NO_COLOR}"

}

#allows the user to increase the commission rate of an employee
increase_commission_rate(){

	#obtaining ID of the employee to increase commission percentage for
	echo -e "Enter Employee ID of the employee to increase commission percentage for: \c"
	read employee_id
	employee_id_length=${#employee_id}

	#validating the ID
	if [[ $employee_id_length -ne 7 || $employee_id -le 0 ]]
	then
		echo -e "${RED}Invalid Employee ID! ID must be a positive 7 digits long number.${NO_COLOR}"
		return
	fi

	#checking if the employee exists
	id_exists=-1
	for ((a=0;a<$i;a++))
	do
		temp_id=${employee_array[$a,0]}
		if [ $employee_id -eq $temp_id ]
		then
			id_exists=$a
			break
		fi
	done

	if [ $id_exists -eq -1 ]
	then
		echo -e "${RED}Invalid Employee ID! Employee with this ID does not exist.${NO_COLOR}"
		return
	fi

	#obtaining the new increased commission percentage
	echo -e "Enter new Commission Percentage: \c"
	read employee_commission_percentage

	#validating commission percentage
	if [ -z "$employee_commission_percentage" ]
	then
		echo -e "${RED}Invalid Employee Commission Percentage! Commission Percentage is required.${NO_COLOR}"
		return
	fi
	
	if [[ $employee_commission_percentage -lt 0 || $employee_commission_percentage -gt 100 ]]
	then
		echo -e "${RED}Invalid Employee Commission Percentage! Commission Percentage must be between 0 and 100.${NO_COLOR}"
		return
	fi

	#checking if new 'increased' percentage is lower than existing commission rate
	if [ $employee_commission_percentage -lt ${employee_array[$id_exists,4]} ]
	then
		echo -e "${RED}Invalid 'Increased' Commission Percentage! 'Increased' Commission percentage cannot be lower than existing commission percentage.${NO_COLOR}"
		return
	fi
	
	#setting the new commission percentage
	employee_array[$id_exists,4]=$employee_commission_percentage

	#notes for the user
    echo -e "${GREEN}Successfully increased commission rate of the employee!${NO_COLOR}"

}

#allows the user to increase the hourly or base salary of an employee by a certain percentage
increase_wage(){

    #obtaining ID of the employee to increase base salary/hourly wage for
	echo -e "Enter Employee ID of the employee to increase commission percentage for: \c"
	read employee_id
	employee_id_length=${#employee_id}

	#validating the ID
	if [[ $employee_id_length -ne 7 || $employee_id -le 0 ]]
	then
		echo -e "${RED}Invalid Employee ID! ID must be a positive 7 digits long number.${NO_COLOR}"
		return
	fi

	#checking if the employee exists
	id_exists=-1
	for ((a=0;a<$i;a++))
	do
		temp_id=${employee_array[$a,0]}
		if [ $employee_id -eq $temp_id ]
		then
			id_exists=$a
			break
		fi
	done

	if [ $id_exists -eq -1 ]
	then
		echo -e "${RED}Invalid Employee ID! Employee with this ID does not exist.${NO_COLOR}"
		return
	fi

	#obtaining the new increased commission percentage
	echo -e "Enter percentage by which to increase base salary/hourly wage by: \c"
	read wage_increase_percentage

	#validating commission percentage
	if [ -z "$wage_increase_percentage" ]
	then
		echo -e "${RED}Invalid Wage Increase Percentage! Wage Increase Percentage is required.${NO_COLOR}"
		return
	fi
	
	if [ $wage_increase_percentage -lt 0 ]
	then
		echo -e "${RED}Invalid Wage Increase Percentage! Wage 'Increase' Percentage must be positive.${NO_COLOR}"
		return
	fi

	
	#updating hourly or base salary depending on the type of employee
	if [ ${employee_array[$id_exists,2]} == "parttime" ]
	then
		wage_index=5
	else
		wage_index=7
	fi

	#updating the wage - base salary for fulltime employees and hourly salary for parttime employees
	employee_array[$id_exists,$wage_index]=$((${employee_array[$id_exists,$wage_index]}+$(($((${employee_array[$id_exists,$wage_index]}*$wage_increase_percentage))/100))))

	#notes for the user
    echo -e "${GREEN}Successfully increased commission rate of the employee!${NO_COLOR}"

}

#writes all changes to file and quits the program
quit(){

	#calls the module to write to file
	write_file

	#notes for the user
    echo -e "${GREEN}Successfully quit the program. All changes made saved to file!${NO_COLOR}"
}

#start of the program
#declaring colors
RED='\033[0;31m' #used for error messages
BLUE='\033[0;34m' #used to highlight part-time employees who worked more than 48 hours a month
YELLOW='\033[0;33m' #used to highlight part-time employees who worked less than 12 hours a month
GREEN='\033[0;32m' #used for success messages
PURPLE='\033[0;35m' #used to highlight full-time employees who generated less than 100,000 in revenue in a month
NO_COLOR='\033[0m' #standard output color for the terminal

#declaring an associative array to store employee details
declare -A employee_array

#read file and populate the employee_array
read_file

#display the menu
display_menu

#read user input
read input 

while [ true ]
do

#validates user input to ensure the user has entered a valid option
	if [[ -z "$input" || $input -lt 1 || $input -gt 8 ]]
	then
		echo -e "${RED}Invalid choice${NO_COLOR}"
	else
		
		#calling the appropriate module based on user choice
		case $input in
			1*)
			add_new_employee
			;;

			2*)
			remove_existing_employee
			;;
            
            3*)
			list_full_time_employees
			;;

            4*)
			list_part_time_employees
			;;

            5*)
			list_employees_with_salary
			;;

            6*)
			increase_commission_rate
			;;	

            7*)
			increase_wage
			;;

			8*)
			quit
			;;

		esac

	fi

	display_menu
	read input

done
