# Установка OpenSSL
if ! command -v openssl &> /dev/null; then # <- проверка на наличие установленного пакета
  sudo apt update && sudo apt install -y openssl # <- установка пакета
  if [ $? -ne 0 ]; then # <- проверка на успешность установки
    exit 1
  fi
else
  echo "Open SSL уже установлен." # <- сообщение о том, что пакет уже установлен
fi

# Генерация сертификата
CERT_DIR="/etc/ssl/self_signed_cert"
CERT_NAME="self_signed"
DAYS_VALID=3650
mkdir -p "$CERT_DIR"
CERT_PATH="$CERT_DIR/$CERT_NAME.crt"
KEY_PATH="$CERT_DIR/$CERT_NAME.key"

openssl req -x509 -nodes -days $DAYS_VALID -newkey rsa:2048 \
  -keyout "$KEY_PATH" \
  -out "$CERT_PATH" \
  -subj "/C=US/ST=State/L=City/O=Organization/OU=Department/CN=example.com"

if [ $? -eq 0 ]; then
  echo "SSL CERTIFICATE PATH: $CERT_PATH"
  echo "SSL KEY PATH: $KEY_PATH"
else
  exit 1
fi

# Финальное сообщение
for i in {1..2}; do echo "============================================================"; done
echo "   Установка завершена, ключи сгенерированы!"
echo "   Пропишите ключи в панели управления 3x-ui"
echo "1) Пройдите по ссылке сверху, введи логин и пароль, который сгенерировал скрипт"
echo "2) После перейдиртре в Настройки панели"
echo "3) Путь к файлу ПУБЛИЧНОГО ключа сертификата -> /etc/ssl/self_signed_cert/self_signed.crt"
echo "4) Путь к файлу ПРИВАТНОГО ключа сертификата -> /etc/ssl/self_signed_cert/self_signed.key"
echo "5) Сохраните и перезагрузите панель"

echo "============================================================"
