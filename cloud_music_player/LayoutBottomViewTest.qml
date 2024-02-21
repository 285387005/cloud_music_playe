// layoutBottomView 底部布局窗口

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQml 2.12
import QtMultimedia 5.12
import QtGraphicalEffects 1.0

Frame{// 底部工具栏
    property var playList: []
    property int current: -1
    property int currentIndex: -1

    property int sliderValue: 0
    property int sliderFrom: 0
    property int sliderTo: 100
    property string sliderTime: ""
    property int saveVolume: 0 // 保存静音前的音量

    property int currentPlayMode: 0
    property var playModeList: [{icon:"single-repeat",name:"单曲循环"},
        {icon:"repeat",name:"顺序播放"},
        {icon:"random",name:"随机播放"}]

    property bool playbackStateChangeCallbackEnabled: false

    property string musicName: "歌曲名"
    property string musicArtist: "歌手名"
    property string musicalbum: ""
    property string musicTime: ""
    property string musicCoverImg: "qrc:/images/player"
    property string musicUrl: ""
    property string musicId: ""
    property string musicType: ""

    property int playingState: 0
    property bool volumeState: true // 音量状态
    property bool playListState: true // 播放列表状态
    property real animationDuration: 500 // 音量动画持续时间

    width: window.width-20
    height: 100
    x:10
    y:5
    padding: 0

    background:Rectangle{
        id:barEffect
        color: "#15ffffff"
        border.width: 1
        border.color: "#20000000"
        radius: 10
    }

    RowLayout{
        width: parent.width
        height: parent.height
        Rectangle{
            border.width: 2
            border.color: "red"
        }

        Item { // 播放歌曲信息
            Layout.preferredWidth: parent.width*0.30+60
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.topMargin: 18
            Layout.leftMargin: 18
            visible: !layoutHeaderView.isSmallWindow

            MusicRoundImage{
                id: musicCover
                width: 64
                height: 64
                imgSrc: musicCoverImg
                borderRadius:10
                MouseArea{
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    MusicIconBuuton{
                        id:musicExpand
                        iconSoure: "qrc:/images/expand.png"
                        iconWidth: 60
                        iconHeight: 64
                        visible: false
                        toolTip: "展开音乐详情页面"
                        icon.color: "#ffffff"
                        background:Rectangle{
                            implicitWidth: 64
                            implicitHeight: 64
                            color: "#50000000"
                            radius: 10
                        }
                        onClicked: {
                            pageDetailView.visible = true
                            pageHomeView.visible = false
                        }
                    }
                    MusicIconBuuton{
                        id:musicMerge
                        iconSoure: "qrc:/images/merge.png"
                        iconWidth: 60
                        iconHeight: 64
                        visible: false
                        toolTip: "关闭音乐详情页面"
                        icon.color: "#ffffff"
                        background:Rectangle{
                            implicitWidth: 64
                            implicitHeight: 64
                            color: "#30000000"
                            radius: 10
                        }
                        onClicked: {
                            pageDetailView.visible = false
                            pageHomeView.visible = true
                        }
                    }
                    onEntered: {
                        if(pageHomeView.visible == true)
                            musicExpand.visible = true
                        else
                            musicMerge.visible = true
                    }
                    onExited: {
                        musicExpand.visible = false
                        musicMerge.visible = false
                    }
                }
            }

            Text {// 歌名
                id: songNameText
                anchors.left: musicCover.right
                anchors.leftMargin: 18
                y:5
                width: parent.width*0.7
                text: musicName
                font.family: window.mFONT_FAMILY
                font.pointSize: 12
                font.weight: Font.DemiBold // 加粗
                color: window.mTEXT_COLOR
                elide: Qt.ElideRight
            }

            Text {// 歌手
                id: songerNameText
                anchors.left: musicCover.right
                anchors.top: songNameText.bottom
                anchors.topMargin: 5
                anchors.leftMargin: 18
                width: parent.width*0.7
                text: musicArtist
                font.family: window.mFONT_FAMILY
                font.pointSize: 9
                color: window.mTEXT_COLOR
                elide: Qt.ElideRight
            }
        }

        Item { // 播放时间 居中
            Layout.preferredWidth: parent.width*0.4
            Layout.fillWidth: true
            Layout.topMargin: 30
            //visible: !layoutHeaderView.isSmallWindow

            Text {
                id: startTimeText
                anchors.right: slider.left
                anchors.leftMargin: 5
                visible: !layoutHeaderView.isSmallWindow
                text: "00:00"
                font.family: window.mFONT_FAMILY
                color: window.mTEXT_COLOR
            }

            Text {
                id: endTimeText
                anchors.left: slider.right
                anchors.rightMargin: 5
                visible: !layoutHeaderView.isSmallWindow
                text: musicTime
                font.family: window.mFONT_FAMILY
                color: window.mTEXT_COLOR
            }
            MusicIconBuuton{ // 我喜欢
                id:favorite
                iconSoure: "qrc:/images/favorite.png"
                iconWidth: 24
                iconHeight: 24
                anchors.bottom: slider.top
                anchors.bottomMargin: !layoutHeaderView.isSmallWindow?8:0
                x:!layoutHeaderView.isSmallWindow?slider.width/2-20-50*1-42:130-20-50*1-42
                toolTip: "我喜欢"
                onClicked: saveFavorite(playList[current])
            }

            MusicIconBuuton{ // 上一首
                iconSoure: "qrc:/images/previous.png"
                iconWidth: 32
                iconHeight: 32
                anchors.bottom: slider.top
                anchors.bottomMargin: !layoutHeaderView.isSmallWindow?4:-4
                x:!layoutHeaderView.isSmallWindow?slider.width/2-20-50*1:130-20-50
                toolTip: "上一曲"
                onClicked: playPrevious()
            }
            MusicIconBuuton{ // 播放
                iconSoure: playingState ===0?"qrc:/images/stop.png":"qrc:/images/pause.png"
                iconWidth: 40
                iconHeight: 40
                anchors.bottom: slider.top
                anchors.bottomMargin: !layoutHeaderView.isSmallWindow?0:-8
                x:!layoutHeaderView.isSmallWindow?slider.width/2-20:130-25
                toolTip: playingState===0?"播放":"暂停"
                onClicked:playOrPause()
            }
            MusicIconBuuton{ // 下一首
                iconSoure: "qrc:/images/next.png"
                iconWidth: 32
                iconHeight: 32
                anchors.bottom: slider.top
                anchors.bottomMargin: !layoutHeaderView.isSmallWindow?4:-4
                x:!layoutHeaderView.isSmallWindow?slider.width/2-10+50*1:130+50-20
                toolTip: "下一曲"
                onClicked: playNext("")
            }
            MusicIconBuuton{ // 播放模式
                id: playMode
                iconSoure: "qrc:/images/"+playModeList[currentPlayMode].icon
                iconWidth: 24
                iconHeight: 24
                anchors.bottom: slider.top
                anchors.bottomMargin: !layoutHeaderView.isSmallWindow?8:2
                x:!layoutHeaderView.isSmallWindow?slider.width/2+50*1+42:130+50*1+30
                toolTip: playModeList[currentPlayMode].name
                onClicked: changePlayMode()
            }

            Slider{ // 歌曲播放进度条
                id:slider
                width: parent.width-startTimeText.width-endTimeText.width-10
                Layout.fillWidth: true
                visible: !layoutHeaderView.isSmallWindow
                value: sliderValue
                from: sliderFrom
                to: sliderTo

                onMoved: { // 拖动播放进度条
                    mediaPlayer.seek(value)
                }

                height: 25
                background: Rectangle{
                    id:sliderProgress
                    x:slider.leftPadding
                    y:slider.topPadding+(slider.availableHeight-height)/2
                    width: slider.availableWidth
                    height: 4
                    radius: 2
                    color: "#40000000"
                    Rectangle{
                        id:sliderProgressBar
                        width: slider.visualPosition*parent.width
                        height: parent.height
                        color: "#EC4141"
                        radius: 2
                    }
                }
                handle: Rectangle{
                    id:sliderButton
                    visible: false
                    x:slider.leftPadding+(slider.availableWidth-width)*slider.visualPosition-1
                    y:slider.topPadding+(slider.availableHeight-height)/2
                    width: 14
                    height: 14
                    radius: 7
                    color: "#EC4141"
                    border.color: "#EC4141"
                    border.width: 0.5
                }

                onHoveredChanged: {
                    if(hovered)
                    {
                        sliderButton.visible = true
                        sliderProgress.height = 6
                        sliderProgress.radius = 3
                        sliderProgressBar.radius = 3
                    }
                    else
                    {
                        sliderButton.visible = false
                        sliderProgress.height = 4
                        sliderProgress.radius = 2
                        sliderProgressBar.radius = 2
                    }
                }
            }
        }


        Item { // 右部分
            Layout.preferredWidth: parent.width*0.3
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.rightMargin: 18
            Layout.topMargin: parent.height/2-20
            MusicIconBuuton{ // 音量控制
                id:maxVolume
                iconSoure: volumeState?"qrc:/images/volume.png":"qrc:/images/mute.png"
                iconWidth: !layoutHeaderView.isSmallWindow?40:32
                iconHeight: !layoutHeaderView.isSmallWindow?40:32
                toolTip: volumeState?"静音":"解除静音"
                anchors.right: !layoutHeaderView.isSmallWindow?playListPage.left:parent.right
                anchors.rightMargin: !layoutHeaderView.isSmallWindow?20:0
                onHoveredChanged: {
                    if(hovered)
                        volumecontrol.visible = true
                    else
                        volumecontrol.visible = false
                }
                MouseArea {
                    anchors.fill: parent
                    onWheel: {
                        if (wheel.angleDelta.y > 0) {
                            // 向上滚动，执行增加音量的操作
                            volumecontrol.volumeValue = Math.min(volumecontrol.volumeValue + 3, 100);
                        } else {
                            // 向下滚动，执行减小音量的操作
                            volumecontrol.volumeValue = Math.max(volumecontrol.volumeValue - 3, 0);
                        }
                    }
                    onClicked: {
                        if(volumeState)
                        {
                            volumeState = false
                            saveVolume = volumecontrol.volumeValue
                            volumecontrol.volumeValue = 0
                        }
                        else
                        {
                            volumeState = true
                            volumecontrol.volumeValue = saveVolume
                        }
                    }

                }
                VolumeSlider{
                    id:volumecontrol
                    anchors.bottom: maxVolume.top
                    anchors.horizontalCenter: maxVolume.horizontalCenter
                    visible: false
                }
            }
            MusicIconBuuton{ // 播放列表
                id: playListPage
                iconSoure: "qrc:/images/playListPage.png"
                iconWidth: 32
                iconHeight: 32
                x:parent.width-50
                y:4
                visible: !layoutHeaderView.isSmallWindow
                toolTip: playListState?"播放列表":"关闭列表"
                onClicked: {
                    playListState = !playListState
                }

                PlayListPage{
                    id:playListPagecontrol
                    playListMusic: playList
                    current: current
                    anchors.bottom: playListPage.top
                    //x:-width+rightBoundary.width+35 // 原版
                    x:-width+70
                    //anchors.bottomMargin: 20 // 原版
                    anchors.bottomMargin: 45
                    visible: !playListState
                    onHoveredChanged: {
                        if(hovered)
                            playListPage.ToolTip.visible = false
                        else
                            playListPage.ToolTip.visible = true
                    }
                }
            }
        }
    }




    Component.onCompleted: {
        // 从配置文件中拿到currentPlayMode
        currentPlayMode = settings.value("currentPlayMode",0)
        playList = lastPlaySettings.value("lastPlay",0)
        getLastPlay()
    }

    onCurrentChanged: {
        playbackStateChangeCallbackEnabled = false
        playMusic()
    }

    function saveLastPlay(index = 0){ // 播放缓存
        if(playList.length<index+1) return
        var item = playList[index]
        var lastPlay = lastPlaySettings.value("lastPlay",[])
        if(lastPlay.length>0)
        {
            // 限制三百条数据
            lastPlay.pop()
        }
        var i = lastPlay.findIndex(value=>value.id === item.id)
        if(i>=0)
        {
            lastPlay.splice(i,1)
        }
        lastPlay.unshift({
                            id:item.id+"",
                            name:item.name,
                            artist:item.artist,
                            url:item.url?item.url:"",
                            type:item.type?item.type:"",
                            time:item.time?item.time:"",
                            album:item.album?item.album:"本地音乐",
                            cover:musicCoverImg
                        })

        lastPlaySettings.setValue("lastPlay",lastPlay)
    }

    function getLastPlay(){
        musicId = playList[0].id
        musicName = playList[0].name
        musicCoverImg = playList[0].cover
        musicArtist = playList[0].artist
        musicTime = playList[0].time
        musicUrl = playList[0].url
        musicType = playList[0].type
        musicalbum = playList[0].album
        console.log(playList[0].cover)
    }

    function saveFavorite(value={}){ // 喜欢列表
        var favorite = favoriteSettings.value("favorite",[])
        // 删除重复元素id
        var i = -1
        while(favorite.findIndex(item=>value.id.toString() === item.id)+1){
            i = favorite.findIndex(item=>value.id.toString() === item.id)
            console.log(i)
            if(i>=0)
            {
                favorite.splice(i,1)
            }
        }
        favorite.unshift({
                            id:value.id+"",
                            name:value.name,
                            artist:value.artist,
                            url:value.url?value.url:"",
                            time:value.time?value.time:"",
                            type:value.type?value.type:"",
                            album:value.album?value.album:"本地音乐"
                        })
        if(favorite.length>300)
        {
            // 限制三百条数据
            favorite.pop()
        }
        favoriteSettings.setValue("favorite",favorite)
    }

    function saveHistory(index = 0){ // 历史播放
        if(playList.length<index+1) return
        var item = playList[index]
        var history = historySettings.value("history",[])

        // 删除重复元素id
        var i = -1
        while(history.findIndex(value=>value.id === item.id.toString())+1){
            i = history.findIndex(value=>value.id === item.id.toString())
            if(i>=0)
            {
                history.splice(i,1)
            }
        }
        history.unshift({
                            id:item.id+"",
                            name:item.name,
                            artist:item.artist,
                            url:item.url?item.url:"",
                            type:item.type?item.type:"",
                            time:item.time?item.time:"",
                            album:item.album?item.album:"本地音乐"
                        })
        if(history.length>300)
        {
            // 限制三百条数据
            history.pop()
        }
        historySettings.setValue("history",history)
    }

    function playPrevious(){// 上一首
        if(playList.length<1) return

        switch(currentPlayMode){
        case 0:
        case 1: // 顺序播放
            current = (current+playList.length-1)%playList.length
            break
        case 2:
            var random = parseInt(Math.random()*playList.length)
            current = current === random?random+1:random
            break
        }
    }

    function playOrPause(){ // 播放或暂停
        if(!mediaPlayer.source){
            return
        }
        if(mediaPlayer.playbackState === MediaPlayer.PlayingState){
            mediaPlayer.pause() // 暂停
        }
        else if(mediaPlayer.playbackState === MediaPlayer.PausedState)
        {
            mediaPlayer.play()
        }
    }

    function playNext(type="natural"){ // 下一首
        if(playList.length<1) return
        switch(currentPlayMode){
        case 0:
            if(type==="natural")
                mediaPlayer.play()
            break
        case 1: // 顺序播放
            current = (current+1)%playList.length
            break
        case 2:
            var random = parseInt(Math.random()*playList.length)
            current = current === random?random+1:random
            break
        }
    }

    function changePlayMode(){ // 播放模式
        currentPlayMode = (currentPlayMode+1)%playModeList.length
        settings.setValue("currentPlayMode",currentPlayMode) // 保存信息
    }

    function playMusic(){ // 播放音乐
        if(current < 0) return
        // 播放
        if(playList.length<current+1) return

        if(playList[current].type === "1"){
            // 播放本地音乐
            playLocalMusic()
        }
        else
        {
            // 播放网络音乐
            playWebMusic()
        }
        saveHistory(current)
    }

    function playLocalMusic(){ // 播放本地音乐
        var currentItem = playList[current]
        mediaPlayer.source = currentItem.url
        mediaPlayer.play()
        musicName = currentItem.name
        musicArtist = currentItem.artist
        saveLastPlay(current)
    }

    function playWebMusic(){ // 获取音乐id
        var id = playList[current].id
        if(!id) return

        // 设置播放歌曲名
        musicName = playList[current].name
        musicArtist = playList[current].artist
        //console.log("name="+playList[current].name+" artist="+playList[current].artist)

        function onReply(reply){
            httpUtils.onReplySignal.disconnect(onReply)

            var data = JSON.parse(reply).data[0]
            var url = data.url
            musicUrl = url // 播放路径
            var time = data.time // 音乐时长

            // 设置slider
            setSlider(0,time,0)

            if(!url) return

            var cover = playList[current].cover
            if(!cover){
                // 请求cover
                getCover(id)
            }
            else{// 设置封面
                musicCoverImg = cover
                getLyric(id) // 播放列表类型获取歌词
            }

            mediaPlayer.source = url
            mediaPlayer.play()

            playbackStateChangeCallbackEnabled = true

        }

        httpUtils.onReplySignal.connect(onReply)// onReplySignal是HttpUtils中的信号前加了on首字母大写
        httpUtils.connet("song/url?id="+id)
    }

    function setSlider(from = 0,to = 100,value = 0){ // 设置音乐播放滚动条
        sliderFrom = from
        sliderTo = to
        sliderValue = value

        var value_mm = parseInt(value/1000/60)+"" // 开始分
        value_mm = value_mm.length<2?"0"+value_mm:value_mm
        var value_ss = parseInt(value/1000%60)+"" // 开始秒
        value_ss = value_ss.length<2?"0"+value_ss:value_ss

        var to_mm = parseInt(to/1000/60)+"" // 结束分
        to_mm = to_mm.length<2?"0"+to_mm:to_mm
        var to_ss = parseInt(to/1000%60)+"" // 结束秒
        to_ss = to_ss.length<2?"0"+to_ss:to_ss

        startTimeText.text = value_mm+":"+value_ss // 开始时间
        endTimeText.text = to_mm+":"+to_ss // 结束时间
        sliderTime = to_mm+":"+to_ss
        musicTime = to_mm+":"+to_ss
    }

    function getCover(id){ // 获取封面
        function onReply(reply){
            httpUtils.onReplySignal.disconnect(onReply)
            getLyric(id)

            var song = JSON.parse(reply).songs[0]
            var cover = song.al.picUrl
            musicCoverImg = cover
            saveLastPlay(current)
            if(musicName.length<1) musicName = song.name
            if(musicArtist.length<1) musicArtist = song.ar[0].name
        }

        httpUtils.onReplySignal.connect(onReply)
        httpUtils.connet("song/detail?ids="+id)
    }

    function getLyric(id){ // 请求歌词
        function onReply(reply){
            httpUtils.onReplySignal.disconnect(onReply)

            //console.log("请求歌词传入为:",id)
            var lyric = JSON.parse(reply).lrc.lyric
            if(lyric.length<1)  return
            var lyrics = (lyric.replace(/\[.*\]/gi,"")).split("\n")

            if(lyrics.length>0) pageDetailView.lyrics = lyrics

            var times = []
            lyric.replace(/\[.*\]/gi,function(match,index){
                // match: [00:00.00]
                if(match.length>2){
                    var time = match.substr(1,match.length-2)
                    var arr = time.split(":")
                    var timeValue = arr.length>1?parseInt(arr[0])*60*1000:0
                    arr = arr.length>1?arr[1].split("."):[0,0]
                    timeValue += arr.length>0?parseInt(arr[0])*1000:0
                    timeValue += arr.length>1?parseInt(arr[1])*10:0
                    times.push(timeValue)
                }
            })
            mediaPlayer.times = times
        }

        httpUtils.onReplySignal.connect(onReply)
        httpUtils.connet("lyric?id="+id)
    }
}
