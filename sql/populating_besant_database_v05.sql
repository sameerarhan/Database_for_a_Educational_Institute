CREATE DATABASE besant_database_v05;
USE besant_database_v05;

-- DROP DATABASE besant_database_v05;
SHOW TABLES;  -- tables
SHOW TRIGGERS;  -- triggers
SHOW PROCEDURE status    -- Procedures
WHERE db = 'besant_database_v05';
SHOW FUNCTION STATUS WHERE Db = DATABASE();   -- Functions



-- {{ 


SELECT * FROM course;   
SELECT * FROM subject;
SELECT * FROM course_sub;
SELECT * FROM coordinator;
SELECT * FROM batch;
SELECT * FROM instructor;
SELECT * FROM student_enquiry;
SELECT * FROM enrollments;
SELECT * FROM student;
SELECT * FROM payments;
SELECT * FROM student_batch;


DESC course;
DESC subject;
DESC course_sub;
DESC coordinator;
DESC batch;
DESC instructor;
DESC student_enquiry;
DESC enrollments;
DESC student;
DESC payments;
DESC student_batch;


SHOW CREATE TABLE course;
SHOW CREATE TABLE subject;
SHOW CREATE TABLE course_sub;
SHOW CREATE TABLE coordinator;
SHOW CREATE TABLE batch;
SHOW CREATE TABLE instructor;
SHOW CREATE TABLE student_enquiry;
SHOW CREATE TABLE enrollments;
SHOW CREATE TABLE student;
SHOW CREATE TABLE payments;
SHOW CREATE TABLE student_batch;






-- }}




-- -------------------------------------------------------------- Just Practice ------------------------------------------------------------------------------------

-- Populating a table of names,age,salary
CREATE TABLE cust_prac_table(
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

        INSERT INTO cust_prac_table(cust_name,age)
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


SELECT * FROM cust_prac_table
WHERE age IS NOT NULL;

SELECT AVG(age),MIN(age),MAX(age) FROM cust_prac_table;    -- to know how are the values randomized

SELECT age,COUNT(*) AS 'No of Customers'           -- to know the mode(age) | customers of what age are highest in number
FROM cust_prac_table
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

-- - TABLE student_enquiry -
-- - TABLE enrollments -
-- - TABLE student -
-- - TABLE subject -
-- - TABLE course -
-- - TABLE coordinator -
-- - TABLE instructor -
-- - TABLE batch -
-- - TABLE payments -
-- TABLE course_sub 
-- - TABLE student_batch -
-- - TABLE enrolled_courses -




-- ----------------------------------------------------------------- TABLE student_enquiry ----------------------------------

-- {{ TABLE student_enquiry
 
-- Creating a TABLE student_enquiry in stored_proc_order_by_me by copying the structure of Table student_enquiry from besant_database_v05
CREATE TABLE besant_database_v05.student_enquiry LIKE
besant_database_v05.student_enquiry;

INSERT INTO stored_proc_order_by_me.student_enquiry 
SELECT * FROM besant_database_v05.student_enquiry;

ALTER TABLE student_enquiry
MODIFY COLUMN status ENUM('NEW','INTERESTED','DEMO_SCHEDULED','LIKELY_TO_CONVERT','CONVERTED','ON_HOLD','LIKELY_LOST','LOST');

DESC student_enquiry;
ALTER TABLE student_enquiry    -- added an extra attribute "gender"
ADD COLUMN gender ENUM("Male","Female") ;

SHOW CREATE TABLE student_enquiry;
							SELECT * FROM student_enquiry;
                            DESC student_enquiry;
-- }} 
								

-- -------------------------------------------------------------- TABLE enrollments ---------------------------------------------------

-- {{ TABLE enrollments 

-- Creating a TABLE enrollments by copying the structure from besant_database_v05.enrollments
CREATE TABLE besant_database_v05.enrollments LIKE   -- created a table enrollments by copying the structure of table besant_database_v05.enrollments
besant_database_v05.enrollments;

INSERT INTO stored_proc_order_by_me.enrollments 
SELECT * FROM besant_database_v05.enrollments;

ALTER TABLE enrollments
ADD UNIQUE(enquiry_id);


-- check for duplicate enquiry_id 
SELECT enquiry_id
FROM enrollments
GROUP BY enquiry_id
HAVING COUNT(*) > 1;
-- we had composite PK now changed it to PK with one column i.e., enrollment_id => one enrollment_id can enroll to only one course


ALTER TABLE enrollments
DROP PRIMARY KEY,
ADD PRIMARY KEY(enrollment_id);

SHOW CREATE TABLE enrollments;
SHOW INDEX FROM enrollments;

ALTER TABLE enrollments
ADD FOREIGN KEY(enquiry_id) REFERENCES student_enquiry(enquiry_id);

ALTER TABLE enrollments
ADD FOREIGN KEY(enrolled_course_id) REFERENCES course(course_id);

ALTER TABLE enrollments
DROP INDEX enrolled_course_id_idx;




									SELECT * FROM enrollments;
									DESC enrollments;
                                    
-- }}

 

-- ----------------------------------------------------------- TABLE student ----------------------------------------------------

-- {{ TABLE student
CREATE TABLE besant_database_v05.student LIKE   -- created a table enrollments by copying the structure of table besant_database_v05.enrollments
besant_database_v05.student;

INSERT INTO stored_proc_order_by_me.enrollments 
SELECT * FROM besant_database_v05.enrollments;

ALTER TABLE student
ADD UNIQUE(enrollment_id);

SHOW CREATE TABLE student;

ALTER TABLE student
DROP PRIMARY KEY,
ADD PRIMARY KEY(student_id);



-- }} 


-- ------------------------------------------------------ TABLE course -----------------------------------------------------------------

-- {{ TABLE course - (no population static data[Dimension])
-- Creating TABLE course table by copying the schema of besant_database_v05.course

CREATE TABLE besant_database_v05.course LIKE
besant_database_v05.course;

INSERT INTO course(course_id, course_name, course_fee ,coordinator_id)
VALUES(1, 'Data Analytics', 42500,1),(2, 'Data Science', 40000,3),(3, 'Python Full Stack Development', 40000,2),(4, 'Java Full Stack Development', 40000,1),(5, 'Cloud Computing', 42500,3);

									SELECT * FROM course;
                                    DESC course;
                                    
-- }} 



-- ------------------------------------------------------ TABLE subject -----------------------------------------------------------------

-- {{ TABLE subject (no populating - static data[Dimension]) 

CREATE TABLE besant_database_v05.subject LIKE
besant_database_v05.subject;

INSERT INTO subject (subject_name)
VALUES ('Microsoft Excel'),('Power BI'),('Microsoft Power BI'),('Python'),('Data Science'),('Java'),('ReactJS'),
		('Django'),('Cloud Computing'),('DevOps'),('AWS'),('SQL');
        

											SELECT * FROM subject;
                                            DESC subject;


-- }} 



-- ---------------------------------------------------------------- TABLE coordinator ------------------------------------------------------------

-- {{ TABLE coordinator (no populating - static data[Dimension])

CREATE TABLE besant_database_v05.coordinator LIKE
besant_database_v05.coordinator;

INSERT INTO coordinator(Coordinator_id,Coordinator_name,age,Gender,role)
VALUES(1, 'Saravanan', 38, 'Male', 'Staff'),(2, 'Vikram', 35, 'Male', 'Staff'),(3, 'Siva', 24, 'Male', 'Staff'),(4, 'Jeeva', 40, 'Male', 'Manager');


										SELECT * FROM coordinator;
                                        DESC coordinator;

-- }} 


-- ---------------------------------------------------------------- TABLE payments ------------------------------------------------------------

-- {{ TABLE payments

CREATE TABLE besant_database_v05.payments LIKE
besant_database_v05.payments;

ALTER TABLE payments
ADD FOREIGN KEY (student_id) REFERENCES student(student_id);
ALTER TABLE payments
ADD FOREIGN KEY (course_id) REFERENCES course(course_id);


ALTER TABLE payments
DROP PRIMARY KEY,
ADD PRIMARY KEY (payment_id,student_id);

SHOW CREATE TABLE payments;
										SELECT * FROM payments;
                                        DESC payments;
-- }} 

-- ---------------------------------------------------------------- TABLE batch ------------------------------------------------------------

-- {{ TABLE batch

CREATE TABLE besant_database_v05.batch LIKE
besant_database_v05.batch;

ALTER TABLE batch
ADD CONSTRAINT UNIQUE(batch_name);  -- bcz when creating random data it might create same 2 batches with same name this unique prevents 
									-- it may be create 2 batches in same day but with different subject name 

ALTER TABLE batch
ADD FOREIGN KEY (instructor_id) REFERENCES instructor(instructor_id);

ALTER TABLE batch
ADD FOREIGN KEY (course_id) REFERENCES course(course_id);

ALTER TABLE payments
DROP FOREIGN KEY batch_ibfk_2;

ALTER TABLE batch
ADD FOREIGN KEY (subject_id) REFERENCES subject(subject_id);


SHOW CREATE TABLE batch;

									SELECT * FROM batch;
                                    DESC batch;
                                   
                                   
-- }} 


-- ---------------------------------------------------------------- TABLE instructor ------------------------------------------------------------

-- {{ TABLE instructor (no populating - static data[Dimension] )

CREATE TABLE besant_database_v05.instructor LIKE
besant_database_v05.instructor;

INSERT INTO instructor(instructor_id,instructor_name,age,gender)
VALUES (1,"Krishnan",52,"Male"),(2,"Chandana",28,"Female"),(3,"Anikit",30,"Male"),(4,"Kishore",32,"Male");


										SELECT * FROM instructor;
                                        DESC instructor;
                                        
-- }} 


-- ---------------------------------------------------------------- TABLE student_batch ------------------------------------------------------------

-- {{ TABLE student_batch

CREATE TABLE besant_database_v05.student_batch LIKE
besant_database_v05.student_batch;



										SELECT * FROM student_batch;
                                        DESC student_batch;
                                        
-- }} 


-- ---------------------------------------------------------------- TABLE course_sub ------------------------------------------------------------

-- {{ TABLE course_sub

CREATE TABLE besant_database_v05.course_sub LIKE
besant_database_v05.course_sub;


ALTER TABLE course_sub
ADD FOREIGN KEY (course_id) REFERENCES course(course_id);

ALTER TABLE course_sub
ADD FOREIGN KEY (subject_id) REFERENCES subject(subject_id);

SHOW CREATE TABLE course_sub;

SELECT pc.course_id,ps.subject_id
FROM course pc,subject ps;

INSERT INTO course_sub(course_id, subject_id)
VALUES (1,1),(1,3),(1,4),(1,12), (2,1),(2,3),(2,4),(2,5),(2,12), (3,4),(3,7),(3,12),(3,8), (4,6),(4,12),(4,7), (5,9),(5,10),(5,11),(5,12);


                                        SELECT * FROM course_sub;
                                        DESC course_sub;
                        

                        




-- }} END OF TABLE course_sub

-- ---------------------------------------------------------------- TABLE course_sub ------------------------------------------------------------


-- ===================================================================            - PROCEDURES -                 =============================================================

-- {{ ---------------------------------------------------------------- PROCEDURE p_student_enquiry --------------------------------------------------------------
DROP PROCEDURE p_student_enquiry;


DELIMITER //

CREATE PROCEDURE p_student_enquiry(
IN no_of_rows INT ,
OUT result VARCHAR(200)
)

BEGIN                    -- ORDER => 1.Temp Variables 2.Cursors 3.EXIT Handler i.e., DECLARE variables DECLARE conditions(optional) DECLARE cursors DECLARE handlers
        
	DECLARE x INT DEFAULT 1;
    DECLARE randvalue INT ;
    DECLARE v_no_of_rows INT;
    
	DECLARE EXIT HANDLER FOR SQLEXCEPTION 
		BEGIN 
			ROLLBACK;
			RESIGNAL;
		END;
    
    SELECT COUNT(*)
    INTO v_no_of_rows
    FROM student_enquiry;
    
START TRANSACTION ;    
	WHILE x <= no_of_rows DO 
    
		SET randvalue = randbetween(1,50);
        
		INSERT INTO student_enquiry(student_name,email_id,phone,enquiry_date,status,address,course,councellor_name,remarks)
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
			) -- student_name
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
			) -- email_id
			,
			CONCAT(
				ELT(randbetween(1,3),'9','7','8'),				
				LPAD(v_no_of_rows + x, 9, '0')            -- x= 1 ; 90000000001 | x =2 ; 8000000002
			) -- phone number
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
			) -- enquiry_date 
			,
			ELT(randbetween(1,7),'INTERESTED','DEMO_SCHEDULED','LIKELY_TO_CONVERT','CONVERTED','ON_HOLD','LIKELY_LOST','LOST') -- status
			,
			ELT(randbetween(1,50),
					'Bidar, Karnataka','Kalaburagi, Karnataka','Raichur, Karnataka','Ballari, Karnataka','Vijayapura, Karnataka','Belagavi, Karnataka',
					'Davanagere, Karnataka','Shivamogga, Karnataka','Tumakuru, Karnataka','Mysuru, Karnataka','Mandya, Karnataka','Hassan, Karnataka','Chikkamagaluru, Karnataka',
					'Kolar, Karnataka','Chikkaballapur, Karnataka','Ramanagara, Karnataka','Hubballi, Karnataka','Dharwad, Karnataka','Udupi, Karnataka','Mangaluru, Karnataka',
					'Yadgir, Karnataka','Koppal, Karnataka','Gadag, Karnataka','Haveri, Karnataka','Bagalkote, Karnataka','Kodagu, Karnataka','Karwar, Karnataka','Bengaluru Rural, Karnataka',
					'Anantapur, Andhra Pradesh','Kadiri, Andhra Pradesh','Tirupati, Andhra Pradesh','Kurnool, Andhra Pradesh','Kadapa, Andhra Pradesh','Nellore, Andhra Pradesh','Chittoor, Andhra Pradesh',
					'Guntur, Andhra Pradesh','Vijayawada, Andhra Pradesh','Visakhapatnam, Andhra Pradesh','Rajahmundry, Andhra Pradesh','Ongole, Andhra Pradesh','Warangal, Telangana','Karimnagar, Telangana',
					'Nizamabad, Telangana','Khammam, Telangana','Mahabubnagar, Telangana','Nalgonda, Telangana','Adilabad, Telangana','Salem, Tamil Nadu','Coimbatore, Tamil Nadu','Hosur, Tamil Nadu'
				) -- Address
			,
                ELT(
					randbetween(1,5),
					'Data Science',
					'Data Analytics',
					'Python Full Stack Development',
					'Cloud Computing',
					'Java Full Stack Development'
				   ) -- course
			,
                ELT(
					randbetween(1,3),
					'Vikram',
					'Jeeva',
					'Saravanan'
				) -- councellor_name
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
				) -- remarks
			);
		SET x = x+1;
	END WHILE;
    
SET result = CONCAT(no_of_rows," rows inserted successfully into student_enquiry table");

COMMIT;
END //
DELIMITER ;



-- CALL student_enquiry(no_of_rows,@result)
CALL p_student_enquiry(50000,@result);
SELECT @result;

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE student_enquiry;
SET FOREIGN_KEY_CHECKS = 1;


								 SELECT * FROM student_enquiry ;
                            





-- }} - END PROCEDURE p_student_enquiry -




-- {{ ---------------------------------------------------------------- PROCEDURE p_enrollments ---------------------------------------------
DROP PROCEDURE p_enrollments;

DELIMITER //

CREATE PROCEDURE p_enrollments(
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

-- 	CREATE TEMPORARY TABLE temp_enquiries
-- 	SELECT enquiry_id,enquiry_date
-- 	FROM student_enquiry
-- 	WHERE status IN (
-- 		'CONVERTED',
-- 		'INTERESTED',
-- 		'DEMO_SCHEDULED',
-- 		'LIKELY_TO_CONVERT'
-- 	);


START TRANSACTION;
	WHILE x <= no_of_rows DO
		
		SELECT pse.enquiry_id,pse.enquiry_date
		INTO inst_enq_id,inst_enq_id_date
		FROM student_enquiry pse
		WHERE pse.status IN ('CONVERTED','INTERESTED','DEMO_SCHEDULED','LIKELY_TO_CONVERT')
		AND NOT EXISTS
		(
			SELECT 1
			FROM enrollments pe
			WHERE pe.enquiry_id = pse.enquiry_id
		)
		ORDER BY RAND()
		LIMIT 1;
        
--         SELECT enquiry_id,enquiry_date
-- 		INTO inst_enq_id,inst_enq_id_date
-- 		FROM temp_enquiries
-- 		ORDER BY RAND()
-- 		LIMIT 1;
        
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
        
        INSERT INTO enrollments(enquiry_id,enrolled_course_id,enrolled_date,councellor_name,enrollment_status,ongoing_fee,discount,fees_to_pay,payment_plan,source,remarks)
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

SET result = CONCAT(no_of_rows," inserted successfully into enrollments table");

END //

DELIMITER ;

show processlist;
kill 28;

-- CALL p_enrollments(no_of_rows,@result);
CALL p_enrollments(3000,@result);
SELECT @result;
								DESC enrollments;
								SELECT * FROM enrollments;


-- Student directly Enrolled (Direct Enrollment)
SELECT * 
FROM enrollments
WHERE enquiry_id IS NULL;

-- Students joined through enquiry
SELECT * 
FROM enrollments
WHERE enquiry_id IS NOT NULL;

SELECT * 
FROM enrollments
WHERE fees_to_pay IS NULL;

-- No of Students enrolled by Course
SELECT pc.course_name AS "Course Name",COUNT(*) AS "No of Students"
FROM enrollments pe
RIGHT JOIN course pc
ON pe.enrolled_course_id = pc.course_id
GROUP BY pc.course_id,pc.course_name;



-- }} - END PROCEDURE p_enrollments -





-- {{ ------------------------------------------------------------- PROCEDURE p_student ---------------------------------
DROP PROCEDURE p_student;

DELIMITER //

CREATE PROCEDURE p_student(
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
        
		SELECT penr.enrollment_id,
			   penq.student_name,
			   penq.phone,
			   penq.email_id,
			   penq.address
		INTO v_enr_id,
			 v_enq_student_name,
			 v_enq_phone,
			 v_enq_email_id,
			 v_enq_address
		FROM enrollments penr
		LEFT JOIN student_enquiry penq
		ON penq.enquiry_id = penr.enquiry_id
		WHERE NOT EXISTS
		(
			SELECT 1
			FROM student ps
			WHERE ps.enrollment_id = penr.enrollment_id
		)
		ORDER BY RAND()
		LIMIT 1;
        
-- 		   SELECT penr.enrollment_id,penq.student_name,penq.phone,penq.email_id,penq.address
--         INTO v_enr_id,v_enq_student_name,v_enq_phone,v_enq_email_id,v_enq_address         -- v_student_name,v_phone,v_email,v_address will be NULL if student is a direct enrollment not through a enquiry
--         FROM enrollments penr
--         LEFT JOIN student_enquiry penq
--         ON penq.enquiry_id = penr.enquiry_id
--         ORDER BY RAND()
--         LIMIT 1;
    
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
        
        
        INSERT INTO student(enrollment_id,student_name,phone,email_id,address,age,qualification,experience_level)
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
SET stu_result = CONCAT(no_of_rows," inserted successfully into student table");
END //
DELIMITER ;


-- CALL p_student(no_of_rows,@result);
CALL p_student(10,@result);
SELECT @result;



								SELECT * FROM student;
                                


-- }} END OF PROCEDURE p_student




-- {{ ------------------------------------------------------------- PROCEDURE p_payments -----------------------------------------------------
DROP PROCEDURE p_payments;   -- payment_datetime column the time is not set it is showing 2023-08-12 00:00:00

DELIMITER //

CREATE PROCEDURE p_payments(
IN no_of_rows INT ,
OUT result VARCHAR(250)
)

BEGIN
	DECLARE x INT DEFAULT 1;
    DECLARE v_student_id INT;
    DECLARE v_course_id INT;
    DECLARE v_fees_to_pay DECIMAL(8,2);
    DECLARE v_payment_plan ENUM('EMI','Installments','One_time');
    DECLARE v_enrolled_date DATETIME;
    DECLARE v_amount_abt_to_pay DECIMAL(8,2);
    DECLARE v_amount_already_paid_till_now_sum DECIMAL(8,2);
    DECLARE v_amount_already_paid_plus_amount_abt_to_pay DECIMAL(8,2);
    DECLARE v_payment_date DATE;
    DECLARE v_mode_of_payment VARCHAR(45);
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			ROLLBACK;
			RESIGNAL;
		END ;



START TRANSACTION;
	payment_loop:
	WHILE x <= no_of_rows DO
		
		SELECT pstu.student_id,
			   penr.enrolled_course_id,
			   penr.Fees_to_Pay,
			   penr.Payment_Plan,
			   penr.enrolled_date
		INTO v_student_id,
			 v_course_id,
			 v_fees_to_pay,
			 v_payment_plan,
			 v_enrolled_date
		FROM student pstu
		JOIN enrollments penr
			ON penr.enrollment_id = pstu.enrollment_id
		ORDER BY RAND()
		LIMIT 1;
        
		SELECT IFNULL(SUM(amount_paid),0) 
		INTO v_amount_already_paid_till_now_sum
		FROM payments
		WHERE student_id = v_student_id;
        
        -- SET v_payment_date = d;
        
		SET v_amount_abt_to_pay =
		LEAST(
			CASE
				WHEN randbetween(1,10) <= 7
				THEN randbetween(5000,20000)
				ELSE randbetween(20001,50000)
			END,
			v_fees_to_pay - IFNULL(v_amount_already_paid_till_now_sum,0)
		);

		IF v_amount_abt_to_pay <= 0 THEN
			SET x = x + 1;
			ITERATE payment_loop;
		END IF;

       SET v_payment_date =  
			CASE
				WHEN v_payment_plan IN ("One_time","EMI") THEN DATE_ADD(v_enrolled_date , INTERVAL randbetween(0,1) DAY )
				WHEN v_payment_plan = "Installments" THEN DATE_ADD(v_enrolled_date , INTERVAL randbetween(1,30) DAY )
			END;
            
	   SET v_mode_of_payment = ELT(randbetween(1,4),'Card','Cash','UPI','Net Banking');
        
--         SET v_amount_already_paid_plus_amount_abt_to_pay = v_amount_already_paid_till_now_sum + v_amount_abt_to_pay ;
-- 		
--         -- Validation 1 - to see if the fees
-- 		IF v_amount_already_paid_plus_amount_abt_to_pay > v_fees_to_pay THEN
-- 				SIGNAL SQLSTATE '45000'
-- 				SET MESSAGE_TEXT = 'Amount paid greater than fees to pay';
-- 		END IF;	

        INSERT INTO payments(student_id,course_id,date,amount_paid,mode_of_payment)
        VALUES (
			v_student_id       
            ,
            v_course_id 
            ,
			v_payment_date
			,
			v_amount_abt_to_pay
            ,
            v_mode_of_payment
            );
		
    
		
		SET x = x + 1;
        
	END WHILE;
			
			
COMMIT ;

SET result = CONCAT(no_of_rows," inserted successfully into payments table");
 
END //

DELIMITER ;




-- CALL p_payments(no_of_rows,@result);
CALL p_payments(1,@result);
SELECT @result;

									SELECT * FROM payments;
                                    

SELECT * FROM student;
SELECT * FROM payments;


-- }} END OF PROCEDURE p_payments






-- {{{------------------------------------------------------------------------- PROCEDURE p_batch ----------------------------------------------------------

DROP PROCEDURE p_batch; -- prblm - if batch_name is devops_23_jan... then the course_id for that row is 2 which is Data Science and subject_id for that row is 5 which is sql
								   -- assuming any instructor can teach any subject
DELIMITER //

CREATE PROCEDURE p_batch(
IN no_of_rows INT ,
OUT result VARCHAR(250)
)

BEGIN
	DECLARE x INT DEFAULT 1;

	DECLARE v_random_wd_start_date DATE;
	DECLARE v_random_wd_end_date DATE;

	DECLARE v_random_wk_start_date DATE;
	DECLARE v_random_wk_end_date DATE;

	DECLARE v_batch_wd_name VARCHAR(100);
	DECLARE v_batch_wk_name VARCHAR(100);

	DECLARE v_batch_name_final_randbet_wd_wk VARCHAR(100);

	DECLARE v_final_start_date DATE;
	DECLARE v_final_end_date DATE;

	DECLARE v_total_students INT;

	DECLARE v_timings TIME;

	DECLARE v_batch_day ENUM("WEEKDAYS","WEEKENDS");

	DECLARE v_instructor_id INT;

	DECLARE v_subject_id INT;
    DECLARE v_subject_name VARCHAR(100);
    
    DECLARE v_course_id INT;


    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			ROLLBACK;
			RESIGNAL;
		END ;



START TRANSACTION;
	WHILE x <= no_of_rows DO        
		
        SET v_random_wd_start_date = DATE_ADD('2021-01-01', INTERVAL FLOOR(RAND() * DATEDIFF(CURDATE(),'2021-01-01')) DAY); -- random date between 2021 and curdate()
        
        SET v_random_wd_end_date = 
										DATE_ADD(v_random_wd_start_date, INTERVAL randbetween(30,35) DAY);
                                    
        SET v_batch_wd_name = CONCAT(
									ELT( 
										randbetween(1,11),'Microsoft Excel','Microsoft Power BI','Python','Data Science','Java','ReactJS','Django','Cloud Computing','DevOps','AWS','SQL'
                                        ),             
										"_",DATE_FORMAT(v_random_wd_start_date,'%d_%b_%Y'),"_",DATE_FORMAT(v_random_wd_end_date,'%d_%b_%Y'),"_WD"
								);					-- ^^ above here it converts date as 01_Jul_2024 this format                 -- SQL_Jan_11_2026_Feb_11_2026_WD
                            
		SET v_random_wk_start_date = DATE_ADD(
											DATE_ADD('2021-01-02', INTERVAL FLOOR(RAND() * (DATEDIFF(CURDATE(),'2021-01-02') DIV 7)) * 7 DAY),
											INTERVAL 0 DAY
										); --  2024-05-22 | a random saturday between 2021-01-01 and curdate() 
					
		SET v_random_wk_end_date = DATE_ADD(v_random_wk_start_date,INTERVAL 29 DAY);  -- if wk_batch starts on saturday it ends on +5 weekends on sunday
        
        SET v_batch_wk_name = CONCAT(
									ELT(
										randbetween(1,11),'Microsoft Excel','Microsoft Power BI','Python','Data Science','Java','ReactJS','Django','Cloud Computing','DevOps','AWS','SQL'
                                        ),
										"_",DATE_FORMAT(v_random_wk_start_date,"%d_%b_%Y"),"_",DATE_FORMAT(v_random_wk_end_date,"%d_%b_%Y"),"_WK"
								);   -- 	^^ above here it converts date as 01_Jul_2024 this format | SQL_Jan_11_2026_Feb_11_2026_WK
        
        SET v_batch_name_final_randbet_wd_wk = ELT(
												IF(randbetween(1,10) <= 7, 1, 2),
												v_batch_wd_name,v_batch_wk_name
                                                ); -- result - AWS_Mar_24_2023_Apr_24_2023_WD - 7 times || AWS_Mar_24_2023_Apr_24_2023_WK - 3 times \ 7 times it would be weekday batch and 3 times it would be weekend batch
                                                
		SET v_final_start_date = IF(
									RIGHT(v_batch_name_final_randbet_wd_wk,2) = "WD",v_random_wd_start_date,v_random_wk_start_date
                                    );
                                    
		SET v_final_end_date = IF(
								  RIGHT(v_batch_name_final_randbet_wd_wk,2) = "WD",v_random_wd_end_date,v_random_wk_end_date
								 ); 
                                 
		SET v_total_students = 0;
        
        SET v_timings = MAKETIME( randbetween(7,12),0,0 );
        
        SET v_batch_day = IF ( 
								RIGHT(v_batch_name_final_randbet_wd_wk,2) = "WD","WEEKDAYS","WEEKENDS"
							  );
                              
		SET v_instructor_id = randbetween(1,4); -- assuming any instructor can teach any subject
	
    -- set the subjectid before setting the courseid
		SET v_subject_name = SUBSTRING_INDEX(v_batch_name_final_randbet_wd_wk,'_',1);        -- SELECT SUBSTRING_INDEX('SQL_Jan_11_2026_Feb_11_2026_WK','_',1);
        
        SELECT subject_id 
        INTO v_subject_id          -- SET v_subject_id
        FROM subject  
        WHERE subject_name = v_subject_name;
	
        
--         SET v_subject_id = CASE
-- 							 WHEN randbetween(1,2)=1 THEN 1 
--                              ELSE ELT(randbetween(1,10),3,4,5,6,7,8,9,10,11,12)
-- 						   END;              -- subject_id = (1,3,4,5,6,7,8,9,10,11,12)

		-- SET v_course_id = s;
        
        SELECT pcs.course_id
        INTO v_course_id                   -- SET v_course_id
        FROM course pe
        JOIN course_sub pcs
        ON pcs.course_id = pe.course_id
        JOIN subject ps
        ON ps.subject_id = pcs.subject_id
        WHERE ps.subject_id = v_subject_id
        ORDER BY RAND()
        LIMIT 1;
		
        INSERT INTO batch(batch_name,start_date,end_date,total_students,timings,batch_day,instructor_id,course_id,subject_id)
        VALUES (
			v_batch_name_final_randbet_wd_wk       
            ,
			v_final_start_date 
            ,
			v_final_end_date 
			,
            v_total_students 
            ,
            v_timings 
            ,
            v_batch_day 
            ,
            v_instructor_id 
            ,
            v_course_id 
            ,
            v_subject_id 
            );
			
    
		SET x = x + 1;
        
	END WHILE;
			
			
COMMIT ;

SET result = CONCAT(no_of_rows," inserted successfully into batch table");
 
END //

DELIMITER ;


-- CALL p_batch(no_of_rows,@result);
CALL p_batch(2,@result);
SELECT @result;



							SELECT * FROM batch;




-- }}} END OF PROCEDURE p_batch



-- {{ ---------------------------------------------------------------- PROCEDURE p_populate_student_batch ---------------------------------------------

DROP PROCEDURE p_populate_student_batch;

DELIMITER //

CREATE PROCEDURE p_populate_student_batch(
IN no_of_rows INT,
OUT result VARCHAR(200)
)

BEGIN 

	DECLARE x INT DEFAULT 1;
    DECLARE v_student_id INT;
    DECLARE v_enrolled_date DATE;
    DECLARE v_enrolled_course_id INT;
    DECLARE v_batch_id_1 INT;
    DECLARE v_batch_id_2 INT;
    DECLARE v_batch_id_1_no_of_stu INT;
    DECLARE v_batch_id_2_no_of_stu INT;
    
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			ROLLBACK;
            RESIGNAL;
		END ;
        
        
START TRANSACTION ;
	WHILE x <= no_of_rows DO 
		
		SELECT stu.student_id,enr.enrolled_date,enr.enrolled_course_id
		INTO v_student_id,v_enrolled_date,v_enrolled_course_id
		FROM student stu
		JOIN enrollments enr 
		ON enr.enrollment_id = stu.enrollment_id
        ORDER BY RAND()
        LIMIT 1;
        
        -- SET @v_enrolled_date = YEAR(curdate() -1);
        -- SET @v_enrolled_course_id = 5;
        
        
        SELECT batch_id 
        INTO v_batch_id_1
        FROM batch 
        WHERE start_date >= v_enrolled_date  AND course_id = v_enrolled_course_id
        ORDER BY batch_id
        LIMIT 1;
        
        SELECT batch_id 
        INTO v_batch_id_2
        FROM batch 
        WHERE start_date >= v_enrolled_date  AND course_id = v_enrolled_course_id
        ORDER BY batch_id
        LIMIT 1 OFFSET 1;
	
		
        
        INSERT INTO student_batch(student_id,batch_id)
        VALUES(
			v_student_id
            ,
            v_batch_id_1
            );
        
        INSERT INTO student_batch(student_id,batch_id)
        VALUES(
			v_student_id
            ,
            v_batch_id_2
            );
            
            
		SET x = x + 1;
    END WHILE ;


COMMIT ;

SET result = CONCAT(no_of_rows," inserted successfully into student_batch table");


SELECT COUNT(*)
INTO v_batch_id_1_no_of_stu
FROM student_batch
WHERE batch_id = v_batch_id_1
GROUP BY batch_id;

SELECT COUNT(*)
INTO v_batch_id_2_no_of_stu
FROM student_batch
WHERE batch_id = v_batch_id_2
GROUP BY batch_id;

UPDATE batch
SET total_students = v_batch_id_1_no_of_stu
WHERE batch_id = v_batch_id_1;

UPDATE batch
SET total_students = v_batch_id_2_no_of_stu
WHERE batch_id = v_batch_id_2;

COMMIT;

SELECT "No of Students in batch updated successfully";

END //
DELIMITER ;


CALL p_populate_student_batch(no_of_rows,@result);
CALL p_populate_student_batch(20,@result);
SELECT @result;

							SELECT * FROM student_batch;
                            SELECT * FROM batch;
                            
 SELECT student_id,batch_id,COUNT(*)                   
FROM student_batch
GROUP BY student_id,batch_id;
    
-- }} END OF PROCEDURE p_populate_student_batch



-- {{ ---------------------------------------------------------------- PROCEDURE p_populate_besant_database_v05 ---------------------------------------------

DROP PROCEDURE p_populate_besant_database_v05;

DELIMITER //

CREATE PROCEDURE p_populate_besant_database_v05(
IN no_of_rows INT,
OUT result VARCHAR(500)
)

BEGIN 
	DECLARE v_enquiry_result VARCHAR(150);
    DECLARE v_enrollment_result VARCHAR(150);
    DECLARE v_student_result VARCHAR(150);
    DECLARE v_payments_result VARCHAR(150);
    DECLARE v_batch_result VARCHAR(150);
    -- DECLARE v_final_result VARCHAR(150);
    
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
				ROLLBACK;
                RESIGNAL;
		END;
	
    IF no_of_rows <= 0 
		THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = "no_of_rows to insert should be greater than 0 ";
	ELSEIF no_of_rows IS NULL 
		THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = "no_of_rows to insert can't be NULL ";
    END IF ;

START TRANSACTION;

    CALL p_student_enquiry(ROUND(no_of_rows * 1.30), v_enquiry_result);  -- 30% more rows than entered rows     SELECT ROUND(6 * 1.30)

    CALL p_enrollments(no_of_rows, v_enrollment_result);    -- same rows no change
    
    CALL p_student(no_of_rows, v_student_result);    		-- same rows no change

    CALL p_payments(ROUND(no_of_rows * 1.30), v_payments_result);    		-- 30% extra rows than entered rows

    CALL p_batch(GREATEST( 1, ROUND(no_of_rows * 0.01) ),v_batch_result);   		-- will add only 1% of entered rows if entered rows is > 
	-- SELECT GREATEST(1,ROUND(200*0.01))  												  	-- IF no_of_rows(1-100) then 1 row inserted into batch
																							-- IF no_of_rows(101-200) then 2 rows inserted into batch                                                                                          
                                                                                          
    
    
	SET result = CONCAT(
		'Student Enquiry: ', v_enquiry_result,
		' | Enrollment: ', v_enrollment_result,
		' | Student: ', v_student_result,
		' | Payments: ', v_payments_result,
		' | Batch: ', v_batch_result
	);


COMMIT;
END //

DELIMITER ;





-- CALL p_populate_besant_database_v05(no_of_rows,@result);          
CALL p_populate_besant_database_v05(no_of_rows,@result);  				-- p_student_enquiry will add 30% more rows 
CALL p_populate_besant_database_v05(200,@result); 
SELECT @result; 								  					-- p_enrollments will add same rows 
																	-- p_student will add same rows
																	-- p_payments will add 30% more rows 
-- **Note** : Maximum 1000 rows can be inserted in one go           -- p_batch will add 1% of total entered rows 
 
 
WITH cte AS ( 
SELECT student_name,COUNT(*) AS no_of_dupli							
FROM student_enquiry
GROUP BY student_name
HAVING COUNT(*) > 1 )
SELECT SUM(no_of_dupli)
FROM cte ;
                                        
							SELECT * FROM student_enquiry;
							SELECT * FROM enrollments;
                            SELECT * FROM student;
                            SELECT * FROM payments;
                            SELECT * FROM batch;
          
-- Note : Run the below commands with precaution ,this will delete all the data from 5 Fact Tables     
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE student_enquiry;
TRUNCATE TABLE enrollments;
TRUNCATE TABLE student;
TRUNCATE TABLE payments;
TRUNCATE TABLE batch;
SET FOREIGN_KEY_CHECKS = 1;     
          
          


-- }} END OF PROCEDURE p_populate_besant_database_v05

-- ===================================================- END OF PROCEDURES -===============================================












