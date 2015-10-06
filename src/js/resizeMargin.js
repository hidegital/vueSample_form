var ua = ('./ua.js');//内部で外定義の関数をrequire
var resizeMargin = function(pageHeight) {
    var $target1 = $('.main_box'),
        $target2 = $('.main_box_bottomImg'),
        $target3 = $('.main_boxTxt'),
        $target4 = $('.main_boxNav');
    if (!ua.Mobile && !ua.Tablet) {
        if (pageHeight > 800) {
            $target1.css('margin-top', '9%');
            $target2.css('margin-top', '6%');
            $target3.css('margin-top', '4%');
        } else if (pageHeight < 800 && pageHeight > 750) {
            $target1.css('margin-top', '9%');
            $target2.css('margin-top', '5%');
        } else if (pageHeight < 750 && pageHeight > 700) {
            $target1.css('margin-top', '8%');
            $target2.css('margin-top', '5%');
            $target3.css('margin-top', '3%');
        } else if (pageHeight < 700 && pageHeight > 600) {
            $target1.css('margin-top', '7%');
            $target2.css('margin-top', '4%');
            $target3.css('margin-top', '2%');
        } else if (pageHeight < 600 && pageHeight > 500) {
            $target1.css('margin-top', '5%');
            $target2.css('margin-top', '3%');
            $target3.css('margin-top', '2%');
        } else {
            return;
        }
    }
    if(ua.Mobile){
        if (pageHeight > 700) {
            $target1.css('margin-top', '18%');
            $target2.css('margin-top', '10%');
            $target3.css('margin-top', '9%');
            $target4.css('margin-top', '4%');
        } else if (pageHeight < 568) {
            $target1.css('margin-top', '8%');
        }else{
            return;
        }
    }
    if(ua.Tablet){
        console.log('ccc');
        var mql = window.matchMedia( "(orientation: portrait)" );
        mql.addListener( onOrientationChange );
        onOrientationChange( mql );
        if ( mql.matches ) {
            if (pageHeight > 900) {
                $target1.css('margin-top', '20%');
                $target2.css('margin-top', '12%');
                $target3.css('margin-top', '11%');
                $target4.css('margin-top', '6%');
            }
        }else{
            $target1.css('margin-top', '8%');
            $target2.css('margin-top', '6%');
            $target3.css('margin-top', '4%');
        }
    }
}

module.exports = resizeMargin