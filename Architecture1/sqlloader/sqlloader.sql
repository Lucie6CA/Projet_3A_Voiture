--commande pour sqlloader
--Charger le fichier via sqlloader dans la base de donnée Oracle SQL

--Dans l'invité de commande:
sqlldr

--Table : catalogue
    sqlldr  CARRONBZ2021@PDBORCL/CARRONBZ202101 control=C:\Users\l.carron\Documents\3aS2\MBDS\Projet3A\Projet_3A_Voiture\sqlloader\control\control_catalogue.ctl errors=0 skip=1
--Table : client
	sqlldr  ORACLEUSER@PDBORCL/PassOrs1 control=control_clients.ctl log=track_clients.log skip=1