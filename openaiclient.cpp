#include <QGuiApplication>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QQmlApplicationEngine>
#include <QThread>

#include "chatmodel.h"
#include "openaiclient.h"

OpenAIClient::OpenAIClient(QObject *parent) : QObject(parent) {}

void OpenAIClient::sendPrompt(const QString &prompt) {
    auto model = ChatModel::instance();
    model->appendMessage("user", prompt);
    model->appendMessage("assistant", "");

    QNetworkRequest request(
        QUrl("https://openrouter.ai/api/v1/chat/completions"));
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    request.setRawHeader("Authorization",
                         QByteArray("Bearer ") + qgetenv("OPENAI_API_KEY"));

    QJsonObject payload{{"model", "nvidia/nemotron-3-nano-30b-a3b:free"},
                        {"stream", true},
                        {"messages", model->modelToJson()}};

    m_reply = m_manager.post(
        request, QJsonDocument(payload).toJson(QJsonDocument::Compact));

    connect(m_reply, &QNetworkReply::readyRead, this,
            &OpenAIClient::onReadyRead);
    connect(m_reply, &QNetworkReply::finished, this, &OpenAIClient::onFinished);
}

void OpenAIClient::onReadyRead() {
    while (m_reply->canReadLine()) {
        QByteArray line = m_reply->readLine().trimmed();

        if (!line.startsWith("data:"))
            continue;

        QByteArray jsonData = line.mid(5).trimmed();

        if (jsonData == "[DONE]") {
            auto model = ChatModel::instance();
            model->dump();
            emit finished();
            return;
        }

        QJsonDocument doc = QJsonDocument::fromJson(jsonData);
        auto delta = doc["choices"][0]["delta"]["content"].toString();

        if (!delta.isEmpty()) {
            auto model = ChatModel::instance();
            QMetaObject::invokeMethod(
                model, [model, delta]() { model->appendToLastMessage(delta); },
                Qt::QueuedConnection);
        }
    }
}

void OpenAIClient::onFinished() {
    if (m_reply->error() != QNetworkReply::NoError)
        emit error(m_reply->errorString());

    m_reply->deleteLater();
    m_reply = nullptr;
}
