using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BusRouteHCM.Code
{
    public class BusStop
    {
        private string name = null;
        private double x1 = 0.0;
        private double y1 = 0.0;
        public BusStop(string name, double x1, double y1) {
            this.name = name;
            this.x1 = x1;
            this.y1 = y1;
        }
        public BusStop() { 
        }
        public string getName() {
            return name;
        }
        public void setName(string name) {
            this.name = name;
        }
        public double getX1() {
            return x1;
        }
        public void setX1(double x1) {
            this.x1 = x1;
        }
        public double getY1() {
            return y1;
        }
        public void setY1(double y1) {
            this.y1 = y1;
        }
    }
}
