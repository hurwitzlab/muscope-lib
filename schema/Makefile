db: recreate ctd_type investigator

recreate: drop create schema

drop:
	mysqladmin drop -f muscope 

create:
	mysqladmin create muscope

schema:
	mysql muscope < create.sql

image:
	sqlt-graph --color -o muscope.png -f MySQL create.sql

ctd_type:
	mysqlimport --delete --local -c ctd_type,unit muscope ctd_type.txt

investigator:
	mysqlimport --delete --local -c investigator_name,institution muscope investigator.txt
