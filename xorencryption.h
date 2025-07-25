#ifndef XORENCRYPTION_H
#define XORENCRYPTION_H

#include <QByteArray>
#include <QString>

class XOREncryption {
public:
    // Encrypt or decrypt using XOR
    static QByteArray applyXOR(const QByteArray &data, const QByteArray &key);

    // Load and decrypt an encrypted file
    static QByteArray decryptFile(const QString &filePath, const QByteArray &key);

    // Encrypt plain data and save to file
    static bool encryptToFile(const QString &inputPath, const QString &outputPath, const QByteArray &key);
};

#endif // XORENCRYPTION_H
