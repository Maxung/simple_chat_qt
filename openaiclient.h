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
    Q_PROPERTY(bool isLoading READ isLoading NOTIFY isLoadingChanged)

public:
    explicit OpenAIClient(QObject *parent = nullptr);

    Q_INVOKABLE QString currentModel() const;
    Q_INVOKABLE void setModel(const QString &model);

    Q_INVOKABLE void sendPrompt(const QString &prompt);
    bool isLoading() const;

signals:
    void partialResponse(const QString &text);
    void finished();
    void error(const QString &message);
    void isLoadingChanged();

private slots:
    void onReadyRead();
    void onFinished();

private:
    QNetworkAccessManager m_manager;
    QNetworkReply *m_reply = nullptr;
    QString m_model;
    bool m_isLoading = false;
};

#endif // OPENAICLIENT_H
