-- MySQL Script generated by MySQL Workbench
-- Sun Sep 11 00:23:23 2022
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema universitydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema universitydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `universitydb` DEFAULT CHARACTER SET utf8 ;
USE `universitydb` ;

-- -----------------------------------------------------
-- Table `universitydb`.`students`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `universitydb`.`students` (
  `student_id` INT NOT NULL AUTO_INCREMENT,
  `student_name` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`student_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `universitydb`.`departments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `universitydb`.`departments` (
  `department_id` INT NOT NULL AUTO_INCREMENT,
  `department_name` VARCHAR(255) NOT NULL,
  `department_office` INT NOT NULL,
  PRIMARY KEY (`department_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `universitydb`.`rooms`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `universitydb`.`rooms` (
  `room_id` INT NOT NULL AUTO_INCREMENT,
  `room_name` VARCHAR(255) NOT NULL,
  `room_capacity` INT NOT NULL,
  PRIMARY KEY (`room_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `universitydb`.`courses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `universitydb`.`courses` (
  `crn` INT NOT NULL AUTO_INCREMENT,
  `course_name` VARCHAR(255) NOT NULL,
  `start_time` DATETIME NOT NULL,
  `end_time` DATETIME NOT NULL,
  `room_id` INT NOT NULL,
  PRIMARY KEY (`crn`),
  CONSTRAINT `fk_courses_rooms`
    FOREIGN KEY (`room_id`)
    REFERENCES `universitydb`.`rooms` (`room_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `universitydb`.`majors_in`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `universitydb`.`majors_in` (
  `major_id` INT NOT NULL AUTO_INCREMENT,
  `student_id` INT NOT NULL,
  `department_id` INT NOT NULL,
  PRIMARY KEY (`major_id`, `student_id`, `department_id`),
  CONSTRAINT `fk_students_has_departments_students1`
    FOREIGN KEY (`student_id`)
    REFERENCES `universitydb`.`students` (`student_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_students_has_departments_departments1`
    FOREIGN KEY (`department_id`)
    REFERENCES `universitydb`.`departments` (`department_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `universitydb`.`enrolled`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `universitydb`.`enrolled` (
  `student_id` INT NOT NULL,
  `course_crn` INT NOT NULL,
  `credit_status` VARCHAR(45) NOT NULL,
  `enrollement_id` INT NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`enrollement_id`),
  CONSTRAINT `fk_students_has_courses_students1`
    FOREIGN KEY (`student_id`)
    REFERENCES `universitydb`.`students` (`student_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_students_has_courses_courses1`
    FOREIGN KEY (`course_crn`)
    REFERENCES `universitydb`.`courses` (`crn`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- SQL query to find all the rooms that can seat at least 100 people
SELECT * FROM `rooms` WHERE room_capacity>=100

-- SQL query to find the courses with the earliest start time
SELECT course_name, MIN(start_time) FROM `courses`

-- SQL query to find the courses taken by BIF majors
SELECT DISTINCT c.course_name from majors_in as m, enrolled as e, departments as d, courses as c where d.department_name LIKE "BIF" and m.department_id = d.department_id and e.student_id = m.student_id and e.course_crn = c.crn

-- SQL query to find the students that are not enrolled in any course
SELECT DISTINCT s.student_name FROM students s WHERE NOT EXISTS (SELECT * from enrolled e where e.student_id = s.student_id)

-- SQL query to find the count of CS students enrolled in CSC275
SELECT count(DISTINCT e.student_id) FROM enrolled e, majors_in m, courses c, departments d WHERE d.department_name="CS" and m.department_id = d.department_id and c.course_name="CSC275" and e.course_crn = c.crn

-- SQL query to find the count of CS students enrolled in any course
SELECT count(DISTINCT e.student_id) FROM enrolled e, majors_in m, departments d WHERE d.department_name="CS" and m.department_id = d.department_id and e.student_id = m.student_id

-- SQL query to find the number of majors that each student has declared
SELECT s.student_id, COUNT(m.department_id) FROM majors_in m, students s WHERE m.student_id = s.student_id GROUP BY s.student_id

-- SQL query to get all departments with more than one majoring student
SELECT d.department_name, COUNT(m.student_id) FROM majors_in m, departments d WHERE m.department_id = d.department_id GROUP BY m.department_id HAVING COUNT(m.student_id)>1


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
