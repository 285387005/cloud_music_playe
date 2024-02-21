// Background

import QtQuick 2.12
import QtGraphicalEffects 1.0

Rectangle {

    property alias backgroundImageSrc: backgroundImage.source
    property alias isbar: bar.visible
    property alias scaleAnimationToRunning: scaleAnimationTo.running
    property alias scaleAnimationFromRunning: scaleAnimationFrom.running
    property alias scaleFactor: backgroundImage.scale

    Image {
        id: backgroundImage
        source: "qrc:/images/background.png"
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
    }

    // 灰色透明遮罩
    Rectangle {
        id:bar
        anchors.fill: parent
        color: "#000000" // 这里设置灰色的颜色
        opacity: 0.1 // 设置遮罩的透明度，根据需要进行调整
        visible: isbar // 根据图片的悬停状态显示/隐藏遮罩
    }

    // 缩放动画
    SequentialAnimation {
        id: scaleAnimationTo
        running: scaleAnimationToRunning
        PropertyAnimation {
            target: backgroundImage
            property: "scale"
            to: 1.2 // 放大图片到 1.2 倍大小
            duration: 300 // 动画持续时间，根据需要进行调整
            easing.type: Easing.InOutQuad // 缓动类型，根据需要进行调整
        }
    }

    SequentialAnimation {
        id: scaleAnimationFrom
        running: scaleAnimationFromRunning
        PropertyAnimation {
            target: backgroundImage
            property: "scale"
            to: 1.0 // 放大图片到 1.2 倍大小
            duration: 300 // 动画持续时间，根据需要进行调整
            easing.type: Easing.InOutQuad // 缓动类型，根据需要进行调整
        }
    }

    // 鼠标悬停时放大图片
    /*MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            scaleAnimationTo.running = true
            scaleAnimationFrom.running = false
            bar.visible = false
            console.log(parent.width,parent.height)
        }
        onExited: {
            scaleAnimationFrom.running = true
            scaleAnimationTo.running = false
            bar.visible = true
        }
    }*/


}
