SELECT 
    g.grades_students_id AS student_id,
    MAX(g.grade) AS best_grade
FROM 
    grades g
GROUP BY 
    g.grades_students_id;
