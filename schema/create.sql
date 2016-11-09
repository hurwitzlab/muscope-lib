SET foreign_key_checks = 0;

DROP TABLE IF EXISTS cruise;
CREATE TABLE cruise (
  cruise_id int unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  cruise_name varchar(50) DEFAULT NULL,
  start_date date,
  end_date date,
  KEY (cruise_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS cruise_core_ctd;
CREATE TABLE cruise_core_ctd (
  cruise_core_ctd_id int unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  cruise_id int unsigned,
  ctd_type_id int unsigned,
  ctd_value float NOT NULL,
  FOREIGN KEY (cruise_id) REFERENCES cruise (cruise_id) ON DELETE CASCADE,
  FOREIGN KEY (ctd_type_id) REFERENCES ctd_type (ctd_type_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS ctd_type;
CREATE TABLE ctd_type (
  ctd_type_id int unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  ctd_type varchar(100),
  unit varchar(20),
  KEY (ctd_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS investigator;
CREATE TABLE investigator (
  investigator_id int unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  investigator_name varchar(50) DEFAULT NULL,
  institution varchar(255) DEFAULT NULL,
  KEY (investigator_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS station;
CREATE TABLE station (
  station_id int unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  cruise_id int unsigned NOT NULL,
  station_number int unsigned,
  latitude float,
  longitude float,
  UNIQUE (cruise_id, station_number),
  FOREIGN KEY (cruise_id) REFERENCES cruise (cruise_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS cast;
CREATE TABLE cast (
  cast_id int unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  station_id int unsigned,
  cast_number int unsigned,
  collection_date date,
  collection_time time,
  FOREIGN KEY (station_id) REFERENCES station (station_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS filter_type;
CREATE TABLE filter_type (
  filter_type_id int unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  filter_type varchar(50) DEFAULT '',
  UNIQUE (filter_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS sample_type;
CREATE TABLE sample_type (
  sample_type_id int unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  sample_type varchar(50) DEFAULT '',
  UNIQUE (sample_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS sequencing_method;
CREATE TABLE sequencing_method (
  sequencing_method_id int unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  sequencing_method varchar(50) DEFAULT '',
  UNIQUE (sequencing_method)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS library_kit;
CREATE TABLE library_kit (
  library_kit_id int unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  library_kit varchar(50) DEFAULT '',
  UNIQUE (library_kit)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS sample;
CREATE TABLE sample (
  sample_id int unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  cast_id int unsigned,
  investigator_id int unsigned,
  filter_type_id int unsigned,
  sample_type_id int unsigned,
  sequencing_method_id int unsigned,
  library_kit_id int unsigned,
  sample_name varchar(255) DEFAULT NULL,
  seq_name varchar(255) DEFAULT NULL,
  depth int unsigned,
  filter_min decimal(10,4),
  KEY (sample_name),
  FOREIGN KEY (cast_id) REFERENCES cast (cast_id) ON DELETE CASCADE,
  FOREIGN KEY (filter_type_id) REFERENCES filter_type (filter_type_id) ON DELETE CASCADE,
  FOREIGN KEY (sample_type_id) REFERENCES sample_type (sample_type_id) ON DELETE CASCADE,
  FOREIGN KEY (sequencing_method_id) REFERENCES sequencing_method (sequencing_method_id) ON DELETE CASCADE,
  FOREIGN KEY (library_kit_id) REFERENCES library_kit (library_kit_id) ON DELETE CASCADE,
  FOREIGN KEY (investigator_id) REFERENCES investigator (investigator_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS sample_ctd;
CREATE TABLE sample_ctd (
  sample_ctd_id int unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  sample_id int unsigned,
  ctd_type_id int unsigned,
  ctd_value decimal(10,4) NOT NULL,
  FOREIGN KEY (sample_id) REFERENCES sample (sample_id) ON DELETE CASCADE,
  FOREIGN KEY (ctd_type_id) REFERENCES ctd_type (ctd_type_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE search (
  search_id int unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  table_name varchar(100) DEFAULT NULL,
  primary_key int unsigned DEFAULT NULL,
  search_text longtext,
  FULLTEXT KEY search_text (search_text)
) ENGINE=MyISAM;

CREATE TABLE query_log (
  query_log_id int unsigned NOT NULL AUTO_INCREMENT,
  num_found int unsigned DEFAULT NULL,
  query text,
  params text,
  ip text,
  user_id text,
  time double DEFAULT NULL,
  date timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (query_log_id)
) ENGINE=MyISAM;
