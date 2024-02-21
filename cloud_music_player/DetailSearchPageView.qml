// DetailSearchPageView

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

ColumnLayout{
    Layout.fillWidth: true
    width: parent.width

    Rectangle{

        Layout.fillWidth: true
        width: parent.width
        height: 60
        color: "#00000000"

        Text {
            x:10
            verticalAlignment: Text.AlignBottom
            text: qsTr("搜索音乐")
            font.family: window.mFONT_FAMILY
            font.pointSize: 25
            color: window.mTEXT_COLOR
        }
    }

    RowLayout{

        Layout.fillWidth: true

        TextField{
            id:searchInput
            font.family: window.mFONT_FAMILY
            font.pointSize: 14
            selectByMouse: true // 允许使用鼠标选中文本
            selectionColor: "#999999" // 设置选中文本的颜色
            placeholderText: "请输入搜索关键词" // 设置文本框中的提示文字
            color: window.mTEXT_COLOR // 文字颜色
            background: Rectangle{
                color: "#00000000"
                opacity: 0.5 // 不透明度
                implicitHeight: 40 // 隐式高度
                implicitWidth: 400 // 隐式宽度
            }

            focus: true // 自动聚焦，使得文本框获得焦点
            Keys.onPressed: if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return)doSearch()
        }

        MusicIconBuuton{
            iconSoure: "qrc:/images/search"
            toolTip: "搜索"
            onClicked: doSearch()
        }
    }

    MusicListView{
        id:musicListView
        deletable: false
        onLoadMore: doSearch(offset,current)
    }

    function doSearch(offset = 0,current = 0){
        var keywords = searchInput.text
        if(keywords.length<1)
            return
        function onReply(reply){
            httpUtils.onReplySignal.disconnect(onReply)
            var result = JSON.parse(reply).result
            musicListView.current = current
            musicListView.all = result.songCount
            musicListView.musicList = result.songs.map(item=>{
                                                           var timelen = item.duration
                                                           var to_mm = parseInt(timelen/1000/60)+"" // 结束分
                                                           to_mm = to_mm.length<2?"0"+to_mm:to_mm
                                                           var to_ss = parseInt(timelen/1000%60)+"" // 结束秒
                                                           to_ss = to_ss.length<2?"0"+to_ss:to_ss
                                                           var timeText = ""+to_mm+":"+to_ss+"" // 结束时间
                                                       return {
                                                            id:item.id,
                                                            name:item.name,
                                                            artist:item.artists[0].name,
                                                            album:item.album.name,
                                                            cover:"",
                                                            time:timeText
                                                        }
                                                    })
        }

        httpUtils.onReplySignal.connect(onReply)// onReplySignal是HttpUtils中的信号前加了on首字母大写
        httpUtils.connet("search?keywords="+keywords+"&offset="+offset+"&limit=60")
        console.log("search?keywords="+keywords+"&offset="+offset+"&limit=60")
    }
}
