using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics;
using BusRouteAlgorithm;
using System.IO;
using BusRouteHCM.Code;

namespace BusRouteAlgorithm
{
    class Dijkstra
    {
        #region Variables Declaration
        const double RADIO = 6371*1000;//Ban kinh Trai Dat theo metre
        const double PIx = 3.141592653589793;
        private double distanceM = 200;       // khoang cach trung binh tinh den cac tram xung quanh

        List<BusStation> allBusStations;
        List<StationLabel> allStationLabels;
        List<BusStation> path;
        ReadData readData;
        private PriorityQueueB<BusStation> mOpenSet;// = new PriorityQueueB<BusStation>(new CompareBusStation());

        #endregion Variables Declaration

        #region Methods
        public Dijkstra()
        {
            allBusStations = new List<BusStation>();
            allStationLabels = new List<StationLabel>();
            path = new List<BusStation>();
            readData = new ReadData();
            mOpenSet = new PriorityQueueB<BusStation>(new CompareBusStation());
            
            //var timeCounter = new Stopwatch();
            //timeCounter.Start();
            readData.ExcuteReadData();
            allBusStations = readData.GetAllStations();

            #region Edit the input file for new require
            //---------------------------------------//
            //double totalDistanceCoord = 0.0;
            //using (StreamWriter sr = File.CreateText("D:\\oldInput.txt"))
            //{
            //    sr.WriteLine(allBusStations.Count);
            //}
            //using (StreamWriter sr = File.AppendText("D:\\oldInput.txt"))
            //{
            //    foreach (BusStation bs in allBusStations)
            //    {
            //        //foreach (BusStation bsFind in allBusStations)
            //        //{
            //        //    totalDistanceCoord = DistanceBetweenPlaces(bs.XCoord, bs.YCoord, bsFind.XCoord, bsFind.YCoord);     // caculate distance (start,end) vs (x1,y1)
            //        //    if (totalDistanceCoord < distanceM && totalDistanceCoord > 0)
            //        //    {
            //        //        bs.SetAdjStations(bsFind, (int)totalDistanceCoord, 0);
            //        //    }
            //        //}
            //        string output = bs.Name + " " + bs.XCoord + " " + bs.YCoord;
            //        sr.WriteLine(output);
            //    }
            //}
            //using (StreamWriter sr = File.AppendText("D:\\oldInput.txt"))
            //{
            //    foreach (BusStation bs in allBusStations)
            //    {
            //        foreach (AdjStation adjBs in bs.GetAdjStations())
            //        {
            //            string output = bs.Name + " " + adjBs.BusStation.Name + " " + adjBs.EdgeWeight + " " + adjBs.IsByBus;
            //            sr.WriteLine(output);
            //        }
            //    }
            //}
            //End edit file
            //---------------------------------------//
            #endregion

            foreach (BusStation s in allBusStations)
            {
                StationLabel sLabel = new StationLabel();
                sLabel.StationName = s.Name;
                sLabel.DistanceFromStart = s.DistanceFromStart;
                allStationLabels.Add(sLabel);
            }
            //timeCounter.Stop();
            //long elapsedTime = timeCounter.ElapsedMilliseconds;
            //System.Console.WriteLine("Read data: " + elapsedTime);
        }

        public List<BusStation> RunAlgorithm(string startStation, string destStation, int numBusStop)
        {
            List<BusStation> dijkstraPath = new List<BusStation>();
            List<List<BusStation>> resultList = new List<List<BusStation>>();
            
            BusStation start = readData.GetStationByName(startStation);
            BusStation dest = readData.GetStationByName(destStation);

            List<BusStation> startList = new List<BusStation>();
            List<BusStation> destList = new List<BusStation>();
            double totalDistanceCoord = 0.0;
            startList.Add(start);
            destList.Add(dest);

            //Tim tat ca cac tram xung quanh 2 tram dau va cuoi cua input
            foreach (BusStation bs in allBusStations)
            {
                totalDistanceCoord = DistanceBetweenPlaces(start.XCoord, start.YCoord, bs.XCoord, bs.YCoord);     // caculate distance (start,end) vs (x1,y1)
                if (totalDistanceCoord > 0 && totalDistanceCoord < distanceM)
                {
                    startList.Add(bs);
                }
                totalDistanceCoord = DistanceBetweenPlaces(dest.XCoord, dest.YCoord, bs.XCoord, bs.YCoord);     // caculate distance (start,end) vs (x1,y1)
                if (totalDistanceCoord > 0 && totalDistanceCoord < distanceM)
                {
                    destList.Add(bs);
                }
            }

            //Tim tat ca duong di ngan nhat giua cac tram trong 2 list startList va destList
            foreach (BusStation bsInStartList in startList)
            {
                foreach (BusStation bsInDestList in destList)
                {
                    resultList.Add(this.MainAlgorithm(bsInStartList, bsInDestList, numBusStop));
                }
            }

            //if (resultList.ElementAt(0).Count > 3)
            //{
            //    dijkstraPath = resultList.ElementAt(0);
            //    return dijkstraPath;
            //}

            //for (int i = 0; i < resultList.Count; i++)
            //{
            //    List<BusStation> temp = resultList.ElementAt(i);
            //    if (temp.Count > 3)
            //    {
            //        if (temp.First().Name.Equals(start.Name) || temp.Last().Name.Equals(dest.Name))
            //        {
            //            dijkstraPath = resultList.ElementAt(0);
            //            return dijkstraPath;
            //        }
            //    }
            //}

            dijkstraPath = GetMinResult(resultList);

            return dijkstraPath;
        }

        public List<BusStation> GetMinResult(List<List<BusStation>> resultList)
        { 
            List<BusStation> result = null;
            int indexResult = 0;
            int min = 10000;
            for (int i = 1; i < resultList.Count; i++)
            {
                if (resultList.ElementAt(i).Count > 3 && resultList.ElementAt(i).Count < min)
                {
                    min = resultList.ElementAt(i).Count;
                    indexResult = i;
                }
            }

            result = resultList.ElementAt(indexResult);
            return result;
        }

        /// <summary>
        /// The main algorithm
        /// </summary>
        /// <param name="start"></param>
        /// <param name="dest"></param>
        /// <param name="numBusStop"></param>
        /// <returns></returns>
        public List<BusStation> MainAlgorithm(BusStation start, BusStation dest, int numBusStop)
        {
            // Initialize the distance to every node from the starting node. 
            //GetStartingTraversalCost(start);

            // Initialize best path to every node as from the starting node. 
            //GetStartingBestPath(start);

            // Initialize the distance to every node from the starting node.
            // Initialize best path to every node as from the starting node. 
            GetBestPathAndStartingTraversalCost(start);

            PriorityQueueB<BusStation> Q = new PriorityQueueB<BusStation>(new CompareBusStationDijkstra());

            for (int i = 0; i < allBusStations.Count; i++)
                Q.Push(allBusStations.ElementAt(i));


            while (Q.Count != 0)
            {
                BusStation examiningBusStation = Q.Pop();

                //If this node is the dest node: BREAK
                if (examiningBusStation.Name == dest.Name)
                    break;

                foreach (var adjStation in examiningBusStation.GetAdjStations())
                {
                    BusStation adjBusStation = adjStation.BusStation;
                    double cost = adjStation.EdgeWeight;

                    SetLabelListForABusStation(examiningBusStation, adjBusStation, start, numBusStop);

                    if (adjBusStation.Name.Equals(dest.Name))
                    {
                        adjBusStation.PreviousBusStation = examiningBusStation;
                        adjBusStation.DistanceFromStart = examiningBusStation.DistanceFromStart + cost;
                        path = GetMinimumPath(start, dest);
                        return path;
                    }

                    bool NumBusStopExceedCondition = IsNumBusStopExceedCondition(adjBusStation, numBusStop);

                    if (cost < ProjectConstants.MAX_VAUE && 
                            ((examiningBusStation.DistanceFromStart + cost) < adjBusStation.DistanceFromStart) && !NumBusStopExceedCondition)
                    {
                        // We have found a better way to get at relative 
                        adjBusStation.DistanceFromStart = examiningBusStation.DistanceFromStart + cost; // record new distance 
                        adjBusStation.PreviousBusStation = examiningBusStation;

                        //foreach (StationLabel label in adjBusStation.GetLabelList())
                        //{
                        //    if (label.NumberBusStop > numBusStop)
                        //    {
                        //        adjBusStation.GetLabelList().Remove(label);
                        //    }
                        //}
                        if (adjBusStation.GetLabelList().Count > 0)
                        {
                            Q.Push(adjBusStation);
                        }
                    }
                }
            }
            
            path = GetMinimumPath(start, dest);
            return path;
        }

        /// <summary>
        /// Set label list for adjBusStation
        /// </summary>
        /// <param name="examiningBusStation"></param>
        /// <param name="adjBusStation"></param>
        /// <param name="start"></param>
        /// <param name="numBusStop"></param>
        public void SetLabelListForABusStation(BusStation examiningBusStation, BusStation adjBusStation, BusStation start, int numBusStop)
        {
            if (adjBusStation.GetLabelList().Count == 0)
            {
                if (examiningBusStation.Name.Equals(start.Name))
                {
                    foreach (string route in examiningBusStation.GetBusRouteList())
                    {
                        foreach (string routeInAdjStation in adjBusStation.GetBusRouteList())
                        {
                            if (routeInAdjStation.Equals(route))
                            {
                                StationLabel sl = new StationLabel();
                                sl.StationName = adjBusStation.Name;
                                sl.BusName = routeInAdjStation;
                                sl.PreviousBus = route;
                                sl.DistanceFromStart = adjBusStation.DistanceFromStart;
                                adjBusStation.SetLabelList(sl);
                            }
                        }
                    }
                }
                else
                {
                    foreach (StationLabel label in examiningBusStation.GetLabelList())
                    {
                        foreach (string routeInAdjStation in adjBusStation.GetBusRouteList())
                        {
                            if (routeInAdjStation.Equals(label.BusName))
                            {
                                StationLabel sl = new StationLabel();
                                sl.StationName = adjBusStation.Name;
                                sl.BusName = routeInAdjStation;
                                sl.PreviousBus = label.BusName;
                                sl.NumberBusStop = label.NumberBusStop;
                                sl.DistanceFromStart = adjBusStation.DistanceFromStart;
                                adjBusStation.SetLabelList(sl);
                            }
                            else
                            {
                                if (label.NumberBusStop + 1 <= numBusStop)
                                {
                                    StationLabel sl = new StationLabel();
                                    sl.StationName = adjBusStation.Name;
                                    sl.BusName = routeInAdjStation;
                                    sl.PreviousBus = label.BusName;
                                    sl.NumberBusStop = label.NumberBusStop + 1;
                                    sl.DistanceFromStart = adjBusStation.DistanceFromStart;
                                    adjBusStation.SetLabelList(sl);
                                }
                            }
                        }
                    }
                }
            }
        }

        public bool IsNumBusStopExceedCondition(BusStation bs, int condition)
        {
            bool isExceed = true;

            foreach (StationLabel sl in bs.GetLabelList())
            {
                if (sl.NumberBusStop <= condition)
                {
                    isExceed = false;
                }
            }

            return isExceed;
        }

        /// <summary>
        /// Set previou[] of all node to start node and Set the dist[] of all node to MAX_VALUE except for start node and its adjacent nodes
        /// </summary>
        /// <param name="startBusStation"></param>
        private void GetBestPathAndStartingTraversalCost(BusStation startBusStation)
        {
            foreach (BusStation s in allBusStations)
            {
                s.PreviousBusStation = startBusStation;
                s.ResetLabelList();
                if (s.Name == startBusStation.Name)
                {
                    startBusStation.DistanceFromStart = 0;
                    foreach (AdjStation nearby in startBusStation.GetAdjStations())
                    {
                        nearby.BusStation.DistanceFromStart = nearby.EdgeWeight;
                        nearby.BusStation.IsAdjToStart = true;
                    }
                }
                else
                {
                    if (s.DistanceFromStart == -1 || !s.IsAdjToStart)
                    {
                        s.DistanceFromStart = ProjectConstants.MAX_VAUE;
                    }
                }
            }
            foreach (string route in startBusStation.GetBusRouteList())
            {
                StationLabel sl = new StationLabel();
                sl.StationName = startBusStation.Name;
                sl.BusName = route;
                sl.NumberBusStop = 1;
                sl.DistanceFromStart = startBusStation.DistanceFromStart;
                startBusStation.SetLabelList(sl);
            }
        }

        /// <summary>
        /// Set previou[] of all node to start node
        /// </summary>
        /// <param name="startBusStation"></param>
        private void GetStartingBestPath(BusStation startBusStation)
        {
            foreach (BusStation s in allBusStations)
            {
                s.PreviousBusStation = startBusStation;
            }
        }

        /// <summary>
        /// Set the dist[] of all node to MAX_VALUE except for start node and its adjacent nodes
        /// </summary>
        /// <param name="startBusStation"></param>
        private void GetStartingTraversalCost(BusStation startBusStation)
        {
            foreach (BusStation s in allBusStations)
            {
                if (s.Name == startBusStation.Name)
                {
                    startBusStation.DistanceFromStart = 0;
                    foreach (AdjStation nearby in startBusStation.GetAdjStations())
                    {
                        nearby.BusStation.DistanceFromStart = nearby.EdgeWeight;
                    }
                }
                else
                {
                    if (s.DistanceFromStart == -1)
                    {
                        s.DistanceFromStart = ProjectConstants.MAX_VAUE;
                    }
                }
                foreach (string route in s.GetBusRouteList())
                {
                    StationLabel sl = new StationLabel();
                    sl.StationName = s.Name;
                    sl.BusName = route;
                    sl.DistanceFromStart = s.DistanceFromStart;
                }
            }
        }        

        /// <summary>
        /// Get the shortest path
        /// </summary>
        /// <param name="start"></param>
        /// <param name="finish"></param>
        /// <returns></returns>
        private List<BusStation> GetMinimumPath(BusStation start, BusStation finish)
        {
            Stack<BusStation> path = new Stack<BusStation>();
            BusStation temp;
            do
            {
                temp = finish.PreviousBusStation;
                foreach (AdjStation adj in temp.GetAdjStations())
                {
                    if (adj.BusStation.Name == finish.Name && adj.IsByBus != 1)
                    {
                        temp.IsWalk = true;
                        finish.IsWalk = true;
                    }
                }
                path.Push(finish);
                finish = finish.PreviousBusStation;

            }
            while (finish != start);
            path.Push(start);
            List<BusStation> result = path.ToList();
            return result;
        }

        /// <summary>
        /// Distance between 2 stations
        /// </summary>
        /// <param name="lat1"></param>
        /// <param name="lon1"></param>
        /// <param name="lat2"></param>
        /// <param name="lon2"></param>
        /// <returns></returns>
        public static double DistanceBetweenPlaces(double lat1, double lon1, double lat2, double lon2)
        {
            double dlon = Radians(lon2 - lon1);
            double dlat = Radians(lat2 - lat1);

            double a = (Math.Sin(dlat / 2) * Math.Sin(dlat / 2)) + Math.Cos(Radians(lat1)) * Math.Cos(Radians(lat2)) * (Math.Sin(dlon / 2) * Math.Sin(dlon / 2));
            double angle = 2 * Math.Atan2(Math.Sqrt(a), Math.Sqrt(1 - a));
            return (angle * RADIO);//distance in miles
        }

        /// <summary>
        /// Convert to radians
        /// </summary>
        /// <param name="x"></param>
        /// <returns></returns>
        public static double Radians(double x)
        {
            return x * PIx / 180;
        }

        #endregion Methods
    }

    internal class CompareBusStationDijkstra : IComparer<BusStation>
    {
        #region IComparer Members
        public int Compare(BusStation x, BusStation y)
        {
            if (x.DistanceFromStart > y.DistanceFromStart)
                return 1;
            else if (x.DistanceFromStart < y.DistanceFromStart)
                return -1;
            return 0;

        }
        #endregion
    }
}
