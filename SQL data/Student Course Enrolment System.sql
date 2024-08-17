-- STUDENT COURSE ENROLMNT SYSTEM -- 

USE schooldb;


-- CREATE TABLES FOR STUDENTS,COURSES AND ENROLMENT -- 
-- STUDENTS TABLE
CREATE TABLE tbl_students(
studentID INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
first_name VARCHAR(60) NOT NULL,
last_name VARCHAR(60) NOT NULL,
date_of_birth DATE NOT NULL,
Email VARCHAR(60) NOT NULL
);

-- COURSES TABLE
CREATE TABLE tbl_courses(
courseID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
course_name VARCHAR(60) NOT NULL,
course_description VARCHAR(60) NOT NULL,
credits  INT NOT NULL
);

-- ENROLMENT TABLE WITH FOREIGN KEYS
CREATE TABLE tbl_enrolments(
enrolmentID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
studentID INT NOT NULL UNIQUE,
courseID INT NOT NULL,

CONSTRAINT studentID
FOREIGN KEY (studentID)
REFERENCES tbl_students(studentID)
ON DELETE CASCADE
ON UPDATE CASCADE,

CONSTRAINT courseID 
FOREIGN KEY (courseID)
REFERENCES tbl_courses(courseID)
ON DELETE CASCADE
ON UPDATE CASCADE,

enrolment_date DATE NOT NULL,
grade VARCHAR(2) NOT NULL
);


-- CREATE QUERIES TO LIST ALL STUDENTS, ALL COURSES, AND ALL ENROLMENTS.
SELECT * FROM  tbl_students;
SELECT * FROM  tbl_courses;
SELECT * FROM  tbl_enrolments;

-- UPDATE A STUDENT'S GRADE FOR A COURSE.
UPDATE tbl_enrolments SET grade='C' WHERE enrolmentID=10;
SELECT * FROM tbl_enrolments WHERE enrolmentID=10;

-- CREATE VIEWS TO SHOW STUDENTS' COURSES AND THEIR GRADES.
CREATE VIEW student_grades
AS
SELECT
   tbl_enrolments.enrolmentID,
   tbl_enrolments.studentID,
   tbl_students.first_name,
   tbl_students.last_name,
   tbl_enrolments.grade,
   tbl_courses.course_name,
   tbl_enrolments.courseID    
FROM
    tbl_enrolments
JOIN
    tbl_students ON tbl_enrolments.studentID = tbl_students.studentID
JOIN 

    tbl_courses ON tbl_enrolments.courseID = tbl_courses.courseID
ORDER BY
    tbl_enrolments.enrolmentID;
    
    SELECT*FROM student_grades;


-- USE STORED PROCEDURES TO ENROL A STUDENT IN A COURSE AND HANDLE ALL RELATED UPDATES.

DELIMITER $$

CREATE PROCEDURE enrol_new_student(
    IN new_first_name VARCHAR(50),
    IN new_last_name VARCHAR(50),
    IN new_date_of_birth DATE,
    IN new_email VARCHAR(60),
    IN selected_courseID INT,
    IN new_enrolment_date DATE,
    IN student_grade VARCHAR(2)
)
BEGIN
	DECLARE new_studentID INT;
    INSERT INTO tbl_students (first_name, last_name, date_of_birth, Email)
    VALUES (new_first_name, new_last_name,new_date_of_birth, new_email);
    
        SET new_studentID = LAST_INSERT_ID();
    
    INSERT INTO tbl_enrolments (studentID, courseID, enrolment_date,grade)
    VALUES (new_studentID, selected_courseID, new_enrolment_date, student_grade);
END $$

DELIMITER ;

CALL enrol_new_student ('Brian', 'Barlow','1999-08-09','brian83@hotmail.com','2','2023-10-01','D');


-- IMPLEMENT THE CASE STATEMENT TO CATEGORISE STUDENTS BASED ON THEIR GRADES

SELECT
    tbl_enrolments.enrolmentID,       
    tbl_enrolments.enrolment_date,
     tbl_enrolments.studentID,
    CONCAT(tbl_students.first_name, ' ',  tbl_students.last_name) AS 'Fullname',
    tbl_enrolments.courseID,
    tbl_courses.course_name,
    tbl_enrolments.grade,
    CASE
        WHEN tbl_enrolments.grade = 'A' THEN 'Accepted'
        WHEN tbl_enrolments.grade = 'B' THEN 'Accepted'
        WHEN tbl_enrolments.grade = 'C'  THEN 'Conditional'
        WHEN tbl_enrolments.grade = 'D'  THEN 'Deffered'        
        ELSE 'No grade'
    END AS type_of_offer
FROM
    tbl_enrolments
JOIN
    tbl_students ON tbl_enrolments.studentID = tbl_students.studentID
JOIN 
    tbl_courses ON tbl_enrolments.courseID = tbl_courses.courseID
ORDER BY
    tbl_enrolments.enrolmentID;
    
    DESC tbl_enrolments;

    

