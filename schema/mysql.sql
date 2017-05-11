-- MySQL dump 10.13  Distrib 5.7.17, for Linux (x86_64)
--
-- Host: localhost    Database: muscope
-- ------------------------------------------------------
-- Server version	5.7.17

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
-- Table structure for table `app`
--

DROP TABLE IF EXISTS `app`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `app` (
  `app_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `app_name` varchar(50) NOT NULL,
  `is_active` tinyint(4) DEFAULT '1',
  `protocol` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`app_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `app_run`
--

DROP TABLE IF EXISTS `app_run`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `app_run` (
  `app_run_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `app_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `app_ran_at` datetime DEFAULT NULL,
  `params` text,
  PRIMARY KEY (`app_run_id`),
  KEY `user_id` (`user_id`),
  KEY `app_id` (`app_id`),
  CONSTRAINT `app_run_ibfk_1` FOREIGN KEY (`app_id`) REFERENCES `app` (`app_id`),
  CONSTRAINT `app_run_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cast`
--

DROP TABLE IF EXISTS `cast`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cast` (
  `cast_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `station_id` int(10) unsigned DEFAULT NULL,
  `cast_number` int(10) unsigned DEFAULT NULL,
  `collection_date` date DEFAULT NULL,
  `collection_time` time DEFAULT NULL,
  `collection_time_zone` varchar(20) NOT NULL DEFAULT '',
  PRIMARY KEY (`cast_id`),
  UNIQUE KEY `station_id` (`station_id`,`cast_number`),
  CONSTRAINT `cast_ibfk_1` FOREIGN KEY (`station_id`) REFERENCES `station` (`station_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=105 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cruise`
--

DROP TABLE IF EXISTS `cruise`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cruise` (
  `cruise_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `cruise_name` varchar(50) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  PRIMARY KEY (`cruise_id`),
  UNIQUE KEY `cruise_name_2` (`cruise_name`),
  KEY `cruise_name` (`cruise_name`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cruise_core_ctd`
--

DROP TABLE IF EXISTS `cruise_core_ctd`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cruise_core_ctd` (
  `cruise_core_ctd_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `cruise_id` int(10) unsigned DEFAULT NULL,
  `ctd_type_id` int(10) unsigned DEFAULT NULL,
  `ctd_value` float NOT NULL,
  PRIMARY KEY (`cruise_core_ctd_id`),
  KEY `cruise_id` (`cruise_id`),
  KEY `ctd_type_id` (`ctd_type_id`),
  CONSTRAINT `cruise_core_ctd_ibfk_1` FOREIGN KEY (`cruise_id`) REFERENCES `cruise` (`cruise_id`) ON DELETE CASCADE,
  CONSTRAINT `cruise_core_ctd_ibfk_2` FOREIGN KEY (`ctd_type_id`) REFERENCES `ctd_type` (`ctd_type_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ctd_type`
--

DROP TABLE IF EXISTS `ctd_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ctd_type` (
  `ctd_type_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ctd_type` varchar(100) DEFAULT NULL,
  `unit` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`ctd_type_id`),
  KEY `ctd_type` (`ctd_type`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `investigator`
--

DROP TABLE IF EXISTS `investigator`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `investigator` (
  `investigator_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `institution` varchar(255) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `project` text,
  `bio` text,
  PRIMARY KEY (`investigator_id`),
  UNIQUE KEY `first_name` (`first_name`,`last_name`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `login`
--

DROP TABLE IF EXISTS `login`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `login` (
  `login_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `login_date` datetime NOT NULL,
  PRIMARY KEY (`login_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `login_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `query_log`
--

DROP TABLE IF EXISTS `query_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `query_log` (
  `query_log_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `num_found` int(10) unsigned DEFAULT NULL,
  `query` text,
  `params` text,
  `ip` text,
  `user_id` text,
  `time` double DEFAULT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`query_log_id`)
) ENGINE=MyISAM AUTO_INCREMENT=97 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample`
--

DROP TABLE IF EXISTS `sample`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sample` (
  `sample_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `cast_id` int(10) unsigned DEFAULT NULL,
  `investigator_id` int(10) unsigned NOT NULL DEFAULT '1',
  `sample_name` varchar(255) DEFAULT NULL,
  `seq_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`sample_id`),
  UNIQUE KEY `cast_id` (`cast_id`,`sample_name`),
  KEY `sample_name` (`sample_name`),
  KEY `investigator_id` (`investigator_id`),
  CONSTRAINT `sample_ibfk_1` FOREIGN KEY (`cast_id`) REFERENCES `cast` (`cast_id`) ON DELETE CASCADE,
  CONSTRAINT `sample_ibfk_6` FOREIGN KEY (`investigator_id`) REFERENCES `investigator` (`investigator_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=591 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_attr`
--

DROP TABLE IF EXISTS `sample_attr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sample_attr` (
  `sample_attr_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sample_attr_type_id` int(10) unsigned NOT NULL,
  `sample_id` int(10) unsigned NOT NULL,
  `value` varchar(255) NOT NULL,
  PRIMARY KEY (`sample_attr_id`),
  UNIQUE KEY `sample_id` (`sample_id`,`sample_attr_type_id`,`value`),
  KEY `sample_attr_type_id` (`sample_attr_type_id`),
  CONSTRAINT `sample_attr_ibfk_2` FOREIGN KEY (`sample_id`) REFERENCES `sample` (`sample_id`) ON DELETE CASCADE,
  CONSTRAINT `sample_attr_ibfk_3` FOREIGN KEY (`sample_attr_type_id`) REFERENCES `sample_attr_type` (`sample_attr_type_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9759 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_attr_type`
--

DROP TABLE IF EXISTS `sample_attr_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sample_attr_type` (
  `sample_attr_type_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sample_attr_type_category_id` int(10) unsigned DEFAULT NULL,
  `type` varchar(100) NOT NULL,
  `unit` varchar(20) DEFAULT NULL,
  `url_template` varchar(255) DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`sample_attr_type_id`),
  UNIQUE KEY `type` (`type`),
  KEY `sample_attr_type_category_id` (`sample_attr_type_category_id`),
  CONSTRAINT `sample_attr_type_ibfk_1` FOREIGN KEY (`sample_attr_type_category_id`) REFERENCES `sample_attr_type_category` (`sample_attr_type_category_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_attr_type_alias`
--

DROP TABLE IF EXISTS `sample_attr_type_alias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sample_attr_type_alias` (
  `sample_attr_type_alias_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sample_attr_type_id` int(10) unsigned NOT NULL,
  `alias` varchar(100) NOT NULL,
  PRIMARY KEY (`sample_attr_type_alias_id`),
  UNIQUE KEY `sample_attr_type_id` (`sample_attr_type_id`,`alias`),
  CONSTRAINT `sample_attr_type_alias_ibfk_1` FOREIGN KEY (`sample_attr_type_id`) REFERENCES `sample_attr_type` (`sample_attr_type_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_attr_type_category`
--

DROP TABLE IF EXISTS `sample_attr_type_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sample_attr_type_category` (
  `sample_attr_type_category_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `category` varchar(100) NOT NULL,
  PRIMARY KEY (`sample_attr_type_category_id`),
  UNIQUE KEY `category` (`category`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_file`
--

DROP TABLE IF EXISTS `sample_file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sample_file` (
  `sample_file_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sample_id` int(10) unsigned NOT NULL,
  `sample_file_type_id` int(10) unsigned NOT NULL DEFAULT '1',
  `file` varchar(200) DEFAULT NULL,
  `num_seqs` int(11) DEFAULT NULL,
  `num_bp` bigint(20) unsigned DEFAULT NULL,
  `avg_len` int(11) DEFAULT NULL,
  `pct_gc` double DEFAULT NULL,
  PRIMARY KEY (`sample_file_id`),
  UNIQUE KEY `sample_id` (`sample_id`,`sample_file_type_id`,`file`),
  KEY `sample_id_2` (`sample_id`),
  KEY `sample_file_type_id` (`sample_file_type_id`),
  CONSTRAINT `sample_file_ibfk_4` FOREIGN KEY (`sample_file_type_id`) REFERENCES `sample_file_type` (`sample_file_type_id`) ON DELETE CASCADE,
  CONSTRAINT `sample_file_ibfk_5` FOREIGN KEY (`sample_id`) REFERENCES `sample` (`sample_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1790 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_file_type`
--

DROP TABLE IF EXISTS `sample_file_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sample_file_type` (
  `sample_file_type_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL,
  PRIMARY KEY (`sample_file_type_id`),
  UNIQUE KEY `type` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `search`
--

DROP TABLE IF EXISTS `search`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `search` (
  `search_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `table_name` varchar(100) DEFAULT NULL,
  `primary_key` int(10) unsigned DEFAULT NULL,
  `search_text` longtext,
  PRIMARY KEY (`search_id`),
  FULLTEXT KEY `search_text` (`search_text`)
) ENGINE=MyISAM AUTO_INCREMENT=7270 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `station`
--

DROP TABLE IF EXISTS `station`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `station` (
  `station_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `cruise_id` int(10) unsigned NOT NULL,
  `station_number` int(10) unsigned DEFAULT NULL,
  `latitude` float DEFAULT NULL,
  `longitude` float DEFAULT NULL,
  PRIMARY KEY (`station_id`),
  UNIQUE KEY `cruise_id` (`cruise_id`,`station_number`),
  CONSTRAINT `station_ibfk_1` FOREIGN KEY (`cruise_id`) REFERENCES `cruise` (`cruise_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=67 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `user_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_name` varchar(50) NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_name` (`user_name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-05-11  9:43:08
