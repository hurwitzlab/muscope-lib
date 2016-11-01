SET foreign_key_checks = 0;

DROP TABLE IF EXISTS cruise;
CREATE TABLE cruise (
  cruise_id int unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  cruise_name varchar(50) DEFAULT NULL,
  start_date date,
  end_date date,
  KEY (cruise_name)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS cruise_core_ctd;
CREATE TABLE cruise_core_ctd (
  cruise_core_ctd_id int unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  cruise_id int unsigned,
  ctd_type_id int unsigned,
  ctd_value float NOT NULL,
  FOREIGN KEY (cruise_id) REFERENCES cruise (cruise_id) ON DELETE CASCADE,
  FOREIGN KEY (cty_type_id) REFERENCES cty_type (cty_type_id) ON DELETE CASCADE
);

CREATE TABLE ctd_type (
  ctd_type_id int unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  ctd_type varchar(100),
  KEY (ctd_type)
);

DROP TABLE IF EXISTS investigator;
CREATE TABLE investigator (
  investigator_id int unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  investigator_name varchar(50) DEFAULT NULL,
  institution varchar(255) DEFAULT NULL,
  KEY (investigator_name)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS station;
CREATE TABLE station (
  station_id int unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  cruise_id int unsigned NOT NULL,
  station_number int unsigned,
  latitude float,
  longitude float,
  UNIQUE (cruise_id, station_number),
  FOREIGN KEY (cruise_id) REFERENCES cruise (cruise_id) ON DELETE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS cast;
CREATE TABLE cast (
  cast_id int unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  station_id int unsigned,
  cast_number int unsigned,
  FOREIGN KEY (station_id) REFERENCES station (station_id) ON DELETE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS sample;
CREATE TABLE sample (
  sample_id int unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  cast_id int unsigned,
  investigator_id int unsigned,
  sample_name varchar(255) DEFAULT NULL,
  rosette_position int unsigned,
  KEY (sample_name),
  FOREIGN KEY (cast_id) REFERENCES cast (cast_id) ON DELETE CASCADE,
  FOREIGN KEY (investigator_id) REFERENCES investigator (investigator_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
