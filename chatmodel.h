#ifndef CHATMODEL_H
#define CHATMODEL_H

#include <QAbstractListModel>
#include <QQmlEngine>
#include <parser.h>

struct ChatMessage {
    QString role;
    QString content;
    QString htmlContent;
    quint64 revision = 0;
};

class ChatModel : public QAbstractListModel {
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
    Q_PROPERTY(int count READ count NOTIFY countChanged)

  public:
    enum Roles { RoleRole = Qt::UserRole + 1, ContentRole, HTMLContentRole };

    static ChatModel *instance();
    static ChatModel *create(QQmlEngine *qmlEngine, QJSEngine *jsEngine);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    int count() const { return m_messages.count(); }

    Q_INVOKABLE void appendMessage(const QString &role, const QString &content);
    Q_INVOKABLE void appendToLastMessage(const QString &textChunk);
    Q_INVOKABLE void updateLastMessage(const QString &content);
    Q_INVOKABLE void clear();
    void dump();
    QJsonArray modelToJson();

  signals:
    void countChanged();
    void messageUpdated(int index);

  private:
    explicit ChatModel(QObject *parent = nullptr);
    QList<ChatMessage> m_messages;
    static ChatModel *s_instance;
    MD::Parser md;
    quint64 m_revisionCounter = 0;
    void queueHtmlReparse(int index);
};

#endif // CHATMODEL_H
