# Training Institute Database Project

## EER Database Diagram
<img width="1456" height="536" alt="Medical_Store_DB_v011" src="https://github.com/user-attachments/assets/e90ed7b8-b83d-4456-8b49-0c453c4db616" />

## Database Design

The database consists of multiple related tables representing:

student_enquiry – captures initial student interest

enrollments – stores enrolled students

student – maintains student profile

course & course_sub – course and subject structure

batch – batch scheduling and capacity

instructor – instructor details

student_batch – student-to-batch mapping

## Features
- Normalized schema
- Foreign key relationships
- Ready for analytics and dashboards

## Project Overview

This project designs and implements a relational database for a training institute (e.g., Besant Technologies) to manage and analyze the complete student lifecycle:

Enquiry → Enrollment → Batch → Course → Payment

The database is built considering real-world scenarios such as:

Multiple courses and subjects

Batch allocations

Instructor assignments

Student tracking

Revenue and performance analysis

The goal is to support both:

Operational needs (storing student data)

Analytical needs (dashboard and business insights)

## Business Problem

Training institutes receive a large number of student enquiries through their website and offline channels.
However, not all enquiries convert into enrollments, and not all enrolled students complete payment.

The institute wants to answer questions such as:

How many enquiries convert into enrollments?

Which courses attract the most students?

Which batches perform best?

How much revenue is generated per course?

Which instructors handle the most students?

This database model is designed to capture and analyze these aspects efficiently.

## Objectives

Design a normalized database schema for an educational institute

Track students from enquiry to enrollment

Manage courses, subjects, batches, and instructors

Enable revenue and performance analysis

Prepare data for BI tools and dashboards

## Tools & Technologies

Database Tool: MySQL

Design Tool: MySQL Workbench (EER Diagram)

Version Control: Git & GitHub

## Key Features

Proper primary key and foreign key relationships

Normalized schema

Designed using real training institute workflows

Ready for:

Stored procedures

Triggers

Analytical queries

Dashboards (Power BI / Excel / Tableau)
