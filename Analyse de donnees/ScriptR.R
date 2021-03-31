#--------------------------------------#
# ACTIVATION DES LIRAIRIES NECESSAIRES #
#--------------------------------------#

install.packages("C50")
library(C50)
install.packages("randomForest")
library(randomForest)
install.packages("e1071")
library(e1071)
install.packages("naivebayes")
library(naivebayes)
install.packages("nnet")
library(nnet)
install.packages("kknn")
library(kknn)
install.packages("ggplot2")
library(ggplot2)
install.packages("ROCR")
library(ROCR)
install.packages("rvest")
library(rvest)
install.packages("ggplot2")
library(ggplot2)
install.packages("plyr")
library(plyr)
install.packages("dplyr")
library(dplyr)
install.packages("scales")
library(scales)
install.packages("maps")
library(maps)
install.packages("mapproj")
library(mapproj)
install.packages("plotly")
library(plotly)
install.packages("digest")
library(digest)
install.packages("stringr")
library(stringr)
install.packages("sqldf")
library(sqldf)
install.packages("tree")
library(tree)
install.packages("pROC")
library(pROC)
library(ROCR)
install.packages("klaR")
library(klaR)




#--------------------------------#
# IMPORT DES FICHIERS # 
#--------------------------------#


#charger les fichiers
#direction
setwd("C:/Users/l.carron/Documents/3a_S1/MBDS/COURS/6.DataScience/Projet/DATA")

#création de immatriculations car on ne peut pas utiliser une table Oracle : le fichier est trop volumineux
immatriculations <- read.csv("Immatriculations.csv" , header = TRUE, sep = ",", dec = ".")

install.packages("RJDBC")
library(RJDBC)

##classPath : add path to drivers jdbc

drv <- RJDBC::JDBC(driverClass = "oracle.jdbc.OracleDriver", classPath =  Sys.glob("C:/drivers/*"))


#Connexion 
conn <- dbConnect(drv, "jdbc:oracle:thin:@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)
                  (HOST=144.21.67.201)(PORT=1521))(CONNECT_DATA=
                  (SERVICE_NAME=pdbest21.631174089.oraclecloud.internal)))",
                  "CARON2B20", "CARON2B2001")

#Enregistrement de la table Marketing  dans Oracle
marketing <- read.csv("C:/Users/l.carron/Documents/3a_S1/MBDS/COURS/6.DataScience/Projet/DATA/Marketing.csv", header = TRUE, 
                      sep = ",", dec = ".")

names(marketing)[6] = ("deuxiemeVoiture")

dbWriteTable(conn,"marketing",marketing,   
             rownames=FALSE, overwrite = TRUE, append = FALSE)




#Enregistrement de la table Catalogue dans  Oracle
catalogue <- read.csv("C:/Users/l.carron/Documents/3a_S1/MBDS/COURS/6.DataScience/Projet/DATA/Catalogue.csv", header = TRUE, 
                      sep = ",", dec = ".")


dbWriteTable(conn,"catalogue",catalogue,   
             rownames=FALSE, overwrite = TRUE, append = FALSE)

#Enregistrement de la table Client dans  Oracle
client <- read.csv("C:/Users/l.carron/Documents/3a_S1/MBDS/COURS/6.DataScience/Projet/DATA/Clients_5.csv", header = TRUE, 
                   sep = ",", dec = ".")

dbWriteTable(conn,"client5",client,   
             rownames=FALSE, overwrite = TRUE, append = FALSE)


#Visualisation des tables
allTables <- dbGetQuery(conn, "SELECT owner, table_name FROM all_tables where 
                        owner = 'CARON2B20'")

#A partir des tables créées sur oracle nous créons les dataframe : 
  
marketing <- dbGetQuery(conn, "select * from marketing")
catalogue <- dbGetQuery(conn, "select * from catalogue")
client <- dbGetQuery(conn,"select * from client5")

#immatriculations est déjà créé

#--------------------------------#
# PREPARATION DES DONNEES #
#Analyse exploratoire des données#
#--------------------------------#

#---------------------------#
#TRI DES DIFFERENTS FICHIERS#
#---------------------------#


#-----------------#
#Catalogue à trier#
#-----------------#

names(catalogue)
attach(catalogue)
summary(catalogue)


#RIEN A TRIER C'EST Un FICHIER PROPRE

#conversions des types

catalogue$puissance <- as.numeric(catalogue$puissance)
catalogue$longueur <- as.factor(catalogue$longueur)
catalogue$nbPlaces <- as.numeric(catalogue$nbPlaces)
catalogue$nbPortes <- as.numeric(catalogue$nbPortes)
catalogue$couleur <- as.factor(catalogue$couleur)
catalogue$occasion<- as.logical(catalogue$occasion)
catalogue$prix<- as.numeric(catalogue$prix)

#--------------#
#Client à trier#
#--------------#

attach(client)


#sexe
client<- filter( client, sexe!="?" & sexe!="N/D" & sexe!=" " & sexe!="NA")

#finalement, on veut enlever toutes les données qui ne sont pas M et F 

client <- filter(client, client$sexe=="M" | client$sexe=="F")

#vérification
client[client$sexe=="Féminin",]
#conversion
client$sexe <- as.factor(client$sexe)




#age

#vérifions les ages :

client$age <- as.numeric(client$age)

client[client$age <18 ,]
client[client$age >84 ,]

#il y a pas mal de client qui ont -1 age donc on enlève ces lignes inutiles

client<- filter( client, client$age>=18 & client$age<=84)


#taux

#conversion
client$taux <- as.numeric(client$taux)

#vérifier
client[client$taux<544,]

client[client$taux>74185,]

client <- filter(client, client$taux >= 544 & client$taux <=74185)



#situationFamiliale

#client<- filter( client, situationFamiliale!="?" & situationFamiliale!="N/D" & situationFamiliale!=" " & situationFamiliale!="NA")


#on veut garder que les catégories Célibataire, Divorcée, En couple, Marié(e), Seul, Seule
client[client$situationFamiliale!="En Couple" & client$situationFamiliale!="Célibataire" & client$situationFamiliale!="Seule" & client$situationFamiliale!="Marié(e)" & client$situationFamiliale!="Seul" & client$situationFamiliale!="Divorcée",]

client <- filter (client, situationFamiliale=="Célibataire" | situationFamiliale=="Divorcée" | situationFamiliale=="En Couple"|
                    situationFamiliale=="Marié(e)" | situationFamiliale=="Seul" | situationFamiliale=="Seule")

summary(client$situationFamiliale)

#conversion
client$situationFamiliale <- as.factor(client$situationFamiliale)



#nbEnfantsACharge

client<- filter( client, nbEnfantsAcharge!="?" & nbEnfantsAcharge!="N/D" & nbEnfantsAcharge!=" " & nbEnfantsAcharge!="NA")

client$nbEnfantsAcharge <- as.numeric(client$nbEnfantsAcharge)

#les nb d'enfants sont ils anormaux?

client[client$nbEnfantsAcharge!="0" & client$nbEnfantsAcharge!="1" & client$nbEnfantsAcharge!="2" & client$nbEnfantsAcharge!="3" & client$nbEnfantsAcharge!="4",]

#il y a pas mal de client qui ont -1 enfants à charges donc on enlève ces lignes
client<- filter( client, client$nbEnfantsAcharge>=0 & client$nbEnfantsAcharge<=4 )

#vérification
client[client$nbEnfantsAcharge <0 | client$nbEnfantsAcharge >4,]



#2emeVoiture
client<- filter( client, X2eme.voiture!="?" & X2eme.voiture!="N/D" & X2eme.voiture!=" " & X2eme.voiture!="NA")

#vérifions 2eme voiture :
client[client$X2eme.voiture!="true" & client$X2eme.voiture!="false",]

client$X2eme.voiture <- as.logical(client$X2eme.voiture)

summary(client$X2eme.voiture)

#tri:
client<-filter(client, client$X2eme.voiture ==FALSE | client$X2eme.voiture==TRUE)


#immatriculation

client[client$immatriculation=="?" | client$immatriculation=="N/D" | client$immatriculation==" " | client$immatriculation=="NA",]

#on cherche les imamtriculations qui ne sont pas de longueur 10, qui correspond au format 9999 AA 99

client[nchar(client$immatriculation)!=10,]

#on les filtre
client<-filter(client, nchar(client$immatriculation)==10)

summary(client$immatriculation)

client<- filter( client, immatriculation!="?" & immatriculation!="N/D" & immatriculation!=" " & immatriculation!="NA")

summary(client$immatriculation)


#NA

na.omit(client)


#------------------------#
#Immatriculations à trier#
#------------------------#


immatriculations$nbPlaces <- as.numeric(immatriculations$nbPlaces)
immatriculations$nbPortes <- as.numeric(immatriculations$nbPortes)
immatriculations$couleur <- as.factor(immatriculations$couleur)
immatriculations$occasion<- as.logical(immatriculations$occasion)
immatriculations$prix<- as.numeric(immatriculations$prix)


#-----------------#
#Marketing à trier#
#-----------------#

marketing$age <- as.numeric(marketing$age)
marketing$sexe <- as.factor(marketing$sexe)
marketing$taux <- as.numeric(marketing$taux)
marketing$situationFamiliale <- as.factor(marketing$situationFamiliale)
marketing$nbEnfantsAcharge <- as.numeric(marketing$nbEnfantsAcharge)
marketing$X2eme.voiture <- as.logical(marketing$X2eme.voiture)




#----------------------------------------------#
# lier les documents immatriculations et client#
#----------------------------------------------#

clientComplet <-merge(client, immatriculations, by="immatriculation")

#d'accord j'ai créé mon client Complet mais j'ai plus de ligne que de client 



#regardons le nombre de client qui ont 2 voitures:

client2voitures <- client[client$X2eme.voiture!="false",]

print(clientComplet)


#ATTENTION AUX DOUBLONS

#pour clients dans les immatriculations
#doublons <- client[duplicated(client$immatriculation) =="TRUE",]
#doublons
#18 doublons

#1er doublons
#client[client$immatriculation == "1557 AB 48",]
#la même immat appartient à 2 personnes totalement différente
#voyons si dans immatriculations elle est double
#immatriculations[immatriculations$immatriculation=="1557 AB 48",]

#elle correspond à 2 voitures différentes
#ce qui est un problème car après la liaison dans client complet : 
#clientComplet[clientComplet$immatriculation=="1557 AB 48",]
# 1 immat créer 4 lignes dans client complet

#ce qui fait que les 18 doublons d'immat dans clients crééent 18*4 lignes =72 lignes en plus dans client Complet

#ON SUPPRIME LES DOUBLONS DANS CLIENT
client <- client[duplicated(client$immatriculation) =="FALSE",]
client[duplicated(client$immatriculation) =="TRUE",]

#client_sans_doublons <- client[duplicated(client$immatriculation) =="FALSE",]

#doublons dans immatriculations:
#doublons_immat <- immatriculations[duplicated(immatriculations$immatriculation)=="TRUE",]
#doublons_immat

#on les enlève du coup :

immatriculations <- immatriculations[duplicated(immatriculations$immatriculation)=="FALSE",]
#immatriculations_sans_doublons <- immatriculations[duplicated(immatriculations$immatriculation) =="FALSE",]

#on relie les 2 tables 
clientComplet <-merge(client, immatriculations, by="immatriculation")

#doublons dans clientComplet
clientComplet[duplicated(clientComplet$immatriculation)=="TRUE",]
#AUCUN DOUBLONS DANS CLIENT COMPLET


#----------#
#CATEGORIES#
#----------#

#nuage de point catégories de voiture

qplot(longueur, puissance, data= catalogue)

qplot(longueur, nbPlaces, data=catalogue)

qplot(longueur, prix, data=catalogue)

qplot(nbPlaces, prix, data=catalogue)

qplot(nbPlaces, nbPortes, data=catalogue)

qplot(longueur, nbPortes, data=catalogue) 

qplot(puissance, prix, data=catalogue, color=longueur)

qplot(nbPlaces, puissance, data=catalogue)

qplot(nom, prix, data=catalogue, color=longueur)


#CRITERES
#citadines : les courtes
#sport : +de 300cv
#berline compact : moyennes
#berline : des longues mais pas de 7places
#berline confort : très longue mais supérieur à 190 et inférieur à 300

citadines <- catalogue[catalogue$longueur=="courte",]
grandeFamille <- catalogue[catalogue$nbPlaces==7,]
sport <- catalogue[catalogue$puissance >300,]
berline_confort <- catalogue[catalogue$longueur=="très longue" & catalogue$puissance> 190 & catalogue$puissance <300,]
berline_compact <- catalogue[catalogue$longueur=="moyenne",]
berline <- catalogue[catalogue$longueur=="longue" & catalogue$nbPlaces!=7,]


#faire des critères très précis pour pouvoir créer immatriculations$categorie

##ATTENTION il y a des incohérences --> par exemple : new beetle c'est pas 5 places mais 4 donc pas dans la bonne catégorie car on ne peut pas la conseiller à des familles (trop serrées à l'arrière), donc irait plus dans la catégorie citadine


#attribuer les catégories aux données de Immatriculations

#DEUXIEME TEST :
immatriculations$categorie <- ifelse(immatriculations$longueur =="courte", immatriculations$categorie <- "citadine", 
                                     ifelse(immatriculations$nbPlaces ==7, immatriculation$categorie <- "monospace", 
                                            ifelse(immatriculations$puissance > 300, immatriculations$categorie <- "sport", 
                                                   ifelse(immatriculations$longueur =="très longue" & catalogue$puissance> 190 & catalogue$puissance <300, immatriculations$categorie <- "berline_confort", 
                                                          ifelse(immatriculations$longueur=="moyenne", immatriculations$categorie <- "berline_compact", immatriculations$categorie<- "berline")))))

#attention WARNINGs
#1: In immatriculations$longueur == "très longue" & catalogue$puissance >  :
# la taille d'un objet plus long n'est pas multiple de la taille d'un objet plus court
#2: In immatriculations$longueur == "très longue" & catalogue$puissance >  :
# la taille d'un objet plus long n'est pas multiple de la taille d'un objet plus court

#je me rend compte du coup qu'il n'y a aucune voiture de 7places, devons nous supposer que les familles de 4 enfants choisiront automatiquement un monospace?
summary(immatriculations$nbPlaces)

summary(immatriculations)




#on RE RELIE LES TABLES CLIENT ET IMMATRICULATIONS

clientComplet <-merge(client, immatriculations, by="immatriculation")

summary(clientComplet)



#-----------------------#
#PREMIER TEST: SANS TAUX#
#-----------------------#

#suppression des colonnes pas utiles, toutes sauf celles qui correspondent aux clients
#Et taux aussi car on est dans notre premier test sans taux 

clientComplet <- subset(clientComplet, select= -immatriculation)
clientComplet <- subset(clientComplet, select= -nbPlaces)
clientComplet <- subset(clientComplet, select= -nbPortes)
clientComplet <- subset(clientComplet, select= -prix)
clientComplet <- subset(clientComplet, select= -longueur)
clientComplet <- subset(clientComplet, select= -puissance)
clientComplet <- subset(clientComplet, select= -nom)
clientComplet <- subset(clientComplet, select= -marque)
clientComplet <- subset(clientComplet, select= -occasion)
clientComplet <- subset(clientComplet, select= -couleur)
clientComplet <- subset(clientComplet, select= -taux)


#conversion en factor de toutes les colonnes 

clientComplet$categorie <- as.factor(clientComplet$categorie)
clientComplet$age <- as.factor(clientComplet$age)
clientComplet$sexe <- as.factor(clientComplet$sexe)
clientComplet$situationFamiliale <- as.factor(clientComplet$situationFamiliale)
clientComplet$nbEnfantsAcharge <- as.factor(clientComplet$nbEnfantsAcharge)
clientComplet$X2eme.voiture <- as.factor(clientComplet$X2eme.voiture)


#création des ensembles d'apprentissage et de test:


#2/3
client_EA <- clientComplet[1:25766,]

#1/3
client_ET <- clientComplet[25767:38650,]

#------------#
#CLASSIFIEURS#
#------------#

#-----------------#
# NEURAL NETWORKS #
#-----------------#


# Apprentissage du classifeur de type perceptron monocouche

summary(client_EA)
summary(client_ET)

classifieur_nn <- nnet(categorie~., client_EA, size=5)

# weights:  435
#initial  value 39557.274172 
#iter  10 value 18611.213523
#iter  20 value 14609.847583
#iter  30 value 13831.904061
#iter  40 value 13702.704874
#iter  50 value 13629.551045
#iter  60 value 13554.907070
#iter  70 value 13471.798557
#iter  80 value 13403.409941
#iter  90 value 13294.175532
#iter 100 value 13211.298935
#final  value 13211.298935 
#stopped after 100 iterations

#weights:  435
#initial  value 54834.069093 
#iter  10 value 20351.213869
#iter  20 value 14164.484642
#iter  30 value 13846.808182
##iter  40 value 13597.591170
#iter  50 value 13445.972771
#iter  60 value 13406.092362
#iter  70 value 13385.292554
#iter  80 value 13371.688768
#iter  90 value 13355.660402
#iter 100 value 13337.412462
#final  value 13337.412462 
#stopped after 100 iterations


#sans taux et immatriculation et tout en factor 

pred.nn <- predict(classifieur_nn,client_ET, type="class")

table(pred.nn)

#pred.nn
#berline berline_compact        citadine           sport 
#5255             379            4688            2563 

#berline berline_compact        citadine           sport 
#5268             292            4774            2550 


#matrice de confusion 

table(client_ET$categorie, pred.nn)

#pred.nn
#berline berline_compact citadine sport
#berline            3752               0        0   370
#berline_compact       0             178      769     0
#berline_confort      38               0        0    67
#citadine              0             201     3919     0
#sport              1465               0        0  2126

#berline berline_compact citadine sport
#berline            3759               0        0   363
#berline_compact       0             141      806     0
#berline_confort      38               0        0    67
#citadine              0             151     3968     0
#sport              1471               0        0  2120


#taux d'erreur? 


#Indices AUC

#il nous faut les probabilités de prédictions des classifieurs

prob.nn <- predict(classifieur_nn, client_ET, type="raw")

#on test:
nn_auc <- multiclass.roc(client_ET$categorie, prob.nn)
print(nn_auc)

#Data: multivariate predictor prob.nn with 5 levels of client_ET$categorie: berline, berline_compact, berline_confort, citadine, sport.
#Multi-class area under the curve: 0.8847

#29/01 : 0.8715

#-------------#
# NAIVE BAYES #
#-------------#

# Apprentissage du classifeur de type naive bayes

nb <- naive_bayes(categorie~., client_EA)

#Warning messages:
#  1: naive_bayes(): Feature age - zero probabilities are present. Consider Laplace smoothing. 
#2: naive_bayes(): Feature taux - zero probabilities are present. Consider Laplace smoothing. 
#3: naive_bayes(): Feature situationFamiliale - zero probabilities are present. Consider Laplace smoothing. 
#4: naive_bayes(): Feature nbEnfantsAcharge - zero probabilities are present. Consider Laplace smoothing. 
#5: naive_bayes(): Feature X2eme.voiture - zero probabilities are present. Consider Laplace smoothing. 

# Test du classifieur : classe predite

nb_class <- predict(nb, client_ET, type="class")
table(nb_class)

#berline berline_compact berline_confort        citadine           sport 
#5056             679               0            3563            3586 

# Matrice de confusion
table( client_ET$categorie, nb_class)

#                berline berline_compact berline_confort citadine sport
#berline            3614               0               0        1   507
#berline_compact       0             337               0      610     0
#berline_confort      36               0               0        0    69
#citadine              0             342               0     2951   826
#sport              1406               0               0        1  2184



# Test du classifieur : probabilites pour chaque prediction
nb_prob <- predict(nb, client_ET, type="prob")

#Indice AUC
nb_auc <- multiclass.roc(client_ET$categorie, nb_prob)

print(nb_auc)

#Data: multivariate predictor nb_prob with 5 levels of client_ET$categorie: berline, berline_compact, berline_confort, citadine, sport.
#Multi-class area under the curve: 0.8621

#-------------#
# C5.0        #
#-------------#



# Apprentissage du classifeur de type arbre de décision
tree_C50 <- C5.0(categorie~., client_EA)
tree_C50

#TCall:
#C5.0.formula(formula = categorie ~ ., data = client_EA)

#Classification Tree
#Number of samples: 25766 
#Number of predictors: 5 

#Tree size: 6 

#Non-standard options: attempt to group attributes

C50_class<-predict(tree_C50, client_ET, type="class")


table(C50_class)

#C50_class
#        berline berline_compact berline_confort        citadine           sport 
#           5268               0               0            5066            2550 

table(client_ET$categorie, C50_class)

#                 berline berline_compact berline_confort citadine sport
#berline            3759               0               0        0   363
#berline_compact       0               0               0      947     0
#berline_confort      38               0               0        0    67
#citadine              0               0               0     4119     0
#sport              1471               0               0        0  2120

c50_prob<-predict(tree_C50, client_ET, type="prob")


c50_auc<-multiclass.roc(client_ET$categorie, c50_prob)

print(c50_auc)


#Data: multivariate predictor c50_prob with 5 levels of client_ET$categorie: berline, berline_compact, berline_confort, citadine, sport.
#Multi-class area under the curve: 0.8667

#---------------------#
# K-NEAREST NEIGHBORS #
#---------------------#

# Apprentissage et test simultanes du classifeur de type k-nearest neighbors
classifieur_knn <- kknn(categorie~., client_EA, client_ET)

# Resultat : classe predite et probabilites de chaque classe pour chaque instance de test
summary(classifieur_knn)

# Matrice de confusion
table(client_ET$categorie, classifieur_knn$fitted.values)


#               berline berline_compact berline_confort citadine sport
#berline            3128               0               0        0   994
#berline_compact       0             225               0      722     0
#berline_confort      34               0               0        0    71
#citadine              0             363               0     3756     0
#sport              1330               0               3        0  2258


# Conversion des probabilites en data frame
knn_prob <- as.data.frame(classifieur_knn$prob)


# Calcul de l'AUC
knn_auc<-multiclass.roc(client_ET$categorie, knn_prob)
print(knn_auc)

#Data: multivariate predictor knn_prob with 5 levels of client_ET$categorie: berline, berline_compact, berline_confort, citadine, sport.
#Multi-class area under the curve: 0.7996




#------#
#R-PART#
#------#

install.packages("rpart")
library(rpart)

classifieur_rpart <-rpart(categorie ~.,client_EA)

#erreur car ça fait planter R


#----#
#TREE#
#----#
classifieur_tree <-tree(categorie~.,client_EA)


#erreur
#Error in tree(categorie ~ ., client_EA) : 
#  factor predictors must have at most 32 levels

#On n'utilisera pas Rpart ni Tree

#-------------#
#RANDOM FOREST#
#-------------#


classifieur_rf <- randomForest(categorie~., client_EA)

#Error in randomForest.default(m, y, ...) : 
#  Can not handle categorical predictors with more than 53 categories.


#donc, on enlève ce qui pourrait poser problème donc age


client_EA <- subset(client_EA, select = -age)
client_ET <- subset(client_ET, select = -age)

classifieur_rf <- randomForest(categorie~., client_EA)

pred_rf <- predict(classifieur_rf, client_ET, type="response")

table(pred_rf)

#berline berline_compact berline_confort        citadine           sport 
#5264               0               0            5066            2554 

#matrice de confusion 
table(client_ET$categorie, pred_rf)

#                berline berline_compact berline_confort citadine sport
#berline            3756               0               0        0   366
#berline_compact       0               0               0      947     0
#berline_confort      38               0               0        0    67
#citadine              0               0               0     4119     0
#sport              1470               0               0        0  2121

# Test du classifieur : probabilites pour chaque prediction
rf_prob <- predict(classifieur_rf, client_ET, type="prob")
# L'objet genere est une matrice 
rf_prob


# Calcul de l'AUC
rf_auc <- multiclass.roc(client_ET$categorie, rf_prob)


print(rf_auc)

#Data: multivariate predictor rf_prob with 5 levels of client_ET$categorie: berline, berline_compact, berline_confort, citadine, sport.
#Multi-class area under the curve: 0.7021

#---#
#SVM#
#---#

svm_class <- svm(categorie~., client_EA, probability=TRUE)

# Test du classifieur : classe predite
svm_pred <- predict(svm_class, client_ET, type="response")
svm_pred


table(svm_pred)

#berline berline_compact berline_confort        citadine           sport 
#5051               0               0            5066            2767 

#matrice de confusion

table(client_ET$categorie, svm_pred)

#berline berline_compact berline_confort citadine sport
#berline            3610               0               0        0   512
#berline_compact       0               0               0      947     0
#berline_confort      36               0               0        0    69
#citadine              0               0               0     4119     0
#sport              1405               0               0        0  2186

# Test du classifieur : probabilites pour chaque prediction
svm_prob <- predict(svm_class, client_ET, probability=TRUE)


# Recuperation des probabilites associees aux predictions
svm_prob <- attr(svm_prob, "probabilities")

# Conversion en un data frame 
svm_prob <- as.data.frame(svm_prob)


# Calcul de l'AUC
svm_auc <-multiclass.roc(client_ET$categorie, svm_prob)

print (svm_auc) 

#Data: multivariate predictor knn_prob with 5 levels of client_ET$categorie: berline, berline_compact, berline_confort, citadine, sport.
#Multi-class area under the curve: 0.8673





#------------------------#
#DEUXIEME TEST: AVEC TAUX#
#------------------------#


#on RE RELIE LES TABLES CLIENT ET IMMATRICULATIONS
clientComplet <-merge(client, immatriculations, by="immatriculation")
summary(clientComplet)

#suppression des colonnes pas utiles, toutes sauf celles qui correspondent aux clients

clientComplet <- subset(clientComplet, select= -immatriculation)
clientComplet <- subset(clientComplet, select= -nbPlaces)
clientComplet <- subset(clientComplet, select= -nbPortes)
clientComplet <- subset(clientComplet, select= -prix)
clientComplet <- subset(clientComplet, select= -longueur)
clientComplet <- subset(clientComplet, select= -puissance)
clientComplet <- subset(clientComplet, select= -nom)
clientComplet <- subset(clientComplet, select= -marque)
clientComplet <- subset(clientComplet, select= -occasion)
clientComplet <- subset(clientComplet, select= -couleur)

#création des ensembles d'apprentissage et de test:


#2/3
client_EA <- clientComplet[1:25766,]

#1/3
client_ET <- clientComplet[25767:38650,]

#------------#
#CLASSIFIEURS#
#------------#

#-------------#
# NAIVE BAYES #
#-------------#

# Apprentissage du classifeur de type naive bayes
nb <- naive_bayes(client_EA$categorie~., client_EA)
nb

#Warning messages:
#1: naive_bayes(): Feature situationFamiliale - zero probabilities are present. Consider Laplace smoothing. 
#2: naive_bayes(): Feature X2eme.voiture - zero probabilities are present. Consider Laplace smoothing.

# Test du classifieur : classe predite

nb_class <- predict(nb, client_ET, type="class")
nb_class
table(nb_class)


#berline berline_compact berline_confort        citadine           sport 
#4366            2672             469            2251            3126 

# Matrice de confusion
table( client_ET$categorie, nb_class)

#                berline berline_compact berline_confort citadine sport
#berline            3169               1             231      204   517
#berline_compact       0             889               0       58     0
#berline_confort      40               0              38        0    27
#citadine              0            1781              74     1877   387
#sport              1157               1             126      112  2195

# Test du classifieur : probabilités pour chaque prediction
nb_prob <- predict(nb, client_ET, type="prob")
nb_prob #matrice

# Courbe ROC
nb_pred <- multiclass.roc(client_ET$categorie, nb_prob)


nb_pred

#Data: multivariate predictor nb_prob with 5 levels of client_ET$categorie: berline, berline_compact, berline_confort, citadine, sport.
#Multi-class area under the curve: 0.9017


#-------------#
# C5.0        #
#-------------#

client_EA$categorie <- as.factor(client_EA$categorie)
client_EA$age <- as.factor(client_EA$age)
client_EA$sexe <- as.factor(client_EA$sexe)
client_EA$taux <- as.factor(client_EA$taux)
client_EA$situationFamiliale <- as.factor(client_EA$situationFamiliale)
client_EA$nbEnfantsAcharge <- as.factor(client_EA$nbEnfantsAcharge)
client_EA$X2eme.voiture <- as.factor(client_EA$X2eme.voiture)

client_ET$age <- as.factor(client_ET$age)
client_ET$taux <- as.factor(client_ET$taux)
client_ET$nbEnfantsAcharge <- as.factor(client_ET$nbEnfantsAcharge)
client_ET$X2eme.voiture <- as.factor(client_ET$X2eme.voiture)


#___________________#
#   c5.0            #
#___________________#

# Apprentissage du classifeur de type arbre de décision
dt <- C5.0(client_EA$categorie~., client_EA)
print(dt)


#Classification Tree
#Number of samples: 25766 
#Number of predictors: 6 

#Tree size: 29 

#Non-standard options: attempt to group attributes


# Test du classifieur : classe predite
dt_class <- predict(dt, client_ET, type="class")
dt_class
table(dt_class)

#berline berline_compact berline_confort        citadine           sport 
#5782            1086               0            3980            2036 

# Matrice de confusion
table(client_ET$categorie, dt_class)


#berline berline_compact berline_confort citadine sport
#berline            4053               0               0        0    69
#berline_compact       0             538               0      409     0
#berline_confort      86               0               0        0    19
#citadine              0             548               0     3571     0
#sport              1643               0               0        0  1948

# Test du classifieur : probabilites pour chaque prediction
dt_prob <- predict(dt, client_ET, type="prob")

# Calcul de l'AUC
c_auc <-multiclass.roc(client_ET$categorie, dt_prob)
print (c_auc)

#Data: multivariate predictor dt_prob with 5 levels of client_ET$categorie: berline, berline_compact, berline_confort, citadine, sport.
#Multi-class area under the curve: 0.9091


#___________________#
#                   #
#   naive bayes     #
#                   #
#___________________#

# Apprentissage du classifeur de type naive bayes
nb <- naive_bayes(client_EA$categorie~., client_EA)

# Test du classifieur : classe predite
nb_class <- predict(nb, client_ET, type="class")
table(nb_class)

#berline berline_compact berline_confort        citadine           sport 
#4503            1031               0            3673            3677

# Matrice de confusion
table(client_ET$categorie, nb_class)

#               berline berline_compact berline_confort citadine sport
#berline            3191               0               0      267   664
#berline_compact       0             501               0      446     0
#berline_confort      44               0               0        0    61
#citadine             91             530               0     2822   676
#sport              1177               0               0      138  2276


# Test du classifieur : probabilites pour chaque prediction
nb_prob <- predict(nb, client_ET, type="prob")


# Calcul de l'AUC
nb_auc <-multiclass.roc(client_ET$categorie, nb_prob)
print (nb_auc)

#Data: multivariate predictor nb_prob with 5 levels of client_ET$categorie: berline, berline_compact, berline_confort, citadine, sport.
##Multi-class area under the curve : 0.8931

#___________________#
#                   #
#       svm         #
#                   #
#___________________#

# Apprentissage du classifeur de type svm
svm <- svm(categorie~., client_EA, probability=TRUE)

# Test du classifieur : classe predite
svm_class <- predict(svm, client_ET, type="response")
svm_class
table(svm_class)

#        berline berline_compact berline_confort        citadine           sport 
#           5004               0               0            5115            2765

# Matrice de confusion
table(client_ET$categorie, svm_class)

#               berline berline_compact berline_confort citadine sport
#berline            3576               0               0       34   512
#berline_compact       0               0               0      947     0
#berline_confort      35               0               0        1    69
#citadine              0               0               0     4119     0
#sport              1393               0               0       14  2184

# Test du classifieur : probabilites pour chaque prediction
svm_prob <- predict(svm, client_ET, probability=TRUE)


# Recuperation des probabilites associees aux predictions
svm_prob <- attr(svm_prob, "probabilities")

# Conversion en un data frame 
svm_prob <- as.data.frame(svm_prob)


# Calcul de l'AUC
svm_auc <-multiclass.roc(client_ET$categorie, svm_prob)
print (svm_auc) 

##Multi-class area under the curve: 0.8944





#-------------#
#NNET#
#-------------#


classifieur_nn <- nnet(categorie~., client_EA, size=5)

# classifieur_nn <- nnet(categorie~., client_EA, size=5)
#Error in nnet.default(x, y, w, softmax = TRUE, ...) : 
#trop (4195) de pondérations

#donc on a mis la colonne taux en échelons 
#cf plus bas la 3e partie

#-------------#
#RANDOM FOREST#
#-------------#


classifieur_rf <- randomForest(categorie~., client_EA)

#Error in randomForest.default(m, y, ...) : 
#  Can not handle categorical predictors with more than 53 categories.


#donc, on enlève ce qui pourrait poser problème : la colonne "age"
#on a aussi testé en mettant age en echelons
#cf 3e partie

client_EA <- subset(client_EA, select = -age)
client_ET <- subset(client_ET, select = -age)
client_EA <- subset(client_EA, select = -taux)
client_ET <- subset(client_ET, select = -taux)

classifieur_rf <- randomForest(categorie~., client_EA)

pred_rf <- predict(classifieur_rf, client_ET, type="response")

table(pred_rf)

#        berline berline_compact berline_confort        citadine           sport 
#           5264               0               0            5066            2554 

#matrice de confusion 
table(client_ET$categorie, pred_rf)

#               berline berline_compact berline_confort citadine sport
#berline            3756               0               0        0   366
#berline_compact       0               0               0      947     0
#berline_confort      38               0               0        0    67
#citadine              0               0               0     4119     0
#sport              1470               0               0        0  2121


# Test du classifieur : probabilites pour chaque prediction
rf_prob <- predict(classifieur_rf, client_ET, type="prob")
# L'objet genere est une matrice 
rf_prob

# Calcul de l'AUC
rf_auc <- multiclass.roc(client_ET$categorie, rf_prob)
print(rf_auc)


#Multi-class area under the curve: 0.7004


#---------------------#
# K-NEAREST NEIGHBORS #
#---------------------#

# Apprentissage et test simultanes du classifeur de type k-nearest neighbors
classifieur_knn <- kknn(categorie~., client_EA, client_ET)
# Error in if (response != "continuous") { : 
#     l'argument est de longueur nulle
#classifieur_knn <- kknn(categorie~age + sexe +taux+ situationFamiliale+nbEnfantsAcharge+X2eme.voiture, client_EA, client_ET)
# Error in if (response != "continuous") { : 
#     l'argument est de longueur nulle


# Resultat : classe predite et probabilites de chaque classe pour chaque instance de test
summary(classifieur_knn)

# Matrice de confusion
table(client_ET$categorie, classifieur_knn$fitted.values)

#                  berline berline_compact berline_confort citadine sport
#berline            3123               0               3        0   996
#berline_compact       0             250               0      697     0
#berline_confort      37               0               0        0    68
#citadine              0             375               0     3744     0
#sport              1323               0               3        0  2265

# Conversion des probabilites en data frame
knn_prob <- as.data.frame(classifieur_knn$prob)


# Calcul de l'AUC
knn_auc<-multiclass.roc(client_ET$categorie, knn_prob)
print(knn_auc)

#Multi-class area under the curve: 0.8017

#---------#
#3e PARTIE#
#---------#

#test de faire des levels pour taux pour avoir résultats nnet avec

#544 -> 829
#830 -> 1114
#1115 -> 1399


#on RE RELIE LES TABLES CLIENT ET IMMATRICULATIONS

clientComplet <-merge(client, immatriculations, by="immatriculation")
summary(clientComplet)


#suppression des colonnes inutiles

clientComplet <- subset(clientComplet, select= -immatriculation)
clientComplet <- subset(clientComplet, select= -nbPlaces)
clientComplet <- subset(clientComplet, select= -nbPortes)
clientComplet <- subset(clientComplet, select= -prix)
clientComplet <- subset(clientComplet, select= -longueur)
clientComplet <- subset(clientComplet, select= -puissance)

clientComplet <- subset(clientComplet, select= -nom)
clientComplet <- subset(clientComplet, select= -marque)
clientComplet <- subset(clientComplet, select= -occasion)
clientComplet <- subset(clientComplet, select= -couleur)


summary(clientComplet$taux)

#création de tauxEchelons
clientComplet$tauxEchelons <- ifelse(clientComplet$taux <=829, clientComplet$tauxEchelons <- "echelon1",
                                     ifelse(clientComplet$taux >=1114, clientComplet$tauxEchelons <- "echelon 3",
                                            ifelse(clientComplet$taux > 829 & clientComplet$taux< 1114, clientComplet$tauxEchelons <-"echelon 2", "NO")))



#Création de ageEchelons
clientComplet$ageEchelons<- ifelse(clientComplet$age <=29, clientComplet$ageEchelons <- "vingtaine",
                                   ifelse(clientComplet$age >= 30 & clientComplet$age <=39, clientComplet$ageEchelons <- "trentaine", 
                                          ifelse(clientComplet$age >= 40 & clientComplet$age <=49, clientComplet$ageEchelons <- "quarantaine",
                                                 ifelse(clientComplet$age >=50 & clientComplet$age <=59, clientComplet$ageEchelons <- "cinquantaine",
                                                        ifelse(clientComplet$age >=60 & clientComplet$age <=69, clientComplet$ageEchelons <- "soixantaine",
                                                               ifelse(clientComplet$age >=70 & clientComplet$age <=79, clientComplet$ageEchelons <- "soixante-dizaine", 
                                                                      clientComplet$ageEchelons <- "quatre-vingtaine"))))))

#Mise en factor de tout
clientComplet$categorie <- as.factor(clientComplet$categorie)
clientComplet$age <- as.factor(clientComplet$age)
clientComplet$sexe <- as.factor(clientComplet$sexe)
clientComplet$situationFamiliale <- as.factor(clientComplet$situationFamiliale)
clientComplet$nbEnfantsAcharge <- as.factor(clientComplet$nbEnfantsAcharge)
clientComplet$X2eme.voiture <- as.factor(clientComplet$X2eme.voiture)
clientComplet$taux <- as.factor(clientComplet$taux)
clientComplet$tauxEchelons <- as.factor(clientComplet$tauxEchelons)
clientComplet$ageEchelons <- as.factor(clientComplet$ageEchelons)

#visualisation
summary(clientComplet$taux) 
summary(clientComplet$tauxEchelons) 


summary(clientComplet$categorie) 

summary(clientComplet$age)
summary(clientComplet$ageEchelons) 

#suppression des colonnes age et taux avec trop de levels
clientComplet <- subset(clientComplet, select= -age)
clientComplet <- subset(clientComplet, select= -taux)



#création des ensembles d'apprentissage et de test:


#2/3
client_EA <- clientComplet[1:25766,]


#1/3
client_ET <- clientComplet[25767:38650,]



#--------------#
#     NNET     #
#--------------#
classifieur_nn <- nnet(categorie~., client_EA, size=5)

# weights:  130
#initial  value 38171.749126 
#iter  10 value 18135.842129
#iter  20 value 13165.086537
#iter  30 value 12163.579751
#iter  40 value 11867.960747
#iter  50 value 11733.571511
#iter  60 value 11632.306993
#iter  70 value 11542.378036
#iter  80 value 11504.454748
#iter  90 value 11495.156494
#iter 100 value 11490.371974
#final  value 11490.371974 
#stopped after 100 iterations


#avec taux et age en echelons et tout en factor 

pred.nn <- predict(classifieur_nn,client_ET, type="class")

table(pred.nn)

#pred.nn
#        berline berline_compact        citadine           sport 
#5289             249            4817            2529

#matrice de confusion 

table(client_ET$categorie, pred.nn)

#pred.nn
#                  berline berline_compact citadine sport
#berline            3770               0        0   352
#berline_compact       0             126      821     0
#berline_confort      39               0        0    66
#citadine              0             123     3996     0
#sport              1480               0        0  2111

#Indices AUC

#il nous faut les probabilités de prédictions des classifieurs

prob.nn <- predict(classifieur_nn, client_ET, type="raw")

#on test:
nn_auc <- multiclass.roc(client_ET$categorie, prob.nn)
print(nn_auc)

#Data: multivariate predictor prob.nn with 5 levels of client_ET$categorie: berline, berline_compact, berline_confort, citadine, sport.
#Multi-class area under the curve: 0.9203


#-------------#
#RANDOM FOREST#
#-------------#


classifieur_rf <- randomForest(categorie~., client_EA)


pred_rf <- predict(classifieur_rf, client_ET, type="response")

table(pred_rf)

#        berline berline_compact berline_confort        citadine           sport 
#5264              81               0            4985            2554

#matrice de confusion 
table(client_ET$categorie, pred_rf)

#                  berline berline_compact berline_confort citadine sport
#berline            3757               0               0        0   365
#berline_compact       0              40               0      907     0
#berline_confort      38               0               0        0    67
#citadine              0              41               0     4078     0
#sport              1469               0               0        0  2122


# Test du classifieur : probabilites pour chaque prediction
rf_prob <- predict(classifieur_rf, client_ET, type="prob")
# L'objet genere est une matrice 
rf_prob

# Calcul de l'AUC
rf_auc <- multiclass.roc(client_ET$categorie, rf_prob)
print(rf_auc)


#Multi-class area under the curve: 0.761



#___________________#
#   c5.0            #
#___________________#

# Apprentissage du classifeur de type arbre de décision
dt <- C5.0(client_EA$categorie~., client_EA)
print(dt)

#Classification Tree
#Number of samples: 25766 
#Number of predictors: 6 

#Tree size: 6 

#Non-standard options: attempt to group attributes

# Test du classifieur : classe predite
dt_class <- predict(dt, client_ET, type="class")
dt_class
table(dt_class)

#        berline berline_compact berline_confort        citadine           sport 
#           5268               0               0            5066            2550

# Matrice de confusion
table(client_ET$categorie, dt_class)

#                  berline berline_compact berline_confort citadine sport
#berline            3759               0               0        0   363
#berline_compact       0               0               0      947     0
#berline_confort      38               0               0        0    67
#citadine              0               0               0     4119     0
#sport              1471               0               0        0  2120

# Test du classifieur : probabilites pour chaque prediction
dt_prob <- predict(dt, client_ET, type="prob")

# Calcul de l'AUC
c_auc <-multiclass.roc(client_ET$categorie, dt_prob)
print (c_auc)

#Data: multivariate predictor dt_prob with 5 levels of client_ET$categorie: berline, berline_compact, berline_confort, citadine, sport.
#Multi-class area under the curve: 0.8667


#Le résultat est moin bon que avec la colonne taux complète, donc on ne continura pas sur cette voie avec TOUS les classifieurs

#--------------#
#     NNET     #
#--------------#

#AVEC TAUXECHELONS ET AGE NORMAL

#on RE RELIE LES TABLES CLIENT ET IMMATRICULATIONS

clientComplet <-merge(client, immatriculations, by="immatriculation")
summary(clientComplet)


#suppression des colonnes inutiles

clientComplet <- subset(clientComplet, select= -immatriculation)
clientComplet <- subset(clientComplet, select= -nbPlaces)
clientComplet <- subset(clientComplet, select= -nbPortes)
clientComplet <- subset(clientComplet, select= -prix)
clientComplet <- subset(clientComplet, select= -longueur)
clientComplet <- subset(clientComplet, select= -puissance)

clientComplet <- subset(clientComplet, select= -nom)
clientComplet <- subset(clientComplet, select= -marque)
clientComplet <- subset(clientComplet, select= -occasion)
clientComplet <- subset(clientComplet, select= -couleur)


summary(clientComplet$taux)

#création de tauxEchelons
clientComplet$tauxEchelons <- ifelse(clientComplet$taux <=829, clientComplet$tauxEchelons <- "echelon1",
                                     ifelse(clientComplet$taux >=1114, clientComplet$tauxEchelons <- "echelon 3",
                                            ifelse(clientComplet$taux > 829 & clientComplet$taux< 1114, clientComplet$tauxEchelons <-"echelon 2", "NO")))


#mise en factor
clientComplet$categorie <- as.factor(clientComplet$categorie)
clientComplet$age <- as.factor(clientComplet$age)
clientComplet$sexe <- as.factor(clientComplet$sexe)
clientComplet$situationFamiliale <- as.factor(clientComplet$situationFamiliale)
clientComplet$nbEnfantsAcharge <- as.factor(clientComplet$nbEnfantsAcharge)
clientComplet$X2eme.voiture <- as.factor(clientComplet$X2eme.voiture)
clientComplet$taux <- as.factor(clientComplet$taux)
clientComplet$tauxEchelons <- as.factor(clientComplet$tauxEchelons)

#suppression des colonnes age et taux avec trop de levels
clientComplet <- subset(clientComplet, select= -taux)



#création des ensembles d'apprentissage et de test:


#2/3
client_EA <- clientComplet[1:25766,]


#1/3
client_ET <- clientComplet[25767:38650,]



#classifieur#

classifieur_nn <- nnet(categorie~., client_EA, size=5)

#  weights:  430
#initial  value 48458.002034 
#iter  10 value 19198.575012
#iter  20 value 14140.369216
#iter  30 value 13356.912078
#iter  40 value 12947.707569
#iter  50 value 12587.624725
#iter  60 value 12213.527896
#iter  70 value 11974.667392
#iter  80 value 11789.485602
#iter  90 value 11692.393433
#iter 100 value 11582.776826
#final  value 11582.776826 
#stopped after 100 iterations


#avec taux et age en echelons et tout en factor 

pred.nn <- predict(classifieur_nn,client_ET, type="class")

table(pred.nn)

#pred.nn
#        berline berline_compact        citadine           sport 
#           5360             348            4718            2458 

#matrice de confusion 

table(client_ET$categorie, pred.nn)

#pred.nn
#                  berline berline_compact citadine sport
#berline            3776               0        0   346
#berline_compact       0             178      769     0
#berline_confort      53               0        0    52
#citadine              0             170     3949     0
#sport              1531               0        0  2060

#Indices AUC

#il nous faut les probabilités de prédictions des classifieurs

prob.nn <- predict(classifieur_nn, client_ET, type="raw")

#on test:
nn_auc <- multiclass.roc(client_ET$categorie, prob.nn)
print(nn_auc)

#Data: multivariate predictor prob.nn with 5 levels of client_ET$categorie: berline, berline_compact, berline_confort, citadine, sport.
#Multi-class area under the curve: 0.9153

#A peu près pareil, légèrement en dessous
#logique?



#CHOIX DES CLASSIFIEURS#

#C50 ET NNET#
#AVEC TAUX

#conversion des données marketing :

marketing$age <- as.factor(marketing$age)
marketing$sexe <- as.factor(marketing$sexe)
marketing$situationFamiliale <- as.factor(marketing$situationFamiliale)
marketing$nbEnfantsAcharge <- as.factor(marketing$nbEnfantsAcharge)
marketing$X2eme.voiture <- as.factor(marketing$X2eme.voiture)
marketing$taux <- as.factor(marketing$taux)



#on RE RELIE LES TABLES CLIENT ET IMMATRICULATIONS
clientComplet <-merge(client, immatriculations, by="immatriculation")
summary(clientComplet)

#suppression des colonnes pas utiles, toutes sauf celles qui correspondent aux clients

clientComplet <- subset(clientComplet, select= -immatriculation)
clientComplet <- subset(clientComplet, select= -nbPlaces)
clientComplet <- subset(clientComplet, select= -nbPortes)
clientComplet <- subset(clientComplet, select= -prix)
clientComplet <- subset(clientComplet, select= -longueur)
clientComplet <- subset(clientComplet, select= -puissance)
clientComplet <- subset(clientComplet, select= -nom)
clientComplet <- subset(clientComplet, select= -marque)
clientComplet <- subset(clientComplet, select= -occasion)
clientComplet <- subset(clientComplet, select= -couleur)

#création des ensembles d'apprentissage et de test:


#2/3
client_EA <- clientComplet[1:25766,]

#1/3
client_ET <- clientComplet[25767:38650,]

#------------#
#CLASSIFIEURS#
#------------#


#-------------#
# C5.0        #
#-------------#

client_EA$categorie <- as.factor(client_EA$categorie)
client_EA$age <- as.factor(client_EA$age)
client_EA$sexe <- as.factor(client_EA$sexe)
client_EA$taux <- as.factor(client_EA$taux)
client_EA$situationFamiliale <- as.factor(client_EA$situationFamiliale)
client_EA$nbEnfantsAcharge <- as.factor(client_EA$nbEnfantsAcharge)
client_EA$X2eme.voiture <- as.factor(client_EA$X2eme.voiture)

client_ET$age <- as.factor(client_ET$age)
client_ET$taux <- as.factor(client_ET$taux)
client_ET$nbEnfantsAcharge <- as.factor(client_ET$nbEnfantsAcharge)
client_ET$X2eme.voiture <- as.factor(client_ET$X2eme.voiture)



# Apprentissage du classifeur de type arbre de décision
dt <- C5.0(client_EA$categorie~., client_EA)
print(dt)


# Test du classifieur : classe predite
dt_predMarketing <- predict(dt,marketing)

#Error in model.frame.default(object$Terms, newdata, na.action = na.action,  : 
#le facteur taux a des nouveaux niveaux 153, 154, 212, 223, 401, 411, 420, 431, 452, 524, 530

#on décide alors d'enlever les taux inférieur à 544 comme demandé dans le CDC et comme fait pour client :


#conversion
marketing$taux <- as.numeric(marketing$taux)

#vérifier
marketing[marketing$taux<544,]

marketing[marketing$taux>74185,]

marketing <- filter(marketing, marketing$taux >= 544 & marketing$taux <=74185)

#on reconverti en factor
marketing$taux <- as.factor(marketing$taux)


# Test du classifieur : classe predite
dt_predMarketing <- predict(dt,marketing)


dt_predMarketing

table(dt_predMarketing)

#         berline berline_compact berline_confort        citadine           sport 
#               4               0               0               5               0 

prob_predMarketing <- attr(dt_predMarketing, "probabilities")

prob_predMarketing <- as.data.frame(prob_predMarketing)

resultatC50 <- data.frame(marketing,dt_predMarketing )

resultatC50

# age sexe taux situationFamiliale nbEnfantsAcharge X2eme.voiture dt_predMarketing
#1  21    F 1396        Célibataire                0         FALSE         citadine
#2  59    F  572          En Couple                2         FALSE          berline
#3  64    M  559        Célibataire                0         FALSE         citadine
#4  79    F  981          En Couple                2         FALSE          berline
#5  55    M  588        Célibataire                0         FALSE         citadine
#6  34    F 1112          En Couple                0         FALSE          berline
#7  58    M 1192          En Couple                0         FALSE          berline
#8  35    M  589        Célibataire                0         FALSE         citadine
#9  59    M  748          En Couple                0          TRUE         citadine

#enregristrement du resultat :

write.table(resultatC50, file='predictionsC50.csv', sep="\t", dec=".", row.names = F)


########################################################################################
########################################################################################

#NNET
#Pour ce classifieur, on applique les catégories de taux à marketing :

marketing <- read.csv("Marketing.csv" , header = TRUE, sep = ",", dec = ".")

#conversions
marketing$age <- as.numeric(marketing$age)
marketing$sexe <- as.factor(marketing$sexe)
marketing$taux <- as.numeric(marketing$taux)
marketing$situationFamiliale <- as.factor(marketing$situationFamiliale)
marketing$nbEnfantsAcharge <- as.numeric(marketing$nbEnfantsAcharge)
marketing$X2eme.voiture <- as.logical(marketing$X2eme.voiture)

#création de tauxEchelons
marketing$tauxEchelons <- ifelse(marketing$taux <=829, marketing$tauxEchelons <- "echelon1",
                                 ifelse(marketing$taux >=1114, marketing$tauxEchelons <- "echelon 3",
                                        ifelse(marketing$taux > 829 & marketing$taux< 1114, marketing$tauxEchelons <-"echelon 2", "NO")))



#mise en factor
marketing$age <- as.factor(marketing$age)
marketing$sexe <- as.factor(marketing$sexe)
marketing$situationFamiliale <- as.factor(marketing$situationFamiliale)
marketing$nbEnfantsAcharge <- as.factor(marketing$nbEnfantsAcharge)
marketing$X2eme.voiture <- as.factor(marketing$X2eme.voiture)
marketing$taux <- as.factor(marketing$taux)
marketing$tauxEchelons <- as.factor(marketing$tauxEchelons)

#suppression des colonnes age et taux avec trop de levels
marketing <- subset(marketing, select= -taux)


#classifieur#

#AVEC TAUXECHELONS ET AGE NORMAL

#on RE RELIE LES TABLES CLIENT ET IMMATRICULATIONS

clientComplet <-merge(client, immatriculations, by="immatriculation")
summary(clientComplet)


#suppression des colonnes inutiles

clientComplet <- subset(clientComplet, select= -immatriculation)
clientComplet <- subset(clientComplet, select= -nbPlaces)
clientComplet <- subset(clientComplet, select= -nbPortes)
clientComplet <- subset(clientComplet, select= -prix)
clientComplet <- subset(clientComplet, select= -longueur)
clientComplet <- subset(clientComplet, select= -puissance)

clientComplet <- subset(clientComplet, select= -nom)
clientComplet <- subset(clientComplet, select= -marque)
clientComplet <- subset(clientComplet, select= -occasion)
clientComplet <- subset(clientComplet, select= -couleur)


summary(clientComplet$taux)

#création de tauxEchelons
clientComplet$tauxEchelons <- ifelse(clientComplet$taux <=829, clientComplet$tauxEchelons <- "echelon1",
                                     ifelse(clientComplet$taux >=1114, clientComplet$tauxEchelons <- "echelon 3",
                                            ifelse(clientComplet$taux > 829 & clientComplet$taux< 1114, clientComplet$tauxEchelons <-"echelon 2", "NO")))


#mise en factor
clientComplet$categorie <- as.factor(clientComplet$categorie)
clientComplet$age <- as.factor(clientComplet$age)
clientComplet$sexe <- as.factor(clientComplet$sexe)
clientComplet$situationFamiliale <- as.factor(clientComplet$situationFamiliale)
clientComplet$nbEnfantsAcharge <- as.factor(clientComplet$nbEnfantsAcharge)
clientComplet$X2eme.voiture <- as.factor(clientComplet$X2eme.voiture)
clientComplet$taux <- as.factor(clientComplet$taux)
clientComplet$tauxEchelons <- as.factor(clientComplet$tauxEchelons)

#suppression des colonnes age et taux avec trop de levels
clientComplet <- subset(clientComplet, select= -taux)



#création des ensembles d'apprentissage et de test:


#2/3
client_EA <- clientComplet[1:25766,]


#1/3
client_ET <- clientComplet[25767:38650,]



#classifieur#

classifieur_nn <- nnet(categorie~., client_EA, size=5)

# weights:  430
#initial  value 49579.042193 
#iter  10 value 19856.041495
#iter  20 value 12932.362614
#iter  30 value 12101.869758
#iter  40 value 11752.618808
#iter  50 value 11524.946957
#iter  60 value 11441.031762
#iter  70 value 11405.174118
#iter  80 value 11378.520132
#iter  90 value 11360.259123
#iter 100 value 11349.979516
#final  value 11349.979516 
#stopped after 100 iterations

#classification 
nn_predMarketing <- predict(classifieur_nn, marketing, type="class")

nn_predMarketing

table(nn_predMarketing)


nn_probMarketing <- predict(classifieur_nn, marketing, type="raw")

nn_probMarketing

resultatNN <- data.frame(marketing, nn_predMarketing)

resultatNN

write.table(resultatNN, file='predictionsNN.csv', sep="\t", dec=".", row.names = F)

########################################################################################
########################################################################################

#dernière partie : C50 avec les taux en échelons pour avoir le maximum de client à prédire

#On doit alors reprendre C50 avec le taux en échelons


#on RE RELIE LES TABLES CLIENT ET IMMATRICULATIONS

clientComplet <-merge(client, immatriculations, by="immatriculation")
summary(clientComplet)


#suppression des colonnes inutiles

clientComplet <- subset(clientComplet, select= -immatriculation)
clientComplet <- subset(clientComplet, select= -nbPlaces)
clientComplet <- subset(clientComplet, select= -nbPortes)
clientComplet <- subset(clientComplet, select= -prix)
clientComplet <- subset(clientComplet, select= -longueur)
clientComplet <- subset(clientComplet, select= -puissance)

clientComplet <- subset(clientComplet, select= -nom)
clientComplet <- subset(clientComplet, select= -marque)
clientComplet <- subset(clientComplet, select= -occasion)
clientComplet <- subset(clientComplet, select= -couleur)


summary(clientComplet$taux)

#création de tauxEchelons
clientComplet$tauxEchelons <- ifelse(clientComplet$taux <=829, clientComplet$tauxEchelons <- "echelon1",
                                     ifelse(clientComplet$taux >=1114, clientComplet$tauxEchelons <- "echelon 3",
                                            ifelse(clientComplet$taux > 829 & clientComplet$taux< 1114, clientComplet$tauxEchelons <-"echelon 2", "NO")))


#mise en factor
clientComplet$categorie <- as.factor(clientComplet$categorie)
clientComplet$age <- as.factor(clientComplet$age)
clientComplet$sexe <- as.factor(clientComplet$sexe)
clientComplet$situationFamiliale <- as.factor(clientComplet$situationFamiliale)
clientComplet$nbEnfantsAcharge <- as.factor(clientComplet$nbEnfantsAcharge)
clientComplet$X2eme.voiture <- as.factor(clientComplet$X2eme.voiture)
clientComplet$taux <- as.factor(clientComplet$taux)
clientComplet$tauxEchelons <- as.factor(clientComplet$tauxEchelons)

#suppression des colonnes age et taux avec trop de levels
clientComplet <- subset(clientComplet, select= -taux)



#création des ensembles d'apprentissage et de test:


#2/3
client_EA <- clientComplet[1:25766,]


#1/3
client_ET <- clientComplet[25767:38650,]



#classifieur#

# Apprentissage du classifeur de type arbre de décision
dt <- C5.0(client_EA$categorie~., client_EA)
print(dt)

#Classification Tree
#Number of samples: 25766 
#Number of predictors: 6 

#Tree size: 8 

#Non-standard options: attempt to group attributes

# Test du classifieur : classe predite
dt_class <- predict(dt, client_ET, type="class")
dt_class
table(dt_class)

#        berline berline_compact berline_confort        citadine           sport 
#           5268             231               0            4835            2550

# Matrice de confusion
table(client_ET$categorie, dt_class)

#                  berline berline_compact berline_confort citadine sport
#berline            3759               0               0        0   363
#berline_compact       0             127               0      820     0
#berline_confort      38               0               0        0    67
#citadine              0             104               0     4015     0
#sport              1471               0               0        0  2120

# Test du classifieur : probabilites pour chaque prediction
dt_prob <- predict(dt, client_ET, type="prob")

# Calcul de l'AUC
c_auc <-multiclass.roc(client_ET$categorie, dt_prob)
print (c_auc)

#Multi-class area under the curve: 0.8831

#Très bon résultat comme attendu, nous allons maintenant, appliquer la méthode c50 à marketing (déjà avec les taux en échelons)

# Test du classifieur : classe predite
dt_predMarketing <- predict(dt,marketing)


dt_predMarketing

table(dt_predMarketing)

#         berline berline_compact berline_confort        citadine           sport 
#               6               0               0              10               4 

prob_predMarketing <- attr(dt_predMarketing, "probabilities")

prob_predMarketing <- as.data.frame(prob_predMarketing)

resultatC50_2 <- data.frame(marketing,dt_predMarketing )

resultatC50_2



#enregristrement du resultat :

write.table(resultatC50_2, file='predictionsC50_2.csv', sep="\t", dec=".", row.names = F)
