import java.util.ArrayList;

/** Class to store datapoint of accelerometer data. 
* Would be sweet to also have such a class for gps data (instead of a String array).
* */
public class AccelerometerPoint
{
    /** In seconds. */
    private int timestamp, id;
    /** Length x 3 to store x, y and z acceleration. */
    private ArrayList<double[]> data;

    public AccelerometerPoint(int timestamp, int id)
    {
        this.timestamp = timestamp;
        this.id = id;
        data = new ArrayList<double[]> ();
    }

    public void addData(double x, double y, double z)
    {
        // theres got to be a better way
        double[] temp = new double[3];
        temp[0] = x;
        temp[1] = y;
        temp[2] = z;     
        data.add(temp);
    }

    public int getDataSize()
    {
        return data.size();
    }

    public int getTimestamp()
    {
        return timestamp;
    }

    /** Assumptions:
    * index 0 : timestamp
    * index 1 : index 
    * index 2 : x
    * index 3 : y
    * index 4 : z 
    * index 5 : id */
    public static ArrayList<AccelerometerPoint> stringArraysToPoints(
        ArrayList<String[]> lines)
    {
        ArrayList<AccelerometerPoint> points = new ArrayList<AccelerometerPoint> ();
        int timestamp = -1, lastTimestamp = -1, id = -1;
        AccelerometerPoint point = new AccelerometerPoint(0, 0); // cant be null

        for (String[] line : lines)
        {
            // retrieve timestamp
            timestamp = Integer.valueOf(line[0]);
            // retrieve id 
            id = Integer.valueOf(line[5]);
                
            // check for new datapoint
            if (timestamp != lastTimestamp)
            {
                if (lastTimestamp > 0)
                    points.add(point);
                point = new AccelerometerPoint(timestamp, id);
            }

            point.addData(Double.valueOf(line[2]), Double.valueOf(line[3]), 
                    Double.valueOf(line[4]));
                 
            lastTimestamp = Integer.valueOf(line[0]); 
        }
        if (lastTimestamp > 0)
            points.add(point);
        return points;  
    }

    public ArrayList<String> toLines()
    {
        ArrayList<String> lines = new ArrayList<String> ();
        for (int i = 0; i < data.size(); i ++)
        {
            lines.add(String.format("%d,%d,%d,%f,%f,%f\n", id, timestamp, i,
                data.get(i)[0], data.get(i)[1], data.get(i)[2]));
        }
        return lines; 
    }
    
}











