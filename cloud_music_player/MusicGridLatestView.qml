// MusicGridLatestView

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQml 2.12

Item{

    property alias list: gridRepeater.model

    Grid{
        id:gridLayout
        anchors.fill: parent
        columns: 3
        Repeater{
            id:gridRepeater
            Frame{
                padding: 5
                width: parent.width*0.333333
                height: parent.width*0.1
                background: Rectangle{
                    id:background
                    color: "#00000000"
                }
                clip: true

                MusicRoundImage{
                    id:img
                    width: parent.width*0.25
                    height: parent.width*0.25
                    imgSrc: modelData.album.picUrl
                }

                Text {
                    id:name
                    anchors{
                        left: img.right
                        top: parent.top
                        topMargin: 10
                        //verticalCenter: parent.horizontalCenter
                        //bottomMargin: 10
                        leftMargin: 5
                    }
                    text:modelData.name
                    font.family: window.mFONT_FAMILY
                    font.pointSize: 12
                    height: 20
                    width: parent.width*0.72
                    elide: Qt.ElideRight // 属性定义了文本溢出时如何处理，省略文本的中间部分，显示开头、省略号和末尾
                    color: window.mTEXT_COLOR
                }

                Text {
                    anchors{
                        left: img.right
                        top: name.bottom
                        topMargin: 20
                        leftMargin: 5
                    }
                    text:modelData.artists[0].name
                    font.family: window.mFONT_FAMILY
                    font.pointSize: 8
                    height: 20
                    width: parent.width*0.72
                    elide: Qt.ElideRight // 属性定义了文本溢出时如何处理，省略文本的中间部分，显示开头、省略号和末尾
                    color: window.mTEXT_COLOR
                }

                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered: {
                        background.color = "#50000000"
                    }
                    onExited: {
                        background.color = "#00000000"
                    }
                    onDoubleClicked: { // 新歌单曲播放
                        var targetId = modelData.id+""
                        var name = modelData.name+""
                        var artist = modelData.artists[0].name+""
                        var album = modelData.album.name+""
                        var timelen = modelData.duration
                        var to_mm = parseInt(timelen/1000/60)+"" // 结束分
                        to_mm = to_mm.length<2?"0"+to_mm:to_mm
                        var to_ss = parseInt(timelen/1000%60)+"" // 结束秒
                        to_ss = to_ss.length<2?"0"+to_ss:to_ss
                        var timeText = ""+to_mm+":"+to_ss+"" // 结束时间
                        layoutBottomView.current = -1
                        layoutBottomView.playList = [{id:targetId,name:name,artist:artist,cover:"",album:album,time:timeText}]
                        layoutBottomView.current = 0
                    }
                }
            }
        }
    }
}
