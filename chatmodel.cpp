#include "chatmodel.h"
#include <QFile>
#include <QFutureWatcher>
#include <QIODevice>
#include <QThreadPool>
#include <QtConcurrent>
#include <html.h>

ChatModel *ChatModel::s_instance = nullptr;

ChatModel *ChatModel::instance() {
    if (!s_instance)
        s_instance = new ChatModel();
    return s_instance;
}

ChatModel *ChatModel::create(QQmlEngine *qmlEngine, QJSEngine *jsEngine) {
    Q_UNUSED(qmlEngine);
    Q_UNUSED(jsEngine);
    return instance();
}

ChatModel::ChatModel(QObject *parent) : QAbstractListModel(parent) {}

int ChatModel::rowCount(const QModelIndex &parent) const {
    if (parent.isValid())
        return 0;
    return m_messages.count();
}

QVariant ChatModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || index.row() >= m_messages.count())
        return QVariant();

    const ChatMessage &message = m_messages.at(index.row());

    switch (role) {
    case RoleRole:
        return message.role;
    case ContentRole:
        return message.content;
    case HTMLContentRole:
        return message.htmlContent;
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> ChatModel::roleNames() const {
    return {{RoleRole, "role"},
            {ContentRole, "content"},
            {HTMLContentRole, "htmlContent"}};
}

void ChatModel::appendMessage(const QString &role, const QString &content) {
    QTextStream stream(const_cast<QString *>(&content), QIODevice::ReadOnly);
    auto doc = md.parse(stream, QString(), QString());
    const auto html = MD::toHtml(doc);

    beginInsertRows(QModelIndex(), m_messages.count(), m_messages.count());
    ChatMessage message{role, content, html};
    m_messages.append(message);
    endInsertRows();
    emit countChanged();
    emit messageUpdated(m_messages.count() - 1);
}

void ChatModel::appendToLastMessage(const QString &textChunk) {
    if (m_messages.isEmpty())
        return;

    int lastIndex = m_messages.count() - 1;
    m_messages[lastIndex].content += textChunk;
    QModelIndex idx = index(lastIndex);
    emit dataChanged(idx, idx, {ContentRole});
    emit messageUpdated(lastIndex);
    queueHtmlReparse(lastIndex);
}

void ChatModel::updateLastMessage(const QString &content) {
    if (m_messages.isEmpty())
        return;

    int lastIndex = m_messages.count() - 1;
    m_messages[lastIndex].content = content;
    QModelIndex idx = index(lastIndex);
    emit dataChanged(idx, idx, {ContentRole});
    emit messageUpdated(lastIndex);
    queueHtmlReparse(lastIndex);
}

void ChatModel::dump() {
    int lastIndex = m_messages.count() - 1;
    auto html = m_messages[lastIndex].htmlContent;

    QFile file("test.html");
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text))
        return;
    QTextStream out(&file);
    out << html;
    file.close();
}

void ChatModel::clear() {
    beginResetModel();
    m_messages.clear();
    endResetModel();
    emit countChanged();
}

void ChatModel::queueHtmlReparse(int index) {
    if (index < 0 || index >= m_messages.count())
        return;

    const quint64 revision = ++m_revisionCounter;
    m_messages[index].revision = revision;
    QString content = m_messages[index].content;

    auto watcher = new QFutureWatcher<QString>(this);

    connect(watcher, &QFutureWatcher<QString>::finished, this,
            [this, watcher, index, revision]() {
                watcher->deleteLater();

                if (index < 0 || index >= m_messages.count())
                    return;

                if (m_messages[index].revision != revision)
                    return;

                const auto html = watcher->result();
                m_messages[index].htmlContent = html;

                QModelIndex idx = this->index(index);
                emit dataChanged(idx, idx, {HTMLContentRole});
                emit messageUpdated(index);
            });

    watcher->setFuture(QtConcurrent::run(QThreadPool::globalInstance(),
                                         [content = std::move(content)]() mutable {
                                             QTextStream stream(&content,
                                                                QIODevice::ReadOnly);
                                             MD::Parser parser;
                                             auto doc =
                                                 parser.parse(stream, QString(), QString());
                                             return MD::toHtml(doc);
                                         }));
}
