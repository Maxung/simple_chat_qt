#ifndef OPENAICLIENT_H
#define OPENAICLIENT_H

#include <qqmlintegration.h>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QObject>

class OpenAIClient : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

public:
    explicit OpenAIClient(QObject *parent = nullptr);

    Q_INVOKABLE QString currentModel() const;
    Q_INVOKABLE void setModel(const QString &model);

    Q_INVOKABLE void sendPrompt(const QString &prompt);

signals:
    void partialResponse(const QString &text);
    void finished();
    void error(const QString &message);

private slots:
    void onReadyRead();
    void onFinished();

private:
    QNetworkAccessManager m_manager;
    QNetworkReply *m_reply = nullptr;
    QString m_model;
};

#endif // OPENAICLIENT_H
