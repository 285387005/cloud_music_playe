// MusicTextBuuton

import QtQuick 2.12
import QtQuick.Controls 2.5

Button{
    property alias btnText: self.text

    property alias isCheckable: self.checkable
    property alias isChecked: self.checked

    property alias btnWidth: self.width
    property alias btnHeight: self.height

    id:self

    text:"Button"

    font.family: window.mFONT_FAMILY
    font.pointSize: 14

    background: Rectangle{
        implicitWidth: self.width
        implicitHeight: self.height
        color: self.down||(self.checkable&&self.checked)?"#e2f0f8":"#66e9f4ff"
        radius: self.height/2

    }

    width: 50
    height: 50
    checkable: false // 控件是否可以被选中（checked）或取消选中
    checked: false
}
