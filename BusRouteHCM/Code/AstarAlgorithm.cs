using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics;

namespace BusRouteAlgorithm
{
    public enum HeuristicFormula
    {
        Manhattan           = 1,
        MaxDXDY             = 2,
        Euclidean           = 3,
        EuclideanNoSQR      = 4,
    }
    class AstarAlgorithm
    {
        #region Variables Declaration
        ReadData readData;
        List<BusStation> allBusStations;
        private PriorityQueueB<BusStation> mOpenSet = new PriorityQueueB<BusStation>(new CompareBusStation());
        private List<BusStation> mCloseSet = new List<BusStation>();
        private bool found = false;
        private HeuristicFormula mFormula = HeuristicFormula.Euclidean;
        private int mHEstimate = 2;
        #endregion Variables Declaration
      
        #region Methods
        public AstarAlgorithm()
        {
            allBusStations = new List<BusStation>();
            readData = new ReadData();
            var timeCounter = new Stopwatch();
            timeCounter.Start();
            readData.ExcuteReadData();
            allBusStations = readData.GetAllStations();
            timeCounter.Stop();
            long elapsedTime = timeCounter.ElapsedMilliseconds;
            System.Console.WriteLine("Astar");
            System.Console.WriteLine("Read data: " + elapsedTime);
        }

        public void RunAlgorithm()
        {
            string startStation = "";
            string destStation = "";
            List<BusStation> AstarPath = new List<BusStation>();

            System.Console.WriteLine("Running time in milisecond");
            var wholeTime = new Stopwatch();
            wholeTime.Start();

            #region Read input nodes
            System.Console.WriteLine("Start node: ");
            startStation = System.Console.ReadLine();
            System.Console.WriteLine("Dest node: ");
            destStation = System.Console.ReadLine();
            #endregion

            #region Main Algorithm
            var timeCounter = new Stopwatch();
            timeCounter.Start();
            BusStation start = readData.GetStationByName(startStation);
            BusStation dest = readData.GetStationByName(destStation);
            timeCounter.Restart();
            AstarPath = this.MainAlgorithm(start, dest);
            timeCounter.Stop();
            long elapsedTimeAlg = timeCounter.ElapsedMilliseconds;
            System.Console.WriteLine("Main Algorithm: " + elapsedTimeAlg);
            #endregion

            #region Output result
            if (AstarPath != null)
            {
                float sum = 0;
                System.Console.WriteLine("\nThe path:");
                for (int i = 0; i < AstarPath.Count; i++)
                {
                    foreach (var s in AstarPath.ElementAt(i).GetAdjStations())
                    {
                        if ((i + 1 < AstarPath.Count) && s.BusStation.Name == AstarPath.ElementAt(i + 1).Name)
                        {
                            sum += s.EdgeWeight;
                        }
                    }
                    System.Console.Write(AstarPath.ElementAt(i).Name + ' ');
                }
                System.Console.WriteLine("\nTotal distance is: " + sum);
            }
            else
            {
                System.Console.WriteLine("Cannot find a path");
            }
            #endregion

            wholeTime.Stop();
            long elapsedTimeWhole = wholeTime.ElapsedMilliseconds;
            System.Console.WriteLine("Whole program: " + elapsedTimeWhole + "\n\n");
        }

        public List<BusStation> MainAlgorithm(BusStation start, BusStation dest)
        {
            BusStation parentBusStation = start;

            mOpenSet.Push(parentBusStation);

            #region while Main loop
            while (mOpenSet.Count > 0)
            {
                parentBusStation = mOpenSet.Pop();

                //The examiningNode is destinationNode: end
                if (parentBusStation.XCoord == dest.XCoord && parentBusStation.YCoord == dest.YCoord)
                {
                    mCloseSet.Add(parentBusStation);
                    found = true;
                    break;
                }

                //Amount of nodes in Close set exceed search limit
                //if (mClose.Count > mSearchLimit)
                //{
                //    mStopped = true;
                //    return null;
                //}

                #region Calculate each successors
                //Lets calculate each successors
                foreach (var newStation in parentBusStation.GetAdjStations())
                {
                    //Calculate G-Value from examining Station to that parent station
                    double newG = (double)(Math.Sqrt(Math.Pow((newStation.BusStation.XCoord - parentBusStation.XCoord), 2) + Math.Pow((newStation.BusStation.YCoord - parentBusStation.YCoord), 2)));
                    if (newG == parentBusStation.GValue)
                    {
                        continue;
                    }

                    //newStation already in the mOpenSet
                    int foundInOpenIndex = -1;
                    for (int j = 0; j < mOpenSet.Count; j++)
                    {
                        if (mOpenSet[j].XCoord == newStation.BusStation.XCoord && mOpenSet[j].YCoord == newStation.BusStation.YCoord)
                        {
                            foundInOpenIndex = j;
                            break;
                        }
                    }                   
                    if (foundInOpenIndex != -1 && mOpenSet[foundInOpenIndex].GValue <= newG)
                        continue;

                    ////newStation already in the mCloseSet
                    int foundInCloseIndex = -1;
                    for (int j = 0; j < mCloseSet.Count; j++)
                    {
                        if (mCloseSet[j].XCoord == newStation.BusStation.XCoord && mCloseSet[j].YCoord == newStation.BusStation.YCoord)
                        {
                            foundInCloseIndex = j;
                            break;
                        }
                    }
                    if (foundInCloseIndex != -1 && mCloseSet[foundInCloseIndex].GValue <= newG)
                        continue;
                   
                    newStation.BusStation.PXCoord = parentBusStation.XCoord;
                    newStation.BusStation.PYCoord = parentBusStation.YCoord;
                    newStation.BusStation.GValue = newG;
                    newStation.BusStation.PreviousBusStation = parentBusStation;

                    switch (mFormula)
                    {
                        default:
                        case HeuristicFormula.Manhattan:
                            newStation.BusStation.HValue = mHEstimate * (Math.Abs(newStation.BusStation.XCoord - dest.XCoord) + Math.Abs(newStation.BusStation.YCoord - dest.YCoord));
                            break;
                        case HeuristicFormula.MaxDXDY:
                            newStation.BusStation.HValue = mHEstimate * (Math.Max(Math.Abs(newStation.BusStation.XCoord - dest.XCoord), Math.Abs(newStation.BusStation.YCoord - dest.YCoord)));
                            break;
                        case HeuristicFormula.Euclidean:
                            newStation.BusStation.HValue = (double)(mHEstimate * Math.Sqrt(Math.Pow((newStation.BusStation.XCoord - dest.XCoord), 2) + Math.Pow((newStation.BusStation.YCoord - dest.YCoord), 2)));
                            break;
                        case HeuristicFormula.EuclideanNoSQR:
                            newStation.BusStation.HValue = (double)(mHEstimate * (Math.Pow((newStation.BusStation.XCoord - dest.XCoord), 2) + Math.Pow((newStation.BusStation.YCoord - dest.YCoord), 2)));
                            break;
                    }
                    
                    newStation.BusStation.FValue = newStation.BusStation.GValue + newStation.BusStation.HValue;

                    mOpenSet.Push(newStation.BusStation);
                }
                #endregion Calculate each successors

                //Add the parent Node to Close set, the examined node to the Close set
                mCloseSet.Add(parentBusStation);
            }
            #endregion Main loop
            //System.Console.WriteLine(HighResolutionTime.GetTime());
            
            if (found)
            {
                //List<BusStation> result = new List<BusStation>();
                BusStation fNode = mCloseSet[mCloseSet.Count - 1];
                //result.Add(fNode);
                for (int i = mCloseSet.Count - 1; i > 0; i--)
                {
                    if (fNode.PXCoord == mCloseSet[i].XCoord && fNode.PYCoord == mCloseSet[i].YCoord || i == mCloseSet.Count - 1)
                    {
                        fNode = mCloseSet[i];
                        //result.Add(fNode);
                    }

                    else
                        mCloseSet.RemoveAt(i);
                    //fNode = fNode.PreviousBusStation;
                    //result.Add(fNode);
                }
                return mCloseSet;
                //return result;
            }
            return null;
        }
        #endregion Methods
    }
    internal class CompareBusStation : IComparer<BusStation>
    {
        #region IComparer Members
        public int Compare(BusStation x, BusStation y)
        {
            if (x.FValue > y.FValue)
                return 1;
            else if (x.FValue < y.FValue)
                return -1;
            return 0;
        }
        #endregion
    }
}
