// GroqApi.cpp
#include "GroqApi.h"
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include<QCoreApplication>
#include<QFile>

GroqApi::GroqApi(QObject *parent) : QObject(parent) {
    connect(&networkManager, &QNetworkAccessManager::finished, this, &GroqApi::handleReply);
    loadAPIKey();
}

void GroqApi::sendRequest(const QString &prompt) {
    QUrl url("https://api.groq.com/openai/v1/chat/completions");
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    request.setRawHeader("Authorization", "Bearer " + apiKey.toUtf8());

    QJsonObject message;
    message["role"] = "user";
    message["content"] = prompt;

    QJsonArray messages;
    messages.append(message);

    QJsonObject payload;
    payload["model"] = "llama3-70b-8192";
    payload["messages"] = messages;

    QJsonDocument doc(payload);
    QByteArray data = doc.toJson();

    networkManager.post(request, data);
    //qDebug() << prompt;
}

void GroqApi::handleReply(QNetworkReply *reply) {
    QByteArray responseData = reply->readAll();
    reply->deleteLater();

    QJsonDocument doc = QJsonDocument::fromJson(responseData);
    if (!doc.isObject()) {
        emit responseReceived("❌ Invalid JSON response.");
        return;
    }

    QJsonObject obj = doc.object();
    if (obj.contains("error")) {
        emit responseReceived("❌ API error: " + obj["error"].toObject()["message"].toString());
        return;
    }

    if (obj.contains("choices")) {
        auto choices = obj["choices"].toArray();
        if (!choices.isEmpty()) {
            auto message = choices[0].toObject()["message"].toObject()["content"].toString();
            emit responseReceived(message);
            return;
        }
    }

    emit responseReceived("⚠️ No usable response received.");
}

void GroqApi::loadAPIKey()
{
    QString configPath = QCoreApplication::applicationDirPath() + "/../../config.json";
    QFile file(configPath);

    if (!file.exists()) {
        qWarning() << "❌ Config file not found at:" << configPath;
        return;
    }

    if (!file.open(QIODevice::ReadOnly)) {
        qWarning() << "❌ Failed to open config file at:" << configPath;
        return;
    }

    QJsonParseError parseError;
    QJsonDocument doc = QJsonDocument::fromJson(file.readAll(), &parseError);
    if (parseError.error != QJsonParseError::NoError) {
        qWarning() << "❌ Failed to parse config JSON:" << parseError.errorString();
        return;
    }

    apiKey = doc.object().value("groq_api_key").toString();

    if (apiKey.isEmpty()) {
        qWarning() << "⚠️ API key not found or empty in config.json!";
    } else {
        qDebug() << "✅ API key loaded successfully.";
    }
}
