// VolumeSlider

import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    property alias volumeValue: volumeSlider.value
    property alias volumeSliderValue: volumeSlider
    width: 30
    height: 120

    Rectangle {
        width: parent.width
        height: parent.height-10 // 增加高度以容纳垂直滑块
        color: "#50ffffff"
        radius: 2

        // 垂直音量滚动条
        Slider {
            id: volumeSlider
            anchors.fill: parent // 填充整个父元素，即垂直滚动条容器
            orientation: Qt.Vertical
            from: 0
            to: 100
            value: 50 // 初始音量值

            // 当滑块值改变时触发的处理函数
            onValueChanged: {
                // 在这里处理音量变化的逻辑
                mediaPlayer.volume = volumeValue/100; // 假设 audioPlayer 是你的音频播放器对象
            }

            background: Rectangle{
                y:volumeSlider.leftPadding
                x:volumeSlider.topPadding+(volumeSlider.availableWidth-width)/2
                width: 8
                height: volumeSlider.availableHeight
                radius: 4
                color: "#EC4141"
                Rectangle{
                    width: parent.width
                    height: volumeSlider.visualPosition*parent.height
                    color: "#808080"
                    radius: 4
                }
            }

            handle: Rectangle{
                y:volumeSlider.leftPadding+(volumeSlider.availableHeight-height)*volumeSlider.visualPosition
                x:volumeSlider.topPadding+(volumeSlider.availableWidth-width)/2
                width: 14
                height: 14
                radius: 7
                color: "#f0f0f0"
                border.color: "#73a7ab"
                border.width: 0.5
            }

            // 捕获滚轮事件，使音量滚动条可以通过滚轮滚动
            MouseArea {
                anchors.fill: parent
                onWheel: {
                    if (wheel.angleDelta.y > 0) {
                        // 向上滚动，增加音量
                        volumeValue = Math.min(volumeValue + 3, volumeSlider.to);
                    } else {
                        // 向下滚动，减少音量
                        volumeValue = Math.max(volumeValue - 3, volumeSlider.from);
                    }
                }
            }
        }
    }
}
