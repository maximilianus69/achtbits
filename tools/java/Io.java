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

    public static void deleteIfOnlyLabelsWereWritten(String outputDirectory)
    {
        File outputDir = new File(outputDirectory);

        System.out.println("Dir list length: " + outputDir.list().length);

        // if only labels.txt was written (this should be checked earlier
        // and not deleted afterwards) delete the folder
        if ((new File(outputDirectory)).list().length ==  1)
            (new File(outputDirectory)).delete();
    }

    /** Reads config.txt and sets static variabels in PreprocessCsvFiles. {{{
    * done last moment so it isn't pretty all right!?*/
    public static void readAndSetConfiguration() throws Exception
    {
/*
lowerBoundresolution=0.2f 
upperBoundresolution=90
sessionMinimumLengthSeconds=3600
sessionMinimumLengthEntries=5
sessionSeparatorSeconds=900
inputDelimiter=,
outputDelimiter=,
includeColumnsGps=0, 1, 2, 3, 4, 18, 19, 20, 9, 10, 11}
includeColumnsAcc=1, 2, 3, 4, 5, 0}
*/
        ArrayList<String> lines = readFile("config.txt");
        String delimiter = "=";

        PreprocessCsvFiles.lowerBoundresolution = Float.valueOf(lines.get(0).split(delimiter)[1]);
        PreprocessCsvFiles.upperBoundresolution = Float.valueOf(lines.get(1).split(delimiter)[1]);
        PreprocessCsvFiles.sessionMinimumLengthSeconds= Integer.valueOf(lines.get(2).split(delimiter)[1]);
        PreprocessCsvFiles.sessionMinimumLengthEntries= Integer.valueOf(lines.get(3).split(delimiter)[1]);
        PreprocessCsvFiles.sessionSeparatorSeconds = Integer.valueOf(lines.get(4).split(delimiter)[1]);
        PreprocessCsvFiles.inputDelimiter = lines.get(5).split(delimiter)[1];
        PreprocessCsvFiles.outputDelimiter = lines.get(6).split(delimiter)[1];

        String[] values1 = lines.get(7).split(delimiter)[1].split(",");
        PreprocessCsvFiles.includeColumnsGps = new int[values1.length];
        for (int i = 0; i < values1.length; i ++)
            PreprocessCsvFiles.includeColumnsGps[i] = Integer.valueOf(values1[i]);

        
        //for (int i = 0; i < values1.length; i ++)
        //    System.out.println(PreprocessCsvFiles.includeColumnsGps[i]);
        
        
        String[] values2 = lines.get(7).split(delimiter)[1].split(",");
        PreprocessCsvFiles.includeColumnsAcc = new int[values2.length];
        for (int i = 0; i < values2.length; i ++)
            PreprocessCsvFiles.includeColumnsAcc[i] = Integer.valueOf(values2[i]);
        
    } // }}}

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
            PreprocessCsvFiles.accelLinesWritten += point.getDataSize();
        }


        writeFile(newLines, fileName);
    }
    
    /** Writes an arraylist with a string array to file (containing a gps line). */
    public static void writeFileConvertGps(ArrayList<String[]> lines, String fileName)
    {   
        ArrayList<String> newLines = new ArrayList<String> ();
        for (String[] lineSplitted : lines)
        {
            newLines.add(PreprocessCsvFiles.arrayToString(lineSplitted));
            PreprocessCsvFiles.gpsLinesWritten ++; // bleh is ugly 
        }
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
