db: create ctd_type

create:
	mysql muscope < create.sql

image:
	sqlt-graph --color -o muscope.png -f MySQL create.sql

ctd_type:
	mysqlimport --local -c ctd_type muscope ctd_type.txt
