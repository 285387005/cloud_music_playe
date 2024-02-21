// PlayListPage

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import QtQml 2.12
import QtQuick.Shapes 1.12
import QtGraphicalEffects 1.0

Frame {
    property var playListMusic: []
    property string timeText: ""
    property int all: 0
    property int current: 0

    signal loadMore(int offset,int current)
    signal deleteItem(int index)

    width: window.width*0.35
    height: window.height*0.7
    padding: 0
    onPlayListMusicChanged: {
        listViewModel.clear()
        listViewModel.append(playListMusic)
    }

    background:Rectangle{
        id:background
        width: parent.width
        height: parent.height
        color: "#00000000"
        border.width: 0
        radius: 25

        Image {
            id: backgroundImage
            source: "qrc:/images/background.png"
            width: parent.width
            height: parent.height
            anchors.fill: parent
            asynchronous: true
            clip: true
            visible: false //因为显示的是OpacityMask需要false
            fillMode: Image.PreserveAspectCrop

            // 高斯模糊效果
            GaussianBlur {
                id: blurEffect
                source: backgroundImage
                radius: 15 // 调整此值以增加或减少模糊程度
                anchors.fill: parent
            }
        }

        //圆角遮罩Rectangle
        Rectangle {
           id: maskRec
           anchors.fill: parent
           width: backgroundImage.width
           height: backgroundImage.height

           color:"#00000000"
           Rectangle {
               anchors.fill: parent
               width: backgroundImage.paintedWidth
               height: backgroundImage.paintedHeight
               color:"black"
               radius: 25
           }
           visible: false //因为显示的是OpacityMask需要false
        }

        //遮罩后的图案
        OpacityMask {
           id: mask
           anchors.fill: backgroundImage
           source: backgroundImage
           maskSource: maskRec
        }
    }

    Item { // 播放列表头
        id:listViewHeader
        Rectangle{
            color: "#00000000"
        }
        anchors.top: parent.top
        height: 75
        width: parent.width
        ColumnLayout{
            width: parent.width
            height: parent.height
            x:10
            Text {
                text: "当前播放"
                topPadding: 10
                Layout.preferredWidth: parent.width
                font.family: window.mFONT_FAMILY
                font.pointSize: 18
                font.weight: Font.Bold
                color: "#000000"
                elide: Qt.ElideRight
            }
            Text {
                text: "总"+layoutBottomView.playList.length+"首"
                topPadding: -5
                leftPadding: 10
                lineHeight: 1.5
                Layout.preferredWidth: parent.width
                font.family: window.mFONT_FAMILY
                font.pointSize: 8
                color: "#f0f0f0"
                elide: Qt.ElideRight
            }
        }
    }
    Rectangle{
        id:underline
        width: parent.width
        anchors.top: listViewHeader.bottom
        height: 1
        color: "#CC0000" // 淡红
    }

    ListView{ // 播放列表
        id: listView
        anchors.top: underline.bottom
        width: parent.width
        height: parent.height-listViewHeader.height-underline.height
        model:ListModel{
            id: listViewModel
        }
        delegate: listViewDelegate

        clip: true

        highlightMoveDuration: 0
        highlightResizeDuration: 0
    }

    Component{ // 播放列表数据
        id:listViewDelegate
        Rectangle{
            id:listViewDelegateItem
            height: 40
            width: listView.width
            MouseArea{
                RowLayout{
                    width: parent.width
                    height: parent.height
                    spacing: 15
                    x: 10
                    Text { // 歌名
                        text:name
                        Layout.preferredWidth: parent.width*0.45
                        font.family: window.mFONT_FAMILY
                        font.pointSize: 10
                        color: layoutBottomView.current === index?"#CC0000":window.mTEXT_COLOR
                        elide: Qt.ElideRight
                        MouseArea{
                            anchors.fill: parent
                            onDoubleClicked: {
                                // 点击事件逻辑
                                layoutBottomView.current = -1
                                layoutBottomView.current = index
                            }
                        }
                    }
                    Text { // 歌手名
                        text:artist
                        Layout.preferredWidth: parent.width*0.30
                        font.family: window.mFONT_FAMILY
                        font.pointSize: 10
                        color: layoutBottomView.current === index?"#CC0000":window.mTEXT_COLOR
                        elide: Qt.ElideRight
                    }
                    Text { // 时长
                        id:timeColor
                        text: time
                        Layout.preferredWidth: parent.width*0.15
                        font.family: window.mFONT_FAMILY
                        font.pointSize: 10
                        color:"#696969"
                        elide: Qt.ElideRight
                    }
                }
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onEntered: {
                    color = "#20000000"
                    radius = 15
                    timeColor.color = "#000000"
                }
                onExited: {
                    color = "#00000000"
                    timeColor.color = "#696969"
                }
                onClicked: {
                    listViewDelegateItem.ListView.view.currentIndex = index
                }
            }
            color: "#00000000"
        }
    }

}
