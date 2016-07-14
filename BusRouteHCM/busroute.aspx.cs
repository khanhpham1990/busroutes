using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BusRouteAlgorithm;
using BusRouteHCM.Code;
using System.Web.Script.Serialization;
using System.IO;


namespace BusRouteHCM
{
    public partial class busroute : System.Web.UI.Page
    {
        private Dijkstra dijkstra;
        private string startStation = null;
        private string destStation = null;
        private int numBusStop = 0;
        private List<BusStation> resultPath;
        private List<BusStation> listBusNameResult;
        BusStation midBusStation;

        private string startPointRandom = null;
        private string endPointRandom = null;
        public ProcessBusStopNear returnNearObiectStop;
        private string resultEND = null;

        protected void Page_Load(object sender, EventArgs e)
        {
            
            if (!IsPostBack)
            {
                startPointRandom = Request.Params["x1"];
                endPointRandom = Request.Params["y1"];
                if (startPointRandom != null)
                {
                    returnNearObiectStop = new ProcessBusStopNear();
                    resultEND = returnNearObiectStop.ProcessData(double.Parse(startPointRandom), double.Parse(endPointRandom));
                    ConvertToJSONNearBusStop();
                }

                startStation = Request.Params["start"];
                destStation = Request.Params["dest"];
                if (Request.Params["dk"] != null && Request.Params["dk"] != "")
                {
                    numBusStop = Convert.ToInt32(Request.Params["dk"]);
                }

                if (startStation != null)
                {
                    dijkstra = new Dijkstra();
                    listBusNameResult = new List<BusStation>();

                    //Goi GT chinh tra ve ket qua
                    resultPath = dijkstra.RunAlgorithm(startStation, destStation, numBusStop);

                    //ConvertToJSONToTestRoute();

                    //Hien thi thong tin ve client
                    GetBusRoutesResult();
                }
            }
        }

        private void GetBusRoutesResult()
        {
            bool isWalking = true;
            //Case 0: Khong co duong di giua 2 diem
            if (resultPath.Count == 2 && resultPath.ElementAt(1).DistanceFromStart == ProjectConstants.MAX_VAUE)
            {
                Context.Response.Clear();
                Context.Response.Write("0");
                Context.Response.End();
            }

            //Case 1: Co 1 tuyen tu dau toi dich
            BusStation startBS = resultPath.First();
            BusStation destBS = resultPath.Last();
            foreach (string startSL in startBS.GetBusRouteList())
            {
                foreach (string destSL in destBS.GetBusRouteList())
                {
                    if (startSL == destSL)
                    {
                        startBS.BusActive = startSL;
                        destBS.BusActive = destSL;

                        listBusNameResult.Add(startBS);
                        listBusNameResult.Add(destBS);

                        ConvertToJSON(); //Response to browser
                    }
                }
            }

            //Case 2: Di 2 tuyen tu dau den dich
            midBusStation = new BusStation();
            foreach (string startSL in startBS.GetBusRouteList())
            {
                foreach (string destSL in destBS.GetBusRouteList())
                {
                    if (startSL != destSL)
                    {
                        if (RouteExist(startSL, destSL, ref midBusStation))
                        {
                            isWalking = false;
                            startBS.BusActive = startSL;
                            destBS.BusActive = destSL;

                            listBusNameResult.Add(startBS);
                            listBusNameResult.Add(midBusStation);
                            listBusNameResult.Add(destBS);

                            ConvertToJSON(); //Response to browser
                        }
                    }
                }
            }

            if (isWalking)
            {
                int index = 0;
                for (int i = 0; i < resultPath.Count; i++)
                {
                    if (resultPath.ElementAt(i).IsWalk)
                    {
                        index = i;
                        break;
                    }
                }
                GetOneBusRouteFromStartToDest(startBS, resultPath.ElementAt(index));
                GetOneBusRouteFromStartToDest(resultPath.ElementAt(index + 1), destBS);
                ConvertToJSON();
            }
        }

        private void GetOneBusRouteFromStartToDest(BusStation startBS, BusStation destBS)
        {
            foreach (string startSL in startBS.GetBusRouteList())
            {
                foreach (string destSL in destBS.GetBusRouteList())
                {
                    if (startSL == destSL)
                    {
                        startBS.BusActive = startSL;
                        destBS.BusActive = destSL;

                        listBusNameResult.Add(startBS);
                        listBusNameResult.Add(destBS);
                        return;
                    }
                }
            }
        }

        private bool RouteExist(string startBusName, string destBusName, ref BusStation midBusStation)
        {
            bool routeExist = false;
            
            for (int i = 1; i < resultPath.Count - 1; i++)
            {
                bool startRouteExist = false;
                bool destRrouteExist = false;
                BusStation bs = resultPath.ElementAt(i);
                foreach (string sl in bs.GetBusRouteList())
                {
                    if (sl == startBusName)
                    {
                        startRouteExist = true;
                    }
                    if (sl == destBusName)
                    {
                        destRrouteExist = true;
                        bs.BusActive = destBusName;
                    }
                }
                if (startRouteExist && destRrouteExist)
                {
                    midBusStation = bs;
                    routeExist = true;
                    break;
                }
            }

            return routeExist;
        }

        private List<Station> CreateStationList()
        {
            List<Station> listStations = new List<Station>();
            foreach (var bs in resultPath)
            {
                Station s = new Station();
                s.Name = bs.Name;
                s.X = bs.XCoord;
                s.Y = bs.YCoord;
                s.IsWalk = bs.IsWalk;
                listStations.Add(s);
            }
            return listStations;
        }

        private List<Station> CreateResultList()
        {
            List<Station> result = new List<Station>();
            foreach (var bs in listBusNameResult)
            {
                Station s = new Station();
                s.Name = bs.Name;
                s.BusName = bs.BusActive.Split('-')[0];
                s.X = bs.XCoord;
                s.Y = bs.YCoord;
                s.IsWalk = bs.IsWalk;
                result.Add(s);
            }
            return result;
        }

        /*This function contains coord first and coord end*/

        private List<Station> BusStopFirstEnd()
        {
            List<Station> coordBusStop = new List<Station>();
            //coordBusStop = resultNearBusStop;
            //coordBusStop.Add(resultNearBusStop);
            string []arr = new string[3];
            arr = resultEND.Split(',');
            Station a1 = new Station();
            a1.Name = arr[0];
            a1.X = double.Parse(arr[1]);
            a1.Y = double.Parse(arr[2]);
            coordBusStop.Add(a1);
            return coordBusStop;
        }

        private void ConvertToJSONNearBusStop()
        {
            JavaScriptSerializer jss12 = new JavaScriptSerializer();
            string myJsonString1 = jss12.Serialize(BusStopFirstEnd());      // object contains coord start and coord end when user click mouse on map
            string reponseText1 = "{\"path2\":" + myJsonString1 + "}";
            //File.WriteAllText("C:\\Users\\PhamKhanh\\Documents\\Visual Studio 2010\\Projects\\WebSite1\\BusRouteHCM\\path\\resultFirstChoose.json", reponseText1);
            Context.Response.Clear();
            Context.Response.Write(reponseText1);
            Context.Response.End();
        }

        private void ConvertToJSON()
        {
            JavaScriptSerializer jss1 = new JavaScriptSerializer();
            JavaScriptSerializer jss2 = new JavaScriptSerializer();
            string _myJSONstring1 = jss1.Serialize(CreateStationList());
            string _myJSONstring2 = jss2.Serialize(CreateResultList());

            string responseText1 = "{\"path\":" + _myJSONstring1 + "}";
            string responseText2 = "{\"result\":" + _myJSONstring2 + "}";

            string responseText = "[" + responseText1 + "," + responseText2 + "]";

            Context.Response.Clear();
            Context.Response.Write(responseText);
            Context.Response.End();
        }
        
        private void ConvertToJSONToTestRoute()
        {
            JavaScriptSerializer jss1 = new JavaScriptSerializer();
            JavaScriptSerializer jss2 = new JavaScriptSerializer();
            string _myJSONstring1 = jss1.Serialize(CreateStationList());
            string _myJSONstring2 = "";

            string responseText1 = "{\"path\":" + _myJSONstring1 + "}";
            string responseText2 = "{\"result\":" + _myJSONstring1 + "}";

            string responseText = "[" + responseText1 + "," + responseText2 + "]";

            Context.Response.Clear();
            Context.Response.Write(responseText);
            Context.Response.End();
        }
    }
}