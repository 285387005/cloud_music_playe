// DetailFavoritePageView

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import Qt.labs.platform 1.0
import QtMultimedia 5.12
import QtQml 2.12

ColumnLayout{

    Rectangle{

        Layout.fillWidth: true
        width: parent.width
        height: 60
        color: "#00000000"

        Text {
            x:10
            verticalAlignment: Text.AlignBottom
            text: qsTr("我喜欢的")
            font.family: window.mFONT_FAMILY
            font.pointSize: 25
            color: window.mTEXT_COLOR
        }
    }

    RowLayout{ // 按钮
        height: 80
        Item{
            width: 5
        }
        MusicTextBuuton{
            btnText: "刷新记录"
            btnWidth: 120
            btnHeight: 50
            onClicked: getFavorite()
        }
        MusicTextBuuton{
            btnText: "清空记录"
            btnWidth: 120
            btnHeight: 50
            onClicked: clearFavorite()
        }
    }

    MusicListView{ // 播放列表
        id:favoriteListView
        favoritable: false
        onDeleteItem: deleteFavorite(index)
    }

    Component.onCompleted: {
        getFavorite()
    }

    function getFavorite(){
        favoriteListView.musicList = favoriteSettings.value("favorite",[])
    }

    function clearFavorite(list = []){
        favoriteSettings.setValue("favorite",[])
        getFavorite()
    }

    function deleteFavorite(index){
        var list = favoriteSettings.value("favorite",[])
        if(list.length<index+1) return
        list.splice(index,1)
        favoriteSettings.setValue("favorite",list)
        getFavorite()
    }
}

