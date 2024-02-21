#ifndef HTTPUTILS_H
#define HTTPUTILS_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>

class HttpUtils : public QObject
{
    Q_OBJECT
public:
    explicit HttpUtils(QObject *parent = nullptr);



signals:
    void replySignal(QString reply);


private:
    QNetworkAccessManager* m_manger;
    QString m_url = "http://localhost:3000/";

public slots:
    Q_INVOKABLE void replyFinished(QNetworkReply *);
    Q_INVOKABLE void connet(QString url);

};

#endif // HTTPUTILS_H
