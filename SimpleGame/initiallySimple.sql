-- MySQL Workbench Synchronization
-- Generated: 2022-08-05 18:14
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: LENOVO

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

DROP SCHEMA IF EXISTS `simpleGame`;
CREATE SCHEMA IF NOT EXISTS `simpleGame` DEFAULT CHARACTER SET utf8 ;

CREATE TABLE `simpleGame`.`contract` (
  `id` TINYINT NOT NULL AUTO_INCREMENT,
  `contract_address` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  UNIQUE INDEX `contract_address_UNIQUE` (`contract_address` ASC) VISIBLE);


CREATE TABLE IF NOT EXISTS `simpleGame`.`user` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_name` VARCHAR(45) NOT NULL,
  `user_address` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  UNIQUE INDEX `user_name_UNIQUE` (`user_name` ASC) VISIBLE,
  UNIQUE INDEX `user_address_UNIQUE` (`user_address` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


CREATE TABLE IF NOT EXISTS `simpleGame`.`category` (
  `id` TINYINT NOT NULL AUTO_INCREMENT,
  `category_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  UNIQUE INDEX `category_name_UNIQUE` (`category_name` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


CREATE TABLE `simpleGame`.`transaction_type` (
  `id` TINYINT NOT NULL AUTO_INCREMENT,
  `transaction_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  UNIQUE INDEX `transaction_name_UNIQUE` (`transaction_name` ASC) VISIBLE);



CREATE TABLE IF NOT EXISTS `simpleGame`.`item` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `item_code` VARCHAR(100) NOT NULL,
  `game_code` VARCHAR(100) NOT NULL,
  `item_name` VARCHAR(45) NOT NULL,
  `category_id` TINYINT NOT NULL,
  `contract_id` TINYINT NOT NULL,
  `parent_id` INT,
  `status` TINYINT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  UNIQUE INDEX `item_code_UNIQUE` (`item_code` ASC) VISIBLE,
  UNIQUE INDEX `game_code_UNIQUE` (`game_code` ASC) VISIBLE,
  UNIQUE INDEX `item_name_UNIQUE` (`item_name` ASC) VISIBLE,
  INDEX `fk_item_category1_idx` (`category_id` ASC) VISIBLE,
  INDEX `fk_item_contract1_idx` (`contract_id` ASC) VISIBLE,
  INDEX `fk_item_item1_idx` (`parent_id` ASC) VISIBLE,
  CONSTRAINT `fk_item_category1`
    FOREIGN KEY (`category_id`)
    REFERENCES `simpleGame`.`category` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_item_contract1`
    FOREIGN KEY (`contract_id`)
    REFERENCES `simpleGame`.`contract` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_item_item1`
    FOREIGN KEY (`parent_id`)
    REFERENCES `simpleGame`.`item` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;



CREATE TABLE IF NOT EXISTS `simpleGame`.`asset` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `asset_qty` INT NOT NULL,
  `user_id` INT NOT NULL,
  `item_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `fk_asset_user1_idx` (`user_id` ASC) VISIBLE,
  INDEX `fk_asset_item1_idx` (`item_id` ASC) VISIBLE,
  CONSTRAINT `fk_asset_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `simpleGame`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_asset_item1`
    FOREIGN KEY (`item_id`)
    REFERENCES `simpleGame`.`item` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `simpleGame`.`transaction` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `transaction_date` DATETIME NOT NULL,
  `transaction_qty` INT NOT NULL,
  `user_from_id` INT NOT NULL,
  `user_to_id` INT NOT NULL,
  `item_id` INT NOT NULL,
  `type_id` TINYINT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `fk_transaction_user1_idx` (`user_from_id` ASC) VISIBLE,
  INDEX `fk_transaction_item1_idx` (`item_id` ASC) VISIBLE,
  INDEX `fk_transaction_user2_idx` (`user_to_id` ASC) VISIBLE,
  INDEX `fk_transaction_type1_idx` (`type_id` ASC) VISIBLE,
  CONSTRAINT `fk_transaction_user1`
    FOREIGN KEY (`user_from_id`)
    REFERENCES `simpleGame`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_transaction_item1`
    FOREIGN KEY (`item_id`)
    REFERENCES `simpleGame`.`item` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_transaction_user2`
    FOREIGN KEY (`user_to_id`)
    REFERENCES `simpleGame`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_transaction_type1`
    FOREIGN KEY (`type_id`)
    REFERENCES `simpleGame`.`transaction_type` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


DELIMITER $$
CREATE DEFINER = CURRENT_USER TRIGGER `simpleGame`.`transaction_BEFORE_INSERT` BEFORE INSERT ON `transaction` FOR EACH ROW
BEGIN
	IF (SELECT COUNT(*) FROM asset 
       WHERE user_id = NEW.user_from_id AND item_id = NEW.item_id) = 0 THEN
	   INSERT INTO asset (asset_qty, user_id, item_id) VALUES (0, NEW.user_from_id, NEW.item_id);			
    END IF;
    IF (SELECT COUNT(*) FROM asset 
       WHERE user_id = NEW.user_to_id AND item_id = NEW.item_id) = 0 THEN
	   INSERT INTO asset (asset_qty, user_id, item_id) VALUES (0, NEW.user_to_id, NEW.item_id);			
    END IF;
END$$
DELIMITER ;



DELIMITER $$
CREATE TRIGGER `simpleGame`.`transaction_AFTER_INSERT` AFTER INSERT ON `transaction` FOR EACH ROW
BEGIN
	UPDATE asset
    SET asset_qty = asset_qty - NEW.transaction_qty
    WHERE user_id = NEW.user_from_id AND item_id = NEW.item_id;

	UPDATE asset
    SET asset_qty = asset_qty + NEW.transaction_qty
    WHERE user_id = NEW.user_to_id AND item_id = NEW.item_id;
END$$
DELIMITER ;



DELIMITER $$
CREATE DEFINER = CURRENT_USER TRIGGER `simpleGame`.`transaction_BEFORE_UPDATE` BEFORE UPDATE ON `transaction` FOR EACH ROW
BEGIN
	UPDATE asset
    SET asset_qty = asset_qty + OLD.transaction_qty
    WHERE user_id = OLD.user_from_id AND item_id = OLD.item_id;

	UPDATE asset
    SET asset_qty = asset_qty - OLD.transaction_qty
    WHERE user_id = OLD.user_to_id AND item_id = OLD.item_id;
END$$
DELIMITER ;



DELIMITER $$
CREATE DEFINER = CURRENT_USER TRIGGER `simpleGame`.`transaction_AFTER_UPDATE` AFTER UPDATE ON `transaction` FOR EACH ROW
BEGIN
	UPDATE asset
    SET asset_qty = asset_qty - NEW.transaction_qty
    WHERE user_id = NEW.user_from_id AND item_id = NEW.item_id;

	UPDATE asset
    SET asset_qty = asset_qty + NEW.transaction_qty
    WHERE user_id = NEW.user_to_id AND item_id = NEW.item_id;
END$$
DELIMITER ;



DELIMITER $$
CREATE DEFINER = CURRENT_USER TRIGGER `simpleGame`.`transaction_AFTER_DELETE` AFTER DELETE ON `transaction` FOR EACH ROW
BEGIN
    UPDATE asset
    SET asset_qty = asset_qty + OLD.transaction_qty
    WHERE user_id = OLD.user_from_id AND item_id = OLD.item_id;

	UPDATE asset
    SET asset_qty = asset_qty - OLD.transaction_qty
    WHERE user_id = OLD.user_to_id AND item_id = OLD.item_id;
END$$
DELIMITER ;


INSERT INTO `simpleGame`.`user` (`user_name`,`user_address`) 
VALUES ('system','mysql'),('burhan','avcilar'),('osman','beylikduzu'),('can','arnavutkoy');

INSERT INTO `simpleGame`.`category` (`category_name`) 
VALUES ('weapon'),('magazine'),('bullet'),('furniture');

INSERT INTO `simpleGame`.`contract` (`contract_address`) 
VALUES ('x0x1x2x3c21cft2yf1f13');

INSERT INTO `simpleGame`.`transaction_type` (`transaction_name`) 
VALUES ('sale'),('free');

INSERT INTO `simpleGame`.`item` (`item_code`,`game_code`,`item_name`,`category_id`,`contract_id`,`parent_id`,`status`) 
VALUES ('asdf','zxcv','qwer',1,1,null,1),
       ('ghjk','vbnm','tyui',2,1,1,1),
       ('qazx','wsxc','edcv',1,1,null,1),
       ('wqaz','ewsx','redc',3,1,2,1),
       ('vcde','bvfr','nbgt',4,1,null,1),
       ('reds','fdcx','gfvc',4,1,null,1),
       ('bgfr','nbgf','mnhg',3,1,2,1),
       ('rtgh','tghn','fgty',1,1,null,1),
       ('mjhn','mjki','ujko',2,1,3,1),
       ('vfgt','bghy','polk',4,1,null,1),
       ('loik','kiuj','juyh',1,1,null,1),
       ('hytg','gtrf','fred',3,1,9,1);

INSERT INTO `simpleGame`.`transaction` (`transaction_date`,`transaction_qty`,`user_from_id`,`user_to_id`,`item_id`,`type_id`) 
VALUES ('2022-07-31 20:15:57',1,1,2,10,2),
       ('2022-08-01 05:24:45',1,3,4,5,1),
       ('2022-08-02 12:45:23',1,2,1,4,2),
       ('2022-07-26 15:34:42',2,4,3,7,1),
       ('2022-07-28 03:15:36',3,1,3,12,2),
       ('2022-07-27 02:34:12',3,2,1,9,2),
       ('2022-07-25 22:46:25',1,2,4,6,1),
       ('2022-07-26 23:27:43',1,4,1,8,2),
       ('2022-07-29 20:15:57',2,3,2,9,1),
       ('2022-07-30 19:56:21',2,1,3,11,2),
       ('2022-07-31 14:23:41',3,2,1,10,2),
       ('2022-07-24 23:35:57',3,3,1,1,2),
       ('2022-07-26 16:15:36',2,4,1,12,2),
       ('2022-07-23 13:37:32',1,3,2,3,1),
       ('2022-07-24 15:32:39',2,2,1,5,2),
       ('2022-07-26 22:15:22',2,1,4,7,1),
       ('2022-07-27 23:43:57',3,2,3,7,1),
       ('2022-07-21 21:36:12',3,4,2,3,1),
       ('2022-07-22 20:15:57',1,3,1,9,2);

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;