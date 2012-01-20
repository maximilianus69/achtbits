import java.util.ArrayList;
import java.util.Date;
import java.text.SimpleDateFormat;
import java.awt.Polygon;
import java.awt.Rectangle;

/** Parses a .csv file of one (1) bird and splits it in processed small .csv file, 
* each containing one (1) session. Optionally it can accept a .csv file with 
* accelerometer data. It will create additional .csv session files next to the gps
* files that contain the accelerometer data files.
*
* Parsed .csv files are dropped in a newly created folder ('deviceX') in the output
* folder.
*
* One can select the columns that need to be inlcuded (in source).
* Sessions are split if they are more than a certain time apart (15 min?).
* Lines with '\N' occurences are excluded from the new .csv files.
* Lines with coordinates outside the north sea are excluded. 
* Date time is converted to seconds since 2008-01-01 00:00:00.
* 
*
* Input argument 1: a .csv file of one (1) bird with gps data.
* Input argument 2: a directory (will be filled with bird_x_session_y.csv files).
* Input argument 3: (optional) a .csv of one (1) bird accelerometer data.
*
* Assumes the first line in the input gps .csv file are the labels of each columns.
* Assumens the zero-based 1st index of the selected columns is the column with.
* the timestamp.
* Assumes the zero-based 3rd and 4th index of the selected columns are the
* columns with latitude and longitude respectively.
*
* Accelerometer .csv data files have more specific requirements.
* TODO: write specific requirements for the accelerometer .csv data files here.
*
* @author Maarten Inja */
class PreprocessCsvFiles
{
   
    ///// constants ///// 

    /** Used to converts date times to timestamp in ms. Example of a date time from
    * file: '2010-07-01 10:01:03' */
    private static final SimpleDateFormat SIMPLE_DATE_FORMAT = 
        new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    /** Everything outside this polygon from the coordinates in the file is 
    * discarded.*/
    private static final String NORTH_SEA_COORDINATES_TEXT_FILE = "northSeaCoordinates.txt";
    /** Birds are being tracked since breeding season 2008 (www.uva-bits.nl). 
    * So instead of the epoch we use seconds since 2008-01-01 00:00:00.
    * "(SIMPLE_DATE_FORMAT.parse("2008-01-01 00:00:00")).getTime() / 1000;"*/
    private static final long USELESS_SECONDS = 1199142000;


    ///// Command line arguments /////

    /** Optional. */
    private static String accelerometerDatafile;
    private static String outputDirectory;

    ///// (Should) Read these from the config file /////

    /** Boundaries to filter resolution in entrypoints per minutes. */
    private static float lowerBoundresolution = 1; 
    private static float upperBoundresolution = 90; 

    /** Minimum session time before we want to include it. */
    private static final int sessionMinimumLengthSeconds = 3600; // 1 hour 
    private static final int sessionMinimumLengthEntries = 5;
    private static final int sessionSeparatorSeconds = 900; // 15 min

    private static String inputDelimiter = ",";
    private static String outputDelimiter = ",";

    /** The integers in this column will be saved in the output file. */
    private static int[] includeColumnsGps = {0, 1, 2, 3, 4, 18, 19, 20, 9, 10, 11}; 
    private static int[] includeColumnsAcc = {1, 2, 3, 4, 5, 0}; 

    ///// other /////

    /** Is a accelerometer .csv data file supplied from command line arguments?*/
    private static boolean parseAccelerometerData;

    private static DoublePolygon northSeaPolygon;

    /** To store the completely parsed gps sessions in before writing to file. */
    private static ArrayList<ArrayList<String[]>> parsedSessions;
    /** To store completely parsed accel sessions in before writing to file. */
    private static ArrayList<ArrayList<AccelerometerPoint>> accelerosSessionized;
   
    private static int deviceId = -1;
    /** Description and that what will be written to labels.txt. */
    private static ArrayList<String> columnLabels;
    private static int sessionCount, sessionsDiscarded, linesDiscarded;
    private static int totalLinesDiscarded, linesRead; 
    private static int totalGpsLines, totalAccelLines;
    /** Written to by Io.java. */
    public static int gpsLinesWritten, accelLinesWritten;

    public static int[] mainWrapper(String[] args)
    {
        totalLinesDiscarded = 0;
        gpsLinesWritten = accelLinesWritten = 0;
        totalGpsLines = totalAccelLines = linesRead = 0;
        parsedSessions = new ArrayList<ArrayList<String[]>> ();
        columnLabels = new ArrayList<String> ();
       
        // total gps lines, gps lines lost, total accel lines, accel lines lost 
        int[] resultArray = {-1, -1, -1, -1};

        if (args.length == 2 | (parseAccelerometerData = args.length == 3))
        {
            System.out.println("Processing gps data .csv file");
                
            outputDirectory = args[1];

            // read lines from file and preprocess some
            ArrayList<String[]> lines =     
                preprocessTimeSlashN(args[0], includeColumnsGps);
System.out.println("gps lines read: " + linesRead);
            resultArray[0] = linesRead; // total gps lines

            if (lines.size() < 2)
            {
                System.out.println("Too little remains of gps data, exit");
                return resultArray;
            }

            // extract bird number from some column
            deviceId = extractDeviceId(columnLabels, lines);

            if (Io.createFolder(outputDirectory + Io.SYSTEM_SEPARATOR + "device" +
                deviceId))
                outputDirectory += Io.SYSTEM_SEPARATOR + "device" + deviceId;
            else
            {
                System.out.println("Could not create directory.. exiting");
                return resultArray;
            }

            // preprocess some more
            lines = preprocessNorthSeaPerimeter(lines);

            if (lines.size() < 2)
            {
                System.out.println("Too little remains of gps data, exit");
                return resultArray;
            }

            // split the lines into sessions
            sessionize(lines);

            // Write the labels for each column + some extra info to file. 
            Io.writeFile(columnLabels, outputDirectory + Io.SYSTEM_SEPARATOR +
                "labels.txt");

            System.out.println("Writting gps to file");

            // write the parsed sessions to file
            for (int i = 0; i < parsedSessions.size(); i++)
                Io.writeFileConvertGps(parsedSessions.get(i), 
                    String.format(outputDirectory + Io.SYSTEM_SEPARATOR +
                    "device_" + deviceId + "_gps_session_%03d.csv", i));


resultArray[1] = resultArray[0] - gpsLinesWritten; // gps lines lost
System.out.println("gps lines lost : " + resultArray[1]);

            if (parseAccelerometerData)
            {
                accelerometerDatafile = args[2];
                // parse accelerometer data here ... 

                System.out.println("Processing accelerometer data .csv file");
                ArrayList<String []> acceleroLines = 
                    preprocessTimeSlashN(accelerometerDatafile, includeColumnsAcc);
                resultArray[2] = linesRead; // total accel lines

System.out.println("accel lines read: " + linesRead);

                if (acceleroLines.size() < 2)
                {
                    System.out.println("Too little remains of accel data, exit");
                    return resultArray;
                }
            
                ArrayList<AccelerometerPoint> acceleros = 
                    AccelerometerPoint.stringArraysToPoints(acceleroLines);

                if (acceleros.size() < 2)
                {
                    System.out.println("Too little remains of accel data, exit");
                    return resultArray;
                }

                accelerosSessionized = 
                    linkGpsWithAccelerometer(parsedSessions, acceleros);


                if (acceleros.size() < 2)
                {
                    System.out.println("Too little remains of accel data, exit");
                    return resultArray;
                }

                System.out.println("writing accel to file");

                for (int i = 0; i < accelerosSessionized.size(); i++)
                    Io.writeFileConvertAccel(accelerosSessionized.get(i), 
                        String.format(outputDirectory + Io.SYSTEM_SEPARATOR +
                         "device_" + deviceId + "_accel_session_%03d.csv", i));
                
                resultArray[3] = resultArray[2] - accelLinesWritten; // accel lines lost
System.out.println("accel lines lost : " + resultArray[3]);

                int lostAccelLines = acceleroLines.size() - accelLinesWritten;
                System.out.println(accelLinesWritten + " of " + 
                    acceleroLines.size() + " accelerometer points written to file" +
                    " (" + lostAccelLines + " lines lost).");

            }

        }
        else
            System.out.println("Error, needs three or four arguments, 1st: input file name, 2nd: output file name 3rd (optional) input file for accelerometer data"); 

        return resultArray;
    }

    public static void main (String args[])
    {
        mainWrapper(args);
    }

    /** Uses columnLabels to find the column with the device (serial?) id. 
    * Returns a device id if found, -1 otherwise. */
    public static int extractDeviceId(ArrayList<String> columnLabels, 
        ArrayList<String[]> lines)
    {
        int column = -1;
        //for (String s: columnLabels)
        //    System.out.println(s);
        for (int i = 0; i < columnLabels.size(); i ++)
            if (columnLabels.get(i).indexOf("serial") != -1)
            {
                column = i;
                break;
            }
        try
        {
            return column >= 0 ? Integer.valueOf(lines.get(0)[column]) : column;
        }
        catch (Exception e)
        {
            System.out.println("ERROR!");
            System.out.println(e.getMessage());
            e.printStackTrace();
            System.out.println("Found column " + column);
            System.out.println("Printing lines.get(0) for debug purposes");
            for (String s: lines.get(0))
                System.out.println(s);
            System.exit(1);
        }
        // unreachable code, freakin' compiler
        return -1;
    }


    /** splits up arraylist with acceldatapoints to arraylist with sessions of
    * acceldatapoints. */
    public static ArrayList<ArrayList<AccelerometerPoint>> linkGpsWithAccelerometer(
        ArrayList<ArrayList<String[]>> gpsParsed, 
        ArrayList<AccelerometerPoint> acceleros)
    {
        // the sessions of the acceldata
        ArrayList<ArrayList<AccelerometerPoint>> accelerosSessionized = 
            new ArrayList<ArrayList<AccelerometerPoint>> ();

        // loop through the gsp sessions
        for (ArrayList<String[]> gpsSession : gpsParsed)
        {
            // create a new accel session 
            ArrayList<AccelerometerPoint> accelSession = 
                new ArrayList<AccelerometerPoint> ();

            // loop through ALL known acceldatapoints
            for (AccelerometerPoint point : acceleros)
            {
                // loop through each gps datapoint in this session
                for (String [] gpsLine : gpsSession)
                {
                    // if a acceldatapointtimestamp matches gpsdatappointstime stamp
                    if (point.getTimestamp() == Integer.valueOf(gpsLine[1]))
                        // add this accelpoint to the accelsession
                        accelSession.add(point);
                }
            }
            // add the accelsession to the return session
            accelerosSessionized.add(accelSession);
        }
        return accelerosSessionized;
    }

    /** Removes those lines that have coordinates who are not in the north sea. */
    public static ArrayList<String[]> preprocessNorthSeaPerimeter(
        ArrayList<String[]> lines)
    {

        // create and load the north sea coordinates from file to create a polygon
        ArrayList<String> northSeaLines = Io.readFile(NORTH_SEA_COORDINATES_TEXT_FILE);
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
            if (northSeaPolygon.contains(Double.valueOf(line[2]), 
                                         Double.valueOf(line[3])))
                newLines.add(line);
            else
                discardedLines ++;
        }        

        System.out.println(discardedLines + " line(s) excluded because not in north sea");
        totalLinesDiscarded += linesDiscarded;
        
        return newLines;
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
            
            //System.out.printf("ts: %d, lst: %d, session_sep: %d\n", timestamp, lastTimestamp, sessionSeparatorSeconds);

            // if the difference in time was too great
            if (timestamp - lastTimestamp > sessionSeparatorSeconds)
            {
                if (session.size() > 1)
                    session.remove(session.size()-1);
                // we create a new session (but check if we discard te old one)
                session = sessionCheck(session);
            }
            lastTimestamp = timestamp;
        }
        //System.out.printf("Sessions created: %d, sessions discarded: %d, lines discarded: %d (could not fit in a session)\n", sessionCount, sessionsDiscarded, linesDiscarded);
        System.out.println(linesDiscarded + " line(s) excluded because they could not fit in a session");
        totalLinesDiscarded += linesDiscarded;
        System.out.println(sessionCount + " session(s) created ready to write to file");
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
        if (session.size() >= sessionMinimumLengthEntries && 
            sessionTimeSeconds > sessionMinimumLengthSeconds &&
            sessionResolution > lowerBoundresolution &&
            sessionResolution < upperBoundresolution)
        {
            // safe!
            parsedSessions.add(session);
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
    public static ArrayList<String[]> preprocessTimeSlashN(String inputFileName,
        int[] includeColumns)
    {
        ArrayList<String[]> newLines = new ArrayList<String[]> ();
        ArrayList<String> lines = Io.readFile(inputFileName); 
        linesRead = lines.size();

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
        labels[labels.length - 1] = " with a resolution of " + 
            lowerBoundresolution + "-" + upperBoundresolution + 
            " entries/minute";

        columnLabels.add(arrayToString(labels));
        columnLabels.add("accel: id, timestamp, index, x, y, z.. I believe...\n");
         
        System.out.println(lines.size() + " line(s) in input file");

        if (slashNCount > 0)
            System.out.println(slashNCount + " line(s) excluded because of occurence of '\\N'");
        totalLinesDiscarded += slashNCount;
         
        return newLines;
   
    }

    /** Returns a timestamp if the string is a date time, the same string otherwise. */
    private static String stringToTimestamp(String s)
    {
        try
        {
            Date date = SIMPLE_DATE_FORMAT.parse(s);
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



    /** Because Java's inbuilt String.'replace' doesnt work :@ */
    public static String removeChar(String s, char c) 
    {
        String r = "";
        for (int i = 0; i < s.length(); i ++) 
           if (s.charAt(i) != c) 
                r += s.charAt(i);
        return r;
    }






} 















