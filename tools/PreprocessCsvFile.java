import java.util.ArrayList;
import java.util.Date;
import java.io.*;
import java.text.SimpleDateFormat;
import java.awt.Polygon;
import java.awt.Rectangle;

/** Parses a .csv file of one (1) bird and splits it in processed small .csv file, 
* each containing one (1) session. 
*
* One can select the columns that need to be inlcuded.
* Sessions are split if they are more than a certain time apart (15 min?).
* Lines with '\N' occurences are excluded from the new .csv files.
* Lines with coordinates outside the north sea are excluded. 
* Date time is converted to seconds since 2008-01-01 00:00:00.
* 
* .csv file line beforehand:
* "device_info_serial","date_time","latitude","longitude","altitude","pressure","temperature","h_accuracy","v_accuracy","x_speed","y_speed","z_speed","gps_fixtime","location","userflag","satellites_used","positiondop","speed_accuracy","vnorth","veast","vdown","speed_3d"
*
* Input argument 1: a .csv file of one (1) bird
* Input argument 2: the number of the bird
* Input argument 3: a directory (will be filled with bird_x_session_y.csv files)
*
* Assumes the first line in the input .csv file are the labels of each columns
* Assumens the zero-based 1st index of the selected columns is the column with
* the timestamp.
* Assumes the zero-based 3rd and 4th index of the selected columns are the
* columns with latitude and longitude respectively.
*
* @author Maarten Inja */
class PreprocessCsvFile
{

    // Example of a date time: '2010-07-01 10:01:03' (which results in the following format:) 
    private static final SimpleDateFormat SIMPLE_DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    private static final float LOWER_BOUND_RESOLUTION = 1; // entrypoints per minute
    private static final float UPPER_BOUND_RESOLUTION = 90; 


    private static final String NORTH_SEA_COORDINATES_TEXT_FILE = "northSeaCoordinates.txt";
    /** Birds are being tracked since breeding season 2008 (www.uva-bits.nl). 
    * So instead of the epoch we use seconds since 2008-01-01 00:00:00.
    * "(SIMPLE_DATE_FORMAT.parse("2008-01-01 00:00:00")).getTime() / 1000;"*/
    private static final long USELESS_SECONDS = 1199142000;

    /** Minimum session time before we want to include it. */
    private static final int SESSION_MINIMUM_LENGTH_SECONDS = 3600; // 1 hour 
    private static final int SESSION_MINIMUM_LENGTH_ENTRIES = 5;
    private static final int SESSION_SEPARATOR_SECONDS = 900; // 15 min
   
    // some of these below should be converted to final static... 
 
    private static DoublePolygon northSeaPolygon;

    private static String inputDelimiter = ",";
    private static String outputDelimiter = ",";
    /** The integers in this column will be saved in the output file. */
    private static int[] includeColumns = {0, 1, 2, 3, 4, 18, 19, 20}; 
    private static int birdNumber = -1;
    /** The first line of the input .csv file. */
    private static ArrayList<String> columnLabels = new ArrayList<String> (1);
    private static String outputDirectory;

    private static int sessionCount, sessionsDiscarded, linesDiscarded;
    private static int totalLinesDiscarded = 0;

    public static void main (String args[])
    {
        if (args.length == 3)
        {
            birdNumber = Integer.valueOf(args[1]);
            outputDirectory = args[2];

            ArrayList<String[]> lines = preprocessTimeSlashN(args[0]);
            lines = preprocessNorthSeaPerimeter(lines);
            sessionize(lines);
            writeFile(columnLabels, outputDirectory + 
                System.getProperty("file.separator") + "labels.txt");
        }
        else
            System.out.println("Error, needs three arguments, 1st: input file name and 2nd: bird number 3rd: output file name"); 
    }

    /** Removes those lines that have coordinates who are not in the north sea. 
    * @warning UNTESTED*/
    public static ArrayList<String[]> preprocessNorthSeaPerimeter(
        ArrayList<String[]> lines)
    {

        // create and load the north sea coordinates from file to create a polygon
        ArrayList<String> northSeaLines = readFile(NORTH_SEA_COORDINATES_TEXT_FILE);
        northSeaPolygon = new DoublePolygon();
        for (String line : northSeaLines)
        {
            String[] lineSplitted = line.split(",");
            northSeaPolygon.addPoint(Double.valueOf(lineSplitted[0]), 
                                     Double.valueOf(lineSplitted[1]));
        }
       
        // check if the coordinates of the points are in the north sea polygon  
        int discardedLines = 0;
        ArrayList<String[]> newLines = new ArrayList<String[]> ();

        for (String[] line : lines)   
        {
            if (!northSeaPolygon.contains(Double.valueOf(line[2]), 
                                         Double.valueOf(line[3])))
                newLines.add(line);
            else
                discardedLines ++;
        }        

        System.out.println(discardedLines + " line(s) excluded because not in north sea");
        totalLinesDiscarded += linesDiscarded;
        
        return lines;
    }

    /** Splits the rows of the data in seperate sessions. */
    public static void sessionize(ArrayList<String[]> lines)
    {
        long lastTimestamp = 0, timestamp;
        sessionCount = 0; sessionsDiscarded = 0; linesDiscarded = 0;
        ArrayList<String[]> session = new ArrayList<String[]> ();


        for (String[] lineSplitted : lines)
        {
            //for (String s : lineSplitted)
            //   System.out.println(s);

            session.add(lineSplitted);
            timestamp = Long.valueOf(lineSplitted[1]);
            
            //System.out.printf("ts: %d, lst: %d, session_sep: %d\n", timestamp, lastTimestamp, SESSION_SEPARATOR_SECONDS);

            // if the difference in time was too great
            if (timestamp - lastTimestamp > SESSION_SEPARATOR_SECONDS)
            {
                // we create a new session (but check if we discard te old one)
                session = sessionCheck(session);
            }
            lastTimestamp = timestamp;
        }
        //System.out.printf("Sessions created: %d, sessions discarded: %d, lines discarded: %d (could not fit in a session)\n", sessionCount, sessionsDiscarded, linesDiscarded);
        System.out.println(linesDiscarded + " line(s) excluded because they could not fit in a session");
        totalLinesDiscarded += linesDiscarded;
        System.out.println(sessionCount + " session(s) created and written to file");
        System.out.println(sessionsDiscarded + " session(s) created but discarded");
   
    }
    
    /** Checks if a session is large and lengthy enough to write to file. Write
    * to file if so, creates a new session if not. */
    private static ArrayList<String[]> sessionCheck(ArrayList<String[]> session)
    {
        //System.out.println("sessionCheck");
        
        long sessionTimeSeconds = Long.valueOf(session.get(session.size() - 1)[1])- 
            Long.valueOf(session.get(0)[1]);
        sessionTimeSeconds = sessionTimeSeconds > 0 ? sessionTimeSeconds : 1;
        float sessionResolution = (sessionTimeSeconds/session.size())/60;

        // large and lengthy enough to call this session a session
        // also check if resolution is alllll right
        if (session.size() >= SESSION_MINIMUM_LENGTH_ENTRIES && 
            sessionTimeSeconds > SESSION_MINIMUM_LENGTH_SECONDS &&
            sessionResolution > LOWER_BOUND_RESOLUTION &&
            sessionResolution < UPPER_BOUND_RESOLUTION)
        {
            // safe!
            writeFileConvert(session, outputDirectory + 
                    System.getProperty("file.separator") + "bird_" + 
                    birdNumber + "_session_" + sessionCount + ".csv");
            sessionCount ++;
        }
        else
        {
            sessionsDiscarded ++;
            linesDiscarded += session.size();
        }
        return new ArrayList<String[]> (); 
    } 


    /** Returns an ArrayList with arrays with integers. Replaces each datetime 
    * with a timestamp. Removes a line for each '\N' occurence. */
    public static ArrayList<String[]> preprocessTimeSlashN(String inputFileName)
    {
        ArrayList<String[]> newLines = new ArrayList<String[]> ();
        ArrayList<String> lines = readFile(inputFileName); 
        int count = -1;
        int slashNCount = 0;

        for (String line: lines)
        {   
            String[] splittedLine = line.split(inputDelimiter);
            String[] newSplittedLine = new String[includeColumns.length];
            boolean slashN = false;   
            int i = 0; // :(
            for (int column : includeColumns)
            {
                // removing those crazy '"''s!
                newSplittedLine[i] = removeChar(splittedLine[column], '\"');

                // if its a date, change it to a timestamp
                newSplittedLine[i] = stringToTimestamp(newSplittedLine[i]);

                // and add it to the newline
                //newLine += newLinePart + outputDelimiter;
                // if a selected column contains '\\N' dont include it (move on)
                if (!slashN && newSplittedLine[i].indexOf("\\N") != -1)
                {
                    slashN = true;  
                    slashNCount ++;
                }
                i ++;
            }
            if (slashN)
                continue;
            // now remove the last delimiter and add newline
            //newLine = newLine.substring(0, newLine.length()-1) + "\n";
            // and add it to the newLines arraylist
            //for (String s : newSplittedLine)
            //    System.out.println(s);
            newLines.add(newSplittedLine);
        }

        // add resolution to the label names
        String[] labels = new String[newLines.get(0).length + 1];
        System.arraycopy(newLines.remove(0), 0,
            labels, 0, labels.length - 1);
        labels[labels.length - 1] = "resolution=[" + LOWER_BOUND_RESOLUTION + 
            "-" + UPPER_BOUND_RESOLUTION + "]entries/minute";
                    
        columnLabels.add(arrayToString(labels));
         
        System.out.println(lines.size() + " line(s) in input file");
        //System.out.println(newLines.size() + " line(s) in output file (removed the first line that indicates what column is what)");
        if (slashNCount > 0)
            System.out.println(slashNCount + " line(s) excluded because of occurence of '\\N'");
        totalLinesDiscarded += slashNCount;
         
        return newLines;
   
        //writeFile(newLines, outputFileName); 
    }

    /** Returns a timestamp if the string is a date time, the same string otherwise. */
    private static String stringToTimestamp(String s)
    {
        try
        {
            Date date = SIMPLE_DATE_FORMAT.parse(s);
            //return String.valueOf((date.getTime()/1000)-USELESS_SECONDS);
            return String.valueOf((date.getTime()/1000)-USELESS_SECONDS);
        }
        catch(Exception e)
        {
            return s;
        }
    }


    /** Rewrites an array to a string with the semi-columns and newlines. 
    * There should be a better way to do this but meh. */
    public static String arrayToString(String[] list)
    {
        String line = "";
        for (int i = 0; i <= list.length - 2; i ++)
            line += list[i] + outputDelimiter;
        return line + list[list.length - 1] + "\n";
    }
    
    /** Writes an arraylist with a string array to file. */
    public static void writeFileConvert(ArrayList<String[]> lines, String fileName)
    {   
        ArrayList<String> newLines = new ArrayList<String> ();
        for (String[] lineSplitted : lines)
            newLines.add(arrayToString(lineSplitted));
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

    /** Because Java's inbuilt String.'replace' doesnt work :@ */
    public static String removeChar(String s, char c) 
    {
        String r = "";
        for (int i = 0; i < s.length(); i ++) 
           if (s.charAt(i) != c) 
                r += s.charAt(i);
        return r;
    }




/** Used by the Roi classes to return double coordinate arrays and to
 *    determine if a point is inside or outside of spline fitted selections. 
 * SOURCE: http://imagej.nih.gov/ij/source/ij/process/FloatPolygon.java 
 * Edited to use doubles. */
private static class DoublePolygon {
    Rectangle bounds;

    /** The number of points. */
    public int npoints;

    /* The array of x coordinates. */
    public double xpoints[];

    /* The array of y coordinates. */
    public double ypoints[];

    /** Constructs an empty FloatPolygon. */ 
    public DoublePolygon() {
        npoints = 0;
        xpoints = new double[10];
        ypoints = new double[10];
    }

    /** Constructs a FloatPolygon from x and y arrays. */ 
    public DoublePolygon(double xpoints[], double ypoints[]) {
        if (xpoints.length!=ypoints.length)
            throw new IllegalArgumentException("xpoints.length!=ypoints.length");
        this.npoints = xpoints.length;
        this.xpoints = xpoints;
        this.ypoints = ypoints;
    }

    /** Constructs a FloatPolygon from x and y arrays. */ 
    public DoublePolygon(double xpoints[], double ypoints[], int npoints) {
        this.npoints = npoints;
        this.xpoints = xpoints;
        this.ypoints = ypoints;
    }
        
    /** Returns 'true' if the point (x,y) is inside this polygon. This is a Java
    version of the remarkably small C program by W. Randolph Franklin at
    http://www.ecse.rpi.edu/Homepages/wrf/Research/Short_Notes/pnpoly.html#The%20C%20Code
    */
    public boolean contains(double x, double y) {
        //System.out.printf("%f, %f in polygon?: ", x, y);
        boolean inside = false;
        for (int i=0, j=npoints-1; i<npoints; j=i++) {
            if (((ypoints[i]>y)!=(ypoints[j]>y)) &&
            (x<(xpoints[j]-xpoints[i])*(y-ypoints[i])/(ypoints[j]-ypoints[i])+xpoints[i]))
            inside = !inside;
        }
        //System.out.println(inside);
        return inside;
    }

    public Rectangle getBounds() {
        if (npoints==0)
            return new Rectangle();
        if (bounds==null)
            calculateBounds(xpoints, ypoints, npoints);
        return bounds.getBounds();
    }

    void calculateBounds(double[] xpoints, double[] ypoints, int npoints) {
        double minX = Float.MAX_VALUE;
        double minY = Float.MAX_VALUE;
        double maxX = Float.MIN_VALUE;
        double maxY = Float.MIN_VALUE;
        for (int i=0; i<npoints; i++) {
            double x = xpoints[i];
            minX = Math.min(minX, x);
            maxX = Math.max(maxX, x);
            double y = ypoints[i];
            minY = Math.min(minY, y);
            maxY = Math.max(maxY, y);
        }
        int iMinX = (int)Math.floor(minX);
        int iMinY = (int)Math.floor(minY);
        bounds = new Rectangle(iMinX, iMinY, (int)(maxX-iMinX+0.5), (int)(maxY-iMinY+0.5));
    }

    public void addPoint(double x, double y) {
        //System.out.printf("%f, %f\n", x, y);
        if (npoints==xpoints.length) {
            double[] tmp = new double[npoints*2];
            System.arraycopy(xpoints, 0, tmp, 0, npoints);
            xpoints = tmp;
            tmp = new double[npoints*2];
            System.arraycopy(ypoints, 0, tmp, 0, npoints);
            ypoints = tmp;
        }
        xpoints[npoints] = x;
        ypoints[npoints] = y;
        npoints++;
        bounds = null;
    }

    public String toString()
    {
        return "length: " + npoints + "\n";
    }

    
    public DoublePolygon duplicate() {
        int n = this.npoints;
        double[] xpoints = new double[n];
        double[] ypoints = new double[n];
        System.arraycopy(this.xpoints, 0, xpoints, 0, n);
        System.arraycopy(this.ypoints, 0, ypoints, 0, n);   
        return new DoublePolygon(xpoints, ypoints, n);
    }

}


} 















