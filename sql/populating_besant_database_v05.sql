CREATE DATABASE populating_besant_database_v05;
USE populating_besant_database_v05;

-- DROP DATABASE populating_besant_database_v05;
SHOW TABLES;  -- tables
SHOW TRIGGERS;  -- triggers
SHOW PROCEDURE status    -- Procedures
WHERE db = 'populating_besant_database_v05';
SHOW FUNCTION STATUS WHERE Db = DATABASE();   -- Functions



-- {{ 

RENAME TABLE
course TO populating_course,
subject TO populating_subject,
course_sub TO populating_course_sub,
coordinator TO populating_coordinator,
batch TO populating_batch,
instructor TO populating_instructor,
student_enquiry TO populating_student_enquiry,
enrollments TO populating_enrollments,
student TO populating_student,
payments TO populating_payments,
student_batch TO populating_student_batch;

SELECT * FROM populating_course;
SELECT * FROM populating_subject;
SELECT * FROM populating_course_sub;
SELECT * FROM populating_coordinator;
SELECT * FROM populating_batch;
SELECT * FROM populating_instructor;
SELECT * FROM populating_student_enquiry;
SELECT * FROM populating_enrollments;
SELECT * FROM populating_student;
SELECT * FROM populating_payments;
SELECT * FROM populating_student_batch;


DESC populating_course;
DESC populating_subject;
DESC populating_course_sub;
DESC populating_coordinator;
DESC populating_batch;
DESC populating_instructor;
DESC populating_student_enquiry;
DESC populating_enrollments;
DESC populating_student;
DESC populating_payments;
DESC populating_student_batch;


SHOW CREATE TABLE populating_course;
SHOW CREATE TABLE populating_subject;
SHOW CREATE TABLE populating_course_sub;
SHOW CREATE TABLE populating_coordinator;
SHOW CREATE TABLE populating_batch;
SHOW CREATE TABLE populating_instructor;
SHOW CREATE TABLE populating_student_enquiry;
SHOW CREATE TABLE populating_enrollments;
SHOW CREATE TABLE populating_student;
SHOW CREATE TABLE populating_payments;
SHOW CREATE TABLE populating_student_batch;




-- }}


-- -------------------------------------------------------------- Just Practice ------------------------------------------------------------------------------------

-- Populating a table of names,age,salary
CREATE TABLE cust_prac_populating_table(
cust_id INT PRIMARY KEY AUTO_INCREMENT,
cust_name VARCHAR(150),
age INT,
salary DECIMAL(8,2)
);


-- {{ creating a Stored Procedure randbetween(start,end)
DELIMITER //

CREATE PROCEDURE randbetween(
IN p_min INT,
IN p_max INT,
OUT res_value INT
)

BEGIN
    SET res_value = FLOOR(
						p_min + RAND() * (p_max - p_min + 1)
						   );
    SELECT res_value;
END //
DELIMITER ;

CALL randbetween(20,70,@res_value);
-- }} 


-- {{ PROCEDURE populate_names
DROP PROCEDURE populate_names_age;

DELIMITER //

CREATE PROCEDURE populate_names_age(IN no_of_names INT)
BEGIN
    DECLARE x INT DEFAULT 1;

    WHILE x <= no_of_names DO

        INSERT INTO cust_prac_populating_table(cust_name,age)
        VALUES (
            ELT(
                FLOOR(1 + RAND() * 5),
                'Aarav Sharma',
                'Vivaan Reddy',
                'Aditya Kumar',
                'Arjun Nair',
                'Sai Kiran'
            ),
			randbetween(20,80)                                                            -- randbetween -> FLOOR(min + RAND() * (max - min + 1))
		);                       
        SET x = x + 1;

    END WHILE;
END //

DELIMITER ;

CALL populate_names_age(1000);


SELECT * FROM cust_prac_populating_table
WHERE age IS NOT NULL;

SELECT AVG(age),MIN(age),MAX(age) FROM cust_prac_populating_table;    -- to know how are the values randomized

SELECT age,COUNT(*) AS 'No of Customers'           -- to know the mode(age) | customers of what age are highest in number
FROM cust_prac_populating_table
WHERE age IS NOT NULL
GROUP BY age
ORDER BY `No of Customers` DESC;

-- }}
-- ------------------------------------------------------- End of Just Practice -----------------------------------------------------------

-- ------------------------------------------------------ Required Custom Functions -----------------------------------------
-- {{ creating a custom function randbetween(start,end)
DELIMITER //

CREATE FUNCTION randbetween(p_min INT,p_max INT)
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE res_values INT;
    
    SET res_values = FLOOR(
						p_min + RAND() * (p_max - p_min + 1)
						   );
    RETURN res_values ;
END //
DELIMITER ;

SELECT randbetween(20,70);
-- }} 


-- =================================================================    SERIOUS   ==============================================================
-- ============================================================          TABLES             =====================================================

-- - TABLE populating_student_enquiry -
-- - TABLE populating_enrollments -
-- - TABLE populating_student -
-- - TABLE populating_subject -
-- - TABLE populating_course -
-- - TABLE populating_coordinator -
-- - TABLE populating_instructor -
-- - TABLE populating_batch -
-- - TABLE populating_payments -
-- - TABLE populating_course_sub -
-- - TABLE populating_student_batch -
-- - TABLE populating_enrolled_courses -




-- ----------------------------------------------------------------- TABLE populating_student_enquiry ----------------------------------

-- {{ TABLE populating_student_enquiry
 
-- Creating a TABLE populating_student_enquiry in stored_proc_order_by_me by copying the structure of Table student_enquiry from besant_database_v05
CREATE TABLE populating_besant_database_v05.populating_student_enquiry LIKE
besant_database_v05.student_enquiry;

INSERT INTO stored_proc_order_by_me.populating_student_enquiry 
SELECT * FROM besant_database_v05.student_enquiry;

ALTER TABLE populating_student_enquiry
MODIFY COLUMN status ENUM('NEW','INTERESTED','DEMO_SCHEDULED','LIKELY_TO_CONVERT','CONVERTED','ON_HOLD','LIKELY_LOST','LOST');

DESC populating_student_enquiry;
ALTER TABLE populating_student_enquiry    -- added an extra attribute "gender"
ADD COLUMN gender ENUM("Male","Female") ;

SHOW CREATE TABLE populating_student_enquiry;
							SELECT * FROM populating_student_enquiry;
                            DESC populating_student_enquiry;
-- }} 
								

-- -------------------------------------------------------------- TABLE populating_enrollments ---------------------------------------------------

-- {{ TABLE populating_enrollments 

-- Creating a TABLE populating_enrollments by copying the structure from besant_database_v05.enrollments
CREATE TABLE populating_besant_database_v05.populating_enrollments LIKE   -- created a table populating_enrollments by copying the structure of table besant_database_v05.enrollments
besant_database_v05.enrollments;

INSERT INTO stored_proc_order_by_me.populating_enrollments 
SELECT * FROM besant_database_v05.enrollments;

ALTER TABLE populating_enrollments
ADD UNIQUE(enquiry_id);


-- check for duplicate enquiry_id 
SELECT enquiry_id
FROM populating_enrollments
GROUP BY enquiry_id
HAVING COUNT(*) > 1;
-- we had composite PK now changed it to PK with one column i.e., enrollment_id => one enrollment_id can enroll to only one course


ALTER TABLE populating_enrollments
DROP PRIMARY KEY,
ADD PRIMARY KEY(enrollment_id);

SHOW CREATE TABLE populating_enrollments;
SHOW INDEX FROM populating_enrollments;

ALTER TABLE populating_enrollments
ADD FOREIGN KEY(enquiry_id) REFERENCES populating_student_enquiry(enquiry_id);

ALTER TABLE populating_enrollments
ADD FOREIGN KEY(enrolled_course_id) REFERENCES populating_course(course_id);

ALTER TABLE populating_enrollments
DROP INDEX enrolled_course_id_idx;




									SELECT * FROM populating_enrollments;
									DESC populating_enrollments;
                                    
-- }}

 

-- ----------------------------------------------------------- TABLE populating_student ----------------------------------------------------

-- {{ TABLE populating_student
CREATE TABLE populating_besant_database_v05.populating_student LIKE   -- created a table populating_enrollments by copying the structure of table besant_database_v05.enrollments
besant_database_v05.student;

INSERT INTO stored_proc_order_by_me.populating_enrollments 
SELECT * FROM besant_database_v05.enrollments;

ALTER TABLE populating_student
ADD UNIQUE(enrollment_id);

SHOW CREATE TABLE populating_student;

ALTER TABLE populating_student
DROP PRIMARY KEY,
ADD PRIMARY KEY(student_id);



-- }} 


-- ------------------------------------------------------ TABLE populating_course -----------------------------------------------------------------

-- {{ TABLE populating_course - (no population static data[Dimension])
-- Creating TABLE populating_course table by copying the schema of besant_database_v05.course

CREATE TABLE populating_besant_database_v05.populating_course LIKE
besant_database_v05.course;

INSERT INTO populating_course(course_id, course_name, course_fee ,coordinator_id)
VALUES(1, 'Data Analytics', 42500,1),(2, 'Data Science', 40000,3),(3, 'Python Full Stack Development', 40000,2),(4, 'Java Full Stack Development', 40000,1),(5, 'Cloud Computing', 42500,3);

									SELECT * FROM populating_course;
                                    DESC populating_course;
                                    
-- }} 



-- ------------------------------------------------------ TABLE populating_subject -----------------------------------------------------------------

-- {{ TABLE populating_subject (no populating - static data[Dimension]) 

CREATE TABLE populating_besant_database_v05.populating_subject LIKE
besant_database_v05.subject;

INSERT INTO populating_subject (subject_name)
VALUES ('Microsoft Excel'),('Power BI'),('Microsoft Power BI'),('Python'),('Data Science'),('Java'),('ReactJS'),
		('Django'),('Cloud Computing'),('DevOps'),('AWS'),('SQL');
        

											SELECT * FROM populating_subject;
                                            DESC populating_subject;


-- }} 



-- ---------------------------------------------------------------- TABLE populating_coordinator ------------------------------------------------------------

-- {{ TABLE populating_coordinator (no populating - static data[Dimension])

CREATE TABLE populating_besant_database_v05.populating_coordinator LIKE
besant_database_v05.coordinator;

INSERT INTO populating_coordinator(Coordinator_id,Coordinator_name,age,Gender,role)
VALUES(1, 'Saravanan', 38, 'Male', 'Staff'),(2, 'Vikram', 35, 'Male', 'Staff'),(3, 'Siva', 24, 'Male', 'Staff'),(4, 'Jeeva', 40, 'Male', 'Manager');


										SELECT * FROM populating_coordinator;
                                        DESC populating_coordinator;

-- }} 


-- ---------------------------------------------------------------- TABLE populating_payments ------------------------------------------------------------

-- {{ TABLE populating_payments

CREATE TABLE populating_besant_database_v05.populating_payments LIKE
besant_database_v05.payments;

ALTER TABLE populating_payments
ADD FOREIGN KEY (student_id) REFERENCES populating_student(student_id);
ALTER TABLE populating_payments
ADD FOREIGN KEY (course_id) REFERENCES populating_course(course_id);


ALTER TABLE populating_payments
DROP PRIMARY KEY,
ADD PRIMARY KEY (payment_id,student_id);

SHOW CREATE TABLE populating_payments;
										SELECT * FROM populating_payments;
                                        DESC populating_payments;
-- }} 

-- ---------------------------------------------------------------- TABLE populating_batch ------------------------------------------------------------

-- {{ TABLE populating_batch

CREATE TABLE populating_besant_database_v05.populating_batch LIKE
besant_database_v05.batch;

ALTER TABLE populating_batch
ADD FOREIGN KEY (instructor_id) REFERENCES populating_instructor(instructor_id);

ALTER TABLE populating_batch
ADD FOREIGN KEY (course_id) REFERENCES populating_course(course_id);

ALTER TABLE populating_payments
DROP FOREIGN KEY populating_batch_ibfk_2;

ALTER TABLE populating_batch
ADD FOREIGN KEY (subject_id) REFERENCES populating_subject(subject_id);

SHOW CREATE TABLE populating_batch;

									SELECT * FROM populating_batch;
                                    DESC populating_batch;
                                   
                                   
-- }} 


-- ---------------------------------------------------------------- TABLE populating_instructor ------------------------------------------------------------

-- {{ TABLE populating_instructor (no populating - static data[Dimension] )

CREATE TABLE populating_besant_database_v05.populating_instructor LIKE
besant_database_v05.instructor;

INSERT INTO populating_instructor(instructor_id,instructor_name,age,gender)
VALUES (1,"Krishnan",52,"Male"),(2,"Chandana",28,"Female"),(3,"Anikit",30,"Male"),(4,"Kishore",32,"Male");


										SELECT * FROM populating_instructor;
                                        DESC populating_instructor;
                                        
-- }} 


-- ---------------------------------------------------------------- TABLE populating_student_batch ------------------------------------------------------------

-- {{ TABLE populating_student_batch

CREATE TABLE populating_besant_database_v05.populating_student_batch LIKE
besant_database_v05.student_batch;



										SELECT * FROM populating_student_batch;
                                        DESC populating_student_batch;
                                        
-- }} 


-- ---------------------------------------------------------------- TABLE populating_course_sub ------------------------------------------------------------

-- {{ TABLE populating_course_sub

CREATE TABLE populating_besant_database_v05.populating_course_sub LIKE
besant_database_v05.course_sub;


ALTER TABLE populating_course_sub
ADD FOREIGN KEY (course_id) REFERENCES populating_course(course_id);

ALTER TABLE populating_course_sub
ADD FOREIGN KEY (subject_id) REFERENCES populating_subject(subject_id);

SHOW CREATE TABLE populating_course_sub;
                                        SELECT * FROM populating_course_sub;
                                        DESC populating_course_sub;
                                        
                                        
-- }}

-- ---------------------------------------------------------------- TABLE populating_course_sub ------------------------------------------------------------


-- ===================================================================             PROCEDURES                 =============================================================

-- {{ ---------------------------------------------------------------- PROCEDURE p_populating_student_enquiry --------------------------------------------------------------
DROP PROCEDURE p_populating_student_enquiry;


DELIMITER //

CREATE PROCEDURE p_populating_student_enquiry(
IN no_of_rows INT ,
OUT result VARCHAR(200)
)

BEGIN                    -- ORDER => 1.Temp Variables 2.Cursors 3.EXIT Handler i.e., DECLARE variables DECLARE conditions(optional) DECLARE cursors DECLARE handlers
        
	DECLARE x INT DEFAULT 1;
    DECLARE randvalue INT ;
    
	DECLARE EXIT HANDLER FOR SQLEXCEPTION 
		BEGIN 
			ROLLBACK;
			RESIGNAL;
		END;
    
START TRANSACTION ;    
	WHILE x <= no_of_rows DO 
    
		SET randvalue = randbetween(1,50);
        
		INSERT INTO populating_student_enquiry(student_name,email_id,phone,enquiry_date,status,address,course,councellor_name,remarks)
		VALUES(
			ELT(
				randvalue,
				'Karthik Gowda','Nithya Ramesh','Darshan Kumar','Keerthana S','Manjunath H',
				'Aishwarya Rao','Pradeep Bhat','Kavya Shetty','Naveen Kumar M','Pooja N',
				'Rakesh Gowda','Shreya Hegde','Sandeep R','Deepika M','Harish Kumar',
				'Ananya Murthy','Vinay K','Lakshmi Narayan','Tejas Gowda','Bhavana S',
				'Arun Prakash','Chaitra R','Nikhil Shetty','Soumya N','Akash Hegde',
				'Divya Rao','Santosh Kumar P','Meghana Bhat','Ashwin R','Sindhu M',
				'Rakshith Gowda','Nandini K','Praveen Kumar','Rashmi S','Dhanush R',
				'Asha Narayan','Vivek H','Sushmitha K','Abhilash M','Pavithra Shetty',
				'Rohith Kumar','Shruthi Ramesh','Ganesh Bhat','Ramya N','Chethan Gowda',
				'Keerthi H','Sunil Kumar B','Anusha R','Mahesh K','Varsha Shetty'
			)
			,
			CONCAT(
				REPLACE(
					ELT(
						randvalue,
						'Karthik Gowda','Nithya Ramesh','Darshan Kumar','Keerthana S','Manjunath H',
						'Aishwarya Rao','Pradeep Bhat','Kavya Shetty','Naveen Kumar M','Pooja N',
						'Rakesh Gowda','Shreya Hegde','Sandeep R','Deepika M','Harish Kumar',
						'Ananya Murthy','Vinay K','Lakshmi Narayan','Tejas Gowda','Bhavana S',
						'Arun Prakash','Chaitra R','Nikhil Shetty','Soumya N','Akash Hegde',
						'Divya Rao','Santosh Kumar P','Meghana Bhat','Ashwin R','Sindhu M',
						'Rakshith Gowda','Nandini K','Praveen Kumar','Rashmi S','Dhanush R',
						'Asha Narayan','Vivek H','Sushmitha K','Abhilash M','Pavithra Shetty',
						'Rohith Kumar','Shruthi Ramesh','Ganesh Bhat','Ramya N','Chethan Gowda',
						'Keerthi H','Sunil Kumar B','Anusha R','Mahesh K','Varsha Shetty'
					),
					' ',
					'.'
				),
				x,FLOOR(RAND() * 100000),
				ELT(
					randbetween(1,20),
					'@gmail.com','@yahoo.com','@outlook.com','@hotmail.com','@live.com',
					'@icloud.com','@proton.me','@protonmail.com','@aol.com','@zoho.com',
					'@yandex.com','@mail.com','@gmx.com','@rediffmail.com','@inbox.com',
					'@fastmail.com','@msn.com','@me.com','@rocketmail.com','@ymail.com'
				)
			)
			,
			LEFT(
				CONCAT(
					ELT(randbetween(1,4), '9', '8', '7', '6'),
					FLOOR(RAND() * 1000000000),
					FLOOR(RAND() * 1000000000)
				),
				10
			) 						-- phone number
			,
			TIMESTAMP(
				DATE_ADD(
					'2021-01-01',
					INTERVAL FLOOR(
						RAND() * DATEDIFF('2025-12-31', '2021-01-01')
					) DAY
				),
				MAKETIME(
					randbetween(9,16),
					randbetween(0,59),
					randbetween(0,59)
				)
			)
			,
			ELT(randbetween(1,7),'INTERESTED','DEMO_SCHEDULED','LIKELY_TO_CONVERT','CONVERTED','ON_HOLD','LIKELY_LOST','LOST')
                ,
                ELT(randbetween(1,50),
					'Bidar, Karnataka','Kalaburagi, Karnataka','Raichur, Karnataka','Ballari, Karnataka','Vijayapura, Karnataka','Belagavi, Karnataka',
					'Davanagere, Karnataka','Shivamogga, Karnataka','Tumakuru, Karnataka','Mysuru, Karnataka','Mandya, Karnataka','Hassan, Karnataka','Chikkamagaluru, Karnataka',
					'Kolar, Karnataka','Chikkaballapur, Karnataka','Ramanagara, Karnataka','Hubballi, Karnataka','Dharwad, Karnataka','Udupi, Karnataka','Mangaluru, Karnataka',
					'Yadgir, Karnataka','Koppal, Karnataka','Gadag, Karnataka','Haveri, Karnataka','Bagalkote, Karnataka','Kodagu, Karnataka','Karwar, Karnataka','Bengaluru Rural, Karnataka',
					'Anantapur, Andhra Pradesh','Kadiri, Andhra Pradesh','Tirupati, Andhra Pradesh','Kurnool, Andhra Pradesh','Kadapa, Andhra Pradesh','Nellore, Andhra Pradesh','Chittoor, Andhra Pradesh',
					'Guntur, Andhra Pradesh','Vijayawada, Andhra Pradesh','Visakhapatnam, Andhra Pradesh','Rajahmundry, Andhra Pradesh','Ongole, Andhra Pradesh','Warangal, Telangana','Karimnagar, Telangana',
					'Nizamabad, Telangana','Khammam, Telangana','Mahabubnagar, Telangana','Nalgonda, Telangana','Adilabad, Telangana','Salem, Tamil Nadu','Coimbatore, Tamil Nadu','Hosur, Tamil Nadu'
				   )
				,
                ELT(
					randbetween(1,5),
					'Data Science',
					'Data Analytics',
					'Python Full Stack Development',
					'Cloud Computing',
					'Java Full Stack Development'
				   )
				,
                ELT(
					randbetween(1,3),
					'Vikram',
					'Jeeva',
					'Saravanan'
				)
                ,
                ELT(
					randbetween(1,21),
					NULL,
					'Needs time to think',
					'Need a week to decide',
					'Has exams this month',
					'Interested in weekend batch',
					'Waiting for salary',
					'Will join next month',
					'Comparing with other institutes',
					'Discussing with parents',
					'Discussing with spouse',
					'Budget constraints',
					'Currently busy with project work',
					'Planning to relocate to Bengaluru',
					'Waiting for course demo',
					'Interested but not ready yet',
					'Will confirm after current course completion',
					'Looking for online batch',
					'Looking for classroom batch',
					'Waiting for company approval',
					'Will contact after vacation',
					'Not available this month'
				)
			);
		SET x = x+1;
	END WHILE;
    
SET result = CONCAT(" ",no_of_rows," rows inserted successfully!!");

COMMIT;
END //
DELIMITER ;

-- CALL populating_student_enquiry(no_of_rows,@result)
CALL p_populating_student_enquiry(2500,@result);
SELECT @result;


							SELECT * FROM populating_student_enquiry;
                            

-- No of Records
SELECT CONCAT(COUNT(*)," rows") AS "No of Records" 
FROM populating_student_enquiry;

-- No of Students in each course
SELECT course,COUNT(*) AS "No of Students"
FROM populating_student_enquiry
GROUP BY course;

-- No of Students from each Location
SELECT address,COUNT(*) AS "No of Students"
FROM populating_student_enquiry
GROUP BY address;

SELECT * 
FROM populating_student_enquiry
WHERE email_id IS NULL OR " " OR phone IS NULL OR " ";

-- Type of Remarks 
SELECT remarks,COUNT(*) AS "No of Students"
FROM populating_student_enquiry
GROUP BY remarks;

-- No of Students interested in enrollment 
SELECT COUNT(*)
FROM populating_student_enquiry
WHERE status IN ('INTERESTED','LIKELY_TO_CONVERT','CONVERTED','DEMO_SCHEDULED');

-- No of Students Enquired
SELECT COUNT(*)
FROM populating_student_enquiry;

-- }} - END PROCEDURE p_populating_student_enquiry -




-- {{ ---------------------------------------------------------------- PROCEDURE p_populating_enrollments ---------------------------------------------
DROP PROCEDURE p_populating_enrollments;

DELIMITER //

CREATE PROCEDURE p_populating_enrollments(
IN no_of_rows INT ,
OUT result VARCHAR(250)
)

BEGIN
	DECLARE x INT DEFAULT 1;
    DECLARE inst_enq_id_date DATETIME;
    DECLARE inst_enq_id INT;
    DECLARE final_enq_id INT;
    DECLARE v_enrolled_course_id INT;
    DECLARE v_discount DECIMAL(3,2);
    DECLARE v_ongoing_fee DECIMAL(8,2);
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			ROLLBACK;
			RESIGNAL;
		END ;



START TRANSACTION;
	WHILE x <= no_of_rows DO
		
        SELECT enquiry_id,enquiry_date
		INTO inst_enq_id,inst_enq_id_date
		FROM populating_student_enquiry
		WHERE status IN  ('CONVERTED','INTERESTED','DEMO_SCHEDULED','LIKELY_TO_CONVERT')
		ORDER BY RAND()
		LIMIT 1;
        
		SET final_enq_id =
        CASE
            WHEN randbetween(1,10) <= 7
            THEN inst_enq_id
            ELSE NULL
        END;                    -- this will contain 70% admissions through enquiry and 30% through direct enrollment i.e., NULL
        
        SET v_enrolled_course_id = randbetween(1,5) ;   -- in order to store the ernolled course id 
		
        SET v_discount = ELT(randbetween(1,3),0.05,0.10,NULL) ;  -- in order to store the discount
        
        SET v_ongoing_fee =                                    -- ongoing_fee
        CASE    
				WHEN v_enrolled_course_id = 1 THEN randbetween(35000,50000) -- Data Analytics
				WHEN v_enrolled_course_id = 2 THEN randbetween(35000,45000) -- Data Science
				WHEN v_enrolled_course_id = 3 THEN randbetween(35000,45000) -- Python Full Stack Development
				WHEN v_enrolled_course_id = 4 THEN randbetween(35000,45000) -- Java Full Stack Development
				WHEN v_enrolled_course_id = 5 THEN randbetween(35000,50000) -- Cloud Computing
		END ;
        
        INSERT INTO populating_enrollments(enquiry_id,enrolled_course_id,enrolled_date,councellor_name,enrollment_status,ongoing_fee,discount,fees_to_pay,payment_plan,source,remarks)
        VALUES (
			final_enq_id       -- NULL means direct enrollment if it has enq id then its through a enquiry
            ,
            v_enrolled_course_id -- course_id will be 1,2,3,4,5
            ,
            CASE
				WHEN randbetween(1,10) <= 7
					THEN DATE_ADD(
							inst_enq_id_date,
							INTERVAL randbetween(1,30) DAY
								)
					ELSE TIMESTAMP(
							DATE_ADD(
								'2021-01-01'
                                ,
								INTERVAL FLOOR(
									RAND() * DATEDIFF('2025-12-31','2021-01-01')) DAY
									)
								,
								MAKETIME(
								randbetween(9,18),
								randbetween(0,59),
								randbetween(0,59)
										)
									)
				END
			,
            ELT(randbetween(1,4),'Vikram','Saravanan','Siva','Jeeva')
            ,
			CASE            -- enrollment_status
				WHEN final_enq_id IS NULL 
                THEN 'ENROLLED'
                ELSE ELT(randbetween(1,10),'ENROLLED','ENROLLED','ENROLLED','ENROLLED','ENROLLED','ENROLLED','ENROLLED','REJECTED','REJECTED','REJECTED')
			END    -- result of this column will be "ENROLLED" OR "REJECTED"
            ,
            v_ongoing_fee   -- ongoing_fee
			,
            v_discount  -- discount
            ,
            CASE    -- fees_to_pay
				WHEN v_discount IS NOT NULL
				THEN v_ongoing_fee - (v_ongoing_fee * v_discount)
				ELSE v_ongoing_fee
			END
            ,
            ELT(randbetween(1,3),"EMI","Installments","One_time")
			,
            ELT(randbetween(1,5),"Friend Referred","Internet","Social Media","Mouth Word","Ads")
            ,
            ELT(randbetween(1,2),NULL,"Need a job as early as possible")
		);
		
		SET x = x + 1;
        
	END WHILE;
			
			

COMMIT ;

SET result = CONCAT(no_of_rows," inserted successfully.");
 
END //

DELIMITER ;



-- CALL p_populating_enrollments(no_of_rows,@result);
CALL p_populating_enrollments(20,@result);
SELECT @result;
								DESC populating_enrollments;
								SELECT * FROM populating_enrollments;


-- Student directly Enrolled (Direct Enrollment)
SELECT * 
FROM populating_enrollments
WHERE enquiry_id IS NULL;

-- Students joined through enquiry
SELECT * 
FROM populating_enrollments
WHERE enquiry_id IS NOT NULL;

SELECT * 
FROM populating_enrollments
WHERE fees_to_pay IS NULL;

-- No of Students enrolled by Course
SELECT pc.course_name AS "Course Name",COUNT(*) AS "No of Students"
FROM populating_enrollments pe
RIGHT JOIN populating_course pc
ON pe.enrolled_course_id = pc.course_id
GROUP BY pc.course_id,pc.course_name;



-- }} - END PROCEDURE p_populating_enrollments -





-- {{ ------------------------------------------------------------- PROCEDURE p_populating_student ---------------------------------
DROP PROCEDURE p_populating_student;

DELIMITER //

CREATE PROCEDURE p_populating_student(
IN no_of_rows INT,
OUT stu_result VARCHAR(100)
)

BEGIN 
	DECLARE x INT DEFAULT 1;               -- very imp to set it to 1 if not sql will automatically set x to NULL so when runing the loop x(NULL) <= no_of_rows then FALSE loop never starts
    DECLARE v_randvalue INT;
	DECLARE v_enr_student_name VARCHAR(100);
    DECLARE v_enr_phone_number VARCHAR(12);
    DECLARE v_enr_email_id VARCHAR(100);
    DECLARE v_enr_address VARCHAR(200);
    DECLARE v_enq_enr_age INT;
    DECLARE v_enq_enr_qualification VARCHAR(100);
    DECLARE v_enq_enr_experience_level ENUM('Experienced','Fresher');
    DECLARE v_enr_id INT;
    DECLARE v_enq_student_name VARCHAR(100);
    DECLARE v_enq_phone VARCHAR(12);
    DECLARE v_enq_email_id VARCHAR(50);
    DECLARE v_enq_address VARCHAR(200);
    


	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
				ROLLBACK;
                RESIGNAL;
		END;
        
START TRANSACTION;

	WHILE x <= no_of_rows DO
		
		SET v_randvalue = randbetween(1,50);
        
		SELECT penr.enrollment_id,penq.student_name,penq.phone,penq.email_id,penq.address
        INTO v_enr_id,v_enq_student_name,v_enq_phone,v_enq_email_id,v_enq_address         -- v_student_name,v_phone,v_email,v_address will be NULL if student is a direct enrollment not through a enquiry
        FROM populating_enrollments penr
        LEFT JOIN populating_student_enquiry penq
        ON penq.enquiry_id = penr.enquiry_id
        ORDER BY RAND()
        LIMIT 1;
    
		SET v_enr_student_name = ELT(v_randvalue,'Abdul Rahman','Mohammed Arif','Syed Imran','Ayesha Fathima','Noor Ahmed','Faizan Khan','Sameera Begum','Zubair Ali','Rizwana Parveen','Shahid Hussain',
								'Ramesh Babu','Suresh Kumar','Prakash Raj','Venkatesh Murthy','Shankar Narayan','Mahalakshmi R','Gayathri Devi','Bhavani Shankar','Priyanka Reddy','Harini Krishnan',
								'Arunachalam','Karthikeyan M','Senthil Kumar','Murugan R','Balasubramanian','Vigneshwaran','Rajalakshmi','Meenakshi Sundaram','Kavitha Selvi','Yogeshwari',
								'Feroz Ahmed','Naseeruddin','Asma Banu','Tasneem Fathima','Imran Pasha','Sajid Khan','Farzana Begum','Nawaz Sharif','Yaseen Ahmed','Shabana Parveen',
                                'Rahul Verma','Neha Sharma','Amit Singh','Pankaj Yadav','Anjali Mishra','Ritu Gupta','Vishal Chauhan','Rohan Agarwal','Sneha Kapoor','Akash Pandey');
                                
                                
		SET v_enr_phone_number = LEFT(
									CONCAT(
										ELT(randbetween(1,4), '9', '8', '7', '6'),
										FLOOR(RAND() * 1000000000),
										FLOOR(RAND() * 1000000000)
										),
										10
									);
        
		SET v_enr_email_id = CONCAT(
								REPLACE(
									ELT(
										v_randvalue,
										'Abdul Rahman','Mohammed Arif','Syed Imran','Ayesha Fathima','Noor Ahmed','Faizan Khan','Sameera Begum','Zubair Ali','Rizwana Parveen','Shahid Hussain',
										'Ramesh Babu','Suresh Kumar','Prakash Raj','Venkatesh Murthy','Shankar Narayan','Mahalakshmi R','Gayathri Devi','Bhavani Shankar','Priyanka Reddy','Harini Krishnan',
										'Arunachalam','Karthikeyan M','Senthil Kumar','Murugan R','Balasubramanian','Vigneshwaran','Rajalakshmi','Meenakshi Sundaram','Kavitha Selvi','Yogeshwari',
										'Feroz Ahmed','Naseeruddin','Asma Banu','Tasneem Fathima','Imran Pasha','Sajid Khan','Farzana Begum','Nawaz Sharif','Yaseen Ahmed','Shabana Parveen',
										'Rahul Verma','Neha Sharma','Amit Singh','Pankaj Yadav','Anjali Mishra','Ritu Gupta','Vishal Chauhan','Rohan Agarwal','Sneha Kapoor','Akash Pandey'
                                
										),
										' ',
										'.'
									),
									x,FLOOR(RAND() * 100000),
									ELT(
										randbetween(1,20),
										'@gmail.com','@yahoo.com','@outlook.com','@hotmail.com','@live.com',
										'@icloud.com','@proton.me','@protonmail.com','@aol.com','@zoho.com',
										'@yandex.com','@mail.com','@gmx.com','@rediffmail.com','@inbox.com',
										'@fastmail.com','@msn.com','@me.com','@rocketmail.com','@ymail.com'
										)
									);
		SET v_enr_address = ELT(v_randvalue,'Kodigehalli, Bengaluru','Sahakara Nagar, Bengaluru','Vidyaranyapura, Bengaluru','Yelahanka, Bengaluru','Hebbal, Bengaluru',
							'Jakkur, Bengaluru','Thanisandra, Bengaluru','RK Hegde Nagar, Bengaluru','Nagawara, Bengaluru','RT Nagar, Bengaluru',
							'Ganganagar, Bengaluru','Mathikere, Bengaluru','Dollars Colony, Bengaluru','New BEL Road, Bengaluru','Kempapura, Bengaluru',
							'Bagalur, Bengaluru','Hennur, Bengaluru','Kogilu, Bengaluru','Allalasandra, Bengaluru','Byatarayanapura, Bengaluru',
							'Mysuru, Karnataka','Tumakuru, Karnataka','Shivamogga, Karnataka','Mangaluru, Karnataka','Hubballi, Karnataka',
							'Davanagere, Karnataka','Belagavi, Karnataka','Udupi, Karnataka','Hassan, Karnataka','Mandya, Karnataka',
							'Chitradurga, Karnataka','Kolar, Karnataka','Ramanagara, Karnataka','Chikkamagaluru, Karnataka','Ballari, Karnataka',
							'Chennai, Tamil Nadu','Coimbatore, Tamil Nadu','Salem, Tamil Nadu','Madurai, Tamil Nadu','Vellore, Tamil Nadu',
							'Hyderabad, Telangana','Secunderabad, Telangana','Warangal, Telangana','Karimnagar, Telangana','Nizamabad, Telangana',
							'Vijayawada, Andhra Pradesh','Visakhapatnam, Andhra Pradesh','Guntur, Andhra Pradesh','Tirupati, Andhra Pradesh','Kurnool, Andhra Pradesh');
		SET v_enq_enr_age = randbetween(19,45);
        
        SET v_enq_enr_qualification = ELT(randbetween(1,20),'B.E CSE','B.E ISE','B.E ECE','B.Tech CSE','B.Tech IT','BCA','MCA','B.Sc Computer Science','B.Sc Information Technology',
							  'B.Sc Mathematics','B.Sc Statistics','B.Com','M.Com','BBA','MBA','Diploma in Computer Science','Diploma in Information Technology','Polytechnic',
                              'M.Sc Computer Science','M.Sc Data Science');
		
        SET v_enq_enr_experience_level = ELT(randbetween(1,2),'Experienced','Fresher');
        
        
        INSERT INTO populating_student(enrollment_id,student_name,phone,email_id,address,age,qualification,experience_level)
					VALUES(
							v_enr_id   -- enrollment_id
                            ,
                            CASE   -- student_name
								WHEN v_enq_student_name IS NOT NULL THEN v_enq_student_name
                                WHEN v_enq_student_name IS NULL THEN v_enr_student_name
							END
                            ,
                            CASE   -- phone
								WHEN v_enq_phone IS NOT NULL THEN v_enq_phone
                                WHEN v_enq_phone IS NULL THEN v_enr_phone_number
							END
                            ,
                            CASE    -- email_id
								WHEN v_enq_email_id IS NOT NULL THEN v_enq_email_id
                                WHEN v_enq_email_id IS NULL THEN v_enr_email_id
							END
                            ,
                            CASE     -- address
								WHEN v_enq_address IS NOT NULL THEN v_enq_address
                                WHEN v_enq_address IS NULL THEN v_enr_address
							END
                            ,
                            v_enq_enr_age   -- age
                            ,
                            v_enq_enr_qualification  -- qualification
                            ,
                            v_enq_enr_experience_level   -- experience_level
						);
        
		SET x = x + 1;
    END WHILE;

COMMIT;
SET stu_result = CONCAT(" ",no_of_rows," inserted successfully into populating_student table");
END //
DELIMITER ;


-- CALL p_populating_student(no_of_rows,@result);
CALL p_populating_student(10,@stu_result);
SELECT @stu_result;



								SELECT * FROM populating_student;
                                


-- }} END OF PROCEDURE p_populating_student




-- {{ ------------------------------------------------------------- PROCEDURE p_populating_payments -----------------------------------------------------

DELIMITER //

CREATE PROCEDURE p_populating_payments(
IN no_of_rows INT ,
OUT result VARCHAR(250)
)

BEGIN
	DECLARE x INT DEFAULT 1;
    DECLARE v_student_id INT;
    DECLARE v_course_id INT;
    DECLARE v_fees_to_pay DECIMAL(8,2);
    DECLARE v_payment_plan ENUM('EMI','Installments','One_time');
    DECLARE v_ DECIMAL(3,2);
    DECLARE v_ DECIMAL(8,2);
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			ROLLBACK;
			RESIGNAL;
		END ;



START TRANSACTION;
	WHILE x <= no_of_rows DO
		
        SELECT pstu.student_id,penr.enrolled_course_id,penr.Fees_to_Pay,penr.Payment_Plan
		INTO v_student_id,v_course_id,v_fees_to_pay,v_payment_plan
		FROM populating_student pstu
        JOIN populating_enrollments penr
        ON penr.enrollment_id = pstu.enrollment_id
        ORDER BY RAND()
		LIMIT 1;
        
        
        -- BYE 
		SET final_enq_id =
        CASE
            WHEN randbetween(1,10) <= 7
            THEN inst_enq_id
            ELSE NULL
        END;                    -- this will contain 70% admissions through enquiry and 30% through direct enrollment i.e., NULL
        
        SET v_enrolled_course_id = randbetween(1,5) ;   -- in order to store the ernolled course id 
		
        SET v_discount = ELT(randbetween(1,3),0.05,0.10,NULL) ;  -- in order to store the discount
        
        SET v_ongoing_fee =                                    -- ongoing_fee
        CASE    
				WHEN v_enrolled_course_id = 1 THEN randbetween(35000,50000) -- Data Analytics
				WHEN v_enrolled_course_id = 2 THEN randbetween(35000,45000) -- Data Science
				WHEN v_enrolled_course_id = 3 THEN randbetween(35000,45000) -- Python Full Stack Development
				WHEN v_enrolled_course_id = 4 THEN randbetween(35000,45000) -- Java Full Stack Development
				WHEN v_enrolled_course_id = 5 THEN randbetween(35000,50000) -- Cloud Computing
		END ;
        
        INSERT INTO populating_enrollments(enquiry_id,enrolled_course_id,enrolled_date,councellor_name,enrollment_status,ongoing_fee,discount,fees_to_pay,payment_plan,source,remarks)
        VALUES (
			final_enq_id       -- NULL means direct enrollment if it has enq id then its through a enquiry
            ,
            v_enrolled_course_id -- course_id will be 1,2,3,4,5
            ,
            CASE
				WHEN randbetween(1,10) <= 7
					THEN DATE_ADD(
							inst_enq_id_date,
							INTERVAL randbetween(1,30) DAY
								)
					ELSE TIMESTAMP(
							DATE_ADD(
								'2021-01-01'
                                ,
								INTERVAL FLOOR(
									RAND() * DATEDIFF('2025-12-31','2021-01-01')) DAY
									)
								,
								MAKETIME(
								randbetween(9,18),
								randbetween(0,59),
								randbetween(0,59)
										)
									)
				END
			,
            ELT(randbetween(1,4),'Vikram','Saravanan','Siva','Jeeva')
            ,
			CASE            -- enrollment_status
				WHEN final_enq_id IS NULL 
                THEN 'ENROLLED'
                ELSE ELT(randbetween(1,10),'ENROLLED','ENROLLED','ENROLLED','ENROLLED','ENROLLED','ENROLLED','ENROLLED','REJECTED','REJECTED','REJECTED')
			END    -- result of this column will be "ENROLLED" OR "REJECTED"
            ,
            v_ongoing_fee   -- ongoing_fee
			,
            v_discount  -- discount
            ,
            CASE    -- fees_to_pay
				WHEN v_discount IS NOT NULL
				THEN v_ongoing_fee - (v_ongoing_fee * v_discount)
				ELSE v_ongoing_fee
			END
            ,
            ELT(randbetween(1,3),"EMI","Installments","One_time")
			,
            ELT(randbetween(1,5),"Friend Referred","Internet","Social Media","Mouth Word","Ads")
            ,
            ELT(randbetween(1,2),NULL,"Need a job as early as possible")
		);
		
		SET x = x + 1;
        
	END WHILE;
			
			

COMMIT ;

SET result = CONCAT(no_of_rows," inserted successfully.");
 
END //

DELIMITER ;





-- }} END OF PROCEDURE p_populating_payments








-- {{ ---------------------------------------------------------------- PROCEDURE p_populate_besant_database_v05 ---------------------------------------------

DROP PROCEDURE p_populate_besant_database_v05;

DELIMITER //

CREATE PROCEDURE p_populate_besant_database_v05(
IN no_of_rows INT,
OUT result VARCHAR(100)
)

BEGIN 
	DECLARE v_result1 VARCHAR(100);
    DECLARE v_result2 VARCHAR(100);

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
				ROLLBACK;
                RESIGNAL;
		END;
        
START TRANSACTION;

    CALL p_populating_student_enquiry(no_of_rows * 1.30, v_result1);

    CALL p_populating_enrollments(no_of_rows, v_result2);

    SET result = CONCAT(
        'Student Enquiry: ', v_result1,
        ' | Enrollment: ', v_result2
    );


COMMIT;
END //
DELIMITER ;


-- CALL p_populate_besant_database_v05(no_of_rows,@result);
CALL p_populate_besant_database_v05(10,@result);  -- remember that populating_student_enquiry will add 30% more rows than entered
SELECT @result;

							SELECT * FROM populating_student_enquiry;
							SELECT * FROM populating_enrollments;
                            
-- }} END OF PROCEDURE p_populate_besant_database_v05





