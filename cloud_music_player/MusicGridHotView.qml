// MusicGridHotView

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQml 2.12

Item{

    property alias list: gridRepeater.model

    Grid{
        id:gridLayout
        anchors.fill: parent
        columns: 5
        Repeater{
            id:gridRepeater
            Frame{
                padding: 5
                width: parent.width*0.2
                height: parent.width*0.2+30
                background: Rectangle{
                    id:background
                    color: "#00000000"
                }
                clip: true

                MusicRoundImage{
                    id:img
                    width: parent.width
                    height: parent.width
                    imgSrc: modelData.coverImgUrl
                }

                Text {
                    anchors{
                        top:img.bottom
                        horizontalCenter: parent.horizontalCenter
                    }
                    text:modelData.name
                    font.family: window.mFONT_FAMILY
                    font.pointSize: 8
                    height: 30
                    width: parent.width
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    elide: Qt.ElideMiddle // 属性定义了文本溢出时如何处理，省略文本的中间部分，显示开头、省略号和末尾
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
                    onClicked: {
                        var item = gridRepeater.model[index]
                        var ids = item.id
                        pageHomeView.showPlayList(ids,"1000")
                    }
                }
            }
        }
    }
}
