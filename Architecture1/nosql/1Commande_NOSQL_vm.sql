-------------------------------------------------------
-- Import du fichier Marketing.csv dans ORACLE NOSQL --
-------------------------------------------------------

-- Sur la machine virtuelle Oracle@BigDataLite (en local)
-- connexion à l'adresse IP 134.59.152.cent quatorze Port 443

-- Dans un invite de commandes : 
 
    -- Ceci est le chemin vers notre projet sur la machine virtuelle
    [oracle@bigdatalite ~]$ export MYPROJECTHOME=/home/CARRON/Projet3AMBDS/

    -- Compiler le code java pour importer la table MARKETING à partir du fichier csv
    [oracle@bigdatalite ~]$ javac -g -cp $KVHOME/lib/kvclient.jar:$MYPROJECTHOME/ $MYPROJECTHOME/NoSQL/DataImportMarketing.java

    -- Executer le code java pour importer la table MARKETING à partir du fichier csv
    [oracle@bigdatalite ~]$ java -Xmx256m -Xms256m  -cp $KVHOME/lib/kvclient.jar:$MYPROJECTHOME/ nosql.DataImportMarketing

/*
****** Dans : executeDDL ********
===========================
Statement was successful:
        drop table MARKETING
Results:
        Plan DropTable MARKETING
Id:                    3648
State:                 SUCCEEDED
Attempt number:        1
Started:               2021-03-22 15:29:00 UTC
Ended:                 2021-03-22 15:29:10 UTC
Total tasks:           3
 Successful:           3

****** Dans : executeDDL ********
===========================
Statement was successful:
        Create table MARKETING (CLIENTMARKETINGID INTEGER,AGE STRING,SEXE STRING,TAUX STRING,SITUATIONFAMILIALE STRING,NBENFANTSACHARGE STRING,DEUXIEMEVOITURE STRING,PRIMARY KEY (CLIENTMARKETINGID))
Results:
        Plan CreateTable MARKETING
Id:                    3649
State:                 SUCCEEDED
Attempt number:        1
Started:               2021-03-22 15:29:12 UTC
Ended:                 2021-03-22 15:29:12 UTC
Total tasks:           1
 Successful:           1

********************************** Dans : loadmarketingDataFromFile *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************
********************************** Dans : insertAmarketingRow *********************************

*/

-- Connection à Oracle NoSQL
[oracle@bigdatalite ~]$ java -jar $KVHOME/lib/kvstore.jar runadmin -port 5000 -host bigdatalite.localdomain

kv-> connect store -name kvstore

-- Vérification du contenu de la table MARKETING
kv-> get table -name MARKETING

-- Réponse :
{"CLIENTMARKETINGID":7,"AGE":"59","SEXE":"F","TAUX":"572","SITUATIONFAMILIALE":"En Couple","NBENFANTSACHARGE":"2","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":11,"AGE":"79","SEXE":"F","TAUX":"981","SITUATIONFAMILIALE":"En Couple","NBENFANTSACHARGE":"2","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":1,"AGE":"21","SEXE":"F","TAUX":"1396","SITUATIONFAMILIALE":"C�libataire","NBENFANTSACHARGE":"0","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":6,"AGE":"27","SEXE":"F","TAUX":"153","SITUATIONFAMILIALE":"En Couple","NBENFANTSACHARGE":"2","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":18,"AGE":"54","SEXE":"F","TAUX":"452","SITUATIONFAMILIALE":"En Couple","NBENFANTSACHARGE":"3","DEUXIEMEVOITURE":"true"}
{"CLIENTMARKETINGID":19,"AGE":"35","SEXE":"M","TAUX":"589","SITUATIONFAMILIALE":"C�libataire","NBENFANTSACHARGE":"0","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":20,"AGE":"59","SEXE":"M","TAUX":"748","SITUATIONFAMILIALE":"En Couple","NBENFANTSACHARGE":"0","DEUXIEMEVOITURE":"true"}
{"CLIENTMARKETINGID":10,"AGE":"22","SEXE":"M","TAUX":"154","SITUATIONFAMILIALE":"En Couple","NBENFANTSACHARGE":"1","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":2,"AGE":"35","SEXE":"M","TAUX":"223","SITUATIONFAMILIALE":"C�libataire","NBENFANTSACHARGE":"0","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":3,"AGE":"48","SEXE":"M","TAUX":"401","SITUATIONFAMILIALE":"C�libataire","NBENFANTSACHARGE":"0","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":16,"AGE":"22","SEXE":"M","TAUX":"411","SITUATIONFAMILIALE":"En Couple","NBENFANTSACHARGE":"3","DEUXIEMEVOITURE":"true"}
{"CLIENTMARKETINGID":5,"AGE":"80","SEXE":"M","TAUX":"530","SITUATIONFAMILIALE":"En Couple","NBENFANTSACHARGE":"3","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":15,"AGE":"60","SEXE":"M","TAUX":"524","SITUATIONFAMILIALE":"En Couple","NBENFANTSACHARGE":"0","DEUXIEMEVOITURE":"true"}
{"CLIENTMARKETINGID":17,"AGE":"58","SEXE":"M","TAUX":"1192","SITUATIONFAMILIALE":"En Couple","NBENFANTSACHARGE":"0","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":4,"AGE":"26","SEXE":"F","TAUX":"420","SITUATIONFAMILIALE":"En Couple","NBENFANTSACHARGE":"3","DEUXIEMEVOITURE":"true"}
{"CLIENTMARKETINGID":12,"AGE":"55","SEXE":"M","TAUX":"588","SITUATIONFAMILIALE":"C�libataire","NBENFANTSACHARGE":"0","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":9,"AGE":"64","SEXE":"M","TAUX":"559","SITUATIONFAMILIALE":"C�libataire","NBENFANTSACHARGE":"0","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":14,"AGE":"34","SEXE":"F","TAUX":"1112","SITUATIONFAMILIALE":"En Couple","NBENFANTSACHARGE":"0","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":8,"AGE":"43","SEXE":"F","TAUX":"431","SITUATIONFAMILIALE":"C�libataire","NBENFANTSACHARGE":"0","DEUXIEMEVOITURE":"false"}
{"CLIENTMARKETINGID":13,"AGE":"19","SEXE":"F","TAUX":"212","SITUATIONFAMILIALE":"C�libataire","NBENFANTSACHARGE":"0","DEUXIEMEVOITURE":"false"}

20 rows returned


/*Nous avons également testé avec immatriculations mais finalement nous chargerons immatriculations avec HDFS*/

-- Compiler le code java pour importer la table IMMATRICULATIONS à partir du fichier csv
[oracle@bigdatalite ~]$ javac -g -cp $KVHOME/lib/kvclient.jar:$MYPROJECTHOME/ $MYPROJECTHOME/nosql/DataImportImmatriculations.java

-- Executer le code java pour importer la table IMMATRICULATIONS à partir du fichier csv
[oracle@bigdatalite ~]$ java -Xmx256m -Xms256m  -cp $KVHOME/lib/kvclient.jar:$MYPROJECTHOME/ nosql.DataImportImmatriculations


--Immatriculations est un fichier très grand, la réponse n'a pas d'utilité à afficher comme ça 

-- Vérification du contenu de la table IMMATRICULATIONS
kv-> get table -name IMMATRICULATIONS

Réponse : 

{"IMMATRICULATION":"0 AC 37","MARQUE":"Volkswagen","NOM":"Polo 1.2 6V","PUISSANCE":"55","LONGUEUR":"courte","NBPLACES":"5","NBPORTES":"3","COULEUR":"bleu","OCCASION":"false","PRIX":"12200"}
{"IMMATRICULATION":"0 CY 48","MARQUE":"Volvo","NOM":"S80 T6","PUISSANCE":"272","LONGUEUR":"tr�s longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"noir","OCCASION":"false","PRIX":"50500"}
{"IMMATRICULATION":"0 DA 10","MARQUE":"Volkswagen","NOM":"Polo 1.2 6V","PUISSANCE":"55","LONGUEUR":"courte","NBPLACES":"5","NBPORTES":"3","COULEUR":"gris","OCCASION":"false","PRIX":"12200"}
{"IMMATRICULATION":"0 FH 84","MARQUE":"Audi","NOM":"A2 1.4","PUISSANCE":"75","LONGUEUR":"courte","NBPLACES":"5","NBPORTES":"5","COULEUR":"gris","OCCASION":"false","PRIX":"18310"}
{"IMMATRICULATION":"0 FU 63","MARQUE":"Dacia","NOM":"Logan 1.6 MPI","PUISSANCE":"90","LONGUEUR":"moyenne","NBPLACES":"5","NBPORTES":"5","COULEUR":"gris","OCCASION":"false","PRIX":"7500"}
{"IMMATRICULATION":"0 GV 37","MARQUE":"BMW","NOM":"M5","PUISSANCE":"507","LONGUEUR":"tr�s longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"gris","OCCASION":"false","PRIX":"94800"}
{"IMMATRICULATION":"0 HE 15","MARQUE":"Renault","NOM":"Vel Satis 3.5 V6","PUISSANCE":"245","LONGUEUR":"tr�s longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"noir","OCCASION":"true","PRIX":"34440"}
{"IMMATRICULATION":"0 JH 10","MARQUE":"Daihatsu","NOM":"Cuore 1.0","PUISSANCE":"58","LONGUEUR":"courte","NBPLACES":"5","NBPORTES":"3","COULEUR":"noir","OCCASION":"false","PRIX":"8850"}
{"IMMATRICULATION":"0 LI 46","MARQUE":"Audi","NOM":"A2 1.4","PUISSANCE":"75","LONGUEUR":"courte","NBPLACES":"5","NBPORTES":"5","COULEUR":"gris","OCCASION":"false","PRIX":"18310"}
{"IMMATRICULATION":"0 MD 67","MARQUE":"BMW","NOM":"M5","PUISSANCE":"507","LONGUEUR":"tr�s longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"blanc","OCCASION":"false","PRIX":"94800"}
{"IMMATRICULATION":"0 OG 25","MARQUE":"Volkswagen","NOM":"Polo 1.2 6V","PUISSANCE":"55","LONGUEUR":"courte","NBPLACES":"5","NBPORTES":"3","COULEUR":"gris","OCCASION":"false","PRIX":"12200"}
{"IMMATRICULATION":"0 OZ 65","MARQUE":"Ford","NOM":"Mondeo 1.8","PUISSANCE":"125","LONGUEUR":"longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"blanc","OCCASION":"false","PRIX":"23900"}
{"IMMATRICULATION":"0 PJ 19","MARQUE":"Renault","NOM":"Laguna 2.0T","PUISSANCE":"170","LONGUEUR":"longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"bleu","OCCASION":"false","PRIX":"27300"}
{"IMMATRICULATION":"0 SG 37","MARQUE":"Renault","NOM":"Vel Satis 3.5 V6","PUISSANCE":"245","LONGUEUR":"tr�s longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"gris","OCCASION":"false","PRIX":"49200"}
{"IMMATRICULATION":"0 SQ 23","MARQUE":"Renault","NOM":"Vel Satis 3.5 V6","PUISSANCE":"245","LONGUEUR":"tr�s longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"gris","OCCASION":"false","PRIX":"49200"}
{"IMMATRICULATION":"0 TB 43","MARQUE":"BMW","NOM":"M5","PUISSANCE":"507","LONGUEUR":"tr�s longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"bleu","OCCASION":"true","PRIX":"66360"}
{"IMMATRICULATION":"0 WB 68","MARQUE":"Jaguar","NOM":"X-Type 2.5 V6","PUISSANCE":"197","LONGUEUR":"longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"noir","OCCASION":"true","PRIX":"25970"}
{"IMMATRICULATION":"0 WM 41","MARQUE":"Audi","NOM":"A2 1.4","PUISSANCE":"75","LONGUEUR":"courte","NBPLACES":"5","NBPORTES":"5","COULEUR":"noir","OCCASION":"true","PRIX":"12817"}
{"IMMATRICULATION":"0 YG 14","MARQUE":"Audi","NOM":"A2 1.4","PUISSANCE":"75","LONGUEUR":"courte","NBPLACES":"5","NBPORTES":"5","COULEUR":"bleu","OCCASION":"false","PRIX":"18310"}
{"IMMATRICULATION":"0 YS 70","MARQUE":"Nissan","NOM":"Primera 1.6","PUISSANCE":"109","LONGUEUR":"longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"gris","OCCASION":"false","PRIX":"18650"}
{"IMMATRICULATION":"1 AE 59","MARQUE":"Audi","NOM":"A2 1.4","PUISSANCE":"75","LONGUEUR":"courte","NBPLACES":"5","NBPORTES":"5","COULEUR":"bleu","OCCASION":"false","PRIX":"18310"}
{"IMMATRICULATION":"1 CQ 63","MARQUE":"BMW","NOM":"M5","PUISSANCE":"507","LONGUEUR":"tr�s longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"noir","OCCASION":"false","PRIX":"94800"}
{"IMMATRICULATION":"1 CZ 45","MARQUE":"Audi","NOM":"A3 2.0 FSI","PUISSANCE":"150","LONGUEUR":"moyenne","NBPLACES":"5","NBPORTES":"5","COULEUR":"rouge","OCCASION":"false","PRIX":"28500"}
{"IMMATRICULATION":"1 DR 40","MARQUE":"Volkswagen","NOM":"Golf 2.0 FSI","PUISSANCE":"150","LONGUEUR":"moyenne","NBPLACES":"5","NBPORTES":"5","COULEUR":"blanc","OCCASION":"false","PRIX":"22900"}
{"IMMATRICULATION":"1 DS 75","MARQUE":"Jaguar","NOM":"X-Type 2.5 V6","PUISSANCE":"197","LONGUEUR":"longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"noir","OCCASION":"false","PRIX":"37100"}
{"IMMATRICULATION":"1 FI 20","MARQUE":"Volkswagen","NOM":"Polo 1.2 6V","PUISSANCE":"55","LONGUEUR":"courte","NBPLACES":"5","NBPORTES":"3","COULEUR":"bleu","OCCASION":"false","PRIX":"12200"}
{"IMMATRICULATION":"1 FJ 67","MARQUE":"BMW","NOM":"M5","PUISSANCE":"507","LONGUEUR":"tr�s longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"rouge","OCCASION":"false","PRIX":"94800"}
{"IMMATRICULATION":"1 FS 96","MARQUE":"BMW","NOM":"M5","PUISSANCE":"507","LONGUEUR":"tr�s longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"rouge","OCCASION":"false","PRIX":"94800"}
{"IMMATRICULATION":"1 HT 65","MARQUE":"Fiat","NOM":"Croma 2.2","PUISSANCE":"147","LONGUEUR":"longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"gris","OCCASION":"true","PRIX":"17346"}
{"IMMATRICULATION":"1 MS 19","MARQUE":"Mercedes","NOM":"S500","PUISSANCE":"306","LONGUEUR":"tr�s longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"blanc","OCCASION":"true","PRIX":"70910"}
{"IMMATRICULATION":"1 OS 21","MARQUE":"Volkswagen","NOM":"Golf 2.0 FSI","PUISSANCE":"150","LONGUEUR":"moyenne","NBPLACES":"5","NBPORTES":"5","COULEUR":"blanc","OCCASION":"true","PRIX":"16029"}
{"IMMATRICULATION":"1 PD 24","MARQUE":"Renault","NOM":"Vel Satis 3.5 V6","PUISSANCE":"245","LONGUEUR":"tr�s longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"blanc","OCCASION":"true","PRIX":"34440"}
{"IMMATRICULATION":"1 RT 70","MARQUE":"Jaguar","NOM":"X-Type 2.5 V6","PUISSANCE":"197","LONGUEUR":"longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"noir","OCCASION":"false","PRIX":"37100"}
{"IMMATRICULATION":"1 SF 79","MARQUE":"Volkswagen","NOM":"Golf 2.0 FSI","PUISSANCE":"150","LONGUEUR":"moyenne","NBPLACES":"5","NBPORTES":"5","COULEUR":"gris","OCCASION":"false","PRIX":"22900"}
{"IMMATRICULATION":"1 TN 97","MARQUE":"Jaguar","NOM":"X-Type 2.5 V6","PUISSANCE":"197","LONGUEUR":"longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"gris","OCCASION":"true","PRIX":"25970"}
{"IMMATRICULATION":"1 WZ 75","MARQUE":"Volvo","NOM":"S80 T6","PUISSANCE":"272","LONGUEUR":"tr�s longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"gris","OCCASION":"false","PRIX":"50500"}
{"IMMATRICULATION":"1 XO 20","MARQUE":"BMW","NOM":"M5","PUISSANCE":"507","LONGUEUR":"tr�s longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"rouge","OCCASION":"false","PRIX":"94800"}
{"IMMATRICULATION":"1 ZF 46","MARQUE":"Volvo","NOM":"S80 T6","PUISSANCE":"272","LONGUEUR":"tr�s longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"blanc","OCCASION":"true","PRIX":"35350"}
{"IMMATRICULATION":"1 ZL 22","MARQUE":"Saab","NOM":"9.3 1.8T","PUISSANCE":"150","LONGUEUR":"longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"bleu","OCCASION":"true","PRIX":"27020"}
{"IMMATRICULATION":"1 ZW 20","MARQUE":"Fiat","NOM":"Croma 2.2","PUISSANCE":"147","LONGUEUR":"longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"gris","OCCASION":"false","PRIX":"24780"}
{"IMMATRICULATION":"1 ZY 89","MARQUE":"BMW","NOM":"M5","PUISSANCE":"507","LONGUEUR":"tr�s longue","NBPLACES":"5","NBPORTES":"5","COULEUR":"blanc","OCCASION":"true","PRIX":"66360"}
{"IMMATRICULATION":"10 BU 67","MARQUE":"Audi","NOM":"A2 1.4","PUISSANCE":"75","LONGUEUR":"courte","NBPLACES":"5","NBPORTES":"5","COULEUR":"blanc","OCCASION":"true","PRIX":"12817"}
--More--(1~42)


--Nous voulons maintenant créer une table externe sur hive : cf le fichier 2Hive_cmd
