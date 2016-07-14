using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BusRouteHCM.Code;

namespace BusRouteAlgorithm
{
    struct AdjStation
    {
        BusStation busStation;
        int edgeWeight;
        int isByBus;
        public BusStation BusStation
        {
            get
            {
                return busStation;
            }
            set
            {
                busStation = value;
            }
        }
        public int EdgeWeight
        {
            get
            {
                return edgeWeight;
            }
            set
            {
                edgeWeight = value;
            }
        }
        public int IsByBus
        {
            get { return isByBus; }
            set { isByBus = value; }
        }
    };

    class BusStation
    {
        #region Variables Declerations

        string name;
        double X; //Toa do X cua Node
        double Y; //Toa do Y cua Node
        string busActive; //Bus name in the result
        double stationWeight;

        public string Name
        {
            get
            {
                return name;
            }
            set
            {
                name = value;
            }
        }
        public double XCoord
        {
            get
            {
                return X;
            }
            set
            {
                X = value;
            }
        }
        public double YCoord
        {
            get
            {
                return Y;
            }
            set
            {
                Y = value;
            }
        }
        public string BusActive
        {
            get { return busActive; }
            set { busActive = value; }
        }

        List<AdjStation> adjacentStations;
        List<string> busRouteList;
        List<StationLabel> labelList;

        #region AStarAlgorithm
        double F; //Gia tri ham f(x)
        double G; //Gia tri ham g(x)
        double H; //Gia tri ham h(x)

        double PX; //Toa do X cua Node cha
        double PY; //Toa do Y cua Node cha
        
        public double FValue
        {
            get
            {
                return F;
            }
            set
            {
                F = value;
            }
        }
        public double GValue
        {
            get
            {
                return G;
            }
            set
            {
                G = value;
            }
        }
        public double HValue
        {
            get
            {
                return H;
            }
            set
            {
                H = value;
            }
        }
        public double PXCoord
        {
            get
            {
                return PX;
            }
            set
            {
                PX = value;
            }
        }
        public double PYCoord
        {
            get
            {
                return PY;
            }
            set
            {
                PY = value;
            }
        }
        #endregion AStarAlgorithm

        #region Dijkstra
        private bool isAdjToStart;
        private double distanceFromStart;
        private BusStation previousBusStation;

        public bool IsWalk
        { get; set; }
        public bool IsAdjToStart
        { 
            get { return isAdjToStart; }
            set { isAdjToStart = value; }
        }
        public double DistanceFromStart
        {
            get
            {
                return this.distanceFromStart;
            }
            set
            {
                this.distanceFromStart = value;
            }
        }
        public BusStation PreviousBusStation
        {
            get
            {
                return this.previousBusStation;
            }
            set
            {
                this.previousBusStation = value;
            }
        }
        #endregion Dijkstra
        
        #endregion
        
        #region Constructors
        public BusStation(string name, double X, double Y, int stationWeight)
        {
            F = 0; G = 0; H = 0; PX = 0; PY = 0;
            this.name = name;
            this.X = X;
            this.Y = Y;
            this.distanceFromStart = -1;
            this.stationWeight = stationWeight;
            this.IsWalk = false;
            adjacentStations = new List<AdjStation>();
            busRouteList = new List<string>();
            labelList = new List<StationLabel>();
        }
        public BusStation()
        {
            this.DistanceFromStart = -1;
            adjacentStations = new List<AdjStation>();
            busRouteList = new List<string>();
            labelList = new List<StationLabel>();
        }
        #endregion
        
        #region Methods
        public List<AdjStation> GetAdjStations()
        {
            return adjacentStations;
        }
        public List<string> GetBusRouteList()
        {
            return busRouteList;
        }
        public List<StationLabel> GetLabelList()
        {
            return labelList;
        }
        public void SetLabelList(StationLabel sl)
        {
            labelList.Add(sl);
        }
        public void ResetLabelList()
        {
            this.labelList = new List<StationLabel>();
        }
        public void SetAdjStations(BusStation s, int edgeWeight, int isByBus)
        {
            foreach (AdjStation adjStation in adjacentStations)
            {
                if (adjStation.BusStation.Name == s.Name) //The Node going to be added already in the adjacent list so ignore it
                    return;
            }
            AdjStation aS = new AdjStation();
            aS.EdgeWeight = edgeWeight;
            aS.BusStation = s;
            aS.IsByBus = isByBus;
            adjacentStations.Add(aS);
        }
        public void SetBusRouteGoThroughStation(string busRoute)
        { 
            busRouteList.Add(busRoute);
        }
        #endregion
    }
}

