
-------------------------------------------------------
-- Import du fichier Catalogue.csv et Immatriculations.csv dans HDFS --
-------------------------------------------------------

-- Sur la machine virtuelle Oracle@BigDataLite (en local)
-- connexion à l'adresse IP 134.59.152.cent quatorze Port 443

-- Dans un invite de commandes : 
 
    -- Ceci est le chemin vers notre projet sur la machine virtuelle
    [oracle@bigdatalite ~]$ export MYPROJECTHOME=/home/CARRON/Projet3AMBDS/
	

--Créer un répertoire pour y mettre les fichiers:
hdfs dfs -mkdir /groupe5

--Pour l'architecture 1:
hdfs dfs -mkdir /groupe5/archi1
hdfs dfs -mkdir /groupe5/archi1/dossier_catalogue
hdfs dfs -mkdir /groupe5/archi1/dossier_immatriculations


--J'utilise WinSCP pour mettre mes fichiers sur ma machine locale, puis je les copie sur HDFS:

-- ajout des fichiers

--Pour l'architecture 1:
hdfs dfs -put $MYPROJECTHOME/CSV/Catalogue.csv /groupe5/archi1/dossier_catalogue

hdfs dfs -put $MYPROJECTHOME/CSV/Immatriculations.csv /groupe5/archi1/dossier_immatriculations

--Vérifier que les fichiers sont bien à leur place:

hdfs dfs -ls /groupe5/archi1/dossier_immatriculations
hdfs dfs -ls /groupe5/archi1/dossier_catalogue



--Pour avoir des informations détaillées sur chacuns des datanodes:
hdfs dfsadmin -report (pas optimiser pour hdfs)

--Obtenir des informations sur l'état du système de fichiers:
hdfs fsck /
hdfs fsck /groupe5

