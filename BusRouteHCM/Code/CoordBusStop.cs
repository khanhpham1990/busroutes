using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BusRouteHCM.Code
{
    public class CoordBusStop
    {
        private string name = null;
        private double x1 = 0.0;
        private double y1 = 0.0;
        private double coord = 0.0;
        public CoordBusStop(string name, double x1, double y1, double coord) {
            this.name = name;
            this.coord = coord;
            this.x1 = x1;
            this.y1 = y1;
        }
        public string getName() {
            return name;
        }
        public void setName(string name) {
            this.name = name;
        }
        public double getCoord() {
            return coord;
        }
        public void setCoord(double coord) {
            this.coord = coord;
        }

        public double getX1()
        {
            return x1;
        }
        public void setX1(double x1)
        {
            this.x1 = x1;
        }

        public double getY1()
        {
            return y1;
        }
        public void seY1(double y1)
        {
            this.y1 = y1;
        }

    }
}
