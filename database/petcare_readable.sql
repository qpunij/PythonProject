-- ================================================================
-- 宠物生病管理系统  数据库脚本
--    数据库：petcare        字符集：utf8mb4      引擎：InnoDB
--
-- 说明：
--   1. 这里列出与业务相关的 3 张表，方便阅读和写报告；
--      auth_user 虽然是 Django 自带的，但 pet 表有外键指向它，
--      所以必须一起建，否则建表会报错。
--   2. 其余 Django 表（auth_group、django_session、django_migrations 等）
--      执行 python manage.py migrate 会自动创建。
--   3. 要完整还原整个库（13 张表 + 全部数据 + 账号），请用 petcare_full.sql。
-- ================================================================

CREATE DATABASE IF NOT EXISTS `petcare` DEFAULT CHARACTER SET utf8mb4;
USE `petcare`;

-- ----------------------------------------------------------------
-- auth_user / 用户表（Django 自带，此处列出是因为 pet 表有外键指向它）
-- ----------------------------------------------------------------
CREATE TABLE `auth_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `password` varchar(128) COLLATE utf8mb4_general_ci NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `first_name` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `last_name` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(254) COLLATE utf8mb4_general_ci NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------------------------------------------
-- pet / 宠物信息表
-- ----------------------------------------------------------------
CREATE TABLE `pet` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `species` varchar(10) COLLATE utf8mb4_general_ci NOT NULL,
  `gender` varchar(2) COLLATE utf8mb4_general_ci NOT NULL,
  `age` int unsigned NOT NULL,
  `weight` decimal(5,2) NOT NULL,
  `created` datetime(6) NOT NULL,
  `owner_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `pet_owner_id_efe81f2f_fk_auth_user_id` (`owner_id`),
  CONSTRAINT `pet_owner_id_efe81f2f_fk_auth_user_id` FOREIGN KEY (`owner_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `pet_chk_1` CHECK ((`age` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------------------------------------------
-- sickness_record / 就诊记录表
-- ----------------------------------------------------------------
CREATE TABLE `sickness_record` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `disease` varchar(30) COLLATE utf8mb4_general_ci NOT NULL,
  `symptom` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `visit_date` date NOT NULL,
  `hospital` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `medicine` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `cost` decimal(8,2) NOT NULL,
  `status` varchar(10) COLLATE utf8mb4_general_ci NOT NULL,
  `created` datetime(6) NOT NULL,
  `pet_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sickness_record_pet_id_40a31ee5_fk_pet_id` (`pet_id`),
  CONSTRAINT `sickness_record_pet_id_40a31ee5_fk_pet_id` FOREIGN KEY (`pet_id`) REFERENCES `pet` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------------------------------------------
-- 初始数据：用户（密码为 pbkdf2 加盐哈希，非明文）
--     admin    / admin123456   超级管理员
--     xiaoming / xm123456     普通用户
-- ----------------------------------------------------------------
INSERT INTO `auth_user` VALUES (1,'pbkdf2_sha256$720000$CqUFNtGA5OCeEQAPxAvk3J$gED78To9OmqLTBs8wAe7CrokM/ToD2RAuGrVq48ATQQ=',NULL,1,'admin','','','admin@example.com',1,1,'2026-11-12 07:04:03.642189'),(2,'pbkdf2_sha256$720000$SsSqLbUnMf1KE1vU4l1X7Y$6LG9k/CaYncKt0O3Ib0UdGvcgU18/NF0dv5GY7E6DCk=','2026-11-12 07:04:27.120199',0,'xiaoming','小明','','xm@example.com',0,1,'2026-11-12 07:04:03.892749');

-- ----------------------------------------------------------------
-- 初始数据：宠物
-- ----------------------------------------------------------------
INSERT INTO `pet` (`id`, `name`, `species`, `gender`, `age`, `weight`, `created`, `owner_id`) VALUES (1,'豆豆','狗','公',3,12.50,'2026-11-12 07:04:04.143889',2);
INSERT INTO `pet` (`id`, `name`, `species`, `gender`, `age`, `weight`, `created`, `owner_id`) VALUES (2,'咪咪','猫','母',2,4.20,'2026-11-12 07:04:04.146943',2);
INSERT INTO `pet` (`id`, `name`, `species`, `gender`, `age`, `weight`, `created`, `owner_id`) VALUES (3,'小白','兔','公',1,1.80,'2026-11-12 07:04:04.148473',2);

-- ----------------------------------------------------------------
-- 初始数据：就诊记录
-- ----------------------------------------------------------------
INSERT INTO `sickness_record` (`id`, `disease`, `symptom`, `visit_date`, `hospital`, `medicine`, `cost`, `status`, `created`, `pet_id`) VALUES (1,'急性肠胃炎','不吃东西，呕吐两次','2026-11-10','市宠物医院','益生菌、止吐针',260.00,'治疗中','2026-11-12 07:04:04.151000',1);
INSERT INTO `sickness_record` (`id`, `disease`, `symptom`, `visit_date`, `hospital`, `medicine`, `cost`, `status`, `created`, `pet_id`) VALUES (2,'皮肤病','背上一块掉毛，总是挠','2026-10-03','爱宠诊所','外用喷剂',120.00,'已痊愈','2026-11-12 07:04:04.153091',1);
INSERT INTO `sickness_record` (`id`, `disease`, `symptom`, `visit_date`, `hospital`, `medicine`, `cost`, `status`, `created`, `pet_id`) VALUES (3,'猫鼻支','打喷嚏，流眼泪，精神差','2026-11-06','市宠物医院','滴眼液、消炎药',340.00,'治疗中','2026-11-12 07:04:04.154619',2);
INSERT INTO `sickness_record` (`id`, `disease`, `symptom`, `visit_date`, `hospital`, `medicine`, `cost`, `status`, `created`, `pet_id`) VALUES (4,'耳螨','总甩头，耳朵里有黑点','2026-08-14','爱宠诊所','耳康滴耳液',80.00,'已痊愈','2026-11-12 07:04:04.157659',2);
INSERT INTO `sickness_record` (`id`, `disease`, `symptom`, `visit_date`, `hospital`, `medicine`, `cost`, `status`, `created`, `pet_id`) VALUES (5,'牙齿过长','吃东西慢，流口水','2026-10-28','市宠物医院','修剪牙齿',150.00,'已痊愈','2026-11-12 07:04:04.159187',3);
