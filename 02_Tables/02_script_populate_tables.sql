-- SCRIPT PARA RELLENAR CON DATOS ALEATORIOS "students":
DELIMITER $$

CREATE PROCEDURE InsertRandomStudents(IN total INT)
BEGIN
    DECLARE i INT DEFAULT 1;

    WHILE i <= total DO
        INSERT INTO students (students_name, students_email)
        VALUES (
            CONCAT('Student_', FLOOR(RAND() * 1000)),
            CONCAT('student', i, '@example.com')  -- con la i garantizamos que no se repitan
        );
        SET i = i + 1;
    END WHILE;
END$$

DELIMITER ;

-- Llamar al procedimiento para generar 100 registros
CALL InsertRandomStudents(100);


-- SCRIPT PARA RELLENAR CON DATOS ALEATORIOS "professors":

DELIMITER $$

CREATE PROCEDURE InsertRandomProfessors(IN total INT)
BEGIN
    DECLARE i INT DEFAULT 1;

    WHILE i <= total DO
        INSERT INTO professors (professors_name, professors_email)
        VALUES (
            CONCAT('Professor_', i),
            CONCAT('Professor', i, '@example.com')  -- con la i garantizamos que no se repitan
        );
        SET i = i + 1;
    END WHILE;
END$$

DELIMITER ;

-- Llamar al procedimiento para generar 15 registros
CALL InsertRandomProfessors(15);



-- SCRIPT PARA RELLENAR CON DATOS ALEATORIOS "courses":

DELIMITER $$

CREATE PROCEDURE InsertRandomCourses(IN total INT)
BEGIN
    -- Declaración de variables
    DECLARE i INT DEFAULT 1;
    DECLARE professor_id INT;
    DECLARE remaining_courses INT;
    DECLARE done INT DEFAULT 0;

    -- Declaración del cursor
    DECLARE cur_professors CURSOR FOR SELECT professors_id FROM professors;

    -- Declaración del manejador de errores
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Contar el número total de profesores y calcular los cursos restantes
    SET remaining_courses = total;

    -- Abrir el cursor para asignar al menos un curso a cada profesor
    OPEN cur_professors;

    read_loop: LOOP
        FETCH cur_professors INTO professor_id;

        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Insertar un curso para el profesor actual
        INSERT INTO courses (courses_name, courses_professors_id)
        VALUES (
            CONCAT('Course_', i),
            professor_id
        );

        SET i = i + 1;
        SET remaining_courses = remaining_courses - 1;

        -- Salir si ya se han insertado todos los cursos requeridos
        IF remaining_courses <= 0 THEN
            LEAVE read_loop;
        END IF;
    END LOOP;

    CLOSE cur_professors;

    -- Asignar cursos restantes a profesores aleatorios
    WHILE remaining_courses > 0 DO
        -- Seleccionar un professor_id aleatorio
        SET professor_id = (SELECT professors_id FROM professors ORDER BY RAND() LIMIT 1);

        -- Insertar un nuevo curso
        INSERT INTO courses (courses_name, courses_professors_id)
        VALUES (
            CONCAT('Course_', i),
            professor_id
        );

        SET i = i + 1;
        SET remaining_courses = remaining_courses - 1;
    END WHILE;
END$$

DELIMITER ;

-- Llamar al procedimiento para generar 40 registros
CALL InsertRandomCourses(40);




-- SCRIPT PARA RELLENAR CON DATOS ALEATORIOS "grades":


DELIMITER $$

CREATE PROCEDURE InsertRandomGradesWithLimits()
BEGIN
    DECLARE student_id INT;
    DECLARE course_id INT;
    DECLARE professor_id INT;
    DECLARE grade DECIMAL(5,2);
    DECLARE num_courses INT;
    DECLARE max_courses INT DEFAULT 10;
    DECLARE num_students INT;
    DECLARE j INT; -- Declaración de la variable contador
    DECLARE student_cursor CURSOR FOR SELECT students_id FROM students;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET num_students = 0;

    -- Contamos el número total de estudiantes
    SELECT COUNT(*) INTO num_students FROM students;

    -- Abrimos el cursor para recorrer los estudiantes
    OPEN student_cursor;

    -- Recorremos cada estudiante
    read_loop: LOOP
        FETCH student_cursor INTO student_id;

        IF num_students = 0 THEN
            LEAVE read_loop;
        END IF;

        -- Generar un número aleatorio de cursos entre 1 y 10 para este estudiante
        SET num_courses = FLOOR(RAND() * max_courses) + 1;

        -- Asignar los cursos de manera aleatoria
        SET j = 1; -- Inicializamos el contador para los cursos

        WHILE j <= num_courses DO
            -- Seleccionar un curso aleatorio
            SET course_id = (SELECT courses_id FROM courses ORDER BY RAND() LIMIT 1);
            -- Seleccionar el profesor correspondiente al curso
            SET professor_id = (SELECT courses_professors_id FROM courses WHERE courses_id = course_id LIMIT 1);

            -- Calificación aleatoria: 65% de los cursos entre 50 y 100, el resto entre 0 y 50
            IF RAND() <= 0.65 THEN
                SET grade = ROUND(RAND() * 50 + 50, 2);  -- Calificación entre 50 y 100
            ELSE
                SET grade = ROUND(RAND() * 50, 2);  -- Calificación entre 0 y 50
            END IF;

            -- Insertar el registro en grades
            INSERT INTO grades (grades_courses_id, grades_students_id, grades_professors_id, grade)
            VALUES (course_id, student_id, professor_id, grade);

            SET j = j + 1;  -- Incrementamos el contador
        END WHILE;

    END LOOP;

    CLOSE student_cursor;
END$$

DELIMITER ;

-- Llamar al procedimiento para generar las calificaciones aleatorias
CALL InsertRandomGradesWithLimits();

