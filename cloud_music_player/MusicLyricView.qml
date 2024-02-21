// MusicLyricView

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import QtQml 2.12
import QtQuick.Shapes 1.12

Rectangle {
    id:lyricView

    property alias lyrics: list.model
    property alias current: list.currentIndex

    Layout.preferredHeight: parent.height*0.8
    Layout.alignment: Qt.AlignHCenter

    clip: true
    color: "#00000000"

    ListView{
        id:list
        anchors.fill:parent
        model: ["暂无歌词","",""]
        delegate: listDelegate
        highlight: Rectangle{
            color: "#2073a7db"
            radius: 5
        }
        highlightMoveDuration: 0
        highlightResizeDuration: 0
        currentIndex: 0
        preferredHighlightBegin: parent.height/2-50
        preferredHighlightEnd:parent.height/2
        highlightRangeMode: ListView.StrictlyEnforceRange

        // 根据播放时间自动滚动到对应的歌词项
//        onCurrentIndexChanged: {
//            // 根据播放时间计算当前播放到的歌词项
//            var currentTime = mediaPlayer.position;
//            var index = findLyricIndex(currentTime);
//            currentIndex = index;
//        }
    }

    Component{
        id:listDelegate

        Item {
            id: delegateItem
            width: parent.width
            height: 50
            Text{
                text:modelData
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                color: index==list.currentIndex?"black":"#505050"
                font{
                    family: window.mFONT_FAMILY
                    pointSize: index==list.currentIndex ? 14 : 12
                    weight: index==list.currentIndex ? Font.Bold : Font.Normal
                }
            }
            states: State{
                when:delegateItem.ListView.isCurrentItem
                PropertyChanges {
                    target: delegateItem
                    scale:1

                }
            }
            MouseArea{
                anchors.fill:parent
                onClicked: list.currentIndex = index
            }
        }
    }
}
