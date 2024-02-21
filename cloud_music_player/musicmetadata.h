#ifndef MUSICMETADATA_H
#define MUSICMETADATA_H

#include <QObject>
#include <QUrl>
#include <QMediaPlayer>
#include <QMediaMetaData>
#include <QEventLoop> // 新增头文件
#include <QDebug>

class MusicMetadata : public QObject
{
    Q_OBJECT
public:
    explicit MusicMetadata(QObject *parent = nullptr);

    Q_INVOKABLE QVariantMap getMetadata(const QUrl &fileUrl);
};

#endif // MUSICMETADATA_H
