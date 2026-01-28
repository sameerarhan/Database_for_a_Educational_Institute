-- Creating Required Tables
-- First Create Tables then Remove the Repetetive Data/Columns      i.e., Normalization



CREATE TABLE `student_enquiry` (
  `enquiry_id` int NOT NULL AUTO_INCREMENT,
  `student_name` varchar(150) NOT NULL,
  `email_id` varchar(150) DEFAULT NULL,
  `phone` varchar(45) DEFAULT NULL,
  `enquiry_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('NEW','CONTACTED','REJECTED','ENROLLED') NOT NULL,
  `address` varchar(150) NOT NULL,
  `course` enum('Data Analytics','Data Science','Devops','Java FullStackDevelopment','Python  FullStackDevelopment') NOT NULL,
  `councellor_name` varchar(45) DEFAULT NULL,
  `Remarks` varchar(400) DEFAULT NULL,
  PRIMARY KEY (`enquiry_id`),
  UNIQUE KEY `phone_UNIQUE` (`phone`),
  UNIQUE KEY `email_id_UNIQUE` (`email_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3


CREATE TABLE `enrollments` (
  `enrollment_id` int NOT NULL AUTO_INCREMENT,
  `enquiry_id` int DEFAULT NULL,
  `course_enrolled` enum('Data Analytics','Data Science','Devops','Java FullStackDevelopment','Python  FullStackDevelopment') NOT NULL,
  `enrolled_date` date NOT NULL,
  `councellor_name` varchar(45) NOT NULL,
  `enrollment_status` enum('ENROLLED','ENROLLMENT_CONFIRMED','REJECTED') DEFAULT NULL,
  `student_name` varchar(150) NOT NULL,
  `email` varchar(45) DEFAULT NULL,
  `phone` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`enrollment_id`),
  UNIQUE KEY `email_UNIQUE` (`email`),
  UNIQUE KEY `phone_UNIQUE` (`phone`),
  KEY `enquiry_id_idx` (`enquiry_id`),
  CONSTRAINT `enquiry_id` FOREIGN KEY (`enquiry_id`) REFERENCES `student_enquiry` (`enquiry_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3


CREATE TABLE `student` (
  `student_id` int NOT NULL AUTO_INCREMENT,
  `enrollment_id` int NOT NULL,
  `student_name` varchar(45) NOT NULL,
  `date_of_joining` datetime NOT NULL,
  `fee_paid` decimal(8,2) DEFAULT NULL,
  PRIMARY KEY (`student_id`),
  KEY `enrollment_id_2` (`enrollment_id`),
  CONSTRAINT `enrollment_id_2` FOREIGN KEY (`enrollment_id`) REFERENCES `enrollments` (`enrollment_id`)
) ENGINE=InnoDB AUTO_INCREMENT=20252 DEFAULT CHARSET=utf8mb3


CREATE TABLE `course` (
  `course_id` int NOT NULL AUTO_INCREMENT,
  `course_name` varchar(150) NOT NULL,
  `course_fee` decimal(8,2) NOT NULL,
  `coordinator_id` int NOT NULL,
  PRIMARY KEY (`course_id`,`coordinator_id`),
  KEY `coordinator_id_idx` (`coordinator_id`),
  CONSTRAINT `coordinator_id` FOREIGN KEY (`coordinator_id`) REFERENCES `coordinator` (`Coordinator_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3


CREATE TABLE `subject` (
  `subject_id` int NOT NULL AUTO_INCREMENT,
  `subject_name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`subject_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3


CREATE TABLE `batch` (
  `batch_id` int NOT NULL AUTO_INCREMENT,
  `batch_name` varchar(45) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `total_students` int DEFAULT NULL,
  `timings` varchar(45) NOT NULL,
  `batch_day` enum('WEEKDAYS','WEEKENDS') DEFAULT NULL,
  `instructor_id` int NOT NULL,
  `course_id` int NOT NULL,
  `subject_id` int NOT NULL,
  PRIMARY KEY (`batch_id`,`course_id`,`subject_id`,`instructor_id`),
  KEY `instructor_id_idx` (`instructor_id`),
  KEY `course_id_idx` (`course_id`),
  KEY `subject_id_idx` (`subject_id`),
  CONSTRAINT `course_id2` FOREIGN KEY (`course_id`) REFERENCES `course_sub` (`course_id`),
  CONSTRAINT `instructor_id` FOREIGN KEY (`instructor_id`) REFERENCES `instructor` (`instructor_id`),
  CONSTRAINT `subject_id_2` FOREIGN KEY (`subject_id`) REFERENCES `course_sub` (`subject_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3


CREATE TABLE `instructor` (
  `instructor_id` int NOT NULL AUTO_INCREMENT,
  `instructor_Name` varchar(45) NOT NULL,
  `age` int DEFAULT NULL,
  PRIMARY KEY (`instructor_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3


CREATE TABLE `coordinator` (
  `Coordinator_id` int NOT NULL AUTO_INCREMENT,
  `Coordinator_name` varchar(45) DEFAULT NULL,
  `age` int DEFAULT NULL,
  PRIMARY KEY (`Coordinator_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3



CREATE TABLE `course_sub` (
  `course_id` int NOT NULL,
  `subject_id` int NOT NULL,
  PRIMARY KEY (`course_id`,`subject_id`),
  KEY `fk_Course_has_subject_subject1_idx` (`subject_id`),
  KEY `course_id_idx` (`course_id`),
  CONSTRAINT `course_id1` FOREIGN KEY (`course_id`) REFERENCES `course` (`course_id`),
  CONSTRAINT `subject_id_1` FOREIGN KEY (`subject_id`) REFERENCES `subject` (`subject_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3


CREATE TABLE `student_batch` (
  `student_id` int NOT NULL,
  `batch_id` int NOT NULL,
  PRIMARY KEY (`student_id`,`batch_id`),
  KEY `fk_student_details_has_batch_batch1_idx` (`batch_id`),
  KEY `fk_student_details_has_batch_student_details1_idx` (`student_id`),
  CONSTRAINT `batch_id1` FOREIGN KEY (`batch_id`) REFERENCES `batch` (`batch_id`),
  CONSTRAINT `fk_student_details_has_batch_student_details1` FOREIGN KEY (`student_id`) REFERENCES `student` (`student_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3



-----------

