/** Used by the Roi classes to return double coordinate arrays and to
 *    determine if a point is inside or outside of spline fitted selections. 
 * SOURCE: http://imagej.nih.gov/ij/source/ij/process/FloatPolygon.java 
 * Edited to use doubles and also removed a lot of stuff. */
public class DoublePolygon {

    /** The number of points (x/ypoints.length??). */
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
    }

    public String toString()
    {
        return "length: " + npoints + "\n";
    }

    

}
