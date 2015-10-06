module.exports =
{
    accordionPc : function() {
        var $triggerMenu = $('[data-nav-trigger="trigger"]'),
            $targetMenu  = $('[data-nav-target="target"]');
        $triggerMenu.on('mouseleave',function(e){
            if($targetMenu.hasClass('isOpen')) {
                var $mousePosition = $(e.target);
                if ($mousePosition != $triggerMenu || $mousePosition != $targetMenu) {
                    $(this).removeClass('toggleArea');
                    $targetMenu.removeClass('isOpen').addClass('isClose');
                }
            }
        });
        $triggerMenu.on('mouseover', function () {
            if(!$targetMenu.hasClass('isOpen')) {
                $(this).addClass('toggleArea');
                $targetMenu.removeClass('isClose').addClass('isOpen');
            }else{
                return;
            }
        });
    },

    /*アコーディオンタブレット用*/
    accordionTablet : function() {
        var $triggerMenu       = $('[data-nav-trigger="trigger"]'),
            $targetMenu        = $('[data-nav-target="target"]'),
            $targetMenuList    = $('[data-nav-targetlist="targetlist"]'),
            $targetlink        = $('[data-link="link"]'),
            $targetlink02      = $('[data-link02="link02"]'),
            $targetlink03      = $('[data-link03="link03"]'),
            triggerData        = $triggerMenu.data(),
            targetData         = $targetMenu.data(),
            targetDataList     = $targetMenuList.data(),
            targetlinkData     = $targetlink.data(),
            targetlinkData02   = $targetlink02.data(),
            targetlinkData03   = $targetlink03.data(),
            flg                = false;

        $('body').on('touchstart', function (e) {
            var $target = $(e.target).data();

            if ($target == triggerData && !flg) {
                $triggerMenu.addClass('toggleArea');
                $targetMenu.removeClass('isClose').addClass('isOpen');
                flg = true;
            }
            else if ($target != triggerData && $target != targetDataList && $target != targetlinkData && $target != targetlinkData02 && $target != targetlinkData03 && $target != targetData && flg == true) {
                if($target == targetlinkData && $target == targetlinkData02 && $target == targetlinkData03) return
                $triggerMenu.removeClass('toggleArea');
                $targetMenu.removeClass('isOpen').addClass('isClose');
                flg = false;
            }
        });
    },

    /*ハンバーガー*/
    hambuger : function() {
        // ナビアイコンをクリックしたら
        $('.navIcon').click(function(){
            $('.menu').toggleClass('menuOn'); // サイドメニュー表示切替
            $('body').toggleClass('fixed'); // コンテンツ固定

            if ($('.iconLayer').hasClass('arrow')) {
                $('.iconLayer').removeClass('arrow').addClass('hamburger'); // ハンバーガーメニューに
            } else { // それ以外なら
                $('.iconLayer').removeClass('hamburger').addClass("arrow"); // 矢印
            }
            return false;
        });

        // サイドナビゲーション高さ指定
        function winHeight() {
            var winH = $(window).height();
            var headerH = $('header').height() + 34;
            var winH = winH - headerH; // ヘッダーの高さを引く
            $('.menu').css({
                'height': winH + 'px',
                'top': headerH + 'px'
            });
        }
        winHeight();

        // リサイズしたら再度実行
        $(window).resize(function(){
            winHeight();
        });
    },

    hambugerFix : function() {
        if ( $('.fix_Nav').length == 0 ) return
        var fixNavPos = $('.fix_Nav').get( 0 ).offsetTop;
        var scrollNum;
        var winH = $(window).height();
        var fixNavFlg = false;
        $(window).scroll(function() {
            scrollNum = ($(this).scrollTop());
            if(fixNavPos <= scrollNum){
                $('.fix_Nav').addClass('isFixed');
                fixNavFlg = false;
            }else{
                $('.fix_Nav').removeClass('isFixed');
                fixNavFlg = true;
            }
        });

        // サイドナビゲーション高さ指定
        function winHeight() {
            // ヘッダーの高さを引く
            $('.menuFix').css({
                'height': winH + 'px'
            });
        }
        winHeight();
        // リサイズしたら再度実行
        $(window).resize(function(){
            winHeight();
        });

        // ナビアイコンをクリックしたら
        $('.navIconFix').click(function () {
            $('.menuFix').toggleClass('menuOn'); // サイドメニュー表示切替
            //$('.content_bottomListWrapper').toggleClass('fixed'); // コンテンツ固定

            if ($('.iconLayerFix').hasClass('arrowFix')) {
                $('.iconLayerFix').removeClass('arrowFix').addClass('hamburgerFix'); // ハンバーガーメニューに
            } else { // それ以外なら
                $('.iconLayerFix').removeClass('hamburgerFix').addClass("arrowFix");
            }
            $('.menuFix').css({
                'top': $('.fix_Nav').height() + 'px'
            });
            return false;
        });
    }
}