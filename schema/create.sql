DROP TABLE IF EXISTS cast;
CREATE TABLE cast (
  cast_id int(10) unsigned NOT NULL AUTO_INCREMENT,
  station_id int(10) unsigned DEFAULT NULL,
  cast_number int(10) unsigned DEFAULT NULL,
  collection_date date DEFAULT NULL,
  collection_time time DEFAULT NULL,
  collection_time_zone varchar(20) NOT NULL DEFAULT '',
  PRIMARY KEY (cast_id),
  UNIQUE KEY station_id (station_id,cast_number),
  CONSTRAINT cast_ibfk_1 FOREIGN KEY (station_id) REFERENCES station (station_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS cruise;
CREATE TABLE cruise (
  cruise_id int(10) unsigned NOT NULL AUTO_INCREMENT,
  cruise_name varchar(50) DEFAULT NULL,
  start_date date DEFAULT NULL,
  end_date date DEFAULT NULL,
  PRIMARY KEY (cruise_id),
  UNIQUE KEY cruise_name_2 (cruise_name),
  KEY cruise_name (cruise_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS cruise_core_ctd;
CREATE TABLE cruise_core_ctd (
  cruise_core_ctd_id int(10) unsigned NOT NULL AUTO_INCREMENT,
  cruise_id int(10) unsigned DEFAULT NULL,
  ctd_type_id int(10) unsigned DEFAULT NULL,
  ctd_value float NOT NULL,
  PRIMARY KEY (cruise_core_ctd_id),
  KEY cruise_id (cruise_id),
  KEY ctd_type_id (ctd_type_id),
  CONSTRAINT cruise_core_ctd_ibfk_1 FOREIGN KEY (cruise_id) REFERENCES cruise (cruise_id) ON DELETE CASCADE,
  CONSTRAINT cruise_core_ctd_ibfk_2 FOREIGN KEY (ctd_type_id) REFERENCES ctd_type (ctd_type_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS ctd_type;
CREATE TABLE ctd_type (
  ctd_type_id int(10) unsigned NOT NULL AUTO_INCREMENT,
  ctd_type varchar(100) DEFAULT NULL,
  unit varchar(20) DEFAULT NULL,
  PRIMARY KEY (ctd_type_id),
  KEY ctd_type (ctd_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS filter_type;
CREATE TABLE filter_type (
  filter_type_id int(10) unsigned NOT NULL AUTO_INCREMENT,
  filter_type varchar(50) DEFAULT '',
  PRIMARY KEY (filter_type_id),
  UNIQUE KEY filter_type (filter_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS investigator;
CREATE TABLE investigator (
  investigator_id int(10) unsigned NOT NULL AUTO_INCREMENT,
  first_name varchar(50) DEFAULT NULL,
  last_name varchar(50) DEFAULT NULL,
  institution varchar(255) DEFAULT NULL,
  website varchar(255) DEFAULT NULL,
  project text,
  bio text,
  PRIMARY KEY (investigator_id),
  UNIQUE KEY first_name (first_name,last_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS library_kit;
CREATE TABLE library_kit (
  library_kit_id int(10) unsigned NOT NULL AUTO_INCREMENT,
  library_kit varchar(50) DEFAULT '',
  PRIMARY KEY (library_kit_id),
  UNIQUE KEY library_kit (library_kit)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS query_log;
CREATE TABLE query_log (
  query_log_id int(10) unsigned NOT NULL AUTO_INCREMENT,
  num_found int(10) unsigned DEFAULT NULL,
  query text,
  params text,
  ip text,
  user_id text,
  time double DEFAULT NULL,
  date timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (query_log_id)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS sample;
CREATE TABLE sample (
  sample_id int(10) unsigned NOT NULL AUTO_INCREMENT,
  cast_id int(10) unsigned DEFAULT NULL,
  investigator_id int(10) unsigned NOT NULL DEFAULT '1',
  filter_type_id int(10) unsigned NOT NULL DEFAULT '1',
  sample_type_id int(10) unsigned NOT NULL DEFAULT '1',
  sequencing_method_id int(10) unsigned NOT NULL DEFAULT '1',
  library_kit_id int(10) unsigned NOT NULL DEFAULT '1',
  sample_name varchar(255) DEFAULT NULL,
  seq_name varchar(255) DEFAULT NULL,
  PRIMARY KEY (sample_id),
  UNIQUE KEY cast_id (cast_id,sample_name),
  KEY sample_name (sample_name),
  KEY filter_type_id (filter_type_id),
  KEY sample_type_id (sample_type_id),
  KEY sequencing_method_id (sequencing_method_id),
  KEY library_kit_id (library_kit_id),
  KEY investigator_id (investigator_id),
  CONSTRAINT sample_ibfk_1 FOREIGN KEY (cast_id) REFERENCES cast (cast_id) ON DELETE CASCADE,
  CONSTRAINT sample_ibfk_2 FOREIGN KEY (filter_type_id) REFERENCES filter_type (filter_type_id) ON DELETE CASCADE,
  CONSTRAINT sample_ibfk_3 FOREIGN KEY (sample_type_id) REFERENCES sample_type (sample_type_id) ON DELETE CASCADE,
  CONSTRAINT sample_ibfk_4 FOREIGN KEY (sequencing_method_id) REFERENCES sequencing_method (sequencing_method_id) ON DELETE CASCADE,
  CONSTRAINT sample_ibfk_5 FOREIGN KEY (library_kit_id) REFERENCES library_kit (library_kit_id) ON DELETE CASCADE,
  CONSTRAINT sample_ibfk_6 FOREIGN KEY (investigator_id) REFERENCES investigator (investigator_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS sample_attr;
CREATE TABLE sample_attr (
  sample_attr_id int(10) unsigned NOT NULL AUTO_INCREMENT,
  sample_attr_type_id int(10) unsigned NOT NULL,
  sample_id int(10) unsigned NOT NULL,
  value varchar(255) NOT NULL,
  PRIMARY KEY (sample_attr_id),
  UNIQUE KEY sample_id (sample_id,sample_attr_type_id,value),
  KEY sample_attr_type_id (sample_attr_type_id),
  CONSTRAINT sample_attr_ibfk_2 FOREIGN KEY (sample_id) REFERENCES sample (sample_id) ON DELETE CASCADE,
  CONSTRAINT sample_attr_ibfk_3 FOREIGN KEY (sample_attr_type_id) REFERENCES sample_attr_type (sample_attr_type_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS sample_attr_type;
CREATE TABLE sample_attr_type (
  sample_attr_type_id int(10) unsigned NOT NULL AUTO_INCREMENT,
  sample_attr_type_category_id int(10) unsigned DEFAULT NULL,
  type varchar(100) NOT NULL,
  unit varchar(20) DEFAULT NULL,
  url_template varchar(255) DEFAULT NULL,
  description text,
  PRIMARY KEY (sample_attr_type_id),
  UNIQUE KEY type (type),
  KEY sample_attr_type_category_id (sample_attr_type_category_id),
  CONSTRAINT sample_attr_type_ibfk_1 FOREIGN KEY (sample_attr_type_category_id) REFERENCES sample_attr_type_category (sample_attr_type_category_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS sample_attr_type_alias;
CREATE TABLE sample_attr_type_alias (
  sample_attr_type_alias_id int(10) unsigned NOT NULL AUTO_INCREMENT,
  sample_attr_type_id int(10) unsigned NOT NULL,
  alias varchar(100) NOT NULL,
  PRIMARY KEY (sample_attr_type_alias_id),
  UNIQUE KEY sample_attr_type_id (sample_attr_type_id,alias),
  CONSTRAINT sample_attr_type_alias_ibfk_1 FOREIGN KEY (sample_attr_type_id) REFERENCES sample_attr_type (sample_attr_type_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS sample_attr_type_category;
CREATE TABLE sample_attr_type_category (
  sample_attr_type_category_id int(10) unsigned NOT NULL AUTO_INCREMENT,
  category varchar(100) NOT NULL,
  PRIMARY KEY (sample_attr_type_category_id),
  UNIQUE KEY category (category)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS sample_file;
CREATE TABLE sample_file (
  sample_file_id int(10) unsigned NOT NULL AUTO_INCREMENT,
  sample_id int(10) unsigned NOT NULL,
  sample_file_type_id int(10) unsigned NOT NULL,
  file varchar(200) DEFAULT NULL,
  num_seqs int(11) DEFAULT NULL,
  num_bp bigint(20) unsigned DEFAULT NULL,
  avg_len int(11) DEFAULT NULL,
  pct_gc double DEFAULT NULL,
  PRIMARY KEY (sample_file_id),
  UNIQUE KEY sample_id (sample_id,sample_file_type_id,file),
  KEY sample_id_2 (sample_id),
  KEY sample_file_type_id (sample_file_type_id),
  CONSTRAINT sample_file_ibfk_4 FOREIGN KEY (sample_file_type_id) REFERENCES sample_file_type (sample_file_type_id) ON DELETE CASCADE,
  CONSTRAINT sample_file_ibfk_5 FOREIGN KEY (sample_id) REFERENCES sample (sample_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS sample_file_type;
CREATE TABLE sample_file_type (
  sample_file_type_id int(10) unsigned NOT NULL AUTO_INCREMENT,
  type varchar(255) NOT NULL,
  PRIMARY KEY (sample_file_type_id),
  UNIQUE KEY type (type)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS sample_type;
CREATE TABLE sample_type (
  sample_type_id int(10) unsigned NOT NULL AUTO_INCREMENT,
  sample_type varchar(50) DEFAULT '',
  PRIMARY KEY (sample_type_id),
  UNIQUE KEY sample_type (sample_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS search;
CREATE TABLE search (
  search_id int(10) unsigned NOT NULL AUTO_INCREMENT,
  table_name varchar(100) DEFAULT NULL,
  primary_key int(10) unsigned DEFAULT NULL,
  search_text longtext,
  PRIMARY KEY (search_id),
  FULLTEXT KEY search_text (search_text)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS sequencing_method;
CREATE TABLE sequencing_method (
  sequencing_method_id int(10) unsigned NOT NULL AUTO_INCREMENT,
  sequencing_method varchar(50) DEFAULT '',
  PRIMARY KEY (sequencing_method_id),
  UNIQUE KEY sequencing_method (sequencing_method)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS station;
CREATE TABLE station (
  station_id int(10) unsigned NOT NULL AUTO_INCREMENT,
  cruise_id int(10) unsigned NOT NULL,
  station_number int(10) unsigned DEFAULT NULL,
  latitude float DEFAULT NULL,
  longitude float DEFAULT NULL,
  PRIMARY KEY (station_id),
  UNIQUE KEY cruise_id (cruise_id,station_number),
  CONSTRAINT station_ibfk_1 FOREIGN KEY (cruise_id) REFERENCES cruise (cruise_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
