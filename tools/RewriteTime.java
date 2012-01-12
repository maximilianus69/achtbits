import java.util.ArrayList;
import java.util.*;
import java.io.*;
import java.text.SimpleDateFormat;

/** Rewrites the date in a .csv file to a timestamp instead of a string
* and writes it to a new .csv file. 
* @author Maarten Inja*/
class RewriteTime
{
    // Example of a date time 2010-07-01 10:01:03 (which results in the following format:) 
    private static SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    private static String delimiter = ",";


    public static void main (String args[])
    {
        if (args.length == 2)
            rewriteTime(args[0], args[1]);
        else
            System.out.println("Error, needs two arguments, 1st input file name and 2nd output file name"); 
    }


    public static void rewriteTime(String inputFileName, String outputFileName)
    {
        ArrayList<String> newLines = new ArrayList<String> ();
        ArrayList<String> lines = readFile(inputFileName); 
        int count = 0;
        for (String line: lines)
        {
            try
            {
                String[] splittedLine = line.split(delimiter);
                Date date = simpleDateFormat.parse(splittedLine[1]);
                splittedLine[1] = String.valueOf(date.getTime());
                newLines.add(arrayToString(splittedLine)); 
            }
            catch(Exception e)
            {
                count ++;
            }
        }
        System.out.println(count + " line(s) not rewritten");
        writeFile(newLines, outputFileName); 
        System.out.println("done");        
    }

    /** Rewrites an array to a string with the semi-columns and newlines. 
    * There should be a better way to do this but meh. */
    public static String arrayToString(String[] list)
    {
        String line = "";
        for (int i = 0; i <= list.length - 2; i ++)
            line += list[i] + ";";
        return line + list[list.length - 1] + "\n";
    }

    /** Writes an arraylist to a file. */
    public static void writeFile(ArrayList<String> lines, String fileName)
    {
        try{
          // Create file 
          FileWriter fstream = new FileWriter(fileName);
          BufferedWriter out = new BufferedWriter(fstream);
            for (String line: lines)
                out.write(line);
          //Close the output stream
          out.close();
          }catch (Exception e){//Catch exception if any
          System.err.println("Error: " + e.getMessage());
          }
    }

    /** Returns an arraylist in which each item is a line from the file*/
    public static ArrayList<String> readFile(String fileName)
    {
        ArrayList<String> lines = new ArrayList<String> ();
        try{
          // Open the file that is the first 
          // command line parameter
          FileInputStream fstream = new FileInputStream(fileName);
          // Get the object of DataInputStream
          DataInputStream in = new DataInputStream(fstream);
          BufferedReader br = new BufferedReader(new InputStreamReader(in));
          String strLine;
          //Read File Line By Line
          while ((strLine = br.readLine()) != null)   {
          // Print the content on the console
                lines.add(strLine);
          }
          //Close the input stream
          in.close();
            }catch (Exception e){//Catch exception if any
          System.err.println("Error: " + e.getMessage());
          }
        return lines;
    }
}

