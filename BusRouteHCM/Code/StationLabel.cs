using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BusRouteHCM.Code
{
    public class StationLabel
    {
        private string _stationName;
        private double _distanceFromStart;
        private int _nStop;
        private string _busName;
        private string _previousBus;

        public StationLabel()
        {
            _nStop = 1;
        }

        public string StationName
        {
            get { return _stationName; }
            set { _stationName = value; }
        }

        public double DistanceFromStart
        {
            get { return _distanceFromStart; }
            set { _distanceFromStart = value; }
        }

        public int NumberBusStop
        {
            get { return _nStop; }
            set { _nStop = value; }
        }

        public string BusName
        {
            get { return _busName; }
            set { _busName = value; }
        }

        public string PreviousBus
        {
            get { return _previousBus; }
            set { _previousBus = value; }
        }
    }
}