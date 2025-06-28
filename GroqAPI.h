#ifndef GROQAPI_H
#define GROQAPI_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>

class GroqApi : public QObject {
    Q_OBJECT
public:
    explicit GroqApi(QObject *parent = nullptr);
    Q_INVOKABLE void sendRequest(const QString &prompt);

signals:
    void responseReceived(const QString &response);

private slots:
    void handleReply(QNetworkReply *reply);
    void loadAPIKey();

private:
    QNetworkAccessManager networkManager;
    QString apiKey = ""; // Replace this with your real key
};



#endif // GROQAPI_H
