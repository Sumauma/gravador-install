-- MySQL dump 10.13  Distrib 8.0.36, for Linux (x86_64)
--
-- Host: localhost    Database: cdrs
-- ------------------------------------------------------
-- Server version	8.0.36-2ubuntu3

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
-- Table structure for table `cdr`
--

DROP TABLE IF EXISTS `cdr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cdr` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `callid` varchar(512) NOT NULL,
  `fromtel` varchar(512) NOT NULL,
  `totel` varchar(512) NOT NULL,
  `sessionid` varchar(512) NOT NULL,
  `created` datetime NOT NULL,
  `updated` datetime DEFAULT NULL,
  `associatetime` datetime NOT NULL,
  `xml` varchar(8192) NOT NULL,
  `filename` varchar(1024) DEFAULT NULL,
  `isrcallid` varchar(512) DEFAULT NULL,
  `isrucid` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_cdr_callid` (`callid`),
  KEY `idx_cdr_sessionid` (`sessionid`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cdr`
--

LOCK TABLES `cdr` WRITE;
/*!40000 ALTER TABLE `cdr` DISABLE KEYS */;
INSERT INTO `cdr` VALUES (1,'1234','1234','1235','1234567890','2022-04-24 22:11:36','2022-04-24 22:11:37','2022-04-24 22:11:36','<xml>banana</xml>','macaco.wav',NULL,NULL);
/*!40000 ALTER TABLE `cdr` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-05-20 13:35:52
