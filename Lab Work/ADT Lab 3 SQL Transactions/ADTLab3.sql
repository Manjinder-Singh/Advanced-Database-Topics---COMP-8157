-- Answer 1
-- Creating database with name 'ManjinderADTLab3' and then using database "ManjinderADTLab3".
Create database ManjinderADTLab3;
use ManjinderADTLab3;

-- Answer 2
-- Creation of "ManjinderStudents" table.
CREATE TABLE ManjinderStudents (
  StudentID INT PRIMARY KEY,
  FullName VARCHAR(100),
  Email VARCHAR(100),
  TotalCredits INT
);

-- Creation of "ManjinderCourses" table.
CREATE TABLE ManjinderCourses (
  CourseID INT PRIMARY KEY,
  CourseName VARCHAR(100),
  Instructor VARCHAR(100),
  CourseCredits INT,
  AvailableSeats INT
);

-- Creation of "ManjinderStudentRegistration" table.
CREATE TABLE ManjinderStudentRegistration (
  RegistrationID INT PRIMARY KEY Identity(1,1),
  StudentID INT,
  CourseID INT,
  FOREIGN KEY (StudentID) REFERENCES ManjinderStudents(StudentID),
  FOREIGN KEY (CourseID) REFERENCES ManjinderCourses(CourseID)
);

-- Inserting sample data into ManjinderStudents table
INSERT INTO ManjinderStudents(StudentID, FullName, Email, TotalCredits)
VALUES
(1, 'John Doe', 'john.doe@example.com', 0),
 (2, 'Jane Smith', 'jane.smith@example.com', 0),
 (3, 'Michael Johnson', 'michael.johnson@example.com', 0);

-- Inserting sample data into ManjinderCourses table
INSERT INTO ManjinderCourses (CourseID, CourseName, Instructor, CourseCredits, AvailableSeats)
VALUES
 (1, 'Mathematics', 'Professor Anderson', 3, 1),
 (2, 'English Literature', 'Professor Thompson', 4, 20),
 (3, 'Computer Science', 'Professor Roberts', 5, 10);
 

 -- Displaying data in Tables after creation and insertion operation.
  select * from ManjinderStudents;
  select * from ManjinderCourses;
  select * from ManjinderStudentRegistration;


  
  -- ANSWER 3: Creation of Stored Procedure
  CREATE PROCEDURE Manjinder_spInsertStudentRegistration
    @StudentID INT,
    @CourseID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- It will show the beginning of transaction.
    BEGIN TRANSACTION;
    -- It will check if the seats are available in the course.
    DECLARE @AvailableSeats INT;
    SELECT @AvailableSeats = AvailableSeats
    FROM ManjinderCourses
    WHERE CourseID = @CourseID;

    -- If seats are not avaialble then rollback transaction will be executed and then the appropriate return error message will be displayed.
    IF @AvailableSeats <= 0
    BEGIN
        ROLLBACK TRANSACTION;
        PRINT 'Course is full. Registration failed.';
        RETURN
    END;

    -- Decrease the availability of seats in the Courses table
    UPDATE ManjinderCourses
    SET AvailableSeats = AvailableSeats - 1
    WHERE CourseID = @CourseID;

    -- Add course credits to the student's total credits in the Students table
    UPDATE ManjinderStudents
    SET TotalCredits = TotalCredits + (
        SELECT CourseCredits
        FROM ManjinderCourses
        WHERE CourseID = @CourseID
    )
    WHERE StudentID = @StudentID;

    -- Insert the record into the StudentRegistration table
    INSERT INTO ManjinderStudentRegistration (StudentID, CourseID)
    VALUES (@StudentID, @CourseID);

    -- Commit the transaction
    COMMIT TRANSACTION;

    PRINT 'Registration successful.';
END;


-- Answer 4
-- Register Jane Smith for Mathematics.
EXEC Manjinder_spInsertStudentRegistration @StudentID = 2, @CourseID = 1;

-- Register Michael Johnson for Computer Science.
EXEC Manjinder_spInsertStudentRegistration @StudentID = 3, @CourseID = 3;

-- Register John Doe for Mathematics.
EXEC Manjinder_spInsertStudentRegistration @StudentID = 1, @CourseID = 1;


  select * from ManjinderStudents;
  select * from ManjinderCourses;
  select * from ManjinderStudentRegistration;
