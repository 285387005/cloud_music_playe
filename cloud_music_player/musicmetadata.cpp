// musicmetadata.cpp
#include "musicmetadata.h"

MusicMetadata::MusicMetadata(QObject *parent) : QObject(parent) {}

QVariantMap MusicMetadata::getMetadata(const QUrl &fileUrl)
{
    QVariantMap metadataMap;

    QMediaPlayer mediaPlayer;
    mediaPlayer.setMedia(fileUrl);

    mediaPlayer.play();

    // 等待元数据加载完成
    QEventLoop loop;
    QObject::connect(&mediaPlayer, &QMediaPlayer::mediaStatusChanged, [&](QMediaPlayer::MediaStatus status){
        if (status == QMediaPlayer::BufferedMedia) {
            loop.quit();
        }
    });
    loop.exec();

    if (mediaPlayer.isMetaDataAvailable()) {
        metadataMap["title"] = mediaPlayer.metaData(QMediaMetaData::Title).toString();
        metadataMap["artist"] = mediaPlayer.metaData(QMediaMetaData::Author).toString();
        metadataMap["lyrics"] = mediaPlayer.metaData(QMediaMetaData::Lyrics).toString();
        metadataMap["cover"] = mediaPlayer.metaData(QMediaMetaData::CoverArtImage).toUrl();
        metadataMap["time"] = mediaPlayer.metaData(QMediaMetaData::Duration);
        // Add more metadata keys as needed
    }

    mediaPlayer.stop(); // 停止播放

    return metadataMap;
}
