using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;

namespace BusRouteHCM.Code
{
    public class ProcessBusStopNear
    {
        #region declare variable
        const double PIx = 3.141592653589793;
        const double RADIO = 6378.16;
        private string line;
        private double x1 = 0.0;
        private double y1 = 0.0;
        private int a = 0;
        private int countLimitBusStop = 0;
        private double startPoint = 0.0;
        private double endPoint = 0.0;
        private double totalDistanceCoord = 0.0;
        private double distanceM = 6;       // khoang cach trung binh tinh den cac tram xung quanh
        private string[] listName;
        private double[] listCoordX;
        private double[] listCoordY;

        private string resultEnd = null;

        List<BusStop> bus = new List<BusStop>();
        List<BusStop> busReturn = new List<BusStop>();
        List<CoordBusStop> minCoord = new List<CoordBusStop>();
        List<double> compareMin = new List<double>();
        List<double> compareMin_temp = new List<double>();
        List<BusStopReturn> busReturnResult = new List<BusStopReturn>();
        #endregion
        
        public string ProcessData(double start, double end)
        {
            StreamReader reader = new StreamReader(ProjectConstants.INPUT_FILE);
            try {
                line = reader.ReadLine();
                a = int.Parse(line);
                for (int i = 0; i < a;i++ )
                {
                    line = reader.ReadLine();
                    string[] arrSecond = line.Split(' ');
                    string stationName = arrSecond[0];
                    x1 = double.Parse(arrSecond[1]);
                    y1 = double.Parse(arrSecond[2]);
                    BusStop busstop1 = new BusStop(stationName,x1,y1);
                    //totalDistanceCoord = Math.Sqrt(Math.Pow((start - x1),2) + Math.Pow((end - y1),2));
                    totalDistanceCoord = DistanceBetweenPlaces(start, end, x1, y1);     // caculate distance (start,end) vs (x1,y1)
                    if(totalDistanceCoord < distanceM) {
                        CoordBusStop coordBusStop = new CoordBusStop(stationName,x1,y1,totalDistanceCoord);
                        countLimitBusStop++;
                        minCoord.Add(coordBusStop);
                    }
                    bus.Add(busstop1);
                }
                listName = new string[countLimitBusStop];
                listCoordX = new double[countLimitBusStop];
                listCoordY = new double[countLimitBusStop];

                for (int i = 0; i < countLimitBusStop;i++ )
                {
                    compareMin.Add(minCoord[i].getCoord());
                    //compareMin_temp.Add(minCoord[i].getCoord());
                    listName[i] = minCoord[i].getName();
                    listCoordX[i] = minCoord[i].getX1();
                    listCoordY[i] = minCoord[i].getY1();
                }
                for (int i = 0; i < compareMin.Count;i++ )
                {
                    compareMin_temp.Add(compareMin[i]);
                }
                //compareMin_temp = compareMin;
                compareMin.Sort();
                double minCoordName = compareMin[0];
                //double elementsMin1 = compareMin_temp.Find(items1 => items1 == minCoordName);
                int elementsMin = 0;
                bool flags_ = true;
                int variable_count = 0;
                while(flags_) {
                    if(compareMin_temp[variable_count] == minCoordName) {
                        elementsMin = variable_count;
                        flags_ = false;
                    }
                    variable_count++;
                }
                //int elementsMin = compareMin_temp.BinarySearch(minCoordName);
                //BusStop returnResult = new BusStop(listName[elementsMin],listCoordX[elementsMin],listCoordY[elementsMin]);
                //busReturn.Add(returnResult);
                resultEnd = listName[elementsMin] + "," + listCoordX[elementsMin] + "," + listCoordY[elementsMin];
                reader.Dispose();
            }
            catch(Exception e) {
                e.ToString();
            }
            return resultEnd;
        }
        #region ProcessNearBusStop
        public ProcessBusStopNear(double x,double y) {
            startPoint = x;
            endPoint = y;
        }
        public static double Radians(double x)
        {
            return x * PIx / 180;
        }
        public static double DistanceBetweenPlaces(double lat1,double lon1,double lat2,double lon2)
        {
            double dlon = Radians(lon2 - lon1);
            double dlat = Radians(lat2 - lat1);

            double a = (Math.Sin(dlat / 2) * Math.Sin(dlat / 2)) + Math.Cos(Radians(lat1)) * Math.Cos(Radians(lat2)) * (Math.Sin(dlon / 2) * Math.Sin(dlon / 2));
            double angle = 2 * Math.Atan2(Math.Sqrt(a), Math.Sqrt(1 - a));
            return (angle * RADIO) * 0.62137;//distance in miles
        }
    	#endregion

        #region DeclareConstructorClassProcessNearBusStop
        public ProcessBusStopNear() { 
        }
        #endregion
    }
}