-- Students table
CREATE TABLE students (
 student_id SERIAL PRIMARY KEY,
 first_name VARCHAR(50),
 last_name VARCHAR(50),
 contact_number VARCHAR(15)
);

-- Fees payments table
CREATE TABLE fees_payments (
 payment_id SERIAL PRIMARY KEY,
 student_id INT,
 payment_date DATE,
 amount DECIMAL(10, 2),
 FOREIGN KEY (student_id) REFERENCES students(student_id)
);

-- Enrollments table
CREATE TABLE enrollments (
 enrollment_id SERIAL PRIMARY KEY,
 student_id INT,
 course_id INT,
 enrollment_date DATE,
 FOREIGN KEY (student_id) REFERENCES students(student_id),
 FOREIGN KEY (course_id) REFERENCES courses(course_id)
);


-- Courses table
CREATE TABLE courses (
 course_id SERIAL PRIMARY KEY,
 course_title VARCHAR(100),
 credits INT
);

-- Lecturers table
CREATE TABLE lecturers (
 lecturer_id SERIAL PRIMARY KEY,
 lecture_name DATE,
 FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- Teaching assistant's table
CREATE TABLE teaching_assistants (
 ta_id SERIAL PRIMARY KEY,
 course_id INT,
 FOREIGN KEY (course_id) REFERENCES courses(course_id)
);



-- Insert sample data into the Students table
INSERT INTO Students (student_id, first_name,last_name)
VALUES
('001', 'Yasmeen', 'Doku'),
('002', 'Peggy','Somuah'),
('003', 'Afua','Ayisi'),
('004', 'Kim','Cred'),
('005', 'John',' Doe')


-- Insert sample data into the FeesPayments table
INSERT INTO fees_payments ( student_id, amount, payment_date)
VALUES
('001', 2000, '2022-09-01'),
('002', 1500, '2022-09-12'),
('003', 1500, '2022-09-23'),
('004', 1500, '2022-09-30'),
('005', 1500, '2022-09-09')


-- Insert sample data into the Courses table
INSERT INTO courses (course_title, credits)
VALUES
('Software Engineering', 3),
( 'Computer System Design', 3),
('Data Communications', 2),
('Linear Circuits', 3),
( 'Data Structures and Aglorithms', 3)


-- Insert sample data into the Enrollments table
INSERT INTO Enrollments ( student_id, course_id)
VALUES
('001', '005'),
('002', '004'),
('003', '003'),
('004', '002'),
('005', '001')


-- Insert sample data into the Lecturers table
INSERT INTO lecturers( lecturer_name )
VALUES
( 'Mr. John Asiamah'),
( 'Prof. Isaac Aboagye'),
( 'Ms Magaret Richardson'),
( 'Prof. Godfred Mills'),
( 'Prof. Percy Okai')

-- Insert sample data into the TAs table
INSERT INTO teaching_assistants (ta_id)
VALUES
('0001'),
('0002'),
('0003'),
('0004'),
('0005')

CREATE OR REPLACE FUNCTION calculate_outstanding_fees(student_id INT)
 RETURNS JSON
 LANGUAGE plpgsql
AS
$$
DECLARE
 total_fees DECIMAL(10, 2);
 total_payments DECIMAL(10, 2);
 outstanding_fees DECIMAL(10, 2);
 result JSON;
BEGIN
 SELECT SUM(amount) INTO total_payments FROM fees_payments WHERE student_id = 
student_id;
 SELECT SUM(enrollment_fee) INTO total_fees FROM courses WHERE course_id IN 
(SELECT course_id FROM enrollments WHERE student_id = student_id);
 outstanding_fees := total_fees - total_payments;
 result := json_build_object('student_id', student_id, 'outstanding_fees', 
outstanding_fees);
 RETURN result;
END;
$$;
