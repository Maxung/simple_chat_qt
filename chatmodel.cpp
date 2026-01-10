#include "chatmodel.h"
#include <QFile>
#include <QIODevice>
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
    m_messages.append({role, content, html});
    endInsertRows();
    emit countChanged();
}

void ChatModel::appendToLastMessage(const QString &textChunk) {
    if (m_messages.isEmpty())
        return;

    int lastIndex = m_messages.count() - 1;
    m_messages[lastIndex].content += textChunk;
    QTextStream stream(const_cast<QString *>(&m_messages[lastIndex].content),
                       QIODevice::ReadOnly);
    auto doc = md.parse(stream, QString(), QString());
    const auto html = MD::toHtml(doc);
    m_messages[lastIndex].htmlContent = html;

    QModelIndex idx = index(lastIndex);
    emit dataChanged(idx, idx, {HTMLContentRole});
}

void ChatModel::updateLastMessage(const QString &content) {
    if (m_messages.isEmpty())
        return;

    int lastIndex = m_messages.count() - 1;
    m_messages[lastIndex].content = content;
    QModelIndex idx = index(lastIndex);
    emit dataChanged(idx, idx, {ContentRole});
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
