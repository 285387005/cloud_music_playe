// DetailRecommendPageView

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

ScrollView {

    // 声明一个自定义信号，用于通知请求完成
    signal requestCompleted();

    clip: true // 子类元素超出父类元素大小自动进行裁剪
    ScrollBar.vertical.visible: false
    ColumnLayout{
        Rectangle{

            Layout.fillWidth: true
            width: parent.width
            height: 60
            color: "#00000000"

            Text {
                x:10
                verticalAlignment: Text.AlignBottom
                text: qsTr("推荐内容")
                font.family: window.mFONT_FAMILY
                font.pointSize: 25
                color: window.mTEXT_COLOR
            }
        }


        MusicBannerView{
            id: bannerView
            Layout.preferredWidth: window.width-200
            Layout.preferredHeight: (window.width-200)*0.3
            Layout.fillWidth: true
            Layout.fillHeight: true

        }

        Rectangle{

            Layout.fillWidth: true
            width: parent.width
            height: 60
            color: "#00000000"

            Text {
                x:10
                verticalAlignment: Text.AlignBottom
                text: qsTr("热门歌单")
                font.family: window.mFONT_FAMILY
                font.pointSize: 25
                color: window.mTEXT_COLOR
            }
        }

        MusicGridHotView{
            id:hotView
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: (window.width-250)*0.2*4+140
            Layout.bottomMargin: 20
        }

        Rectangle{

            Layout.fillWidth: true
            width: parent.width
            height: 60
            color: "#00000000"

            Text {
                x:10
                verticalAlignment: Text.AlignBottom
                text: qsTr("新歌推荐")
                font.family: window.mFONT_FAMILY
                font.pointSize: 25
                color: window.mTEXT_COLOR
            }
        }

        MusicGridLatestView{
            id:latestView
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: (window.width-230)*0.1*10+20
            Layout.bottomMargin: 20
        }

    }

    Component.onCompleted: {
        getBannerList()
    }

    function getBannerList(){ // 获取轮播图

        function onReply(reply){
            httpUtils.onReplySignal.disconnect(onReply)
            var banners = JSON.parse(reply).banners
            bannerView.bannerList = banners
            getHotList()
        }

        httpUtils.onReplySignal.connect(onReply)// onReplySignal是HttpUtils中的信号前加了on首字母大写
        httpUtils.connet("banner")
    }

    function getHotList(){ // 获取热门歌单

        function onReply(reply){
            httpUtils.onReplySignal.disconnect(onReply)
            var playlists = JSON.parse(reply).playlists
            hotView.list = playlists
            getLatestList()
        }

        httpUtils.onReplySignal.connect(onReply)// onReplySignal是HttpUtils中的信号前加了on首字母大写
        httpUtils.connet("top/playlist/highquality?limit=20")
    }

    function getLatestList(){ // 获取新出歌曲

        function onReply(reply){
            httpUtils.onReplySignal.disconnect(onReply)
            var latestList = JSON.parse(reply).data
            latestView.list = latestList.slice(0,30)

            // 请求完成后发出自定义信号
            requestCompleted();
        }

        httpUtils.onReplySignal.connect(onReply)// onReplySignal是HttpUtils中的信号前加了on首字母大写
        httpUtils.connet("top/song")
    }

    onRequestCompleted: {
        console.log("加载完成")
        layoutBottomView.current = 0
    }
}
