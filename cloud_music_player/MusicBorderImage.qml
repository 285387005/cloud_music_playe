// MusicBorderImage

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0

Rectangle {

    property string imgSrc: "qrc:/images/player.jpg"
    property int borderRadius: 5
    property bool isRotating: false
    property real rotationAngel: 0.0

    radius: borderRadius

    gradient: Gradient{
        GradientStop{
            position: 0.0
            color: "#101010"
        }
        GradientStop{
            position: 0.5
            color: "#a0a0a0"
        }
        GradientStop{
            position: 1.0
            color: "#505050"
        }
    }

    Image {
        id:image
        anchors.centerIn: parent
        source: imgSrc
        smooth: true // 平滑度
        visible: false
        width: parent.width*0.9
        height: parent.height*0.9
        fillMode: Image.PreserveAspectCrop // 保持长宽比裁剪
        antialiasing: true // 抗锯齿
        asynchronous: true
    }

    Rectangle{
        id:mask
        color: "black"
        anchors.fill: parent
        radius: borderRadius
        visible: false
        smooth: true
        antialiasing: true // 抗锯齿
    }

    OpacityMask{// 不透明度遮罩效果
        id:maskImage
        anchors.fill: image
        source: image
        maskSource: mask // 应用于mask上
        visible: true
        antialiasing: true
    }

    NumberAnimation{ // 旋转效果
        running: isRotating
        loops: Animation.Infinite
        target: maskImage
        from: rotationAngel
        to:360+rotationAngel
        property: "rotation"
        duration: 60000 // 时间
        onStopped: {
            rotationAngel = maskImage.rotation
        }

    }
}
