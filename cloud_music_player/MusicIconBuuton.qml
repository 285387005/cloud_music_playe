import QtQuick 2.12
import QtQuick.Controls 2.5

Button{
    property string iconSoure: ""
    property string toolTip: ""

    property bool isCheckable: false
    property bool isChecked: false

    property int iconWidth: 32
    property int iconHeight: 32
    property int iconRadius: iconWidth*1.2/2
    property int iconImplWidth: iconWidth*1.2

    id:self

    padding: 0

    icon.source: iconSoure
    icon.width: iconWidth
    icon.height: iconHeight

    //ToolTip.visible: hovered //用户将鼠标悬停在相关元素上时显示工具提示
    ToolTip.text: toolTip// 气泡提示框

    // 控制 ToolTip 的位置
    ToolTip.toolTip.x: self.width+16
    ToolTip.toolTip.y: self.height+16

    background: Rectangle{
        implicitWidth: iconImplWidth
        implicitHeight: iconImplWidth
        color: self.down||(isCheckable&&self.checked)?"#00497563":"#00e9f4ff"
        radius: iconRadius
    }
    icon.color: self.down||(isCheckable&&self.checked)?"#ffffff":window.mTEXT_COLOR

    onHoveredChanged: {
        if(hovered)
        {
            icon.color = "#EC4141" // 淡红
            ToolTip.visible = true
        }
        else{
            icon.color = window.mTEXT_COLOR
            ToolTip.visible = false
        }
    }

    checkable: isCheckable // 控件是否可以被选中（checked）或取消选中
    checked: isChecked

}
