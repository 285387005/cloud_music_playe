// MusicListView

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import QtQml 2.12
import QtQuick.Shapes 1.12

Frame{

    property var musicList: []
    property int all: 0
    property int pageSize: 60
    property int current: 0
    property bool deletable: true
    property bool favoritable: true


    signal loadMore(int offset,int current)
    signal deleteItem(int index)

    onMusicListChanged: {
        listViewModel.clear()
        listViewModel.append(musicList)
    }

    Layout.fillWidth: true
    Layout.fillHeight: true
    clip: true
    spacing: 0
    padding: 0
    background: Rectangle{
        color: "#00000000"
    }

    ListView{
        id: listView
        anchors.fill: parent
        model:ListModel{
            id: listViewModel
        }

        header: listViewHeader
        delegate: listViewDelegate
        footer: pageBotton

        highlight: Rectangle{
            color: "#30f0f0f0"
        }
        highlightMoveDuration: 0
        highlightResizeDuration: 0
    }

    Component{ // 头
        id:listViewHeader
        Rectangle{
            color: "#10a863fa" //播放列表头背景色
            height: 45
            width: listView.width
            RowLayout{
                width: parent.width
                height: parent.height
                spacing: 15
                x: 5
                Text {
                    text: "序号"
                    horizontalAlignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width*0.1
                    font.family: window.mFONT_FAMILY
                    font.pointSize: 13
                    color: "#868686"
                    elide: Qt.ElideRight
                }
                Text {
                    text: "歌名"
                    Layout.preferredWidth: parent.width*0.35
                    font.family: window.mFONT_FAMILY
                    font.pointSize: 13
                    color: "#868686"
                    elide: Qt.ElideRight
                }
                Text {
                    text: "歌手"
                    Layout.preferredWidth: parent.width*0.15
                    font.family: window.mFONT_FAMILY
                    font.pointSize: 13
                    color: "#868686"
                    elide: Qt.ElideRight
                }
                Text {
                    text: "专辑"
                    Layout.preferredWidth: parent.width*0.15
                    font.family: window.mFONT_FAMILY
                    font.pointSize: 13
                    color: "#868686"
                    elide: Qt.ElideRight
                }
                Text {
                    text: "操作"
                    horizontalAlignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width*0.15
                    font.family: window.mFONT_FAMILY
                    font.pointSize: 13
                    color: "#868686"
                    elide: Qt.ElideRight
                }
            }


        }
    }

    Component{ // 搜索数据
        id:listViewDelegate
        Rectangle{
            id:listViewDelegateItem
            height: 45
            width: listView.width

            MouseArea{
                RowLayout{
                    width: parent.width
                    height: parent.height
                    spacing: 15
                    x: 5
                    Text {
                        text: index+1+pageSize*current
                        horizontalAlignment: Qt.AlignHCenter
                        Layout.preferredWidth: parent.width*0.1
                        font.family: window.mFONT_FAMILY
                        font.pointSize: 13
                        color: window.mTEXT_COLOR
                        elide: Qt.ElideRight
                    }
                    Text {
                        text: name
                        Layout.preferredWidth: parent.width*0.35
                        font.family: window.mFONT_FAMILY
                        font.pointSize: 13
                        color: window.mTEXT_COLOR
                        elide: Qt.ElideRight

                        MouseArea{
                            anchors.fill: parent
                            onDoubleClicked: {
                                // 点击事件逻辑
                                layoutBottomView.current = -1
                                layoutBottomView.playList = musicList
                                layoutBottomView.current = index
                            }
                        }
                    }
                    Text {
                        text: artist
                        Layout.preferredWidth: parent.width*0.15
                        font.family: window.mFONT_FAMILY
                        font.pointSize: 13
                        color: window.mTEXT_COLOR
                        elide: Qt.ElideRight
                    }
                    Text {
                        text: album
                        Layout.preferredWidth: parent.width*0.15
                        font.family: window.mFONT_FAMILY
                        font.pointSize: 13
                        color: window.mTEXT_COLOR
                        elide: Qt.ElideRight
                    }

                    Item{
                        Layout.preferredWidth: parent.width*0.15
                        RowLayout{
                            anchors.centerIn: parent
                            MusicIconBuuton{
                                iconSoure: "qrc:/images/pause.png"
                                iconHeight: 16
                                iconWidth: 16
                                toolTip: "播放"
                                onClicked: {
                                    layoutBottomView.current = -1
                                    layoutBottomView.playList = musicList
                                    layoutBottomView.current = index
                                }
                            }
                            MusicIconBuuton{
                                visible:favoritable
                                iconSoure: "qrc:/images/favorite.png"
                                iconHeight: 16
                                iconWidth: 16
                                toolTip: "喜欢"
                                onClicked: {
                                    // 喜欢
                                    layoutBottomView.saveFavorite({
                                                                      id:musicList[index].id,
                                                                      name:musicList[index].name,
                                                                      artist:musicList[index].artist,
                                                                      url:musicList[index].url?musicList[index].url:"",
                                                                      album:musicList[index].album,
                                                                      type:musicList[index].type?musicList[index].type:"0"
                                                                  })
                                }
                            }
                            MusicIconBuuton{
                                visible:deletable
                                iconSoure: "qrc:/images/clear.png"
                                iconHeight: 16
                                iconWidth: 16
                                toolTip: "删除"
                                onClicked:deleteItem(index)
                            }
                        }
                    }
                }
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onEntered: {
                    color = "#30f0f0f0"
                }
                onExited: {
                    // 离开后要变回之前的奇偶色
                    color = (index + 1 + pageSize * current) % 2 === 1 ? "#10f0f0f0" : "#00000000"
                }
                onClicked: {
                    listViewDelegateItem.ListView.view.currentIndex = index
                }
            }
            // 根据索引判断奇偶数，并设置不同的背景颜色
            color: (index + 1 + pageSize * current) % 2 === 1 ? "#10f0f0f0" : "#00000000"
        }
    }

    Component { // 尾 分页
        id:pageBotton
        Rectangle{
            visible: musicList.length!=0&&all!=0
            width: parent.width
            height: 60
            color: "#00000000"
            ButtonGroup{
                buttons: buttons.children
            }
            RowLayout{
                id:buttons
                anchors.centerIn: parent
                Repeater{
                    id:repeater
                    model:all/pageSize>9?9:all/pageSize
                    Button{
                        Text{
                            anchors.centerIn: parent
                            text: modelData+1
                            font.family: window.mFONT_FAMILY
                            font.pointSize: 14
                            color: checked?"#497563":window.mTEXT_COLOR

                        }
                        background: Rectangle{
                            implicitHeight: 30
                            implicitWidth: 30
                            color: checked?"#e2f0f8":"#20e9f4ff" // checked是否选中
                            radius: 30
                        }
                        checkable: true
                        checked: modelData === current
                        onClicked: {
                            if(current===index)
                                return
                            console.log(modelData,current)
                            loadMore(current*pageSize,index)
                        }
                    }
                }
            }
        }
    }

}
