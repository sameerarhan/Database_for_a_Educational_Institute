-- {{ REQUIRED STORED PROCEDURES

-- {{ Procedure sp_AddCourse(Course_name,Course_fee)
 DROP PROCEDURE sp_addcourse;
DELIMITER $$

CREATE PROCEDURE sp_addcourse(
-- IN instructor_id VARCHAR(150),
IN `Course Name` VARCHAR(100),
IN `Course Fee` DECIMAL(8,2),
IN `Coordinator ID` INT
)

proc_main:
BEGIN 

DECLARE d_course_id_exists INT ;

START TRANSACTION ;

SELECT COUNT(*) 
INTO d_course_id_exists
FROM course
WHERE course_name = `Course Name` ;

IF d_course_id_exists <> 0 
 THEN 
 SELECT "Course already Exists";
 ROLLBACK;
 LEAVE proc_main;
END IF;
 
 
 INSERT INTO course(
 
 course_name,
 course_fee,
 coordinator_id
 )
 VALUES
 (
  `Course Name`,
  `Course Fee`,
  `Coordinator ID`
 );

COMMIT ;
SELECT CONCAT("Course ",`Course Name`," added Succesfully" );
END $$
DELIMITER ;
SELECT * FROM course;
-- }}




-- {{ Procedure sp_addcoordinator(coordinator_name,age

DELIMITER $$

-- Creation Block
CREATE PROCEDURE sp_addcoordinator(
IN `Co ordinator Name` VARCHAR(45),
IN `Age` INT,
IN `Gender` ENUM("Male","Female"),
OUT `Result Message` VARCHAR(150)
)

-- Exceutable Block
proc_main:
BEGIN 
-- Declaration Block(Temp Variables)
DECLARE d_coordinator_exists INT DEFAULT 0;

-- Declaration Block(EXIT HANDLER)
DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN 
		ROLLBACK;
        RESIGNAL;
	END ;

-- Trasactional Block (Main Code Block) (executable SQL statements)
START TRANSACTION ;

-- Data Loading Block
SELECT COUNT(*)
INTO d_coordinator_exists
FROM coordinator
WHERE Coordinator_name = `Co ordinator Name`;

-- Exception Handling Block 
IF d_coordinator_exists <> 0 
	THEN 
	SET `Result Message` = "Co ordinator already Exists";
	SIGNAL SQLSTATE "45000"
	SET MESSAGE_TEXT = `Result Message`;
	LEAVE proc_main;
ELSE 
-- DML Statements Block
	INSERT INTO coordinator (coordinator_name,age,Gender)
				VALUES (`Co ordinator Name`,`Age`,`Gender`);
END IF ;

COMMIT;
SET `Result Message` = "Co ordinator "+ `Co ordinator Name` + " added Successfully";
SELECT `Result Message`;

END $$
DELIMITER ;
SELECT * FROM coordinator;



-- }}





-- {{ Procedure sp_addenrollment(enquiry_id,enrolled_course_id,councellor_name,enrollment_status,ongoing_fee,discount,fees_to_pay,payment_plan,source,remarks
desc enrollments;
DELIMITER $$

-- Creation Block
CREATE PROCEDURE sp_addenrollment(
IN `Enquiry ID` INT ,
IN `Enrolled Course ID` INT,
IN `Councellor Name` VARCHAR(45),
IN `Enrollment Status` ENUM("ENROLLED","PENDING","REJECTED"),
IN `ongoing Fee` DECIMAL(8,2),
IN `Discount` DECIMAL(8,2),
IN `Fees To Pay` DECIMAL(8,2),
IN `Payment Plan` ENUM("ONE_TIME","INSTALLMENTS","EMI"),
IN `Source` VARCHAR(45),
IN `Remarks` VARCHAR(100),
OUT `Result Message` VARCHAR(150)
)

-- Exceutable Block
proc_main:
BEGIN 
-- Declaration Block(Temp Variables)
DECLARE v_course_id_exists INT DEFAULT 0;

-- Declaration Block(EXIT HANDLER)
DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN 
		ROLLBACK;
        RESIGNAL;
	END ;

-- Trasactional Block (Main Code Block) (executable SQL statements)
START TRANSACTION ;

-- Data Loading Block
SELECT COUNT(*)
INTO v_course_id_exists
FROM course
WHERE course_id = `Enrolled Course ID`;

-- Exception Handling Block 
IF v_course_id_exists <> 1 
	THEN 
	SET `Result Message` = "Course ID Does not Exists";
	SIGNAL SQLSTATE "45000"
	SET MESSAGE_TEXT = `Result Message`;
	LEAVE proc_main;
END IF ;

-- DML Statements Block

INSERT INTO enrollments(enquiry_id,enrolled_course_id,councellor_name,enrollment_status,ongoing_fee,discount,fees_to_pay,payment_plan,source,remarks)
			VALUES(`Enquiry ID`,`Enrolled Course ID`,`Councellor Name`,`Enrollment Status`,`ongoing fee`,`Discount`,`Fees To Pay`,`Payment Plan`,`Source`,`Remarks`);


COMMIT;
SET `Result Message` = "Student enrolled Successfully";
SELECT `Result Message`;

END $$
DELIMITER ;
SELECT * FROM enrollments;



-- }}




-- {{ Procedure sp_addpayment(student_id,course_id,amount_paid,mode_of_payment

DELIMITER $$
CREATE PROCEDURE sp_addpayment(
IN `Student ID` INT,
IN `Course ID` INT ,
IN `Amount Paid` DECIMAL(8,2) ,
IN `Mode of Payment` VARCHAR(45),
OUT `Result Message` VARCHAR(100)
)

-- Exceutable Block
proc_main:
BEGIN 
-- Declaration Block(Temp Variables)
DECLARE v_student_id_exists INT DEFAULT 0;
DECLARE v_course_id_exists INT DEFAULT 0;
DECLARE v_amount_paid_before_plus_paying_now DECIMAL(8,2) DEFAULT 0;
DECLARE v_amount_paid_till_now DECIMAL(8,2) DEFAULT 0;
DECLARE v_fees_to_pay DECIMAL(8,2) DEFAULT 0;
DECLARE v_amount_paying_now DECIMAL(8,2) DEFAULT 0;


-- Declaration Block(EXIT HANDLER)
DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN 
		ROLLBACK;
        RESIGNAL;
	END ;

-- Trasactional Block (Main Code Block) (executable SQL statements)
START TRANSACTION ;

-- Data Loading Block
SELECT COUNT(*)
INTO v_student_id_exists
FROM student
WHERE student_id = `Student ID` ;

SELECT COUNT(*)
INTO v_course_id_exists
FROM course
WHERE course_id = `Course ID`;

SELECT IFNULL(SUM(amount_paid),0)
INTO v_amount_paid_till_now
FROM payments
WHERE student_id = `Student ID` AND course_id = `Course ID`;

SELECT fees_to_pay
INTO v_fees_to_pay
FROM enrollments enr
JOIN student s
ON s.enrollment_id = enr.enrollment_id
WHERE s.student_id = `Student ID` AND enr.enrolled_course_id= `Course ID`;

SET v_amount_paying_now = `Amount Paid` ;
SET v_amount_paid_before_plus_paying_now = `Amount Paid` + v_amount_paid_till_now;

-- Exception Handling Block 
IF v_student_id_exists <= 0  OR v_course_id_exists <= 0
	THEN 
	SET `Result Message` = "Student ID or Course ID Does not Exist";
	SIGNAL SQLSTATE "45000"
	SET MESSAGE_TEXT = `Result Message`;
	LEAVE proc_main;
ELSEIF  v_amount_paid_before_plus_paying_now > v_fees_to_pay 
	THEN
    SET `Result Message` = "Amount is Exceeding than the student has to pay(fee)";
	SIGNAL SQLSTATE "45000"
	SET MESSAGE_TEXT = `Result Message`;
	LEAVE proc_main;    
ELSE 
-- DML Statements Block
	INSERT INTO payments (student_id,course_id,amount_paid,mode_of_payment)
				VALUES (`Student ID`,`Course ID`,`Amount Paid`,`Mode of Payment`);

END IF ;

COMMIT;
SET `Result Message` = "Payment recorded Successfully";
SELECT `Result Message`;

END $$
DELIMITER ;



-- }} 
SELECT * FROM payments;




-- {{ Procedure sp_addstudent(enrollment_id,student_name,phone,email,address,age,qualification,experience_level)

DELIMITER //

CREATE PROCEDURE sp_addstudent(
IN `Enrollment ID` INT,
IN `Student Name` VARCHAR(45),
IN `Phone` VARCHAR(45),
IN `Email ID` VARCHAR(45),
IN `Address` VARCHAR(100),
IN `Age` INT,
IN `Qualification` VARCHAR(45),
IN `Experience Level` ENUM("Fresher","Experienced"),
OUT `Result Message` VARCHAR(100)
)

proc_main:

BEGIN 
DECLARE v_student_exists INT;

DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN 
		ROLLBACK;
        RESIGNAL;
	END ;

START TRANSACTION ;

SELECT COUNT(*)
INTO v_student_exists
FROM student
WHERE student_name = `Student Name`;

IF v_student_exists <> 0 
	THEN 
	SET `Result Message` = "Student already Exists";
	SIGNAL SQLSTATE "45000"
	SET MESSAGE_TEXT = `Result Message`;
	LEAVE proc_main;
END IF ;

-- DML Statements Block
	INSERT INTO student (enrollment_id,student_name,phone,email_id,address,age,qualification,experience_level)
				VALUES  (`Enrollment ID`,`Student Name`,`Phone` ,`Email ID`,`Address` ,`Age` ,`Qualification` ,`Experience Level` );



COMMIT;
SET `Result Message` = "Student "+ `Student Name`+ " added Successfully";
SELECT `Result Message`;

END //
DELIMITER ;


-- }}


-- {{ sp_addstudentgpt
DELIMITER //

CREATE PROCEDURE sp_addstudentgpt(
    IN p_enrollment_id INT,
    IN p_student_name VARCHAR(45),
    IN p_phone VARCHAR(45),
    IN p_email VARCHAR(45),
    IN p_address VARCHAR(100),
    IN p_age INT,
    IN p_qualification VARCHAR(45),
    IN p_experience_level VARCHAR(20),
    OUT p_result_message VARCHAR(100)
)

proc_main: BEGIN

    DECLARE v_student_exists INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT COUNT(*)
    INTO v_student_exists
    FROM student
    WHERE student_name = p_student_name;

    IF v_student_exists <> 0 THEN
        SET p_result_message = 'Student already exists';
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = p_result_message;
        LEAVE proc_main;
    END IF;

    INSERT INTO student
        (enrollment_id, student_name, phone, email_id, address, age, qualification, experience_level)
    VALUES
        (p_enrollment_id, p_student_name, p_phone, p_email, p_address,
         p_age, p_qualification, p_experience_level);

    COMMIT;

    SET p_result_message = CONCAT('Student ', p_student_name, ' added successfully');
    SELECT p_result_message;

END //

DELIMITER ;



-- }}




DROP PROCEDURE getalltables;
-- {{ Procedure getalltables()
DELIMITER $$

CREATE PROCEDURE getalltables()
BEGIN 

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

END $$
DELIMITER ;
-- }} 
CALL getalltables();




-- {{ Procedure descalltables() 
DELIMITER $$

CREATE PROCEDURE descalltables()
BEGIN 

desc course;
desc subject;
desc course_sub;
desc coordinator;
desc batch;
desc instructor;
desc student_enquiry;
desc enrollments;
desc student;
desc payments;
desc student_batch;

END $$ 
DELIMITER ;
-- }} 
CALL descalltables;





DROP PROCEDURE sp_addinstructor;
-- {{ Procedure AddInstructor(instructorid,instructorname,age)
 
 DELIMITER $$

CREATE PROCEDURE sp_addinstructor(
-- IN instructor_id VARCHAR(150),
IN p_instructor_name VARCHAR(100),
IN p_age INT
)

proc_main:
BEGIN 

DECLARE d_instructor_exists INT ;

START TRANSACTION ;

SELECT COUNT(*) 
INTO d_instructor_exists
FROM instructor
WHERE instructor_name = p_instructor_name ;

IF p_age <= 0 OR p_age > 100 
 THEN 
 SELECT "Age must be between 1 and 100";
 ROLLBACK;
 LEAVE proc_main;
ELSEIF d_instructor_exists <> 0 
 THEN 
 SELECT "Instructor_name already exists";
 ROLLBACK ;
 LEAVE proc_main;

END IF ;
 
 INSERT INTO instructor(
 
 instructor_name,
 age
 )
 VALUES
 (
  p_instructor_name,
  p_age
 );

COMMIT ;
SELECT CONCAT("Instructor ",p_instructor_name," added Succesfully" );
END $$
DELIMITER ;
-- }}

CALL sp_addinstructor("Anikit",27);
SELECT * FROM instructor;




DROP PROCEDURE sp_insertincourse_sub;
-- {{ Procedure insertincourse_sub(course_id,subject_id,@result_message)
DELIMITER $$ 

CREATE PROCEDURE sp_insertincourse_sub(
IN p_course_id INT,
IN p_subject_id INT,
OUT result_message VARCHAR(300)
)


proc_main:

BEGIN 
	DECLARE v_courseid_exists INT DEFAULT 0;                    
	DECLARE v_subjectid_exists INT DEFAULT 0;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION 					
		BEGIN 
			ROLLBACK; 											
			RESIGNAL;				
		END;

	SELECT COUNT(*) 											
	INTO v_courseid_exists    
	FROM course
	WHERE course_id = p_course_id;

	IF v_courseid_exists = 0 
		THEN 
		SET result_message = "Course ID Does not Exist in the Course Master Table.";
		SIGNAL SQLSTATE "45000"
		SET MESSAGE_TEXT = result_message;
		LEAVE proc_main;
	END IF ;

	SELECT COUNT(*)
	INTO v_subjectid_exists
	FROM subject
	WHERE subject_id = p_subject_id;

	IF v_subjectid_exists = 0 
		THEN 
		SET result_message = "Subject ID Does not Exist in the Subject Master Table";
		SIGNAL SQLSTATE "45000"
		SET MESSAGE_TEXT = result_message;
		LEAVE proc_main;
	END IF ;
  
    INSERT INTO course_sub(course_id,subject_id)
				VALUES(p_course_id,p_subject_id);
	COMMIT;
	SET result_message = "Course ID , Subject ID Inserted into course_sub Successfully";
    SELECT result_message;
	
END $$ 
DELIMITER ;
-- }} 

   CALL sp_insertincourse_sub(1,1,@result_message);
SELECT * FROM course_sub;

-- {{ Procedure insertinstudent_batch(student_id,batch_id)
DELIMITER $$
CREATE PROCEDURE sp_insertinstudent_batch(
IN student_id_p VARCHAR(150),
IN batch_id_p VARCHAR(150),
OUT result_message VARCHAR(300)
)

proc_main:
BEGIN 
	DECLARE v_batchid_exists VARCHAR(150) DEFAULT 0 ;
	DECLARE v_studentid_exists VARCHAR(150) DEFAULT 0 ;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION 
	BEGIN 
		ROLLBACK;
		RESIGNAL;
	END;

	START TRANSACTION ;

	SELECT COUNT(*)
	INTO v_batchid_exists
	FROM batch
	WHERE batch_id = batch_id_p;

	IF v_batchid_exists = 0 
		THEN 
		SET result_message = "Batch ID Does not Exist!!";
		SIGNAL SQLSTATE "45000"
		SET MESSAGE_TEXT = result_message;
		LEAVE proc_main;
	END IF ;


	SELECT COUNT(*)
	INTO v_studentid_exists
	FROM student
	WHERE student_id = student_id_p;

	IF v_studentid_exists = 0 
		THEN 
		SET result_message = "Student ID Does not Exist!!";
		SIGNAL SQLSTATE "45000"
		SET MESSAGE_TEXT = result_message;
		LEAVE proc_main;
	END IF ;
		
	INSERT INTO student_batch(student_id,batch_id)
	VALUES(student_id_p,batch_id_p);
		  
	COMMIT;
    
	SET result_message = "Batch ID & Student ID Inserted into course_sub Successfully";
	SELECT result_message;

END $$

DELIMITER ;
-- }}

CALL insertinstudent_batch(1,2,@result_message);


DROP PROCEDURE sp_studentenquiry;
-- {{ Creating Procedure sp_studentenquiry  
DELIMITER $$
-- Header Block 
CREATE PROCEDURE sp_studentenquiry(
IN `Student name` VARCHAR(45),
IN `Email ID` VARCHAR(100),
IN `Phone` VARCHAR(45),
IN `Status` VARCHAR(45),
IN `Address` VARCHAR(100),
IN `course` VARCHAR(45),
IN `Councellor Name` VARCHAR(45),
IN `Remarks` VARCHAR(200),
OUT `Result Message` VARCHAR(200)
)

-- Initialization/Declaration Block
PROC_MAIN:
BEGIN 

DECLARE d_phone_exists INT;
DECLARE d_email_id_exists INT;

-- Declaring Exception Handler 
DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN 
		ROLLBACK;
        RESIGNAL;
	END;

START TRANSACTION;

-- Main Block or DML Block 
INSERT INTO student_enquiry(student_name,phone,email_id,address,course,status,councellor_name,remarks) 
VALUES (`Student name`,`Phone`,`Email ID`,`Address`,`course`,`Status`,`Councellor Name`,`Remarks`);

COMMIT ;

SET `Result Message`  = "Student Details Inserted Successfully";
SELECT `Result Message` ;

END $$ ;
DELIMITER  ;
-- }}
