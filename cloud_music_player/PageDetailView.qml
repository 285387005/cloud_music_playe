// PageDetailView

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQml 2.12

Item {
    Layout.fillWidth: true
    Layout.fillHeight: true

    property alias lyrics: lyricsView.lyrics
    property alias current: lyricsView.current

//    Rectangle{
//        color: "#50f3a7db"
//    }
    RowLayout{
        anchors.fill: parent
        Frame{
            Layout.preferredWidth:!layoutHeaderView.isSmallWindow?parent.width*0.5:330
            Layout.minimumHeight: 650
            Layout.minimumWidth: 330

            background: Rectangle{
                color: "#00000000"
            }

            Text {
                id: name
                text: layoutBottomView.musicName
                //width: parent.width
                anchors{
                    bottom: artist.top
                    bottomMargin: 20
                    horizontalCenter: parent.horizontalCenter
                }
                font{
                    family: mFONT_FAMILY
                    pointSize: 16
                }
                elide: Qt.ElideMiddle
            }
            Text {
                id: artist
                text: layoutBottomView.musicArtist
                //width: parent.width
                anchors{
                    bottom: coverMusic.top
                    bottomMargin: 20
                    topMargin: 20
                    horizontalCenter: parent.horizontalCenter
                }
                font{
                    family: mFONT_FAMILY
                    pointSize: 14
                }
                elide: Qt.ElideMiddle
            }

            MusicBorderImage{ // 音乐播放片
                id: coverMusic
                anchors.centerIn: parent
                anchors.verticalCenterOffset: !layoutHeaderView.isSmallWindow?0:-50
                width: parent.width*0.7
                height: width
                borderRadius: width
                imgSrc: layoutBottomView.musicCoverImg
                isRotating: layoutBottomView.playingState===1
            }

            Text {
                id: lyric
                visible: layoutHeaderView.isSmallWindow
                text: lyricsView.lyrics[current]?lyricsView.lyrics[current]:"暂无歌词"
                anchors{
                    top: coverMusic.bottom
                    topMargin: 40
                    horizontalCenter: parent.horizontalCenter
                }
                font{
                    family: window.mFONT_FAMILY
                    pointSize: 14
                }
            }
        }

        Frame{ // 歌词界面
            Layout.preferredWidth: parent.width*0.5
            Layout.preferredHeight: parent.height
            visible: !layoutHeaderView.isSmallWindow

            background: Rectangle{
                color: "#00000000"
            }

            MusicLyricView{
                id:lyricsView
                anchors.fill:parent
                visible: !layoutHeaderView.isSmallWindow
            }
        }
    }
}
