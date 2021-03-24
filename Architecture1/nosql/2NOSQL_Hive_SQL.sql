[oracle@bigdatalite ~]$ beeline
Beeline version 1.1.0-cdh5.4.0 by Apache Hive 
 
-- Se connecter à HIVE
beeline> !connect jdbc:hive2://localhost:10000
 
Enter username for jdbc:hive2://localhost:10000: oracle
Enter password for jdbc:hive2://localhost:10000: ********
(password : welcome1)
 
-- Supprimer la table MARKETING si elle existe déjà
jdbc:hive2://localhost:10000> drop table MARKETING; 
 
 /*
 
No rows affected (0.101 seconds)

*/

-- Création de la table externe MARKETING pointant vers la table MARKETING de ORACLE NOSQL
jdbc:hive2://localhost:10000> CREATE EXTERNAL TABLE MARKETING(
    CLIENTMARKETINGID int,
    AGE string ,
    SEXE string, 
    TAUX string,
    SITUATIONFAMILIALE string,
    NBENFANTSACHARGE string,
    DEUXIEMEVOITURE string
)
STORED BY 'oracle.kv.hadoop.hive.table.TableStorageHandler'
TBLPROPERTIES (
"oracle.kv.kvstore" = "kvstore",
"oracle.kv.hosts" = "bigdatalite.localdomain:5000", 
"oracle.kv.hadoop.hosts" = "bigdatalite.localdomain/127.0.0.1", 
"oracle.kv.tableName" = "MARKETING");



 
-- Vérification du contenu de la table MARKETING externe dans HIVE
0: jdbc:hive2://localhost:10000> select * from MARKETING;

/*
+------------------------------+----------------+-----------------+-----------------+-------------------------------+-----------------------------+----------------------------+--+
| marketing.clientmarketingid  | marketing.age  | marketing.sexe  | marketing.taux  | marketing.situationfamiliale  | marketing.nbenfantsacharge  | marketing.deuxiemevoiture  |
+------------------------------+----------------+-----------------+-----------------+-------------------------------+-----------------------------+----------------------------+--+
| 1                            | 21             | F               | 1396            | C?libataire                   | 0                           | false                      |
| 6                            | 27             | F               | 153             | En Couple                     | 2                           | false                      |
| 18                           | 54             | F               | 452             | En Couple                     | 3                           | true                       |
| 19                           | 35             | M               | 589             | C?libataire                   | 0                           | false                      |
| 20                           | 59             | M               | 748             | En Couple                     | 0                           | true                       |
| 7                            | 59             | F               | 572             | En Couple                     | 2                           | false                      |
| 11                           | 79             | F               | 981             | En Couple                     | 2                           | false                      |
| 10                           | 22             | M               | 154             | En Couple                     | 1                           | false                      |
| 2                            | 35             | M               | 223             | C?libataire                   | 0                           | false                      |
| 3                            | 48             | M               | 401             | C?libataire                   | 0                           | false                      |
| 16                           | 22             | M               | 411             | En Couple                     | 3                           | true                       |
| 5                            | 80             | M               | 530             | En Couple                     | 3                           | false                      |
| 15                           | 60             | M               | 524             | En Couple                     | 0                           | true                       |
| 17                           | 58             | M               | 1192            | En Couple                     | 0                           | false                      |
| 4                            | 26             | F               | 420             | En Couple                     | 3                           | true                       |
| 12                           | 55             | M               | 588             | C?libataire                   | 0                           | false                      |
| 8                            | 43             | F               | 431             | C?libataire                   | 0                           | false                      |
| 13                           | 19             | F               | 212             | C?libataire                   | 0                           | false                      |
| 9                            | 64             | M               | 559             | C?libataire                   | 0                           | false                      |
| 14                           | 34             | F               | 1112            | En Couple                     | 0                           | false                      |
+------------------------------+----------------+-----------------+-----------------+-------------------------------+-----------------------------+----------------------------+--+
20 rows selected (0.327 seconds)
*/



-- Supprimer la table IMMATRICULATIONS si elle existe déjà
jdbc:hive2://localhost:10000> drop table IMMATRICULATIONS; 
 
 /*
 
No rows affected (0.212 seconds)

*/

-- Création de la table externe MARKETING pointant vers la table MARKETING de ORACLE NOSQL
jdbc:hive2://localhost:10000> CREATE EXTERNAL TABLE IMMATRICULATIONS(
    IMMATRICULATION string, MARQUE string, NOM string,PUISSANCE string,LONGUEUR string,NBPLACES string,NBPORTES string,COULEUR string,OCCASION string,PRIX string)
STORED BY 'oracle.kv.hadoop.hive.table.TableStorageHandler'
TBLPROPERTIES (
"oracle.kv.kvstore" = "kvstore",
"oracle.kv.hosts" = "bigdatalite.localdomain:5000", 
"oracle.kv.hadoop.hosts" = "bigdatalite.localdomain/127.0.0.1", 
"oracle.kv.tableName" = "IMMATRICULATIONS");


 
-- Vérification du contenu de la table MARKETING externe dans HIVE
0: jdbc:hive2://localhost:10000> select * from IMMATRICULATIONS limit 10;

/*
+-----------------------------------+--------------------------+-----------------------+-----------------------------+----------------------------+----------------------------+----------------------------+---------------------------+----------------------------+------------------------+--+
| immatriculations.immatriculation  | immatriculations.marque  | immatriculations.nom  | immatriculations.puissance  | immatriculations.longueur  | immatriculations.nbplaces  | immatriculations.nbportes  | immatriculations.couleur  | immatriculations.occasion  | immatriculations.prix  |
+-----------------------------------+--------------------------+-----------------------+-----------------------------+----------------------------+----------------------------+----------------------------+---------------------------+----------------------------+------------------------+--+
| 0 BJ 79                           | Volvo                    | S80 T6                | 272                         | tr?s longue                | 5                          | 5                          | rouge                     | true                       | 35350                  |
| 0 CD 43                           | BMW                      | M5                    | 507                         | tr?s longue                | 5                          | 5                          | bleu                      | false                      | 94800                  |
| 0 CF 54                           | BMW                      | M5                    | 507                         | tr?s longue                | 5                          | 5                          | gris                      | false                      | 94800                  |
| 0 GU 85                           | BMW                      | M5                    | 507                         | tr?s longue                | 5                          | 5                          | noir                      | false                      | 94800                  |
| 0 HI 40                           | Mercedes                 | S500                  | 306                         | tr?s longue                | 5                          | 5                          | noir                      | true                       | 70910                  |
| 0 MA 55                           | Audi                     | A2 1.4                | 75                          | courte                     | 5                          | 5                          | bleu                      | true                       | 12817                  |
| 0 OJ 81                           | Jaguar                   | X-Type 2.5 V6         | 197                         | longue                     | 5                          | 5                          | noir                      | false                      | 37100                  |
| 0 QV 39                           | Fiat                     | Croma 2.2             | 147                         | longue                     | 5                          | 5                          | rouge                     | true                       | 17346                  |
| 0 RH 25                           | Lancia                   | Ypsilon 1.4 16V       | 90                          | courte                     | 5                          | 3                          | rouge                     | false                      | 13500                  |
| 0 RO 80                           | Volkswagen               | Golf 2.0 FSI          | 150                         | moyenne                    | 5                          | 5                          | blanc                     | false                      | 22900                  |
+-----------------------------------+--------------------------+-----------------------+-----------------------------+----------------------------+----------------------------+----------------------------+---------------------------+----------------------------+------------------------+--+
10 rows selected (0.368 seconds)

*/



************************************************************************
--Créer les tables externes Oracle SQL pointant vers les tables externes HIVE

--Se connecter à sqlplus

sqlplus CARONBZ2021@ORCL/CARONBZ202101


--Supprimer les tables si elles existent

drop table MARKETING_O_EXT;

--créer la table MARKETING_O_EXT

CREATE TABLE MARKETING_O_EXT(
CLIENTMARKETINGID number, 
AGE varchar2(40), 
SEXE varchar2(40), 
TAUX varchar2(40), 
SITUATIONFAMILIALE varchar2(40), 
NBENFANTSACHARGE varchar2(40), 
DEUXIEMEVOITURE varchar2(40)
)
ORGANIZATION EXTERNAL (
TYPE ORACLE_HIVE 
DEFAULT DIRECTORY ORACLE_BIGDATA_CONFIG
ACCESS PARAMETERS 
(
com.oracle.bigdata.tablename=default.MARKETING
)
) 
REJECT LIMIT UNLIMITED;

--Vérifier que les tables ont bien été créées

SELECT count(*) from MARKETING_O_EXT;


  COUNT(*)
----------
        20

set linesize 200
col OWNER format A30
col TABLE_NAME format A30
SELECT owner, table_name FROM dba_tables where owner='CARONBZ2021'

/*
OWNER                          TABLE_NAME
------------------------------ ------------------------------
CARONBZ2021                    CLIENT
CARONBZ2021                    CATALOGUE_O_EXT
CARONBZ2021                    IMMATRICULATIONS_O_EXT
CARONBZ2021                    MARKETING_O_EXT
*/




