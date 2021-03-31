**********************************************************
HIVE ARCHITECTURE1
*********************************************************************
--On cherche ensuite, pour l'architecture 1, à créer les tables externes HIVE Issues des données de Immatriculation et Catalogue:

beeline[oracle@bigdatalite ~]$ beeline
Beeline version 1.1.0-cdh5.4.0 by Apache Hive 

-- Se connecter à HIVE
beeline> !connect jdbc:hive2://localhost:10000
 
Enter username for jdbc:hive2://localhost:10000: oracle
Enter password for jdbc:hive2://localhost:10000: ********
(password : welcome1)
 
-- Supprimer les tables IMMATRICULATIONS_HDFS_EXT et CATALOGUE_HDFS_EXT si elles existent déjà
-- PUIS
-- Création de la table externe IMMATRICULATIONS_HDFS_EXT pointant vers HDFS
-- table externe Hive IMMATRICULATIONS_HDFS_EXT 
-- et création de la table externe CATALOGUE_HDFS_EXT pointant vers HDFS 
-- table externe Hive CATALOGUE_HDFS_EXT

drop table IMMATRICULATIONS_HDFS_EXT;

CREATE EXTERNAL TABLE  IMMATRICULATIONS_HDFS_EXT  (IMMATRICULATION string, MARQUE string, NOM string, 
PUISSANCE int, LONGUEUR string, NBPLACES int, NBPORTES int, COULEUR string, OCCASION string, PRIX int)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE LOCATION 'hdfs:/groupe5/archi1/dossier_immatriculations';

drop table CATALOGUE_HDFS_EXT;

CREATE EXTERNAL TABLE  CATALOGUE_HDFS_EXT  (MARQUE string, NOM string, PUISSANCE int,
 LONGUEUR string, NBPLACES int, NBPORTES int, COULEUR string, OCCASION string, PRIX int)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE LOCATION 'hdfs:/groupe5/archi1/dossier_catalogue';

-- Vérification du contenu des tables externes dans HIVE

desc IMMATRICULATIONS_HDFS_EXT
/*
+------------------+------------+----------+--+
|     col_name     | data_type  | comment  |
+------------------+------------+----------+--+
| immatriculation  | string     |          |
| marque           | string     |          |
| nom              | string     |          |
| puissance        | int        |          |
| longueur         | string     |          |
| nbplaces         | int        |          |
| nbportes         | int        |          |
| couleur          | string     |          |
| occasion         | string     |          |
| prix             | int        |          |
+------------------+------------+----------+--+
10 rows selected (0.107 seconds)
*/


select MARQUE, NOM, PUISSANCE, LONGUEUR from IMMATRICULATIONS_HDFS_EXT where IMMATRICULATION='9925 TY 41';

/*
+---------+---------+------------+-----------+--+
| marque  |   nom   | puissance  | longueur  |
+---------+---------+------------+-----------+--+
| Audi    | A2 1.4  | 75         | courte    |
+---------+---------+------------+-----------+--+
1 row selected (0.926 seconds)

*/

desc CATALOGUE_HDFS_EXT;
/*
+------------+------------+----------+--+
|  col_name  | data_type  | comment  |
+------------+------------+----------+--+
| marque     | string     |          |
| nom        | string     |          |
| puissance  | int        |          |
| longueur   | string     |          |
| nbplaces   | int        |          |
| nbportes   | int        |          |
| couleur    | string     |          |
| occasion   | string     |          |
| prix       | int        |          |
+------------+------------+----------+--+
9 rows selected (0.133 seconds)
*/

select * from CATALOGUE_HDFS_EXT where prix<8000;

/*
+----------------------------+-------------------------+-------------------------------+------------------------------+------------------------------+------------------------------+-----------------------------+------------------------------+--------------------------+--+
| catalogue_hdfs_ext.marque  | catalogue_hdfs_ext.nom  | catalogue_hdfs_ext.puissance  | catalogue_hdfs_ext.longueur  | catalogue_hdfs_ext.nbplaces  | catalogue_hdfs_ext.nbportes  | catalogue_hdfs_ext.couleur  | catalogue_hdfs_ext.occasion  | catalogue_hdfs_ext.prix  |
+----------------------------+-------------------------+-------------------------------+------------------------------+------------------------------+------------------------------+-----------------------------+------------------------------+--------------------------+--+
| Dacia                      | Logan 1.6 MPI           | 90                            | moyenne                      | 5                            | 5                            | blanc                       | false                        | 7500                     |
| Dacia                      | Logan 1.6 MPI           | 90                            | moyenne                      | 5                            | 5                            | rouge                       | false                        | 7500                     |
| Dacia                      | Logan 1.6 MPI           | 90                            | moyenne                      | 5                            | 5                            | noir                        | false                        | 7500                     |
| Dacia                      | Logan 1.6 MPI           | 90                            | moyenne                      | 5                            | 5                            | gris                        | false                        | 7500                     |
| Dacia                      | Logan 1.6 MPI           | 90                            | moyenne                      | 5                            | 5                            | bleu                        | false                        | 7500                     |
+----------------------------+-------------------------+-------------------------------+------------------------------+------------------------------+------------------------------+-----------------------------+------------------------------+--------------------------+--+

*/

******************************************************************************
--Créer les tables externes Oracle SQL pointant vers les tables externes HIVE
******************************************************************************
--Se connecter à sqlplus

sqlplus CARONBZ2021@ORCL/CARONBZ202101


--Supprimer les tables si elles existent

drop table IMMATRICULATIONS_O_EXT;
drop table CATALOGUE_O_EXT;

--créer la table IMMATRICULATIONS_O_EXT

CREATE TABLE  IMMATRICULATIONS_O_EXT(
IMMATRICULATION varchar2(10), 
MARQUE varchar2(40), 
NOM varchar2(40), 
PUISSANCE number, 
LONGUEUR varchar2(40), 
NBPLACES number, 
NBPORTES number, 
COULEUR varchar2(40), 
OCCASION varchar2(40), 
PRIX number
)
ORGANIZATION EXTERNAL (
TYPE ORACLE_HIVE 
DEFAULT DIRECTORY ORACLE_BIGDATA_CONFIG
ACCESS PARAMETERS 
(
com.oracle.bigdata.tablename=default.IMMATRICULATIONS_HDFS_EXT
)
) 
REJECT LIMIT UNLIMITED;

--créer la table CATALOGUE_O_EXT

CREATE TABLE CATALOGUE_O_EXT(
MARQUE varchar2(40), 
NOM varchar2(40), 
PUISSANCE number, 
LONGUEUR varchar2(40), 
NBPLACES number, 
NBPORTES number, 
COULEUR varchar2(40), 
OCCASION varchar2(40), 
PRIX number
)
ORGANIZATION EXTERNAL (
TYPE ORACLE_HIVE 
DEFAULT DIRECTORY ORACLE_BIGDATA_CONFIG
ACCESS PARAMETERS 
(
com.oracle.bigdata.tablename=default.CATALOGUE_HDFS_EXT
)
) 
REJECT LIMIT UNLIMITED;

--Vérifier que les tables ont bien été créées

SELECT count(*) from IMMATRICULATIONS_O_EXT;


  COUNT(*)
----------
   2000001

   
select MARQUE, NOM, PUISSANCE, LONGUEUR from IMMATRICULATIONS_O_EXT where IMMATRICULATION='9925 TY 41'; 


SELECT count(*) from CATALOGUE_O_EXT;

  COUNT(*)
----------
       271

select * from CATALOGUE_O_EXT where prix<8000;



/*Avant que tout marche correctement j'ai fais face à une erreur :

ORA-29913: error in executing ODCIEXTTABLEOPEN callout 
ORA-29400: data cartridge error 
KUP-11554: error accessing the Oracle Big Data configuration file

--J'ai donc fais la démarche suivante :

ORACLE_BIGDATA_CONFIG et ORA_BIGDATA_CL_bigdatalite. 
La directorie ORACLE_BIGDATA_CONFIG sert à stocker les lignes
rappatri?es des bases distantes.

Op?ration à faire une seule fois.

v?rification
SQL> select DIRECTORY_NAME from dba_directories;
select * from dba_directories;

SQL> create or replace directory ORACLE_BIGDATA_CONFIG as '/u01/lucie/bigdatasql_config';
SQL> create or replace directory "ORA_BIGDATA_CL_bigdatalite" as '';

-- v?rification
SQL> select DIRECTORY_NAME from dba_directories;

Puis après reconnexion à mon sqlplus, le problème était réglé
*/




