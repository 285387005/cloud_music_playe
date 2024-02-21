// MusicBannerView

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQml 2.12

Frame {

    property alias bannerList: bannerView.model // 属性实例化
    property int current: 0

    background: Rectangle{
        color: "#00000000"
    }

    PathView{
        id:bannerView
        width: parent.width
        height: parent.height
        clip: true //启用剪辑，将内容限制在 PathView 区域内

        delegate: Item {
            id:delegateItem
            width: bannerView.width*0.7
            height: bannerView.height
            z:PathView.z?PathView.z:0
            scale: PathView.scale?PathView.scale:1.0
            MusicRoundImage{
                id: bannerImage
                imgSrc: modelData.imageUrl
                width: delegateItem.width
                height: delegateItem.height
                borderRadius: 10
            }

            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onEntered: {
                    bannerTimer.stop()
                }
                onExited: {
                    bannerTimer.start()
                }
                onClicked: {
                    if(bannerView.currentIndex == index)
                    {
                        var item = bannerView.model[index]
                        var targetId = item.targetId+""
                        var targetType = item.targetType+"" // 1代表单曲 10代表专辑 1000代表歌单
                        switch(targetType){
                        case "1":
                            // 播放歌曲
                            console.log(targetId)
                            //singleMusic(targetId)
                            layoutBottomView.current = -1
                            layoutBottomView.playList = [{id:targetId,name:"",artist:"",cover:"",album:""}]
                            layoutBottomView.current = 0
                            break
                        case "10":
                            // 打开专辑
                            break
                        case "1000":
                            // 打开播放列表
                            pageHomeView.showPlayList(targetId,targetType)
                            break
                        }
                    }
                    else
                    {
                        bannerView. currentIndex =index
                    }
                }
            }

        }

        pathItemCount: 3 // 当前展示的item有几个
        path:bannerPath
        preferredHighlightBegin: 0.5 // 开始第一张为0.5
        preferredHighlightEnd: 0.5 // 结束最后一张为0.5
    }

    Path{
        id:bannerPath
        startX: 0
        startY: bannerView.height/2-10 // 设置路径的起始点

        PathAttribute{name:"z";value:0} // 用于为路径上的不同部分添加属性
        PathAttribute{name:"scale";value:0.6}

        PathLine{ // 定义路径的直线段。
            x:bannerView.width/2
            y:bannerView.height/2-10
        }

        PathAttribute{name:"z";value:2}
        PathAttribute{name:"scale";value:0.9}

        PathLine{
            x:bannerView.width
            y:bannerView.height/2-10
        }

        PathAttribute{name:"z";value:0}
        PathAttribute{name:"scale";value:0.6}
    }

    PageIndicator{
        id: indicator
        anchors{
            top:bannerView.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: -10
        }
        count: bannerView.count
        currentIndex: bannerView.currentIndex
        spacing: 10
        delegate: Rectangle{
            width: 20
            height: 5
            radius: 5
            color: bannerView.currentIndex == index?window.mTEXT_COLOR:"#55ffffff"
            Behavior on color {
                ColorAnimation {
                    duration: 200
                }
            }
            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onEntered: {
                    bannerTimer.stop()
                    bannerView.currentIndex = index
                }
                onExited: {
                    bannerTimer.start()
                }
            }
        }
    }

    Timer{
        id:bannerTimer
        interval: 3000 // 定时时长
        running: true // 默认运行属性
        repeat: true // 重复
        onTriggered: {
            if(bannerView.count>0)
                bannerView.currentIndex = (bannerView.currentIndex+1)%bannerView.count
        }
    }

    function singleMusic(id){
        function onReply(reply){
            httpUtils.onReplySignal.disconnect(onReply)
            var data = JSON.parse(reply).data[0]
            var time = data.time // 音乐时长

        }

        httpUtils.onReplySignal.connect(onReply)// onReplySignal是HttpUtils中的信号前加了on首字母大写
        httpUtils.connet("song/url?id="+id)
    }
}
