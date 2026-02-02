-- {{ Course and their Subjects 

SELECT c.course_name AS 'Course Name',s.subject_name AS `Subject Name`
FROM course c
JOIN course_sub cs
ON cs.course_id = c.course_id
JOIN subject s
ON s.subject_id = cs.subject_id;

-- }}


- {{ To Check Batch Active or Not

SELECT *,if(curdate() > end_date,"Batch Completed","Running") AS Batch_Status FROM batch;
SELECT *,if( end_date < curdate() ,"Batch Completed","Running") AS Batch_Status FROM batch;
-- }} 



-- {{ Fee Paid and Balance Fee to Pay by Student Name 

SELECT s.student_name AS "Student Name",SUM(p.amount_paid) AS "Fee_Paid",( MAX(fees_to_pay) - SUM(p.amount_paid) ) AS "Balance Fee"
FROM course c
JOIN payments p
ON c.course_id = p.course_id
JOIN student s
ON s.student_id = p.student_id
JOIN enrollments enr
ON enr.enrollment_id = s.enrollment_id
GROUP BY s.student_name,s.student_id;

-- }} 



-- {{ Fee Paid on the day of Enrollment 


SELECT s.student_name,enr.enrolled_course_id,max(enr.fees_to_pay),sum(p.amount_paid) AS "Amount Paid on Enrolled Day"
FROM enrollments enr 
JOIN student s
ON s.enrollment_id = enr.enrollment_id
JOIN payments p 
ON p.student_id = s.student_id
WHERE enr.enrolled_date = p.date
GROUP BY s.student_id,s.student_name,enr.enrolled_course_id;



-- }} 






