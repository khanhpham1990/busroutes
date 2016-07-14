using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BusRouteHCM.Code
{
    public class Station
    {
        public string Name { get; set; }
        public string BusName { get; set; }
        public double X { get; set; }
        public double Y { get; set; }
        public bool IsWalk { get; set; }
    }
}