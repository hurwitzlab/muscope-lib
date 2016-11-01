SET foreign_key_checks = 0;

DROP TABLE IF EXISTS pi;
CREATE TABLE pi (
  pi_id int unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  pi_name varchar(50) DEFAULT NULL,
  institution varchar(255) DEFAULT NULL,
  KEY (pi_name)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS cruise;
CREATE TABLE cruise (
  cruise_id int unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  pi_id int unsigned,
  cruise_name varchar(50) DEFAULT NULL,
  KEY (cruise_name),
  FOREIGN KEY (pi_id) REFERENCES pi (pi_id) ON DELETE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS sample;
CREATE TABLE sample (
  sample_id int unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  cruise_id int unsigned,
  cast_number int unsigned DEFAULT NULL,
  station_number int unsigned,
  rosette_position int unsigned DEFAULT NULL,
  latitude float,
  longitude float,
  depth int,
  pressure_dbar float,
  temperature_ctd float,
  temperature_potential float,
  density_potential float,
  salinity float,
  dissolved_oxygen_ctd float,
  dissolved_oxygen int,
  dissolved_inorganic_carbon int,
  alkalinity int,
  phosphate int,
  nitrate_and_nitrite int,
  silicate int,
  chloropigment_ctd float,
  dissolved_organic_phosphorus  int,
  dissolved_organic_nitrogen int,
  dissolved_organic_carbon int,
  total_dissolved_phosphorus int,
  total_dissolved_nitrogen int,
  low_level_nitrogen int,
  low_level_phosphorus int,
  particulate_carbon int,
  particulate_nitrogen int,
  particulate_phosphorus int,
  particulate_silica int,
  fluorometric_chlorophyll_a int,
  total_phaeopigment int,
  chlorophyllide_a int,
  chlorophyll_c int,
  peridinin int,
  19_prime_butanoyloxyfucoxanthin int,
  fucoxanthin int,
  19_prime_hexanoyloxyfucoxanthin int,
  prasinoxanthin int,
  violaxanthin int,
  diadinoxanthin int,
  lutein int,
  zeaxanthin int,
  chlorophyll_b int,
  carotene_alpha int,
  carotene_beta int,
  divinyl_chlorophyll_a int,
  monovinyl_chlorophyll_a int,
  chlorophyll_a int,
  heterotrophic_bacteria_abundance int,
  prochlorococcus_abundance int,
  synechococcus_abundance int,
  pico_eukaryote_abundance int,
  atp int,
  gas_ch4 int,
  gas_n2o int,
  FOREIGN KEY (cruise_id) REFERENCES cruise (cruise_id) ON DELETE CASCADE
) ENGINE=InnoDB;