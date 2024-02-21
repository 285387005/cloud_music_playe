import QtQuick 2.12
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0

Item {

    property string imgSrc: "qrc:/images/player.jpg"

    property int borderRadius: 5

    Image {
        id:image
        anchors.centerIn: parent
        source: imgSrc
        smooth: true // 平滑度
        visible: false
        width: parent.width
        height: parent.height
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
        anchors.fill: image
        source: image
        maskSource: mask // 应用于mask上
        visible: true
        antialiasing: true
    }
}
