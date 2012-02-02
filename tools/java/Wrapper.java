import java.io.*;

public class Wrapper
{
    public static final int[] KNOWN_IDS = {51, 52, 54, 121, 130, 132, 
    133, 134, 135, 297, 298, 304, 311, 317, 319, 320, 324, 324, 326,
    327, 329, 344, 355, 373, 533, 534, 535, 536, 537, 538, 540, 541,
    542};

    //public static final String OUTPUT_DIR = ".." + Io.SYSTEM_SEPARATOR + "parsedCsvFiles";
    public static final String OUTPUT_DIR = "temp";
    public static final String DIR_TO_DATA_FILES = ".." + Io.SYSTEM_SEPARATOR + 
        ".." + Io.SYSTEM_SEPARATOR + "rawdata" + Io.SYSTEM_SEPARATOR;

    public static void main(String args[])
    {

        for (int id : KNOWN_IDS)
        {
            File gpsCsvFile = new File(DIR_TO_DATA_FILES + "DATA_ALL_GPS_BIRD_" + id + ".csv");
            File accelCsvFile = new File(DIR_TO_DATA_FILES + "DATA_ALL_ACCELEROMETER_BIRD_" + id + ".csv");

            if (gpsCsvFile.exists())
            {
                System.out.print("\tParsing " + gpsCsvFile.getName());
                if (accelCsvFile.exists())
                {
                    System.out.println(" with " + accelCsvFile.getName());
                    args = new String[3];
                    args[0] = DIR_TO_DATA_FILES + gpsCsvFile.getName();
                    args[1] = OUTPUT_DIR;
                    args[2] = DIR_TO_DATA_FILES + accelCsvFile.getName();
                }
                else
                {
                    System.out.println(" without accel file");
                    args = new String[2];
                    args[0] = DIR_TO_DATA_FILES + gpsCsvFile.getName();
                    args[1] = OUTPUT_DIR;
                }
            }
            else
                System.out.println("\t!!!ERROR: missing gps file: " + gpsCsvFile.getName());
        }

    }
}
