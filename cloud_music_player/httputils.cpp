#include "httputils.h"

HttpUtils::HttpUtils(QObject *parent) : QObject(parent)
{
    m_manger = new QNetworkAccessManager(this);

    connect(m_manger,&QNetworkAccessManager::finished,this,&HttpUtils::replyFinished);
}

void HttpUtils::replyFinished(QNetworkReply *reply)
{
    emit replySignal(reply->readAll());
}

void HttpUtils::connet(QString url)
{
    QNetworkRequest request;
    request.setUrl(QUrl(m_url+url));// 设置请求
    m_manger->get(request);// 链接给到m_manger让m_manger发送请求
}
