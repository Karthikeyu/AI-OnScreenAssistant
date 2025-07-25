#include "xorencryption.h"
#include <QFile>
#include <QDebug>

QByteArray XOREncryption::applyXOR(const QByteArray &data, const QByteArray &key) {
    QByteArray result;
    for (int i = 0; i < data.size(); ++i) {
        result.append(data[i] ^ key[i % key.size()]);
    }
    return result;
}

QByteArray XOREncryption::decryptFile(const QString &filePath, const QByteArray &key) {
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly)) {
        qWarning() << "❌ Failed to open file:" << filePath;
        return QByteArray();
    }

    QByteArray encryptedData = file.readAll();
    return applyXOR(encryptedData, key);
}

bool XOREncryption::encryptToFile(const QString &inputPath, const QString &outputPath, const QByteArray &key) {
    QFile inputFile(inputPath);
    if (!inputFile.open(QIODevice::ReadOnly)) {
        qWarning() << "❌ Failed to open input file:" << inputPath;
        return false;
    }

    QByteArray plainData = inputFile.readAll();
    QByteArray encrypted = applyXOR(plainData, key);

    QFile outFile(outputPath);
    if (!outFile.open(QIODevice::WriteOnly)) {
        qWarning() << "❌ Failed to open output file:" << outputPath;
        return false;
    }

    outFile.write(encrypted);
    return true;
}
