-- INSERT INTO TABLES 


desc course;
INSERT INTO course(

course_name,
course_fee,
coordinator_id
)
VALUES
(

"Data Science",
50000,
1

);
SELECT * FROM course;




desc subject;
INSERT INTO subject(
subject_name
)
VALUES
(
"Microsoft Excel"
);
SELECT * FROM subject;




desc course_sub;
INSERT INTO course_sub(
course_id,
subject_id)
VALUES (
1,
1
);
SELECT * FROM course_sub;




desc coordinator;
INSERT INTO coordinator(

coordinator_name,
age
)
VALUES
( 
  "Vikram",
  28
);
SELECT * FROM coordinator;




desc batch;
INSERT INTO batch(

batch_name,
start_date,
end_date,
total_students,
timings,
batch_day,
instructor_id,
course_id,
subject_id
)
VALUES
(

"Python_WKDY_DEC25",
curdate(),
date_add(curdate(),INTERVAL 30 DAY),
56,
"12:00PM - 1:00PM",
"WEEKDAYS",
4,
1,
1
);
SELECT * FROM batch;




desc instructor;
INSERT INTO instructor(

instructor_Name,
age
)
VALUES
(
"Anikit",
26
);
SELECT * FROM instructor;




DESC student_enquiry;
INSERT INTO student_enquiry
(
  
  student_name,
  email_id,
  phone,
  enquiry_date,
  status,
  address,
  course,
  councellor_name,
  remarks
)
VALUES
( 
  'Aiza',
  'aizakhan5@gmail.com',
   9898923378,
   "2026-01-12",
  'NEW',
  'Bangalore',
  'Data Science',
  'Vikram',
  'Has Some Exams this month '
);
SELECT * FROM student_enquiry;




DESC enrollments;
INSERT INTO enrollments(

enquiry_id,
enrolled_course_id,
enrolled_date,
councellor_name,
enrollment_status,
ongoing_fee,
Discount,
fees_to_pay,
payment_plan,
source,
remarks
)
VALUES (

10,
1,
 curdate(),
"Vikram",
"Enrolled",
50000,
null,
50000,
"EMI",
"Google",
null
);
select * from enrollments;




desc student;
INSERT INTO student
(

  enrollment_id,
  student_name,
  phone,
  email_id,
  address,
  age,
  qualification,
  experience_level
)
VALUES
(
  
  1,
  'Aliza',
  982839928,
  'aliza32@gmail.com',
  'Banglore',
  21,
  "B.Tech in CSE",
  "Fresher"
);
select * from student ;




DESC payments;
SELECT * FROM payments;

INSERT INTO payments(student_id,course_id,date,amount_paid,mode_of_payment)
			VALUES (1,1,curdate() + INTERVAL 2 DAY ,5000,"Cash");





desc student_batch;
INSERT INTO student_batch(
student_id,
batch_id
)
VALUES (
1,
1
);
SELECT * FROM student_batch;


-- 

