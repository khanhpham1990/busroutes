function init() {
    var map_canvas = document.getElementById("map_canvas");
    var oWindow = getWinSize();
    map_canvas.style.height = (oWindow.height - 128) + 'px';
    var divLoading = document.getElementById("divLoading");
    divLoading.style.top = ((oWindow.height - 128) / 2) + 'px';
    divLoading.style.left = ((oWindow.width - 128) / 2) + 'px';
    setPosition('From');
    //loadStation();
    getAllStreet();
}
function loadStation() {
    var url = 'Server.aspx?action=GetAllPublicStation';
    var req = getAjax();

    req.onreadystatechange = function () {
        if (req.readyState == 4 && req.status == 200) {
            var myObject = "jSonTram=" + req.responseText;
            eval(myObject);
            for (var i = 0; i < jSonTram.TABLE[0].ROW.length; i++) {                
                var utmInter = new UTMRef(jSonTram.TABLE[0].ROW[i].COL[2].DATA, jSonTram.TABLE[0].ROW[i].COL[3].DATA, "N", 48);
                var llInter = utmInter.toLatLng();
                var latLngInter = new google.maps.LatLng(llInter.lat, llInter.lng);
                var marker = new google.maps.Marker({
                    position: latLngInter,
                    title: jSonTram.TABLE[0].ROW[i].COL[1].DATA,
                    map: map,
                    icon: "./images/"+jSonTram.TABLE[0].ROW[i].COL[4].DATA
                });
                attachAjaxInstructionText(marker, jSonTram.TABLE[0].ROW[i].COL[0].DATA)
            }
        }

    }

    req.open('GET', url, true);
    req.send(null);
}

function resize() {
    var map_canvas = document.getElementById("map_canvas");
    var oWindow = getWinSize();
    map_canvas.style.height = (oWindow.height - 128) + 'px';
}
var numOfItem = 0;
var currentItem = -1;

var arrOfChoicedItem = new Array();

function resetText(comp) {
    document.getElementById("hdBoxNo" + comp).value = '';
    document.getElementById("hdBoxStr" + comp).value = '';
    document.getElementById("txtBox" + comp).value = '';  
   if (comp == 'From') {
        if (startMarker != null)
            startMarker.setMap(null);
        startMarker = null;
    }
    else {
        if (endMarker != null)
            endMarker.setMap(null);
        endMarker = null;
    }
            
    currentItem = -1;
    numOfItem = 0;
}

function onAddresFocus(comp) {
    clearOverlays();

    var divLoading = document.getElementById("divLoading");
    divLoading.style.visibility = '';

    var hdBoxNo = document.getElementById("hdBoxNo" + comp).value;
    var hdBoxStr = document.getElementById("hdBoxStr" + comp).value;
    var url = 'Server.aspx?action=FindAddress&With=NAME&NoAdd=' + hdBoxNo + '&StrAdd=' + hdBoxStr;

    req = getAjax();
    req.onreadystatechange = function () {
        if (req.readyState == 4 && req.status == 200) {
            var resultJSON;
            var myObject = "resultJSON=" + req.responseText;
            eval(myObject);
            if (resultJSON.found) {
                var htmlStr = '<table width=99%>';

                var count = 0;
                find = true;

                var minDif = diff(hdBoxNo, resultJSON.districts[0].addrs[0].SoNha);
                var minAddr = resultJSON.districts[0].addrs[0];
                var minCount = 1;
                var minLat = 0;
                var minLng = 0;
                var minX = 0, minY = 0;
                //-----------
                for (var i = 0; i < resultJSON.districts.length; i++) {
                    var district = resultJSON.districts[i];
                    var _tenQuan = district.DistrictName;

                    htmlStr += '<tr style="font-family: Arial;font-size: 13px;font-weight: bold;background-color: #ffbb33;padding-left:3px;height:20px;"><td><span style="color:#000000;">' + _tenQuan + '</span></td></tr>';

                    for (var j = 0; j < district.addrs.length; j++) {
                        var addr = district.addrs[j];
                        count++;

                        var X1 = addr.X;
                        var Y1 = addr.Y;
                        var utm = new UTMRef(X1, Y1, "N", 48);
                        var ll = utm.toLatLng();
                        //var pos = new google.maps.LatLng(ll.lat, ll.lng);

                        var _soNha = addr.SoNha;
                        var _tenDuongCoDau = addr.TenCoDau;
                        var _tenDuongKhongDau = addr.TenKhongDau;

                        var _tenPhuong = addr.TenPhuong;
                        var _maPhuong = addr.MaPhuong;

                        var txt = (_soNha == '') ? '' : _soNha + ", ";
                        var addressStr = txt + _tenDuongCoDau + ", " + _tenPhuong;

                        htmlStr += '<tr class="address"><td> <span style="cursor:pointer;padding-left:10px;"'
                                + ' onclick="changePosTo(\'' + comp + '\',' + ll.lat + ',' + ll.lng + ',\'' + addressStr + ', '
                                + _tenQuan + '\',\'' + _soNha + '\',\'' + _tenDuongKhongDau + '\', true'
                                + ');">'

                        // + ' onclick="testA(\''+comp+'\');">'
                                + addressStr + '</span></td></tr>';
                        htmlStr += '<tr><td style="border-bottom-width:1px; border-bottom-style:dotted;"></td></tr>'

                        /*
                        //kiem tra co phai la dia chi dau tien tim duoc khong
                        // neu la dau tien thi hien no ra
                        if (i == 0 && j == 0) {
                        var find = true;
                        if (district.addrs.length > 1 || resultJSON.districts.length > 1)
                        find = false;
                        changePosTo(comp, ll.lat, ll.lng, addressStr + ', ' + _tenQuan, _soNha, _tenDuongKhongDau, find);
                        }
                        */
                        if (count == 1) {
                            minLat = ll.lat;
                            minLng = ll.lng;
                            minX = addr.X; minY = addr.Y;
                        }

                        var dif = diff(hdBoxNo, addr.SoNha);
                        if (dif < minDif) {
                            minDif = dif;
                            minAddr = addr;
                            minCount = count;
                            minLat = ll.lat; minLng = ll.lng;
                            minX = addr.X; minY = addr.Y;
                        }

                        if (district.addrs.length > 1 || resultJSON.districts.length > 1)
                            find = false;
                    }

                }

                htmlStr += '</table>';

                var temp = (minAddr.SoNha == '') ? '' : minAddr.SoNha + ", ";
                var addrTempStr = temp + minAddr.TenCoDau + ", " + minAddr.TenPhuong + ", " + minAddr.TenQuan;

                changePosTo(comp, minLat, minLng, addrTempStr, minAddr.SoNha, minAddr.TenKhongDau, find);

                setContent_Div('cttDiv', htmlStr);
                //testA(comp);
                show_div_Layer3();
            } else {
                updateAddressBar(comp, '', '', '');
                alert('Không có địa chỉ này!!!');
            }

            divLoading.style.visibility = 'hidden';
        }

    }

    req.open('GET', url, true);
    req.send(null);
}
//---------------------------------
function getNumberFromText(txt) {
    //var re = new RegExp(/\d+/g);
    //var m = re.exec(txt);
    var m = txt.match(/\d+/g);// return all numbers
    if(m!=null && m.length >0)
        return m;
    return [5000];
}

function diff(txt1, txt2) {
    var number1 = (txt1 == '') ? [0] : getNumberFromText(txt1);
    var number2 = (txt2 == '') ? [5000] : getNumberFromText(txt2);

    var dif = 0;
    var max = (number1.length > number2.length) ? number1.length : number2.length;
    for (var i = 0; i < max; i++) {
        var n1=0, n2=0;
        if (i < number1.length) n1 = number1[i];
        if (i < number2.length) n2 = number2[i];

        if ((n1 != 0 && n2 == 0) || (n1 == 0 && n2 != 0)) {
            n1 = 0.1;
            n2 = 0;
        }

        dif += Math.abs(n1-n2);
    }

    if (txt1.length != txt2.length) dif += 0.1;
    //alert("(" +txt1 +", "+number1 +") - (" + txt2+", " + number2 +")");

    return dif;
}
//////////////////////////////////////////////
(function ($) {
    jQuery.mlp = { x: 0, y: 0 }; // Mouse Last Position
    $(document).mousemove(function (e) {
        jQuery.mlp = { x: e.pageX, y: e.pageY }
    });
    function notNans(value) {
        if (isNaN(value)) {
            return 0;
        } else {
            return value
        }
    }
    $.fn.ismouseover = function (overThis) {
        var result;
        this.eq(0).each(function () {
            var offSet = $(this).offset();
            var w = Number($(this).width())
            + notNans(Number($(this).css("padding-left").replace("px", "")))
            + notNans(Number($(this).css("padding-right").replace("px", "")))
            + notNans(Number($(this).css("border-right-width").replace("px", "")))
            + notNans(Number($(this).css("border-left-width").replace("px", "")));
            var h = Number($(this).height())
            + notNans(Number($(this).css("padding-top").replace("px", "")))
            + notNans(Number($(this).css("padding-bottom").replace("px", "")))
            + notNans(Number($(this).css("border-top-width").replace("px", "")))
            + notNans(Number($(this).css("border-bottom-width").replace("px", "")));
            if (offSet.left < jQuery.mlp.x && offSet.left + w > jQuery.mlp.x
             && offSet.top < jQuery.mlp.y && offSet.top + h > jQuery.mlp.y) {
                result = true;
            } else {
                result = false;
            }
        });
        return result;
    };
})(jQuery);

///////////////////////////////////////////////
//onblur : Su kien khi khong con TextBox nua
function setDefaultValue(comp) {
    var divResult = 'divBox' + comp;
    setTimeout('hide(\'' + divResult + '\')', 200);
    currentItem = -1;
}

function moveBarToPointer(comp) {
    var divBar = document.getElementById("divBar" + comp);
    if (divBar.offsetTop < (event.clientY + document.body.scrollTop - 50)) {
        if (currentItem < numOfItem - 1) {
            divBar.style.top = (divBar.offsetTop + 16) + 'px';
            currentItem++;
            //document.getElementById("hdBoxStr" + comp).value = jSon.streets[arrOfChoicedItem[currentItem]].TenKhongDau;;                

        }
    }
    else {
        if (currentItem > 0) {
            divBar.style.top = (divBar.offsetTop - 16) + 'px';
            currentItem--;

        }
    }
}

function setValueForTxt(comp) {
    document.getElementById("hdBoxStr" + comp).value = jSon.streets[arrOfChoicedItem[currentItem]].TenKhongDau;
    var txt = jSon.streets[arrOfChoicedItem[currentItem]].TenCoDau;
    document.getElementById("txtBox" + comp).value = document.getElementById("hdBoxNo" + comp).value + ' ' + txt;

    currentItem = 0;
    hide("divBar" + comp);
    hide("divBox" + comp);
}

function setPosition(comp) {

    var txtBox = document.getElementById("txtBox" + comp);

    var divBox = document.getElementById("divBox" + comp);
    var divBar = document.getElementById("divBar" + comp);
    divBox.style.left = (txtBox.offsetLeft + 33) + 'px';
    divBar.style.left = (txtBox.offsetLeft + 33) + 'px';
    divBox.style.top = (txtBox.offsetTop + 38) + 'px';
    divBar.style.top = (txtBox.offsetTop + 40) + 'px';
}

//----------------------------------------------------------------
function onTypeText(evt, comp) {
    evt = (evt) ? evt : ((window.event) ? event : null);

    if (evt) {
        // perform processing here
        if (evt.keyCode == 38 || evt.keyCode == 40) {
            //xử lý lên, xuống      
            if (evt.keyCode == 38) {
                if (currentItem == 0 || currentItem == -1) {
                    currentItem = numOfItem - 1;
                } else {
                    currentItem--;
                }
            }
            else {
                if (currentItem == numOfItem - 1) {
                    currentItem = 0;
                } else {
                    currentItem++;
                }
            }

            //////////////////////////
            var divResults = $("#divBox" +comp );
            // loop through each result div applying the correct style
            divResults.children().each(function (i) {
                if (i == currentItem) {
                    this.className = "selected";
                } else {
                    this.className = "unselected";
                }
            });

            document.getElementById("hdBoxStr" + comp).value = jSon.streets[arrOfChoicedItem[currentItem]].TenKhongDau;
            var txt = (document.getElementById("hdBoxNo" + comp).value == '') ? '' : document.getElementById("hdBoxNo" + comp).value + ", ";
            document.getElementById("txtBox" + comp).value = txt + jSon.streets[arrOfChoicedItem[currentItem]].TenCoDau;

            return;


        } else if (evt.keyCode == 13) {
            //xử lý enter            
            var item = document.getElementById("txtBox" + comp).value;
            //if (true)(jSon.streets[arrOfChoicedItem[currentItem]].TenCoDau != item) {
            //ten khong dau
            document.getElementById("hdBoxStr" + comp).value = jSon.streets[arrOfChoicedItem[currentItem]].TenKhongDau;
            //ten co dau de hien len
            var txt = (document.getElementById("hdBoxNo" + comp).value == '') ? '' : document.getElementById("hdBoxNo" + comp).value + ", ";
            document.getElementById("txtBox" + comp).value = txt + jSon.streets[arrOfChoicedItem[currentItem]].TenCoDau;

            currentItem = -1;
            hide("divBar" + comp);
            hide("divBox" + comp);
            onAddresFocus(comp);
            //}
            return;
        }
        else {
            getTenDuong(comp);
//            if (numOfItem > 0) {
//                var txtBox = document.getElementById("txtBox" + comp);
//                var divBar = document.getElementById("divBar" + comp);
//                divBar.style.top = (txtBox.offsetTop + 38) + 'px';

//            } else {
//                hide("divBar" + comp);
//                currentItem = -1;
//            }
        }
    }
}

//Lay ten tat ca con duong dua vao bien jSon - global
//var jSon;
function getAllStreet() {
    var url = 'Server.aspx?action=GetAll';
    var req = getAjax();
    req.onreadystatechange = function () {
        if (req.readyState == 4 && req.status == 200) {

            var myObject = "jSon=" + req.responseText;
            eval(myObject);

        }

    }
    req.open('GET', url, true);
    req.send(null);
}

function getTenDuong(comp) {
    var item = document.getElementById("txtBox" + comp).value;
    
    var str = "";
    numOfItem = 0;
    if (item.indexOf(" ", 0) > 0) {
        //check token đầu tiên là số        
        //if token đầu tiên là số thì bỏ số ra
        if (!isNaN(parseFloat(item.substring(0, item.indexOf(" ", 0) + 1)))) {
            document.getElementById("hdBoxNo" + comp).value = item.substring(0, item.indexOf(" ", 0));
            item = item.substring(item.indexOf(" ", 0) + 1);
        }
    }

    if (item == "") {
        document.getElementById("divBox" + comp).innerHTML = "";
        document.getElementById("hdBoxNo" + comp).value ="";
        document.getElementById("hdBoxStr" + comp).value= "";
        currentItem = -1;
        
        return;
    }

    for (var i = 0; i < jSon.streets.length; i++) {
        var index = jSon.streets[i].TenKhongDau.toLowerCase().indexOf(item.toLowerCase());
        if (index >= 0) {
            arrOfChoicedItem[numOfItem] = i;
            numOfItem++;

            str += '<div  style="cursor:pointer;" onclick="itemOnclick(' + i + ', \'' + comp + '\');">'
                + jSon.streets[i].TenKhongDau;
            str += '</div>';

            if (numOfItem > 19) {
                break;
            }
        }

        index = jSon.streets[i].TenCoDau.toLowerCase().indexOf(item.toLowerCase());
        if (index >= 0) {
            arrOfChoicedItem[numOfItem] = i;
            numOfItem++;

            str += '<div  style="cursor:pointer;" onclick="itemOnclick(' + i + ', \'' + comp + '\');">'
                + jSon.streets[i].TenCoDau;
            str += '</div>';

            if (numOfItem > 19) {
                break;
            }
        }
    }
    document.getElementById("divBox" + comp).innerHTML = str;

    //---------------------------------------------------------
    var divResults = $("#divBox" + comp);

    divResults.highlight(item);

    var divs = $("#" + "divBox" + comp + " > div");

    // on mouse over clean previous selected and set a new one
    divs.mouseover(function () {
        divs.each(function () { this.className = "unselected"; });
        this.className = "selected";
    });

    show("divBox" + comp);
    //show("divBar" + comp);
}

//khi click chon 1 addr row
function itemOnclick(index, comp) {
    document.getElementById("hdBoxStr" + comp).value = jSon.streets[index].TenKhongDau;

    var txt = (document.getElementById("hdBoxNo" + comp).value == '') ? jSon.streets[index].TenCoDau
                : document.getElementById("hdBoxNo" + comp).value + ", " + jSon.streets[index].TenCoDau;

    document.getElementById("txtBox" + comp).value = txt;

    currentItem = 0;
    hide("divBar" + comp);
    hide("divBox" + comp);
    onAddresFocus(comp);
}

function getAjax() {
    var XmlHttp;

    try {
        XmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
    }
    catch (e) {
        try {
            XmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
        }
        catch (oc) {
            XmlHttp = null;
        }
    }
    //Creating object of XMLHTTP in Mozilla and Safari 
    if (!XmlHttp && typeof XMLHttpRequest != "undefined") {
        XmlHttp = new XMLHttpRequest();
    }
    return XmlHttp;
}
////////////////////////////////////////////////

function barMouseOver(comp) {
    hide('divBar' + comp);
}
function hide(x) {
    document.getElementById(x).style.display = 'none';
}
function show(x) {
    document.getElementById(x).style.display = '';
}
function disableEnterKey(e) {
    var key;
    if (window.event)
        key = window.event.keyCode;     //IE
    else
        key = e.which;     //firefox
    if (key == 13)
        return false;
    else
        return true;
}

///////////////////
function getAddressCoor() {

    var hdBoxNoFrom = document.getElementById("hdBoxNoFrom").value;
    var hdBoxStrFrom = document.getElementById("hdBoxStrFrom").value;
    url = 'Server.aspx?action=GetAddress&NoAdd=' + hdBoxNoFrom + '&StrAdd=' + hdBoxStrFrom;
    req = getAjax();
    req.onreadystatechange = function () {
        if (req.readyState == 4 && req.status == 200) {
            var myObject = "jSonAdd=" + req.responseText;
            eval(myObject);
            //alert(parseFloat(jSonAdd.TABLE[0].ROW[0].COL[0].DATA) +' '+ parseFloat(jSonAdd.TABLE[0].ROW[0].COL[1].DATA));
            var utm1 = new UTMRef(parseFloat(jSonAdd.TABLE[0].ROW[0].COL[0].DATA), parseFloat(jSonAdd.TABLE[0].ROW[0].COL[1].DATA), "N", 48);

            var ll3 = utm1.toLatLng();

            var position = new google.maps.LatLng(parseFloat(ll3.lat), parseFloat(ll3.lng));
            var marker = new google.maps.Marker({
                position: position,
                map: map
            });
            map.panTo(position);
            alert(jSonAdd.TABLE[0].ROW[0].COL[2].DATA);
        }

    }
    req.open('GET', url, true);
    req.send(null);
}

//////////////////////////////
function calcRoute(start, end) {
    // Retrieve the start and end locations and create
    // a DirectionsRequest using WALKING directions.
    var request = {
        origin: start,
        destination: end,
        travelMode: google.maps.DirectionsTravelMode.WALKING
    };

    // Route the directions and pass the response to a
    // function to create markers for each step.
    directionsService.route(request, function (response, status) {
        if (status == google.maps.DirectionsStatus.OK) {
            //directionsDisplay.setDirections(response);
            showSteps(response);
        }
    });

}

function showSteps(directionResult, start) {
    // For each step, place a marker, and add the text to the marker's
    // info window. Also attach the marker to an array so we
    // can keep track of it and remove it when calculating new
    // routes.
    var myRoute = directionResult.routes[0].legs[0];

    for (var i = 0; i < myRoute.steps.length; i++) {
        if (i != 0) {
            //            var marker = new google.maps.Marker({
            //                position: myRoute.steps[i].start_point,
            //                map: map
            //            });
            //            attachInstructionText(marker, myRoute.steps[i].instructions);
            //            markersArray.push(marker);
        }
        //Draw path
        if (start) {


            var pp1 = path1.getPath();
            pp1.push(myRoute.steps[i].start_point);
            if (i == myRoute.steps.length - 1)
                pp1.push(myRoute.steps[i].end_point);

        }
        else {

            var pp2 = path2.getPath();
            pp2.push(myRoute.steps[i].start_point);
            if (i == myRoute.steps.length - 1)
                pp2.push(myRoute.steps[i].end_point);

        }
    }
    if (start)
        path1.setMap(map);
    else
        path2.setMap(map);

    return myRoute.distance.value;
}


function attachInstructionText(marker, text) {
    google.maps.event.addListener(marker, 'click', function () {
        // Open an info window when the marker is clicked on,
        // containing the text of the step.
        stepDisplay.setContent(text);
        stepDisplay.open(map, marker);
    });
}
function attachAjaxInstructionText(marker, id) {
    google.maps.event.addListener(marker, 'click', function () {
        // Open an info window when the marker is clicked on,
        // containing the text of the step.
        var chuyenStr = id;
        var url = 'Server.aspx?action=GetTuyenQuaTram&TramId=' + id;
        req = getAjax();
        req.onreadystatechange = function () {
            if (req.readyState == 4 && req.status == 200) {
                var myObject = "jSonTram=" + req.responseText;
                eval(myObject);
                for (var i = 0; i < jSonTram.TABLE[0].ROW.length; i++) {
                    chuyenStr = 'Tên gọi: ' + jSonTram.TABLE[0].ROW[i].COL[2].DATA+'<br>'+'Tuyến đi qua: ' + jSonTram.TABLE[0].ROW[i].COL[3].DATA;
                }
                stepDisplay.setContent(chuyenStr);
                stepDisplay.open(map, marker);

            }
        }
        req.open('GET', url, true);
        req.send(null);

    });
}

////////////////////////////////////////////////////
//XY
function drawArrow(pt1, pt2, color) {
    var arrowSize = 10;

    function addHead(point, theta, color) {
        var x = point[0] * 1, y = point[1] * 1;

        var t = theta + (Math.PI / 4);
        if (t > Math.PI)
            t -= 2 * Math.PI;
        var t2 = theta - (Math.PI / 4);
        if (t2 <= (-Math.PI))
            t2 += 2 * Math.PI;

        var pts = new Array();
        var headLength = arrowSize;
        var x1 = 0 + x - Math.cos(t) * headLength;
        var y1 = 0 + y + Math.sin(t) * headLength;
        var x2 = 0 + x - Math.cos(t2) * headLength;
        var y2 = 0 + y + Math.sin(t2) * headLength;

        var utm = new UTMRef(x1, y1, "N", 48);
        var ll = utm.toLatLng();
        //1
        pts.push(new google.maps.LatLng(ll.lat, ll.lng));
        //2
        utm = new UTMRef(x, y, "N", 48);
        ll = utm.toLatLng();
        pts.push(new google.maps.LatLng(ll.lat, ll.lng));
        //3
        utm = new UTMRef(x2, y2, "N", 48);
        ll = utm.toLatLng();
        pts.push(new google.maps.LatLng(ll.lat, ll.lng));

        var head = new google.maps.Polyline({
            path: pts,
            strokeWeight: 7,
            strokeOpacity: 0.8,
            strokeColor: color
        });
        //		// Construct the polygon
        //		var head = new google.maps.Polygon({
        //		    paths: pts,
        //		    strokeColor: "#FF0000",
        //		    strokeOpacity: 0.8,
        //		    strokeWeight: 1,
        //		    fillColor: "#FF0000",
        //		    fillOpacity: 0.35
        //		});
        arrows.push(head);
        //var head = new google.maps.Polygon(pts, color, 0, 1, color, 1);
        head.setMap(map);
    }
    var utm = new UTMRef(pt1[0], pt1[1], "N", 48);
    var ll = utm.toLatLng();
    var p1 = new google.maps.LatLng(ll.lat, ll.lng);

    utm = new UTMRef(pt2[0], pt2[1], "N", 48);
    ll = utm.toLatLng();
    var p2 = new google.maps.LatLng(ll.lat, ll.lng);

    var points = [
        p1,
        p2
    ];
    var polyline = new google.maps.Polyline({
        path: points,
        strokeColor: color,
        strokeOpacity: 0.8,
        strokeWeight: 7
    });

    //var polyline = new google.maps.Polyline([p1, p2], color, lineWidth, lineOpacity);
    var dx = pt2[0] - pt1[0];
    var dy = pt2[1] - pt1[1];
    var theta = Math.atan2(-dy, dx);
    addHead(pt2, theta, color);
    arrows.push(polyline);
    polyline.setMap(map);
}

/////////////////////////////////////////////////////////////////
function displayDistance(dis) {
    dis = Math.round(dis);
    var km = Math.floor(dis / 1000);
    //if (km < 1) km = 0;

    var m = dis % 1000;
    if (km == 0)
        return m + ' m';
    return km + ' km ' + m + ' m';
}

function displayHour(minutes) {
    minutes = Math.round(minutes);
    var hour = Math.floor(minutes / 60);
    var minute = minutes % 60;
    if (hour == 0) return minute + ' phút';
    return hour + ' giờ ' + minute + ' phút';
}

///////////////////////////////////////////////
function moveTo(lat, lng) {
    // map.setZoom(17);
    map.panTo(new google.maps.LatLng(lat, lng));

}

function updateAddressBar(comp, sonha, tenkhongdau, addrStr) {
    var hdBoxNo = document.getElementById("hdBoxNo" + comp);
    var hdBoxStr = document.getElementById("hdBoxStr" + comp);
    var txtBox = document.getElementById("txtBox" + comp);

    hdBoxNo.value = sonha;
    hdBoxStr.value = tenkhongdau;
    txtBox.value = addrStr;
}

function changePosTo(comp, lat, lng, addrStr, sonha, tenkhongdau, find) {
    
    updateAddressBar(comp, sonha, tenkhongdau, addrStr);

    var start;
    if (comp == 'From') {
        start = true;
    } else {
        start = false;
    }

    addMarker(start, lat, lng, find);

}

function addMarker(start, lat, lng, find) {
    pos = new google.maps.LatLng(lat, lng);
    var marker = new google.maps.Marker({
        draggable: true,
        position: new google.maps.LatLng(lat, lng),
        map: map
    });
    if (start) {
        if (startMarker != null)
            startMarker.setMap(null);

        marker.title = "Nơi bắt đầu";
        marker.icon = './images/a_l.png';
        startMarker = marker;
    }
    else {
        if (endMarker != null)
            endMarker.setMap(null);

        marker.title = "Đích đến";
        marker.icon = './images/b_l.png';
        endMarker = marker;
    }

    google.maps.event.addListener(marker, 'dragend', function () {
        var latlng = new LatLng(marker.getPosition().lat(), marker.getPosition().lng());
        var utm = latlng.toUTMRef();
        var X = utm.easting;
        var Y = utm.northing;
        findAddressWithCoord(X, Y, marker);

    });

    //if (startMarker == null || endMarker == null || !find)
        moveTo(lat, lng);

    //tim duong
    //if (find) checkMarkersAndFindRoute();
}

/*
function findAddressWithCoord(_X, _Y, marker) {
	var httpRequest;
	var stringReturn="";
    if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
        httpRequest = new XMLHttpRequest();
    }
	var start = (marker == startMarker)? true: false;
	var url_1 = "busroute.aspx?x1=" + _X + "&y1=" + _Y;
	//console.log(url_1);
	
	//var busObject_1 = httpRequest.response;
    httpRequest.onreadystatechange = function () {
        if (httpRequest.readyState == 4 && httpRequest.status == 200) {
            // alert(httpRequest.response);
            var busObject_1 = httpRequest.response;
            var myObject_1 = eval("(" + busObject_1 + ")");
			//console.log(myObject_1.path2[0].Y);
			stringReturn =  myObject_1.path2[0].Name + "," + myObject_1.path2[0].X + "," + myObject_1.path2[0].Y;
        }
    }
    httpRequest.open("GET", url_1, true);
    httpRequest.send();
	
	return stringReturn;
}
*/
function checkMarkersAndFindRoute() {
    if (startMarker != null && endMarker != null) {
        var latlng1 = new LatLng(startMarker.getPosition().lat(), startMarker.getPosition().lng());
        var utm1 = latlng1.toUTMRef();
        var X1 = utm1.easting;
        var Y1 = utm1.northing;
        var latlng2 = new LatLng(endMarker.getPosition().lat(), endMarker.getPosition().lng());
        var utm2 = latlng2.toUTMRef();
        var X2 = utm2.easting;
        var Y2 = utm2.northing;
        if (choicedFunc == 'shortespath')
            findShortestPath(X1, Y1, X2, Y2);
        else
            findBusRoute(X1, Y1, X2, Y2);
        //findBusRoute(X1, Y1, X2, Y2);
        return true;
    }
    return false;
}
