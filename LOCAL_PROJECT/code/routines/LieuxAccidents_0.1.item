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
public class LieuxAccidents {

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
    public static String set_categorie (int catr){
    	String categorie = "";
    	switch (catr){
    	case 1: categorie = "Autoroute"; break;
    	case 2: categorie = "Route Nationale"; break;
    	case 3: categorie = "Route départementale"; break;
    	case 4: categorie = "Voie communautale"; break;
    	case 5: categorie = "Hors réseau public"; break;
    	case 6: categorie = "Parc de stationnement"; break;
    	case 7: categorie = "Autre"; break;
    	}
    	return categorie;
    }
    public static String set_circulation (String circ){
    	String circulation = "";
    	switch (circ){
    	case "1": circulation = "A sens unique"; break;
    	case "2": circulation = "Bidirectionnelle"; break;
    	case "3": circulation = "A chaussée séparée"; break;
    	case "4": circulation = "Avec voies d'affectation variable"; break;
    	}
    	return circulation ;
    }
    public static String set_voie (String vosp){
    	String voie = "";
    	switch (vosp){
    	case "1": voie = "Piste cyclable"; break;
    	case "2": voie = "Banque cyclable"; break;
    	case "3": voie = "Voie réservée"; break;

    	}
    	return voie ;
    }
    public static String set_profil (String prof){
    	String profil = "";
    	switch (prof){
    	case "1": profil = "Plat"; break;
    	case "2": profil = "Pente"; break;
    	case "3": profil = "Sommet de cote"; break;
    	case "4": profil = "Bas de cote";break;
    	}
    	return profil;
    }
    public static String set_plan (String pl){
    	String plan = "";
    	switch (pl){
    	case "1": plan = "Partie rectiligne"; break;
    	case "2": plan = "En courbe à gauche"; break;
    	case "3": plan = "En courbe à droite"; break;
    	case "4": plan = "En S";break;
    	}
    	return plan;
    }
    public static String set_surface (String surf){
    	String surface = "";
    	switch (surf){
    	case "1": surface = "Normale"; break;
    	case "2": surface = "Mouillée"; break;
    	case "3": surface = "Flaques"; break;
    	case "4": surface = "Inondée";break;
    	case "5": surface = "Enneigé"; break;
    	case "6": surface = "Boue"; break;
    	case "7": surface = "Verglacée"; break;
    	case "8": surface = "Corpss gras";break;
    	case "9": surface = "Autre";break;
    	}
    	return surface;
    }
    public static String set_infrastructure( String infra){
    	String infrastructure = "";
    	switch(infra){
    	case "1": infrastructure = "Tunnel";break;
    	case "2": infrastructure = "Pont"; break;
    	case "3": infrastructure = "Bretelle"; break;
    	case "4": infrastructure = "Voie ferrée";break;
    	case "5": infrastructure = "Carrefour"; break;
    	case "6": infrastructure = "Zone piétonne";break;
    	case "7": infrastructure = "Zone de péage";break;
    	}
    	return infrastructure;
    }
    public static String set_situation( String situ){
    	String situation = "";
    	switch(situ){
    	case "1": situation = "Sur chaussée";break;
    	case "2": situation = "Sur bande d'arret d'urgence"; break;
    	case "3": situation = "Sur accotement"; break;
    	case "4": situation = "Sur trottoir";break;
    	case "5": situation = "Sur piste cyclable"; break;
    	}
    	return situation;
    }

}
