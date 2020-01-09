-- MySQL dump 10.13  Distrib 5.1.61, for Win64 (unknown)
--
-- Host: localhost    Database: ptls
-- ------------------------------------------------------
-- Server version	5.1.61-community

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `gross`
--

DROP TABLE IF EXISTS `gross`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gross` (
  `SN` int(10) unsigned NOT NULL DEFAULT '0',
  `ReadDate` int(10) unsigned NOT NULL DEFAULT '0',
  `RealReadDate` datetime DEFAULT NULL,
  `TCh1` bigint(20) unsigned DEFAULT '0',
  `TCh2` bigint(20) unsigned DEFAULT '0',
  `TCh3` bigint(20) unsigned DEFAULT '0',
  `TCh4` bigint(20) unsigned DEFAULT '0',
  `TCh5` bigint(20) unsigned DEFAULT '0',
  `TCh6` bigint(20) unsigned DEFAULT '0',
  `TCh7` bigint(20) unsigned DEFAULT '0',
  `TCh8` bigint(20) unsigned DEFAULT '0',
  `LastRead` datetime DEFAULT NULL,
  `mLastRead` datetime DEFAULT NULL,
  PRIMARY KEY (`SN`),
  KEY `SN` (`SN`,`ReadDate`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tmp`
--

DROP TABLE IF EXISTS `tmp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tmp` (
  `SN` int(10) unsigned NOT NULL DEFAULT '0',
  `ReadDate` int(10) unsigned NOT NULL DEFAULT '0',
  `RealReadDate` datetime DEFAULT NULL,
  `Ch1` mediumint(8) unsigned DEFAULT '0',
  `Ch2` mediumint(8) unsigned DEFAULT '0',
  `Ch3` mediumint(8) unsigned DEFAULT '0',
  `Ch4` mediumint(8) unsigned DEFAULT '0',
  `Ch5` mediumint(8) unsigned DEFAULT '0',
  `Ch6` mediumint(8) unsigned DEFAULT '0',
  `Ch7` mediumint(8) unsigned DEFAULT '0',
  `Ch8` mediumint(8) unsigned DEFAULT '0',
  `Confirmed` tinyint(3) unsigned DEFAULT '0',
  PRIMARY KEY (`SN`,`ReadDate`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-01-09 15:46:52
