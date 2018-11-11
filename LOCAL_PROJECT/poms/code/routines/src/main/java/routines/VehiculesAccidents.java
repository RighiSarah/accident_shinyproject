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
public class VehiculesAccidents {

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
    public static String set_categorie (String catg){
    	String categorie = "";
    	if (catg.equals ("01") || catg.equals ("02") || catg.equals("03")  ){
    		categorie = "Bicyclette";
    	}else if (catg.equals("04") || catg.equals("05") ||  catg.equals("06")||
    			catg.equals("30") || catg.equals("31") || catg.equals("32") || 
    			catg.equals("33") || catg.equals("34") || catg.equals("35") || 
    			catg.equals("36") ){
    		categorie = "Scooter";
    	}else if (catg.equals("07") ){
    		categorie = "Vehicule seul";
    	}else if (	catg.equals("08") || catg.equals("09") || catg.equals("10")
    			|| catg.equals("11")|| catg.equals("12")|| catg.equals("13")
    			|| catg.equals("14") || catg.equals("15") ) {
    		categorie = "Camion";
    	}else if (catg.equals("16") || catg.equals("17") || catg.equals("21")){
    		categorie = "Tracteur";
    	}else if (catg.equals("18") || catg.equals("19") || catg.equals("40")){
    		categorie = "Tramway";
    	}else if ( catg.equals("20") || catg.equals("99")){
    		categorie = "Autre" ; 
    	}else if (catg.equals("37")|| catg.equals("38") || catg.equals("18") 
    			|| catg.equals("39") || catg.equals("40")){
    		categorie = "Transport en commun";
    	}else {
    		categorie = "Autre";
    	}
    	return categorie ;
    }
}
