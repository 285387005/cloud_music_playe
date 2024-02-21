// App

import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import MyUtils 1.0
import MusicMetadata 1.0
import QtMultimedia 5.12
import Qt.labs.settings 1.1
import QtGraphicalEffects 1.0

ApplicationWindow {

    id:window

    property int mWINDOW_WIDTH: 1200
    property int mWINDOW_HEIGHT: 800

    property string mFONT_FAMILY: "微软雅黑"
    property string mTEXT_COLOR: "#1B1B1B" //"#eeffffff"

    visible: true //窗口显示
    width: mWINDOW_WIDTH
    height: mWINDOW_HEIGHT
    title: qsTr("Music Player")

    background:Background{
        id:appBackground
    }

    flags: Qt.Window|Qt.FramelessWindowHint

    AppSystemTrayIcon{

    }

    HttpUtils{
        id:httpUtils
    }

    MusicMetadata{
        id:musicMetadata
    }

    Settings{
        id:settings
        fileName: "sonf/settings.ini"
    }

    Settings{
        id: historySettings
        fileName: "conf/history.ini"
    }

    Settings{
        id: favoriteSettings
        fileName: "conf/favorite.ini"
    }

    Settings{
        id:lastPlaySettings
        fileName: "conf/lastPlay.ini"
    }

    ColumnLayout{ // 框架布局
        anchors.fill:parent
        spacing: 0

        LayoutHeaderView{ // 头
            id:layoutHeaderView
        }

        PageHomeView{ // 左侧列表
            id:pageHomeView
        }

        PageDetailView{ // 播放歌曲详情页面
            id:pageDetailView
            visible: false
        }

        Item{
            id:baffle
            width: window.width
            height: 115

            LayoutBottomViewTest{ // 底部
                id:layoutBottomView
            }
        }

    }

    // 鼠标悬停时放大图片
    /*MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        propagateComposedEvents: true // 允许事件穿透
        onEntered: {
            appBackground.isbar = true
            appBackground.scaleAnimationToRunning = true
            appBackground.scaleAnimationFromRunning = false
        }
        onExited: {
            appBackground.isbar = false
            appBackground.scaleAnimationToRunning = false
            appBackground.scaleAnimationFromRunning = true
        }
    }*/

    MediaPlayer{ // 播放功能
        id: mediaPlayer

        property var times: []

        onPositionChanged: {
            layoutBottomView.setSlider(0,duration,position)

            if(times.length>0){
                var count = times.filter(time=>time<position).length
                pageDetailView.current = count === 0?0:count-1
            }

        }

        onPlaybackStateChanged: {
            layoutBottomView.playingState = playbackState === MediaPlayer.PlayingState?1:0
            if(playbackState == MediaPlayer.StoppedState&&layoutBottomView.playbackStateChangeCallbackEnabled)
            {
                layoutBottomView.playNext()
            }
        }
    }



}
