-- =======================================================- ANALYSIS -=======================================================

SELECT *
FROM course pe
JOIN course_sub pcs
ON pcs.course_id = pe.course_id
JOIN subject ps
ON ps.subject_id = pcs.subject_id;



-- {{ - analysis student_enquiry -

-- No of Records/Enquiries
SELECT CONCAT(COUNT(*)," rows") AS "No of Records"
FROM student_enquiry;

-- No of Students in each course
SELECT course,COUNT(*) AS "No of Students"
FROM student_enquiry
GROUP BY course;

-- No of Students from each Location
SELECT address,COUNT(*) AS "No of Students"
FROM student_enquiry
GROUP BY address;

-- Students with Missing Email or Phone
SELECT *
FROM student_enquiry
WHERE email_id IS NULL
   OR email_id = ''
   OR phone IS NULL
   OR phone = '';

-- Type of Remarks
SELECT remarks,COUNT(*) AS "No of Students"
FROM student_enquiry
GROUP BY remarks;

-- No of Students Interested in Enrollment
SELECT COUNT(*)
FROM student_enquiry
WHERE status IN ('INTERESTED','LIKELY_TO_CONVERT','CONVERTED','DEMO_SCHEDULED');

-- No of Students Enquired
SELECT COUNT(*)
FROM student_enquiry;

-- }} end of analysis student_enquiry



-- {{ - analysis enrollments -

DELETE FROM student_enquiry
WHERE enquiry_id IN
(
    SELECT enquiry_id
    FROM enrollments
);

SELECT *
FROM enrollments
WHERE enquiry_id IS NULL;

SELECT pse.enquiry_id
FROM student_enquiry pse
WHERE NOT EXISTS
(
    SELECT 1
    FROM enrollments pe
    WHERE pe.enquiry_id = pse.enquiry_id
);

-- Fee Paid on the Day of Enrollment
SELECT
    s.student_name,
    enr.enrolled_course_id,
    MAX(enr.fees_to_pay),
    SUM(p.amount_paid) AS "Amount Paid on Enrolled Day"
FROM enrollments enr
JOIN student s
ON s.enrollment_id = enr.enrollment_id
JOIN payments p
ON p.student_id = s.student_id
WHERE enr.enrolled_date = p.date
GROUP BY
    s.student_id,
    s.student_name,
    enr.enrolled_course_id;

-- }} end of analysis enrollments



-- {{ - analysis student -

-- Fee Paid and Balance Fee by Student
SELECT
    s.student_name AS "Student Name",
    SUM(p.amount_paid) AS "Fee Paid",
    (MAX(enr.fees_to_pay) - SUM(p.amount_paid)) AS "Balance Fee"
FROM student s
JOIN enrollments enr
ON enr.enrollment_id = s.enrollment_id
JOIN payments p
ON p.student_id = s.student_id
GROUP BY
    s.student_id,
    s.student_name;

-- }} end of analysis student



-- {{ - analysis payments -

-- Fee Paid and Balance Fee
SELECT *,
       (Total_Fees_To_Pay - Fee_Paid) AS Balance_Fee
FROM
(
    SELECT
        pstu.student_id,
        SUM(ppy.amount_paid) AS Fee_Paid,
        MAX(penr.Fees_to_Pay) AS Total_Fees_To_Pay
    FROM payments ppy
    JOIN student pstu
    ON pstu.student_id = ppy.student_id
    JOIN enrollments penr
    ON penr.enrollment_id = pstu.enrollment_id
    GROUP BY pstu.student_id
) AS t2;

SELECT *
FROM enrollments;

-- Fee Paid by Each Student
SELECT
    student_id,
    SUM(amount_paid) AS "Fee Paid"
FROM payments
GROUP BY student_id;

-- Fees to Pay by Each Student
SELECT
    pstu.student_id,
    pstu.student_name,
    SUM(Fees_to_Pay) AS "Fees to Pay"
FROM enrollments penr
JOIN student pstu
ON pstu.enrollment_id = penr.enrollment_id
GROUP BY
    pstu.student_id,
    pstu.student_name;

-- Total Revenue in Year 2023
SELECT SUM(amount_paid)
FROM payments
WHERE YEAR(date) = 2023;

-- Total Revenue
SELECT SUM(amount_paid) AS "Total Revenue"
FROM payments;

-- Revenue Per Course
SELECT
    pcou.course_name,
    SUM(ppyt.amount_paid) AS "Total Revenue"
FROM payments ppyt
JOIN course pcou
ON ppyt.course_id = pcou.course_id
GROUP BY
    pcou.course_id,
    pcou.course_name;

-- }} end of analysis payments



-- {{ - analysis batch -

-- Batch Status
SELECT *,
       IF(CURDATE() > end_date,
          'Batch Completed',
          'Running') AS Batch_Status
FROM batch;

-- Total Batches in a Year
SET @year = 2023;

SELECT *
FROM batch
WHERE YEAR(start_date) = @year;

-- Number of Batches for Each Subject
SELECT
    psub.subject_name,
    COUNT(*) AS "No of Batches"
FROM batch pbat
JOIN subject psub
ON psub.subject_id = pbat.subject_id
GROUP BY
    pbat.subject_id,
    psub.subject_name;

-- }} end of analysis batch



-- {{ - analysis course -

-- Course and Subjects
SELECT
    c.course_name AS "Course Name",
    s.subject_name AS "Subject Name"
FROM course c
JOIN course_sub cs
ON cs.course_id = c.course_id
JOIN subject s
ON s.subject_id = cs.subject_id;

-- Course and Subjects (Specific Course)
SET @course_id = 1;

SELECT
    pcou.course_name,
    psub.subject_name
FROM course pcou
JOIN course_sub pcs
ON pcs.course_id = pcou.course_id
JOIN subject psub
ON psub.subject_id = pcs.subject_id
WHERE pcou.course_id = @course_id;

-- Coordinator for Each Course
SELECT *
FROM course pcou
JOIN coordinator pcoor
ON pcoor.coordinator_id = pcou.coordinator_id;

-- }} end of analysis course
