#include "chatmodel.h"

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

ChatModel::ChatModel(QObject *parent)
    : QAbstractListModel(parent)
{
}

int ChatModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;
    return m_messages.count();
}

QVariant ChatModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_messages.count())
        return QVariant();

    const ChatMessage &message = m_messages.at(index.row());

    switch (role) {
    case RoleRole:
        return message.role;
    case ContentRole:
        return message.content;
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> ChatModel::roleNames() const
{
    return {
        {RoleRole, "role"},
        {ContentRole, "content"}
    };
}

void ChatModel::appendMessage(const QString &role, const QString &content)
{
    beginInsertRows(QModelIndex(), m_messages.count(), m_messages.count());
    m_messages.append({role, content});
    endInsertRows();
    emit countChanged();
}

void ChatModel::appendToLastMessage(const QString &textChunk)
{
    if (m_messages.isEmpty())
        return;

    int lastIndex = m_messages.count() - 1;
    m_messages[lastIndex].content += textChunk;
    
    QModelIndex idx = index(lastIndex);
    emit dataChanged(idx, idx, {ContentRole});
}

void ChatModel::updateLastMessage(const QString &content)
{
    if (m_messages.isEmpty())
        return;

    int lastIndex = m_messages.count() - 1;
    m_messages[lastIndex].content = content;
    
    QModelIndex idx = index(lastIndex);
    emit dataChanged(idx, idx, {ContentRole});
}

void ChatModel::clear()
{
    beginResetModel();
    m_messages.clear();
    endResetModel();
    emit countChanged();
}
