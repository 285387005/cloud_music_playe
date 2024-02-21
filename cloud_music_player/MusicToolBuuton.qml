import QtQuick 2.12
import QtQuick.Controls 2.5

ToolButton{
    property string iconSoure: ""
    property string toolTip: ""

    property bool isCheckable: false
    property bool isChecked: false

    id:self

    icon.source: iconSoure

    ToolTip.visible: hovered //用户将鼠标悬停在相关元素上时显示工具提示
    ToolTip.text: toolTip// 气泡提示框

    background: Rectangle{
        color: self.down||(isCheckable&&self.checked)?"#eeeeee":"#00000000"
    }
    icon.color: self.down||(isCheckable&&self.checked)?"#00000000":"#eeeeee"

    checkable: isCheckable // 控件是否可以被选中（checked）或取消选中
    checked: isChecked
}
