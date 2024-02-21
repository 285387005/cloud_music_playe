// PageHomeView

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQml 2.12


RowLayout{

    property int defaultIndex: 0

    property var qmlList: [
    {icon:"recommend-white.png",value:"推荐内容",qml:"DetailRecommendPageView",menu:true},
    {icon:"cloud-white.png",value:"搜索音乐",qml:"DetailSearchPageView",menu:true},
    {icon:"local-white.png",value:"本地音乐",qml:"DetailLocalPageView",menu:true},
    {icon:"history-white.png",value:"播放历史",qml:"DetailHistoryPageView",menu:true},
    {icon:"favorite-big-white.png",value:"我喜欢的",qml:"DetailFavoritePageView",menu:true},
    {icon:"",value:"",qml:"DetailPlayListPageView",menu:false}
    ]

    spacing: 0

    Frame {// 左侧工具栏


        Layout.preferredWidth: 200
        Layout.fillHeight: true
        background: Rectangle{
            color: "#0000AAAA"
        }
        padding: 0

        ColumnLayout{

            anchors.fill: parent

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 150 // 首选填充高度
                MusicBorderImage {  // 头像
                    imgSrc: "https://p1.music.126.net/KDOYYZ7Xy2yQHqO4xnzyRg==/109951167720529273.jpg"
                    anchors.centerIn: parent
                    height: 100
                    width: 100
                    borderRadius: 100
                    isRotating: layoutBottomView.playingState===1
                }
            }

            ListView{
                id:menuView
                height: parent.height
                Layout.fillHeight: true
                Layout.fillWidth: true
                model: ListModel{
                    id:menuViewModel
                }
                delegate: menuViewDelegate
                highlight: Rectangle{
                    color: "#0073a7ab"
                }
                highlightMoveDuration: 0 // 菜单栏切换过渡时间
                highlightResizeDuration: 0 // 菜单栏高度变形时间
            }
        }


        Component{
            id:menuViewDelegate
            Rectangle{
                id:menuViewDelegateItem
                height: 50
                width: 200
                color: "#00000000"
                RowLayout{

                    anchors.fill: parent
                    anchors.centerIn: parent
                    spacing: 15
                    Item {
                        width: 30
                    }

                    Image{
                        source: "qrc:/images/"+icon
                        Layout.preferredWidth: 20
                        Layout.preferredHeight: 20
                    }

                    Text {
                        id:onhover
                        text: value
                        Layout.fillWidth: true
                        height: 50
                        font.family: window.mFONT_FAMILY
                        font.weight: menuViewDelegateItem.ListView.view.currentIndex === index?Font.ExtraBold:Font.Normal
                        font.pixelSize: 18
                        color: "#ffffff"
                    }
                }

                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: {
                        onhover.y = 16
                    }
                    onExited: {
                        onhover.y = 15
                    }
                    onClicked: {
                        hidePlayList()
                        repeater.itemAt(menuViewDelegateItem.ListView.view.currentIndex).visible = false
                        // 处于当前高亮的索引
                        menuViewDelegateItem.ListView.view.currentIndex = index
                        var loader =  repeater.itemAt(index)
                        loader.visible = true
                        loader.source = qmlList[index].qml+".qml"
                    }
                }
            }

        }
        Component.onCompleted: {
            menuViewModel.append(qmlList.filter(item=>item.menu))

            var loader =  repeater.itemAt(defaultIndex) // 默认页面
            loader.visible = true
            loader.source = qmlList[defaultIndex].qml+".qml" // 默认页面

            menuView.currentIndex = defaultIndex
        }
    }

    Repeater{
        id:repeater
        model: qmlList.length

        Loader {
            visible: false
            Layout.fillWidth: true
            Layout.fillHeight: true

        }
    }

    function showPlayList(targetId="",targetType = "10"){
        repeater.itemAt(menuView.currentIndex).visible = false
        var loader =  repeater.itemAt(5)// 处于当前高亮的索引
        loader.visible = true
        loader.source = qmlList[5].qml+".qml"
        loader.item.targetType = targetType
        loader.item.targetId = targetId
    }
    function hidePlayList(){
        repeater.itemAt(menuView.currentIndex).visible = true
        // 处于当前高亮的索引
        var loader =  repeater.itemAt(5)
        loader.visible = false
    }

}
