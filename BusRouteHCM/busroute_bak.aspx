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
        <!-- Ham viet cho xu ly css -->
        <style type="text/css">
            .selected {
	        background:#3b5998;
            color:#FFFFFF;
            }
            .unselected {
	            background-color: #fff;
	            color: #666;
            }
            .highlight 
            {
                font-size :small;
                font-weight : bold;
            }
            body { margin:0; }

                #contextMenu {
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
	                display:none;
                }

                #contextMenu a {
	                color: #000;
	                font-family: Arial;
	                font-size: 12px;
	                text-decoration: none;
	                display: block;
	                line-height: 22px;
	                height: 22px;
	                padding: 1px 10px;
                }

                #contextMenu li {
	                list-style: none;
	                padding: 1px;
	                margin: 0px;
                }

                #contextMenu li.hover a {
	                background-color: #A7C4FA;
                }

                #contextMenu li.separator {
	                border-top: solid 1px #ccc;
                }
        </style>

<!-------------- Style CSS use for autocomplete   ------------------------------------->
        <style type="text/css">
	        .ui-combobox {
		        position: relative;
		        display: inline-block;
	        }
	        .ui-combobox-toggle {
		        position: absolute;
		        top: 0;
		        bottom: 0;
		        margin-left: -1px;
		        padding: 0;
		        /* support: IE7 */
		        height: 1.7em;
		        top: 0.1em;
	        }
	        .ui-combobox-input {
		        margin: 0;
		        padding: 0.3em;
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
        <input id="chckLuotDi" type="checkbox" name="chckLuotDi" checked="checked" /></td>
        <input class="button" type="button" name="Submit" value="Hiển thị tuyến" onclick="showRouteOfBus();" />
        <select id="txtBoxFrom" style="width: 300px; border-width: 1px; top: 4px">
            <option value="">Select From Bus Stop</option>
        </select>
        <select id="txtBoxTo"  style="width: 300px; border-width: 1px; top: 4px">
            <option value="">Select To Bus Stop</option>
        </select>
        Nhập điều kiện:
        <input type="text" name="chondieukien" style="width: 30px; border-width: 1px; top: 4px"/>
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

        var directionDisplay;
        var directionsService = new google.maps.DirectionsService();
        
        var stepDisplay;
        var startMarker, endMarker;
        var hasStart, hasEnd;
        /*Ve mui ten cho tuyen bus*/
        var arrows = []; // luu arrow
        var setArrows;
        var markersArray = [];
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

        var listAllBusStop = new Array();        // mang chua danh sach "têntram toado_x toado_y id","tentram1 tentram2 khoang_cach" cua tung tram luot di + luot ve
        var listPathRouteTemp = new Array();
        /*-----------------------------------------------------------------------------------------------------------------------------------------------------*/

        /* Xu ly cho phan node First to End */
        var batches = [];
        var itemsPerBatch = 10; // google API max - 1 start, 1 stop, and 8 waypoints (limit 8 waypoint for google map direction)
        var itemsCounter = 0;
        var directionDisplay;
        var directionsService = new google.maps.DirectionsService();
        var wayptsExist = 0; //testArray.length;	


        var routesPath = [];
        var markerPath = [];
        var CoordList = [];     // mang chua danh sach cac toa do cua tuyen
        var returnStartPoint, returnEndPoint;
        var stringReturn = "";
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

            map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions);
            directionsDisplay = new google.maps.DirectionsRenderer();

            document.getElementById('thongtintuyenxebus').innerHTML = "";
            directionsDisplay.setPanel(document.getElementById('thongtintuyenxebus'));
            directionsDisplay.setMap(map);
            //setArrows = new ArrowHandler();
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
                        findAddressWithCoord(llInter_1.lat, llInter_1.lng, startMarker,true);
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
                        findAddressWithCoord(llInter_2.lat, llInter_2.lng, endMarker,false);
                        //console.log(returnEndPoint);
                        break;
                }
                return false;
            });
        });


        
        /*
        $.getJSON('Dstuyen/tuyen.json', function (data) {
        for (var i = 0; i < data.ROW.length; i++) {
        $("#option_list").append('<option value="' + data.ROW[i].id + '">' + '[' + data.ROW[i].id + ']' + ' ' + data.ROW[i].nameRoutes + '</option>');
        }
        });
        */


        /*Distance between bus stop hcm city*/
        /*
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
        */

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
                    //stringReturn = myObject_1.path2[0].Name + "," + myObject_1.path2[0].X + "," + myObject_1.path2[0].Y;
                    if (flags == true) {
                        StartPointNear(myObject_1.path2[0].Name, myObject_1.path2[0].X, myObject_1.path2[0].Y,_X,_Y);
                    }
                    else {
                        EndPointNear(myObject_1.path2[0].Name, myObject_1.path2[0].X, myObject_1.path2[0].Y,_X,_Y);
                    }
                }
            }
            httpRequest.open("GET", url_1, true);
            httpRequest.send();
        }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /* Hien thi ra phần tọa độ trạm gần nhất với điểm click chuột trên bản đồ */
        var toadoX_start = 0.0, toadoY_start = 0.0, toadoX_end = 0.0, toadoy_end = 0.0, nameStartCliclPoint, nameEndClickPoint;
        function StartPointNear(name_start, x_start, y_start, x_, y_) {
            //console.log(name_start+ "toa do 1");
            toadoX_start = x_;
            toadoY_start = y_;
            console.log("Trạm START gần với tọa độ khi click chuột:" + name_start + " Tọa độ khi click chuột:" + "(" + toadoX_start + "," + toadoY_start + ")");
            nameStartCliclPoint = name_start;
            document.getElementById('address').innerHTML = name_start;
        }
        function EndPointNear(name_end, x_end, y_end, x_, y_) {
            //console.log(name_end + "toa do 2");
            toadoX_end = x_;
            toadoy_end = y_;
            console.log("Trạm END gần với tọa độ khi click chuột:" + name_end + " Tọa độ khi click chuột:" + "(" + toadoX_end + "," + toadoy_end + ")");
            nameEndClickPoint = name_end;
            document.getElementById('address').innerHTML = name_end;
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
        var subBatch = [];
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
            

            /*Lay du lieu nhap vao input select From*/
            var from = document.getElementById("txtBoxFrom");
            var valueIsFrom = from.options[from.selectedIndex].value; // .text

            /*Lay du lieu nhap vao input select To*/
            var to = document.getElementById("txtBoxTo");
            var valueIsTo = to.options[to.selectedIndex].value; // .text

            valueIsFrom = nameStartCliclPoint;
            valueIsTo = nameEndClickPoint;

            var url1 = "busroute.aspx?start=" + valueIsFrom + "&dest=" + valueIsTo;
            var busObject = httpRequest.response;
            //httpRequest.open("GET", url1, true);
            //httpRequest.send();
            //console.log(url1);

            /*test demo*/
            pathArr.push(new google.maps.LatLng(toadoX_start, toadoY_start));
            /*end test demo*/

            httpRequest.onreadystatechange = function () {
                if (httpRequest.readyState == 4 && httpRequest.status == 200) {
                    var busObject = httpRequest.response;
                    var myObject = eval("(" + busObject + ")");
                    //document.getElementById('thongtintuyenxebus').innerHTML = "";

                    //alert(myObject);
                    for (var i = 0; i < myObject.path.length; i++) {
                        routesPath.push({ Lat: myObject.path[i].X, Lng: myObject.path[i].Y });        // dua toa do kinh-vi do vao array routes dung co che queue
                        var latLngInter = new google.maps.LatLng(myObject.path[i].X, myObject.path[i].Y);
                        CoordList.push(latLngInter);
                        pathArr.push(latLngInter);

                        var toadoX = myObject.path[i].X;
                        var toadoY = myObject.path[i].Y;
                        listPathRouteTemp.push(toadoX);
                        listPathRouteTemp.push(toadoY);

            //            document.getElementById('thongtintuyenxebus').innerHTML += "<div class=\"report\" onclick=\"moveTo(" + myObject.path[i].X + ", " + myObject.path[i].Y + ",'" + myObject.path[i].Name + "');\">" + "[" + i + "]" + myObject.path[i].Name + '</div>';
                        var marker = new google.maps.Marker({
                            position: latLngInter,
                            title: myObject.path[i].Name,
                            map: map,
                            icon: "../images/bus3.png"
                        });

                        markerPath.push(marker);
                    }
                    map.panTo(markerPath[0].getPosition());

                    /*
                    myPathDijkstra = new google.maps.Polyline({
                        map: map,
                        path: CoordList,
                        strokeWeight: 7,
                        strokeOpacity: 0.8,
                        strokeColor: "#FF33CC"
                    });
                    
                    myPathDijkstra.setMap(map);
                    */
                    //drawPathRoute(myObject.path.length);
                    //console.log(pathArr);

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
            //console.log(pathArr);
            wayptsExist = pathArr.length;
            batches = [];
            //console.log(wayptsExist);
            while (wayptsExist) {
                //var subBatch = [];
                subBatch = [];
                var subitemsCounter = 0;
                for (var j = itemsCounter; j < pathArr.length; j++) {
                    //console.log(testArray[j].jb);
                    subitemsCounter++;
                    subBatch.push({
                        location: new window.google.maps.LatLng(pathArr[j].kb, pathArr[j].lb),
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
            //console.log(batches);
            calcRoute(batches, directionsService, directionsDisplay);
        }
        function calcRoute(batches, directionsService, directionsDisplay) {
            var combinedResults ;
            var unsortedResults = [{}]; // to hold the counter and the results themselves as they come back, to later sort
            var directionsResultsReturned = 0;

            for (var k = 0; k < batches.length; k++) {
                var lastIndex = batches[k].length - 1;
                var start = batches[k][0].location;
                
                var end = batches[k][lastIndex].location;
                //console.log(batches[k][0]);
                // trim first and last entry from array
                var waypts = [];
                waypts = batches[k];
                waypts.splice(0, 1);
                waypts.splice(waypts.length - 1, 1);

                var request = {
                    origin: start,
                    destination: end,
                    waypoints: waypts,
                    travelMode: window.google.maps.TravelMode.DRIVING
                };
                (function (kk) {
                    directionsService.route(request, function (result, status) {
                        if (status == window.google.maps.DirectionsStatus.OK) {

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
                                                combinedResults.routes[0].bounds = combinedResults.routes[0].bounds.extend(unsortedResults[key].result.routes[0].bounds.getNorthEast());
                                                combinedResults.routes[0].bounds = combinedResults.routes[0].bounds.extend(unsortedResults[key].result.routes[0].bounds.getSouthWest());
                                            }
                                            count++;
                                        }
                                    }
                                }
                                directionsDisplay.setDirections(combinedResults);
                            }
                        }
                    });
                })(k);
            }
        }
        /*
        function calcRoute(batches, directionsService, directionsDisplay) {
            var combinedResults;
            var directionsResultsReturned = 0;

            for (var k = 0; k < batches.length; k++) {
                var lastIndex = batches[k].length - 1;
                var start = batches[k][0].location;
                var end = batches[k][lastIndex].location;


                // trim first and last entry from array
                var waypts = [];
                waypts = batches[k];
                waypts.splice(0, 1);
                waypts.splice(waypts.length - 1, 1);

                var request = {
                    origin: start,
                    destination: end,
                    waypoints: waypts,
                    optimizeWaypoints: true,
                    travelMode: window.google.maps.TravelMode.DRIVING
                };
                directionsService.route(request, function (result, status) {
                    if (status == window.google.maps.DirectionsStatus.OK) {
                        if (directionsResultsReturned == 0) {
                            combinedResults = result;
                            directionsResultsReturned++;
                        }
                        else {
                            combinedResults.routes[0].legs = combinedResults.routes[0].legs.concat(result.routes[0].legs);
                            combinedResults.routes[0].overview_path = combinedResults.routes[0].overview_path.concat(result.routes[0].overview_path);

                            combinedResults.routes[0].bounds = combinedResults.routes[0].bounds.extend(result.routes[0].bounds.getNorthEast());
                            combinedResults.routes[0].bounds = combinedResults.routes[0].bounds.extend(result.routes[0].bounds.getSouthWest());
                            directionsResultsReturned++;
                        }
                        if (directionsResultsReturned == batches.length)
                            directionsDisplay.setDirections(combinedResults);
                    }
                });
            }
        }
        */
        /////////////////////////////////////////////////////////////////////////////////////////////////
        /*
        (function ($) {
            $.widget("ui.combobox", {
                _create: function () {
                    this.wrapper = $("<span>")
					.addClass("ui-combobox")
					.insertAfter(this.element);

                    this._createAutocomplete();
                    this._createShowAllButton();
                },

                _createAutocomplete: function () {
                    var selected = this.element.children(":selected"),
					value = selected.val() ? selected.text() : "";

                    this.input = $("<input>")
					.appendTo(this.wrapper)
					.val(value)
					.attr("title", "")
					.addClass("ui-state-default ui-combobox-input ui-widget ui-widget-content ui-corner-left")
					.autocomplete({
					    delay: 0,
					    minLength: 0,
					    source: $.proxy(this, "_source")
					})
					.tooltip({
					    tooltipClass: "ui-state-highlight"
					});

                    this._on(this.input, {
                        autocompleteselect: function (event, ui) {
                            ui.item.option.selected = true;
                            this._trigger("select", event, {
                                item: ui.item.option
                            });
                        },

                        autocompletechange: "_removeIfInvalid"
                    });
                },

                _createShowAllButton: function () {
                    var wasOpen = false;

                    $("<a>")
					.attr("tabIndex", -1)
					.attr("title", "Show All Items")
					.tooltip()
					.appendTo(this.wrapper)
					.button({
					    icons: {
					        primary: "ui-icon-triangle-1-s"
					    },
					    text: false
					})
					.removeClass("ui-corner-all")
					.addClass("ui-corner-right ui-combobox-toggle")
					.mousedown(function () {
					    wasOpen = input.autocomplete("widget").is(":visible");
					})
					.click(function () {
					    input.focus();

					    // Close if already visible
					    if (wasOpen) {
					        return;
					    }

					    // Pass empty string as value to search for, displaying all results
					    input.autocomplete("search", "");
					});
                },

                _source: function (request, response) {
                    var matcher = new RegExp($.ui.autocomplete.escapeRegex(request.term), "i");
                    response(this.element.children("option").map(function () {
                        var text = $(this).text();
                        if (this.value && (!request.term || matcher.test(text)))
                            return {
                                label: text,
                                value: text,
                                option: this
                            };
                    }));
                },

                _removeIfInvalid: function (event, ui) {

                    // Selected an item, nothing to do
                    if (ui.item) {
                        return;
                    }

                    // Search for a match (case-insensitive)
                    var value = this.input.val(),
					valueLowerCase = value.toLowerCase(),
					valid = false;
                    this.element.children("option").each(function () {
                        if ($(this).text().toLowerCase() === valueLowerCase) {
                            this.selected = valid = true;
                            return false;
                        }
                    });

                    // Found a match, nothing to do
                    if (valid) {
                        return;
                    }

                    // Remove invalid value
                    this.input
					.val("")
					.attr("title", value + " didn't match any item")
					.tooltip("open");
                    this.element.val("");
                    this._delay(function () {
                        this.input.tooltip("close").attr("title", "");
                    }, 2500);
                    this.input.data("ui-autocomplete").term = "";
                },

                _destroy: function () {
                    this.wrapper.remove();
                    this.element.show();
                }
            });
        })(jQuery);

        $(function () {
            $("#txtBoxTo").combobox();
            $("#toggle").click(function () {
                $("#txtBoxTo").toggle();
            });
        });
        */
        /////////////////////////////////////////////////////////////////////////////////////////////////
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
    <div id="map_canvas" style="position: absolute; top: 30px; width: 77.7%; left: 288.6px;
        height: 680px; z-index: 1; background-color: rgb(229, 227, 223); overflow: hidden;
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
    <div id="divLoading" style="left:60px; top:180px; position:absolute; visibility:hidden; z-index:110"><img width="100px" src="images/loading.gif" /></div>

</body>
</html>
