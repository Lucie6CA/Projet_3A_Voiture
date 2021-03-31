package org.mapreduceco2;

import java.util.Arrays;
import java.util.Iterator;
import java.io.IOException;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.util.GenericOptionsParser;

// Notre classe MAP.
	// Les 4 types generiques correspondent a:
	// 1 - Object: C'est le type de la cle d'entre.
	// 2 - Text: C'est le type de la valeur d'entre.
	// 3 - Text: C'est le type de la cle de sortie.
	// 4 - Text: C'est le type de la valeur de sortie.
	
public class MapCO2 extends Mapper<Object, Text, Text, Text> {
	
	// La fonction MAP.
		// Note: Le type du premier argument correspond au premier type generique.
		// Note: Le type du second argument correspond au deuxieme type generique.
		// Note: L'objet Context nous permet d'ecrire les couples (cle, valeur).
		
	protected void map(Object key, Text value, Context context) throws IOException, InterruptedException {

		if (value.toString().contains("Marque")){ 
			return;
		}

		String node = value.toString(); 
		node = node.replaceAll("\\u00a0"," ");
		
		String[] splitted_node = node.split(","); 

		// Trie des colonnes
		
		String[] splitted_space = splitted_node[1].split("\\s+"); 
		String colMarque = splitted_space[0];
		colMarque = colMarque.replace("\"", "");

        String colbonusMalus = splitted_node[2];
		colbonusMalus = colbonusMalus.replaceAll(" ", "").replace("€1", "").replace("€", "").replace("\"", "");
		if (colbonusMalus.equals("150kW(204ch)") || colbonusMalus.equals("100kW(136ch)"))
		{
			return;
		}
		if (colbonusMalus.length() == 1){
			colbonusMalus="0"; 
		} 
		
		String colRejet = splitted_node[3];

        String colCout = splitted_node[4];
		String[] colCout_splitted = colCout.split(" ");
		//pour trier les valeurs à 2 ou 3 virgules
		if(colCout_splitted.length == 2){  
			colCout = colCout_splitted[0];
		} else if(colCout_splitted.length == 3){ 
			colCout= colCout_splitted[0] + colCout_splitted[1];
		}
		
        context.write(new Text(colMarque), new Text(String.valueOf(Integer.parseInt(colbonusMalus)) + "|" +  String.valueOf(Integer.parseInt(colRejet)) + "|" + String.valueOf(Integer.parseInt(colCout))));
	}
}