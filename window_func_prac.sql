-- Use the test database
USE test;

-- Create the employee table
CREATE TABLE employee (
    emp_ID INT,
    emp_NAME VARCHAR(50),
    DEPT_NAME VARCHAR(50),
    SALARY INT
);

-- Insert data into the employee table
INSERT INTO employee (emp_ID, emp_NAME, DEPT_NAME, SALARY) VALUES
(101, 'Mohan', 'Admin', 4000),
(102, 'Rajkumar', 'HR', 3000),
(103, 'Akbar', 'IT', 4000),
(104, 'Dorvin', 'Finance', 6500),
(105, 'Rohit', 'HR', 3000),
(106, 'Rajesh', 'Finance', 5000),
(107, 'Preet', 'HR', 7000),
(108, 'Maryam', 'Admin', 4000),
(109, 'Sanjay', 'IT', 6500),
(110, 'Vasudha', 'IT', 7000),
(111, 'Melinda', 'IT', 8000),
(112, 'Komal', 'IT', 10000),
(113, 'Gautham', 'Admin', 2000),
(114, 'Manisha', 'HR', 3000),
(115, 'Chandni', 'IT', 4500),
(116, 'Satya', 'Finance', 6500),
(117, 'Adarsh', 'HR', 3500),
(118, 'Tejaswi', 'Finance', 5500),
(119, 'Cory', 'HR', 8000),
(120, 'Monica', 'Admin', 5000),
(121, 'Rosalin', 'IT', 6000),
(122, 'Ibrahim', 'IT', 8000),
(123, 'Vikram', 'IT', 8000),
(124, 'Dheeraj', 'IT', 11000);

-- all entries
SELECT *
from employee;

-- Highest salary by department. Use a group by clause
SELECT DEPT_NAME, max(SALARY)
FROM employee
group by DEPT_NAME;

-- Extract max salary from every department with all other entries
-- For this case use a window function
SELECT e.*,
	MAX(SALARY) OVER(partition by DEPT_NAME) as max_salary
FROM employee e
ORDER BY max_salary ASC;

-- ROW_NUMBER() : assign unique value to each entry in the record
SELECT e.*,
	row_number() over(partition by DEPT_NAME) as rn
from employee e;

-- Fetch the first two companies that first joined the company by department
SELECT * FROM (
	SELECT e.*,
		row_number() over(partition by dept_name order by emp_id) as rn
	from employee e) x
where x.rn < 3;

-- RANK window function. FETCH the top 3 employees in each department earninig the max salary.
SELECT * FROM (
	SELECT e.*,
		rank() over(PARTITION BY  DEPT_NAME ORDER BY salary DESC) as rnk
	from employee e) y
WHERE y.rnk < 4;

-- DENSE RANK WINODW FUNCTON
SELECT e.*,
	rank() over(PARTITION BY  DEPT_NAME ORDER BY salary DESC) as rnk,
	dense_rank() OVER(PARTITION BY DEPT_NAME ORDER BY salary DESC) as dense_rnk,
    row_number() OVER(PARTITION BY dept_name) as row_num
FROM employee e;

-- LEAD() & LAG()
-- Fetch a query to display if the salary of an employee is higher, lower or equal to the preciovus employee.
select e.*,
	lag(salary) over (partition by dept_name order by emp_id) as prev_emp_salary
from employee e;

select e.*,
	lag(salary, 1, 0) over (partition by dept_name order by emp_id) as prev_emp_salary,
    CASE WHEN e.salary > lag(salary) over (partition by dept_name order by emp_id) then 'Higher than previous employee'
        WHEN e.salary < lag(salary) over (partition by dept_name order by emp_id) then 'Lower than previous employee'
        WHEN e.salary = lag(salary) over (partition by dept_name order by emp_id) then 'Same as previous employee'
        ELSE 'No Previous Employee'
        END sal_range
from employee e;

select e.*,
	lead(salary) over (partition by dept_name order by emp_id) as next_emp_salary
from employee e;

select e.*,
	lead(salary, 1, 0) over (partition by dept_name order by emp_id) as next_emp_salary
from employee e