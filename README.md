# Training Institute Database Project
## Project Overview

This project designs and implements a relational database for a training institute (e.g., Besant Technologies) to manage and analyze the complete student lifecycle:

Enquiry > Enrollment > Student > Course > Batch > Payment

The database is built considering real-world operational and analytical requirements of an educational institute.

## EER Database Diagram
<img width="1556" height="711" alt="Besant_Enrolment_v05_up" src="https://github.com/user-attachments/assets/86d28026-ce48-4ae4-89ce-8ace9bafc73c" />


## Business Problem

Training institutes receive a large number of student enquiries through their website and offline channels.
However:

Not all enquiries convert into enrollments

Not all enrolled students complete their payments

The institute wants to answer key business questions such as:

How many enquiries convert into enrollments?

Which courses attract the most students?

Which batches perform best?

How much revenue is generated per course?

Which instructors handle the most students?

This database model is designed to capture and analyze these aspects efficiently.

# Database Design

The database consists of multiple related tables representing:

student_enquiry – captures initial student interest

enrollments – stores enrolled students and enrollment details

student – maintains student profile information

course & course_sub – course and subject structure

batch – batch scheduling and capacity management

instructor – instructor details

student_batch – mapping between students and batches

payments – stores fee payment transactions



## Objectives

Design a normalized database schema for an educational institute

Track students from enquiry to enrollment

Manage courses, subjects, batches, and instructors

Enable revenue and performance analysis

Prepare data for BI tools and dashboards

## Features

Normalized relational schema

Proper primary key and foreign key relationships

Models real training institute workflows

Stored Procedures to insert data with ACID properties and Transactional Control to maintain data consistency

Triggers

Analytical queries

Dashboards

## Tools & Technologies

Database: MySQL

Design Tool: MySQL Workbench (EER Diagram)

Version Control: Git & GitHub

## Future Enhancements


Triggers for audit logging and automatic fee updates

Analytical views

Data ready for report generation

Live Dashboards for KPIs and performance tracking using Power BI
