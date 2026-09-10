# Настройки путей
BACKUP_DIR="/var/backups/my_project"
SOURCE_DIR="/home/tester"
DATE=$(date +%Y-%m-%d_%H-%M-%S)
ARCHIVE_NAME="tester_backup_$DATE.tar.gz"

echo "=== СТАРТ ПРОЦЕДУРЫ РЕЗЕРВНОГО КОПИРОВАНИЯ ==="
echo "Время начала: $(date)"

# 1. Проверяем, существует ли папка для бэкапов. Если нет — создаем.
if [ ! -d "$BACKUP_DIR" ]; then
    echo "Папка $BACKUP_DIR не найдена. Создаю..."
    sudo mkdir -p "$BACKUP_DIR"
fi

# 2. Архивируем домашнюю папку пользователя tester
echo "Архивация директории $SOURCE_DIR..."
sudo tar -czf "$BACKUP_DIR/$ARCHIVE_NAME" "$SOURCE_DIR" 2>/dev/null

# Проверяем код завершения последней команды (tar)
if [ $? -eq 0 ]; then
    echo "Бэкап успешно создан: $BACKUP_DIR/$ARCHIVE_NAME"
else
    echo "КРИТИЧЕСКАЯ ОШИБКА: Не удалось создать архив!"
fi

# 3. Сбор информации о текущих пользователях в системе (для аудита)
echo -e "\n=== МОНИТОРИНГ ПОЛЬЗОВАТЕЛЕЙ ==="
echo "Кто сейчас в системе:"
who

echo "История последних входов (last):"
last -n 3
