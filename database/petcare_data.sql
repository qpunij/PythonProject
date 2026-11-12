-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: petcare
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `pet`
--

LOCK TABLES `pet` WRITE;
/*!40000 ALTER TABLE `pet` DISABLE KEYS */;
INSERT INTO `pet` (`id`, `name`, `species`, `gender`, `age`, `weight`, `created`, `owner_id`) VALUES (1,'豆豆','狗','公',3,12.50,'2026-11-12 07:04:04.143889',2);
INSERT INTO `pet` (`id`, `name`, `species`, `gender`, `age`, `weight`, `created`, `owner_id`) VALUES (2,'咪咪','猫','母',2,4.20,'2026-11-12 07:04:04.146943',2);
INSERT INTO `pet` (`id`, `name`, `species`, `gender`, `age`, `weight`, `created`, `owner_id`) VALUES (3,'小白','兔','公',1,1.80,'2026-11-12 07:04:04.148473',2);
/*!40000 ALTER TABLE `pet` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `sickness_record`
--

LOCK TABLES `sickness_record` WRITE;
/*!40000 ALTER TABLE `sickness_record` DISABLE KEYS */;
INSERT INTO `sickness_record` (`id`, `disease`, `symptom`, `visit_date`, `hospital`, `medicine`, `cost`, `status`, `created`, `pet_id`) VALUES (1,'急性肠胃炎','不吃东西，呕吐两次','2026-11-10','市宠物医院','益生菌、止吐针',260.00,'治疗中','2026-11-12 07:04:04.151000',1);
INSERT INTO `sickness_record` (`id`, `disease`, `symptom`, `visit_date`, `hospital`, `medicine`, `cost`, `status`, `created`, `pet_id`) VALUES (2,'皮肤病','背上一块掉毛，总是挠','2026-10-03','爱宠诊所','外用喷剂',120.00,'已痊愈','2026-11-12 07:04:04.153091',1);
INSERT INTO `sickness_record` (`id`, `disease`, `symptom`, `visit_date`, `hospital`, `medicine`, `cost`, `status`, `created`, `pet_id`) VALUES (3,'猫鼻支','打喷嚏，流眼泪，精神差','2026-11-06','市宠物医院','滴眼液、消炎药',340.00,'治疗中','2026-11-12 07:04:04.154619',2);
INSERT INTO `sickness_record` (`id`, `disease`, `symptom`, `visit_date`, `hospital`, `medicine`, `cost`, `status`, `created`, `pet_id`) VALUES (4,'耳螨','总甩头，耳朵里有黑点','2026-08-14','爱宠诊所','耳康滴耳液',80.00,'已痊愈','2026-11-12 07:04:04.157659',2);
INSERT INTO `sickness_record` (`id`, `disease`, `symptom`, `visit_date`, `hospital`, `medicine`, `cost`, `status`, `created`, `pet_id`) VALUES (5,'牙齿过长','吃东西慢，流口水','2026-10-28','市宠物医院','修剪牙齿',150.00,'已痊愈','2026-11-12 07:04:04.159187',3);
/*!40000 ALTER TABLE `sickness_record` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-12 15:05:02
