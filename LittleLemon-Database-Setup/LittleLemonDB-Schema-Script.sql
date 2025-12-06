-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema LittleLemonDB
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `LittleLemonDB` ;

-- -----------------------------------------------------
-- Schema LittleLemonDB
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `LittleLemonDB` DEFAULT CHARACTER SET utf8 ;
USE `LittleLemonDB` ;

-- -----------------------------------------------------
-- Table `LittleLemonDB`.`customers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LittleLemonDB`.`customers` ;

CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`customers` (
  `customer_id` INT NOT NULL AUTO_INCREMENT,
  `full_name` VARCHAR(100) NOT NULL,
  `contact_numbers` VARCHAR(100) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`customer_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`bookings`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LittleLemonDB`.`bookings` ;

CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`bookings` (
  `booking_id` INT NOT NULL AUTO_INCREMENT,
  `booking_date` DATE NOT NULL,
  `table_number` INT NOT NULL,
  `customer_id` INT NULL,
  PRIMARY KEY (`booking_id`),
  INDEX `booking_customer_idx` (`customer_id` ASC) VISIBLE,
  CONSTRAINT `booking_customer`
    FOREIGN KEY (`customer_id`)
    REFERENCES `LittleLemonDB`.`customers` (`customer_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`staff`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LittleLemonDB`.`staff` ;

CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`staff` (
  `staff_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `role` VARCHAR(45) NOT NULL,
  `salary` DECIMAL(8,2) NOT NULL,
  PRIMARY KEY (`staff_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`delivery_status`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LittleLemonDB`.`delivery_status` ;

CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`delivery_status` (
  `delivery_status_id` INT NOT NULL AUTO_INCREMENT,
  `delivery_date` DATE NOT NULL,
  `status` VARCHAR(45) NOT NULL,
  `staff_id` INT NULL,
  PRIMARY KEY (`delivery_status_id`),
  INDEX `staff_id_idx` (`staff_id` ASC) VISIBLE,
  CONSTRAINT `staff_id`
    FOREIGN KEY (`staff_id`)
    REFERENCES `LittleLemonDB`.`staff` (`staff_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`menu_item`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LittleLemonDB`.`menu_item` ;

CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`menu_item` (
  `menu_item_id` INT NOT NULL AUTO_INCREMENT,
  `course_name` VARCHAR(45) NULL,
  `starter_name` VARCHAR(45) NULL,
  `drink_name` VARCHAR(45) NULL,
  PRIMARY KEY (`menu_item_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`menu`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LittleLemonDB`.`menu` ;

CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`menu` (
  `menu_id` INT NOT NULL AUTO_INCREMENT,
  `menu_name` VARCHAR(100) NOT NULL,
  `menu_item_id` INT NOT NULL,
  `cuisine` VARCHAR(45) NULL,
  PRIMARY KEY (`menu_id`),
  INDEX `menu_item_id_idx` (`menu_item_id` ASC) VISIBLE,
  CONSTRAINT `menu_item_id`
    FOREIGN KEY (`menu_item_id`)
    REFERENCES `LittleLemonDB`.`menu_item` (`menu_item_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`orders`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LittleLemonDB`.`orders` ;

CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`orders` (
  `order_id` INT NOT NULL AUTO_INCREMENT,
  `order_date` DATE NOT NULL,
  `quantity` VARCHAR(45) NOT NULL,
  `total_cost` DECIMAL(8,2) NOT NULL,
  `customer_id` INT NULL,
  `delivery_status_id` INT NULL,
  `menu_id` INT NULL,
  PRIMARY KEY (`order_id`),
  INDEX `customer_id_idx` (`customer_id` ASC) VISIBLE,
  INDEX `delivery_status_id_idx` (`delivery_status_id` ASC) VISIBLE,
  INDEX `menu_id_idx` (`menu_id` ASC) VISIBLE,
  CONSTRAINT `customer_id`
    FOREIGN KEY (`customer_id`)
    REFERENCES `LittleLemonDB`.`customers` (`customer_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `delivery_status_id`
    FOREIGN KEY (`delivery_status_id`)
    REFERENCES `LittleLemonDB`.`delivery_status` (`delivery_status_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `menu_id`
    FOREIGN KEY (`menu_id`)
    REFERENCES `LittleLemonDB`.`menu` (`menu_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
