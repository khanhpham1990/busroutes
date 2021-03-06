﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="busroute.aspx.cs" Inherits="BusRouteHCM.busroute" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head id="Head1" runat="server">
    <title></title>
    <script type="text/javascript" src="http://maps.googleapis.com/maps/api/js?v=3.12&key=AIzaSyA5_pDLOrLDV5THdfNH8gzHU3nFklH7kZ4&sensor=false&language=vi&region=GB"></script>
    <script type="text/javascript" src="Scripts/Arrows.js"></script>
    <script type="text/javascript" src="Scripts/jquery-1.9.0.min.js"></script>
    <script type="text/javascript" src="Scripts/jquery.lazyload.min.js"></script>
    <script type="text/javascript" src="Scripts/jscoord-1.1.1.js"></script>
    <script type="text/javascript" src="Scripts/MyJScript.js"></script>
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
    
    <script type="text/javascript" src="Scripts/jquery.autocomplete.js"></script>
    <script type="text/javascript" src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
    <script type="text/javascript" src="Scripts/jquery-1.9.1.js"></script>
    <link rel="stylesheet" href="http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css" />
    <script type="text/javascript" src="http://code.jquery.com/jquery-1.9.1.js"></script>
    <meta http-equiv="content-type" content="text/html;charset=UTF-8" />

    <script type="text/javascript"  src="http://ajax.googleapis.com/ajax/libs/jquery/1.2.6/jquery.min.js"></script>
    <link   rel="stylesheet"        href="Styles/jquery-ui.css" type="text/css" />
    <script type="text/javascript"  src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.6/jquery-ui.min.js"></script>

    <script type="text/javascript">
        /*-----------------------------------------------------------------------------------------------------------------------------------------------------*/
        //Ajax
        google.maps.visualRefresh = true;
        var httpRequest;
        if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
            httpRequest = new XMLHttpRequest();
        }
        else {// code for IE6, IE5
            httpRequest = new ActiveXObject("Microsoft.XMLHTTP");
        }

        var directionDisplay;
        var directionsService = new google.maps.DirectionsService();

        var stepDisplay;
        var geocoder;
        var startMarker, endMarker;
        var hasStart, hasEnd;
        /*Ve mui ten cho tuyen bus*/
        var arrows = []; // luu arrow
        var setArrows;
        var markersArray = [];
        var markerPath1 = [];
        var pathArr = new Array(); //luu cac tuyen tren duong di

        function clearOverlays() {
            if (directionsDisplay)
                directionsDisplay.setMap(null);
            if (markersArray) {
                for (i in markersArray) {
                    markersArray[i].setMap(null);
                }
                markersArray = [];
            }
            setArrows.arrowheads = [];
            if (arrows) {
                for (i in arrows) {
                    arrows[i].setMap(null);
                }
                arrows = [];
            }
            for (var i in pathArr) {
                pathArr[i].setMap(null);
            }
            pathArr = [];
        }

        var routes = [];                 // mang chua cac routes
        var directionDistance = [];     // mang chua khoang cach giua 2 bus stop
        var map;
        var mypath;                     // ve duong dan dua tren cac bus stop
        var myPathDijkstra;             // ve duong dan dua tren path Dijkstra tim duoc
        var path1 = [];
        var markerList = [];            // chua danh sach cac marker
        var stepDisplay_;                // dat chế độ hiển thị thông tin trạm đầu-cuối
        var listAllBusStop = new Array();        // mang chua danh sach "têntram toado_x toado_y id","tentram1 tentram2 khoang_cach" cua tung tram luot di + luot ve
        var listPathRouteTemp = new Array();
        /*-----------------------------------------------------------------------------------------------------------------------------------------------------*/

        /* Xu ly cho phan node First to End */
        var batches = [];
        var itemsPerBatch = 10; // google API max - 1 start, 1 stop, and 8 waypoints (limit 8 waypoint for google map direction)
        var itemsCounter = 0;
        var wayptsExist = 0; //testArray.length;	

        var markerArray = [];
        var routesPath = [];
        var markerPath = [];
        var CoordList = [];     // mang chua danh sach cac toa do cua tuyen
        var returnStartPoint, returnEndPoint;
        var stringReturn = "";

        var busResultInfo;

        /*-----------------------------------------------------------------------------------------------------------------------------------------------------*/
        $(document).ready(function () {
            var useragent = navigator.userAgent;
            var map_canvas = document.getElementById("map_canvas");
            //var myCenter = new google.maps.LatLng(10.781034791471589, 106.65887832641602);

            if (useragent.indexOf('iPhone') != -1 || useragent.indexOf('Android') != -1) {
                map_canvas.style.width = '100%';
                map_canvas.style.height = '80%';
            } else {
                map_canvas.style.width = '80%';
                map_canvas.style.height = '600px';
            }
            directionsDisplay = new google.maps.DirectionsRenderer();
            var mapOptions = {
                zoom: 14,
                zoomControl: true,
                zoomControlOptions: {
                    style: google.maps.ZoomControlStyle.SMALL
                },
                center: new google.maps.LatLng(10.781034791471589, 106.65887832641602),
                mapTypeId: google.maps.MapTypeId.ROADMAP,
                mapTypeControl: true,       // hien thi ve tinh
                mapTypeControlOptions: {
                    position: google.maps.ControlPosition.TOP_RIGHT
                },
                panControl: false,

                zoomControl: true,
                zoomControlOptions: {
                    style: google.maps.ZoomControlStyle.SMALL,
                    position: google.maps.ControlPosition.TOP_RIGHT
                },
                scaleControl: true,
                scaleControlOptions: {
                    position: google.maps.ControlPosition.RIGHT_BOTTOM
                }
            };
            geocoder = new google.maps.Geocoder();
            map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions);
            directionsDisplay = new google.maps.DirectionsRenderer({
                suppressMarkers: true
            });
            stepDisplay_ = new google.maps.InfoWindow();

            document.getElementById('thongtintuyenxebus').innerHTML = "";
            directionsDisplay.setPanel(document.getElementById('thongtintuyenxebus'));
            directionsDisplay.setMap(map);
            google.maps.event.addListener(directionsDisplay, 'directions_changed', function () {
                computeTotalDistance(directionsDisplay.directions);
                computeTotalDuration(directionsDisplay.directions);
            });

            //tao mot context menu
            // Create the context menu element
            var contextMenu = $(document.createElement('ul')).attr('id', 'contextMenu');
            contextMenu.append(
			    '<li><a href="#zoomIn">Phóng to</a></li>' +
			    '<li><a href="#zoomOut">Thu nhỏ</a></li>' +
			    '<li><a href="#startPoint">Bắt đầu</a></li>' +
			    '<li><a href="#endPoint">Đích đến</a></li>'
		    );
            contextMenu.bind('contextmenu', function () { return false; });
            //Gan no len ban do
            $(map.getDiv()).append(contextMenu);
            var clickedLatLng;
            // Display and position the menu
            google.maps.event.addListener(map, 'rightclick', function (e) {
                // start buy hiding the context menu if its open
                contextMenu.hide();
                var mapDiv = $(map.getDiv()),
				x = e.pixel.x,
				y = e.pixel.y;
                // save the clicked location
                clickedLatLng = e.latLng;
                // adjust if clicked to close to the edge of the map
                if (x > mapDiv.width() - contextMenu.width())
                    x -= contextMenu.width();

                if (y > mapDiv.height() - contextMenu.height())
                    y -= contextMenu.height();
                // Set the location and fade in the context menu
                contextMenu.css({ top: y, left: x }).fadeIn(100);
            });
            contextMenu.find('a').click(function () {
                // fade out the menu
                contextMenu.fadeOut(75);
                var action = $(this).attr('href').substr(1);
                switch (action) {
                    case 'zoomIn':
                        map.setZoom(
								map.getZoom() + 1
							);
                        map.panTo(clickedLatLng);
                        break;
                    case 'zoomOut':
                        map.setZoom(
								map.getZoom() - 1
							);
                        map.panTo(clickedLatLng);
                        break;
                    case 'startPoint':
                        map.panTo(clickedLatLng);
                        addMarker(true, clickedLatLng.lat(), clickedLatLng.lng());
                        var latlng1 = new LatLng(startMarker.getPosition().lat(), startMarker.getPosition().lng());
                        var utm1 = latlng1.toUTMRef();
                        var X1 = utm1.easting;
                        var Y1 = utm1.northing;
                        var utmInter_1 = new UTMRef(X1, Y1, "N", 48);
                        var llInter_1 = utmInter_1.toLatLng();

                        //console.log(llInter_1.lat +" "+ llInter_1.lng);
                        findAddressWithCoord(llInter_1.lat, llInter_1.lng, startMarker, true);
                        //console.log(startMarker);
                        break;
                    case 'endPoint':
                        map.panTo(clickedLatLng);
                        addMarker(false, clickedLatLng.lat(), clickedLatLng.lng());
                        var latlng2 = new LatLng(endMarker.getPosition().lat(), endMarker.getPosition().lng());
                        var utm2 = latlng2.toUTMRef();
                        var X2 = utm2.easting;
                        var Y2 = utm2.northing;

                        var utmInter_2 = new UTMRef(X2, Y2, "N", 48);
                        var llInter_2 = utmInter_2.toLatLng();
                        findAddressWithCoord(llInter_2.lat, llInter_2.lng, endMarker, false);
                        //console.log(returnEndPoint);
                        break;
                }
                return false;
            });
        });

        /*Su dung ham ve mui ten arrows*/
        //setArrows.arrowheads = [];
        if (arrows) {
            for (i in arrows) {
                arrows[i].setMap(null);
            }
            // Now, clear the array itself.
            arrows = [];
        }
        
        /*Ham tim toa do tram gan nhat khi click point tren ban do*/
        function findAddressWithCoord(_X, _Y, marker, flags) {
            var start1 = (marker == startMarker) ? true : false;
            var url_1 = "busroute.aspx?x1=" + _X + "&y1=" + _Y;
            httpRequest.onreadystatechange = function () {
                if (httpRequest.readyState == 4 && httpRequest.status == 200) {
                    var busObject_1 = httpRequest.response;
                    var myObject_1 = eval("(" + busObject_1 + ")");
                    if (flags == true) {
                        StartPointNear(myObject_1.path2[0].Name, myObject_1.path2[0].X, myObject_1.path2[0].Y, _X, _Y);
                    }
                    else {
                        EndPointNear(myObject_1.path2[0].Name, myObject_1.path2[0].X, myObject_1.path2[0].Y, _X, _Y);
                    }
                }
            }
            httpRequest.open("GET", url_1, true);
            httpRequest.send();
        }


        function findAddressWithCoord1(_X, _Y, marker, flags) {
            var start1 = (marker == startMarker) ? true : false;
            var url_1 = "busroute.aspx?x1=" + _X + "&y1=" + _Y;
            httpRequest.onreadystatechange = function () {
                if (httpRequest.readyState == 4 && httpRequest.status == 200) {
                    var busObject_1 = httpRequest.response;
                    var myObject_1 = eval("(" + busObject_1 + ")");
                    StartPointNear(myObject_1.path2[0].Name, myObject_1.path2[0].X, myObject_1.path2[0].Y, _X, _Y);
                    alert("Bạn đã chọn điểm bắt đầu!");
                }
            }
            httpRequest.open("GET", url_1, true);
            httpRequest.send();
        }
        function findAddressWithCoord2(_X, _Y, marker, flags) {
            var start1 = (marker == startMarker) ? true : false;
            var url_1 = "busroute.aspx?x1=" + _X + "&y1=" + _Y;
            httpRequest.onreadystatechange = function () {
                if (httpRequest.readyState == 4 && httpRequest.status == 200) {
                    var busObject_1 = httpRequest.response;
                    var myObject_1 = eval("(" + busObject_1 + ")");
                    EndPointNear(myObject_1.path2[0].Name, myObject_1.path2[0].X, myObject_1.path2[0].Y, _X, _Y);
                    alert("Bạn đã chọn điểm đích đến!");
                }
            }
            httpRequest.open("GET", url_1, true);
            httpRequest.send();
        }

        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /* Hien thi ra phần tọa độ trạm gần nhất với điểm click chuột trên bản đồ */
        var toadoX_start = 0.0, toadoY_start = 0.0, toadoX_end = 0.0, toadoy_end = 0.0, nameStartCliclPoint, nameEndClickPoint;
        function StartPointNear(name_start, x_start, y_start, x_, y_) {
            toadoX_start = x_;
            toadoY_start = y_;
            console.log("Trạm START gần với tọa độ khi click chuột:" + name_start + " Tọa độ khi click chuột:" + "(" + toadoX_start + "," + toadoY_start + ")");
            nameStartCliclPoint = name_start;
            codeLatLngFrom(toadoX_start, toadoY_start);
        }
        function EndPointNear(name_end, x_end, y_end, x_, y_) {
            toadoX_end = x_;
            toadoy_end = y_;
            console.log("Trạm END gần với tọa độ khi click chuột:" + name_end + " Tọa độ khi click chuột:" + "(" + toadoX_end + "," + toadoy_end + ")");
            nameEndClickPoint = name_end;
            codeLatLngTo(toadoX_end, toadoy_end);
        }

        function codeLatLngFrom(latAddress, longAddress) {
            var lat = latAddress;
            var lng = longAddress; 
            var latlng = new google.maps.LatLng(lat, lng);
            geocoder.geocode({ 'latLng': latlng }, function (results, status) {
                if (status == google.maps.GeocoderStatus.OK) {
                    if (results[1]) {
                        map.setZoom(15);
                        document.getElementById('txtBoxFrom_autocomplete').value = results[1].formatted_address;
                        //document.getElementById('address').innerHTML = results[1].formatted_address;
                    } else {
                        alert('Không tìm thấy tọa độ địa chỉ trên google service');
                    }
                }
            });
        }

        function codeLatLngTo(latAddress, longAddress) {
            var lat = latAddress; //parseFloat(latlngStr[0]);
            var lng = longAddress; //parseFloat(latlngStr[1]);
            var latlng = new google.maps.LatLng(lat, lng);
            geocoder.geocode({ 'latLng': latlng }, function (results, status) {
                if (status == google.maps.GeocoderStatus.OK) {
                    if (results[1]) {
                        map.setZoom(15);
                        document.getElementById('txtBoxTo_autocomplete').value = results[1].formatted_address;
                        //document.getElementById('address').value = results[1].formatted_address;
                    } else {
                        alert('Không tìm thấy tọa độ địa chỉ trên google service');
                    }
                }
            });
        }
        /*--------------------------------------------------------------------------------------------------------------------*/



        /*Cap nhat lai va xoa cac marker tram bus tren ban do*/
        function removeTheMarkers() {
            while (markerList[0]) {
                markerList.pop().setMap(null);
            }
        }
        function removeTheMarkersPath() {
            while (markerPath[0]) {
                markerPath.pop().setMap(null);
            }
        }
        function placeMarker(position, map) {
            var marker = new google.maps.Marker({ position: position, map: map });
        }

        /*Xu ly ajax thong tin tuyen xe bus*/
        function showRouteOfBus() {
            var url;
            removeTheMarkers();
            removeTheMarkersPath();
            var lstTuyen = document.getElementById("option_list");
            var chckLuotDi = document.getElementById("chckLuotDi");
            if ($('#chckLuotDi').is(":checked")) {
                chckLuotDi = "on";      // chon ve tuyen luot di
                url = "http://localhost:7452/data/GetTuyenBus/true/GetTuyenBus_true" + lstTuyen.value + ".json";
            } else {
                chckLuotDi = "off";      // chon ve tuyen luot ve
                url = "http://localhost:7452/data/GetTuyenBus/false/GetTuyenBus_false" + lstTuyen.value + ".json";
            }

            httpRequest.onreadystatechange = function () {
                if (httpRequest.readyState == 4 && httpRequest.status == 200) {
                    var carObject = eval('(' + httpRequest.responseText + ')');
                    var myObject = "jSonTuyen=" + httpRequest.responseText;
                    eval(myObject);
                    var j = 0;
                    document.getElementById("thongtintuyenxebus").innerHTML = "";
                    for (var i = 0; i < jSonTuyen.TABLE[0].ROW.length; i++) {
                        var utmInter = new UTMRef(jSonTuyen.TABLE[0].ROW[i].COL[3].DATA, jSonTuyen.TABLE[0].ROW[i].COL[4].DATA, "N", 48);
                        var llInter = utmInter.toLatLng();
                        var latLngInter = new google.maps.LatLng(llInter.lat, llInter.lng);
                        routes.push({ Lat: llInter.lat, Lng: llInter.lng });        // dua toa do kinh-vi do vao array routes dung co che queue

                        document.getElementById('thongtintuyenxebus').innerHTML += "<div class=\"report\" onclick=\"moveTo(" + llInter.lat + ", " + llInter.lng + ",'" + jSonTuyen.TABLE[0].ROW[i].COL[0].DATA + ' ' + jSonTuyen.TABLE[0].ROW[i].COL[1].DATA + ' Quận ' + jSonTuyen.TABLE[0].ROW[i].COL[2].DATA + "');\">" + "[" + i + "][" + jSonTuyen.TABLE[0].ROW[i].COL[7].DATA + '] ' + jSonTuyen.TABLE[0].ROW[i].COL[0].DATA + ' ' + jSonTuyen.TABLE[0].ROW[i].COL[1].DATA + ' Quận ' + jSonTuyen.TABLE[0].ROW[i].COL[2].DATA + '</div>';

                        // Ve len ban do danh dau marker
                        var marker = new google.maps.Marker({
                            position: latLngInter,
                            title: jSonTuyen.TABLE[0].ROW[i].COL[0].DATA + ' ' + jSonTuyen.TABLE[0].ROW[i].COL[1].DATA + ' Quận ' + jSonTuyen.TABLE[0].ROW[i].COL[2].DATA,
                            map: map,
                            //thay icon của markers
                            icon: "../images/bus.png"
                        });
                        markerList.push(marker);
                    }
                    map.panTo(markerList[0].getPosition());
                    getRoute(lstTuyen.value, chckLuotDi);
                }
            }
            httpRequest.open("GET", url, true);
            httpRequest.send();
        }
        /*Ket thuc xu ly thong tin tuyen xe bus*/


        /*Ham ve route dua vao thong tin toa do google map*/
        function getRoute(tuyenID, chckLuotDi) {
            if (mypath != null) {
                mypath.setMap(null);
            }
            mypath = new google.maps.Polyline({
                map: map,
                strokeWeight: 7,
                strokeOpacity: 0.8,
                strokeColor: "#00FF00"
            });
            var url = "";
            if (chckLuotDi == "on") {
                url = "http://localhost:7452/data/GetFullRoute/true/GetFullRoute_true" + tuyenID + ".txt";
            }
            else {
                url = "http://localhost:7452/data/GetFullRoute/false/GetFullRoute_false" + tuyenID + ".txt";
            }

            httpRequest.onreadystatechange = function () {
                if (httpRequest.readyState == 4 && httpRequest.status == 200) {
                    var coors = httpRequest.responseText.split(" ");        // chua thong tin tap hop cac toa do Google cua cac tram
                    for (var i = 0; i < coors.length; i++) {
                        if (coors[i] != ' ') {
                            path = mypath.getPath();
                            latlng = coors[i].split(",");
                            path.push(new google.maps.LatLng(latlng[1], latlng[0]));
                        }
                    }
                }
            }
            httpRequest.open("GET", url, true);
            httpRequest.send();
        }


        /*Xu ly thong tin hien ra khi click vao tung toa do tram*/
        function moveTo(lat, lng, title) {
            map.panTo(new google.maps.LatLng(lat, lng));
            updateMarkerPosition(new google.maps.LatLng(lat, lng));
            updateMarkerAddress(title);
        }
        function updateMarkerPosition(latLng) { // hien thi thong tin toa do google map ten con duong

            //document.getElementById('info').innerHTML = latLng.lat() + "," + latLng.lng();
        }
        function updateMarkerAddress(str) {     // hien thi thong tin ve con duong
            document.getElementById('address').innerHTML = str;
        }

        $.getJSON('data/Input/input_json.json',
                  function (data) {
                      for (var i = 0; i < data.BusStop.length; i++) {
                          var string1 = data.BusStop[i].id;
                          var a = string1.split(" ");
                          //$("#txtBoxFrom").append('<option value="' + a[0] + '">' + '[' + a[0] + ']' + '</option>');
                          //$("#txtBoxTo").append('<option value="' + a[0] + '">' + '[' + a[0] + ']' + '</option>');
                      }
                  });
                      
                  
        function distance(lat1, lon1, lat2, lon2, unit) {
            var radlat1 = Math.PI * lat1 / 180;
            var radlat2 = Math.PI * lat2 / 180;
            var radlon1 = Math.PI * lon1 / 180;
            var radlon2 = Math.PI * lon2 / 180;
            var theta = lon1 - lon2;
            var radtheta = Math.PI * theta / 180;
            var dist = Math.sin(radlat1) * Math.sin(radlat2) + Math.cos(radlat1) * Math.cos(radlat2) * Math.cos(radtheta);
            dist = Math.acos(dist);
            dist = dist * 180 / Math.PI;
            dist = dist * 60 * 1.1515;
            if (unit == "K") { dist = dist * 1.609344; }
            if (unit == "N") { dist = dist * 0.8684; }
            return dist;
        }
        var pathPaint;
        var subBatch = [];

        /* Function process read data from file input data example when click button browser in menubar*/
        function readfile(f) {
            var reader = new FileReader();  // Create a FileReader object
            reader.readAsText(f);           // Read the file
            reader.onload = function () {    // Define an event handler
                var text = reader.result;   // This is the file contents
                var object1 = text.split(" ");

                var coordinateLat = object1[0];
                var coordinateLng = object1[1];

                var coordinateLat1 = object1[2];
                var coordinateLng1 = object1[3];
                console.log(coordinateLat + "-" + coordinateLng);
                console.log(coordinateLat1 + "-" + coordinateLng1);


                //findAddressWithCoord(coordinateLat1, coordinateLng1, endMarker, false);
                findAddressWithCoord1(coordinateLat, coordinateLng, startMarker, true);
            }
            reader.onerror = function (e) {
                console.log("Error", e);
            };
        }
        function readfile1(f) {
            var reader = new FileReader();  // Create a FileReader object
            reader.readAsText(f);           // Read the file
            reader.onload = function () {    // Define an event handler
                var text = reader.result;   // This is the file contents
                var object1 = text.split(" ");

                var coordinateLat = object1[0];
                var coordinateLng = object1[1];

                var coordinateLat1 = object1[2];
                var coordinateLng1 = object1[3];
                console.log(coordinateLat1 + "-" + coordinateLng1);
                
                //findAddressWithCoord(coordinateLat, coordinateLng, startMarker, true);
                findAddressWithCoord2(coordinateLat1, coordinateLng1, endMarker, false);
                
            }
            reader.onerror = function (e) {
                console.log("Error", e);
            };
        }


        /*Hàm chuyển từ dữ liệu mã trạm sang địa chỉ trạm tương ứng trên bản đồ*/
        function codeLatLngBusNameToAddressName(latAddress, longAddress) {
            var lat = latAddress;
            var lng = longAddress;
            var latlng = new google.maps.LatLng(lat, lng);
            geocoder.geocode({ 'latLng': latlng }, function (results, status) {
                if (status == google.maps.GeocoderStatus.OK) {
                    if (results[1]) {
                        document.getElementById('A1BK').value = results[1].formatted_address;
                    }
                }
            });
        }

        /*Xu ly du lieu nhap vao input - output*/
        function showRouteOfBus1() {
            removeTheMarkers();
            removeTheMarkersPath();
            while (CoordList[0]) {
                CoordList.pop();
            }
            while (pathArr[0]) {
                pathArr.pop();
            }
            //console.log(batches);

            if (mypath != null) {
                mypath.setMap(null);
            }
            if (myPathDijkstra != null) {
                myPathDijkstra.setMap(null);
            }


            /*Process choose data example read from file input*/
            var chckLuotDi = document.getElementById("chckLuotDi");
            if ($('#chckLuotDi').is(":checked")) {
                chckLuotDi = "on";      // chon su dung du lieu mau
            } else {
                chckLuotDi = "off";      // chon khong su dung du lieu mau
            }


            var valueIsTo;
            var valueIsFrom;
            if (chckLuotDi == "on") {
                valueIsFrom = nameStartCliclPoint;
                valueIsTo = nameEndClickPoint;
            }
            if (chckLuotDi == "off") {
                valueIsFrom = nameStartCliclPoint;
                valueIsTo = nameEndClickPoint;
            }

            var dk = document.getElementById("dieukien").value;
            if (isNaN(dk)) {
                alert("Số bus đi tối đa phải là một con số.");
                return;
            }else if (dk == null || dk == "") {
                alert("Hãy nhập số lần tối đa bạn muốn chuyển tuyến!");
                return;
            } else if (dk <= 0) {
                alert("Số bus đi tối đa phải lớn hơn 0");
                return;
            }

            var url1 = "busroute.aspx?start=" + valueIsFrom + "&dest=" + valueIsTo + "&dk=" + dk;
            var busObject = httpRequest.response;

            /*test demo*/
            pathArr.push(new google.maps.LatLng(toadoX_start, toadoY_start));
            /*end test demo*/

            httpRequest.onreadystatechange = function () {
                if (httpRequest.readyState == 4 && httpRequest.status == 200) {
                    var busObject = httpRequest.response;
                    if (busObject == "0") {
                        alert("Không thể tìm thấy đường đi. Hãy thử lại!");
                        return;
                    }
                    var responseData = eval("(" + busObject + ")");
                    var myObject = responseData[0];
                    var myResult = responseData[1];

                    if (myResult.result.length == 2) {
                        var tramDau = myResult.result[0].Name;
                        var tramDich = myResult.result[1].Name;
                        var busName = myResult.result[0].BusName;

                        var tramDau1 = [];
                        var toadoDauX1 = [];
                        var toadoDauY1 = [];
                        var diachiDau1 = [];
                        var latlng;
                        /*Ham chyển đổi từ mã trạm sang địa chỉ*/
                        for (var i = 0; i < myResult.result.length; i++) {
                            tramDau1[i] = myResult.result[0].Name;
                            toadoDauX1[i] = myResult.result[0].X;
                            toadoDauY1[i] = myResult.result[0].Y;
                        }

                        var latlong_ = new google.maps.LatLng(myResult.result[0].X, myResult.result[0].Y);
                        var khanh_s = "Từ trạm " + tramDau + " đi tuyến " + busName + " tới đích";
                        busResultInfo = "Từ trạm " + tramDau + " đi tuyến " + busName + " tới đích";
                        var marker = new google.maps.Marker({
                            position: latlong_,
                            title: busName,
                            map: map,
                            icon: "./images/bus3.png"
                        });
                        markerPath1.push(marker);
                        map.panTo(markerPath1[0].getPosition());
                        document.getElementById('dialog').innerHTML = khanh_s;
                        //c11();
                    } else if (myResult.result.length == 3) {
                        var tramDau = myResult.result[0].Name;
                        var tramGiua = myResult.result[1].Name;
                        var tramDich = myResult.result[2].Name;
                        var busName1 = myResult.result[0].BusName;
                        var busName2 = myResult.result[2].BusName;


                        var consoleLength = myResult.result.length;
                        var latlong_ = [];
                        var busName_ = [];
                        var busTuyen_ = [];
                        var titleForBus_ = [];
                        for (var i = 0; i < consoleLength - 1; i++) {
                            latlong_[i] = new google.maps.LatLng(myResult.result[i].X, myResult.result[i].Y);
                            busName_[i] = myResult.result[i].Name;
                            busTuyen_[i] = myResult.result[i].BusName;
                            titleForBus_[i] = "Từ trạm " + busName_[i] + " bắt tuyến xe buýt số " + busTuyen_[i];
                            var marker = new google.maps.Marker({
                                position: latlong_[i],
                                title: titleForBus_[i],
                                map: map,
                                icon: "./images/bus1.png"
                            });
                            markerPath1.push(marker);
                        }
                        for (var i = 0; i < consoleLength - 1; i++) {
                            map.panTo(markerPath1[i].getPosition());
                        }
                        var khanh_s = "Từ trạm " + tramDau + " đi tuyến " + busName1 + " tới trạm " + tramGiua + " đi tiếp tuyến " + busName2 + " tới đích";
                        busResultInfo = "Từ trạm " + tramDau + " đi tuyến " + busName1 + " tới trạm " + tramGiua + " đi tiếp tuyến " + busName2 + " tới đích";
                        document.getElementById('dialog').innerHTML = khanh_s;
                        //c11();
                    } else {
                        var tramDau1 = myResult.result[0].Name;
                        var tramDich1 = myResult.result[1].Name;
                        var busName1 = myResult.result[0].BusName;
                        var latlong_ = new google.maps.LatLng(myResult.result[0].X, myResult.result[0].Y);
                        var khanh_s1 = "Từ trạm " + tramDau1 + " đi tuyến " + busName1 + " tới trạm " + tramDich1;

                        /*
                        var marker1 = new google.maps.Marker({
                        position: latlong_,
                        title: tramDau1,
                        map: map,
                        icon: "./images/bus1.png"
                        });
                        markerPath1.push(marker1);
                        map.panTo(markerPath1[0].getPosition());
                        //c11();
                        */

                        var length1 = myResult.result.length;
                        var latlong_s = [];
                        var tramDau1s = [];
                        var busName1s = [];
                        var specialWalk = [];
                        var specialTitle = null;
                        var normalTitle = null;
                        for (var i = 0; i < length1; i++) {
                            latlong_s[i] = new google.maps.LatLng(myResult.result[i].X, myResult.result[i].Y);
                            tramDau1s[i] = myResult.result[i].Name;
                            busName1s[i] = myResult.result[i].BusName;
                            specialWalk[i] = myResult.result[i].IsWalk;

                            /*
                            normalTitle = "Từ trạm " + tramDau1s[i] + " đón tuyến " + busName1s[i];
                            if (specialWalk[i] == true && i < (length1 - 1)) {
                            specialTitle = "Từ trạm " + tramDau1s[i] + " đi bộ đến trạm " + tramDau1s[i + 1];
                            normalTitle = specialTitle;
                            }
                            */
                            var marker1 = new google.maps.Marker({
                                position: latlong_s[i],
                                title: "Trạm buýt " + tramDau1s[i],
                                map: map,
                                icon: "./images/bus1.png"
                            });
                            markerPath1.push(marker1);
                            map.panTo(markerPath1[0].getPosition());
                        }

                        if (myResult.result.length > 3) {
                            var tramDau2 = myResult.result[2].Name;
                            var tramDich2 = myResult.result[3].Name;
                            var busName2 = myResult.result[2].BusName;
                            var latlong_ = new google.maps.LatLng(myResult.result[2].X, myResult.result[2].Y);
                            var latlong__ = new google.maps.LatLng(myResult.result[1].X, myResult.result[1].Y);
                            var khoangcachdibo = google.maps.geometry.spherical.computeDistanceBetween(latlong__, latlong_);
                            console.log(khoangcachdibo);
                            var khanh_s2 = " đi bộ tới trạm " + tramDau2 + " [với khoảng cách <b> "+ Math.round(khoangcachdibo) + " mét</b>]" +" đi tiếp tuyến " + busName2 + " tới đích";
                        }
                        else {
                            var tramDau2 = myResult.result[1].Name;
                            var tramDich2 = myResult.result[3].Name;
                            var busName2 = myResult.result[2].BusName;
                            var latlong_ = new google.maps.LatLng(myResult.result[2].X, myResult.result[2].Y);

                            var khanh_s2 = " từ trạm " + tramDau2 + " đi bộ đến đích";
                        }


                        var title1 = "Từ trạm " + tramDau2 + " bắt tuyến " + busName2;

                        /*
                        var marker2 = new google.maps.Marker({
                        position: latlong_,
                        title: title1,
                        map: map,
                        icon: "./images/bus1.png"
                        });
                        markerPath1.push(marker2);
                        map.panTo(markerPath1[0].getPosition());
                        */
                        busResultInfo = khanh_s1 + khanh_s2;
                        document.getElementById('dialog').innerHTML = khanh_s1 + khanh_s2;
                        //c11();
                    }

                    for (var i = 0; i < myObject.path.length; i++) {
                        routesPath.push({ Lat: myObject.path[i].X, Lng: myObject.path[i].Y });        // dua toa do kinh-vi do vao array routes dung co che queue
                        var latLngInter = new google.maps.LatLng(myObject.path[i].X, myObject.path[i].Y);
                        CoordList.push(latLngInter);
                        pathArr.push(latLngInter);

                        var toadoX = myObject.path[i].X;
                        var toadoY = myObject.path[i].Y;
                        listPathRouteTemp.push(toadoX);
                        listPathRouteTemp.push(toadoY);
                    }

                    /*start test demo*/
                    pathArr.push(new google.maps.LatLng(toadoX_end, toadoy_end));
                    /*end test demo*/

                    caculateDrawRoute(pathArr);
                }
            }
            httpRequest.open("GET", url1, true);
            httpRequest.send();
        }
        
        
        // Ham ve duong noi giua 2 tram bat ky
        function caculateDrawRoute(pathArr) {
            wayptsExist = pathArr.length;
            batches = [];
            while (wayptsExist) {
                subBatch = [];
                var subitemsCounter = 0;
                for (var j = itemsCounter; j < pathArr.length; j++) {
                    subitemsCounter++;
                    subBatch.push({
                        location: new window.google.maps.LatLng(pathArr[j].jb, pathArr[j].kb),
                        stopover: true
                    });
                    if (subitemsCounter == itemsPerBatch)
                        break;
                }
                itemsCounter += subitemsCounter;
                batches.push(subBatch);
                wayptsExist = itemsCounter < pathArr.length;
                itemsCounter--;
            }
            calcRoute(batches, directionsService, directionsDisplay);
        }
        var end = "", start = "";
        function calcRoute(batches, directionsService, directionsDisplay) {
            for (i = 0; i < markerArray.length; i++) {
                markerArray[i].setMap(null);
            }
            markerArray = [];

            var combinedResults;
            var unsortedResults = [{}]; // to hold the counter and the results themselves as they come back, to later sort
            var directionsResultsReturned = 0;

            for (var k = 0; k < batches.length; k++) {
                var lastIndex = batches[k].length - 1;
                start = batches[k][0].location;
                end = batches[k][lastIndex].location;
                var waypts = [];
                waypts = batches[k];
                waypts.splice(0, 1);
                waypts.splice(waypts.length - 1, 1);

                var request = {
                    origin: start,
                    destination: end,
                    waypoints: waypts,
                    travelMode: window.google.maps.TravelMode.WALKING
                };
                (function (kk) {
                    directionsService.route(request, function (result, status) {
                        if (status == window.google.maps.DirectionsStatus.OK) {
                            fx(result.routes[0]);
                            var unsortedResult = {
                                order: kk,
                                result: result
                            };
                            
                            unsortedResults.push(unsortedResult);
                            directionsResultsReturned++;
                            if (directionsResultsReturned == batches.length) {
                                unsortedResults.sort(function (a, b) {
                                    return parseFloat(a.order) - parseFloat(b.order);
                                });
                                var count = 0;
                                for (var key in unsortedResults) {
                                    if (unsortedResults[key].result != null) {
                                        if (unsortedResults.hasOwnProperty(key)) {
                                            if (count == 0)
                                                combinedResults = unsortedResults[key].result;
                                            else {
                                                combinedResults.routes[0].legs = combinedResults.routes[0].legs.concat(unsortedResults[key].result.routes[0].legs);
                                                combinedResults.routes[0].overview_path = combinedResults.routes[0].overview_path.concat(unsortedResults[key].result.routes[0].overview_path);
                                            }
                                            count++;
                                        }
                                    }
                                }
                                directionsDisplay.setDirections(combinedResults);
                                showSteps(combinedResults);
                            }
                        }
                    });
                })(k);
            }
        }

        /*---------------------------------------------------------------------------------------------------------------------------*/
        function showSteps(directionResult) {
            var myRoute = directionResult.routes[0].legs[0];
            var myRoutes = directionResult.routes[0].legs;
            var countLength = myRoutes.length;

            console.log(directionResult);
            
            for (var i = 0; i < countLength; i++) {
                var icon = "https://chart.googleapis.com/chart?chst=d_map_pin_letter&chld=" + i + "|FF0000|000000";
                if (i == 0) {
                    icon = "https://chart.googleapis.com/chart?chst=d_map_xpin_icon_withshadow&chld=pin_sright|home|52B552";
                }
                var marker = new google.maps.Marker({
                    position: myRoutes[i].start_location,
                    title: myRoutes[i].start_address,
                    map: map,
                    icon: icon
                });

                attachInstructionText(marker, myRoutes.start_address);
                markerArray.push(marker);
            }
            /*--------------------------------------------------------------------------*/
            var marker1 = new google.maps.Marker({
                position: myRoutes[countLength - 1].end_location,
                title: myRoutes[countLength - 1].end_address,
                map: map,
                icon: "https://chart.googleapis.com/chart?chst=d_map_pin_icon&chld=flag|ADDE63"
            });
            var markerPath2 = [];
            markerPath2.push(marker);
            map.panTo(markerPath2[0].getPosition());
            /*--------------------------------------------------------------------------*/

            //markerArray.push(marker);

            google.maps.event.trigger(markerArray[0], "click");
        }

        function attachInstructionText(marker, text) {
            google.maps.event.addListener(marker, 'click', function () {
                stepDisplay_.setContent(text);
                stepDisplay_.open(map, marker);
            });
        }
        /*---------------------------------------------------------------------------------------------------------------------------*/

        var vantocdibo = 4*1000/3600; // 5m/s

        function computeTotalDistance(result) {
            var total = 0;
            var total_start = 0;    //khoang cach đi từ nút đầu đến trạm gần nhất
            var total_end = 0;      // khoảng cách đi từ trạm cuối cùng về điểm đích
            

            var myroute = result.routes[0];
            total_start = myroute.legs[0].distance.value / 1000;
            total_end = myroute.legs[myroute.legs.length - 1].distance.value/1000;
            for (var i = 1; i < myroute.legs.length-1; i++) {
                total += myroute.legs[i].distance.value;
            }
            total = total / 1000.
            document.getElementById('TotalDistance').innerHTML = total + ' km';
            document.getElementById('totalDistance_start').innerHTML = total_start + ' km';
            document.getElementById('totalDistance_end').innerHTML = total_end + ' km';
        }

        function computeTotalDuration(result) {
            var total = 0;
            var total_time_start = 0;
            var total_time_end = 0;


            var myroute = result.routes[0];
            total_time_start = myroute.legs[0].duration.value;
            total_time_end = myroute.legs[myroute.legs.length - 1].duration.value;

            var total_distance_start = myroute.legs[0].distance.value;
            var total_distance_end = myroute.legs[myroute.legs.length - 1].distance.value;

            //console.log(total_distance_start + "," + total_distance_end);

            for (var i = 1; i < myroute.legs.length-1; i++) {
                total += myroute.legs[i].duration.value;
            }
            total = total / 60.
            var laydiachiTinhStart = [];
            var laydiachiTinhStart1 = [];
            laydiachiTinhStart = myroute.legs[0].start_address.split(',');
            laydiachiTinhStart1 = myroute.legs[0].end_address.split(',');

            var laydiachiTinhEnd = [];
            var laydiachiTinhEnd1 = [];
            laydiachiTinhEnd = myroute.legs[myroute.legs.length - 1].start_address.split(',');
            laydiachiTinhEnd1 = myroute.legs[myroute.legs.length - 1].end_address.split(',');
            
            document.getElementById('TotalDuration').innerHTML = Math.round(total) + ' phút';
            var khanh_kstart = "Từ địa chỉ: " + "<b>" + laydiachiTinhStart[0] + "</b>" + " đi bộ tới địa chỉ trạm "
            + "<b>" + laydiachiTinhStart1[0] + "</b>" + " với khoảng cách là: " + "<b>" + total_distance_start + "</b>" + " mét, với thời gian: " + "<b>" + Math.round(total_distance_start / vantocdibo) + "</b>" + ' giây' + " (với vận tốc 4km/h)";
            var khanh_kend = "Từ địa chỉ: " + "<b>" + laydiachiTinhEnd[0] + "</b>" + " đi bộ về đích " + "<b>" + laydiachiTinhEnd1[0] + "</b>" + " với khoảng cách là: " + "<b>" + total_distance_end + "</b>" + " mét, với thời gian: " + "<b>" + Math.round(total_distance_end / vantocdibo) + "</b>" + ' giây' + " (với vận tốc 4km/h)";

            document.getElementById('dialog1').innerHTML = khanh_kstart + "<br/><br/>" + busResultInfo + "<br/><br/>" + khanh_kend;
            c12();
        }

        function fx(o) {
            if (o && o.legs) {
                for (l = 0; l < o.legs.length; ++l) {
                    var leg = o.legs[l];
                    for (var s = 0; s < leg.steps.length; ++s) {
                        var step = leg.steps[s],
					  a = (step.lat_lngs.length) ? step.lat_lngs[0] : step.start_point,
					  z = (step.lat_lngs.length) ? step.lat_lngs[1] : step.end_point,
					  dir = ((Math.atan2(z.lng() - a.lng(), z.lat() - a.lat()) * 180) / Math.PI) + 360,
					  ico = ((dir - (dir % 3)) % 120);
                        new google.maps.Marker({
                            position: a,
                            icon: new google.maps.MarkerImage('http://maps.google.com/mapfiles/dir_' + ico + '.png',
													new google.maps.Size(24, 24),
													new google.maps.Point(0, 0),
													new google.maps.Point(12, 12)
												   ),
                            map: map,
                            title: Math.round((dir > 360) ? dir - 360 : dir) + '°'
                        });

                    }
                }
            }
        }

        /*------------------------------------------------------------------------------------------------------*/
        function codeLatLngToShowDialogue(latAddress, longAddress) {
            var lat = latAddress; 
            var lng = longAddress;
            var latlng = new google.maps.LatLng(lat, lng);
            geocoder.geocode({ 'latLng': latlng }, function (results, status) {
                if (status == google.maps.GeocoderStatus.OK) {
                    if (results[1]) {
                        document.getElementById('txtBoxTo_autocomplete').value = results[1].formatted_address;
                    }
                }
            });
        }

        function c12() {
            $(document).ready(function () {
                $('#dialog1').dialog({
                    dialogClass: "loadingScreenWindow1",
                    autoOpen: true,
                    draggable: true,
                    resizable: true
                });
            });
        }
        /*------------------------------------------------------------------------------------------------------*/

        /* Process data button browser */
        $(function () {
            $(".inputWrapper").mousedown(function () {
                var button = $(this);
                button.addClass('clicked');
                setTimeout(function () {
                    button.removeClass('clicked');
                }, 50);
            });
        });

        $(function () {
            $(".inputWrapper1").mousedown(function () {
                var button = $(this);
                button.addClass('clicked');
                setTimeout(function () {
                    button.removeClass('clicked');
                }, 50);
            });
        });
    </script>
    <script type="text/javascript">
        var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
        document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
    </script>
    <script type="text/javascript">
        try {
            var pageTracker = _gat._getTracker("UA-11603881-1");
            pageTracker._trackPageview();
        } catch (err) { }
    </script>
    

    <!-- -------------------------------------------------------- -->

    <style type="text/css">
    #Layer3 {
	    position:absolute;
	    left:10px;
	    top:120px;
	    z-index:10;
	    background:url('images/p2.png') no-repeat;
	    visibility: hidden;
        width: 325px;
        }
    .style1 {
	    color: #FFFFFF;
	    font-weight: bold;
	    font-family: Verdana, Arial, Helvetica, sans-serif;
	    font-size: 12px;
    }
    .style2 {
	    font-family: Verdana, Arial, Helvetica, sans-serif;
	    font-size: 11px;
    }
    </style>

        <!-- Ham viet cho xu ly css -->
    <style type="text/css">
        .loadingScreenWindow
        {
            position: relative; 
            padding: .2em; 
            width: 300px; 
            border: 2px solid blue;
            background: #FFEE77;
        }
        .loadingScreenWindow1
        {
            position: relative; 
            padding: .2em; 
            width: 100px; 
            border: 4px solid green;
            background: #FFFFFF;
            display: block;
        }
        .selected
        {
            background: #3b5998;
            color: #FFFFFF;
        }
        .unselected
        {
            background-color: #fff;
            color: #666;
        }
        .highlight
        {
            font-size: small;
            font-weight: bold;
        }
        body
        {
            margin: 0;
        }
        
        #contextMenu
        {
            position: absolute;
            min-width: 100px;
            z-index: 1000;
            background: #fff;
            border-top: solid 1px #CCC;
            border-left: solid 1px #CCC;
            border-bottom: solid 1px #676767;
            border-right: solid 1px #676767;
            padding: 0px;
            margin: 0px;
            display: none;
        }
        
        #contextMenu a
        {
            color: #000;
            font-family: Arial;
            font-size: 12px;
            text-decoration: none;
            display: block;
            line-height: 22px;
            height: 22px;
            padding: 1px 10px;
        }
        
        #contextMenu li
        {
            list-style: none;
            padding: 1px;
            margin: 0px;
        }
        
        #contextMenu li.hover a
        {
            background-color: #A7C4FA;
        }
        
        #contextMenu li.separator
        {
            border-top: solid 1px #ccc;
        }
    </style>
    <!-------------- Style CSS use for autocomplete   ------------------------------------->
    <style type="text/css">
        .ui-combobox
        {
            position: relative;
            display: inline-block;
        }
        .ui-combobox-toggle
        {
            position: absolute;
            top: 0;
            bottom: 0;
            margin-left: -1px;
            padding: 0; /* support: IE7 */
            height: 1.7em;
            top: 0.1em;
        }
        .ui-combobox-input
        {
            margin: 0;
            padding: 0.3em;
        }
    </style>

    <!-- Style for button Find File Data Example -->
    	<style type="text/css">
		.inputWrapper {
			overflow: hidden;
			position: relative;
			cursor: pointer;
			margin-right:10px;
			/*Using a background color, but you can use a background image to represent a button*/
			background-color: #ACC;
		}
		.inputWrapper1 {
			overflow: hidden;
			position: relative;
			cursor: pointer;
			background-color: #DDA;
		}
		.fileInput {
			cursor: pointer;
			height: 100%;
			position:absolute;
			top: 0;
			right: 0;
			/*This makes the button huge so that it can be clicked on*/
			font-size:50px;
		}
		.hidden {
			/*Opacity settings for all browsers*/
			opacity: 0;
			-moz-opacity: 0;
			filter:progid:DXImageTransform.Microsoft.Alpha(opacity=0)
		}
		
		
		.fileInput1 {
			cursor: pointer;
			height: 100%;
			position:absolute;
			top: 0;
			right: 0;
			/*This makes the button huge so that it can be clicked on*/
			font-size:50px;
		}
		.hidden1 {
			/*Opacity settings for all browsers*/
			opacity: 0;
			-moz-opacity: 0;
			filter:progid:DXImageTransform.Microsoft.Alpha(opacity=0)
		}


		/*Dynamic styles*/
		.inputWrapper:hover {
			background-color: #F1D;
		}
		.inputWrapper.clicked {
			background-color: #A66;
		}
		
		.inputWrapper1:hover {
			background-color: #A9C;
		}
		.inputWrapper1.clicked {
			background-color: #A71;
		}
 </style>
</head>
<body>
    <div style="border-bottom-style: outset; border-bottom-width: 1px; width: 1381.8px;
        position: absolute; left: 1px; top: 0px; z-index: 2; height: 28.5px; background-color: rgb(144, 239, 138);">
        <select id="option_list" style="width: 286px;">
            <option value="">Chọn tuyến xe buýt</option>
            <option value="1">[1] Bến Thành - Bến Xe Chợ Lớn</option>
            <option value="2">[2] Bến Thành - Bến Xe Miền Tây</option>
            <option value="3">[3] Bến Thành - Thạnh Lộc</option>
            <option value="4">[4] Bến Thành - Cộng Hòa - An Sương</option>
            <option value="6">[6] Bến Xe Chợ Lớn - Đại Học Nông Lâm</option>
            <option value="7">[7] Bến Xe Chợ Lớn - Gò Vấp</option>
            <option value="8">[8] Bến Xe Quận 8 - Đại Học Quốc Gia</option>
            <option value="9">[9] Chợ Lớn - Quốc Lộ 1A - Hưng Long</option>
            <option value="10">[10] Đại Học Quốc Gia - Bến Xe Miền Tây</option>
            <option value="11">[11] Bến Thành - Đầm Sen</option>
            <option value="13">[13] Bến Thành - Bến Xe Củ Chi</option>
            <option value="14">[14] Miền Đông - 3 tháng 2 - Miền Tây</option>
            <option value="15">[15] Bến Phú Định - Bình Trị Đông</option>
            <option value="16">[16] Bến Xe Chợ Lớn - Bình Trị Đông</option>
            <option value="17">[17] Bến Xe Chợ Lớn - Cư Xá Ngân Hàng</option>
            <option value="18">[18] Bến Thành - Chợ Hiệp Thành</option>
            <option value="19">[19] Bến Thành - Khu Chế Xuất Linh Trung - Đại Học Quốc Gia</option>
            <option value="20">[20] Bến Thành - Nhà Bè</option>
            <option value="22">[22] Bến Xe Quận 8 - KCN Lê Minh Xuân</option>
            <option value="23">[23] Bến Xe Chợ Lớn - Ngã Ba Giồng</option>
            <option value="24">[24] Bến Xe Miền Đông - Hóc Môn</option>
            <option value="25">[25] Bến Xe Quận 8 - Khu Dân Cư Vĩnh Lộc A</option>
            <option value="26">[26] Bến Xe Miền Đông - Bến Xe An Sương</option>
            <option value="27">[27] Bến Thành - Âu Cơ - An Sương</option>
            <option value="28">[28] Bến Thành - Chợ Xuân Thới Thượng</option>
            <option value="29">[29] Bến Phà Cát Lái - Chợ Nông Sản Thủ Đức</option>
            <option value="30">[30] Chợ Tân Hương - Đại học Quốc tế</option>
            <option value="31">[31] Bến xe Miền Đông - Khu dân cư Tân Quy</option>
            <option value="32">[32] Bến Xe Miền Tây - Bến Xe Ngã Tư Ga</option>
            <option value="33">[33] Bến Xe An Sương - Suối Tiên - Đại học Quốc Gia</option>
            <option value="34">[34] Bến Thành - Đại Học Công Nghệ Sài Gòn</option>
            <option value="35">[35] Tuyến xe buýt Quận 1</option>
            <option value="36">[36] Bến Thành - Thới An</option>
            <option value="37">[37] Cảng Quận 4 - Nhơn Đức</option>
            <option value="38">[38] KDC Tân Quy - Đầm Sen</option>
            <option value="39">[39] Bến Thành - Võ Văn Kiệt - Bến Xe Miền Tây</option>
            <option value="40">[40] Bến Xe Miền Đông - Bến Xe Ngã Tư Ga</option>
            <option value="41">[41] Đầm Sen - Bến Xe An Sương</option>
            <option value="43">[43] Bến Xe Miền Đông - Phà Cát Lái</option>
            <option value="44">[44] Cảng Quận 4 - Bình Quới</option>
            <option value="45">[45] Bến Thành - Bến Xe Quận 8</option>
            <option value="46">[46] Cảng Quận 4 - Bến Thành - Bến Mễ Cốc</option>
            <option value="47">[47] Bến Xe Chợ Lớn - Quốc Lộ 50 - Hưng Long</option>
            <option value="48">[48] Siêu Thị CMC - Công Viên Phần Mềm Quang Trung</option>
            <option value="50">[50] Đại Học Bách Khoa - Đại Học Quốc Gia</option>
            <option value="51">[51] Bến Xe Miền Đông - Bình Hưng Hòa</option>
            <option value="52">[52] Bến Thành - Đại Học Quốc Tế</option>
            <option value="53">[53] Lê Hồng Phong - Đại Học Quốc Gia</option>
            <option value="54">[54] Bến Xe Miền Đông - Bến Xe Chợ Lớn</option>
            <option value="55">[55] Công Viên Phần Mềm Quang Trung - Khu Công Nghệ Cao</option>
            <option value="56">[56] Bến Xe Chợ Lớn - Đại Học Giao Thông Vận Tải</option>
            <option value="57">[57] Chợ Phước Bình - Trường THPT Hiệp Bình</option>
            <option value="58">[58] Bến Xe Ngã 4 Ga - Bình Mỹ</option>
            <option value="59">[59] Bến Xe Quận 8 - Bến Xe Ngã 4 Ga</option>
            <option value="60">[60] Bến Xe An Sương - KCN Lê Minh Xuân</option>
            <option value="61">[61] Bến Xe Miền Tây - KCN Lê Minh Xuân</option>
            <option value="62">[62] Bến Xe Quận 8 - Thới An</option>
            <option value="64">[64] Bến Xe Miền Đông - Đầm Sen</option>
            <option value="65">[65] Bến Thành - CMT8 - Bến Xe An Sương</option>
            <option value="66">[66] Bến Xe Chợ Lớn - Bến Xe An Sương</option>
            <option value="68">[68] Bến Xe Chợ Lớn - KCX Tân Thuận</option>
            <option value="69">[69] Bến Thành - KCN Tân Bình</option>
            <option value="70">[70] Tân Quy - Bến Súc</option>
            <option value="71">[71] Bến Xe An Sương - Phật Cô Đơn</option>
            <option value="72">[72] Bến Thành - Hiệp Phước</option>
            <option value="73">[73] Chợ Bình Chánh - KCN Lê Minh Xuân</option>
            <option value="74">[74] Bến Xe An Sương - Bến Xe Củ Chi</option>
            <option value="76">[76] Long Phước - Suối Tiên - Đền Vua Hùng</option>
            <option value="77">[77] Đồng Hòa - Cần Thạnh</option>
            <option value="78">[78] Thới An - Hóc Môn</option>
            <option value="79">[79] Bến Xe Củ Chi - Đền Bến Dược</option>
            <option value="80">[80] Bến Xe Chợ Lớn - Ba Làng</option>
            <option value="81">[81] Bến Xe Chợ Lớn - Lê Minh Xuân</option>
            <option value="82">[82] Bến Xe Chợ Lớn - Ngã Ba Tân Quý Tây</option>
            <option value="83">[83] Bến Xe Củ Chi - Cầu Thầy Cai</option>
            <option value="84">[84] Bến Xe Chợ Lớn - Tân Túc</option>
            <option value="85">[85] Bến Xe An Sương - Khu Công Nghiệp Nhị Xuân</option>
            <option value="86">[86] Bến Thành - Đại học Tôn Đức Thắng</option>
            <option value="87">[87] Bến Xe Củ Chi - An Nhơn Tây</option>
            <option value="88">[88] Bến Thành - Chợ Long Phước</option>
            <option value="89">[89] Bệnh Viện Đa Khoa Thủ Đức - Trường THPT Hiệp Bình</option>
            <option value="90">[90] Phà Bình Khánh - Cần Thạnh</option>
            <option value="91">[91] Bến Xe Miền Tây - Chợ Nông Sản Thủ Đức</option>
            <option value="93">[93] Bến Thành - Đại Học Nông Lâm</option>
            <option value="94">[94] Bến Xe Chợ Lớn - Bến Xe Củ Chi</option>
            <option value="95">[95] KDC KCN Tân Bình - Bến Xe Miền Đông</option>
            <option value="96">[96] Bến Thành - Chợ Bình Điền</option>
            <option value="99">[99] Chợ Bình Khánh - Đại học Quốc Gia</option>
            <option value="100">[100] Bến Xe Củ Chi - Cầu Tân Thái</option>
            <option value="101">[101] Bến Xe Chợ Lớn - Bến Phú Định</option>
            <option value="102">[102] Bến Thành - Nguyễn Văn Linh - Bến Xe Miền Tây</option>
            <option value="103">[103] Bến Xe Chợ Lớn - Bến Xe Ngã 4 Ga</option>
            <option value="104">[104] Bến Xe An Sương - Đại Học Nông Lâm</option>
            <option value="192">[107] Bến xe Củ Chi- Bố Heo</option>
            <option value="110">[110] Phú Xuân - Hiệp Phước</option>
            <option value="111">[111] Bến Xe Quận 8 - Bến Xe An Sương</option>
            <option value="122">[122] An Sương - Tân Quy</option>
            <option value="126">[126] Bến Xe Củ Chi - Bình Mỹ</option>
            <option value="139">[139] Bến Xe Miền Tây - Phú Xuân</option>
            <option value="140">[140] Bến Thành - Phạm Thế Hiển - Ba Tơ</option>
            <option value="141">[141] Chợ Long Trường - KCX Linh Trung</option>
            <option value="143">[143] Bến Xe Chợ Lớn - Bình Hưng Hòa</option>
            <option value="144">[144] Bến Xe Miền Tây - Chợ Lớn - Đầm Sen - Nhiêu Lộc</option>
            <option value="145">[145] Bến Xe Chợ Lớn - Chợ Hiệp Thành</option>
            <option value="146">[146] Bến Xe Miền Đông - Chợ Hiệp Thành</option>
            <option value="148">[148] Bến Xe Miền Tây - Gò Vấp</option>
            <option value="149">[149] Bến Thành - Cư Xá Nhiêu Lộc</option>
            <option value="150">[150] Bến Xe Chợ Lớn - Ngã 3 Tân Vạn</option>
            <option value="151">[151] Bến Xe Miền Tây - Bến Xe An Sương</option>
            <option value="152">[152] Khu Dân Cư Trung Sơn - Sân Bay Tân Sơn Nhất</option>
        </select>
        Lượt đi:
        <input id="chckLuotDi" type="checkbox" name="chckLuotDi" checked="checked" />
        <input class="button" type="button" name="Submit" value="Hiển thị tuyến" onclick="showRouteOfBus();" />
       <!-- <select id="txtBoxFrom" style="width: 300px; border-width: 1px; top: 4px">
            <option value="">Select From Bus Stop</option>
        </select>
        -->
        <input id="txtBoxFrom_autocomplete" type="text" value="Chọn điểm bắt đầu đi" style="width: 299px; border-width: 2px; top: 4px" />
        <input id="txtBoxTo_autocomplete" type="text" value="Chọn điểm đến" style="width: 299px; border-width: 2px; top: 4px" />
        
        Số bus tối đa:
        <input id="dieukien" type="text" name="chondieukien" style="width: 29px; border-width: 1px; top: 4px"/>
        <input id="button_click" class="button1" type="button" name="Submit" value="Tìm đường đi" onclick="showRouteOfBus1();" />
        <!--<input type="file" id="fileInput" value="Nhập vào" onchange="readfile(this.files[0])" />       <!-- Read data from file input (data example) -->
	<!--
        <a class="inputWrapper" style="height: 24px; width: 68px;">
		Điểm đầu
		<input class="fileInput hidden"type="file" id="fileInput" onchange="readfile1(this.files[0])" name="file_output"/>
	    </a>

	    <a class="inputWrapper1" style="height: 24px; width: 68px;">
		Điểm đích
		<input class="fileInput1 hidden1" type="file" onchange="readfile(this.files[0])" name="file_Input"/>
	    </a>
	-->
    </div>

    <!-- Function process popup texbox show information bus route -->
    <div id="Layer3"">
	    <div style="height:50px; align="right"" id="div_popup" onmousemove = "div_popup_mousemove()" onmousedown="div_popup_mousedown()" onmouseup="div_popup_mouseup()" onmouseover="div_popup_mouseover()" onmouseout="div_popup_mouseout()">
            <a href="#"><img src="images/spacer.gif" width="30" height="30" border="0" onclick="hide_div_Layer3();"/></a>
        </div>
	    <div  style="height:23px; margin: 2px 22px 5px 17px" >
	        <img src="images/a.png" alt="text2" width="20" height="23" align="left"/><span id="beginDiv" style="font-size:10px" class="style1"/>
         </div>
	    <div id="cttDiv" style="height:200px; margin:0px 22px 5px 17px; overflow:auto">
	      <table width="100%" border="0" cellspacing="0" cellpadding="5">
          </table>
	    </div>
	    <div style="margin:15px 22px 2px 17px; height:24px" >
                <img src="images/b.png" alt="text1" width="20" height="23" align="left" /><span style="font-size:10px" id="endDiv" class="style1"/>
        </div>
        <div style="margin:13px 22px 5px 17px; height:44px">
            <table width="100%" border="0"><tr>
                <td><div id="infoDiv" class="style1" style="font-size:11px"></div></td>
                <td align="right"><div id="backDiv" class="style1" style="font-size:11px"></div></td>
            </tr></table>
        </div>
    </div>



    <!-- Chua cac thong tin lien quan den viec doi ma tram sang dia chi tram  -->
    <a id="diachi0"></a><a id="diachi1"></a> <a id="diachi2"></a> <a id="diachi3"></a> <a id="diachi4"></a> <a id="diachi5"></a> <a id="diachi6"></a>
    <a id="diachi7"></a> <a id="diachi8"></a> <a id="diachi9"></a> <a id="diachi10"></a> <a id="diachi11"></a> <a id="diachi12"></a>
    <a id="diachi13"></a> <a id="diachi14"></a> <a id="diachi15"></a> <a id="diachi16"></a> <a id="diachi17"></a> <a id="diachi18"></a>
    <!-------------------------------------------------------------------------->

    <div id="thongtintuyenxebus" style="border-style: outset; border-width: 1px; position: absolute; left: 0px; top: 30px; width: 284.6px; height: 468px; z-index: 2; background-color: rgb(238, 238, 238); overflow: auto;">
        <b>Danh sách các tuyến xe bus</b>
    </div>
    <div id="map_canvas1" style="position: absolute; top: 30px; width: 77%; left: 285px; height: 600px; z-index: 1; background-color: rgb(229, 227, 223); overflow: hidden;">
    </div>
    <div id="map_canvas" style="position: absolute; top: 30px; width: 77.7%; left: 288.6px;z-index: 1; background-color: rgb(229, 227, 223); overflow: hidden;-webkit-transform: translateZ(0);">
    </div>
    <input id="A1BK" value=""/>

    <div id="infoPanel" style="border-style: outset; border-width: 1px; position: absolute; left: 0px; top: 500px; width: 284px; height: 133px; z-index: 2; background: #aaaaaa">
        <!--
        <b>Tọa độ trạm:</b>
        <div id="info">
        </div>
        -->
        <b>Địa chỉ:</b> <b id="address"></b><br />
        <b>Tổng khoảng cách:</b> <b id="TotalDistance"></b><br />
        <b>Tổng thời gian:</b> <b id="TotalDuration"></b>
        <br/>
        <a class="inputWrapper" style="height: 24px; width: 68px;">
		<b><i>Chọn điểm đầu</i></b>
		<input class="fileInput hidden"type="file" id="fileInput" onchange="readfile(this.files[0])" name="file_output"/>
	    </a>
        <br/>
        <a class="inputWrapper1" style="height: 24px; width: 68px;">
		<b><i>Chọn điểm đích</i></b>
		<input class="fileInput1 hidden1" type="file" onchange="readfile1(this.files[0])" name="file_Input"/>
	    </a>

        <input type="hidden" id="stationIndex" />
    </div>

    

    <div id="marker_legend">
    </div>
    <div id="divLoading" style="left:60px; top:180px; position:absolute; visibility:hidden; z-index:110"><img width="100px" src="images/loading.gif" alt=""/></div>
    <b id="totalDistance_start"></b>
    <b id="totalDistance_end"></b>
    <b id="totalDuration_start"></b>
    <b id="totalDuration_end"></b>
    <div id="dialog" title="Nội dung tìm kiếm"></div>
    <div id="dialog1" title="Kết quả đường đi bằng xe buýt">
    <h3></h3>
    </div>
</body>
</html>
