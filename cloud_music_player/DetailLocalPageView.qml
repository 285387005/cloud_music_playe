// DetailLocalPageView

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import Qt.labs.platform 1.0
import QtMultimedia 5.12
import Qt.labs.settings 1.1
import QtQml 2.12

ColumnLayout{

    Settings{
        id: localSettings
        fileName: "conf/local.ini"
    }

    Rectangle{

        Layout.fillWidth: true
        width: parent.width
        height: 60
        color: "#00000000"

        Text {
            x:10
            verticalAlignment: Text.AlignBottom
            text: qsTr("本地音乐")
            font.family: window.mFONT_FAMILY
            font.pointSize: 25
            color: window.mTEXT_COLOR
        }
    }

    RowLayout{ // 按钮
        height: 80
        Item{
            width: 5
        }

        MusicTextBuuton{
            btnText: "添加本地音乐"
            btnWidth: 200
            btnHeight: 50
            onClicked:fileDialog.open()
        }
        MusicTextBuuton{
            btnText: "刷新记录"
            btnWidth: 120
            btnHeight: 50
            onClicked: getlocal()
        }
        MusicTextBuuton{
            btnText: "清空记录"
            btnWidth: 120
            btnHeight: 50
            onClicked: saveLocal()
        }
    }

    MusicListView{ // 播放列表
        id:localListView
        onDeleteItem: deleteLocal(index)
    }

    Component.onCompleted: {
        getlocal()
    }

    function getlocal(){
        var list = localSettings.value("local",[])
        localListView.musicList = list
        return list
    }

    function saveLocal(list = []){
        localSettings.setValue("local",list)
        getlocal()
    }

    function deleteLocal(index){
        var list = localSettings.value("local",[])
        if(list.length<index+1) return
        list.splice(index,1)
        saveLocal(list)
    }

    FileDialog{
        id:fileDialog
        fileMode: FileDialog.OpenFiles
        nameFilters: ["MP3 Music Files(*.mp3)","FLAC Music Files(*.flac)"]
        folder: StandardPaths.standardLocations(StandardPaths.MusicLocation)[0]
        acceptLabel: "确定"
        rejectLabel: "取消"

        onAccepted: {
            var list = getlocal()
            for(var index in files){
                var path = files[index]
                var name = "歌名"
                var artist = "歌手"
                var timelen = "时长"
                var lyrics = "歌词"

                if (musicMetadata.getMetadata(path).title && musicMetadata.getMetadata(path).artist) {
                    name = musicMetadata.getMetadata(path).title
                    artist = musicMetadata.getMetadata(path).artist
                    lyrics = musicMetadata.getMetadata(path).lyrics
                    timelen = musicMetadata.getMetadata(path).time
                }
                var to_mm = parseInt(timelen/1000/60)+"" // 结束分
                to_mm = to_mm.length<2?"0"+to_mm:to_mm
                var to_ss = parseInt(timelen/1000%60)+"" // 结束秒
                to_ss = to_ss.length<2?"0"+to_ss:to_ss
                var timeText = ""+to_mm+":"+to_ss+"" // 结束时间

                if(list.filter(item=>item.id === path).length<1)
                    list.push({
                                  id:path +"",
                                  name:name,
                                  artist:artist,
                                  url:path +"",
                                  album:"本地音乐",
                                  lyrics:"",
                                  time:timeText,
                                  type:"1" // 1表示本地 0表示网络
                              })

                saveLocal(list)
            }
        }
    }
}
