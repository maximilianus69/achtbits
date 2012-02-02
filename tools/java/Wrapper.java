import java.io.*;

public class Wrapper
{
    public static final int[] KNOWN_IDS = {51, 52, 54, 121, 130, 132, 
    133, 134, 135, 297, 298, 304, 311, 317, 319, 320, 324, 324, 326,
    327, 329, 344, 355, 373, 533, 534, 535, 536, 537, 538, 540, 541,
    542};

    //public static final String outputDir = ".." + Io.SYSTEM_SEPARATOR + "parsedCsvFiles";
    public static String outputDir = "temp";
    public static String dirToDataFiles = ".." + Io.SYSTEM_SEPARATOR + 
        ".." + Io.SYSTEM_SEPARATOR + "rawdata" + Io.SYSTEM_SEPARATOR;


    public static void main(String args[])
    {

        if (args.length != 2)
        {
            System.out.println("Run this with two command line arguments: 1st the output directory, 2nd the directory of the data files.");
            System.out.println("Will now exit");
            return; 
        }
        outputDir = args[0];
        dirToDataFiles = args[1];

        for (int id : KNOWN_IDS)
        {
            File gpsCsvFile = new File(dirToDataFiles + "DATA_ALL_GPS_BIRD_" + id + ".csv");
            File accelCsvFile = new File(dirToDataFiles + "DATA_ALL_ACCELEROMETER_BIRD_" + id + ".csv");

            if (gpsCsvFile.exists())
            {
                System.out.print("\tParsing " + gpsCsvFile.getName());
                if (accelCsvFile.exists())
                {
                    System.out.println(" with " + accelCsvFile.getName());
                    args = new String[3];
                    args[0] = dirToDataFiles + gpsCsvFile.getName();
                    args[1] = outputDir;
                    args[2] = dirToDataFiles + accelCsvFile.getName();
                    PreprocessCsvFiles.main(args);
                }
                else
                {
                    System.out.println(" without accel file");
                    args = new String[2];
                    args[0] = dirToDataFiles + gpsCsvFile.getName();
                    args[1] = outputDir;
                    PreprocessCsvFiles.main(args);
                }
            }
            else
                System.out.println("\t!!!ERROR: missing gps file: " + gpsCsvFile.getName());
        }

    }
}
