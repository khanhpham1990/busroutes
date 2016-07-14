jQuery.fn.highlight = function (text) {
    function func(div, text) {
        var l = 0;
        if (div.nodeType == 3) {
            var index = div.data.toUpperCase().indexOf(text);
            if (index >= 0) {
                var span = document.createElement("span");
                span.className = "highlight";
                var followStr = div.splitText(index);
                //str = 'abcd';
                //str1 = str.splitText(1);
                //=> str ='a' , str1 = 'bcd';

                var afterStr = followStr.splitText(text.length);
                var hlText = followStr.cloneNode(true);
                span.appendChild(hlText);
                followStr.parentNode.replaceChild(span, followStr);
                l = 1;
                //alert("k");
            }
        }
        else {
            if (div.nodeType == 1 && div.childNodes && !/(script|style)/i.test(div.tagName)) {
                //Node.ELEMENT_NODE == 1
                for (var g = 0; g < div.childNodes.length; ++g) {
                    g += func(div.childNodes[g], text)
                }
            }
        }
        return l;
    }
    return this.each(function () { func(this, text.toUpperCase()) })
};

jQuery.fn.removeHighlight = function () {
    return this.find("span.highlight").each(function () {
        this.parentNode.firstChild.nodeName; with (this.parentNode) {
            replaceChild(this.firstChild, this); normalize()
        }
    }).end()
};