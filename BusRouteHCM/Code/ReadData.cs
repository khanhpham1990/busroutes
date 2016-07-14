using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using BusRouteHCM.Code;

namespace BusRouteAlgorithm
{
    class ReadData
    {
        #region Variables Declerations
        private int _nStations;
        private List<BusStation> _allBusStations;
        #endregion

        #region Constructors
        public ReadData()
        {
            _allBusStations = new List<BusStation>();
        }
        #endregion

        #region Methods
        public List<BusStation> GetAllStations()
        {
            return _allBusStations; ;
        }

        public BusStation GetStationByName(string stationName)
        {
            BusStation temp = new BusStation();
            foreach (BusStation s in _allBusStations)
            {
                if (s.Name == stationName)
                {
                    temp = s;
                    break;
                }
            }
            return temp;
        }

        public void ExcuteReadData()
        {
            StreamReader sr = new StreamReader(ProjectConstants.INPUT_FILE);
            StreamReader srBus = new StreamReader(ProjectConstants.DS_TUYEN);
            try
            {

                //Get the number stations
                string line = sr.ReadLine(); //Read the first line
                _nStations = int.Parse(line);

                //Get nodes and their coordination               
                //Read through the input file with _nStations lines
                for (int i = 0; i < _nStations; i++)
                {
                    string lineStations = sr.ReadLine(); //Read the second line
                    string[] arrSecond = lineStations.Split(' ');
                    string stationName = arrSecond[0];

                    //Because input file does not have stationweigh, so a Station's stationweight is set to 100
                    //int stationWeight = int.Parse(arr[1]); //Station weight
                    //BusStation aBusStation = new BusStation(name, double.Parse(arr[2]), double.Parse(arr[3]), stationWeight);

                    int stationWeight = 100; //Station weight
                    BusStation aBusStation = new BusStation(stationName, double.Parse(arrSecond[1]), double.Parse(arrSecond[2]), stationWeight);

                    _allBusStations.Add(aBusStation); //Add a new created node to the list of all Node of the Map
                    //this.AddBusStationToList(aBusStation);
                    //wr.WriteLine("Add node " + i + ": " + arr[0]);
                }

                // Get the weight between 2 station   
                //wr.WriteLine(_nEdges);
                //System.Console.WriteLine(_nEdges);
                string lineEdges = string.Empty;
                while ((lineEdges = sr.ReadLine()) != null)
                {
                    string[] arrThird = lineEdges.Split(' ');
                    string startNode = arrThird[0];
                    string destNode = arrThird[1];
                    int edgeWeight = int.Parse(arrThird[2]);
                    int isByBus = int.Parse(arrThird[3]);
                    foreach (BusStation s in _allBusStations) //Get the node in the list to add its adjStation
                    {
                        if (s.Name == startNode)
                        {
                            foreach (BusStation destS in _allBusStations)
                            {
                                if (destS.Name == destNode)
                                {
                                    s.SetAdjStations(destS, edgeWeight, isByBus);
                                    break;
                                }
                            }
                            break;
                        }
                    }
                }

                //Begin read data from Bus route file
                string route = string.Empty;
                while ((route = srBus.ReadLine()) != null)
                {
                    string[] arr = route.Split(' ');
                    string routeName = arr[0];
                    for (int i = 1; i < arr.Length; i++)
                    {
                        string station = arr[i];
                        BusStation busStation = GetStationByName(station);
                        busStation.SetBusRouteGoThroughStation(routeName);
                    }
                }
            }
            catch (System.Exception e)
            {
                System.Console.WriteLine(e.ToString());
            }
            finally
            {
                sr.Dispose();
                srBus.Dispose();
            }
        }

        public void AddBusStationToList(BusStation bsInput)
        {
            foreach (BusStation bs in _allBusStations)
            {
                if (bs.Name == bsInput.Name) //The Node going to be added already in the adjacent list so ignore it
                    return;
            }
            _allBusStations.Add(bsInput);
        }

        #endregion
    }
}
