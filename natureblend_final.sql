-- --------------------------------------------------------
-- 호스트:                          223.130.159.72
-- 서버 버전:                        10.6.18-MariaDB-0ubuntu0.22.04.1 - Ubuntu 22.04
-- 서버 OS:                        debian-linux-gnu
-- HeidiSQL 버전:                  12.8.0.6908
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- natureblend 데이터베이스 구조 내보내기
CREATE DATABASE IF NOT EXISTS `natureblend` /*!40100 DEFAULT CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci */;
USE `natureblend`;

-- 프로시저 natureblend.add_plan_by_orders 구조 내보내기
DELIMITER //
CREATE PROCEDURE `add_plan_by_orders`(
	IN p_order_num_json_array TEXT,
    IN p_plan_name varchar(50),
    in p_product_code_json_array TEXT,
    in p_plan_qty_json_array TEXT,
    in p_plan_start_date datetime,
    in p_plan_end_date datetime,
    in p_emp_num int
)
BEGIN
	DECLARE i INT DEFAULT 1;
    DECLARE order_num_array_length INT;
    DECLARE order_num_value TEXT;
    DECLARE product_code_value TEXT;
    DECLARE plan_qty_value TEXT;
    

	DECLARE plan_num INT;
    DECLARE order_num INT;
    declare count int;
    
    DECLARE v_result_value VARCHAR(20);
    
    START TRANSACTION;
    
    SET order_num_array_length = JSON_LENGTH(p_order_num_json_array);
    
    select count(*)
    into count
    from order_plan_relation;
    
    set count = count + 1;
    
    -- 반복적으로 JSON 배열 요소 추출
    WHILE i <= order_num_array_length DO
        SET order_num_value = JSON_UNQUOTE(JSON_EXTRACT(p_order_num_json_array, CONCAT('$[', i - 1, ']')));
        SET product_code_value = JSON_UNQUOTE(JSON_EXTRACT(p_product_code_json_array, CONCAT('$[', i - 1, ']')));
        -- SELECT CONCAT('Extracted product_code: ', product_code_value);
        SET plan_qty_value = JSON_UNQUOTE(JSON_EXTRACT(p_plan_qty_json_array, CONCAT('$[', i - 1, ']')));
        
        INSERT INTO order_plan_relation (plan_num, order_num, product_code, plan_qty)
        VALUES (count, order_num_value, product_code_value, plan_qty_value);
		SET  v_result_value = FOUND_ROWS();
        
        if v_result_value != 1 then
			ROLLBACK;
			SET  v_result_value = 'order_plan_relation insert fail';
		END if;

        SET i = i + 1;
    END WHILE;
    
    -- 생산계획번호plan_num(count임), 생산계획명 plan_name, 제품코드 product_code, 계획수량 plan_qty
-- 계획일자 plan_create_date(sysdate), 계획시작일자 plan_start_date, 계획종료일자 plan_end_date, 
-- 계획진행상태 plan_status(default plan_waiting), 생산계획자 emp_num
    
    -- order_plan_relation의 plan_num이 production_plan의 plan_num에도 들어감
    insert into production_plan(plan_num, plan_name, plan_start_date, plan_end_date, plan_emp)
    value(count, p_plan_name, p_plan_start_date, p_plan_end_date, p_emp_num);
    SET  v_result_value = FOUND_ROWS();
    
    if v_result_value != 1 then
		ROLLBACK;
		SET  v_result_value = 'production_plan insert fail';
	END if;
    
    SET  v_result_value = 'success';
    select v_result_value as result;
    
    COMMIT;
END//
DELIMITER ;

-- 테이블 natureblend.bev_test_details 구조 내보내기
CREATE TABLE IF NOT EXISTS `bev_test_details` (
  `bev_test_details_id` int(10) NOT NULL AUTO_INCREMENT,
  `bev_test_item_id` int(10) NOT NULL,
  `etc_min` double NOT NULL DEFAULT 0,
  `etc_max` double NOT NULL DEFAULT 0,
  `product_code` varchar(30) NOT NULL,
  PRIMARY KEY (`bev_test_details_id`)
) ENGINE=InnoDB AUTO_INCREMENT=94 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- 테이블 데이터 natureblend.bev_test_details:~90 rows (대략적) 내보내기
INSERT INTO `bev_test_details` (`bev_test_details_id`, `bev_test_item_id`, `etc_min`, `etc_max`, `product_code`) VALUES
	(1, 1, 3.2, 4, 'P001'),
	(2, 2, 0, 1000, 'P001'),
	(3, 3, 14, 20, 'P001'),
	(4, 4, 0, 0.1, 'P001'),
	(5, 5, 0, 0, 'P001'),
	(6, 1, 3.2, 4, 'P002'),
	(7, 2, 0, 1000, 'P002'),
	(8, 3, 14, 20, 'P002'),
	(9, 4, 0, 0.1, 'P002'),
	(10, 5, 0, 0, 'P002'),
	(11, 1, 3.2, 4, 'P003'),
	(12, 2, 0, 1000, 'P003'),
	(13, 3, 14, 20, 'P003'),
	(14, 4, 0, 0.1, 'P003'),
	(15, 5, 0, 0, 'P003'),
	(16, 1, 3.4, 4, 'P004'),
	(17, 2, 0, 1000, 'P004'),
	(18, 3, 10, 12, 'P004'),
	(19, 4, 0, 0.1, 'P004'),
	(20, 5, 0, 0, 'P004'),
	(21, 1, 3.4, 4, 'P005'),
	(22, 2, 0, 1000, 'P005'),
	(23, 3, 10, 12, 'P005'),
	(24, 4, 0, 0.1, 'P005'),
	(25, 5, 0, 0, 'P005'),
	(26, 1, 3.4, 4, 'P006'),
	(27, 2, 0, 1000, 'P006'),
	(28, 3, 10, 12, 'P006'),
	(29, 4, 0, 0.1, 'P006'),
	(30, 5, 0, 0, 'P006'),
	(31, 1, 3.3, 4.2, 'P007'),
	(32, 2, 0, 1000, 'P007'),
	(33, 3, 10, 12, 'P007'),
	(34, 4, 0, 0.1, 'P007'),
	(35, 5, 0, 0, 'P007'),
	(36, 1, 3.3, 4.2, 'P008'),
	(37, 2, 0, 1000, 'P008'),
	(38, 3, 10, 12, 'P008'),
	(39, 4, 0, 0.1, 'P008'),
	(40, 5, 0, 0, 'P008'),
	(41, 1, 3.3, 4.2, 'P009'),
	(42, 2, 0, 1000, 'P009'),
	(43, 3, 10, 12, 'P009'),
	(44, 4, 0, 0.1, 'P009'),
	(45, 5, 0, 0, 'P009'),
	(46, 1, 2, 2.6, 'P010'),
	(47, 2, 0, 1000, 'P010'),
	(48, 3, 6, 8, 'P010'),
	(49, 4, 0, 0.1, 'P010'),
	(50, 5, 0, 0, 'P010'),
	(51, 1, 2, 2.6, 'P011'),
	(52, 2, 0, 1000, 'P011'),
	(53, 3, 6, 8, 'P011'),
	(54, 4, 0, 0.1, 'P011'),
	(55, 5, 0, 0, 'P011'),
	(56, 1, 2, 2.6, 'P012'),
	(57, 2, 0, 1000, 'P012'),
	(58, 3, 6, 8, 'P012'),
	(59, 4, 0, 0.1, 'P012'),
	(60, 5, 0, 0, 'P012'),
	(61, 1, 3.9, 4.6, 'P013'),
	(62, 2, 0, 1000, 'P013'),
	(63, 3, 14, 18, 'P013'),
	(64, 4, 0, 0.1, 'P013'),
	(65, 5, 0, 0, 'P013'),
	(66, 1, 3.9, 4.6, 'P014'),
	(67, 2, 0, 1000, 'P014'),
	(68, 3, 14, 18, 'P014'),
	(69, 4, 0, 0.1, 'P014'),
	(70, 5, 0, 0, 'P014'),
	(71, 1, 3.9, 4.6, 'P015'),
	(72, 2, 0, 1000, 'P015'),
	(73, 3, 14, 18, 'P015'),
	(74, 4, 0, 0.1, 'P015'),
	(75, 5, 0, 0, 'P015'),
	(76, 1, 4.2, 5.2, 'P016'),
	(77, 2, 0, 1000, 'P016'),
	(78, 3, 8, 13, 'P016'),
	(79, 4, 0, 0.1, 'P016'),
	(80, 5, 0, 0, 'P016'),
	(81, 1, 4.2, 5.2, 'P017'),
	(82, 2, 0, 1000, 'P017'),
	(83, 3, 8, 13, 'P017'),
	(84, 4, 0, 0.1, 'P017'),
	(85, 5, 0, 0, 'P017'),
	(86, 1, 4.2, 5.2, 'P018'),
	(87, 2, 0, 1000, 'P018'),
	(88, 3, 8, 13, 'P018'),
	(89, 4, 0, 0.1, 'P018'),
	(90, 5, 0, 0, 'P018');

-- 테이블 natureblend.bev_test_item 구조 내보내기
CREATE TABLE IF NOT EXISTS `bev_test_item` (
  `bev_test_item_id` int(10) NOT NULL,
  `item_name` varchar(50) NOT NULL COMMENT '당도, 산도...',
  `item_unit` varchar(10) NOT NULL,
  PRIMARY KEY (`bev_test_item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- 테이블 데이터 natureblend.bev_test_item:~5 rows (대략적) 내보내기
INSERT INTO `bev_test_item` (`bev_test_item_id`, `item_name`, `item_unit`) VALUES
	(1, 'pH', 'pH'),
	(2, 'CFU', 'CFU/mL'),
	(3, 'Brix', '°Bx'),
	(4, 'PesticideResidues', 'ppm'),
	(5, 'YeastAndMold', 'CFU/mL');

-- 테이블 natureblend.bev_test_result 구조 내보내기
CREATE TABLE IF NOT EXISTS `bev_test_result` (
  `bev_test_result_id` int(10) NOT NULL AUTO_INCREMENT,
  `qc_berverage_id` varchar(20) NOT NULL,
  `bev_test_details_id` int(10) NOT NULL,
  `bev_test_item_id` int(10) NOT NULL,
  `actual_value` double DEFAULT NULL,
  `is_passed` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`bev_test_result_id`)
) ENGINE=InnoDB AUTO_INCREMENT=151 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- 테이블 데이터 natureblend.bev_test_result:~80 rows (대략적) 내보내기
INSERT INTO `bev_test_result` (`bev_test_result_id`, `qc_berverage_id`, `bev_test_details_id`, `bev_test_item_id`, `actual_value`, `is_passed`) VALUES
	(71, 'QCPB2501070001', 21, 1, 3.4, 'yes'),
	(72, 'QCPB2501070001', 22, 2, 0, 'yes'),
	(73, 'QCPB2501070001', 23, 3, 10, 'yes'),
	(74, 'QCPB2501070001', 24, 4, 0, 'yes'),
	(75, 'QCPB2501070001', 25, 5, 0, 'yes'),
	(76, 'QCPB2501070002', 21, 1, 3.4, 'yes'),
	(77, 'QCPB2501070002', 22, 2, 0, 'yes'),
	(78, 'QCPB2501070002', 23, 3, 10, 'yes'),
	(79, 'QCPB2501070002', 24, 4, 0, 'yes'),
	(80, 'QCPB2501070002', 25, 5, 0, 'yes'),
	(81, 'QCPB2501070003', 1, 1, 3.2, 'yes'),
	(82, 'QCPB2501070003', 2, 2, 0, 'yes'),
	(83, 'QCPB2501070003', 3, 3, 14, 'yes'),
	(84, 'QCPB2501070003', 4, 4, 0, 'yes'),
	(85, 'QCPB2501070003', 5, 5, 0, 'yes'),
	(86, 'QCPB2501070004', 46, 1, 2, 'yes'),
	(87, 'QCPB2501070004', 47, 2, 0, 'yes'),
	(88, 'QCPB2501070004', 48, 3, 6, 'yes'),
	(89, 'QCPB2501070004', 49, 4, 0, 'yes'),
	(90, 'QCPB2501070004', 50, 5, 0, 'yes'),
	(91, 'QCPB2501070005', 46, 1, 2, 'yes'),
	(92, 'QCPB2501070005', 47, 2, 0, 'yes'),
	(93, 'QCPB2501070005', 48, 3, 6, 'yes'),
	(94, 'QCPB2501070005', 49, 4, 0, 'yes'),
	(95, 'QCPB2501070005', 50, 5, 0, 'yes'),
	(96, 'QCPB2501070006', 46, 1, 1, 'no'),
	(97, 'QCPB2501070006', 47, 2, 0, 'yes'),
	(98, 'QCPB2501070006', 48, 3, 5, 'no'),
	(99, 'QCPB2501070006', 49, 4, 0, 'yes'),
	(100, 'QCPB2501070006', 50, 5, 0, 'yes'),
	(101, 'QCPB2501070007', 76, 1, 4.2, 'yes'),
	(102, 'QCPB2501070007', 77, 2, 0, 'yes'),
	(103, 'QCPB2501070007', 78, 3, 8, 'yes'),
	(104, 'QCPB2501070007', 79, 4, 0, 'yes'),
	(105, 'QCPB2501070007', 80, 5, 0, 'yes'),
	(106, 'QCPB2501070009', 76, 1, 4.2, 'yes'),
	(107, 'QCPB2501070009', 77, 2, 0, 'yes'),
	(108, 'QCPB2501070009', 78, 3, 8, 'yes'),
	(109, 'QCPB2501070009', 79, 4, 0, 'yes'),
	(110, 'QCPB2501070009', 80, 5, 0, 'yes'),
	(111, 'QCPB2501070010', 31, 1, 3.3, 'yes'),
	(112, 'QCPB2501070010', 32, 2, 0, 'yes'),
	(113, 'QCPB2501070010', 33, 3, 10, 'yes'),
	(114, 'QCPB2501070010', 34, 4, 0, 'yes'),
	(115, 'QCPB2501070010', 35, 5, 0, 'yes'),
	(116, 'QCPB2501080001', 16, 1, 3.4, 'yes'),
	(117, 'QCPB2501080001', 17, 2, 0, 'yes'),
	(118, 'QCPB2501080001', 18, 3, 10, 'yes'),
	(119, 'QCPB2501080001', 19, 4, 0, 'yes'),
	(120, 'QCPB2501080001', 20, 5, 0, 'yes'),
	(121, 'QCPB2501080002', 61, 1, 3.9, 'yes'),
	(122, 'QCPB2501080002', 62, 2, 0, 'yes'),
	(123, 'QCPB2501080002', 63, 3, 14, 'yes'),
	(124, 'QCPB2501080002', 64, 4, 0, 'yes'),
	(125, 'QCPB2501080002', 65, 5, 0, 'yes'),
	(126, 'QCPB2501070011', 31, 1, 62513515, 'yes'),
	(127, 'QCPB2501070011', 32, 2, 0, 'yes'),
	(128, 'QCPB2501070011', 33, 3, 10, 'yes'),
	(129, 'QCPB2501070011', 34, 4, 0, 'yes'),
	(130, 'QCPB2501070011', 35, 5, 0, 'yes'),
	(131, 'QCPB2501070008', 76, 1, 5, 'yes'),
	(132, 'QCPB2501070008', 77, 2, 0, 'yes'),
	(133, 'QCPB2501070008', 78, 3, 9, 'yes'),
	(134, 'QCPB2501070008', 79, 4, 0, 'yes'),
	(135, 'QCPB2501070008', 80, 5, 0, 'yes'),
	(136, 'QCPB2501080008', 76, 1, 5, 'yes'),
	(137, 'QCPB2501080008', 77, 2, 0, 'yes'),
	(138, 'QCPB2501080008', 78, 3, 9, 'yes'),
	(139, 'QCPB2501080008', 79, 4, 0, 'yes'),
	(140, 'QCPB2501080008', 80, 5, 1, 'no'),
	(141, 'QCPB2501080006', 26, 1, 4, 'yes'),
	(142, 'QCPB2501080006', 27, 2, 0, 'yes'),
	(143, 'QCPB2501080006', 28, 3, 10, 'yes'),
	(144, 'QCPB2501080006', 29, 4, 0, 'yes'),
	(145, 'QCPB2501080006', 30, 5, 1, 'no'),
	(146, 'QCPB2501080007', 76, 1, 4.5, 'yes'),
	(147, 'QCPB2501080007', 77, 2, 1, 'yes'),
	(148, 'QCPB2501080007', 78, 3, 8, 'yes'),
	(149, 'QCPB2501080007', 79, 4, 0, 'yes'),
	(150, 'QCPB2501080007', 80, 5, 0, 'yes');

-- 테이블 natureblend.bom 구조 내보내기
CREATE TABLE IF NOT EXISTS `bom` (
  `bom_num` int(30) NOT NULL AUTO_INCREMENT,
  `product_code` varchar(30) NOT NULL,
  `product_name` varchar(30) NOT NULL,
  `capacity` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`bom_num`,`product_code`),
  KEY `FK_product_TO_bom_1` (`product_code`),
  CONSTRAINT `FK_product_TO_bom_1` FOREIGN KEY (`product_code`) REFERENCES `product` (`product_code`)
) ENGINE=InnoDB AUTO_INCREMENT=114 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- 테이블 데이터 natureblend.bom:~19 rows (대략적) 내보내기
INSERT INTO `bom` (`bom_num`, `product_code`, `product_name`, `capacity`) VALUES
	(2, 'P002', '포도17 (750ml)', 750),
	(3, 'P003', '포도17 (1.5L)', 1500),
	(4, 'P004', '애플팜 (500ml)', 500),
	(5, 'P005', '애플팜 (750ml)', 750),
	(6, 'P006', '애플팜 (1.5L)', 1500),
	(7, 'P007', '오렌쥬시 (500ml)', 500),
	(8, 'P008', '오렌쥬시 (750ml)', 750),
	(9, 'P009', '오렌쥬시 (1.5L)', 1500),
	(10, 'P010', '레몬의꿈 (500ml)', 500),
	(11, 'P011', '레몬의꿈 (750ml)', 750),
	(12, 'P012', '레몬의꿈 (1.5L)', 1500),
	(13, 'P013', '아이망고 (500ml)', 500),
	(14, 'P014', '아이망고 (750ml)', 750),
	(15, 'P015', '아이망고 (1.5L)', 1500),
	(16, 'P016', '당근이세요? (500ml)', 500),
	(17, 'P017', '당근이세요? (750ml)', 750),
	(18, 'P018', '당근이세요? (1.5L)', 1500),
	(84, 'P001', '포도17 (500ml)', 500),
	(113, 'P019', '피치피치(500ml)', 500);

-- 테이블 natureblend.bom_material 구조 내보내기
CREATE TABLE IF NOT EXISTS `bom_material` (
  `bom_seq` int(20) NOT NULL AUTO_INCREMENT,
  `bom_num` int(30) NOT NULL,
  `material_code` varchar(30) NOT NULL,
  `material` varchar(30) NOT NULL,
  `material_con` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`bom_seq`,`bom_num`,`material_code`),
  KEY `FK_bom_TO_bom_material_1` (`bom_num`),
  KEY `FK_material_TO_bom_material_1` (`material_code`),
  CONSTRAINT `FK_bom_TO_bom_material_1` FOREIGN KEY (`bom_num`) REFERENCES `bom` (`bom_num`),
  CONSTRAINT `FK_material_TO_bom_material_1` FOREIGN KEY (`material_code`) REFERENCES `material` (`material_code`)
) ENGINE=InnoDB AUTO_INCREMENT=210 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- 테이블 데이터 natureblend.bom_material:~109 rows (대략적) 내보내기
INSERT INTO `bom_material` (`bom_seq`, `bom_num`, `material_code`, `material`, `material_con`) VALUES
	(1, 2, 'M001', '포도', 128),
	(2, 2, 'M007', '설탕', 83),
	(3, 2, 'M008', '식용색소', 8),
	(4, 2, 'M010', '정수물', 525),
	(5, 2, 'M009', '향료', 8),
	(6, 3, 'M001', '포도', 255),
	(7, 3, 'M007', '설탕', 165),
	(8, 3, 'M008', '식용색소', 15),
	(9, 3, 'M009', '향료', 15),
	(10, 3, 'M010', '정수물', 1050),
	(11, 5, 'M002', '사과', 660),
	(12, 5, 'M007', '설탕', 38),
	(13, 5, 'M008', '식용색소', 8),
	(14, 5, 'M009', '향료', 30),
	(15, 5, 'M010', '정수물', 225),
	(16, 6, 'M002', '사과', 1320),
	(17, 6, 'M008', '식용색소', 15),
	(18, 6, 'M007', '설탕', 75),
	(19, 6, 'M009', '향료', 60),
	(20, 6, 'M010', '정수물', 450),
	(21, 7, 'M003', '오렌지', 800),
	(22, 7, 'M007', '설탕', 30),
	(23, 7, 'M008', '식용색소', 5),
	(24, 7, 'M009', '향료', 15),
	(25, 7, 'M010', '정수물', 100),
	(26, 8, 'M008', '식용색소', 8),
	(27, 8, 'M003', '오렌지', 1200),
	(28, 8, 'M007', '설탕', 45),
	(29, 8, 'M009', '향료', 23),
	(30, 8, 'M010', '정수물', 150),
	(31, 9, 'M003', '오렌지', 2400),
	(32, 9, 'M007', '설탕', 90),
	(33, 9, 'M008', '식용색소', 15),
	(34, 9, 'M010', '정수물', 300),
	(35, 9, 'M009', '향료', 45),
	(36, 2, 'M012', '페트병 (750ml)', 1),
	(37, 3, 'M013', '페트병 (1.5L)', 1),
	(38, 5, 'M012', '페트병 (750ml)', 1),
	(39, 6, 'M013', '페트병 (1.5L)', 1),
	(40, 7, 'M011', '페트병 (500ml)', 1),
	(41, 8, 'M012', '페트병 (750ml)', 1),
	(42, 9, 'M013', '페트병 (1.5L)', 1),
	(48, 4, 'M002', '사과', 440),
	(49, 4, 'M007', '설탕', 25),
	(50, 4, 'M008', '식용색소', 5),
	(51, 4, 'M009', '향료', 20),
	(52, 4, 'M010', '정수물', 150),
	(53, 10, 'M004', '레몬', 847),
	(54, 10, 'M007', '설탕', 75),
	(55, 10, 'M010', '정수물', 250),
	(56, 10, 'M009', '향료', 3),
	(57, 10, 'M008', '식용색소', 3),
	(58, 11, 'M007', '설탕', 112),
	(59, 11, 'M004', '레몬', 1270),
	(60, 11, 'M010', '정수물', 375),
	(61, 11, 'M008', '식용색소', 5),
	(62, 11, 'M009', '향료', 5),
	(63, 12, 'M004', '레몬', 2541),
	(64, 12, 'M007', '설탕', 225),
	(65, 12, 'M008', '식용색소', 9),
	(66, 12, 'M009', '향료', 9),
	(67, 12, 'M010', '정수물', 750),
	(68, 13, 'M010', '정수물', 300),
	(69, 13, 'M005', '망고', 223),
	(70, 13, 'M007', '설탕', 75),
	(71, 13, 'M009', '향료', 6),
	(72, 13, 'M008', '식용색소', 6),
	(73, 14, 'M005', '망고', 334),
	(74, 14, 'M007', '설탕', 112),
	(75, 14, 'M008', '식용색소', 9),
	(76, 14, 'M009', '향료', 9),
	(77, 14, 'M010', '정수물', 450),
	(78, 15, 'M007', '설탕', 225),
	(79, 15, 'M005', '망고', 669),
	(80, 15, 'M009', '향료', 18),
	(81, 15, 'M008', '식용색소', 18),
	(82, 15, 'M010', '정수물', 900),
	(83, 17, 'M006', '당근', 877),
	(84, 17, 'M007', '설탕', 52),
	(85, 17, 'M009', '향료', 8),
	(86, 17, 'M008', '식용색소', 15),
	(87, 17, 'M010', '정수물', 225),
	(88, 18, 'M006', '당근', 1755),
	(89, 18, 'M007', '설탕', 105),
	(90, 18, 'M008', '식용색소', 30),
	(91, 18, 'M009', '향료', 15),
	(92, 18, 'M010', '정수물', 450),
	(93, 16, 'M006', '당근', 585),
	(94, 16, 'M007', '설탕', 35),
	(95, 16, 'M008', '식용색소', 10),
	(96, 16, 'M009', '향료', 5),
	(97, 16, 'M010', '정수물', 150),
	(98, 18, 'M013', '페트병 (1.5L)', 1),
	(99, 17, 'M012', '페트병 (750ml)', 1),
	(101, 4, 'M011', '페트병 (500ml)', 1),
	(102, 10, 'M011', '페트병 (500ml)', 1),
	(103, 11, 'M012', '페트병 (750ml)', 1),
	(104, 12, 'M013', '페트병 (1.5L)', 1),
	(105, 13, 'M011', '페트병 (500ml)', 1),
	(106, 14, 'M012', '페트병 (750ml)', 1),
	(107, 15, 'M013', '페트병 (1.5L)', 1),
	(108, 16, 'M011', '페트병 (500ml)', 1),
	(181, 84, 'M001', '포도', 85),
	(182, 84, 'M007', '설탕', 55),
	(183, 84, 'M008', '식용색소', 5),
	(184, 84, 'M009', '향료', 5),
	(185, 84, 'M010', '정수물', 350),
	(186, 84, 'M011', '페트병 (500ml)', 1),
	(209, 113, 'M014', '복숭아', 4);

-- 프로시저 natureblend.checkLotOutput 구조 내보내기
DELIMITER //
CREATE PROCEDURE `checkLotOutput`(
IN v_product_lot_json_array TEXT
)
BEGIN
DECLARE product_lot_array_length INT;
DECLARE v_sum_count  INT DEFAULT 0; 
DECLARE v_counts INT DEFAULT 0; 
DECLARE i INT DEFAULT 1;
DECLARE product_lot_value TEXT;

  -- 트렌젝션 시작
    START TRANSACTION;
SET product_lot_array_length = JSON_LENGTH(v_product_lot_json_array);

	-- product_lot 길이 만큼 for문 돌아서  i.input_num = o.input_num 값 수 체크 하기
		WHILE i <= product_lot_array_length DO
		SET product_lot_value  = JSON_UNQUOTE(JSON_EXTRACT(v_product_lot_json_array , CONCAT('$[', i - 1, ']')));
        
        SELECT COUNT(*)
		INTO  v_counts
		FROM input_body i JOIN output o 
		ON i.input_num = o.input_num
		WHERE i.product_lot = product_lot_value;
        
		-- 누적 합 업데이트
        SET v_sum_count = v_sum_count + v_counts;

        -- 반복문 인덱스 증가
        SET i = i + 1;
    END WHILE;

    -- 결과 출력
    SELECT v_sum_count AS total_output_count;

END//
DELIMITER ;

-- 테이블 natureblend.client 구조 내보내기
CREATE TABLE IF NOT EXISTS `client` (
  `client_num` int(30) NOT NULL AUTO_INCREMENT,
  `com_num` bigint(20) NOT NULL,
  `com_name` varchar(30) NOT NULL,
  `address` varchar(50) DEFAULT NULL,
  `trade` varchar(20) NOT NULL,
  `boss` varchar(20) DEFAULT NULL,
  `boss_tel` varchar(30) DEFAULT NULL,
  `emp_name` varchar(20) DEFAULT NULL,
  `emp_tel` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`client_num`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- 테이블 데이터 natureblend.client:~14 rows (대략적) 내보내기
INSERT INTO `client` (`client_num`, `com_num`, `com_name`, `address`, `trade`, `boss`, `boss_tel`, `emp_name`, `emp_tel`) VALUES
	(1, 6478100749, '하연과일농장', '대구시 좋은과수원길 123-2', '구매', '표하연', '010-8521-6704', '나잘해', '010-0000-1111'),
	(2, 2110715784, '설탕나라', '서울 설탕시 달달동 433-5번지', '구매', '설탕왕', '010-4564-7897', '달달해', '010-9999-8888'),
	(3, 2110715784, '바다향료', '경기도 향료시 색소동 433-5번지', '구매', '첨가왕', '010-1212-2121', '엠엣쥐', '010-7777-7777'),
	(4, 2110715784, '(주)고래마트', '부산광역시 해운대', '판매', '권주리', '010-7845-4224', '이미니', '010-4575-5122'),
	(5, 29661284, '더착한푸드몰', '울산광광역시 삼산', '판매', '권나윤', '010-5654-6524', '홍길동', '010-4568-5422'),
	(6, 15456452415, '(주) 저스트큐 ', '대구광역시', '판매', '홍길동', '010-5004-9994', '강아지', '010-4568-5422'),
	(7, 1231212345, '하얀물통', '경산북도 왜관시', '구매', '물통왕', '010-1111-1234', '나물병', '010-2222-3333'),
	(22, 43536, '예쁜색소', '서울시 구로구 색소공장', '구매', '크레용', '010-7894-5612', '색연필', '010-8569-9874'),
	(26, 1234567891, '설비제작소', '서울', '구매', '김사장', '010-3334-8885', '정사원', '010-8587-4901'),
	(28, 1548971263, '설비상사', '대구', '구매', '설사장', '010-1266-8885', '강사원', '010-4341-5989'),
	(29, 1349584391, '설비공업', '평양', '구매', '배사장', '010-9966-8664', '개사원', '010-4231-5111'),
	(34, 602541245121, '성원푸드', '서울광역시청담동204호', '판매', '김주리', '010-4512-1212', '이미주', '010-4215-1422'),
	(35, 29661284451, '(주)용운', '대구광역시 중구 142-1', '판매', '이강용', '010-9852-2546', '김민지', '010-7845-4215'),
	(36, 6478100458, '최부자농장', '경기도 남양주시 좋은 과수원길 122-33', '구매', '최아빠', '010-1112-3332', '최아들', '010-4556-7878');

-- 테이블 natureblend.common_main_code 구조 내보내기
CREATE TABLE IF NOT EXISTS `common_main_code` (
  `main_code` varchar(20) NOT NULL,
  `code_name` varchar(20) NOT NULL,
  `note` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`main_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- 테이블 데이터 natureblend.common_main_code:~0 rows (대략적) 내보내기

-- 테이블 natureblend.common_sub_code 구조 내보내기
CREATE TABLE IF NOT EXISTS `common_sub_code` (
  `sub_code` varchar(20) NOT NULL,
  `main_code` varchar(20) NOT NULL,
  `code_rule` varchar(50) NOT NULL,
  `sub_note` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`sub_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- 테이블 데이터 natureblend.common_sub_code:~0 rows (대략적) 내보내기

-- 프로시저 natureblend.deductMaterial 구조 내보내기
DELIMITER //
CREATE PROCEDURE `deductMaterial`(
    IN p_production_order_num INT
)
BEGIN
    -- 변수 선언
    DECLARE v_material_code VARCHAR(50);
    DECLARE v_lot_code VARCHAR(50);
    DECLARE v_lot_seq int;
    DECLARE v_material_qty INT;
    DECLARE done INT DEFAULT 0;

    -- 커서 선언
    DECLARE cur CURSOR FOR
        SELECT material_code, lot_code, lot_seq, material_qty
        FROM invalid_material
        WHERE production_order_num = p_production_order_num;

    -- 핸들러 선언
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- 커서 열기
    OPEN cur;

    -- 레코드 순회
    read_loop: LOOP
        -- 커서에서 한 행씩 추출
        FETCH cur INTO v_material_code, v_lot_code, v_lot_seq, v_material_qty;

        -- 종료 조건
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- 1. material_lot_qty1 테이블의 out_qty 업데이트
        UPDATE material_lot_qty1
        SET out_qty = out_qty + v_material_qty
        WHERE material_code = v_material_code
		  AND material_nomal = 'b1'
          AND lot_code = v_lot_code
          and lot_seq = v_lot_seq;

        -- 2. stok_qty 재계산
        UPDATE material_lot_qty1
        SET stok_qty = in_qty - out_qty
        WHERE material_code = v_material_code
          AND material_nomal = 'b1'
          AND lot_code = v_lot_code
          and lot_seq = v_lot_seq;

        -- 3. invalid_material 테이블의 is_out, out_date 업데이트
        UPDATE invalid_material
        SET is_out = TRUE,
            out_date = NOW()
        WHERE material_code = v_material_code
          AND lot_code = v_lot_code
          and lot_seq = v_lot_seq
          AND production_order_num = p_production_order_num;

    END LOOP;

    -- 커서 닫기
    CLOSE cur;

END//
DELIMITER ;

-- 프로시저 natureblend.deleteOrders 구조 내보내기
DELIMITER //
CREATE PROCEDURE `deleteOrders`(
IN v_order_num_json_array TEXT
)
BEGIN
DECLARE i INT DEFAULT 1;
DECLARE v_change_num INT;
DECLARE order_num_array_length INT;
DECLARE order_num_value TEXT;

    -- 트렌젝션 시작
    START TRANSACTION;
    
-- JSON 배열 길이 계산
SET order_num_array_length = JSON_LENGTH(v_order_num_json_array);

WHILE i <= order_num_array_length DO 
	SET order_num_value = JSON_UNQUOTE(JSON_EXTRACT(v_order_num_json_array , CONCAT('$[', i - 1, ']')));
	-- 주문 삭제 
	DELETE FROM orders 
	WHERE order_num = order_num_value;
    
    -- 변경된 행 체크 
    SET v_change_num = ROW_COUNT();
		IF v_change_num = 0 THEN 
				-- 오류 발생 시 롤백
					rollback;
		END IF;
	SET i = i + 1;
	END WHILE;
    -- 문제없을때
    COMMIT;

END//
DELIMITER ;

-- 프로시저 natureblend.deleteUpdate 구조 내보내기
DELIMITER //
CREATE PROCEDURE `deleteUpdate`(
IN v_product_lot_json_array TEXT
)
BEGIN
DECLARE product_lot_array_length INT;

DECLARE product_lot_value TEXT;


DECLARE i INT DEFAULT 1;
DECLARE v_change_num INT;

    -- 트렌젝션 시작
    START TRANSACTION;
SET product_lot_array_length = JSON_LENGTH(v_product_lot_json_array);

-- product_lot 길이 만큼 for문 돌아서 업데이트 작업 하기
	WHILE i <= product_lot_array_length DO
		SET product_lot_value  = JSON_UNQUOTE(JSON_EXTRACT(v_product_lot_json_array , CONCAT('$[', i - 1, ']')));

--  input_flag 업데이트 취소된 경우 1로 설정 
UPDATE input_body
SET input_flag = 1
WHERE product_lot = product_lot_value;

		SET v_change_num = ROW_COUNT();
		IF v_change_num = 0 THEN 
			-- 오류 발생 시 롤백
			rollback;
		END IF;
		SET i = i + 1;
	END WHILE;
    -- 문제없을때
    COMMIT;

    -- 문제있을때
    ROLLBACK;

END//
DELIMITER ;

-- 테이블 natureblend.employee 구조 내보내기
CREATE TABLE IF NOT EXISTS `employee` (
  `emp_num` bigint(20) NOT NULL DEFAULT 0,
  `name` varchar(20) NOT NULL,
  `birth` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `tel` varchar(30) NOT NULL,
  `job` varchar(15) NOT NULL,
  `job_num` int(20) NOT NULL,
  `position` varchar(15) NOT NULL DEFAULT '사원',
  `employment_date` datetime NOT NULL,
  `resignation_date` datetime DEFAULT NULL COMMENT 'sysdate+365',
  `level` int(11) DEFAULT NULL,
  PRIMARY KEY (`emp_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- 테이블 데이터 natureblend.employee:~15 rows (대략적) 내보내기
INSERT INTO `employee` (`emp_num`, `name`, `birth`, `tel`, `job`, `job_num`, `position`, `employment_date`, `resignation_date`, `level`) VALUES
	(20250001, '김다영', '1993-01-01 00:00:00', '010-2344-2344', '생산', 2, '반장', '2020-12-12 00:00:00', '2024-12-24 15:03:35', 2),
	(20250002, '권주리', '1999-12-03 00:00:00', '010-1234-5678', '영업', 1, '사원', '2024-12-14 00:00:00', '2024-12-24 00:00:00', 1),
	(20250003, '권미니', '1999-12-03 00:00:00', '010-1234-5678', '영업', 1, '사원', '2024-12-14 00:00:00', '2024-12-24 00:00:00', 1),
	(20250004, '이미주', '1999-12-03 00:00:00', '010-1234-5678', '영업', 1, '사원', '2024-12-14 00:00:00', '2024-12-24 00:00:00', 1),
	(20250005, '이옥자', '1999-05-23 00:00:00', '010-3463-8754', '품질', 4, '반장', '2024-12-14 00:00:00', '2029-12-14 00:00:00', 2),
	(20250006, '이설비', '1990-01-01 00:00:00', '010-1111-1111', '설비', 5, '사원', '2024-12-12 00:00:00', '2025-12-12 00:00:00', 1),
	(20250007, '김다영', '1993-03-04 00:00:00', '010-9999-9999', '생산', 2, '반장', '2024-12-12 00:00:00', '2099-09-09 00:00:00', 2),
	(20250008, '권나윤', '1994-12-04 00:00:00', '010-4512-4512', '영업', 1, '사원', '2025-01-02 00:00:00', '2026-01-02 00:00:00', 1),
	(20250009, '박사원', '1999-09-09 00:00:00', '010-2344-2344', '생산', 2, '사원', '2020-02-02 00:00:00', '2024-12-24 00:00:00', 1),
	(20250010, '나사원', '1999-09-05 00:00:00', '010-2343-2344', '생산', 2, '사원', '2019-02-02 00:00:00', '2025-04-24 15:03:24', 1),
	(20250011, '표하연', '1989-03-02 00:00:00', '010-1233-1233', '자재', 6, '관리자', '2020-02-02 00:00:00', '2024-12-24 15:03:34', 3),
	(20250012, '표자재', '1989-03-02 00:00:00', '010-1111-2222', '자재', 3, '사원', '2024-12-31 00:00:00', '2099-12-31 00:00:00', 1),
	(20250013, '표당근', '1989-03-02 00:00:00', '010-1111-2222', '자재', 3, '관리자', '2025-01-02 00:00:00', '2099-12-31 00:00:00', 3),
	(20250014, '관리자', '0001-01-01 00:00:00', '010-1111-9999', '관리자', 1, '관리자', '2025-01-01 00:00:00', '2025-01-03 00:00:00', 3),
	(20250015, '김대리', '2005-07-07 00:00:00', '010-7777-7777', '인사', 6, '대리', '2025-01-09 00:00:00', NULL, 1);

-- 테이블 natureblend.faulty_code 구조 내보내기
CREATE TABLE IF NOT EXISTS `faulty_code` (
  `faulty_code` varchar(30) NOT NULL,
  `faulty_reason` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`faulty_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- 테이블 데이터 natureblend.faulty_code:~13 rows (대략적) 내보내기
INSERT INTO `faulty_code` (`faulty_code`, `faulty_reason`) VALUES
	('FC000', '기타'),
	('FC001', '기타'),
	('FC002', '이물질 검출'),
	('FC003', '무름'),
	('FC004', '운송 중 손상'),
	('FC005', '기준치미달'),
	('FC006', '손상된포장'),
	('FC007', '불량'),
	('FC008', '세척제 잔류'),
	('FC009', '파손'),
	('FC010', '기타'),
	('FC078', '손상된포장'),
	('FC999', 'Ddd');

-- 프로시저 natureblend.getMaterialStock 구조 내보내기
DELIMITER //
CREATE PROCEDURE `getMaterialStock`(
	IN p_material_code_json_array TEXT
)
BEGIN
	DECLARE i INT DEFAULT 1;
	DECLARE material_code_array_length INT;
	DECLARE material_code_value TEXT;

	-- 기존 테이블 삭제 및 새로 생성
	DROP TEMPORARY TABLE IF EXISTS temp_result;

	-- 임시 테이블 생성
	CREATE TEMPORARY TABLE IF NOT EXISTS temp_result (
		material_code VARCHAR(50),
        lot_seq int,
        material_name VARCHAR(50),
		lot_code VARCHAR(50),
		stok_qty INT,
		limit_date DATE,
        invalid_qty int
	);

	START TRANSACTION;

	SET material_code_array_length = JSON_LENGTH(p_material_code_json_array);
	
    WHILE i <= material_code_array_length DO
		SET material_code_value = JSON_UNQUOTE(JSON_EXTRACT(p_material_code_json_array, CONCAT('$[', i - 1, ']')));
	
		-- 결과값을 임시 테이블에 삽입
		INSERT INTO temp_result (lot_seq, material_code, material_name, lot_code, stok_qty, limit_date, invalid_qty)
		select 
			m1.lot_seq,
			m1.material_code, 
			m2.material_name, 
            m1.lot_code, 
            stok_qty, 
            limit_date,
			(select sum(material_qty)
				from invalid_material i
				where m1.lot_seq = i.lot_seq) as invalid_qty
		from material_lot_qty1 m1 inner join material m2
        on m1.material_code = m2.material_code
		where material_nomal = 'b1' 
			and material_lot_state = 'c1'
			and m1.material_code = material_code_value;

		SET i = i + 1;
	END WHILE;

	select lot_seq, material_code, material_name, lot_code, stok_qty, limit_date, invalid_qty from temp_result;
    commit;
END//
DELIMITER ;

-- 프로시저 natureblend.get_stock 구조 내보내기
DELIMITER //
CREATE PROCEDURE `get_stock`(IN p_product_code VARCHAR(10))
BEGIN
    DECLARE r_stock INT DEFAULT 0;
    DECLARE v_product_code VARCHAR(10);
    DECLARE v_input_amount INT;
    DECLARE v_input_flag TINYINT;
    DECLARE v_dispose_flag TINYINT;
    DECLARE done INT DEFAULT 0;

    -- 커서 정의
    DECLARE stock_cursor CURSOR FOR 
        SELECT
            product_code,
            input_amount,
            input_flag,
            dispose_flag
        FROM input_body
        WHERE product_code = p_product_code;

    -- 핸들러 정의
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- 커서 열기
    OPEN stock_cursor;

    -- 커서 순회
    stock_loop: LOOP
        FETCH stock_cursor INTO v_product_code, v_input_amount, v_input_flag, v_dispose_flag;
        IF done THEN
            LEAVE stock_loop;
        END IF;

        -- 조건 확인 후 누적합산
        IF v_input_flag = 0 AND v_dispose_flag = 0 THEN
            SET r_stock = r_stock + v_input_amount;
        END IF;
    END LOOP stock_loop;

    -- 커서 닫기
    CLOSE stock_cursor;

    -- 결과 반환
    SELECT r_stock AS stock;
END//
DELIMITER ;

-- 테이블 natureblend.inactivity 구조 내보내기
CREATE TABLE IF NOT EXISTS `inactivity` (
  `inact_num` bigint(20) NOT NULL AUTO_INCREMENT,
  `inact_start_time` datetime NOT NULL,
  `inact_end_time` datetime DEFAULT NULL,
  `inact_type` varchar(20) NOT NULL COMMENT '점검(check) / 고장(trouble) / 휴식(rest) / 기타(other)',
  `inact_info` varchar(1000) DEFAULT NULL,
  `machine_num` bigint(20) NOT NULL COMMENT 'auto_increment',
  `inact_start_emp` bigint(20) NOT NULL,
  `inact_end_emp` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`inact_num`)
) ENGINE=InnoDB AUTO_INCREMENT=189 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- 테이블 데이터 natureblend.inactivity:~19 rows (대략적) 내보내기
INSERT INTO `inactivity` (`inact_num`, `inact_start_time`, `inact_end_time`, `inact_type`, `inact_info`, `machine_num`, `inact_start_emp`, `inact_end_emp`) VALUES
	(170, '2025-01-07 15:21:50', '2025-01-07 15:21:59', '점검', '', 82, 20250014, 20250014),
	(171, '2025-01-07 16:31:05', '2025-01-07 16:31:29', '고장', '', 83, 20250014, 20250014),
	(172, '2025-01-07 16:31:08', '2025-01-07 16:31:29', '휴식', '', 84, 20250014, 20250014),
	(173, '2025-01-07 16:31:11', '2025-01-07 16:31:28', '고장', '', 86, 20250014, 20250014),
	(174, '2025-01-07 16:31:14', '2025-01-07 16:31:27', '기타', '점검요청', 87, 20250014, 20250014),
	(175, '2025-01-08 10:53:54', '2025-01-08 17:01:39', '점검', '', 83, 20250014, 20250014),
	(176, '2025-01-08 10:54:04', '2025-01-08 16:57:19', '고장', '', 86, 20250014, 20250014),
	(177, '2025-01-08 10:54:07', '2025-01-08 17:01:38', '휴식', '', 88, 20250014, 20250014),
	(178, '2025-01-08 16:57:07', '2025-01-08 16:57:17', '점검', '', 82, 20250014, 20250014),
	(179, '2025-01-08 17:01:20', '2025-01-08 17:01:40', '기타', 'ㅁㅁㅁ', 82, 20250014, 20250014),
	(180, '2025-01-08 17:01:43', '2025-01-08 17:01:45', '점검', '', 84, 20250014, 20250014),
	(181, '2025-01-08 17:02:07', '2025-01-08 17:44:15', '점검', '', 83, 20250014, 20250014),
	(182, '2025-01-08 17:02:10', '2025-01-08 17:41:52', '휴식', '', 85, 20250014, 20250014),
	(183, '2025-01-08 17:02:13', NULL, '휴식', '', 87, 20250014, NULL),
	(184, '2025-01-08 17:41:20', '2025-01-08 17:41:44', '점검', '', 82, 20250014, 20250014),
	(185, '2025-01-08 17:43:46', '2025-01-08 17:44:09', '기타', 'ㅁㅁㅁ', 82, 20250014, 20250014),
	(186, '2025-01-08 17:44:47', '2025-01-08 17:49:17', '점검', '', 84, 20250014, 20250014),
	(187, '2025-01-08 17:44:50', '2025-01-08 17:49:23', '점검', '', 89, 20250014, 20250014),
	(188, '2025-01-08 17:48:33', '2025-01-08 17:49:05', '기타', 'asdf', 82, 20250014, 20250014);

-- 프로시저 natureblend.inputProduct 구조 내보내기
DELIMITER //
CREATE PROCEDURE `inputProduct`(
IN v_product_code_json_array TEXT,
IN v_process_num_json_array TEXT,
IN v_input_amount_json_array TEXT,
IN v_qc_packing_id_json_array TEXT,
IN v_inspect_end_json_array TEXT,
IN v_warehouse_code_json_array TEXT,

IN v_emp_num int
)
BEGIN
-- DECLARE v_emp_num INT; 
DECLARE v_expiration_date_array TEXT;

DECLARE v_change_num INT;
DECLARE v_result_value INT;
DECLARE v_last_num INT;
DECLARE i INT DEFAULT 1;

DECLARE qc_packing_id_array_length INT;

DECLARE qc_packing_id_value TEXT;
DECLARE product_code_value TEXT;
DECLARE process_num_value TEXT;
DECLARE input_amount_value TEXT;
DECLARE inspect_end_value TEXT;
DECLARE warehouse_code_value TEXT;

DECLARE expiration_date_value TEXT;

    -- 트렌젝션 시작
    START TRANSACTION;
-- 사원번호 (사원이름)
-- SELECT emp_num
-- INTO v_emp_num
-- FROM employee
-- WHERE name = v_emp_name
-- LIMIT 1;

-- 입고 헤더 추가 input_header
INSERT INTO input_header (emp_num)
VALUES (v_emp_num);

-- 입고헤더 등록 후 변화한 값 
SET v_change_num = ROW_COUNT();

SELECT v_change_num;

	IF v_change_num = 1 THEN 
		-- 마지막 입고헤더 번호 가져오기
		SELECT inputlist_num
		INTO v_last_num
		FROM input_header
		ORDER BY inputlist_num desc
		limit 1;

		SET qc_packing_id_array_length = JSON_LENGTH(v_qc_packing_id_json_array);
		WHILE i <= qc_packing_id_array_length DO
			SET product_code_value = JSON_UNQUOTE(JSON_EXTRACT(v_product_code_json_array, CONCAT('$[', i - 1, ']')));
			SET process_num_value = JSON_UNQUOTE(JSON_EXTRACT(v_process_num_json_array, CONCAT('$[', i - 1, ']')));
			SET input_amount_value = JSON_UNQUOTE(JSON_EXTRACT(v_input_amount_json_array, CONCAT('$[', i - 1, ']')));
			SET qc_packing_id_value = JSON_UNQUOTE(JSON_EXTRACT(v_qc_packing_id_json_array, CONCAT('$[', i - 1, ']')));
			SET inspect_end_value = JSON_UNQUOTE(JSON_EXTRACT(v_inspect_end_json_array, CONCAT('$[', i - 1, ']')));
            SET warehouse_code_value = JSON_UNQUOTE(JSON_EXTRACT(v_warehouse_code_json_array, CONCAT('$[', i - 1, ']')));

		-- 각 product 의 expiration_date 구하기 
		SELECT expiration_date
		INTO expiration_date_value
		FROM product
		WHERE product_code = product_code_value
		LIMIT 1;
        
        -- 입고테이블(input_body) 등록
        INSERT INTO input_body
						(product_code
                        ,product_lot
                        ,input_amount
                        ,warehouse_code
                        ,qc_packing_id
                        ,expire_date
                        ,inputlist_num)
		VALUES (product_code_value
				,CONCAT(product_code_value,DATE_FORMAT(inspect_end_value,'%d%m%y'),process_num_value)
                ,input_amount_value
                , warehouse_code_value
                , qc_packing_id_value
                ,ADDDATE(inspect_end_value,expiration_date_value)
                ,v_last_num );
                
				SET v_result_value = ROW_COUNT();
					IF v_result_value != 1 THEN 
						-- 오류 발생 시 롤백
						rollback;
					END IF;
				SET i = i + 1;
		END WHILE;
		-- 문제없을때
		COMMIT;
		ELSE
		-- 입고 등록 실패 시 롤백
			ROLLBACK;
   END IF;
END//
DELIMITER ;

-- 프로시저 natureblend.inputUpdate 구조 내보내기
DELIMITER //
CREATE PROCEDURE `inputUpdate`(
IN v_product_lot_json_array TEXT,
IN v_warehouse_name_json_array TEXT 
)
BEGIN
DECLARE product_lot_array_length INT;

DECLARE product_lot_value TEXT;
DECLARE warehouse_name_value TEXT;


DECLARE warehouse_code_value TEXT;

DECLARE i INT DEFAULT 1;
DECLARE v_change_num INT;

    -- 트렌젝션 시작
    START TRANSACTION;
SET product_lot_array_length = JSON_LENGTH(v_product_lot_json_array);

-- product_lot 길이 만큼 for문 돌아서 업데이트 작업 하기
	WHILE i <= product_lot_array_length DO
		SET product_lot_value  = JSON_UNQUOTE(JSON_EXTRACT(v_product_lot_json_array , CONCAT('$[', i - 1, ']')));
		SET warehouse_name_value   = JSON_UNQUOTE(JSON_EXTRACT(v_warehouse_name_json_array  , CONCAT('$[', i - 1, ']')));
        
-- 창고이름으로 창고 번호 가져오기 
SELECT warehouse_code
INTO warehouse_code_value
FROM warehouse
WHERE warehouse_name = warehouse_name_value
LIMIT 1;

-- 창고코드 업데이트 
UPDATE input_body
SET warehouse_code = warehouse_code_value
WHERE product_lot = product_lot_value;

		SET v_change_num = ROW_COUNT();
		IF v_change_num = 0 THEN 
			-- 오류 발생 시 롤백
			rollback;
		END IF;
		SET i = i + 1;
	END WHILE;
    -- 문제없을때
    COMMIT;

    -- 문제있을때
    ROLLBACK;

END//
DELIMITER ;

-- 테이블 natureblend.input_body 구조 내보내기
CREATE TABLE IF NOT EXISTS `input_body` (
  `input_num` int(11) NOT NULL AUTO_INCREMENT,
  `product_code` varchar(30) NOT NULL,
  `product_lot` varchar(20) NOT NULL COMMENT '제품코드 + 생산일 + 생산월(1-9월, 10월: X, 11월:Y, 12월: Z) + 생산연도 + 생산공정코드',
  `input_amount` int(11) NOT NULL COMMENT '품질검사 합격량',
  `input_flag` int(11) NOT NULL DEFAULT 0 COMMENT '0:취소안됨, 1: 취소됨',
  `warehouse_code` varchar(30) NOT NULL,
  `qc_packing_id` varchar(30) NOT NULL,
  `expire_date` datetime NOT NULL COMMENT '품질검사시행날자(제조일자) + 유통기한(제품의 유통  기한 e.g 180일)',
  `dispose_flag` int(11) NOT NULL DEFAULT 0 COMMENT '0: 재고 유지 1: 폐기처리',
  `inputlist_num` int(11) NOT NULL,
  PRIMARY KEY (`input_num`)
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- 테이블 데이터 natureblend.input_body:~5 rows (대략적) 내보내기
INSERT INTO `input_body` (`input_num`, `product_code`, `product_lot`, `input_amount`, `input_flag`, `warehouse_code`, `qc_packing_id`, `expire_date`, `dispose_flag`, `inputlist_num`) VALUES
	(39, 'P005', 'P005070125144', 240, 0, 'W005', 'QCPP2501070001', '2026-01-07 00:00:00', 0, 33),
	(40, 'P005', 'P005070125145', 10, 0, 'W005', 'QCPP2501070002', '2026-01-07 00:00:00', 0, 34),
	(41, 'P001', 'P001070125148', 250, 0, 'W004', 'QCPP2501070003', '2026-01-07 00:00:00', 0, 35),
	(42, 'P004', 'P004080125171', 150, 0, 'W004', 'QCPP2501080001', '2026-01-08 00:00:00', 0, 36),
	(46, 'P016', 'P016070125164', 15, 0, 'W004', 'QCPP2501070005', '2026-01-07 00:00:00', 0, 40);

-- 테이블 natureblend.input_header 구조 내보내기
CREATE TABLE IF NOT EXISTS `input_header` (
  `inputlist_num` int(11) NOT NULL AUTO_INCREMENT,
  `emp_num` int(11) NOT NULL,
  `input_date` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`inputlist_num`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- 테이블 데이터 natureblend.input_header:~5 rows (대략적) 내보내기
INSERT INTO `input_header` (`inputlist_num`, `emp_num`, `input_date`) VALUES
	(33, 20250014, '2025-01-07 14:09:33'),
	(34, 20250014, '2025-01-07 14:22:20'),
	(35, 20250014, '2025-01-07 14:53:31'),
	(36, 20250014, '2025-01-08 10:48:50'),
	(40, 20250008, '2025-01-08 17:41:16');

-- 테이블 natureblend.invalid_material 구조 내보내기
CREATE TABLE IF NOT EXISTS `invalid_material` (
  `invalid_material_num` int(11) NOT NULL AUTO_INCREMENT,
  `production_order_num` int(11) NOT NULL,
  `material_code` varchar(20) NOT NULL,
  `lot_code` varchar(50) NOT NULL,
  `material_qty` int(11) DEFAULT NULL,
  `is_out` varchar(5) NOT NULL DEFAULT '0' COMMENT 'false / true',
  `out_date` datetime DEFAULT NULL,
  `lot_seq` int(11) DEFAULT NULL,
  PRIMARY KEY (`invalid_material_num`)
) ENGINE=InnoDB AUTO_INCREMENT=203 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- 테이블 데이터 natureblend.invalid_material:~83 rows (대략적) 내보내기
INSERT INTO `invalid_material` (`invalid_material_num`, `production_order_num`, `material_code`, `lot_code`, `material_qty`, `is_out`, `out_date`, `lot_seq`) VALUES
	(107, 43, 'M002', 'M00207125002', 165000, '1', '2025-01-07 13:11:09', 192),
	(108, 43, 'M007', 'M00707125004', 9500, '1', '2025-01-07 13:11:09', 196),
	(109, 43, 'M008', 'M00807125005', 2000, '1', '2025-01-07 13:11:09', 198),
	(110, 43, 'M009', 'M00907125006', 7500, '1', '2025-01-07 13:11:09', 200),
	(111, 43, 'M010', 'M01026Z24002', 56250, '1', '2025-01-07 13:11:09', 112),
	(112, 43, 'M012', 'M01207125001', 250, '1', '2025-01-07 13:11:09', 190),
	(113, 44, 'M007', 'M00707125004', 250, '1', '2025-01-07 14:39:46', 196),
	(114, 44, 'M008', 'M00807125005', 250, '1', '2025-01-07 14:39:46', 198),
	(115, 44, 'M009', 'M00907125006', 250, '1', '2025-01-07 14:39:46', 200),
	(116, 44, 'M010', 'M01026Z24002', 250, '1', '2025-01-07 14:39:46', 112),
	(117, 44, 'M011', 'M01107125007', 250, '1', '2025-01-07 14:39:46', 202),
	(118, 45, 'M003', 'M00307125019', 80000, '0', NULL, 226),
	(119, 45, 'M007', 'M00707125004', 3000, '0', NULL, 196),
	(120, 45, 'M008', 'M00807125005', 500, '0', NULL, 198),
	(121, 45, 'M009', 'M00907125006', 1500, '0', NULL, 200),
	(122, 45, 'M010', 'M01026Z24002', 10000, '0', NULL, 112),
	(123, 45, 'M011', 'M01107125014', 100, '0', NULL, 216),
	(124, 46, 'M004', 'M00407125020', 84700, '0', NULL, 228),
	(125, 46, 'M007', 'M00707125004', 7500, '0', NULL, 196),
	(126, 46, 'M010', 'M01026Z24002', 25000, '0', NULL, 112),
	(127, 46, 'M009', 'M00907125006', 300, '0', NULL, 200),
	(128, 46, 'M008', 'M00807125005', 300, '0', NULL, 198),
	(129, 46, 'M011', 'M01107125014', 100, '0', NULL, 216),
	(130, 47, 'M003', 'M00307125019', 120000, '0', NULL, 226),
	(131, 47, 'M007', 'M00707125023', 4500, '0', NULL, 234),
	(132, 47, 'M008', 'M00807125022', 750, '0', NULL, 232),
	(133, 47, 'M009', 'M00907125012', 2250, '0', NULL, 212),
	(134, 47, 'M010', 'M01026Z24002', 15000, '0', NULL, 112),
	(135, 47, 'M011', 'M01107125014', 150, '0', NULL, 216),
	(149, 51, 'M006', 'M00607125016', 87750, '0', NULL, 220),
	(150, 51, 'M007', 'M00707125023', 5250, '0', NULL, 234),
	(151, 51, 'M008', 'M00807125022', 1500, '0', NULL, 232),
	(152, 51, 'M009', 'M00907125012', 750, '0', NULL, 212),
	(153, 51, 'M010', 'M01026Z24002', 22500, '0', NULL, 112),
	(154, 51, 'M011', 'M01107125014', 150, '0', NULL, 216),
	(155, 52, 'M003', 'M00307125019', 120000, '0', NULL, 226),
	(156, 52, 'M007', 'M00707125004', 4500, '0', NULL, 196),
	(157, 52, 'M008', 'M00807125005', 750, '0', NULL, 198),
	(158, 52, 'M009', 'M00907125006', 2250, '0', NULL, 200),
	(159, 52, 'M010', 'M01026Z24002', 15000, '0', NULL, 112),
	(160, 52, 'M011', 'M01107125014', 150, '0', NULL, 216),
	(161, 53, 'M003', 'M00307125019', 80000, '0', NULL, 226),
	(162, 53, 'M008', 'M00807125005', 500, '0', NULL, 198),
	(163, 53, 'M009', 'M00907125006', 1500, '0', NULL, 200),
	(164, 53, 'M010', 'M01026Z24002', 10000, '0', NULL, 112),
	(165, 53, 'M011', 'M01107125014', 100, '0', NULL, 216),
	(166, 53, 'M007', 'M00707125023', 3000, '0', NULL, 234),
	(167, 54, 'M002', 'M00207125018', 66000, '1', '2025-01-08 10:48:15', 224),
	(168, 54, 'M007', 'M00707125004', 3750, '1', '2025-01-08 10:48:15', 196),
	(169, 54, 'M008', 'M00807125005', 750, '1', '2025-01-08 10:48:15', 198),
	(170, 54, 'M009', 'M00907125012', 3000, '1', '2025-01-08 10:48:15', 212),
	(171, 54, 'M010', 'M01026Z24002', 22500, '1', '2025-01-08 10:48:15', 112),
	(172, 54, 'M011', 'M01107125014', 150, '1', '2025-01-08 10:48:16', 216),
	(173, 55, 'M010', 'M01026Z24002', 75000, '0', NULL, 112),
	(174, 55, 'M005', 'M00507125021', 55750, '0', NULL, 230),
	(175, 55, 'M007', 'M00707125023', 18750, '0', NULL, 234),
	(176, 55, 'M009', 'M00907125012', 1500, '0', NULL, 212),
	(177, 55, 'M008', 'M00807125005', 1500, '0', NULL, 198),
	(178, 55, 'M011', 'M01107125014', 250, '0', NULL, 216),
	(179, 56, 'M001', 'M00107125017', 42500, '0', NULL, 222),
	(180, 56, 'M007', 'M00707125023', 27500, '0', NULL, 234),
	(181, 56, 'M008', 'M00807125022', 2500, '0', NULL, 232),
	(182, 56, 'M009', 'M00907125012', 2500, '0', NULL, 212),
	(183, 57, 'M001', 'M00107125017', 19200, '0', NULL, 222),
	(184, 57, 'M007', 'M00707125023', 124500, '0', NULL, 234),
	(185, 57, 'M008', 'M00807125022', 1200, '0', NULL, 232),
	(186, 57, 'M010', 'M01026Z24002', 78750, '0', NULL, 112),
	(187, 57, 'M009', 'M00907125012', 1200, '0', NULL, 212),
	(188, 58, 'M002', 'M00207125018', 66000, '0', NULL, 224),
	(189, 58, 'M007', 'M00707125023', 3750, '0', NULL, 234),
	(190, 58, 'M008', 'M00807125022', 750, '0', NULL, 232),
	(191, 58, 'M009', 'M00907125012', 3000, '0', NULL, 212),
	(192, 58, 'M010', 'M01026Z24002', 22500, '0', NULL, 112),
	(193, 59, 'M002', 'M00207125018', 264000, '0', NULL, 224),
	(194, 59, 'M008', 'M00807125022', 3000, '0', NULL, 232),
	(195, 59, 'M007', 'M00707125023', 15000, '0', NULL, 234),
	(196, 59, 'M007', 'M00708125002', 12000, '0', NULL, 238),
	(197, 59, 'M010', 'M01026Z24002', 90000, '0', NULL, 112),
	(198, 60, 'M006', 'M00607125016', 87750, '0', NULL, 220),
	(199, 60, 'M007', 'M00707125023', 5250, '0', NULL, 234),
	(200, 60, 'M008', 'M00807125022', 1500, '0', NULL, 232),
	(201, 60, 'M009', 'M00907125012', 750, '0', NULL, 212),
	(202, 60, 'M010', 'M01026Z24002', 22500, '0', NULL, 112);

-- 테이블 natureblend.machine 구조 내보내기
CREATE TABLE IF NOT EXISTS `machine` (
  `machine_num` bigint(20) NOT NULL AUTO_INCREMENT,
  `machine_name` varchar(20) NOT NULL,
  `machine_img` varchar(1000) DEFAULT NULL,
  `model_num` varchar(20) NOT NULL,
  `machine_location` varchar(20) NOT NULL,
  `machine_state` varchar(20) DEFAULT 'run' COMMENT '작동중(run) / 작동정지(stop)',
  `uph` bigint(20) NOT NULL,
  `upd` bigint(20) NOT NULL COMMENT '시간 생산량 입력시 계산하여 저장',
  `buy_date` datetime DEFAULT current_timestamp(),
  `install_date` datetime DEFAULT current_timestamp(),
  `part_cnt` bigint(20) DEFAULT NULL,
  `emp_num` bigint(20) NOT NULL COMMENT '기준정보 사원(등록자)',
  `client_num` bigint(20) NOT NULL COMMENT '기준정보 거래처(제작사)',
  `process_code` varchar(100) NOT NULL COMMENT '기준정보 공정정보(설비 분류, 공정 분류)',
  PRIMARY KEY (`machine_num`)
) ENGINE=InnoDB AUTO_INCREMENT=119 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- 테이블 데이터 natureblend.machine:~11 rows (대략적) 내보내기
INSERT INTO `machine` (`machine_num`, `machine_name`, `machine_img`, `model_num`, `machine_location`, `machine_state`, `uph`, `upd`, `buy_date`, `install_date`, `part_cnt`, `emp_num`, `client_num`, `process_code`) VALUES
	(82, '자동 세병기 1.5', '/images/1736235126883세척기.webp', 'BW-1700', '1공장 A3', 'run', 180, 4320, '2025-01-07 12:36:39', '2025-01-07 12:39:35', NULL, 20250014, 28, 'p1'),
	(83, '믹서 당근이세요 1.5', '/images/1736235135978제작기1.avif', 'JM-1100', '1공장 A6', 'run', 100000, 2400000, '2025-01-07 12:43:14', '2025-01-07 12:43:49', NULL, 20250014, 26, 'p2'),
	(84, '라벨기 당근이세요 1.5', '/images/1736235144131포장기1.avif', 'BP-3400', '1공장 A10', 'run', 50, 1200, '2025-01-07 12:45:01', '2025-01-07 12:45:44', NULL, 20250014, 29, 'p3'),
	(85, '자동 세병기 750', '/images/1736235214532세병기2.jpg', 'BW-1500', '1공장 D3', 'run', 250, 6000, '2025-01-07 12:49:48', '2025-01-07 12:50:42', NULL, 20250014, 28, 'p1'),
	(86, '믹서 당근이세요 750', '/images/1736235223318제작기1.avif', 'JM-1100', '1공장 D6', 'run', 100000, 2400000, '2025-01-07 14:13:49', '2025-01-07 14:14:48', NULL, 20250014, 26, 'p2'),
	(87, '라벨기 당근이세요 750', '', 'BP-3300', 'D10', 'stop', 50, 1200, '2025-01-07 14:14:49', '2025-01-07 14:16:05', NULL, 20250014, 29, 'p3'),
	(88, '공용 세병기 1.5', '', 'BW-2000', '2공장 B3', 'run', 200, 4800, '2025-01-07 14:16:32', '2025-01-07 14:17:32', NULL, 20250014, 29, 'p1'),
	(89, '공용 믹서', '/images/1736235234284제작기2.webp', 'JM-2100', '2공장 B6', 'run', 200000, 4800000, '2025-01-07 14:17:37', '2025-01-07 14:18:31', NULL, 20250014, 29, 'p2'),
	(90, '공용 패킹', '', 'BP-4000', '2공장 B10', 'run', 150, 3600, '2025-01-07 14:18:33', '2025-01-07 14:20:21', NULL, 20250014, 29, 'p3'),
	(112, '혼합_병_세척기_001', '/images/1736231837607세척기.webp', 'GPBW-120', '3공장 C5', 'run', 100, 2400, '2025-01-07 15:37:05', '2025-01-07 15:37:52', NULL, 20250014, 28, 'p1'),
	(118, '등록시연1', '/images/1736326072150세척기.webp', 'U1', '111', 'run', 111, 2664, '2025-01-08 17:47:43', '2025-01-08 17:48:04', NULL, 20250014, 26, 'p1');

-- 테이블 natureblend.machine_part 구조 내보내기
CREATE TABLE IF NOT EXISTS `machine_part` (
  `part_num` bigint(20) NOT NULL AUTO_INCREMENT,
  `part_name` varchar(20) NOT NULL,
  `replace_date` datetime DEFAULT NULL,
  `replace_cycle` bigint(20) NOT NULL DEFAULT 0 COMMENT '년/월/일 값을 받아서 교체일 계산',
  `part_location` varchar(20) NOT NULL,
  `buy_date` datetime NOT NULL DEFAULT current_timestamp(),
  `machine_type` varchar(20) NOT NULL COMMENT '기준정보의 설비 분류 목록',
  `machine_num` bigint(20) DEFAULT NULL,
  `client_num` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`part_num`)
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- 테이블 데이터 natureblend.machine_part:~22 rows (대략적) 내보내기
INSERT INTO `machine_part` (`part_num`, `part_name`, `replace_date`, `replace_cycle`, `part_location`, `buy_date`, `machine_type`, `machine_num`, `client_num`) VALUES
	(58, '1', '2025-01-07 14:45:39', 396, '11', '2025-01-07 14:45:39', 'p1', 93, 26),
	(59, '1', '2025-01-07 14:52:05', 31, '1', '2025-01-07 14:52:05', 'p1', 96, 26),
	(60, '1', '2025-01-07 15:04:48', 396, '11', '2025-01-07 15:04:48', 'p1', 99, 26),
	(61, '1', '2025-01-07 15:07:37', 30, '1', '2025-01-07 15:07:37', 'p1', 101, 28),
	(62, '11', '2025-01-07 15:13:34', 396, '11', '2025-01-07 15:13:34', 'p1', 103, 28),
	(63, '1', '2025-01-07 15:19:17', 396, '1', '2025-01-07 15:19:17', 'p1', 105, 28),
	(64, '1', '2025-01-07 15:19:28', 396, '2', '2025-01-07 15:19:28', 'p2', 106, 26),
	(65, '1', '2025-01-07 15:22:53', 31, '1', '2025-01-07 15:22:53', 'p1', 110, 28),
	(66, '2', '2025-01-07 15:24:13', 60, '2', '2025-01-07 15:24:13', 'p2', 111, 26),
	(68, '클리너200', '2025-01-08 17:41:13', 120, '설비 창고1', '2025-01-07 00:00:00', 'p1', 115, 28),
	(69, '클리너200', '2025-01-07 16:28:50', 120, '설비 창고1', '2025-01-08 00:00:00', 'p1', 112, 28),
	(70, '클리너150', '2025-01-08 16:56:45', 90, '설비 창고1', '2025-01-07 00:00:00', 'p1', 113, 28),
	(71, '클리너100', '2025-01-08 17:43:37', 60, '설비 창고1', '2025-01-07 00:00:00', 'p1', 116, 28),
	(72, '클리너100', NULL, 60, '설비 창고 1', '2025-01-01 00:00:00', 'p1 / p3', NULL, 28),
	(73, '글라인더', NULL, 1600, '설비 창고 1', '2025-01-01 00:00:00', 'p2', NULL, 28),
	(74, '글라인더', NULL, 1600, '설비 창고 1', '2025-01-03 00:00:00', 'p2', NULL, 26),
	(76, '부품시연1', '2025-01-08 17:00:07', 365, '창고1', '2025-01-08 17:00:07', 'p1', 114, 28),
	(79, '클리너200', '2025-01-08 17:48:23', 200, '설비 창고1', '2025-01-01 00:00:00', 'p1', 118, 28),
	(80, '클리너200', NULL, 200, '설비 창고1', '2025-01-03 00:00:00', 'p1', NULL, 28),
	(81, '클리너150', NULL, 150, '설비 창고1', '2025-01-06 00:00:00', 'p1', NULL, 28),
	(82, '222', '2025-01-08 17:46:47', 365, 'A1', '2025-01-08 17:46:47', 'p1', 117, 26),
	(83, '222', '2025-01-08 17:46:47', 365, 'A1', '2025-01-08 17:46:47', 'p1', 117, 26);

-- 테이블 natureblend.maintenance 구조 내보내기
CREATE TABLE IF NOT EXISTS `maintenance` (
  `maintenance_num` bigint(20) NOT NULL AUTO_INCREMENT,
  `request_date` datetime DEFAULT current_timestamp(),
  `request` varchar(200) DEFAULT NULL,
  `request_emp` bigint(20) NOT NULL COMMENT '기준정보 사원(정비 요청자)',
  `work_emp` bigint(20) DEFAULT NULL COMMENT '기준정보 사원(작업자)',
  `maintenance_detail` varchar(200) DEFAULT NULL,
  `maintenance_state` varchar(20) NOT NULL DEFAULT 'wait' COMMENT '정비 요청(wait) / 정비 완료(done)',
  `end_date` datetime DEFAULT NULL,
  `machine_num` bigint(20) NOT NULL COMMENT 'auto_increment',
  PRIMARY KEY (`maintenance_num`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- 테이블 데이터 natureblend.maintenance:~9 rows (대략적) 내보내기
INSERT INTO `maintenance` (`maintenance_num`, `request_date`, `request`, `request_emp`, `work_emp`, `maintenance_detail`, `maintenance_state`, `end_date`, `machine_num`) VALUES
	(41, '2025-01-08 00:00:00', '점검요청', 20250014, 20250014, '전검 완료', 'done', '2025-01-08 11:55:38', 82),
	(42, '2025-01-08 00:30:00', '점검요청', 20250014, 20250014, '전검 완료', 'done', '2025-01-08 11:55:46', 83),
	(43, '2025-01-01 16:30:00', '고장', 20250014, 20250014, '설비 재시작 완료', 'done', '2025-01-07 16:30:43', 112),
	(44, '2025-01-07 11:53:00', '부품 수리', 20250014, 20250014, '부품 수리 완료', 'done', '2025-01-08 11:55:26', 85),
	(45, '2025-01-02 11:53:00', '고장 확인', 20250014, 20250014, '점검 완료 / 이상 없음', 'done', '2025-01-08 11:54:49', 87),
	(46, '2025-01-03 11:54:00', '불량률 이상', 20250014, 20250014, '부품 이상 확인 / 부품 교체 완료', 'done', '2025-01-08 11:55:13', 112),
	(47, '2025-01-09 11:55:00', '점검 요청', 20250014, NULL, NULL, 'wait', NULL, 82),
	(48, '2025-01-09 11:56:00', '점검 요청', 20250014, NULL, NULL, 'wait', NULL, 83),
	(49, '2025-01-09 11:56:00', '점검 요청', 20250014, NULL, NULL, 'wait', NULL, 84);

-- 테이블 natureblend.material 구조 내보내기
CREATE TABLE IF NOT EXISTS `material` (
  `material_code` varchar(30) NOT NULL,
  `material_name` varchar(30) NOT NULL,
  `safety_inventory` int(20) NOT NULL,
  `expiration_date` int(10) NOT NULL,
  `regi_date` datetime DEFAULT NULL,
  PRIMARY KEY (`material_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- 테이블 데이터 natureblend.material:~14 rows (대략적) 내보내기
INSERT INTO `material` (`material_code`, `material_name`, `safety_inventory`, `expiration_date`, `regi_date`) VALUES
	('M001', '포도', 100000, 730, '2024-12-26 09:59:39'),
	('M002', '사과', 100000, 730, '2024-12-26 10:00:14'),
	('M003', '오렌지', 100000, 730, '2024-12-26 10:00:27'),
	('M004', '레몬', 100000, 730, '2024-12-26 10:01:25'),
	('M005', '망고', 100000, 730, '2024-12-26 10:01:41'),
	('M006', '당근', 100000, 730, '2024-12-26 10:01:57'),
	('M007', '설탕', 1000000, 730, '2024-12-26 10:02:20'),
	('M008', '식용색소', 10000, 730, '2024-12-26 10:02:33'),
	('M009', '향료', 10000, 730, '2024-12-26 10:02:51'),
	('M010', '정수물', 0, 999999, '2024-12-26 10:03:15'),
	('M011', '페트병 (500ml)', 10000, 730, '2024-12-26 10:54:59'),
	('M012', '페트병 (750ml)', 10000, 730, '2024-12-26 10:55:12'),
	('M013', '페트병 (1.5L)', 10000, 730, '2024-12-26 10:55:25'),
	('M014', '복숭아', 0, 14, '2025-01-08 21:01:33');

-- 테이블 natureblend.material_discard 구조 내보내기
CREATE TABLE IF NOT EXISTS `material_discard` (
  `material_dis_num` int(11) NOT NULL AUTO_INCREMENT COMMENT '폐기번호',
  `lot_seq` int(11) NOT NULL COMMENT 'LOT번호 기본키',
  `material_dis_content` varchar(200) NOT NULL COMMENT '폐기사유 입력 ( 텍스트 )',
  `count` int(11) NOT NULL DEFAULT 0 COMMENT '폐기재고가 그램단위, 미리리터 단위가 발생',
  `emp_num` int(11) NOT NULL COMMENT '자재폐기 처리한 담당자',
  PRIMARY KEY (`material_dis_num`,`lot_seq`),
  KEY `FK_material_discard_natureblend.material_lot_qty1` (`lot_seq`),
  CONSTRAINT `FK_material_discard_natureblend.material_lot_qty1` FOREIGN KEY (`lot_seq`) REFERENCES `material_lot_qty1` (`lot_seq`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- 테이블 데이터 natureblend.material_discard:~9 rows (대략적) 내보내기
INSERT INTO `material_discard` (`material_dis_num`, `lot_seq`, `material_dis_content`, `count`, `emp_num`) VALUES
	(21, 193, '불량 자재 검수 후 폐기', 16000, 20250014),
	(22, 191, '불량 자재 검수 후 폐기', 50, 20250014),
	(23, 210, '이슈발생으로 인한 리콜', 150000, 20250014),
	(24, 208, '이슈발생으로 인한 리콜', 100000, 20250014),
	(25, 206, '이슈발생으로 인한 리콜', 10000, 20250014),
	(26, 204, '이슈발생으로 인한 리콜', 1000, 20250014),
	(27, 194, '이슈발생으로 인한 리콜', 100000, 20250014),
	(28, 192, '이슈발생으로 인한 리콜', 19000, 20250014),
	(29, 190, '이슈발생으로 인한 리콜', 100, 20250014);

-- 테이블 natureblend.material_input 구조 내보내기
CREATE TABLE IF NOT EXISTS `material_input` (
  `input_num` int(11) NOT NULL AUTO_INCREMENT COMMENT '자재입고번호',
  `body_num` int(11) NOT NULL COMMENT '발주 자재별 오토인크리먼트',
  `order_code` varchar(200) NOT NULL COMMENT '자재 발주 코드',
  `client_num` int(11) NOT NULL COMMENT '거래처의 기본키',
  `material_code` varchar(200) NOT NULL COMMENT '자재의 기본키',
  `inset_lot_date` datetime NOT NULL DEFAULT current_timestamp() COMMENT '입고한 날짜',
  `emp_num` int(11) NOT NULL COMMENT '자재 입고 담당자',
  PRIMARY KEY (`input_num`)
) ENGINE=InnoDB AUTO_INCREMENT=148 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- 테이블 데이터 natureblend.material_input:~39 rows (대략적) 내보내기
INSERT INTO `material_input` (`input_num`, `body_num`, `order_code`, `client_num`, `material_code`, `inset_lot_date`, `emp_num`) VALUES
	(75, 129, 'PO241226002', 1, 'M010', '1999-12-26 19:54:32', 20250001),
	(110, 194, 'PO250107001', 7, 'M012', '2025-01-07 12:56:56', 20250014),
	(111, 195, 'PO250107002', 1, 'M002', '2025-01-07 12:56:56', 20250014),
	(112, 196, 'PO250107002', 1, 'M005', '2025-01-07 12:56:56', 20250014),
	(113, 197, 'PO250107003', 2, 'M007', '2025-01-07 12:56:56', 20250014),
	(114, 198, 'PO250107004', 22, 'M008', '2025-01-07 12:56:56', 20250014),
	(115, 199, 'PO250107005', 3, 'M009', '2025-01-07 12:56:56', 20250014),
	(116, 200, 'PO250107001', 7, 'M011', '2025-01-07 12:56:57', 20250014),
	(117, 204, 'PO250107009', 7, 'M011', '2025-01-07 14:11:57', 20250014),
	(118, 203, 'PO250107008', 22, 'M008', '2025-01-07 14:11:57', 20250014),
	(119, 202, 'PO250107007', 2, 'M007', '2025-01-07 14:11:57', 20250014),
	(120, 201, 'PO250107006', 1, 'M004', '2025-01-07 14:11:58', 20250014),
	(121, 214, 'PO250107012', 3, 'M009', '2025-01-07 14:52:28', 20250014),
	(122, 211, 'PO250107011', 7, 'M013', '2025-01-07 14:52:28', 20250014),
	(123, 212, 'PO250107011', 7, 'M011', '2025-01-07 14:52:28', 20250014),
	(124, 213, 'PO250107011', 7, 'M012', '2025-01-07 14:52:28', 20250014),
	(125, 205, 'PO250107010', 1, 'M006', '2025-01-07 14:52:29', 20250014),
	(126, 206, 'PO250107010', 1, 'M001', '2025-01-07 14:52:29', 20250014),
	(127, 207, 'PO250107010', 1, 'M002', '2025-01-07 14:52:29', 20250014),
	(128, 208, 'PO250107010', 1, 'M003', '2025-01-07 14:52:29', 20250014),
	(129, 209, 'PO250107010', 1, 'M004', '2025-01-07 14:52:29', 20250014),
	(130, 210, 'PO250107010', 1, 'M005', '2025-01-07 14:52:29', 20250014),
	(131, 216, 'PO250107014', 22, 'M008', '2025-01-07 14:52:37', 20250014),
	(132, 215, 'PO250107013', 2, 'M007', '2025-01-07 14:52:37', 20250014),
	(133, 224, 'PO250108007', 36, 'M001', '2025-01-08 14:47:47', 20250014),
	(134, 227, 'PO250108008', 2, 'M007', '2025-01-08 14:47:47', 20250014),
	(135, 222, 'PO250108005', 3, 'M009', '2025-01-08 14:47:47', 20250014),
	(136, 223, 'PO250108006', 1, 'M001', '2025-01-09 06:19:08', 20250011),
	(137, 225, 'PO250108006', 1, 'M004', '2025-01-09 06:19:08', 20250011),
	(138, 226, 'PO250108006', 1, 'M006', '2025-01-09 06:19:08', 20250011),
	(139, 220, 'PO250108003', 2, 'M007', '2025-01-09 06:19:08', 20250011),
	(140, 230, 'PO250108011', 3, 'M009', '2025-01-09 06:19:09', 20250011),
	(141, 231, 'PO250108012', 7, 'M011', '2025-01-09 06:19:09', 20250011),
	(142, 228, 'PO250108009', 1, 'M001', '2025-01-09 06:19:23', 20250011),
	(143, 218, 'PO250108002', 1, 'M001', '2025-01-09 07:14:24', 20250011),
	(144, 217, 'PO250108001', 7, 'M011', '2025-01-09 07:14:24', 20250011),
	(145, 221, 'PO250108004', 3, 'M009', '2025-01-09 07:14:25', 20250011),
	(146, 232, 'PO250108013', 2, 'M007', '2025-01-09 07:14:25', 20250011),
	(147, 229, 'PO250108010', 22, 'M008', '2025-01-09 07:14:25', 20250011);

-- 프로시저 natureblend.material_input_polist 구조 내보내기
DELIMITER //
CREATE PROCEDURE `material_input_polist`(
	IN `v_client_num` INT,
	IN `v_emp_num` INT,
	IN `v_material_code` VARCHAR(50),
	IN `v_ord_qty` INT,
	IN `v_limit_date` datetime,
	IN `v_unit_price` INT,
	IN `v_total_price` INT,
	OUT `v_result` VARCHAR(20)
)
BEGIN DECLARE v_order_date VARCHAR(20);

DECLARE v_result_value VARCHAR(20);
DECLARE v_material_name VARCHAR(50);


START TRANSACTION;


SELECT CASE
           WHEN DATE_FORMAT(order_date, '%Y-%m-%d') = DATE_FORMAT(NOW(), '%Y-%m-%d') THEN CASE
                                                                                              WHEN LENGTH((RIGHT(order_code, 3)+1)) = 1 THEN CONCAT('PO', DATE_FORMAT(NOW(), '%y%m%d'), '00',(RIGHT(order_code, 3)+1))
                                                                                              WHEN LENGTH((RIGHT(order_code, 3)+1)) = 2 THEN CONCAT('PO', DATE_FORMAT(NOW(), '%y%m%d'), '0',(RIGHT(order_code, 3)+1))
                                                                                              WHEN LENGTH((RIGHT(order_code, 3)+1)) = 3 THEN CONCAT('PO', DATE_FORMAT(NOW(), '%y%m%d'),(RIGHT(order_code, 3)+1))
                                                                                          END
           ELSE CONCAT('PO', DATE_FORMAT(NOW(), '%y%m%d'), '001')
       END AS order_date INTO v_order_date
FROM material_order_head
ORDER BY order_date DESC
LIMIT 1;

IF v_order_date IS NOT NULL THEN
INSERT INTO material_order_head
VALUES (v_order_date, v_client_num, v_emp_num, CURRENT_TIMESTAMP);


SET v_result_value = FOUND_ROWS();

IF v_result_value = 1 THEN -- body_num, order_code, material_code, ord_qty, limit_date, unit_price, total_price, material_state,

	SELECT
			material_name
	INTO
			v_material_name
	FROM
			material
	WHERE
			material_code = v_material_code;
			
	IF CHARINDEX('병', v_material_name) > 0 THEN
		INSERT INTO material_order_body (order_code, material_code, ord_qty, limit_date, unit_price, total_price, material_state)
		VALUES (v_order_date, v_material_code, v_ord_qty, v_limit_date, v_unit_price, (v_ord_qty * v_unit_price), 'a1');	
	ELSE
		INSERT INTO material_order_body (order_code, material_code, ord_qty, limit_date, unit_price, total_price, material_state)
		VALUES (v_order_date, v_material_code, (v_ord_qty*1000), v_limit_date, v_unit_price, ((v_ord_qty*1000) * v_unit_price), 'a1');
	END IF;

	


SET v_result_value = FOUND_ROWS();

IF v_result_value = 1 THEN
COMMIT;


SET v_result_value = 'OK';

ELSE
ROLLBACK;


SET v_result_value = 'NO_body';

END IF;

ELSE
ROLLBACK;


SET v_result_value = 'NO_head';

END IF;

ELSE
ROLLBACK;


SET v_result_value = 'NO';

END IF;


SELECT v_result_value AS RESULT;

END//
DELIMITER ;

-- 프로시저 natureblend.material_input_polist_rmk 구조 내보내기
DELIMITER //
CREATE PROCEDURE `material_input_polist_rmk`(
	IN `v_materialKey` BIGINT,
	IN `v_client_num` INT,
	IN `v_emp_num` INT,
	IN `v_material_code` VARCHAR(20),
	IN `v_go_qty` INT,
	IN `v_limit_date` datetime,
	IN `v_go_price` INT,
	IN `v_go_total_price` BIGINT,
	OUT `v_result` VARCHAR(50)
)
BEGIN DECLARE v_po_list VARCHAR(30);

DECLARE v_result_value INT;

DECLARE CONTINUE
HANDLER FOR NOT FOUND BEGIN
ROLLBACK; -- 값이 없어서 종료되면 롤백


SELECT v_result,
       'SELECT NOT FOUND' AS ErrorMessage;

END;


START TRANSACTION;

/*
    	IN v_materialKey INT, 	-- 인공킹
		 IN v_client_num INT, 	-- 회사번호
		 IN v_emp_num INT, 		-- 사원 번호
		 IN v_material_code VARCHAR(20), 	--	자재코드
	     IN v_go_qty INT,						-- 입고수량
		 IN v_limit_date datetime, 			-- 입고기일
		 IN v_go_price INT, 						-- 입고단가
	     IN v_go_total_price BIGINT, 		-- 총금액
		 OUT v_result VARCHAR(20)				-- 결과
    */
SET v_result = '프로시저시작';


SELECT IFNULL(
                (SELECT moh.order_code
                 FROM material_order_head moh
                 WHERE moh.client_num = v_client_num
                   AND moh.artificial_head = v_materialKey
                 LIMIT 1), 'NODATA') INTO v_po_list;


SET v_result = 'v_po_list 시작';

IF v_po_list='NODATA' THEN -- 인서트, POLIST빼기, 발주서등록

SET v_result = 'POLIST 생성시작';


SELECT CASE
           WHEN DATE_FORMAT(order_date, '%Y-%m-%d') = DATE_FORMAT(NOW(), '%Y-%m-%d') THEN CASE
                                                                                              WHEN LENGTH((RIGHT(order_code, 3)+1)) = 1 THEN CONCAT('PO', DATE_FORMAT(NOW(), '%y%m%d'), '00',(RIGHT(order_code, 3)+1))
                                                                                              WHEN LENGTH((RIGHT(order_code, 3)+1)) = 2 THEN CONCAT('PO', DATE_FORMAT(NOW(), '%y%m%d'), '0',(RIGHT(order_code, 3)+1))
                                                                                              WHEN LENGTH((RIGHT(order_code, 3)+1)) = 3 THEN CONCAT('PO', DATE_FORMAT(NOW(), '%y%m%d'),(RIGHT(order_code, 3)+1))
                                                                                          END
           ELSE CONCAT('PO', DATE_FORMAT(NOW(), '%y%m%d'), '001')
       END AS order_date INTO v_po_list
FROM material_order_head
ORDER BY order_date DESC
LIMIT 1;


SET v_result = 'POLIST 발주헤더 인서트 시작';


INSERT INTO material_order_head (order_code, client_num, emp_num, artificial_head, order_date)
VALUES (v_po_list, v_client_num, v_emp_num, v_materialKey, CURRENT_TIMESTAMP);


SET v_result_value = ROW_COUNT();

IF v_result_value <> 0 THEN
SET v_result = 'material_order_head인서트 성공';


INSERT INTO material_order_body (order_code, material_code, ord_qty, limit_date, unit_price, total_price)
VALUES (v_po_list, v_material_code, v_go_qty, v_limit_date, v_go_price, v_go_total_price);


SET v_result_value = ROW_COUNT();

IF v_result_value <> 0 THEN
COMMIT;


SET v_result = 'OK';

ELSE
ROLLBACK;


SET v_result = 'material_order_body2 인서트 실패';

END IF;

ELSE
ROLLBACK;


SET v_result = 'material_order_head인서트 실패';

END IF;

ELSE -- 발주서등록

INSERT INTO material_order_body (order_code, material_code, ord_qty, limit_date, unit_price, total_price)
VALUES (v_po_list, v_material_code, v_go_qty, v_limit_date, v_go_price, v_go_total_price);


SET v_result_value = ROW_COUNT();

IF v_result_value <> 0 THEN
COMMIT;


SET v_result = 'OK';

ELSE
ROLLBACK;

-- SELECT v_po_list, v_material_code, v_go_qty, v_limit_date, v_go_price, v_go_total_price;

SET v_result = 'material_order_body인서트 실패';

END IF;

END IF;


SELECT v_result;

END//
DELIMITER ;

-- 프로시저 natureblend.material_lot_a_trush 구조 내보내기
DELIMITER //
CREATE PROCEDURE `material_lot_a_trush`(
	IN `v_lot_seq` INT,
	IN `v_trush_reason` varchar(255),
	IN `v_emp_num` INT,
	OUT `v_result` VARCHAR(50)
)
BEGIN DECLARE v_stok_qty INT;

DECLARE MATERIAL_ERR CONDITION
FOR SQLSTATE '45000'; -- 사용자 예외코드 정의 하는것 45000 이여야함

DECLARE CONTINUE
HANDLER FOR NOT FOUND BEGIN
ROLLBACK; -- 값이 없어서 종료되면 롤백


SELECT v_result,
       'SELECT NOT FOUND' AS ErrorMessage;

END;

-- 사용자 예외처리 정의
 DECLARE EXIT
HANDLER FOR MATERIAL_ERR BEGIN
ROLLBACK;


SELECT v_result,
       '값이처리 되지 않았습니다' AS ErrorMessage;

-- RESIGNAL;		-- 부모로 값 전달
 END;


START TRANSACTION;


SET v_result = '트렌젝션 시작';


SELECT stok_qty INTO v_stok_qty
FROM material_lot_qty1
WHERE lot_seq = v_lot_seq;


SET v_result = 'material_lot_qty1 업데이트';


UPDATE material_lot_qty1 mlq
SET mlq.out_qty = mlq.out_qty+mlq.stok_qty,
    mlq.stok_qty = 0,
    mlq.material_lot_state = 'c2'
WHERE mlq.lot_seq = v_lot_seq;

IF ROW_COUNT() <> 0 THEN -- IF FOUND_ROWS() <> 1 THEN

SET v_result = 'material_lot_qty1 업데이트 성공';


INSERT INTO material_discard (lot_seq, material_dis_content, COUNT, emp_num)
VALUES (v_lot_seq, v_trush_reason, v_stok_qty, v_emp_num);

IF ROW_COUNT() <> 1 THEN
SET v_result = 'material_discard 실패';

SIGNAL MATERIAL_ERR;

ELSE
SET v_result = 'OK';


COMMIT;

END IF;

ELSE
SET v_result = 'material_lot_qty1 업데이트 실패';

SIGNAL MATERIAL_ERR;

END IF;


SELECT v_result;

END//
DELIMITER ;

-- 프로시저 natureblend.material_lot_input 구조 내보내기
DELIMITER //
CREATE PROCEDURE `material_lot_input`(
	IN `v_lot_code` VARCHAR(50),
	IN `v_order_code` VARCHAR(50),
	IN `v_material_name` VARCHAR(100),
	IN `v_pass_qnt` INT,
	IN `v_warehouse1` VARCHAR(50),
	IN `v_rjc_qnt` INT,
	IN `v_warehouse2` VARCHAR(50),
	IN `v_emp_num` INT,
	OUT `v_result` VARCHAR(50)
)
BEGIN DECLARE v_client_num int;

DECLARE v_material_code varchar(50);

DECLARE v_expiration_date int;

DECLARE v_qc_material_id VARCHAR(50);

DECLARE v_body_num int;

DECLARE v_input_num int;

DECLARE MATERIAL_INPUT_ERR CONDITION
FOR SQLSTATE '45000'; -- 사용자 예외코드 정의 하는것 45000 이여야함

DECLARE CONTINUE
HANDLER FOR NOT FOUND BEGIN
ROLLBACK; -- 값이 없어서 종료되면 롤백


SELECT v_result,
       'SELECT NOT FOUND' AS ErrorMessage;

END;

-- 사용자 예외처리 정의
 DECLARE EXIT
HANDLER FOR MATERIAL_INPUT_ERR BEGIN
ROLLBACK;


SELECT v_result,
       '값이 삽입되지 않았습니다' AS ErrorMessage;

-- RESIGNAL;		-- 부모로 값 전달
 END;

-- 트랜젝션 시작

START TRANSACTION;


SET v_result = 'P_start';

-- 회사코드 얻어옴

SELECT client_num INTO v_client_num
FROM material_order_head
WHERE order_code = v_order_code ;


SET v_result = '1step(v_client_num) OK';

-- 유통기한, 자재코드 얻어옴

SELECT material_code, -- 자재코드
 expiration_date -- 유통기한 ex 180
 INTO v_material_code,
      v_expiration_date
FROM material
WHERE material_name = v_material_name ;


SET v_result = '2step(v_material_code, v_expiration_date) OK';

-- 입고 검사 번호 가져옴

SELECT qc_material_id INTO v_qc_material_id
FROM qc_material
WHERE order_code = v_order_code
  AND material_code = v_material_code ;


SET v_result = '3step(v_qc_material_id) OK';

-- 자재 발주 번호

SELECT body_num INTO v_body_num
FROM material_order_body
WHERE order_code = v_order_code
  AND material_code = v_material_code ;


SET v_result = '4step(v_body_num) OK';


INSERT INTO material_input (body_num, order_code, client_num, material_code, inset_lot_date, emp_num)
VALUES (v_body_num, v_order_code, v_client_num, v_material_code, CURRENT_TIMESTAMP, v_emp_num);

-- 주문서헤더 인서트 안되면 발생하는 예외처리
 IF ROW_COUNT() <> 1 THEN
SET v_result = 'material_input';

SIGNAL MATERIAL_INPUT_ERR;

END IF;


SELECT input_num INTO v_input_num
FROM material_input
ORDER BY input_num DESC
LIMIT 1 ;

-- 합격수량 입고

INSERT INTO material_lot_qty1 (input_num, warehouse_code, lot_code, material_code, stok_qty, limit_date, in_qty, qc_material_id)
VALUES (v_input_num, v_warehouse1, CONCAT(v_material_code,v_lot_code), v_material_code, v_pass_qnt, DATE_ADD(CURRENT_TIMESTAMP, INTERVAL v_expiration_date DAY), v_pass_qnt, v_qc_material_id);

IF ROW_COUNT() <> 1 THEN
SET v_result = 'material_lot_qty1 합격수량';

SIGNAL MATERIAL_INPUT_ERR;

END IF;

-- 불합격수량 입고

INSERT INTO material_lot_qty1 (input_num, warehouse_code, lot_code, material_code, stok_qty, limit_date, in_qty, qc_material_id, material_nomal)
VALUES (v_input_num, v_warehouse2, CONCAT(v_material_code,v_lot_code), v_material_code, v_rjc_qnt, DATE_ADD(CURRENT_TIMESTAMP, INTERVAL v_expiration_date DAY), v_rjc_qnt, v_qc_material_id, 'b2');

IF ROW_COUNT() <> 1 THEN
SET v_result = 'material_lot_qty1 불합격';

SIGNAL MATERIAL_INPUT_ERR;

END IF;


UPDATE material_order_body
SET material_state = 'a4'
WHERE body_num = v_body_num ;

IF ROW_COUNT() <> 1 THEN
SET v_result = 'material_order_body 상태변경실패';

SIGNAL MATERIAL_INPUT_ERR;

END IF;


SET v_result = 'OK';


SELECT v_result AS RESULT;


COMMIT;

/*
		로트번호(자동생성)
		LO코드(v_lot_code),
		입고번호(v_input_num)
		자재발주코드(v_order_code)
		자재발주번호(v_body_num)
		거래처코드(v_client_num)
		자재코드(v_material_code)
		유통기한(v_expiration_date) = 180
		입고검사번호(v_qc_material_id)
		사원번호(v_emp_num)
		입고수량(합격)(v_pass_qnt)
		재고수량(합격)(v_pass_qnt)
		창고코드(합격)(v_warehouse1)
		입고수량(불합격)(v_rjc_qnt)
		재고수량(불합격)(v_rjc_qnt)
		창고코드(불합격)(v_warehouse2)
		입고상태(기본값), 상태(기본값), 출고수량(기본값),
		입고일자 (오늘날짜),
	*/ END//
DELIMITER ;

-- 테이블 natureblend.material_lot_qty1 구조 내보내기
CREATE TABLE IF NOT EXISTS `material_lot_qty1` (
  `lot_seq` int(11) NOT NULL AUTO_INCREMENT COMMENT 'LOT번호 기본키',
  `input_num` int(11) NOT NULL COMMENT '자재입고번호',
  `material_code` varchar(200) NOT NULL COMMENT '자재의 기본키',
  `warehouse_code` varchar(100) NOT NULL COMMENT '창고테이블 정보를 다 불러옴',
  `lot_code` varchar(200) NOT NULL COMMENT '자재코드+생산일+생산월(1-9월:1~9, 10~12월:X~Z)+생산연도+그날입고순번',
  `stok_qty` int(11) NOT NULL DEFAULT 0 COMMENT '입고수량 - 출고수량 = 재고수량 ( 현재 재고 ) ( g 단위 )',
  `limit_date` datetime NOT NULL DEFAULT current_timestamp() COMMENT '오늘날짜 + 자재테이블의 숫자로 만들어짐',
  `in_qty` int(11) NOT NULL DEFAULT 0 COMMENT '입고 하여 입고된 정상 또는 불량 수량 ( 불변 )  ( g 단위 )',
  `out_qty` int(11) NOT NULL DEFAULT 0 COMMENT '불가용(홀딩)되었던 재고가 빠져나간 수량 ( g 단위 )',
  `material_nomal` varchar(100) NOT NULL DEFAULT 'b1' COMMENT '[2B] 정상상품입고=b1, 불량상품입고=b2',
  `material_lot_state` varchar(100) NOT NULL DEFAULT 'c1' COMMENT '[2C] 기본값=c1, 폐기처리하면=c2, 재고가0된것=정상=c1',
  `qc_material_id` varchar(20) NOT NULL COMMENT '불량과, 합격 재고 LOT가 따로 발급 (2개중1개만있음 1:1 , 합/불둘다면 1:M)',
  PRIMARY KEY (`lot_seq`)
) ENGINE=InnoDB AUTO_INCREMENT=266 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- 테이블 데이터 natureblend.material_lot_qty1:~77 rows (대략적) 내보내기
INSERT INTO `material_lot_qty1` (`lot_seq`, `input_num`, `material_code`, `warehouse_code`, `lot_code`, `stok_qty`, `limit_date`, `in_qty`, `out_qty`, `material_nomal`, `material_lot_state`, `qc_material_id`) VALUES
	(112, 75, 'M010', 'W011', 'M01026Z24002', 1999910000, '4762-11-22 19:54:32', 2000000000, 90000, 'b1', 'c1', 'QCM2412260018'),
	(190, 110, 'M012', 'W010', 'M01207125001', 0, '2027-01-07 12:56:56', 350, 350, 'b1', 'c2', 'QCM2501070006'),
	(191, 110, 'M012', 'W003', 'M01207125001', 0, '2027-01-07 12:56:56', 50, 50, 'b2', 'c2', 'QCM2501070006'),
	(192, 111, 'M002', 'W001', 'M00207125002', 0, '2027-01-07 12:56:56', 184000, 184000, 'b1', 'c2', 'QCM2501070004'),
	(193, 111, 'M002', 'W003', 'M00207125002', 0, '2027-01-07 12:56:56', 16000, 16000, 'b2', 'c2', 'QCM2501070004'),
	(194, 112, 'M005', 'W001', 'M00507125003', 0, '2027-01-07 12:56:56', 100000, 100000, 'b1', 'c2', 'QCM2501070005'),
	(195, 112, 'M005', 'W003', 'M00507125003', 0, '2027-01-07 12:56:56', 0, 0, 'b2', 'c1', 'QCM2501070005'),
	(196, 113, 'M007', 'W002', 'M00707125004', 26500, '2027-01-07 12:56:56', 40000, 13500, 'b1', 'c1', 'QCM2501070003'),
	(197, 113, 'M007', 'W003', 'M00707125004', 0, '2027-01-07 12:56:56', 0, 0, 'b2', 'c1', 'QCM2501070003'),
	(198, 114, 'M008', 'W002', 'M00807125005', 7000, '2027-01-07 12:56:56', 10000, 3000, 'b1', 'c1', 'QCM2501070002'),
	(199, 114, 'M008', 'W003', 'M00807125005', 0, '2027-01-07 12:56:56', 0, 0, 'b2', 'c1', 'QCM2501070002'),
	(200, 115, 'M009', 'W002', 'M00907125006', 12250, '2027-01-07 12:56:56', 20000, 7750, 'b1', 'c1', 'QCM2501070001'),
	(201, 115, 'M009', 'W003', 'M00907125006', 0, '2027-01-07 12:56:56', 0, 0, 'b2', 'c1', 'QCM2501070001'),
	(202, 116, 'M011', 'W010', 'M01107125007', 250, '2027-01-07 12:56:57', 500, 250, 'b1', 'c1', 'QCM2501070007'),
	(203, 116, 'M011', 'W003', 'M01107125007', 0, '2027-01-07 12:56:57', 0, 0, 'b2', 'c1', 'QCM2501070007'),
	(204, 117, 'M011', 'W010', 'M01107125008', 0, '2027-01-07 14:11:57', 1000, 1000, 'b1', 'c2', 'QCM2501070008'),
	(205, 117, 'M011', 'W003', 'M01107125008', 0, '2027-01-07 14:11:57', 0, 0, 'b2', 'c1', 'QCM2501070008'),
	(206, 118, 'M008', 'W002', 'M00807125009', 0, '2027-01-07 14:11:57', 10000, 10000, 'b1', 'c2', 'QCM2501070009'),
	(207, 118, 'M008', 'W003', 'M00807125009', 0, '2027-01-07 14:11:57', 0, 0, 'b2', 'c1', 'QCM2501070009'),
	(208, 119, 'M007', 'W002', 'M00707125010', 0, '2027-01-07 14:11:57', 100000, 100000, 'b1', 'c2', 'QCM2501070010'),
	(209, 119, 'M007', 'W003', 'M00707125010', 0, '2027-01-07 14:11:57', 0, 0, 'b2', 'c1', 'QCM2501070010'),
	(210, 120, 'M004', 'W001', 'M00407125011', 0, '2027-01-07 14:11:58', 150000, 150000, 'b1', 'c2', 'QCM2501070011'),
	(211, 120, 'M004', 'W003', 'M00407125011', 0, '2027-01-07 14:11:58', 0, 0, 'b2', 'c1', 'QCM2501070011'),
	(212, 121, 'M009', 'W002', 'M00907125012', 9997000, '2027-01-07 14:52:28', 10000000, 3000, 'b1', 'c1', 'QCM2501070014'),
	(213, 121, 'M009', 'W003', 'M00907125012', 0, '2027-01-07 14:52:28', 0, 0, 'b2', 'c1', 'QCM2501070014'),
	(214, 122, 'M013', 'W010', 'M01307125013', 10000, '2027-01-07 14:52:28', 10000, 0, 'b1', 'c1', 'QCM2501070015'),
	(215, 122, 'M013', 'W003', 'M01307125013', 0, '2027-01-07 14:52:28', 0, 0, 'b2', 'c1', 'QCM2501070015'),
	(216, 123, 'M011', 'W010', 'M01107125014', 9850, '2027-01-07 14:52:28', 10000, 150, 'b1', 'c1', 'QCM2501070016'),
	(217, 123, 'M011', 'W003', 'M01107125014', 0, '2027-01-07 14:52:28', 0, 0, 'b2', 'c1', 'QCM2501070016'),
	(218, 124, 'M012', 'W010', 'M01207125015', 10000, '2027-01-07 14:52:28', 10000, 0, 'b1', 'c1', 'QCM2501070017'),
	(219, 124, 'M012', 'W003', 'M01207125015', 0, '2027-01-07 14:52:28', 0, 0, 'b2', 'c1', 'QCM2501070017'),
	(220, 125, 'M006', 'W001', 'M00607125016', 10000000, '2027-01-07 14:52:29', 10000000, 0, 'b1', 'c1', 'QCM2501070018'),
	(221, 125, 'M006', 'W003', 'M00607125016', 0, '2027-01-07 14:52:29', 0, 0, 'b2', 'c1', 'QCM2501070018'),
	(222, 126, 'M001', 'W001', 'M00107125017', 10000000, '2027-01-07 14:52:29', 10000000, 0, 'b1', 'c1', 'QCM2501070019'),
	(223, 126, 'M001', 'W003', 'M00107125017', 0, '2027-01-07 14:52:29', 0, 0, 'b2', 'c1', 'QCM2501070019'),
	(224, 127, 'M002', 'W001', 'M00207125018', 9934000, '2027-01-07 14:52:29', 10000000, 66000, 'b1', 'c1', 'QCM2501070020'),
	(225, 127, 'M002', 'W003', 'M00207125018', 0, '2027-01-07 14:52:29', 0, 0, 'b2', 'c1', 'QCM2501070020'),
	(226, 128, 'M003', 'W001', 'M00307125019', 10000000, '2027-01-07 14:52:29', 10000000, 0, 'b1', 'c1', 'QCM2501070021'),
	(227, 128, 'M003', 'W003', 'M00307125019', 0, '2027-01-07 14:52:29', 0, 0, 'b2', 'c1', 'QCM2501070021'),
	(228, 129, 'M004', 'W001', 'M00407125020', 10000000, '2027-01-07 14:52:29', 10000000, 0, 'b1', 'c1', 'QCM2501070022'),
	(229, 129, 'M004', 'W003', 'M00407125020', 0, '2027-01-07 14:52:29', 0, 0, 'b2', 'c1', 'QCM2501070022'),
	(230, 130, 'M005', 'W001', 'M00507125021', 10000000, '2027-01-07 14:52:29', 10000000, 0, 'b1', 'c1', 'QCM2501070023'),
	(231, 130, 'M005', 'W003', 'M00507125021', 0, '2027-01-07 14:52:29', 0, 0, 'b2', 'c1', 'QCM2501070023'),
	(232, 131, 'M008', 'W002', 'M00807125022', 10000000, '2027-01-07 14:52:37', 10000000, 0, 'b1', 'c1', 'QCM2501070012'),
	(233, 131, 'M008', 'W003', 'M00807125022', 0, '2027-01-07 14:52:37', 0, 0, 'b2', 'c1', 'QCM2501070012'),
	(234, 132, 'M007', 'W002', 'M00707125023', 100000000, '2027-01-07 14:52:37', 100000000, 0, 'b1', 'c1', 'QCM2501070013'),
	(235, 132, 'M007', 'W003', 'M00707125023', 0, '2027-01-07 14:52:37', 0, 0, 'b2', 'c1', 'QCM2501070013'),
	(236, 133, 'M001', 'W001', 'M00108125001', 140000, '2027-01-08 14:47:47', 140000, 0, 'b1', 'c1', 'QCM2501080004'),
	(237, 133, 'M001', 'W003', 'M00108125001', 10000, '2027-01-08 14:47:47', 10000, 0, 'b2', 'c1', 'QCM2501080004'),
	(238, 134, 'M007', 'W002', 'M00708125002', 95000, '2027-01-08 14:47:47', 95000, 0, 'b1', 'c1', 'QCM2501080008'),
	(239, 134, 'M007', 'W003', 'M00708125002', 5000, '2027-01-08 14:47:47', 5000, 0, 'b2', 'c1', 'QCM2501080008'),
	(240, 135, 'M009', 'W002', 'M00908125003', 35000, '2027-01-08 14:47:47', 35000, 0, 'b1', 'c1', 'QCM2501080009'),
	(241, 135, 'M009', 'W003', 'M00908125003', 0, '2027-01-08 14:47:47', 0, 0, 'b2', 'c1', 'QCM2501080009'),
	(242, 136, 'M001', 'W001', 'M00109125001', 100000, '2027-01-09 06:19:08', 100000, 0, 'b1', 'c1', 'QCM2501080005'),
	(243, 136, 'M001', 'W003', 'M00109125001', 0, '2027-01-09 06:19:08', 0, 0, 'b2', 'c1', 'QCM2501080005'),
	(244, 137, 'M004', 'W001', 'M00409125002', 100000, '2027-01-09 06:19:08', 100000, 0, 'b1', 'c1', 'QCM2501080006'),
	(245, 137, 'M004', 'W003', 'M00409125002', 0, '2027-01-09 06:19:08', 0, 0, 'b2', 'c1', 'QCM2501080006'),
	(246, 138, 'M006', 'W001', 'M00609125003', 99000, '2027-01-09 06:19:08', 99000, 0, 'b1', 'c1', 'QCM2501080007'),
	(247, 138, 'M006', 'W003', 'M00609125003', 1000, '2027-01-09 06:19:08', 1000, 0, 'b2', 'c1', 'QCM2501080007'),
	(248, 139, 'M007', 'W002', 'M00709125004', 290000, '2027-01-09 06:19:08', 290000, 0, 'b1', 'c1', 'QCM2501080011'),
	(249, 139, 'M007', 'W003', 'M00709125004', 0, '2027-01-09 06:19:08', 0, 0, 'b2', 'c1', 'QCM2501080011'),
	(250, 140, 'M009', 'W002', 'M00909125005', 90000, '2027-01-09 06:19:09', 90000, 0, 'b1', 'c1', 'QCM2501080014'),
	(251, 140, 'M009', 'W003', 'M00909125005', 10000, '2027-01-09 06:19:09', 10000, 0, 'b2', 'c1', 'QCM2501080014'),
	(252, 141, 'M011', 'W010', 'M01109125006', 1783, '2027-01-09 06:19:09', 1783, 0, 'b1', 'c1', 'QCM2501080013'),
	(253, 141, 'M011', 'W003', 'M01109125006', 17, '2027-01-09 06:19:09', 17, 0, 'b2', 'c1', 'QCM2501080013'),
	(254, 142, 'M001', 'W001', 'M00109125007', 200000, '2027-01-09 06:19:23', 200000, 0, 'b1', 'c1', 'QCM2501080016'),
	(255, 142, 'M001', 'W003', 'M00109125007', 0, '2027-01-09 06:19:23', 0, 0, 'b2', 'c1', 'QCM2501080016'),
	(256, 143, 'M001', 'W001', 'M00109125008', 100000, '2027-01-09 07:14:24', 100000, 0, 'b1', 'c1', 'QCM2501080001'),
	(257, 143, 'M001', 'W003', 'M00109125008', 0, '2027-01-09 07:14:24', 0, 0, 'b2', 'c1', 'QCM2501080001'),
	(258, 144, 'M011', 'W010', 'M01109125009', 500, '2027-01-09 07:14:24', 500, 0, 'b1', 'c1', 'QCM2501080003'),
	(259, 144, 'M011', 'W003', 'M01109125009', 0, '2027-01-09 07:14:24', 0, 0, 'b2', 'c1', 'QCM2501080003'),
	(260, 145, 'M009', 'W002', 'M00909125010', 32000, '2027-01-09 07:14:25', 32000, 0, 'b1', 'c1', 'QCM2501080010'),
	(261, 145, 'M009', 'W003', 'M00909125010', 8000, '2027-01-09 07:14:25', 8000, 0, 'b2', 'c1', 'QCM2501080010'),
	(262, 146, 'M007', 'W002', 'M00709125011', 200000, '2027-01-09 07:14:25', 200000, 0, 'b1', 'c1', 'QCM2501080012'),
	(263, 146, 'M007', 'W003', 'M00709125011', 0, '2027-01-09 07:14:25', 0, 0, 'b2', 'c1', 'QCM2501080012'),
	(264, 147, 'M008', 'W002', 'M00809125012', 100000, '2027-01-09 07:14:25', 100000, 0, 'b1', 'c1', 'QCM2501080015'),
	(265, 147, 'M008', 'W003', 'M00809125012', 0, '2027-01-09 07:14:25', 0, 0, 'b2', 'c1', 'QCM2501080015');

-- 테이블 natureblend.material_order_body 구조 내보내기
CREATE TABLE IF NOT EXISTS `material_order_body` (
  `body_num` int(11) NOT NULL AUTO_INCREMENT COMMENT '발주 자재별 오토인크리먼트',
  `order_code` varchar(200) NOT NULL COMMENT '자재 발주 코드',
  `material_code` varchar(200) NOT NULL COMMENT '자재테이블 정보를 가져옴',
  `ord_qty` int(11) NOT NULL DEFAULT 0 COMMENT '그램단위로 주문함',
  `limit_date` datetime NOT NULL DEFAULT current_timestamp() COMMENT '납기마감 일자',
  `unit_price` int(11) NOT NULL DEFAULT 0 COMMENT '발주당시 금액으로 고정',
  `total_price` bigint(20) NOT NULL DEFAULT 0 COMMENT '단가 * 발주수량의 최종금액',
  `material_state` varchar(100) NOT NULL DEFAULT 'a1' COMMENT '[2A] a1=발주등록, a2=확정, a3=취소,  a4=입고완료',
  PRIMARY KEY (`body_num`,`order_code`),
  KEY `FK_material_order_head_TO_material_order_body_1` (`order_code`),
  CONSTRAINT `FK_material_order_head_TO_material_order_body_1` FOREIGN KEY (`order_code`) REFERENCES `material_order_head` (`order_code`)
) ENGINE=InnoDB AUTO_INCREMENT=236 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- 테이블 데이터 natureblend.material_order_body:~43 rows (대략적) 내보내기
INSERT INTO `material_order_body` (`body_num`, `order_code`, `material_code`, `ord_qty`, `limit_date`, `unit_price`, `total_price`, `material_state`) VALUES
	(129, 'PO241226002', 'M010', 1000000, '1999-12-26 00:00:00', 100000, 100000000, 'a4'),
	(194, 'PO250107001', 'M012', 400, '2025-01-15 00:00:00', 250, 100000, 'a4'),
	(195, 'PO250107002', 'M002', 200000, '2025-01-14 00:00:00', 2500000, 500000000, 'a4'),
	(196, 'PO250107002', 'M005', 100000, '2025-01-13 00:00:00', 4000000, 400000000, 'a4'),
	(197, 'PO250107003', 'M007', 40000, '2025-01-20 00:00:00', 3000000, 120000000, 'a4'),
	(198, 'PO250107004', 'M008', 10000, '2025-01-20 00:00:00', 4000000, 40000000, 'a4'),
	(199, 'PO250107005', 'M009', 20000, '2025-01-20 00:00:00', 5000000, 100000000, 'a4'),
	(200, 'PO250107001', 'M011', 500, '2025-01-20 00:00:00', 200, 100000, 'a4'),
	(201, 'PO250107006', 'M004', 150000, '2025-01-07 00:00:00', 2500000, 375000000, 'a4'),
	(202, 'PO250107007', 'M007', 100000, '2025-01-14 00:00:00', 3300000, 330000000, 'a4'),
	(203, 'PO250107008', 'M008', 10000, '2025-01-15 00:00:00', 5000000, 50000000, 'a4'),
	(204, 'PO250107009', 'M011', 1000, '2025-01-06 00:00:00', 200, 200000, 'a4'),
	(205, 'PO250107010', 'M006', 10000000, '2025-01-08 00:00:00', 2500000, 25000000000, 'a4'),
	(206, 'PO250107010', 'M001', 10000000, '2025-01-08 00:00:00', 2500000, 25000000000, 'a4'),
	(207, 'PO250107010', 'M002', 10000000, '2025-01-08 00:00:00', 2500000, 25000000000, 'a4'),
	(208, 'PO250107010', 'M003', 10000000, '2025-01-07 00:00:00', 2500000, 25000000000, 'a4'),
	(209, 'PO250107010', 'M004', 10000000, '2025-01-08 00:00:00', 2500000, 25000000000, 'a4'),
	(210, 'PO250107010', 'M005', 10000000, '2025-01-07 00:00:00', 2500000, 25000000000, 'a4'),
	(211, 'PO250107011', 'M013', 10000, '2025-01-07 00:00:00', 450, 4500000, 'a4'),
	(212, 'PO250107011', 'M011', 10000, '2025-01-07 00:00:00', 250, 2500000, 'a4'),
	(213, 'PO250107011', 'M012', 10000, '2025-01-07 00:00:00', 300, 3000000, 'a4'),
	(214, 'PO250107012', 'M009', 10000000, '2025-01-15 00:00:00', 6000000, 60000000000, 'a4'),
	(215, 'PO250107013', 'M007', 100000000, '2025-01-09 00:00:00', 3000000, 300000000000, 'a4'),
	(216, 'PO250107014', 'M008', 10000000, '2025-01-09 00:00:00', 5000000, 50000000000, 'a4'),
	(217, 'PO250108001', 'M011', 500, '2025-01-12 00:00:00', 300, 150000, 'a4'),
	(218, 'PO250108002', 'M001', 100000, '2025-01-15 00:00:00', 5000000, 500000000, 'a4'),
	(219, 'PO250108002', 'M006', 200000, '2025-01-22 00:00:00', 6000000, 1200000000, 'a1'),
	(220, 'PO250108003', 'M007', 300000, '2025-01-22 00:00:00', 3000000, 900000000, 'a4'),
	(221, 'PO250108004', 'M009', 40000, '2025-01-20 00:00:00', 7000000, 280000000, 'a4'),
	(222, 'PO250108005', 'M009', 35000, '2025-01-15 00:00:00', 7000000, 245000000, 'a4'),
	(223, 'PO250108006', 'M001', 100000, '2025-01-15 00:00:00', 3500000, 350000000, 'a4'),
	(224, 'PO250108007', 'M001', 150000, '2025-01-15 00:00:00', 3350000, 502500000, 'a4'),
	(225, 'PO250108006', 'M004', 100000, '2025-01-15 00:00:00', 5000000, 500000000, 'a4'),
	(226, 'PO250108006', 'M006', 100000, '2025-01-09 00:00:00', 4500000, 450000000, 'a4'),
	(227, 'PO250108008', 'M007', 100000, '2025-01-15 00:00:00', 8500000, 850000000, 'a4'),
	(228, 'PO250108009', 'M001', 200000, '2025-01-30 00:00:00', 4000000, 800000000, 'a4'),
	(229, 'PO250108010', 'M008', 100000, '2025-01-30 00:00:00', 300000, 30000000, 'a4'),
	(230, 'PO250108011', 'M009', 100000, '2025-01-30 00:00:00', 300000, 30000000, 'a4'),
	(231, 'PO250108012', 'M011', 2000, '2025-01-30 00:00:00', 450, 900000, 'a4'),
	(232, 'PO250108013', 'M007', 200000, '2025-01-30 00:00:00', 500000, 100000000, 'a4'),
	(233, 'PO250109001', 'M007', 100000, '2025-01-22 00:00:00', 4500000, 450000000, 'a1'),
	(234, 'PO250109002', 'M006', 100000, '2025-01-15 00:00:00', 3500000, 350000000, 'a1'),
	(235, 'PO250109003', 'M006', 200000, '2025-01-15 00:00:00', 4000000, 800000000, 'a1');

-- 테이블 natureblend.material_order_head 구조 내보내기
CREATE TABLE IF NOT EXISTS `material_order_head` (
  `order_code` varchar(200) NOT NULL COMMENT '자재 발주 코드',
  `client_num` int(11) NOT NULL COMMENT '거래처테이블 정보를 불러옴',
  `emp_num` int(11) NOT NULL COMMENT '발주등록 담당자',
  `artificial_head` bigint(20) DEFAULT NULL COMMENT '발주인풋할때 인공적으로 동일 헤더 사용인지 판별용',
  `order_date` datetime NOT NULL DEFAULT current_timestamp() COMMENT '오늘날짜',
  PRIMARY KEY (`order_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- 테이블 데이터 natureblend.material_order_head:~31 rows (대략적) 내보내기
INSERT INTO `material_order_head` (`order_code`, `client_num`, `emp_num`, `artificial_head`, `order_date`) VALUES
	('PO241226002', 1, 20250001, 1735210248372, '1999-12-26 19:50:48'),
	('PO250107001', 7, 20250014, 1736222086508, '2025-01-07 12:54:46'),
	('PO250107002', 1, 20250014, 1736222086508, '2025-01-07 12:54:46'),
	('PO250107003', 2, 20250014, 1736222086508, '2025-01-07 12:54:47'),
	('PO250107004', 22, 20250014, 1736222086508, '2025-01-07 12:54:47'),
	('PO250107005', 3, 20250014, 1736222086508, '2025-01-07 12:54:47'),
	('PO250107006', 1, 20250014, 1736226494925, '2025-01-07 14:08:14'),
	('PO250107007', 2, 20250014, 1736226494925, '2025-01-07 14:08:14'),
	('PO250107008', 22, 20250014, 1736226494925, '2025-01-07 14:08:14'),
	('PO250107009', 7, 20250014, 1736226494925, '2025-01-07 14:08:14'),
	('PO250107010', 1, 20250014, 1736228410253, '2025-01-07 14:40:10'),
	('PO250107011', 7, 20250014, 1736228613269, '2025-01-07 14:43:33'),
	('PO250107012', 3, 20250014, 1736228705364, '2025-01-07 14:45:05'),
	('PO250107013', 2, 20250014, 1736228705364, '2025-01-07 14:45:05'),
	('PO250107014', 22, 20250014, 1736228705364, '2025-01-07 14:45:05'),
	('PO250108001', 7, 20250014, 1736297753352, '2025-01-08 09:55:52'),
	('PO250108002', 1, 20250014, 1736297753352, '2025-01-08 09:55:53'),
	('PO250108003', 2, 20250014, 1736297753352, '2025-01-08 09:55:53'),
	('PO250108004', 3, 20250014, 1736297753352, '2025-01-08 09:55:53'),
	('PO250108005', 3, 20250014, 1736306926890, '2025-01-08 12:28:46'),
	('PO250108006', 1, 20250014, 1736306926890, '2025-01-08 12:28:46'),
	('PO250108007', 36, 20250014, 1736306926890, '2025-01-08 12:28:46'),
	('PO250108008', 2, 20250014, 1736306926890, '2025-01-08 12:28:46'),
	('PO250108009', 1, 20250014, 1736347376819, '2025-01-08 23:42:56'),
	('PO250108010', 22, 20250014, 1736347489139, '2025-01-08 23:44:49'),
	('PO250108011', 3, 20250014, 1736347489139, '2025-01-08 23:44:49'),
	('PO250108012', 7, 20250014, 1736347489139, '2025-01-08 23:44:49'),
	('PO250108013', 2, 20250014, 1736347489139, '2025-01-08 23:44:49'),
	('PO250109001', 2, 20250011, 1736373599320, '2025-01-09 06:59:59'),
	('PO250109002', 1, 20250011, 1736373599320, '2025-01-09 06:59:59'),
	('PO250109003', 36, 20250011, 1736373599320, '2025-01-09 06:59:59');

-- 프로시저 natureblend.orderlistDelete 구조 내보내기
DELIMITER //
CREATE PROCEDURE `orderlistDelete`(
IN v_orderlist_num INT 
)
BEGIN
-- 변수 선언

DECLARE vo_change_num INT;
DECLARE vl_change_num INT;

-- 트랜잭션 시작
START TRANSACTION;

DELETE FROM orderlists 
WHERE orderlist_num = v_orderlist_num;

-- 변경된 행 체크 
SET vl_change_num = ROW_COUNT();
IF vl_change_num = 1 THEN 
	DELETE FROM orders 
	WHERE orderlist_num = v_orderlist_num;


	SET vo_change_num = ROW_COUNT();
END IF;
	-- 트랜잭션 커밋 또는 롤백 처리
	IF vl_change_num = 1 AND vo_change_num >= 1 THEN -- `orders`에서 최소 1개 이상의 행이 삭제되었다면 커밋
		-- 트랜잭션 커밋
			COMMIT;
	ELSE
    -- 주문서 등록 실패 시 롤백
        ROLLBACK;
	END IF;
END//
DELIMITER ;

-- 프로시저 natureblend.orderlistInput 구조 내보내기
DELIMITER //
CREATE PROCEDURE `orderlistInput`(
IN v_orderlist_title VARCHAR(50),
IN v_due_date DATETIME,
IN v_com_name VARCHAR(30),


IN v_product_code_json_array TEXT,
IN v_product_num_json_array TEXT,
IN v_per_price_json_array TEXT,
IN v_emp_name VARCHAR(30)
)
BEGIN
-- 변수 선언
DECLARE v_emp_num INT;
DECLARE v_com_num INT;
DECLARE v_last_num INT;
DECLARE v_change_num INT;
DECLARE v_result_value INT;

DECLARE i INT DEFAULT 1;
DECLARE product_code_array_length INT;
DECLARE product_code_value TEXT;
DECLARE product_num_value TEXT;
DECLARE per_price_value TEXT;


-- 트랜잭션 시작
START TRANSACTION;

-- JSON 배열 길이 계산
SET product_code_array_length = JSON_LENGTH(v_product_code_json_array);

-- 사원번호 (사원이름)
SELECT emp_num
INTO v_emp_num
FROM employee
WHERE name = v_emp_name
LIMIT 1;

-- 회사번호 (회사이름)
SELECT client_num
INTO v_com_num
FROM client
WHERE com_name = v_com_name
LIMIT 1;

-- 주문서 등록
INSERT INTO orderlists
		(orderlist_title,
        due_date,
        emp_num,
        client_num)
VALUES (v_orderlist_title,
	    v_due_date,
		v_emp_num,
		v_com_num);

-- 주문서 등록 후 변화한 값 
SET v_change_num = FOUND_ROWS();
        
SELECT v_change_num;

IF v_change_num = 1 THEN 
-- 마지막 주문서 번호 가져오기
SELECT orderlist_num
INTO v_last_num
FROM orderlists
ORDER BY orderlist_num desc
limit 1;

-- 반복으로  json 배열 요소 추출 
WHILE i <= product_code_array_length DO
	SET product_code_value  = JSON_UNQUOTE(JSON_EXTRACT(v_product_code_json_array , CONCAT('$[', i - 1, ']')));
    SET product_num_value   = JSON_UNQUOTE(JSON_EXTRACT(v_product_num_json_array  , CONCAT('$[', i - 1, ']')));
    SET per_price_value   = JSON_UNQUOTE(JSON_EXTRACT(v_per_price_json_array  , CONCAT('$[', i - 1, ']')));
	INSERT INTO orders 
			(order_amount,
			total_price,
			per_price,
			product_code,
			orderlist_num)
	VALUES (product_num_value,
			product_num_value*per_price_value,
			per_price_value,
			product_code_value,
			v_last_num);
		SET v_result_value = FOUND_ROWS();
			IF v_result_value != 1 THEN 
				-- 오류 발생 시 롤백
				rollback;
				
			END IF;
		SET i = i + 1;
	END WHILE;
    -- 트랜잭션 커밋
        COMMIT;
    ELSE
    -- 주문서 등록 실패 시 롤백
        ROLLBACK;
END IF;
END//
DELIMITER ;

-- 테이블 natureblend.orderlists 구조 내보내기
CREATE TABLE IF NOT EXISTS `orderlists` (
  `orderlist_num` int(11) NOT NULL AUTO_INCREMENT,
  `orderlist_title` varchar(50) NOT NULL,
  `order_date` datetime NOT NULL DEFAULT current_timestamp(),
  `due_date` datetime NOT NULL,
  `orderlist_status` varchar(20) NOT NULL DEFAULT 'update' COMMENT '등록:update, 진행중::continue  완료:done',
  `emp_num` int(11) NOT NULL,
  `client_num` int(30) NOT NULL,
  PRIMARY KEY (`orderlist_num`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- 테이블 데이터 natureblend.orderlists:~7 rows (대략적) 내보내기
INSERT INTO `orderlists` (`orderlist_num`, `orderlist_title`, `order_date`, `due_date`, `orderlist_status`, `emp_num`, `client_num`) VALUES
	(90, '광주포도페스티벌', '2025-01-05 12:41:12', '2025-06-14 00:00:00', 'update', 20250008, 4),
	(91, '대구동성로오렌지축제', '2025-01-03 12:41:43', '2025-05-10 00:00:00', 'update', 20250008, 5),
	(92, '대구사과축제', '2025-01-04 12:42:26', '2025-06-15 00:00:00', 'continue', 20250004, 6),
	(93, '대구고등학교축제', '2025-01-02 12:44:08', '2025-06-22 00:00:00', 'update', 20250003, 6),
	(94, '경로마을축제', '2025-01-07 12:44:51', '2025-08-10 00:00:00', 'update', 20250002, 5),
	(95, '레모나축제', '2025-01-07 12:45:47', '2025-04-20 00:00:00', 'update', 20250004, 4),
	(99, '대구치맥페스티벌', '2025-01-08 17:40:45', '2025-05-03 00:00:00', 'continue', 20250008, 35);

-- 테이블 natureblend.orders 구조 내보내기
CREATE TABLE IF NOT EXISTS `orders` (
  `order_num` int(11) NOT NULL AUTO_INCREMENT,
  `order_amount` int(11) NOT NULL DEFAULT 0,
  `total_price` int(11) NOT NULL DEFAULT 0 COMMENT '주문수 * 개당금액',
  `order_status` varchar(20) NOT NULL DEFAULT 'preparing' COMMENT '미출고:preparing,  부분출고: semiShipped , 출고완료:shipped , 재고대기중: stockWaiting',
  `per_price` int(11) NOT NULL DEFAULT 0,
  `product_code` varchar(30) NOT NULL,
  `orderlist_num` int(11) NOT NULL,
  PRIMARY KEY (`order_num`)
) ENGINE=InnoDB AUTO_INCREMENT=129 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- 테이블 데이터 natureblend.orders:~12 rows (대략적) 내보내기
INSERT INTO `orders` (`order_num`, `order_amount`, `total_price`, `order_status`, `per_price`, `product_code`, `orderlist_num`) VALUES
	(112, 150, 225000, 'preparing', 1500, 'P002', 90),
	(113, 250, 250000, 'preparing', 1000, 'P001', 90),
	(114, 150, 165000, 'preparing', 1100, 'P007', 91),
	(115, 250, 500000, 'preparing', 2000, 'P008', 91),
	(116, 150, 225000, 'semiShipped', 1500, 'P004', 92),
	(117, 250, 500000, 'shipped', 2000, 'P005', 92),
	(118, 350, 350000, 'preparing', 1000, 'P013', 93),
	(119, 300, 450000, 'preparing', 1500, 'P016', 94),
	(120, 150, 180000, 'preparing', 1200, 'P010', 95),
	(121, 250, 375000, 'preparing', 1500, 'P011', 95),
	(122, 200, 600000, 'preparing', 3000, 'P006', 92),
	(128, 50, 50000, 'semiShipped', 1000, 'P016', 99);

-- 프로시저 natureblend.orderUpdate 구조 내보내기
DELIMITER //
CREATE PROCEDURE `orderUpdate`(
IN v_orderlist_num INT,
IN v_orderlist_title VARCHAR(50),
IN v_due_date DATETIME,

IN v_order_code_json_array TEXT,
IN v_product_code_json_array TEXT,
IN v_product_num_json_array TEXT,
IN v_per_price_json_array TEXT

)
BEGIN
DECLARE v_result_value INT;

DECLARE i INT DEFAULT 1;
DECLARE product_code_array_length INT;
DECLARE product_code_value TEXT;
DECLARE product_num_value TEXT;
DECLARE per_price_value TEXT;
DECLARE order_code_value TEXT;
DECLARE v_change_num INT;

-- 트렌젝션 시작
START TRANSACTION;

-- JSON 배열 길이 계산
SET product_code_array_length = JSON_LENGTH(v_product_code_json_array);

-- 주문서 수정 
UPDATE orderlists
SET orderlist_title = v_orderlist_title,
	due_date = v_due_date
WHERE orderlist_num = v_orderlist_num;

-- 주문 수정 
-- 반복으로  json 배열 요소 추출 
WHILE i <= product_code_array_length DO
	SET product_num_value  = JSON_UNQUOTE(JSON_EXTRACT(v_product_num_json_array , CONCAT('$[', i - 1, ']')));
    SET per_price_value   = JSON_UNQUOTE(JSON_EXTRACT(v_per_price_json_array  , CONCAT('$[', i - 1, ']')));
    SET order_code_value = JSON_UNQUOTE(JSON_EXTRACT(v_order_code_json_array  , CONCAT('$[', i - 1, ']')));
    SET product_code_value = JSON_UNQUOTE(JSON_EXTRACT(v_product_code_json_array  , CONCAT('$[', i - 1, ']')));
    -- 주문정보 업데이트 
    UPDATE orders
	SET order_amount = product_num_value,
		product_code = product_code_value,
		per_price = per_price_value,
        total_price = product_num_value *  per_price_value
	WHERE orderlist_num = v_orderlist_num AND order_num = order_code_value;
    
    -- 변경된 행 체크 
    SET v_change_num = ROW_COUNT();
			IF v_change_num != 1 THEN 
						-- 오류 발생 시 롤백
					rollback;
			END IF;
	  SET i = i + 1;
	END WHILE;
    -- 문제없을때
    COMMIT;
    -- 문제있을때
    ROLLBACK;
END//
DELIMITER ;

-- 프로시저 natureblend.orderUpdateInput 구조 내보내기
DELIMITER //
CREATE PROCEDURE `orderUpdateInput`(
IN v_orderlist_num INT,
IN v_product_code_json_array TEXT,
IN v_product_num_json_array TEXT,
IN v_per_price_json_array TEXT
)
BEGIN
	DECLARE i INT DEFAULT 1;
	DECLARE product_code_array_length INT;
	DECLARE product_code_value TEXT;
	DECLARE product_num_value TEXT;
	DECLARE per_price_value TEXT;
    DECLARE v_result_value INT;
    

    -- 트렌젝션 시작
    START TRANSACTION;
    
    SET product_code_array_length = JSON_LENGTH(v_product_code_json_array);
	
    -- 주문등록
    WHILE i <= product_code_array_length DO
    SET product_code_value  = JSON_UNQUOTE(JSON_EXTRACT(v_product_code_json_array , CONCAT('$[', i - 1, ']')));
    SET product_num_value   = JSON_UNQUOTE(JSON_EXTRACT(v_product_num_json_array  , CONCAT('$[', i - 1, ']')));
    SET per_price_value   = JSON_UNQUOTE(JSON_EXTRACT(v_per_price_json_array  , CONCAT('$[', i - 1, ']')));
	INSERT INTO orders 
				(orderlist_num,
                order_amount,
                per_price,
                total_price,
                product_code)
	VALUES  (v_orderlist_num,
			product_num_value,
            per_price_value,
            product_num_value*per_price_value,
            product_code_value);
	SET v_result_value = ROW_COUNT();
		IF v_result_value != 1 THEN 
				-- 오류 발생 시 롤백
				rollback;
		END IF;
		SET i = i + 1;
	END WHILE;
    
       -- 주문 상태 업데이트
    IF EXISTS (SELECT 1 FROM orderlists 
				WHERE orderlist_num = v_orderlist_num AND orderlist_status = 'done') 
	THEN
        UPDATE orderlists
        SET orderlist_status = 'continue'
        WHERE orderlist_num = v_orderlist_num AND orderlist_status = 'done';
    END IF;
    
    -- 문제없을때
    COMMIT;
    -- 문제있을때
    ROLLBACK;
END//
DELIMITER ;

-- 테이블 natureblend.order_plan_relation 구조 내보내기
CREATE TABLE IF NOT EXISTS `order_plan_relation` (
  `order_plan_num` int(11) NOT NULL AUTO_INCREMENT,
  `plan_num` int(11) NOT NULL,
  `order_num` int(11) NOT NULL,
  `product_code` varchar(50) NOT NULL,
  `plan_qty` int(11) NOT NULL,
  PRIMARY KEY (`order_plan_num`)
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- 테이블 데이터 natureblend.order_plan_relation:~19 rows (대략적) 내보내기
INSERT INTO `order_plan_relation` (`order_plan_num`, `plan_num`, `order_num`, `product_code`, `plan_qty`) VALUES
	(66, 1, 117, 'P005', 250),
	(67, 1, 118, 'P013', 350),
	(68, 3, 120, 'P010', 150),
	(69, 4, 113, 'P001', 250),
	(70, 5, 114, 'P007', 150),
	(71, 6, 119, 'P016', 150),
	(72, 7, 113, 'P001', 250),
	(73, 8, 120, 'P010', 150),
	(74, 9, 118, 'P013', 250),
	(75, 10, 116, 'P004', 150),
	(76, 11, 113, 'P001', 500),
	(77, 11, 114, 'P007', 150),
	(78, 13, 112, 'P002', 150),
	(79, 13, 115, 'P008', 250),
	(80, 15, 116, 'P004', 150),
	(81, 15, 115, 'P008', 250),
	(82, 17, 121, 'P011', 250),
	(83, 17, 122, 'P006', 200),
	(84, 19, 119, 'P016', 150);

-- 테이블 natureblend.output 구조 내보내기
CREATE TABLE IF NOT EXISTS `output` (
  `output_num` int(11) NOT NULL AUTO_INCREMENT,
  `client_num` int(11) NOT NULL,
  `product_code` varchar(30) NOT NULL,
  `output_amount` int(11) NOT NULL DEFAULT 0,
  `output_date` datetime NOT NULL DEFAULT current_timestamp(),
  `input_num` int(11) NOT NULL,
  `order_num` int(11) NOT NULL,
  `emp_num` int(11) NOT NULL,
  PRIMARY KEY (`output_num`)
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- 테이블 데이터 natureblend.output:~4 rows (대략적) 내보내기
INSERT INTO `output` (`output_num`, `client_num`, `product_code`, `output_amount`, `output_date`, `input_num`, `order_num`, `emp_num`) VALUES
	(62, 6, 'P005', 240, '2025-01-07 14:11:34', 39, 117, 20250004),
	(63, 6, 'P005', 10, '2025-01-07 14:22:36', 40, 117, 20250014),
	(64, 6, 'P004', 50, '2025-01-08 10:49:08', 42, 116, 20250004),
	(68, 35, 'P016', 10, '2025-01-08 17:41:47', 46, 128, 20250008);

-- 프로시저 natureblend.outputProduct 구조 내보내기
DELIMITER //
CREATE PROCEDURE `outputProduct`(
IN v_product_lot_json_array TEXT,
IN v_output_amount_json_array TEXT,
IN v_order_num INT,
IN v_com_name VARCHAR(30),
IN v_emp_name VARCHAR(30)
)
BEGIN
DECLARE product_lot_array_length INT;
DECLARE product_lot_value TEXT;
DECLARE i INT DEFAULT 1;


DECLARE v_com_num INT;
DECLARE v_emp_num INT;
DECLARE output_amount_value TEXT;
DECLARE v_product_code VARCHAR(30);
DECLARE input_num_value TEXT;
DECLARE v_result_value INT;

    -- 트렌젝션 시작
    START TRANSACTION;

-- 회사번호 (회사이름)
SELECT client_num
INTO v_com_num
FROM client
WHERE com_name = v_com_name
GROUP BY client_num
LIMIT 1;

-- 사원번호 (사원이름)
SELECT emp_num
INTO v_emp_num
FROM employee
WHERE name = v_emp_name
GROUP BY emp_num
LIMIT 1;

SET product_lot_array_length = JSON_LENGTH(v_product_lot_json_array);
WHILE i <= product_lot_array_length DO
	SET product_lot_value = JSON_UNQUOTE(JSON_EXTRACT(v_product_lot_json_array, CONCAT('$[', i - 1, ']')));
    SET output_amount_value = JSON_UNQUOTE(JSON_EXTRACT(v_output_amount_json_array, CONCAT('$[', i - 1, ']')));
   
-- 제품코드  
SELECT product_code , input_num
INTO v_product_code , input_num_value
FROM input_body
WHERE product_lot = product_lot_value
LIMIT 1;

-- 출고테이블 추가 
INSERT INTO output
				(client_num
                ,product_code
                ,output_amount
                ,input_num
                ,order_num
                ,emp_num)
VALUES (v_com_num
	   ,v_product_code
       ,output_amount_value
       ,input_num_value
       ,v_order_num
       ,v_emp_num);
	SET v_result_value = ROW_COUNT();
			IF v_result_value != 1 THEN 
				-- 오류 발생 시 롤백
				rollback;
				
			END IF;
	SET i = i + 1;
END WHILE;
-- 주문번호 의 상태 업데이트 만약  order_amount = output_amount 경우 "shipped" , order_amount > output_amount 경우 "semiShipped" , output_amount 가 0이거나 null인 경우 "preparing" 
-- 주문 상태 업데이트
UPDATE orders
SET order_status = 
	CASE 
		WHEN order_amount = (
			SELECT SUM(output_amount)
			FROM output
			WHERE order_num = v_order_num
		) THEN 'shipped'
		WHEN order_amount > (
			SELECT SUM(output_amount)
			FROM output
			WHERE order_num = v_order_num
		) AND (
			SELECT SUM(output_amount)
			FROM output
			WHERE order_num = v_order_num
		) > 0 THEN 'semiShipped'
		ELSE 'preparing'
	END
WHERE order_num = v_order_num;
-- 주문 번호 업데이트 후 주문서 상태 업데이트 만약 주문서의 주문들 중 하나라도 shipped , semiShipped가 있는 경우 "continue"로 변경 , 주문 모두 shipped의 경우 "done"으로 변경  
-- 주문서 상태 업데이트

UPDATE orderlists ol
JOIN orders o ON o.orderlist_num = ol.orderlist_num
SET ol.orderlist_status = 
    CASE 
		WHEN (
				SELECT COUNT(*) 
				FROM orders 
				WHERE orderlist_num = ol.orderlist_num 
				  AND order_status != 'shipped'
			) = 0 THEN 'done'
        WHEN (
            SELECT COUNT(*) 
            FROM orders 
            WHERE orderlist_num = ol.orderlist_num 
              AND order_status IN ('shipped', 'semiShipped')
        ) > 0 THEN 'continue'
        ELSE ol.orderlist_status
    END
WHERE o.order_num = v_order_num;     

    -- 문제없을때
    COMMIT;

END//
DELIMITER ;

-- 테이블 natureblend.process 구조 내보내기
CREATE TABLE IF NOT EXISTS `process` (
  `process_code` varchar(30) NOT NULL,
  `process_name` varchar(30) NOT NULL,
  `machine_type` varchar(30) NOT NULL COMMENT 'a1 세척기기, a2 음료제작기기, a3 포장기기',
  PRIMARY KEY (`process_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- 테이블 데이터 natureblend.process:~3 rows (대략적) 내보내기
INSERT INTO `process` (`process_code`, `process_name`, `machine_type`) VALUES
	('p1', '병세척공정', '세척기기'),
	('p2', '음료제작공정', '음료제작기기'),
	('p3', '포장공정', '포장기기');

-- 테이블 natureblend.process_chart 구조 내보내기
CREATE TABLE IF NOT EXISTS `process_chart` (
  `process_chart_num` int(11) NOT NULL AUTO_INCREMENT,
  `product_code` varchar(30) DEFAULT NULL,
  `process_code` varchar(30) NOT NULL,
  `process_sequence` int(11) DEFAULT NULL,
  `process_name` varchar(30) NOT NULL,
  PRIMARY KEY (`process_chart_num`)
) ENGINE=InnoDB AUTO_INCREMENT=189 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- 테이블 데이터 natureblend.process_chart:~66 rows (대략적) 내보내기
INSERT INTO `process_chart` (`process_chart_num`, `product_code`, `process_code`, `process_sequence`, `process_name`) VALUES
	(54, 'P001', 'p1', 2, '병세척공정'),
	(55, 'P001', 'p2', 1, '음료제작공정'),
	(61, 'P002', 'p2', 1, '음료제작공정'),
	(62, 'P002', 'p3', 3, '포장공정'),
	(63, 'P018', 'p1', 2, '병세척공정'),
	(64, 'P018', 'p2', 1, '음료제작공정'),
	(65, 'P004', 'p1', 2, '병세척공정'),
	(66, 'P004', 'p2', 1, '음료제작공정'),
	(67, 'P004', 'p3', 3, '포장공정'),
	(68, 'P005', 'p1', 2, '병세척공정'),
	(69, 'P005', 'p2', 1, '음료제작공정'),
	(70, 'P005', 'p3', 3, '포장공정'),
	(90, 'P001', 'p3', 3, '포장공정'),
	(115, 'P010', 'p1', 2, '병세척공정'),
	(118, 'P099', 'p1', 2, '병세척공정'),
	(119, 'P099', 'p2', 1, '음료제작공정'),
	(120, 'P099', 'p3', 3, '포장공정'),
	(125, 'P010', 'p2', 1, '음료제작공정'),
	(126, 'P010', 'p3', 3, '포장공정'),
	(127, 'P016', 'p2', 1, '음료제작공정'),
	(128, 'P016', 'p1', 2, '병세척공정'),
	(129, 'P016', 'p3', 3, '포장공정'),
	(130, 'P100', 'p1', 2, '병세척공정'),
	(131, 'P100', 'p2', 1, '음료제작공정'),
	(132, 'P100', 'p3', 3, '포장공정'),
	(133, 'P017', 'p2', 1, '음료제작공정'),
	(134, 'P017', 'p1', 2, '병세척공정'),
	(135, 'P017', 'p3', 3, '포장공정'),
	(136, 'P018', 'p3', 3, '포장공정'),
	(137, 'P015', 'p2', 1, '음료제작공정'),
	(138, 'P015', 'p1', 2, '병세척공정'),
	(139, 'P015', 'p3', 3, '포장공정'),
	(140, 'P014', 'p2', 1, '음료제작공정'),
	(141, 'P014', 'p1', 2, '병세척공정'),
	(142, 'P014', 'p3', 3, '포장공정'),
	(143, 'P013', 'p2', 1, '음료제작공정'),
	(144, 'P013', 'p1', 2, '병세척공정'),
	(145, 'P013', 'p3', 3, '포장공정'),
	(146, 'P012', 'p2', 1, '음료제작공정'),
	(147, 'P012', 'p1', 2, '병세척공정'),
	(148, 'P012', 'p3', 3, '포장공정'),
	(149, 'P011', 'p2', 1, '음료제작공정'),
	(150, 'P011', 'p1', 2, '병세척공정'),
	(151, 'P011', 'p3', 3, '포장공정'),
	(152, 'P009', 'p2', 1, '음료제작공정'),
	(153, 'P009', 'p1', 2, '병세척공정'),
	(154, 'P009', 'p3', 3, '포장공정'),
	(155, 'P008', 'p2', 1, '음료제작공정'),
	(156, 'P008', 'p1', 2, '병세척공정'),
	(157, 'P008', 'p3', 3, '포장공정'),
	(158, 'P007', 'p2', 1, '음료제작공정'),
	(159, 'P007', 'p1', 2, '병세척공정'),
	(160, 'P007', 'p3', 3, '포장공정'),
	(161, 'P006', 'p2', 1, '음료제작공정'),
	(162, 'P006', 'p1', 2, '병세척공정'),
	(163, 'P006', 'p3', 3, '포장공정'),
	(164, 'P003', 'p2', 1, '음료제작공정'),
	(165, 'P003', 'p1', 2, '병세척공정'),
	(166, 'P003', 'p3', 3, '포장공정'),
	(167, 'P002', 'p1', 2, '병세척공정'),
	(169, 'testcode', 'p1', 3, '병세척공정'),
	(171, 'testcode', 'p2', 2, '음료제작공정'),
	(173, 'testcode', 'p3', 1, '포장공정'),
	(186, 'P019', 'p1', 2, '병세척공정'),
	(187, 'P019', 'p2', 1, '음료제작공정'),
	(188, 'P019', 'p3', 3, '포장공정');

-- 테이블 natureblend.process_work_body 구조 내보내기
CREATE TABLE IF NOT EXISTS `process_work_body` (
  `process_num` int(11) NOT NULL AUTO_INCREMENT COMMENT 'auto_increment',
  `process_work_header_num` int(11) NOT NULL COMMENT 'auto_increment',
  `emp_num` int(11) DEFAULT NULL,
  `machine_num` int(11) DEFAULT NULL,
  `partial_process_status` varchar(50) NOT NULL DEFAULT 'partial_process_waiting' COMMENT '진행 전(partial_process_waiting), 진행중(partial_processing), 완료(partial_process_complete)',
  `process_todo_qty` int(11) DEFAULT NULL,
  `process_complete_qty` int(11) DEFAULT NULL,
  `fail_qty` int(11) DEFAULT NULL,
  `success_qty` int(11) DEFAULT NULL,
  `partial_process_start_time` datetime DEFAULT NULL,
  `partial_process_end_time` datetime DEFAULT NULL,
  `is_inspected` varchar(5) NOT NULL DEFAULT '0' COMMENT 'true/false',
  `product_code` varchar(50) NOT NULL,
  PRIMARY KEY (`process_num`)
) ENGINE=InnoDB AUTO_INCREMENT=186 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- 테이블 데이터 natureblend.process_work_body:~46 rows (대략적) 내보내기
INSERT INTO `process_work_body` (`process_num`, `process_work_header_num`, `emp_num`, `machine_num`, `partial_process_status`, `process_todo_qty`, `process_complete_qty`, `fail_qty`, `success_qty`, `partial_process_start_time`, `partial_process_end_time`, `is_inspected`, `product_code`) VALUES
	(140, 88, 20250009, 83, 'partial_process_complete', 100, NULL, 0, 100, '2025-01-07 13:00:01', '2025-01-07 13:04:24', '0', 'P005'),
	(141, 88, 20250009, 83, 'partial_process_complete', 150, NULL, 0, 150, '2025-01-07 13:04:45', '2025-01-07 13:05:26', '0', 'P005'),
	(142, 89, 20250010, 85, 'partial_process_complete', 250, NULL, 60, 190, '2025-01-07 13:06:15', '2025-01-07 13:06:43', '0', 'P005'),
	(143, 89, 20250009, 85, 'partial_process_complete', 100, NULL, 0, 100, '2025-01-07 13:07:36', '2025-01-07 13:09:55', '0', 'P005'),
	(144, 90, 20250009, 84, 'partial_process_complete', 250, NULL, 10, 240, '2025-01-07 13:10:09', '2025-01-07 13:10:34', '0', 'P005'),
	(145, 90, 20250007, 84, 'partial_process_complete', 10, NULL, 0, 10, '2025-01-07 13:10:53', '2025-01-07 13:11:09', '0', 'P005'),
	(146, 91, 20250001, 83, 'partial_process_complete', 250, NULL, 0, 250, '2025-01-07 14:36:04', '2025-01-07 14:38:31', '0', 'P001'),
	(147, 92, 20250009, 91, 'partial_process_complete', 250, NULL, 0, 250, '2025-01-07 14:39:00', '2025-01-07 14:39:13', '0', 'P001'),
	(148, 93, 20250001, 87, 'partial_process_complete', 250, NULL, 0, 250, '2025-01-07 14:39:22', '2025-01-07 14:39:45', '0', 'P001'),
	(149, 97, 20250010, 89, 'partial_process_complete', 50, NULL, 0, 50, '2025-01-07 15:21:29', '2025-01-07 15:31:19', '0', 'P010'),
	(150, 97, 20250010, 89, 'partial_process_complete', 30, NULL, 0, 30, '2025-01-07 15:21:50', '2025-01-07 15:52:44', '0', 'P010'),
	(151, 97, 20250001, 86, 'partial_process_complete', 20, NULL, 20, 0, '2025-01-07 15:22:00', '2025-01-07 15:48:39', '0', 'P010'),
	(152, 98, 20250007, 82, 'partial_processing', 10, NULL, 0, 10, '2025-01-07 15:53:21', NULL, '0', 'P010'),
	(153, 98, 20250009, 85, 'partial_processing', 15, NULL, 0, 15, '2025-01-07 15:53:28', NULL, '0', 'P010'),
	(154, 98, 20250010, 88, 'partial_process_complete', 20, NULL, 0, 20, '2025-01-07 15:53:36', '2025-01-07 18:14:53', '0', 'P010'),
	(155, 98, 20250001, 112, 'partial_process_complete', 35, NULL, 0, 35, '2025-01-07 15:57:01', '2025-01-07 17:12:41', '0', 'P010'),
	(156, 109, 20250001, 83, 'partial_process_complete', 75, NULL, 0, 75, '2025-01-07 16:22:16', '2025-01-07 16:33:06', '0', 'P016'),
	(157, 109, 20250007, 86, 'partial_processing', 25, NULL, 0, 25, '2025-01-07 16:22:38', NULL, '0', 'P016'),
	(158, 109, 20250009, 86, 'partial_processing', 50, NULL, 0, 50, '2025-01-07 16:25:10', NULL, '0', 'P016'),
	(159, 110, 20250009, 85, 'partial_process_complete', 25, NULL, 0, 25, '2025-01-07 16:40:30', '2025-01-07 17:09:05', '0', 'P016'),
	(160, 112, 20250009, 89, 'partial_process_complete', 150, NULL, 0, 150, '2025-01-07 16:41:12', '2025-01-07 16:41:43', '0', 'P007'),
	(161, 115, 20250010, 86, 'partial_processing', 100, NULL, 0, 100, '2025-01-07 16:47:25', NULL, '0', 'P007'),
	(162, 110, 20250010, 112, 'partial_processing', 50, NULL, 0, 50, '2025-01-07 16:54:59', NULL, '0', 'P016'),
	(163, 111, 20250001, 87, 'partial_process_complete', 10, NULL, 0, 10, '2025-01-07 18:19:02', '2025-01-08 03:11:16', '0', 'P016'),
	(164, 111, 20250010, 90, 'partial_process_complete', 15, NULL, 0, 15, '2025-01-07 18:19:08', '2025-01-08 02:46:02', '0', 'P016'),
	(165, 99, 20250007, 84, 'partial_processing', 5, NULL, 0, 5, '2025-01-07 18:19:56', NULL, '0', 'P010'),
	(166, 99, 20250009, 90, 'partial_process_complete', 10, NULL, 0, 10, '2025-01-07 18:20:06', '2025-01-08 03:12:30', '0', 'P010'),
	(167, 99, 20250001, 84, 'partial_processing', 30, NULL, 0, 30, '2025-01-07 18:20:24', NULL, '0', 'P010'),
	(168, 99, NULL, NULL, 'partial_process_waiting', NULL, NULL, NULL, NULL, NULL, NULL, '0', 'P010'),
	(169, 118, 20250009, 89, 'partial_process_complete', 150, NULL, 0, 150, '2025-01-08 10:46:42', '2025-01-08 10:48:09', '0', 'P004'),
	(170, 119, 20250007, 85, 'partial_process_complete', 150, NULL, 0, 150, '2025-01-08 10:46:52', '2025-01-08 10:48:12', '0', 'P004'),
	(171, 120, 20250007, 84, 'partial_process_complete', 150, NULL, 0, 150, '2025-01-08 10:47:02', '2025-01-08 10:48:14', '0', 'P004'),
	(172, 121, 20250009, 89, 'partial_process_complete', 250, NULL, 0, 250, '2025-01-08 11:44:07', '2025-01-08 11:44:48', '0', 'P013'),
	(173, 122, 20250007, 85, 'partial_processing', 250, NULL, 5, 245, '2025-01-08 11:44:26', NULL, '0', 'P013'),
	(174, 123, 20250007, 90, 'partial_process_complete', 100, NULL, 5, 95, '2025-01-08 11:55:16', '2025-01-08 11:57:48', '0', 'P013'),
	(175, 116, NULL, NULL, 'partial_process_waiting', NULL, NULL, NULL, NULL, NULL, NULL, '0', 'P007'),
	(176, 123, 20250007, 90, 'partial_processing', 100, NULL, NULL, NULL, '2025-01-08 11:58:22', NULL, '0', 'P013'),
	(177, 123, NULL, NULL, 'partial_process_waiting', NULL, NULL, NULL, NULL, NULL, NULL, '0', 'P013'),
	(178, 124, 20250001, 86, 'partial_processing', 500, NULL, NULL, NULL, '2025-01-08 17:01:47', NULL, '0', 'P001'),
	(179, 128, 20250009, 88, 'partial_processing', 500, NULL, NULL, NULL, '2025-01-08 17:02:12', NULL, '0', 'P002'),
	(180, 130, 20250001, 89, 'partial_process_complete', 100, NULL, 0, 100, '2025-01-08 17:09:36', '2025-01-08 17:09:42', '0', 'P004'),
	(181, 130, 20250007, 89, 'partial_process_complete', 50, NULL, 0, 50, '2025-01-08 17:09:56', '2025-01-08 17:10:01', '0', 'P004'),
	(182, 133, 20250009, 86, 'partial_process_complete', 100, NULL, 100, 0, '2025-01-08 17:34:33', '2025-01-08 17:34:47', '0', 'P006'),
	(183, 133, NULL, NULL, 'partial_process_waiting', NULL, NULL, NULL, NULL, NULL, NULL, '0', 'P006'),
	(184, 136, 20250009, 89, 'partial_process_complete', 100, NULL, 0, 100, '2025-01-08 17:36:26', '2025-01-08 17:36:32', '0', 'P016'),
	(185, 136, 20250007, 89, 'partial_process_complete', 50, NULL, 50, 0, '2025-01-08 17:36:42', '2025-01-08 17:36:45', '0', 'P016');

-- 테이블 natureblend.process_work_header 구조 내보내기
CREATE TABLE IF NOT EXISTS `process_work_header` (
  `process_work_header_num` int(11) NOT NULL AUTO_INCREMENT COMMENT 'auto_increment',
  `production_order_num` int(11) NOT NULL,
  `production_order_name` varchar(50) NOT NULL,
  `production_order_qty` int(11) NOT NULL,
  `product_code` varchar(50) NOT NULL,
  `product_name` varchar(50) NOT NULL,
  `capacity` int(11) NOT NULL,
  `process_code` varchar(20) NOT NULL,
  `process_name` varchar(50) NOT NULL,
  `machine_type` varchar(50) NOT NULL,
  `process_status` varchar(50) NOT NULL DEFAULT 'process_waiting' COMMENT '진행 전(process_waiting), 진행중(processing), 완료(process_complete)',
  `process_start_time` datetime DEFAULT NULL,
  `process_end_time` datetime DEFAULT NULL,
  `work_date` datetime NOT NULL,
  PRIMARY KEY (`process_work_header_num`)
) ENGINE=InnoDB AUTO_INCREMENT=139 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- 테이블 데이터 natureblend.process_work_header:~39 rows (대략적) 내보내기
INSERT INTO `process_work_header` (`process_work_header_num`, `production_order_num`, `production_order_name`, `production_order_qty`, `product_code`, `product_name`, `capacity`, `process_code`, `process_name`, `machine_type`, `process_status`, `process_start_time`, `process_end_time`, `work_date`) VALUES
	(88, 43, '애플팜 생산 지시', 250, 'P005', '애플팜 (750ml)', 750, 'p2', '음료제작공정', '음료제작기기', 'process_complete', '2025-01-07 13:00:01', '2025-01-07 13:05:26', '2025-01-07 00:00:00'),
	(89, 43, '애플팜 생산 지시', 250, 'P005', '애플팜 (750ml)', 750, 'p1', '병세척공정', '세척기기', 'process_complete', '2025-01-07 13:06:15', '2025-01-07 13:09:55', '2025-01-07 00:00:00'),
	(90, 43, '애플팜 생산 지시', 250, 'P005', '애플팜 (750ml)', 750, 'p3', '포장공정', '포장기기', 'process_complete', '2025-01-07 13:10:09', '2025-01-07 13:11:09', '2025-01-07 00:00:00'),
	(91, 44, '포도주스 지시', 250, 'P001', '포도17 (500ml)', 500, 'p2', '음료제작공정', '음료제작기기', 'process_complete', '2025-01-07 14:36:04', '2025-01-07 14:38:31', '2025-01-07 00:00:00'),
	(92, 44, '포도주스 지시', 250, 'P001', '포도17 (500ml)', 500, 'p1', '병세척공정', '세척기기', 'process_complete', '2025-01-07 14:39:00', '2025-01-07 14:39:13', '2025-01-07 00:00:00'),
	(93, 44, '포도주스 지시', 250, 'P001', '포도17 (500ml)', 500, 'p3', '포장공정', '포장기기', 'process_complete', '2025-01-07 14:39:22', '2025-01-07 14:39:45', '2025-01-07 00:00:00'),
	(97, 46, '레몬지시', 100, 'P010', '레몬의꿈 (500ml)', 500, 'p2', '음료제작공정', '음료제작기기', 'process_complete', '2025-01-07 15:21:29', '2025-01-07 16:07:26', '2025-01-08 00:00:00'),
	(98, 46, '레몬지시', 100, 'P010', '레몬의꿈 (500ml)', 500, 'p1', '병세척공정', '세척기기', 'processing', '2025-01-07 15:53:21', NULL, '2025-01-08 00:00:00'),
	(99, 46, '레몬지시', 100, 'P010', '레몬의꿈 (500ml)', 500, 'p3', '포장공정', '포장기기', 'processing', '2025-01-07 18:19:56', NULL, '2025-01-08 00:00:00'),
	(109, 51, '바니바니 바니바니?', 150, 'P016', '당근이세요? (500ml)', 500, 'p2', '음료제작공정', '음료제작기기', 'processing', '2025-01-07 16:22:16', NULL, '2025-01-07 00:00:00'),
	(110, 51, '바니바니 바니바니?', 150, 'P016', '당근이세요? (500ml)', 500, 'p1', '병세척공정', '세척기기', 'processing', '2025-01-07 16:40:30', NULL, '2025-01-07 00:00:00'),
	(111, 51, '바니바니 바니바니?', 150, 'P016', '당근이세요? (500ml)', 500, 'p3', '포장공정', '포장기기', 'processing', '2025-01-07 18:19:02', NULL, '2025-01-07 00:00:00'),
	(112, 52, '쥬시쥬시', 150, 'P007', '오렌쥬시 (500ml)', 500, 'p2', '음료제작공정', '음료제작기기', 'process_complete', '2025-01-07 16:41:12', '2025-01-07 16:41:43', '2025-01-07 00:00:00'),
	(113, 52, '쥬시쥬시', 150, 'P007', '오렌쥬시 (500ml)', 500, 'p1', '병세척공정', '세척기기', 'process_waiting', NULL, '2025-01-07 16:41:43', '2025-01-07 00:00:00'),
	(114, 52, '쥬시쥬시', 150, 'P007', '오렌쥬시 (500ml)', 500, 'p3', '포장공정', '포장기기', 'process_waiting', NULL, NULL, '2025-01-07 00:00:00'),
	(115, 53, '쥬시두번째 지시', 100, 'P007', '오렌쥬시 (500ml)', 500, 'p2', '음료제작공정', '음료제작기기', 'processing', '2025-01-07 16:47:25', NULL, '2025-01-07 00:00:00'),
	(116, 53, '쥬시두번째 지시', 100, 'P007', '오렌쥬시 (500ml)', 500, 'p1', '병세척공정', '세척기기', 'process_waiting', NULL, NULL, '2025-01-07 00:00:00'),
	(117, 53, '쥬시두번째 지시', 100, 'P007', '오렌쥬시 (500ml)', 500, 'p3', '포장공정', '포장기기', 'process_waiting', NULL, NULL, '2025-01-07 00:00:00'),
	(118, 54, '사과주스 지시', 150, 'P004', '애플팜 (500ml)', 500, 'p2', '음료제작공정', '음료제작기기', 'process_complete', '2025-01-08 10:46:42', '2025-01-08 10:48:09', '2025-01-17 00:00:00'),
	(119, 54, '사과주스 지시', 150, 'P004', '애플팜 (500ml)', 500, 'p1', '병세척공정', '세척기기', 'process_complete', '2025-01-08 10:46:52', '2025-01-08 10:48:12', '2025-01-17 00:00:00'),
	(120, 54, '사과주스 지시', 150, 'P004', '애플팜 (500ml)', 500, 'p3', '포장공정', '포장기기', 'process_complete', '2025-01-08 10:47:02', '2025-01-08 10:48:14', '2025-01-17 00:00:00'),
	(121, 55, '망고500ml 지시', 250, 'P013', '아이망고 (500ml)', 500, 'p2', '음료제작공정', '음료제작기기', 'process_complete', '2025-01-08 11:44:07', '2025-01-08 11:44:48', '2025-01-10 00:00:00'),
	(122, 55, '망고500ml 지시', 250, 'P013', '아이망고 (500ml)', 500, 'p1', '병세척공정', '세척기기', 'processing', '2025-01-08 11:44:26', NULL, '2025-01-10 00:00:00'),
	(123, 55, '망고500ml 지시', 250, 'P013', '아이망고 (500ml)', 500, 'p3', '포장공정', '포장기기', 'processing', '2025-01-08 11:55:16', NULL, '2025-01-10 00:00:00'),
	(124, 56, '포도주스 지시', 500, 'P001', '포도17 (500ml)', 500, 'p2', '음료제작공정', '음료제작기기', 'processing', '2025-01-08 17:01:47', NULL, '2025-01-08 00:00:00'),
	(125, 56, '포도주스 지시', 500, 'P001', '포도17 (500ml)', 500, 'p1', '병세척공정', '세척기기', 'process_waiting', NULL, NULL, '2025-01-08 00:00:00'),
	(126, 56, '포도주스 지시', 500, 'P001', '포도17 (500ml)', 500, 'p3', '포장공정', '포장기기', 'process_waiting', NULL, NULL, '2025-01-08 00:00:00'),
	(127, 57, '포도주스 지시', 150, 'P002', '포도17 (750ml)', 750, 'p2', '음료제작공정', '음료제작기기', 'process_waiting', NULL, NULL, '2025-01-08 00:00:00'),
	(128, 57, '포도주스 지시', 150, 'P002', '포도17 (750ml)', 750, 'p1', '병세척공정', '세척기기', 'processing', '2025-01-08 17:02:12', NULL, '2025-01-08 00:00:00'),
	(129, 57, '포도주스 지시', 150, 'P002', '포도17 (750ml)', 750, 'p3', '포장공정', '포장기기', 'process_waiting', NULL, NULL, '2025-01-08 00:00:00'),
	(130, 58, '사과주스 지시', 150, 'P004', '애플팜 (500ml)', 500, 'p2', '음료제작공정', '음료제작기기', 'process_complete', '2025-01-08 17:09:36', '2025-01-08 17:10:01', '2025-01-08 00:00:00'),
	(131, 58, '사과주스 지시', 150, 'P004', '애플팜 (500ml)', 500, 'p1', '병세척공정', '세척기기', 'process_waiting', NULL, NULL, '2025-01-08 00:00:00'),
	(132, 58, '사과주스 지시', 150, 'P004', '애플팜 (500ml)', 500, 'p3', '포장공정', '포장기기', 'process_waiting', NULL, NULL, '2025-01-08 00:00:00'),
	(133, 59, '애플지시', 200, 'P006', '애플팜 (1.5L)', 1500, 'p2', '음료제작공정', '음료제작기기', 'processing', '2025-01-08 17:34:33', NULL, '2025-01-08 00:00:00'),
	(134, 59, '애플지시', 200, 'P006', '애플팜 (1.5L)', 1500, 'p1', '병세척공정', '세척기기', 'process_waiting', NULL, NULL, '2025-01-08 00:00:00'),
	(135, 59, '애플지시', 200, 'P006', '애플팜 (1.5L)', 1500, 'p3', '포장공정', '포장기기', 'process_waiting', NULL, NULL, '2025-01-08 00:00:00'),
	(136, 60, '당근주스 지시', 150, 'P016', '당근이세요? (500ml)', 500, 'p2', '음료제작공정', '음료제작기기', 'process_complete', '2025-01-08 17:36:26', '2025-01-08 17:36:45', '2025-01-09 00:00:00'),
	(137, 60, '당근주스 지시', 150, 'P016', '당근이세요? (500ml)', 500, 'p1', '병세척공정', '세척기기', 'process_waiting', NULL, NULL, '2025-01-09 00:00:00'),
	(138, 60, '당근주스 지시', 150, 'P016', '당근이세요? (500ml)', 500, 'p3', '포장공정', '포장기기', 'process_waiting', NULL, NULL, '2025-01-09 00:00:00');

-- 테이블 natureblend.product 구조 내보내기
CREATE TABLE IF NOT EXISTS `product` (
  `product_code` varchar(30) NOT NULL,
  `product_name` varchar(30) NOT NULL,
  `capacity` int(20) NOT NULL DEFAULT 0,
  `expiration_date` int(11) NOT NULL,
  PRIMARY KEY (`product_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- 테이블 데이터 natureblend.product:~19 rows (대략적) 내보내기
INSERT INTO `product` (`product_code`, `product_name`, `capacity`, `expiration_date`) VALUES
	('P001', '포도17 (500ml)', 500, 365),
	('P002', '포도17 (750ml)', 750, 365),
	('P003', '포도17 (1.5L)', 1500, 365),
	('P004', '애플팜 (500ml)', 500, 365),
	('P005', '애플팜 (750ml)', 750, 365),
	('P006', '애플팜 (1.5L)', 1500, 365),
	('P007', '오렌쥬시 (500ml)', 500, 365),
	('P008', '오렌쥬시 (750ml)', 750, 365),
	('P009', '오렌쥬시 (1.5L)', 1500, 365),
	('P010', '레몬의꿈 (500ml)', 500, 365),
	('P011', '레몬의꿈 (750ml)', 750, 365),
	('P012', '레몬의꿈 (1.5L)', 1500, 365),
	('P013', '아이망고 (500ml)', 500, 365),
	('P014', '아이망고 (750ml)', 750, 365),
	('P015', '아이망고 (1.5L)', 1500, 365),
	('P016', '당근이세요? (500ml)', 500, 365),
	('P017', '당근이세요? (750ml)', 750, 365),
	('P018', '당근이세요? (1.5L)', 1500, 365),
	('P019', '피치피치(500ml)', 500, 365);

-- 테이블 natureblend.production_order 구조 내보내기
CREATE TABLE IF NOT EXISTS `production_order` (
  `production_order_num` int(11) NOT NULL AUTO_INCREMENT,
  `production_order_name` varchar(50) NOT NULL,
  `plan_num` int(11) NOT NULL,
  `product_code` varchar(20) NOT NULL,
  `work_date` datetime NOT NULL,
  `production_order_qty` int(11) NOT NULL,
  `production_order_date` datetime DEFAULT current_timestamp(),
  `production_order_status` varchar(20) NOT NULL DEFAULT 'work_waiting' COMMENT '대기중(work_waiting), 진행중(work_in_process),  완료(work_complete)',
  `emp_num` int(11) DEFAULT NULL,
  PRIMARY KEY (`production_order_num`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- 테이블 데이터 natureblend.production_order:~13 rows (대략적) 내보내기
INSERT INTO `production_order` (`production_order_num`, `production_order_name`, `plan_num`, `product_code`, `work_date`, `production_order_qty`, `production_order_date`, `production_order_status`, `emp_num`) VALUES
	(43, '애플팜 생산 지시', 1, 'P005', '2025-01-07 00:00:00', 250, '2025-01-07 12:58:15', 'work_complete', 20250001),
	(44, '포도주스 지시', 4, 'P001', '2025-01-07 00:00:00', 250, '2025-01-07 14:27:38', 'work_complete', 20250007),
	(46, '레몬지시', 3, 'P010', '2025-01-08 00:00:00', 100, '2025-01-07 15:01:00', 'work_in_process', 20250007),
	(51, '바니바니 바니바니?', 6, 'P016', '2025-01-07 00:00:00', 150, '2025-01-07 16:21:16', 'work_in_process', 20250011),
	(52, '쥬시쥬시', 5, 'P007', '2025-01-07 00:00:00', 150, '2025-01-07 16:38:33', 'work_in_process', 20250007),
	(53, '쥬시두번째 지시', 5, 'P007', '2025-01-07 00:00:00', 100, '2025-01-07 16:40:04', 'work_in_process', 20250001),
	(54, '사과주스 지시', 10, 'P004', '2025-01-17 00:00:00', 150, '2025-01-08 10:46:18', 'work_complete', 20250007),
	(55, '망고500ml 지시', 9, 'P013', '2025-01-10 00:00:00', 250, '2025-01-08 11:39:24', 'work_in_process', 20250007),
	(56, '포도주스 지시', 11, 'P001', '2025-01-08 00:00:00', 500, '2025-01-08 16:54:46', 'work_waiting', 20250007),
	(57, '포도주스 지시', 13, 'P002', '2025-01-08 00:00:00', 150, '2025-01-08 17:01:24', 'work_in_process', 20250001),
	(58, '사과주스 지시', 15, 'P004', '2025-01-08 00:00:00', 150, '2025-01-08 17:09:11', 'work_in_process', 20250001),
	(59, '애플지시', 17, 'P006', '2025-01-08 00:00:00', 200, '2025-01-08 17:34:11', 'work_in_process', 20250007),
	(60, '당근주스 지시', 19, 'P016', '2025-01-09 00:00:00', 150, '2025-01-08 17:36:07', 'work_in_process', 20250007);

-- 테이블 natureblend.production_plan 구조 내보내기
CREATE TABLE IF NOT EXISTS `production_plan` (
  `plan_name` varchar(50) NOT NULL,
  `plan_create_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `plan_start_date` datetime NOT NULL,
  `plan_end_date` datetime NOT NULL,
  `plan_status` varchar(20) NOT NULL DEFAULT 'plan_waiting' COMMENT '진행전(plan_waiting), 진행중(plan_in_process), 완료(plan_complete)',
  `plan_emp` varchar(10) NOT NULL,
  `plan_num` int(11) NOT NULL,
  PRIMARY KEY (`plan_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- 테이블 데이터 natureblend.production_plan:~14 rows (대략적) 내보내기
INSERT INTO `production_plan` (`plan_name`, `plan_create_date`, `plan_start_date`, `plan_end_date`, `plan_status`, `plan_emp`, `plan_num`) VALUES
	('2024 상반기 생산 계획', '2025-01-07 03:50:42', '2025-01-07 00:00:00', '2025-03-31 00:00:00', 'plan_complete', '20250001', 1),
	('하연이의꿈', '2025-01-07 05:05:53', '2025-01-07 00:00:00', '2025-01-10 00:00:00', 'plan_in_process', '20250011', 3),
	('포도주스 계획', '2025-01-07 05:25:40', '2025-01-08 00:00:00', '2025-02-05 00:00:00', 'plan_complete', '20250007', 4),
	('오렌지 계획', '2025-01-07 05:38:12', '2025-01-07 00:00:00', '2025-01-23 00:00:00', 'plan_in_process', '20250007', 5),
	('바니바니 바니바니?', '2025-01-07 07:18:57', '2025-01-07 00:00:00', '2025-01-17 00:00:00', 'plan_waiting', '20250011', 6),
	('포도쥬스 500미리 생산', '2025-01-08 00:21:27', '2025-01-09 00:00:00', '2025-01-22 00:00:00', 'plan_waiting', '20250011', 7),
	('레몬 쥬스 150개 생산', '2025-01-08 00:22:35', '2025-01-09 00:00:00', '2025-01-15 00:00:00', 'plan_waiting', '20250011', 8),
	('망고쥬스 250개 생산', '2025-01-08 00:23:09', '2025-01-08 00:00:00', '2025-01-16 00:00:00', 'plan_in_process', '20250011', 9),
	('애플팜 주스 계획', '2025-01-08 01:45:16', '2025-01-08 00:00:00', '2025-02-07 00:00:00', 'plan_complete', '20250007', 10),
	('2025 상반기 계획', '2025-01-08 07:53:29', '2025-01-08 00:00:00', '2025-02-05 00:00:00', 'plan_waiting', '20250001', 11),
	('2025 상반기 계획', '2025-01-08 08:00:39', '2025-01-08 00:00:00', '2025-02-05 00:00:00', 'plan_in_process', '20250007', 13),
	('2025 계획!', '2025-01-08 08:08:31', '2025-01-08 00:00:00', '2025-02-05 00:00:00', 'plan_in_process', '20250007', 15),
	('2025상반기계획', '2025-01-08 08:33:27', '2025-01-08 00:00:00', '2025-02-07 00:00:00', 'plan_in_process', '20250007', 17),
	('당근2025 계획', '2025-01-08 08:35:29', '2025-01-08 00:00:00', '2025-02-07 00:00:00', 'plan_in_process', '20250007', 19);

-- 테이블 natureblend.qc_material 구조 내보내기
CREATE TABLE IF NOT EXISTS `qc_material` (
  `qc_material_id` varchar(20) NOT NULL,
  `order_code` varchar(200) NOT NULL COMMENT '자재 발주 코드',
  `material_code` varchar(200) NOT NULL COMMENT '자재발주서바디의 자재발주코드',
  `total_qnt` int(11) NOT NULL COMMENT '자재 총수량',
  `pass_qnt` int(11) DEFAULT 0 COMMENT '검사합격량',
  `rjc_qnt` int(11) DEFAULT 0 COMMENT '검사중 나온 총 불합격량',
  `inspec_start` datetime NOT NULL DEFAULT current_timestamp() COMMENT '테이블에 생성된 시각 기입',
  `inspec_end` datetime DEFAULT NULL COMMENT '테이블에서 수정된 시각 기입',
  `inspec_status` varchar(50) NOT NULL COMMENT '(검사요청완료 or 검사완료)',
  `emp_num` int(30) NOT NULL COMMENT '입고검사 담당자',
  PRIMARY KEY (`qc_material_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- 테이블 데이터 natureblend.qc_material:~39 rows (대략적) 내보내기
INSERT INTO `qc_material` (`qc_material_id`, `order_code`, `material_code`, `total_qnt`, `pass_qnt`, `rjc_qnt`, `inspec_start`, `inspec_end`, `inspec_status`, `emp_num`) VALUES
	('QCM2501070001', 'PO250107005', 'M009', 20000, 20000, 0, '2025-01-07 12:55:22', '2025-01-07 12:56:26', '검사완료', 20250014),
	('QCM2501070002', 'PO250107004', 'M008', 10000, 10000, 0, '2025-01-07 12:55:22', '2025-01-07 12:56:26', '검사완료', 20250014),
	('QCM2501070003', 'PO250107003', 'M007', 40000, 40000, 0, '2025-01-07 12:55:22', '2025-01-07 12:56:26', '검사완료', 20250014),
	('QCM2501070004', 'PO250107002', 'M002', 200000, 184000, 16000, '2025-01-07 12:55:22', '2025-01-07 12:56:26', '검사완료', 20250014),
	('QCM2501070005', 'PO250107002', 'M005', 100000, 100000, 0, '2025-01-07 12:55:22', '2025-01-07 12:56:26', '검사완료', 20250014),
	('QCM2501070006', 'PO250107001', 'M012', 400, 350, 50, '2025-01-07 12:55:22', '2025-01-07 12:56:26', '검사완료', 20250014),
	('QCM2501070007', 'PO250107001', 'M011', 500, 500, 0, '2025-01-07 12:55:22', '2025-01-07 12:56:26', '검사완료', 20250014),
	('QCM2501070008', 'PO250107009', 'M011', 1000, 1000, 0, '2025-01-07 14:09:31', '2025-01-07 14:09:41', '검사완료', 20250014),
	('QCM2501070009', 'PO250107008', 'M008', 10000, 10000, 0, '2025-01-07 14:09:31', '2025-01-07 14:09:41', '검사완료', 20250014),
	('QCM2501070010', 'PO250107007', 'M007', 100000, 100000, 0, '2025-01-07 14:09:31', '2025-01-07 14:09:40', '검사완료', 20250014),
	('QCM2501070011', 'PO250107006', 'M004', 150000, 150000, 0, '2025-01-07 14:09:31', '2025-01-07 14:09:40', '검사완료', 20250014),
	('QCM2501070012', 'PO250107014', 'M008', 10000000, 10000000, 0, '2025-01-07 14:49:12', '2025-01-07 14:52:07', '검사완료', 20250005),
	('QCM2501070013', 'PO250107013', 'M007', 100000000, 100000000, 0, '2025-01-07 14:49:12', '2025-01-07 14:52:07', '검사완료', 20250005),
	('QCM2501070014', 'PO250107012', 'M009', 10000000, 10000000, 0, '2025-01-07 14:49:12', '2025-01-07 14:52:00', '검사완료', 20250005),
	('QCM2501070015', 'PO250107011', 'M013', 10000, 10000, 0, '2025-01-07 14:49:12', '2025-01-07 14:52:00', '검사완료', 20250005),
	('QCM2501070016', 'PO250107011', 'M011', 10000, 10000, 0, '2025-01-07 14:49:12', '2025-01-07 14:52:00', '검사완료', 20250005),
	('QCM2501070017', 'PO250107011', 'M012', 10000, 10000, 0, '2025-01-07 14:49:12', '2025-01-07 14:52:00', '검사완료', 20250005),
	('QCM2501070018', 'PO250107010', 'M006', 10000000, 10000000, 0, '2025-01-07 14:49:12', '2025-01-07 14:52:00', '검사완료', 20250005),
	('QCM2501070019', 'PO250107010', 'M001', 10000000, 10000000, 0, '2025-01-07 14:49:12', '2025-01-07 14:52:00', '검사완료', 20250005),
	('QCM2501070020', 'PO250107010', 'M002', 10000000, 10000000, 0, '2025-01-07 14:49:12', '2025-01-07 14:52:00', '검사완료', 20250005),
	('QCM2501070021', 'PO250107010', 'M003', 10000000, 10000000, 0, '2025-01-07 14:49:12', '2025-01-07 14:52:00', '검사완료', 20250005),
	('QCM2501070022', 'PO250107010', 'M004', 10000000, 10000000, 0, '2025-01-07 14:49:12', '2025-01-07 14:52:00', '검사완료', 20250005),
	('QCM2501070023', 'PO250107010', 'M005', 10000000, 10000000, 0, '2025-01-07 14:49:12', '2025-01-07 14:52:00', '검사완료', 20250005),
	('QCM2501080001', 'PO250108002', 'M001', 100000, 100000, 0, '2025-01-08 11:54:08', '2025-01-08 14:33:24', '검사완료', 20250005),
	('QCM2501080002', 'PO250108002', 'M006', 200000, 0, 0, '2025-01-08 11:54:08', NULL, '검사요청완료', 20250005),
	('QCM2501080003', 'PO250108001', 'M011', 500, 500, 0, '2025-01-08 11:54:08', '2025-01-08 23:46:33', '검사완료', 20250005),
	('QCM2501080004', 'PO250108007', 'M001', 150000, 140000, 10000, '2025-01-08 14:24:26', '2025-01-08 14:25:31', '검사완료', 20250014),
	('QCM2501080005', 'PO250108006', 'M001', 100000, 100000, 0, '2025-01-08 14:24:26', '2025-01-08 14:25:31', '검사완료', 20250014),
	('QCM2501080006', 'PO250108006', 'M004', 100000, 100000, 0, '2025-01-08 14:24:26', '2025-01-08 14:25:31', '검사완료', 20250014),
	('QCM2501080007', 'PO250108006', 'M006', 100000, 99000, 1000, '2025-01-08 14:24:26', '2025-01-08 14:25:31', '검사완료', 20250014),
	('QCM2501080008', 'PO250108008', 'M007', 100000, 95000, 5000, '2025-01-08 14:24:26', '2025-01-08 14:25:31', '검사완료', 20250014),
	('QCM2501080009', 'PO250108005', 'M009', 35000, 35000, 0, '2025-01-08 14:24:26', '2025-01-08 14:25:31', '검사완료', 20250014),
	('QCM2501080010', 'PO250108004', 'M009', 40000, 32000, 8000, '2025-01-08 23:36:31', '2025-01-08 23:37:18', '검사완료', 20250005),
	('QCM2501080011', 'PO250108003', 'M007', 290000, 290000, 0, '2025-01-08 23:36:31', '2025-01-08 23:37:18', '검사완료', 20250005),
	('QCM2501080012', 'PO250108013', 'M007', 200000, 200000, 0, '2025-01-08 23:45:41', '2025-01-08 23:46:33', '검사완료', 20250005),
	('QCM2501080013', 'PO250108012', 'M011', 1800, 1783, 17, '2025-01-08 23:45:41', '2025-01-08 23:46:33', '검사완료', 20250005),
	('QCM2501080014', 'PO250108011', 'M009', 100000, 90000, 10000, '2025-01-08 23:45:41', '2025-01-08 23:46:33', '검사완료', 20250005),
	('QCM2501080015', 'PO250108010', 'M008', 100000, 100000, 0, '2025-01-08 23:45:41', '2025-01-08 23:46:33', '검사완료', 20250005),
	('QCM2501080016', 'PO250108009', 'M001', 200000, 200000, 0, '2025-01-08 23:45:41', '2025-01-08 23:46:33', '검사완료', 20250005);

-- 프로시저 natureblend.qc_material_input_qcmlist 구조 내보내기
DELIMITER //
CREATE PROCEDURE `qc_material_input_qcmlist`(
	IN `v_emp_num` INT,
	IN `v_order_code` VARCHAR(50),
	IN `v_material_name` VARCHAR(50),
	IN `v_total_qty` INT,
	OUT `v_result` VARCHAR(20)
)
BEGIN
	 DECLARE v_material_code VARCHAR(30);
	 DECLARE v_inspec_start  VARCHAR(20);
    DECLARE v_result_value  VARCHAR(20);
    DECLARE v_count INT DEFAULT 0;
    
    
    START TRANSACTION;
    
    SELECT 
	 		  material_code
    INTO
    		  v_material_code
    FROM   material
    WHERE  material_name = v_material_name
	 LIMIT 1;
    
    if v_material_code IS NOT NULL then
    
    SELECT COUNT(*) INTO v_count FROM qc_material;
    
    IF v_count != 0 THEN
    
    SELECT
    	case when DATE_FORMAT(inspec_start, '%Y-%m-%d') = DATE_FORMAT(NOW(), '%Y-%m-%d') then
            	case  when LENGTH((RIGHT(qc_material_id, 4)+1)) = 1 then CONCAT('QCM',DATE_FORMAT(NOW(), '%y%m%d'),'000', (RIGHT(qc_material_id, 4)+1))
                  	when LENGTH((RIGHT(qc_material_id, 4)+1)) = 2 then CONCAT('QCM',DATE_FORMAT(NOW(), '%y%m%d'),'00', (RIGHT(qc_material_id, 4)+1))
                  	when LENGTH((RIGHT(qc_material_id, 4)+1)) = 3 then CONCAT('QCM',DATE_FORMAT(NOW(), '%y%m%d'),'0', (RIGHT(qc_material_id, 4)+1))
                  	when LENGTH((RIGHT(qc_material_id, 4)+1)) = 4 then CONCAT('QCM',DATE_FORMAT(NOW(), '%y%m%d'), (RIGHT(qc_material_id, 4)+1))
            END
      		ELSE 
        		 CONCAT('QCM',DATE_FORMAT(NOW(), '%y%m%d'),'0001')
   	END AS inspec_start
    INTO
    		v_inspec_start
    FROM
    		qc_material
    ORDER BY
         inspec_start DESC
    LIMIT 1;
    ELSE
        SET v_inspec_start = CONCAT('QCM', DATE_FORMAT(NOW(), '%y%m%d'), '0001');
    END IF;
    
	 if v_inspec_start IS NOT NULL then
		INSERT INTO qc_material(qc_material_id, order_code, material_code, total_qnt, inspec_status, emp_num)
		VALUES (v_inspec_start, v_order_code, v_material_code, v_total_qty, '검사요청완료', v_emp_num);
		SET  v_result_value = FOUND_ROWS();
		
		if v_result_value = 1 then
            COMMIT;
            SET  v_result_value = 'Success!';
      else
            ROLLBACK;
            SET  v_result_value = 'Fail...';
      END if;
    else
    	ROLLBACK;
      SET  v_result_value = 'Fail...';
    END if;
    
    
    else
    	ROLLBACK;
      SET  v_result_value = 'Fail...';
    END if;
    
    
    SELECT v_result_value AS result;

END//
DELIMITER ;

-- 테이블 natureblend.qc_material_rjc 구조 내보내기
CREATE TABLE IF NOT EXISTS `qc_material_rjc` (
  `qc_material_rjc_id` varchar(20) NOT NULL DEFAULT '',
  `qc_material_id` varchar(20) NOT NULL,
  `faulty_code` varchar(30) NOT NULL,
  `rjc_quantity` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`qc_material_rjc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- 테이블 데이터 natureblend.qc_material_rjc:~10 rows (대략적) 내보내기
INSERT INTO `qc_material_rjc` (`qc_material_rjc_id`, `qc_material_id`, `faulty_code`, `rjc_quantity`) VALUES
	('QCMR2501070001', 'QCM2501070004', 'FC003', 16000),
	('QCMR2501070002', 'QCM2501070006', 'FC001', 30),
	('QCMR2501070003', 'QCM2501070006', 'FC004', 20),
	('QCMR2501080001', 'QCM2501080004', 'FC004', 10000),
	('QCMR2501080002', 'QCM2501080007', 'FC003', 1000),
	('QCMR2501080003', 'QCM2501080008', 'FC004', 5000),
	('QCMR2501080004', 'QCM2501080010', 'FC001', 2500),
	('QCMR2501080005', 'QCM2501080010', 'FC002', 5500),
	('QCMR2501080006', 'QCM2501080013', 'FC004', 17),
	('QCMR2501080007', 'QCM2501080014', 'FC002', 10000);

-- 프로시저 natureblend.qc_material_rjc_input_rjclist 구조 내보내기
DELIMITER //
CREATE PROCEDURE `qc_material_rjc_input_rjclist`(
	IN `v_qc_material_id` VARCHAR(50),
	IN `v_faulty_code` VARCHAR(50),
	IN `v_rjc_quantity` INT,
	OUT `v_result` VARCHAR(20)
)
BEGIN
	 DECLARE v_count INT DEFAULT 0;
	 DECLARE v_rjc_id VARCHAR(20);
    DECLARE v_result_value VARCHAR(20);
    
    
    
    
    START TRANSACTION;
    
    SELECT COUNT(*) INTO v_count FROM qc_material_rjc;    
    
    
    
    -- 가장 최근 qc_material_rjc_id 가져오기
    IF v_count != 0 THEN
	    SELECT
	    	case when DATE_FORMAT(SUBSTRING(qc_material_rjc_id, 5, 6), '%Y-%m-%d') = DATE_FORMAT(NOW(), '%Y-%m-%d') then
	            	case  when LENGTH((RIGHT(qc_material_rjc_id, 4)+1)) = 1 then CONCAT('QCMR',DATE_FORMAT(NOW(), '%y%m%d'),'000', (RIGHT(qc_material_rjc_id, 4)+1))
	                  	when LENGTH((RIGHT(qc_material_rjc_id, 4)+1)) = 2 then CONCAT('QCMR',DATE_FORMAT(NOW(), '%y%m%d'),'00', (RIGHT(qc_material_rjc_id, 4)+1))
	                  	when LENGTH((RIGHT(qc_material_rjc_id, 4)+1)) = 3 then CONCAT('QCMR',DATE_FORMAT(NOW(), '%y%m%d'),'0', (RIGHT(qc_material_rjc_id, 4)+1))
	                  	when LENGTH((RIGHT(qc_material_rjc_id, 4)+1)) = 4 then CONCAT('QCMR',DATE_FORMAT(NOW(), '%y%m%d'), (RIGHT(qc_material_rjc_id, 4)+1))
	            END
	      		ELSE 
	        		 CONCAT('QCMR',DATE_FORMAT(NOW(), '%y%m%d'),'0001')
	   	END AS  rjc_id
	    INTO
	    		v_rjc_id
	    FROM
			 qc_material_rjc
	    ORDER BY
	         qc_material_rjc_id DESC
		 LIMIT 1;
    ELSE 
    	SET v_rjc_id = CONCAT ('QCMR',DATE_FORMAT(NOW(), '%y%m%d'),'0001');
    END IF;
    
    
	 if v_rjc_id IS NOT NULL then
		INSERT INTO qc_material_rjc(qc_material_rjc_id, qc_material_id, faulty_code, rjc_quantity)	
		VALUES (v_rjc_id, v_qc_material_id, v_faulty_code, v_rjc_quantity); -- 여기서 부터 수정
		SET  v_result_value = FOUND_ROWS();
		
		if v_result_value = 1 then
            COMMIT;
            SET  v_result_value = 'Success!';
      else
            ROLLBACK;
            SET  v_result_value = 'Fail...';
      END if;
    else
    	ROLLBACK;
      SET  v_result_value = 'Fail...';
    END if;
    
    SELECT v_result_value AS result;

END//
DELIMITER ;

-- 테이블 natureblend.qc_packaging 구조 내보내기
CREATE TABLE IF NOT EXISTS `qc_packaging` (
  `qc_packing_id` varchar(20) NOT NULL,
  `total_qnt` int(11) NOT NULL COMMENT '제품총수량',
  `pass_qnt` int(11) DEFAULT 0 COMMENT '검사합격량',
  `rjc_qnt` int(11) DEFAULT 0 COMMENT '검사불합경량',
  `inspec_start` datetime NOT NULL DEFAULT current_timestamp(),
  `inspec_end` datetime DEFAULT NULL,
  `inspec_status` varchar(50) NOT NULL COMMENT '(검사요청완료 or 검사완료)',
  `emp_num` int(30) NOT NULL,
  `process_num` int(11) NOT NULL,
  PRIMARY KEY (`qc_packing_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- 테이블 데이터 natureblend.qc_packaging:~11 rows (대략적) 내보내기
INSERT INTO `qc_packaging` (`qc_packing_id`, `total_qnt`, `pass_qnt`, `rjc_qnt`, `inspec_start`, `inspec_end`, `inspec_status`, `emp_num`, `process_num`) VALUES
	('QCPP2501070001', 250, 240, 10, '2025-01-07 13:10:09', '2025-01-07 13:10:29', '검사완료', 20250009, 144),
	('QCPP2501070002', 10, 10, 0, '2025-01-07 13:10:53', '2025-01-07 13:11:04', '검사완료', 20250007, 145),
	('QCPP2501070003', 250, 250, 0, '2025-01-07 14:39:22', '2025-01-07 14:39:28', '검사완료', 20250001, 148),
	('QCPP2501070004', 10, 10, 0, '2025-01-07 18:19:02', '2025-01-08 03:11:01', '검사완료', 20250001, 163),
	('QCPP2501070005', 15, 15, 0, '2025-01-07 18:19:09', '2025-01-07 18:26:41', '검사완료', 20250010, 164),
	('QCPP2501070006', 5, 5, 0, '2025-01-07 18:19:57', '2025-01-08 14:51:46', '검사완료', 20250007, 165),
	('QCPP2501070007', 10, 10, 0, '2025-01-07 18:20:07', '2025-01-08 03:12:13', '검사완료', 20250009, 166),
	('QCPP2501070008', 30, 30, 0, '2025-01-07 18:20:24', '2025-01-07 18:26:41', '검사완료', 20250001, 167),
	('QCPP2501080001', 150, 150, 0, '2025-01-08 10:47:02', '2025-01-08 10:48:00', '검사완료', 20250007, 171),
	('QCPP2501080002', 100, 95, 5, '2025-01-08 11:55:16', '2025-01-08 11:55:42', '검사완료', 20250007, 174),
	('QCPP2501080003', 100, 0, 0, '2025-01-08 11:58:22', NULL, '검사요청완료', 20250007, 176);

-- 테이블 natureblend.qc_packaging_rjc 구조 내보내기
CREATE TABLE IF NOT EXISTS `qc_packaging_rjc` (
  `packing_rjc_id` varchar(20) NOT NULL DEFAULT '',
  `qc_packing_id` varchar(50) NOT NULL,
  `faulty_code` varchar(30) NOT NULL,
  `rjc_quantity` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`packing_rjc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- 테이블 데이터 natureblend.qc_packaging_rjc:~2 rows (대략적) 내보내기
INSERT INTO `qc_packaging_rjc` (`packing_rjc_id`, `qc_packing_id`, `faulty_code`, `rjc_quantity`) VALUES
	('QCPPR2501070001', 'QCPP2501070001', 'FC002', 10),
	('QCPPR2501080001', 'QCPP2501080002', 'FC009', 5);

-- 프로시저 natureblend.qc_packaging_rjc_input_rjclist 구조 내보내기
DELIMITER //
CREATE PROCEDURE `qc_packaging_rjc_input_rjclist`(		IN v_qc_packing_id VARCHAR(50),
		IN v_faulty_code VARCHAR(50),
		IN v_rjc_quantity INT,
		OUT v_result VARCHAR(20))
BEGIN
	DECLARE v_count int;
	DECLARE v_rjc_id VARCHAR(20);
    DECLARE v_result_value VARCHAR(20);
    
    
    
    
    START TRANSACTION;
    
    SELECT COUNT(*) INTO v_count FROM qc_packaging_rjc; 
    
    
   
    IF v_count != 0 THEN
	    SELECT
	    	case when DATE_FORMAT(SUBSTRING(packing_rjc_id, 6, 6), '%Y-%m-%d') = DATE_FORMAT(NOW(), '%Y-%m-%d') then
	            	case  when LENGTH((RIGHT(packing_rjc_id, 4)+1)) = 1 then CONCAT('QCPPR',DATE_FORMAT(NOW(), '%y%m%d'),'000', (RIGHT(packing_rjc_id, 4)+1))
	                  	when LENGTH((RIGHT(packing_rjc_id, 4)+1)) = 2 then CONCAT('QCPPR',DATE_FORMAT(NOW(), '%y%m%d'),'00', (RIGHT(packing_rjc_id, 4)+1))
	                  	when LENGTH((RIGHT(packing_rjc_id, 4)+1)) = 3 then CONCAT('QCPPR',DATE_FORMAT(NOW(), '%y%m%d'),'0', (RIGHT(packing_rjc_id, 4)+1))
	                  	when LENGTH((RIGHT(packing_rjc_id, 4)+1)) = 4 then CONCAT('QCPPR',DATE_FORMAT(NOW(), '%y%m%d'), (RIGHT(packing_rjc_id, 4)+1))
	            END
	      		ELSE 
	        		 CONCAT('QCPPR',DATE_FORMAT(NOW(), '%y%m%d'),'0001')
	   	END AS  rjc_id
	    INTO
	    		v_rjc_id
	    FROM
			 qc_packaging_rjc
	    ORDER BY
	         packing_rjc_id DESC
		 LIMIT 1;
    ELSE 
    	SET v_rjc_id = CONCAT ('QCPPR',DATE_FORMAT(NOW(), '%y%m%d'),'0001');
    END IF;
    
    
    
    
	 if v_rjc_id IS NOT NULL then
		INSERT INTO qc_packaging_rjc(packing_rjc_id, qc_packing_id, faulty_code, rjc_quantity)	
		VALUES (v_rjc_id, v_qc_packing_id, v_faulty_code, v_rjc_quantity); -- 여기서 부터 수정
		SET  v_result_value = FOUND_ROWS();
		
		if v_result_value = 1 then
            COMMIT;
            SET  v_result_value = 'Success!';
      else
            ROLLBACK;
            SET  v_result_value = 'Fail...';
      END if;
    else
    	ROLLBACK;
      SET  v_result_value = 'Fail...';
    END if;
    
    SELECT v_result_value AS result;

END//
DELIMITER ;

-- 프로시저 natureblend.qc_packaging_update_list 구조 내보내기
DELIMITER //
CREATE PROCEDURE `qc_packaging_update_list`(
	IN v_qc_packing_id VARCHAR(50),
    IN v_process_num INT,
    IN v_pass_qnt INT,
    IN v_rjc_qnt INT,
    OUT v_result VARCHAR(20)
)
BEGIN
	DECLARE v_update_value INT;
    START TRANSACTION;

    -- 검사 테이블 갱신
    UPDATE qc_packaging
    SET pass_qnt = v_pass_qnt, 
        rjc_qnt = v_rjc_qnt, 
        inspec_end = CURRENT_TIMESTAMP, 
        inspec_status = '검사완료'
    WHERE qc_packing_id = v_qc_packing_id;
    SET  v_update_value = ROW_COUNT();
    
    IF v_update_value = 1 then
		UPDATE process_work_body
		SET success_qty = v_pass_qnt, 
			fail_qty = v_rjc_qnt
		WHERE process_num = v_process_num;
		SET v_update_value = ROW_COUNT();
        
		IF v_update_value = 1 then
			COMMIT;
			SET  v_result = 'Success';
		ELSE
			ROLLBACK;
			SET  v_result = 'Fail';
		END if;
	ELSE
		ROLLBACK;
		SET  v_result = 'Fail';
	END if;
    
    SELECT v_result AS result;

END//
DELIMITER ;

-- 테이블 natureblend.qc_process_beverage 구조 내보내기
CREATE TABLE IF NOT EXISTS `qc_process_beverage` (
  `qc_berverage_id` varchar(20) NOT NULL,
  `inspec_result` varchar(50) DEFAULT NULL COMMENT '(합격, 불합격)',
  `inspec_start` datetime NOT NULL DEFAULT current_timestamp(),
  `inspec_end` datetime DEFAULT NULL,
  `inspec_status` varchar(50) NOT NULL COMMENT '(검사요청완료  or 검사완료)',
  `emp_num` int(30) DEFAULT NULL,
  `process_num` int(11) NOT NULL,
  PRIMARY KEY (`qc_berverage_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- 테이블 데이터 natureblend.qc_process_beverage:~19 rows (대략적) 내보내기
INSERT INTO `qc_process_beverage` (`qc_berverage_id`, `inspec_result`, `inspec_start`, `inspec_end`, `inspec_status`, `emp_num`, `process_num`) VALUES
	('QCPB2501070001', '합격', '2025-01-07 13:00:01', '2025-01-07 13:01:46', '검사완료', 20250009, 140),
	('QCPB2501070002', '합격', '2025-01-07 13:04:45', '2025-01-07 13:05:11', '검사완료', 20250009, 141),
	('QCPB2501070003', '합격', '2025-01-07 14:36:04', '2025-01-07 14:36:39', '검사완료', 20250001, 146),
	('QCPB2501070004', '합격', '2025-01-07 15:21:29', '2025-01-07 15:28:04', '검사완료', 20250010, 149),
	('QCPB2501070005', '합격', '2025-01-07 15:21:50', '2025-01-07 15:30:27', '검사완료', 20250010, 150),
	('QCPB2501070006', '불합격', '2025-01-07 15:22:00', '2025-01-07 15:30:27', '검사완료', 20250001, 151),
	('QCPB2501070007', '합격', '2025-01-07 16:22:17', '2025-01-07 16:32:01', '검사완료', 20250001, 156),
	('QCPB2501070008', '합격', '2025-01-07 16:22:39', '2025-01-08 17:49:31', '검사완료', 20250007, 157),
	('QCPB2501070009', '합격', '2025-01-07 16:25:10', '2025-01-07 16:32:45', '검사완료', 20250009, 158),
	('QCPB2501070010', '합격', '2025-01-07 16:41:12', '2025-01-07 16:41:38', '검사완료', 20250009, 160),
	('QCPB2501070011', '합격', '2025-01-07 16:47:26', '2025-01-08 15:05:18', '검사완료', 20250010, 161),
	('QCPB2501080001', '합격', '2025-01-08 10:46:43', '2025-01-08 10:47:54', '검사완료', 20250009, 169),
	('QCPB2501080002', '합격', '2025-01-08 11:44:08', '2025-01-08 11:44:43', '검사완료', 20250009, 172),
	('QCPB2501080003', NULL, '2025-01-08 17:01:47', NULL, '검사요청완료', 20250001, 178),
	('QCPB2501080004', NULL, '2025-01-08 17:09:36', NULL, '검사요청완료', 20250001, 180),
	('QCPB2501080005', NULL, '2025-01-08 17:09:56', NULL, '검사요청완료', 20250007, 181),
	('QCPB2501080006', '불합격', '2025-01-08 17:34:34', '2025-01-08 23:47:05', '검사완료', 20250009, 182),
	('QCPB2501080007', '합격', '2025-01-08 17:36:27', '2025-01-08 23:47:05', '검사완료', 20250009, 184),
	('QCPB2501080008', '불합격', '2025-01-08 17:36:42', '2025-01-08 23:37:51', '검사완료', 20250007, 185);

-- 테이블 natureblend.qc_process_cleaning 구조 내보내기
CREATE TABLE IF NOT EXISTS `qc_process_cleaning` (
  `qc_cleaning_id` varchar(20) NOT NULL,
  `total_qnt` int(11) NOT NULL COMMENT '자재 총수량',
  `pass_qnt` int(11) DEFAULT 0 COMMENT '검사합격량',
  `rjc_qnt` int(11) DEFAULT 0,
  `inspec_start` datetime NOT NULL,
  `inspec_end` datetime DEFAULT NULL,
  `inspec_status` varchar(50) NOT NULL COMMENT '(검사요청완료  or 검사완료)',
  `emp_num` int(30) NOT NULL,
  `process_num` int(11) NOT NULL,
  PRIMARY KEY (`qc_cleaning_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- 테이블 데이터 natureblend.qc_process_cleaning:~12 rows (대략적) 내보내기
INSERT INTO `qc_process_cleaning` (`qc_cleaning_id`, `total_qnt`, `pass_qnt`, `rjc_qnt`, `inspec_start`, `inspec_end`, `inspec_status`, `emp_num`, `process_num`) VALUES
	('QCPC2501070001', 250, 190, 60, '2025-01-07 13:06:15', '2025-01-07 13:06:36', '검사완료', 20250010, 142),
	('QCPC2501070002', 100, 100, 0, '2025-01-07 13:07:36', '2025-01-07 13:09:49', '검사완료', 20250009, 143),
	('QCPC2501070003', 250, 250, 0, '2025-01-07 14:39:00', '2025-01-07 14:39:08', '검사완료', 20250009, 147),
	('QCPC2501070004', 10, 10, 0, '2025-01-07 15:53:22', '2025-01-08 10:47:41', '검사완료', 20250007, 152),
	('QCPC2501070005', 15, 15, 0, '2025-01-07 15:53:28', '2025-01-07 18:14:34', '검사완료', 20250009, 153),
	('QCPC2501070006', 20, 20, 0, '2025-01-07 15:53:37', '2025-01-07 17:09:34', '검사완료', 20250010, 154),
	('QCPC2501070007', 35, 35, 0, '2025-01-07 15:57:01', '2025-01-07 16:49:25', '검사완료', 20250001, 155),
	('QCPC2501070008', 25, 25, 0, '2025-01-07 16:40:31', '2025-01-07 16:49:25', '검사완료', 20250009, 159),
	('QCPC2501070009', 50, 50, 0, '2025-01-07 16:55:00', '2025-01-08 10:47:41', '검사완료', 20250010, 162),
	('QCPC2501080001', 150, 150, 0, '2025-01-08 10:46:53', '2025-01-08 10:47:41', '검사완료', 20250007, 170),
	('QCPC2501080002', 250, 245, 5, '2025-01-08 11:44:27', '2025-01-08 15:00:00', '검사완료', 20250007, 173),
	('QCPC2501080003', 500, 0, 0, '2025-01-08 17:02:13', NULL, '검사요청완료', 20250009, 179);

-- 테이블 natureblend.qc_process_cleaning_rjc 구조 내보내기
CREATE TABLE IF NOT EXISTS `qc_process_cleaning_rjc` (
  `cleaning_rjc_id` varchar(20) NOT NULL DEFAULT '',
  `qc_cleaning_id` varchar(20) NOT NULL,
  `faulty_code` varchar(30) NOT NULL,
  `rjc_quantity` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`cleaning_rjc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- 테이블 데이터 natureblend.qc_process_cleaning_rjc:~3 rows (대략적) 내보내기
INSERT INTO `qc_process_cleaning_rjc` (`cleaning_rjc_id`, `qc_cleaning_id`, `faulty_code`, `rjc_quantity`) VALUES
	('QCPCR2501070001', 'QCPC2501070001', 'FC008', 50),
	('QCPCR2501070002', 'QCPC2501070001', 'FC009', 10),
	('QCPCR2501080001', 'QCPC2501080002', 'FC009', 5);

-- 프로시저 natureblend.qc_process_cleaning_rjc_input_rjclist 구조 내보내기
DELIMITER //
CREATE PROCEDURE `qc_process_cleaning_rjc_input_rjclist`(		IN v_qc_cleaning_id VARCHAR(50),
		IN v_faulty_code VARCHAR(50),
		IN v_rjc_quantity INT,
		OUT v_result VARCHAR(20))
BEGIN
	DECLARE v_count int;
	DECLARE v_rjc_id VARCHAR(20);
    DECLARE v_result_value VARCHAR(20);
    
    
    
    
    START TRANSACTION;
    
    SELECT COUNT(*) INTO v_count FROM qc_process_cleaning_rjc; 
    
    
    -- 가장 최근 cleaning_rjc_id 가져오기
    IF v_count != 0 THEN
	    SELECT
	    	case when DATE_FORMAT(SUBSTRING(cleaning_rjc_id, 6, 6), '%Y-%m-%d') = DATE_FORMAT(NOW(), '%Y-%m-%d') then
	            	case  when LENGTH((RIGHT(cleaning_rjc_id, 4)+1)) = 1 then CONCAT('QCPCR',DATE_FORMAT(NOW(), '%y%m%d'),'000', (RIGHT(cleaning_rjc_id, 4)+1))
	                  	when LENGTH((RIGHT(cleaning_rjc_id, 4)+1)) = 2 then CONCAT('QCPCR',DATE_FORMAT(NOW(), '%y%m%d'),'00', (RIGHT(cleaning_rjc_id, 4)+1))
	                  	when LENGTH((RIGHT(cleaning_rjc_id, 4)+1)) = 3 then CONCAT('QCPCR',DATE_FORMAT(NOW(), '%y%m%d'),'0', (RIGHT(cleaning_rjc_id, 4)+1))
	                  	when LENGTH((RIGHT(cleaning_rjc_id, 4)+1)) = 4 then CONCAT('QCPCR',DATE_FORMAT(NOW(), '%y%m%d'), (RIGHT(cleaning_rjc_id, 4)+1))
	            END
	      		ELSE 
	        		 CONCAT('QCPCR',DATE_FORMAT(NOW(), '%y%m%d'),'0001')
	   	END AS  rjc_id
	    INTO
	    		v_rjc_id
	    FROM
			 qc_process_cleaning_rjc
	    ORDER BY
	         cleaning_rjc_id DESC
		 LIMIT 1;
    ELSE 
    	SET v_rjc_id = CONCAT ('QCPCR',DATE_FORMAT(NOW(), '%y%m%d'),'0001');
    END IF;
    
    
    
    
	 if v_rjc_id IS NOT NULL then
		INSERT INTO qc_process_cleaning_rjc(cleaning_rjc_id, qc_cleaning_id, faulty_code, rjc_quantity)	
		VALUES (v_rjc_id, v_qc_cleaning_id, v_faulty_code, v_rjc_quantity); -- 여기서 부터 수정
		SET  v_result_value = FOUND_ROWS();
		
		if v_result_value = 1 then
            COMMIT;
            SET  v_result_value = 'Success!';
      else
            ROLLBACK;
            SET  v_result_value = 'Fail...';
      END if;
    else
    	ROLLBACK;
      SET  v_result_value = 'Fail...';
    END if;
    
    SELECT v_result_value AS result;

END//
DELIMITER ;

-- 프로시저 natureblend.qc_process_cleaning_update_list 구조 내보내기
DELIMITER //
CREATE PROCEDURE `qc_process_cleaning_update_list`(
	IN `v_qc_cleaning_id` VARCHAR(50),
	IN `v_process_num` INT,
	IN `v_pass_qnt` INT,
	IN `v_rjc_qnt` INT,
	OUT `v_result` VARCHAR(20)
)
BEGIN
	DECLARE v_update_value INT;
    START TRANSACTION;

    -- 검사 테이블 갱신
    UPDATE qc_process_cleaning
    SET pass_qnt = v_pass_qnt, 
        rjc_qnt = v_rjc_qnt, 
        inspec_end = CURRENT_TIMESTAMP, 
        inspec_status = '검사완료'
    WHERE qc_cleaning_id = v_qc_cleaning_id;
    SET  v_update_value = ROW_COUNT();
    
    IF v_update_value = 1 then
		UPDATE process_work_body
		SET success_qty = v_pass_qnt, 
			 fail_qty = v_rjc_qnt
		WHERE process_num = v_process_num;
		SET v_update_value = ROW_COUNT();
        
		IF v_update_value = 1 then
			COMMIT;
			SET  v_result = 'Success';
		ELSE
			ROLLBACK;
			SET  v_result = 'Fail';
		END if;
	ELSE
		ROLLBACK;
		SET  v_result = 'Fail';
	END if;
    
    SELECT v_result AS result;

END//
DELIMITER ;

-- 프로시저 natureblend.qc_p_beverage_input_list 구조 내보내기
DELIMITER //
CREATE PROCEDURE `qc_p_beverage_input_list`(
	IN `v_process_num` INT,
	IN `v_emp_num` INT,
	OUT `v_result` VARCHAR(20)
)
BEGIN
    DECLARE v_count INT DEFAULT 0;
    DECLARE v_qc_berverage_id VARCHAR(20);
    DECLARE v_result_value VARCHAR(20);

    -- 트랜잭션 시작
    START TRANSACTION;

    -- 테이블에 데이터가 있는지 확인
    SELECT COUNT(*) INTO v_count FROM qc_process_beverage;

    -- qc_cleaning_id 생성
    IF v_count != 0 THEN
        SELECT 
            CASE 
                WHEN DATE_FORMAT(SUBSTRING(qc_berverage_id, 5, 6), '%y%m%d') = DATE_FORMAT(NOW(), '%y%m%d') THEN
                    CASE 
                        WHEN LENGTH(CAST(RIGHT(qc_berverage_id, 4) AS UNSIGNED) + 1) = 1 THEN CONCAT('QCPB', DATE_FORMAT(NOW(), '%y%m%d'), '000', CAST(RIGHT(qc_berverage_id, 4) AS UNSIGNED) + 1)
                        WHEN LENGTH(CAST(RIGHT(qc_berverage_id, 4) AS UNSIGNED) + 1) = 2 THEN CONCAT('QCPB', DATE_FORMAT(NOW(), '%y%m%d'), '00', CAST(RIGHT(qc_berverage_id, 4) AS UNSIGNED) + 1)
                        WHEN LENGTH(CAST(RIGHT(qc_berverage_id, 4) AS UNSIGNED) + 1) = 3 THEN CONCAT('QCPB', DATE_FORMAT(NOW(), '%y%m%d'), '0', CAST(RIGHT(qc_berverage_id, 4) AS UNSIGNED) + 1)
                        ELSE CONCAT('QCPB', DATE_FORMAT(NOW(), '%y%m%d'), CAST(RIGHT(qc_berverage_id, 4) AS UNSIGNED) + 1)
                    END
                ELSE 
                    CONCAT('QCPB', DATE_FORMAT(NOW(), '%y%m%d'), '0001')
            END AS berverage_id
        INTO v_qc_berverage_id
        FROM qc_process_beverage
        ORDER BY qc_berverage_id DESC
        LIMIT 1;
    ELSE
        SET v_qc_berverage_id = CONCAT('QCPB', DATE_FORMAT(NOW(), '%y%m%d'), '0001');
    END IF;

    -- INSERT 작업 수행
    IF v_qc_berverage_id IS NOT NULL THEN
        INSERT INTO qc_process_beverage(qc_berverage_id, inspec_start, inspec_status, emp_num, process_num)
        VALUES (v_qc_berverage_id, CURRENT_TIMESTAMP, '검사요청완료', v_emp_num, v_process_num);

        -- INSERT 성공 여부 확인
        IF ROW_COUNT() = 1 THEN
            COMMIT;
            SET v_result = 'Success!';
        ELSE
            ROLLBACK;
            SET v_result = 'Fail...';
        END IF;
    ELSE
        ROLLBACK;
        SET v_result = 'Fail...';
    END IF;
    
    SELECT v_result AS result;

END//
DELIMITER ;

-- 프로시저 natureblend.qc_p_beverage_update_list 구조 내보내기
DELIMITER //
CREATE PROCEDURE `qc_p_beverage_update_list`(	IN v_qc_berverage_id VARCHAR(50),
    IN v_process_num INT,
    IN v_inspec_result VARCHAR(50),
    OUT v_result VARCHAR(20)
)
BEGIN
	DECLARE v_total_qty INT;
	DECLARE v_update_value INT;
    START TRANSACTION;

    -- 검사 테이블 갱신
    UPDATE qc_process_beverage
    SET   inspec_result = v_inspec_result,
          inspec_end = CURRENT_TIMESTAMP, 
          inspec_status = '검사완료'
    WHERE qc_berverage_id = v_qc_berverage_id;
    
    SET   v_update_value = ROW_COUNT();
    
    IF v_update_value = 1 then
		SELECT process_todo_qty
        INTO   v_total_qty
		FROM   process_work_body
		WHERE  process_num = v_process_num;
    
		IF v_inspec_result = "합격" THEN
			UPDATE process_work_body
			SET success_qty = v_total_qty, 
				fail_qty = 0
			WHERE process_num = v_process_num;
        ELSE 
			UPDATE process_work_body
			SET success_qty = 0, 
				fail_qty = v_total_qty
			WHERE process_num = v_process_num;
        END IF;
        
		SET v_update_value = ROW_COUNT();
        
		IF v_update_value = 1 then
			COMMIT;
			SET  v_result = 'Success';
		ELSE
			ROLLBACK;
			SET  v_result = 'Fail';
		END if;
	ELSE
		ROLLBACK;
		SET  v_result = 'Fail';
	END if;
    
    SELECT v_result AS result;

END//
DELIMITER ;

-- 프로시저 natureblend.qc_p_cleaning_input_list 구조 내보내기
DELIMITER //
CREATE PROCEDURE `qc_p_cleaning_input_list`(
    IN v_process_num INT,
    IN v_total_qnt INT,
    IN v_emp_num INT,
    OUT v_result VARCHAR(20)
)
BEGIN
    DECLARE v_count INT DEFAULT 0;
    DECLARE v_qc_cleaning_id VARCHAR(20);
    DECLARE v_result_value VARCHAR(20);

    -- 트랜잭션 시작
    START TRANSACTION;

    -- 테이블에 데이터가 있는지 확인
    SELECT COUNT(*) INTO v_count FROM qc_process_cleaning;

    -- qc_cleaning_id 생성
    IF v_count != 0 THEN
        SELECT 
            CASE 
                WHEN DATE_FORMAT(SUBSTRING(qc_cleaning_id, 5, 6), '%y%m%d') = DATE_FORMAT(NOW(), '%y%m%d') THEN
                    CASE 
                        WHEN LENGTH(CAST(RIGHT(qc_cleaning_id, 4) AS UNSIGNED) + 1) = 1 THEN CONCAT('QCPC', DATE_FORMAT(NOW(), '%y%m%d'), '000', CAST(RIGHT(qc_cleaning_id, 4) AS UNSIGNED) + 1)
                        WHEN LENGTH(CAST(RIGHT(qc_cleaning_id, 4) AS UNSIGNED) + 1) = 2 THEN CONCAT('QCPC', DATE_FORMAT(NOW(), '%y%m%d'), '00', CAST(RIGHT(qc_cleaning_id, 4) AS UNSIGNED) + 1)
                        WHEN LENGTH(CAST(RIGHT(qc_cleaning_id, 4) AS UNSIGNED) + 1) = 3 THEN CONCAT('QCPC', DATE_FORMAT(NOW(), '%y%m%d'), '0', CAST(RIGHT(qc_cleaning_id, 4) AS UNSIGNED) + 1)
                        ELSE CONCAT('QCPC', DATE_FORMAT(NOW(), '%y%m%d'), CAST(RIGHT(qc_cleaning_id, 4) AS UNSIGNED) + 1)
                    END
                ELSE 
                    CONCAT('QCPC', DATE_FORMAT(NOW(), '%y%m%d'), '0001')
            END AS cleaning_id
        INTO v_qc_cleaning_id
        FROM qc_process_cleaning
        ORDER BY qc_cleaning_id DESC
        LIMIT 1;
    ELSE
        SET v_qc_cleaning_id = CONCAT('QCPC', DATE_FORMAT(NOW(), '%y%m%d'), '0001');
    END IF;

    -- INSERT 작업 수행
    IF v_qc_cleaning_id IS NOT NULL THEN
        INSERT INTO qc_process_cleaning(qc_cleaning_id, total_qnt, inspec_start, inspec_status, emp_num, process_num)
        VALUES (v_qc_cleaning_id, v_total_qnt, CURRENT_TIMESTAMP, '검사요청완료', v_emp_num, v_process_num);

        -- INSERT 성공 여부 확인
        IF ROW_COUNT() = 1 THEN
            COMMIT;
            SET v_result = 'Success!';
        ELSE
            ROLLBACK;
            SET v_result = 'Fail...';
        END IF;
    ELSE
        ROLLBACK;
        SET v_result = 'Fail...';
    END IF;
    
    SELECT v_result AS result;

END//
DELIMITER ;

-- 프로시저 natureblend.qc_p_packaging_input_list 구조 내보내기
DELIMITER //
CREATE PROCEDURE `qc_p_packaging_input_list`(
    IN v_process_num INT,
    IN v_total_qnt INT,
    IN v_emp_num INT,
    OUT v_result VARCHAR(20)
)
BEGIN
    DECLARE v_count INT DEFAULT 0;
    DECLARE v_qc_packing_id VARCHAR(20);
    DECLARE v_result_value VARCHAR(20);

    -- 트랜잭션 시작
    START TRANSACTION;

    -- 테이블에 데이터가 있는지 확인
    SELECT COUNT(*) INTO v_count FROM qc_packaging;

    -- qc_cleaning_id 생성
    IF v_count != 0 THEN
        SELECT 
            CASE 
                WHEN DATE_FORMAT(SUBSTRING(qc_packing_id, 5, 6), '%y%m%d') = DATE_FORMAT(NOW(), '%y%m%d') THEN
                    CASE 
                        WHEN LENGTH(CAST(RIGHT(qc_packing_id, 4) AS UNSIGNED) + 1) = 1 THEN CONCAT('QCPP', DATE_FORMAT(NOW(), '%y%m%d'), '000', CAST(RIGHT(qc_packing_id, 4) AS UNSIGNED) + 1)
                        WHEN LENGTH(CAST(RIGHT(qc_packing_id, 4) AS UNSIGNED) + 1) = 2 THEN CONCAT('QCPP', DATE_FORMAT(NOW(), '%y%m%d'), '00', CAST(RIGHT(qc_packing_id, 4) AS UNSIGNED) + 1)
                        WHEN LENGTH(CAST(RIGHT(qc_packing_id, 4) AS UNSIGNED) + 1) = 3 THEN CONCAT('QCPP', DATE_FORMAT(NOW(), '%y%m%d'), '0', CAST(RIGHT(qc_packing_id, 4) AS UNSIGNED) + 1)
                        ELSE CONCAT('QCPP', DATE_FORMAT(NOW(), '%y%m%d'), CAST(RIGHT(qc_packing_id, 4) AS UNSIGNED) + 1)
                    END
                ELSE 
                    CONCAT('QCPP', DATE_FORMAT(NOW(), '%y%m%d'), '0001')
            END AS packing_id
        INTO v_qc_packing_id
        FROM qc_packaging
        ORDER BY qc_packing_id DESC
        LIMIT 1;
    ELSE
        SET v_qc_packing_id = CONCAT('QCPP', DATE_FORMAT(NOW(), '%y%m%d'), '0001');
    END IF;

    -- INSERT 작업 수행
    IF v_qc_packing_id IS NOT NULL THEN
        INSERT INTO qc_packaging(qc_packing_id, total_qnt, inspec_start, inspec_status, emp_num, process_num)
        VALUES (v_qc_packing_id, v_total_qnt, CURRENT_TIMESTAMP, '검사요청완료', v_emp_num, v_process_num);

        -- INSERT 성공 여부 확인
        IF ROW_COUNT() = 1 THEN
            COMMIT;
            SET v_result = 'Success!';
        ELSE
            ROLLBACK;
            SET v_result = 'Fail...';
        END IF;
    ELSE
        ROLLBACK;
        SET v_result = 'Fail...';
    END IF;
    
    SELECT v_result AS result;

END//
DELIMITER ;

-- 프로시저 natureblend.returnDelete 구조 내보내기
DELIMITER //
CREATE PROCEDURE `returnDelete`(
IN v_returnlist_num_json_array TEXT

)
BEGIN
DECLARE returnlist_num_array_length INT;

DECLARE returnlist_num_value TEXT;


DECLARE i INT DEFAULT 1;
DECLARE v_change_num INT;

    -- 트렌젝션 시작
    START TRANSACTION;
SET returnlist_num_array_length = JSON_LENGTH(v_returnlist_num_json_array);

-- returnlist_num 길이 만큼 for문 돌아서 업데이트 작업 하기
	WHILE i <= returnlist_num_array_length DO
		SET returnlist_num_value  = JSON_UNQUOTE(JSON_EXTRACT(v_returnlist_num_json_array , CONCAT('$[', i - 1, ']')));
		

-- 반품  삭제
DELETE FROM returnlists
WHERE returnlist_num  = returnlist_num_value;

		SET v_change_num = ROW_COUNT();
		IF v_change_num = 0 THEN 
			-- 오류 발생 시 롤백
			rollback;
		END IF;
		SET i = i + 1;
	END WHILE;
    -- 문제없을때
    COMMIT;

    -- 문제있을때
    ROLLBACK;

END//
DELIMITER ;

-- 테이블 natureblend.returnlists 구조 내보내기
CREATE TABLE IF NOT EXISTS `returnlists` (
  `returnlist_num` int(11) NOT NULL AUTO_INCREMENT,
  `client_num` int(11) NOT NULL,
  `product_code` varchar(30) NOT NULL,
  `return_num` int(11) NOT NULL DEFAULT 0,
  `return_date` datetime NOT NULL DEFAULT current_timestamp(),
  `return_code` varchar(30) NOT NULL COMMENT '반품사유코드(기준정보)',
  `emp_num` int(11) NOT NULL,
  `note` varchar(100) DEFAULT NULL COMMENT '기타반품사유',
  `output_num` int(11) NOT NULL,
  PRIMARY KEY (`returnlist_num`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- 테이블 데이터 natureblend.returnlists:~1 rows (대략적) 내보내기
INSERT INTO `returnlists` (`returnlist_num`, `client_num`, `product_code`, `return_num`, `return_date`, `return_code`, `emp_num`, `note`, `output_num`) VALUES
	(18, 6, 'P005', 5, '2025-01-07 14:23:36', 'RC011', 20250003, NULL, 63);

-- 프로시저 natureblend.returnUpdate 구조 내보내기
DELIMITER //
CREATE PROCEDURE `returnUpdate`(
IN v_returnlist_num_json_array TEXT,
IN v_return_num_json_array TEXT,
IN v_return_code_json_array TEXT 
)
BEGIN
DECLARE returnlist_num_array_length INT;

DECLARE returnlist_num_value TEXT;
DECLARE return_num_value TEXT;
DECLARE return_code_value TEXT;


DECLARE i INT DEFAULT 1;
DECLARE v_change_num INT;

    -- 트렌젝션 시작
    START TRANSACTION;
SET returnlist_num_array_length = JSON_LENGTH(v_returnlist_num_json_array);

-- returnlist_num 길이 만큼 for문 돌아서 업데이트 작업 하기
	WHILE i <= returnlist_num_array_length DO
		SET returnlist_num_value  = JSON_UNQUOTE(JSON_EXTRACT(v_returnlist_num_json_array , CONCAT('$[', i - 1, ']')));
		SET return_num_value   = JSON_UNQUOTE(JSON_EXTRACT(v_return_num_json_array  , CONCAT('$[', i - 1, ']')));
        SET return_code_value   = JSON_UNQUOTE(JSON_EXTRACT(v_return_code_json_array  , CONCAT('$[', i - 1, ']')));
        

-- 반품량,반품코드 업데이트 
UPDATE returnlists
SET return_num = return_num_value ,
	return_code = return_code_value 
WHERE returnlist_num  = returnlist_num_value;

		SET v_change_num = ROW_COUNT();
		IF v_change_num = 0 THEN 
			-- 오류 발생 시 롤백
			rollback;
		END IF;
		SET i = i + 1;
	END WHILE;
    -- 문제없을때
    COMMIT;

    -- 문제있을때
    ROLLBACK;

END//
DELIMITER ;

-- 테이블 natureblend.return_code 구조 내보내기
CREATE TABLE IF NOT EXISTS `return_code` (
  `return_code` varchar(30) NOT NULL,
  `return_reason` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`return_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- 테이블 데이터 natureblend.return_code:~20 rows (대략적) 내보내기
INSERT INTO `return_code` (`return_code`, `return_reason`) VALUES
	('RC001', '기타'),
	('RC002', '배송 중 파손'),
	('RC003', '사이즈가 맞지 않음'),
	('RC004', '색상이 예상과 다름'),
	('RC005', '설명서와 다른 제품 수령'),
	('RC006', '배송 지연'),
	('RC007', '중복 주문'),
	('RC008', '불필요한 구매'),
	('RC009', '결제 오류로 인한 취소'),
	('RC010', '구매 후 가격 차이 발견'),
	('RC011', '이물질발견'),
	('RC012', '제품이 너무 무겁거나 부피가 큼'),
	('RC013', '고객의 주소 오류'),
	('RC014', '재고 부족으로 취소'),
	('RC015', '세부 사항 미제공'),
	('RC016', '제작 불가능한 주문'),
	('RC017', '제품에 이상 없음 (단순 변심)'),
	('RC018', '제품이 너무 비쌈'),
	('RC019', '구매한 상품이 타 제품과 다름'),
	('RC020', '설명된 기능 미제공');

-- 테이블 natureblend.test 구조 내보내기
CREATE TABLE IF NOT EXISTS `test` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `last_login` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- 테이블 데이터 natureblend.test:~4 rows (대략적) 내보내기
INSERT INTO `test` (`id`, `username`, `email`, `last_login`) VALUES
	(1, 'hayeon', 'hayeon@kakao.com', '2024-12-24 11:33:52'),
	(3, 'jane_doe', 'jane@example.com', '2024-12-19 16:49:18'),
	(4, NULL, 'jane@example.com', '2024-12-19 16:49:02'),
	(5, 'hayeon', 'hayeon@kakao.com', '2024-12-24 11:36:24');

-- 프로시저 natureblend.test 구조 내보내기
DELIMITER //
CREATE PROCEDURE `test`(
	IN `v_emp_name` VARCHAR(50),
	IN `v_com_name` VARCHAR(50)
)
BEGIN
DECLARE v_emp_num INT;
DECLARE v_com_num INT;

SELECT emp_num
INTO v_emp_num
FROM employee
WHERE name = v_emp_name ;

-- 회사이름
SELECT client_num
INTO v_com_num
FROM client
WHERE com_name = v_com_name;



SELECT  v_emp_num,v_com_num ;


END//
DELIMITER ;

-- 테이블 natureblend.warehouse 구조 내보내기
CREATE TABLE IF NOT EXISTS `warehouse` (
  `warehouse_code` varchar(30) NOT NULL,
  `warehouse_name` varchar(30) NOT NULL,
  `storage` varchar(30) NOT NULL,
  `warehouse_location` varchar(30) NOT NULL,
  `emp_name` varchar(20) NOT NULL,
  `emp_tel` varchar(30) NOT NULL,
  `warehouse_area` varchar(30) NOT NULL,
  PRIMARY KEY (`warehouse_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- 테이블 데이터 natureblend.warehouse:~11 rows (대략적) 내보내기
INSERT INTO `warehouse` (`warehouse_code`, `warehouse_name`, `storage`, `warehouse_location`, `emp_name`, `emp_tel`, `warehouse_area`) VALUES
	('W001', '과일창고', '가능', '자재창고1', '김담당', '010-8521-6704', '3305'),
	('W002', '가루창고', '가능', '자재창고2', '이담당', '010-7575-3344', '3305'),
	('W003', '폐기창고', '가능', '자재창고3', '김담당', '010-1111-2222', '3305'),
	('W004', '제품창고1', '가능', '물류3', '정담당', '010-4512-4451', '3305'),
	('W005', '제품창고2', '가능', '물류1', '정담당', '010-4512-4451', '3306'),
	('W006', '제품창고3', '가능', '물류5', '정담당', '010-4512-4451', '3306'),
	('W007', '제품창고4', '불가능', '물류2', '정담당', '010-4512-4451', '3306'),
	('W008', '제품창고5', '불가능', '물류4', '정담당', '010-4512-4451', '3306'),
	('W009', '제품창고6', '가능', '물류5', '정담당', '010-4512-4451', '3306'),
	('W010', '빈병창고', '가능', '자재창고4', '김담당', '010-1111-2222', '3305'),
	('W011', '영구창고', '가능', '영구', '나불멸', '010-1123-3321', '3305');

-- 함수 natureblend.your_client 구조 내보내기
DELIMITER //
CREATE FUNCTION `your_client`(v_material_code varchar(50),
    v_colnum varchar(50)
) RETURNS varchar(50) CHARSET utf8mb3 COLLATE utf8mb3_general_ci
    DETERMINISTIC
BEGIN
	declare v_return_data varchar(50);
	
	SELECT
        CASE 
            WHEN v_colnum = 'com_num' THEN com_num
            WHEN v_colnum = 'com_name' THEN com_name
            WHEN v_colnum = 'address' THEN address
            WHEN v_colnum = 'trade' THEN trade
            WHEN v_colnum = 'boss' THEN boss
            WHEN v_colnum = 'boss_tel' THEN boss_tel
            WHEN v_colnum = 'emp_name' THEN emp_name
            WHEN v_colnum = 'emp_tel' THEN emp_tel
            ELSE 'Invalid Column'
        END
    INTO v_return_data
    FROM client		-- 테이블명 명시 필요!!
    WHERE client_num = v_material_code;	-- 조건 명시 필요!!
    
    RETURN v_return_data;
END//
DELIMITER ;

-- 함수 natureblend.your_employee 구조 내보내기
DELIMITER //
CREATE FUNCTION `your_employee`(v_material_code varchar(50),
    v_colnum varchar(50)
) RETURNS varchar(50) CHARSET utf8mb3 COLLATE utf8mb3_general_ci
    DETERMINISTIC
BEGIN
	declare v_return_data varchar(50);
	
	SELECT
        CASE 
            WHEN v_colnum = 'name' THEN name
            WHEN v_colnum = 'birth' THEN birth
            WHEN v_colnum = 'tel' THEN tel
            WHEN v_colnum = 'job' THEN job
            WHEN v_colnum = 'job_num' THEN job_num
            WHEN v_colnum = 'position' THEN position
            WHEN v_colnum = 'employment_date' THEN employment_date
            WHEN v_colnum = 'resignation_date' THEN resignation_date
            WHEN v_colnum = 'level' THEN level
            ELSE 'Invalid Column'
        END
    INTO v_return_data
    FROM employee		-- 테이블명 명시 필요!!
    WHERE emp_num = v_material_code;	-- 조건 명시 필요!!
    
    RETURN v_return_data;
END//
DELIMITER ;

-- 함수 natureblend.your_faulty_code 구조 내보내기
DELIMITER //
CREATE FUNCTION `your_faulty_code`(v_material_code varchar(50),
    v_colnum varchar(50)
) RETURNS varchar(50) CHARSET utf8mb3 COLLATE utf8mb3_general_ci
    DETERMINISTIC
BEGIN
	declare v_return_data varchar(50);
	
	SELECT
        CASE 
            WHEN v_colnum = 'faulty_reason' THEN faulty_reason
            ELSE 'Invalid Column'
        END
    INTO v_return_data
    FROM faulty_code		-- 테이블명 명시 필요!!
    WHERE faulty_code = v_material_code;	-- 조건 명시 필요!!
    
    RETURN v_return_data;
END//
DELIMITER ;

-- 함수 natureblend.your_machine 구조 내보내기
DELIMITER //
CREATE FUNCTION `your_machine`(v_machine_num int,
    v_colnum varchar(50)
) RETURNS varchar(50) CHARSET utf8mb3 COLLATE utf8mb3_general_ci
    DETERMINISTIC
BEGIN
	declare v_return_data varchar(50);
	
	SELECT
        CASE 
            WHEN v_colnum = 'machine_name' THEN machine_name
            WHEN v_colnum = 'model_num' THEN model_num
            WHEN v_colnum = 'machine_location' THEN machine_location
            WHEN v_colnum = 'machine_state' THEN machine_state
            WHEN v_colnum = 'process_code' THEN process_code
            ELSE 'Invalid Column'
        END
    INTO v_return_data
    FROM machine		
    WHERE machine_num = v_machine_num;	
    
    RETURN v_return_data;
END//
DELIMITER ;

-- 함수 natureblend.your_material 구조 내보내기
DELIMITER //
CREATE FUNCTION `your_material`(`v_material_code` varchar(50),
	`v_colnum` varchar(50)
) RETURNS varchar(50) CHARSET utf8mb3 COLLATE utf8mb3_general_ci
    DETERMINISTIC
BEGIN
	declare v_return_data varchar(50);
	
	SELECT
        CASE 
            WHEN v_colnum = 'material_name' THEN material_name
            WHEN v_colnum = 'safety_inventory' THEN safety_inventory
            WHEN v_colnum = 'expiration_date' THEN expiration_date
            WHEN v_colnum = 'regi_date' THEN regi_date
            ELSE 'Invalid Column'
        END
    INTO v_return_data
    FROM material
    WHERE material_code = v_material_code;
    
    RETURN v_return_data;
END//
DELIMITER ;

-- 함수 natureblend.your_product 구조 내보내기
DELIMITER //
CREATE FUNCTION `your_product`(v_material_code varchar(50),
    v_colnum varchar(50)
) RETURNS varchar(50) CHARSET utf8mb3 COLLATE utf8mb3_general_ci
    DETERMINISTIC
BEGIN
	declare v_return_data varchar(50);
	
	SELECT
        CASE 
            WHEN v_colnum = 'product_name' THEN product_name
            WHEN v_colnum = 'expiration_date' THEN expiration_date
            WHEN v_colnum = 'capacity' THEN capacity
            ELSE 'Invalid Column'
        END
    INTO v_return_data
    FROM product		-- 테이블명 명시 필요!!
    WHERE product_code = v_material_code;	-- 조건 명시 필요!!
    
    RETURN v_return_data;
END//
DELIMITER ;

-- 함수 natureblend.your_return_code 구조 내보내기
DELIMITER //
CREATE FUNCTION `your_return_code`(v_material_code varchar(50),
    v_colnum varchar(50)
) RETURNS varchar(50) CHARSET utf8mb3 COLLATE utf8mb3_general_ci
    DETERMINISTIC
BEGIN
	declare v_return_data varchar(50);
	
	SELECT
        CASE 
            WHEN v_colnum = 'return_reason' THEN return_reason
            ELSE 'Invalid Column'
        END
    INTO v_return_data
    FROM return_code		-- 테이블명 명시 필요!!
    WHERE return_code = v_material_code;	-- 조건 명시 필요!!
    
    RETURN v_return_data;
END//
DELIMITER ;

-- 함수 natureblend.your_warehouse 구조 내보내기
DELIMITER //
CREATE FUNCTION `your_warehouse`(v_material_code varchar(50),
    v_colnum varchar(50)
) RETURNS varchar(50) CHARSET utf8mb3 COLLATE utf8mb3_general_ci
    DETERMINISTIC
BEGIN
	declare v_return_data varchar(50);
	
	SELECT
        CASE 
            WHEN v_colnum = 'warehouse_name' THEN warehouse_name
            WHEN v_colnum = 'storage' THEN storage
            WHEN v_colnum = 'warehouse_location' THEN warehouse_location
            WHEN v_colnum = 'emp_name' THEN emp_name
            WHEN v_colnum = 'emp_tel' THEN emp_tel
            WHEN v_colnum = 'warehouse_area' THEN warehouse_area
            ELSE 'Invalid Column'
        END
    INTO v_return_data
    FROM warehouse		-- 테이블명 명시 필요!!
    WHERE warehouse_code = v_material_code;	-- 조건 명시 필요!!
    
    RETURN v_return_data;
END//
DELIMITER ;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
