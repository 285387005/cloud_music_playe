import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQuick.Window 2.12

ToolBar{// 顶部工具栏
    background: Rectangle{ //Rectangle 是一种基本的绘图元素，用于绘制矩形区域，通常用作背景或者填充效果。
        color: "#00000000"
    }

    property point point: Qt.point(x,y)
    property bool quitWindowMode: false
    property bool isSmallWindow: false // 小窗播放

    width: parent.width
    Layout.fillWidth: true
    RowLayout{

        anchors.fill: parent

        MusicToolBuuton{
            icon.source: "qrc:/images/music.png"
            toolTip: "关于"
            onClicked: {
                aboutPop.open()
            }
        }
        MusicToolBuuton{
            icon.source: "qrc:/images/about.png"// 资源文件
            toolTip: "网易云"
        }
        MusicToolBuuton{
            id: minWindow
            icon.source: "qrc:/images/small-window.png"// 资源文件
            toolTip: "小窗播放"
            visible: !isSmallWindow
            onClicked: {
                setWindowSize(330,650)
                pageHomeView.visible = false
                pageDetailView.visible = true
                isSmallWindow = true
            }
        }
        MusicToolBuuton{
            id:maxWindow
            icon.source: "qrc:/images/exit-small-window.png"// 资源文件
            toolTip: "退出小窗播放"
            visible: isSmallWindow
            onClicked: {
                setWindowSize()
                isSmallWindow = false
            }
        }
        Item {
            Layout.fillWidth:true
            height: 32
            Text {
                anchors.centerIn: parent// 居中继承父类
                text: qsTr("网易云")
                font.family: window.mFONT_FAMILY
                font.pointSize: 15
                color: "#ffffff"
            }
            MouseArea{
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                onPressed: setPoint(mouseX,mouseY)
                onMouseXChanged: moveX(mouseX)
                onMouseYChanged: moveY(mouseY)
            }
        }
        MusicToolBuuton{
            icon.source: "qrc:/images/minimize-screen.png"
            toolTip: "最小化"
            onClicked: {
                window.hide()
            }
        }
        MusicToolBuuton{
            id:resize
            icon.source: "qrc:/images/small-screen.png"
            toolTip: "退出全屏"
            visible: false
            onClicked: {
                window.visibility = Window.AutomaticVisibility
                setWindowSize()
                resize.visible = false
                maximize.visible = true
            }

        }
        MusicToolBuuton{
            id:maximize
            icon.source: "qrc:/images/full-screen.png"
            toolTip: "全屏"
            onClicked: {
                window.visibility = Window.Maximized
                resize.visible = true
                maximize.visible = false
                isSmallWindow = false
            }

        }
        MusicToolBuuton{
            icon.source: "qrc:/images/power.png"
            toolTip: "退出"
            onClicked: {
                Qt.quit()
            }
        }
    }

    Popup{
        id:aboutPop

        parent: Overlay.overlay
        x:(parent.width-width)/2
        y:(parent.height-height)/2

        width: 250
        height: 230

        background: Rectangle{
            color: "#e9f4ff"
            radius: 5
            border.color:"#2273a7ab"
        }

        contentItem: ColumnLayout{
            width: 100
            height: 100
            Layout.alignment: Qt.AlignHCenter
            Image{
                Layout.preferredHeight: 60
                fillMode: Image.PreserveAspectFit
                Layout.fillWidth: true
                source: "qrc:/images/music.png"
            }

            Text {
                text: qsTr("网易云")
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 18
                color: "#8573a7ab"
                font.family: window.mFONT_FAMILY
                font.bold: true
            }
            Text {
                text: qsTr("这是仿写网易云")
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 18
                color: "#8573a7ab"
                font.family: window.mFONT_FAMILY
                font.bold: true
            }
            Text {
                text: qsTr("www.wangyiyun.com")
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 18
                color: "#8573a7ab"
                font.family: window.mFONT_FAMILY
                font.bold: true
            }
        }
    }

    function setWindowSize(width = window.mWINDOW_WIDTH,height = window.mWINDOW_HEIGHT)
    {
        window.height = height
        window.width = width
        window.x = (Screen.desktopAvailableWidth-window.width)/2
        window.y = (Screen.desktopAvailableHeight-window.height)/2
    }

    function setPoint(mouseX = 0,mouseY = 0){
        point = Qt.point(mouseX,mouseY)
    }

    function moveX(mouseX = 0){
        var x = window.x+mouseX-point.x
        if(quitWindowMode&&!isSmallWindow){
            window.x = (Screen.desktopAvailableWidth-window.width)/2
            quitWindowMode = false
            mouseX = mouseX-window.x
            point.x = point.x-window.x
            return
        }
        if(isSmallWindow&&x<=0)
        {
            window.x = 0
            return
        }
        if(isSmallWindow&&x>=Screen.desktopAvailableWidth-window.width)
        {
            window.x = Screen.desktopAvailableWidth-window.width
            return
        }
        window.x = x
    }

    function moveY(mouseY = 0){
        var y = window.y+mouseY-point.y
        if(y<=0&&mouseY<=0&&!isSmallWindow)
        {
            window.visibility = Window.Maximized
            resize.visible = true
            maximize.visible = false
            isSmallWindow = false
            window.x = 0
            window.y = 0
            return
        }
        if(y<=0) y = 0
        if(y>0&&window.visibility===Window.Maximized&&!isSmallWindow)
        {
            window.visibility = Window.AutomaticVisibility
            window.width = window.mWINDOW_WIDTH
            window.x = (Screen.desktopAvailableWidth-window.width)/2
            window.height = window.mWINDOW_HEIGHT
            quitWindowMode = true
            resize.visible = false
            maximize.visible = true
        }

        if(y>Screen.desktopAvailableHeight-50) y = Screen.desktopAvailableHeight-50
        window.y = y
    }
}
