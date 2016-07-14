<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="busroute.aspx.cs" Inherits="BusRouteHCM.busroute" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head id="Head1" runat="server">
    <title></title>
    <script type="text/javascript" src="http://maps.googleapis.com/maps/api/js?key=AIzaSyA5_pDLOrLDV5THdfNH8gzHU3nFklH7kZ4&sensor=false"></script>
    <script type="text/javascript" src="Scripts/Arrows.js"></script>
    <script type="text/javascript" src="Scripts/jquery-1.9.0.min.js"></script>
    <script type="text/javascript" src="Scripts/jquery.lazyload.min.js"></script>
    <script type="text/javascript" src="Scripts/jscoord-1.1.1.js"></script>
    <script type="text/javascript" src="Scripts/MyJScript.js"></script>
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
    <script src="http://maps.google.com/maps/api/js?sensor=false" type="text/javascript"></script>
    <script type="text/javascript" src="http://maps.googleapis.com/maps/api/js?libraries=geometry&sensor=false"></script>
    <script type="text/javascript" src="Scripts/jquery.autocomplete.js"></script>
    <script type="text/javascript" src="http://code.jquery.com/ui/1.10.2/jquery-ui.js"></script>
    <script type="text/javascript" src="Scripts/jquery-1.9.1.js"></script>
    <link rel="stylesheet" href="http://code.jquery.com/ui/1.10.2/themes/smoothness/jquery-ui.css" />
    <link rel="stylesheet" href="http://code.jquery.com/ui/1.10.2/themes/smoothness/jquery-ui.css" />
    <script type="text/javascript" src="http://code.jquery.com/jquery-1.9.1.js"></script>
    <script type="text/javascript" src="http://code.jquery.com/ui/1.10.2/jquery-ui.js"></script>
    <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false"></script>
    <meta http-equiv="content-type" content="text/html;charset=UTF-8" />
</head>
<body>
    <div style="border-bottom-style: outset; border-bottom-width: 1px; width: 1180px;
        position: absolute; left: 1px; top: 0px; z-index: 2; height: 28.5px; background-color: rgb(144, 238, 238);">
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
        <input id="chckLuotDi" type="checkbox" name="chckLuotDi" checked="checked" /></td>
        <input class="button" type="button" name="Submit" value="Hiển thị tuyến" onclick="showRouteOfBus();" />
        <select id="txtBoxFrom" onchange="calcRoute();" style="width: 280px; border-width: 1px; top: 4px">
            <option value="">Select From Bus Stop</option>
        </select>
        <select id="txtBoxTo" onchange="calcRoute();" style="width: 280px; border-width: 1px; top: 4px">
            <option value="">Select To Bus Stop</option>
        </select>
        <!--<input type="text" id="txtBoxFrom" style="width: 280px; border-width:1px; top:4px" />
    <input type="text" id="txtBoxTo" style="width: 280px; border-width:1px; top:4px" /> -->
        <input class="button1" type="button" name="Submit" value="Tìm đường đi" onclick="showRouteOfBus1();" />
    </div>
    <script type="text/javascript">
        /*-----------------------------------------------------------------------------------------------------------------------------------------------------*/
        //Ajax
        var httpRequest;
        if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
            httpRequest = new XMLHttpRequest();
        }
        else {// code for IE6, IE5
            httpRequest = new ActiveXObject("Microsoft.XMLHTTP");
        }

        var directionDisplay;   // tinh toan hien thi route
        var directionsService = new google.maps.DirectionsService();
        var stepDisplay;
        var startMarker, endMarker;
        var hasStart, hasEnd;
        /*Ve mui ten cho tuyen bus*/
        var arrows = []; // luu arrow
        var setArrows;
        var markersArray = [];
        var pathArr = []; //luu cac tuyen tren duong di

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

        var listAllBusStop = new Array();        // mang chua danh sach "têntram toado_x toado_y id","tentram1 tentram2 khoang_cach" cua tung tram luot di + luot ve
        var listPathRouteTemp = new Array();
        /*-----------------------------------------------------------------------------------------------------------------------------------------------------*/

        /* Xu ly cho phan node First to End */
        var directionDisplay;

        


        var routesPath = [];
        var markerPath = [];
        var CoordList = [];     // mang chua danh sach cac toa do cua tuyen

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

            var mapOptions = {
                zoom: 14,
                zoomControl: true,
                zoomControlOptions: {
                    style: google.maps.ZoomControlStyle.SMALL
                },
                center: new google.maps.LatLng(10.781034791471589, 106.65887832641602),
                mapTypeId: google.maps.MapTypeId.ROADMAP,
                mapTypeControl: false,
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

            map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions);
            directionsDisplay = new google.maps.DirectionsRenderer({ 'map': map });
            stepDisplay = new google.maps.InfoWindow();

        });
        /*

        //tao mot context menu
        // Create the context menu element
        var contextMenu = $(document.createElement('ul'))
			.attr('id', 'contextMenu');

        contextMenu.append(
			'<li><a href="#zoomIn">Phóng to bản đồ</a></li>' +
			'<li><a href="#zoomOut">Thu nhỏ bản đồ</a></li>' +
			'<li><a href="#startPoint">Nơi bắt đầu đi</a></li>' +
			'<li><a href="#endPoint">Đích đến</a></li>'
		);
        contextMenu.bind('contextmenu', function () { return false; });
        //Gan no len ban do
        $(map.getDiv()).append(contextMenu);
        */
        var direction_data = [
              { icon: "images/bus1.png",
                  line_color: "#FF0000"
              },
              { icon: "images/bus2.png",
                  line_color: "#0000FF"
              },
              { icon: "images/bus3.png",
                  line_color: "#00FF00"
              },
              { icon: "images/bus4.png",
                  line_color: "#FFFF00"
              }
            ];

        /*
        $.getJSON('Dstuyen/tuyen.json', function (data) {
        for (var i = 0; i < data.ROW.length; i++) {
        $("#option_list").append('<option value="' + data.ROW[i].id + '">' + '[' + data.ROW[i].id + ']' + ' ' + data.ROW[i].nameRoutes + '</option>');
        }
        });
        */


        /*Distance between bus stop hcm city*/
        function CaculateDistance(lat1, lon1, lat2, lon2) {
            var R = 6371; // km
            var dLat = (lat2 - lat1).toRad();
            var dLon = (lon2 - lon1).toRad();
            var lat1 = lat1.toRad();
            var lat2 = lat2.toRad();

            var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) + Math.sin(dLon / 2) * Math.sin(dLon / 2) * Math.cos(lat1) * Math.cos(lat2);
            var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
            var d = R * c;
            return d;
        }


        /*Su dung ham ve mui ten arrows*/
        //setArrows.arrowheads = [];
        if (arrows) {
            for (i in arrows) {
                arrows[i].setMap(null);
            }
            // Now, clear the array itself.
            arrows = [];
        }


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
            removeTheMarkers();
            removeTheMarkersPath();
            var lstTuyen = document.getElementById("option_list");
            var chckLuotDi = document.getElementById("chckLuotDi");
            if ($('#chckLuotDi').is(":checked")) {
                chckLuotDi = "on";      // chon ve tuyen luot di
                var url = "http://localhost:10587/data/GetTuyenBus/true/GetTuyenBus_true" + lstTuyen.value + ".json";
            } else {
                chckLuotDi = "off";      // chon ve tuyen luot ve
                var url = "http://localhost:10587/data/GetTuyenBus/false/GetTuyenBus_false" + lstTuyen.value + ".json";
            }

            //alert(chckLuotDi);
            //var url = "http://localhost:10587/json/route" + lstTuyen.value + ".json";
            //var url_tramluotdi = "http://localhost:10587/data/GetTuyenBus/true/GetTuyenBus_true" + lstTuyen.value + ".json";
            //var url_tramluotve = "http://localhost:10587/data/GetTuyenBus/false/GetTuyenBus_false" + lstTuyen.value + ".json";
            httpRequest.onreadystatechange = function () {
                if (httpRequest.readyState == 4 && httpRequest.status == 200) {
                    //document.getElementById("data").innerHTML = httpRequest.responseText;
                    var carObject = eval('(' + httpRequest.responseText + ')');
                    var myObject = "jSonTuyen=" + httpRequest.responseText;
                    eval(myObject);
                    //alert(jSonTuyen.TABLE[0].ROW.length);
                    //alert(lstTuyen.value);
                    //alert(url);
                    var j = 0;
                    document.getElementById("thongtintuyenxebus").innerHTML = "";
                    for (var i = 0; i < jSonTuyen.TABLE[0].ROW.length; i++) {
                        var utmInter = new UTMRef(jSonTuyen.TABLE[0].ROW[i].COL[3].DATA, jSonTuyen.TABLE[0].ROW[i].COL[4].DATA, "N", 48);
                        var llInter = utmInter.toLatLng();
                        var latLngInter = new google.maps.LatLng(llInter.lat, llInter.lng);
                        routes.push({ Lat: llInter.lat, Lng: llInter.lng });        // dua toa do kinh-vi do vao array routes dung co che queue
                        //alert(llInter.lat + "," + llInter.lng);

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
                url = "http://localhost:10587/data/GetFullRoute/true/GetFullRoute_true" + tuyenID + ".txt";
            }
            else {
                url = "http://localhost:10587/data/GetFullRoute/false/GetFullRoute_false" + tuyenID + ".txt";
            }
            //var url = "http://localhost:10587/ToaDoTram/ToaDoTram" + tuyenID + ".txt";
            //var url = "http://localhost:10587/ToaDoTram/ToaDoTram1.txt";
            httpRequest.onreadystatechange = function () {
                if (httpRequest.readyState == 4 && httpRequest.status == 200) {
                    var coors = httpRequest.responseText.split(" ");        // chua thong tin tap hop cac toa do Google cua cac tram
                    //alert(coors.length);
                    for (var i = 0; i < coors.length; i++) {
                        if (coors[i] != ' ') {
                            path = mypath.getPath();
                            latlng = coors[i].split(",");
                            path.push(new google.maps.LatLng(latlng[1], latlng[0]));
                        }
                    }
                    //alert(mypath);
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

            document.getElementById('info').innerHTML = latLng.lat() + "," + latLng.lng();
        }
        function updateMarkerAddress(str) {     // hien thi thong tin ve con duong
            document.getElementById('address').innerHTML = str;
        }

        //});

        /*xu ly truong hop chon tram bus*/
        /*
        $(function () {
        var availableTags = [
        "ActionScript",
        "AppleScript",
        "Asp",
        "BASIC",
        "C",
        "C++",
        "Clojure",
        "COBOL",
        "ColdFusion",
        "Erlang",
        "Fortran",
        "Groovy",
        "Haskell",
        "Java",
        "JavaScript",
        "Lisp",
        "Perl",
        "PHP",
        "Python",
        "Ruby",
        "Scala",
        "Scheme"
        ];
        $("#txtBoxFrom").autocomplete({
        source: availableTags
        });
        $("#txtBoxTo").autocomplete({
        source: availableTags
        });
        });

        */

        $.getJSON('data/Input/input_json.json',
                  function (data) {
                      for (var i = 0; i < data.BusStop.length; i++) {
                          var string1 = data.BusStop[i].id;
                          var a = string1.split(" ");
                          $("#txtBoxFrom").append('<option value="' + a[0] + '">' + '[' + a[0] + ']' + '</option>');
                          $("#txtBoxTo").append('<option value="' + a[0] + '">' + '[' + a[0] + ']' + '</option>');
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
        /*Xu ly du lieu nhap vao input - output*/
        function showRouteOfBus1() {
            removeTheMarkers();
            removeTheMarkersPath();
            if (mypath != null) {
                mypath.setMap(null);
            }
            if (myPathDijkstra != null) {
                myPathDijkstra.setMap(null);
            }
            

            /*Lay du lieu nhap vao input select From*/
            var from = document.getElementById("txtBoxFrom");
            var valueIsFrom = from.options[from.selectedIndex].value; // .text

            /*Lay du lieu nhap vao input select To*/
            var to = document.getElementById("txtBoxTo");
            var valueIsTo = to.options[to.selectedIndex].value; // .text


            var url1 = "busroute.aspx?start=" + valueIsFrom + "&dest=" + valueIsTo;
            var busObject = httpRequest.response;
            //httpRequest.open("GET", url1, true);
            //httpRequest.send();

            httpRequest.onreadystatechange = function () {
                if (httpRequest.readyState == 4 && httpRequest.status == 200) {
                    var busObject = httpRequest.response;
                    var myObject = eval("(" + busObject + ")");
                    document.getElementById('thongtintuyenxebus').innerHTML = "";

                    //alert(myObject);
                    for (var i = 0; i < myObject.path.length; i++) {
                        routesPath.push({ Lat: myObject.path[i].X, Lng: myObject.path[i].Y });        // dua toa do kinh-vi do vao array routes dung co che queue
                        var latLngInter = new google.maps.LatLng(myObject.path[i].X, myObject.path[i].Y);
                        CoordList.push(latLngInter);
                        var toadoX = myObject.path[i].X;
                        var toadoY = myObject.path[i].Y;
                        listPathRouteTemp.push(toadoX);
                        listPathRouteTemp.push(toadoY);

                        document.getElementById('thongtintuyenxebus').innerHTML += "<div class=\"report\" onclick=\"moveTo(" + myObject.path[i].X + ", " + myObject.path[i].Y + ",'" + myObject.path[i].Name + "');\">" + "[" + i + "]" + myObject.path[i].Name + '</div>';
                        var marker = new google.maps.Marker({
                            position: latLngInter,
                            title: myObject.path[i].Name,
                            map: map,
                            icon: "../images/bus3.png"
                        });

                        markerPath.push(marker);
                        //pathPaint = myPathDijkstra.getPath();
                        //pathPaint.push(new google.maps.LatLng((myObject.path[i].X, myObject.path[i].Y)));
                    }
                    map.panTo(markerPath[0].getPosition());

                    myPathDijkstra = new google.maps.Polyline({
                        map: map,
                        path: CoordList,
                        strokeWeight: 7,
                        strokeOpacity: 0.8,
                        strokeColor: "#FF33CC"
                    });
                    //var paintIt = new google.maps.Polyline(myPathDijkstra);
                    myPathDijkstra.setMap(map);
                    drawPathRoute(myObject.path.length);
                }
            }
            httpRequest.open("GET", url1, true);
            httpRequest.send();
        }

        function calcRoute() {
            
            var start = document.getElementById('txtBoxFrom').value;
            var end = document.getElementById('txtBoxTo').value;
            
            var request = {
                origin:start,
                destination:end,
                travelMode: google.maps.DirectionsTravelMode.DRIVING
            };
            directionsService.route(request, function(response, status) {
              if (status == google.maps.DirectionsStatus.OK) {
                directionsDisplay.setDirections(response);
              }
        });


        // Ham ve duong noi giua 2 tram bat ky
        var pathTemp = [];
        function drawPathRoute(n) {
            var pathCoord;
            var pathTemp = [];
            var pathTemp1 = [];
            //alert(listPathRouteTemp.length);
//            for (var i = 0; i < listPathRouteTemp.length; i++) {
//                pathTemp[i] = listPathRouteTemp.shift();
            //            }

            var a = "http://maps.googleapis.com/maps/api/directions/json?origin=" + listPathRouteTemp.shift() + "," + listPathRouteTemp.shift() + "&destination=" + listPathRouteTemp.shift() + "," + listPathRouteTemp.shift() + "&sensor=false";
            /*
            var j = 0;
            var url = new Array();
            for (var i = 0; i < listPathRouteTemp.length/4; i++) {
                var lat1 = listPathRouteTemp.shift();
                var long1 = listPathRouteTemp.shift();
                var lat2 = listPathRouteTemp.shift();
                var long2 = listPathRouteTemp.shift();

                var url1 = "http://maps.googleapis.com/maps/api/directions/json?origin=" + lat1 + "," + long1 + "&destination=" + lat2 + "," + long2 + "&sensor=false";
                url.push(url1);
                //j += 4
            }
            */
            //alert(n);

            // Xu ly toa do tra ve tu google map service
            //for (var i = 0; i < n; i++) {
                httpRequest.onreadystatechange = function () {
                    if (httpRequest.readyState == 4 && httpRequest.status == 200) {
                        var busObject = httpRequest.response;
                        var myObject = eval("(" + busObject + ")");
                    }
                }
                httpRequest.open("GET", a, true);
                httpRequest.send();
            }
        }
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
    <div id="thongtintuyenxebus" style="border-style: outset; border-width: 1px; position: absolute;
        left: 0px; top: 30px; width: 284.6px; height: 468px; z-index: 2; background-color: rgb(238, 238, 238);
        overflow: auto;">
        <b>Danh sách các tuyến xe bus</b>
    </div>
    <div id="map_canvas1" style="position: absolute; top: 30px; width: 77%; left: 285px;
        height: 600px; z-index: 1; background-color: rgb(229, 227, 223); overflow: hidden;">
    </div>
    <div id="map_canvas" style="position: absolute; top: 30px; width: 77.7%; left: 300px;
        height: 636px; z-index: 1; background-color: rgb(229, 227, 223); overflow: hidden;
        -webkit-transform: translateZ(0);">
    </div>
    <div id="infoPanel" style="border-style: outset; border-width: 1px; position: absolute;
        left: 0px; top: 500px; width: 284px; height: 133px; z-index: 2; background: #aaaaaa">
        <b>Trạng thái:</b>
        <div id="markerStatus">
            <i></i>
        </div>
        <b>Tọa độ trạm:</b>
        <div id="info">
        </div>
        <b>Địa chỉ:</b>
        <div id="address">
        </div>
        <input type="hidden" id="stationIndex" />
    </div>
    <div id="marker_legend">
    </div>
</body>
</html>
