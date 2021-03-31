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
    
    // Notre classe REDUCE.
	// Les 4 types generques correspondent a:
	// 1 - Text: C'est le type de la cle d'entre.
	// 2 - Text: C'est le type de la valeur d'entre.
	// 3 - Text: C'est le type de la cle de sortie.
	// 4 - Text: C'est le type de la valeur de sortie.
	
public class ReduceCO2 extends Reducer<Text, Text, Text, Text> {
	// La fonction REDUCE.
	// Les arguments:
	//   La cle key,
	//   Un Iterable de toutes les valeurs qui sont associees a la cle en question
	//   Le contexte Hadoop (un handle qui nous permet de renvoyer le resultat a Hadoop).
	// Note: Le type du premier argument correspond au premier type generique.
	// Note: Le type du second argument Iterable correspond au deuxieme type generique.
	// Note: L'objet Context nous permet d'ecrire les couples (cle,valeur).
	public void reduce(Text key, Iterable<Text> values, Context context) throws IOException, InterruptedException {
		
		String bonusMalus;
		String rejet;
		String cout;
		int c=0;
		int bonusMalusSum = 0;
		int rejetSum = 0;
		int coutSum = 0;

		Iterator<Text> i = values.iterator();
		while(i.hasNext()) {
			String node = i.next().toString(); 
			System.err.print(key);
			System.err.print("	");
			System.err.println(node);

			String[] splitted_node = node.split("\\|"); 
			bonusMalus = splitted_node[0];
			rejet = splitted_node[1];
			cout = splitted_node[2];
			
			bonusMalusSum += Integer.parseInt(bonusMalus);
			rejetSum += Integer.parseInt(rejet);
			coutSum += Integer.parseInt(cout);
			c++;
		}

		context.write(key, new Text(bonusMalusSum/c + "\t" + rejetSum/c + "\t" + coutSum/c));
	}
}