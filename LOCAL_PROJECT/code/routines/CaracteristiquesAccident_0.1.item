package routines;

/*
 * user specification: the function's comment should contain keys as follows: 1. write about the function's comment.but
 * it must be before the "{talendTypes}" key.
 * 
 * 2. {talendTypes} 's value must be talend Type, it is required . its value should be one of: String, char | Character,
 * long | Long, int | Integer, boolean | Boolean, byte | Byte, Date, double | Double, float | Float, Object, short |
 * Short
 * 
 * 3. {Category} define a category for the Function. it is required. its value is user-defined .
 * 
 * 4. {param} 's format is: {param} <type>[(<default value or closed list values>)] <name>[ : <comment>]
 * 
 * <type> 's value should be one of: string, int, list, double, object, boolean, long, char, date. <name>'s value is the
 * Function's parameter name. the {param} is optional. so if you the Function without the parameters. the {param} don't
 * added. you can have many parameters for the Function.
 * 
 * 5. {example} gives a example for the Function. it is optional.
 */
public class CaracteristiquesAccident {

    /**
     * helloExample: not return value, only print "hello" + message.
     * 
     * 
     * {talendTypes} String
     * 
     * {Category} User Defined
     * 
     * {param} string("world") input: The string need to be printed.
     * 
     * {example} helloExemple("world") # hello world !.
     */
    public static String set_lumiere (int lum){
    	String lumiere="";
    	switch (lum){
    	case 1: lumiere = "Plein Jour"; break;
    	case 2: lumiere = "Crepuscule ou Aube"; break;
    	case 3: lumiere = "nuit sans eclairage"; break;
    	case 4: lumiere = "nuit avec eclairage non allumé"; break;
    	case 5: lumiere = "nuit avec eclairage allumé"; break;
    	}
    	return lumiere;
    }
    public static String set_agg(int agg){
    	String agglomeration="";
    	switch (agg){
    	case 1: agglomeration = "Hors agglomération"; break;
    	case 2: agglomeration = "En agglomération"; break;
    	
    	}
    	return agglomeration;
    }
    public static String set_intersection(int intt){
    	String intersection="";
    	switch (intt){
    	case 1: intersection = "Hors intersection"; break;
    	case 2: intersection = "Intersection en X"; break;
    	case 3: intersection = "Intersection en T"; break;
    	case 4: intersection = "Intersection en Y"; break; 
       	case 5: intersection = "Intersection a plus de 4 branches"; break;
       	case 6: intersection = "Giratoire"; break;
       	case 7: intersection = "Place"; break;
       	case 8: intersection = "Passage à niveau"; break;
       	case 9: intersection = "Autre intersection"; break;
    	
    	}
    	return intersection;
    }
    public static String set_atmosphere (int atm){
    	String atmosphere = "";
    	switch (atm){
    	case 1: atmosphere = "Normale";break;
    	case 2: atmosphere = "Pluie légère";break;
    	case 3: atmosphere = "Pluie forte";break;
    	case 4: atmosphere = "Neige- grele";break;
    	case 5: atmosphere = "Brouillard - fumée";break;
    	case 6: atmosphere = "Vent fort - tempete";break;
    	case 7: atmosphere = "Temps eblouissant";break;
    	case 8: atmosphere = "Temps couvert";break;
    	case 9: atmosphere = "Autre";break;
    	}
    	return atmosphere;
    }
    public static String set_collison (int col){
    	String collision = "";
    	switch (col){
    	case 1: collision = "2 véhicules- frontale";break;
    	case 2: collision = "2 véhicules- l'arrière";break;
    	case 3: collision = "2 véhicules- coté";break;
    	case 4: collision = "3 véhicules et plus- en chaine";break;
    	case 5: collision = "3 véhicules et plus- collisons multiples";break;
    	case 6: collision = "Autre collison";break;
    	case 7: collision = "sans collision";break;

    	}
    	return collision;
    }
    public static String set_gps (String gps){
    	String code = "";
    	switch (gps){
    	case "M": code = "Métropole";break;
    	case "A": code = "Antilles";break;
    	case "G": code = "Guyane";break;
    	case "R": code = "Réunion";break;
    	case "Y": code = "Mayotte";break;

    	}
    	return code;
    }
}
