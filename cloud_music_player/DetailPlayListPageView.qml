// DetailPlayListPageView 播放列表

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

ColumnLayout{

    property string targetId: ""
    property string targetType: "10" // ablum,playlist/detail
    property string name: ""
    //property string time: ""

    onTargetIdChanged:{
        if(targetType == "10")loadAlbum()
        else if(targetType == "1000")loadPlayList()
    }

    Rectangle{

        Layout.fillWidth: true
        width: parent.width
        height: 60
        color: "#00000000"

        Text {
            x:10
            verticalAlignment: Text.AlignBottom
            text: qsTr(targetType=="10"?"专辑":"歌单")
            font.family: window.mFONT_FAMILY
            font.pointSize: 25
            color: window.mTEXT_COLOR
        }
    }

    RowLayout{
        height: 200
        width: parent.width
        MusicRoundImage{
            id:playListCover
            width: 180
            height: 180
            Layout.leftMargin: 15
        }
        Item{
            Layout.fillWidth: true
            height: parent.height

            Text{
                id:playListDesc
                width: parent.width*0.95
                anchors.centerIn: parent
                wrapMode: Text.WrapAnywhere // 表示文本将在任何地方换行，以适应可用的宽度
                font.family: window.mFONT_FAMILY
                font.pointSize: 14
                maximumLineCount: 4 // 这个属性限制文本显示的最大行数
                elide: Text.ElideRight // 表示当文本溢出最大行数时，将省略文本的右侧部分
                lineHeight: 1.5 // 这个属性设置了文本的行高
                color: window.mTEXT_COLOR
            }
        }
    }

    MusicListView{
        id:playListView
        deletable: false
    }

    function loadAlbum(){ // 获取专辑信息

        var url = "ablum?id="+(targetId.length<1?"32311":targetId)

        function onReply(reply){
            httpUtils.onReplySignal.disconnect(onReply)
            var album = JSON.parse(reply).album
            var songs = JSON.parse(reply).songs
            playListCover.imgSrc = album.blurPicUrl
            playListDesc.text = album.description
            name = album.name
            playListView.musicList = songs.map(item=>{
                                                   var timelen = item.al.dt
                                                   var to_mm = parseInt(timelen/1000/60)+"" // 结束分
                                                   to_mm = to_mm.length<2?"0"+to_mm:to_mm
                                                   var to_ss = parseInt(timelen/1000%60)+"" // 结束秒
                                                   to_ss = to_ss.length<2?"0"+to_ss:to_ss
                                                   var timeText = ""+to_mm+":"+to_ss+"" // 结束时间
                                                   return {
                                                        id:item.id,
                                                        name:item.name,
                                                        artist:item.ar[0].name,
                                                        album:item.al.name,
                                                        cover:item.al.picUrl,
                                                        time:timeText
                                                    }
                                               })
        }

        httpUtils.onReplySignal.connect(onReply)
        httpUtils.connet(url)
    }


    function loadPlayList(){ // 获取歌单详情

        var url = "playlist/detail?id="+(targetId.length<1?"32311":targetId)

        function onSongDeatilReply(reply){
            httpUtils.onReplySignal.disconnect(onSongDeatilReply)
            var songs = JSON.parse(reply).songs
            playListView.musicList = songs.map(item=>{
                                                   var timelen = item.dt
                                                   var to_mm = parseInt(timelen/1000/60)+"" // 结束分
                                                   to_mm = to_mm.length<2?"0"+to_mm:to_mm
                                                   var to_ss = parseInt(timelen/1000%60)+"" // 结束秒
                                                   to_ss = to_ss.length<2?"0"+to_ss:to_ss
                                                   var timeText = ""+to_mm+":"+to_ss+"" // 结束时间
                                                   return {
                                                        id:item.id,
                                                        name:item.name,
                                                        artist:item.ar[0].name,
                                                        album:item.al.name,
                                                        cover:item.al.picUrl,
                                                        time:timeText
                                                    }
                                               })
        }

        function onRely(reply){
            httpUtils.onReplySignal.disconnect(onRely)
            var playlist = JSON.parse(reply).playlist
            playListCover.imgSrc = playlist.coverImgUrl
            playListDesc.text = playlist.description
            name = playlist.name

            var ids = playlist.trackIds.map(item=>item.id).join(",")

            httpUtils.onReplySignal.connect(onSongDeatilReply)
            httpUtils.connet("song/detail?ids="+ids)

        }

        httpUtils.onReplySignal.connect(onRely)// onReplySignal是HttpUtils中的信号前加了on首字母大写
        httpUtils.connet(url)
    }
}
