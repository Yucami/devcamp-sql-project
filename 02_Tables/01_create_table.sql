CREATE TABLE professors (
	professors_id int NOT NULL AUTO_INCREMENT,
    professors_name varchar(100) NOT NULL,
    professors_email varchar(80) NOT NULL,
    PRIMARY KEY(professors_id),
    UNIQUE(professors_email)
);

CREATE TABLE courses (
	courses_id int NOT NULL AUTO_INCREMENT,
    courses_name varchar(100) NOT NULL,
    courses_professors_id INT NOT NULL,
    PRIMARY KEY(courses_id),
    FOREIGN KEY (courses_professors_id) REFERENCES professors(professors_id)
);

CREATE TABLE students (
	students_id int NOT NULL AUTO_INCREMENT,
    students_name varchar(100) NOT NULL,
    students_email varchar(80) NOT NULL,
    PRIMARY KEY(students_id),
    UNIQUE(students_email)
);

CREATE TABLE grades (
	grades_id int NOT NULL AUTO_INCREMENT,
    grades_courses_id int NOT NULL,
    grades_students_id int NOT NULL,
    grades_professors_id int NOT NULL,
    grade decimal(10,0) NOT NULL,
    PRIMARY KEY(grades_id),
    FOREIGN KEY(grades_courses_id) REFERENCES courses(courses_id),
    FOREIGN KEY(grades_students_id) REFERENCES students(students_id)
);