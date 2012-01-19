import java.io.*;
import java.util.ArrayList;

/** Contains functions to write and read from file. */
public class Io
{

    public static final String SYSTEM_SEPARATOR = System.getProperty("file.separator");

    public static boolean createFolder(String directory)
    {
        return (new File(directory)).mkdir();
    }

    // {{{ functions to write.
   
    /** Writes an arralyist with accelerometerpoints to file. */ 
    public static void writeFileConvertAccel(ArrayList<AccelerometerPoint> lines, 
        String fileName)
    {
        if (lines.size() == 0)
            return;

        ArrayList<String> newLines = new ArrayList<String> ();
        for (AccelerometerPoint point: lines)
        {
            newLines.addAll(point.toLines());
            PreprocessAccelerometer.accelLinesWritten += point.getDataSize();
        }


        writeFile(newLines, fileName);
    }
    
    /** Writes an arraylist with a string array to file (containing a gps line). */
    public static void writeFileConvertGps(ArrayList<String[]> lines, String fileName)
    {   
        ArrayList<String> newLines = new ArrayList<String> ();
        for (String[] lineSplitted : lines)
            newLines.add(PreprocessAccelerometer.arrayToString(lineSplitted));
        writeFile(newLines, fileName);
    }

    /** Writes an arraylist to a file. */
    public static void writeFile(ArrayList<String> lines, String fileName)
    {
        try
        {
          // Create file 
          FileWriter fstream = new FileWriter(fileName);
          BufferedWriter out = new BufferedWriter(fstream);
            for (String line: lines)
            {
                out.write(line);
            }
          //Close the output stream
          out.close();
          }
        catch (Exception e){//Catch exception if any
          System.err.println("Error: " + e.getMessage());
          }
    }

    // }}}

    // {{{  functions to read.

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

    // }}}

}
