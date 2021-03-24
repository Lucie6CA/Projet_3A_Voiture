--commande pour sqlloader
--Charger le fichier via sqlloader dans la base de donnée Oracle SQL

--Création de la table CLIENT :

sqlplus CARONBZ2021@ORCL/CARONBZ202101

Drop table CLIENT;

CREATE TABLE CLIENT(AGE varchar2(30), SEXE varchar2(30), TAUX varchar2(30), SITUATIONFAMILIALE varchar2(30), NBENFANTSACHARGE varchar2(30), XVOITURE varchar2(30), IMMATRICULATION varchar2(30));

exit 

--dans bigdatalite

export MYPROJECTHOME=/home/CARRON/Projet3AMBDS

--Table : client
--Charger avec sqlloader
 sqlldr  userid=CARONBZ2021@ORCL/CARONBZ202101 control=$MYPROJECTHOME/sqlloader/control/control_client.txt log=$MYPROJECTHOME/sqlloader/log/client_log.log errors=0 skip=1

/*
.
.
.
.
Commit point reached - logical record count 99501
Commit point reached - logical record count 99565
Commit point reached - logical record count 99629
Commit point reached - logical record count 99693
Commit point reached - logical record count 99757
Commit point reached - logical record count 99821
Commit point reached - logical record count 99885
Commit point reached - logical record count 99949
Commit point reached - logical record count 100000

Table CLIENT:
  100000 Rows successfully loaded.

Check the log file:
  /home/CARRON/Projet3AMBDS/sqlloader/log/client_log.log
for more information about the load.

*/
	

	
	
--sur SQL on vérifie le remplissage de la table:

sqlplus CARONBZ2021@ORCL/CARONBZ202101

set linesize 200
col AGE format A10
col SEXE format A20
col TAUX format A20
col SITUATIONFAMILIALE format A20
col NBENFANTSACHARGE format A10
col XVOITURE format A20
col IMMATRICULATION format A20


SELECT * FROM CLIENT OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;
--where rownum <10;

/*Réponse :
AGE        SEXE                 TAUX                 SITUATIONFAMILIALE   NBENFANTSA XVOITURE             IMMATRICULATION
---------- -------------------- -------------------- -------------------- ---------- -------------------- --------------------
62         M                    1262                 En Couple            1          false                6290 DM 24
68         M                    514                  En Couple            2          false                7530 VH 52
26         F                    181                  En Couple            4          true                 7168 HX 32
34         M                    829                  C?libataire          0          false                1539 UR 49
50         M                    1169                 En Couple            4          false                4738 YG 76
53         M                    156                  En Couple            2          false                5176 NX 17
32         F                    566                  C?libataire          0          false                8958 OW 94
30         M                    465                  En Couple            2          true                 1268 FW 51
20         M                    450                  En Couple            0          true                 3531 MD 12
74         M                    426                  En Couple            2          false                8777 ZT 53

10 rows selected.
*/


