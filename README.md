audit.sh 
#!/bin/bash

# Путь к файлу отчета
REPORT_FILE="report.txt"

echo "=== ОТЧЕТ ПО БЕЗОПАСНОСТИ СИСТЕМЫ ===" > $REPORT_FILE
echo "Дата проверки: $(date)" >> $REPORT_FILE
echo "Текущий пользователь: $(whoami)" >> $REPORT_FILE
echo "-------------------------------------" >> $REPORT_FILE

# 1. Проверка прав доступа на критический системный файл (POSIX)
echo " Проверка прав на файл /etc/passwd:" >> $REPORT_FILE
ls -l /etc/passwd >> $REPORT_FILE

# 2. Имитация парсинга логов (поиск предупреждений и ошибок)
echo -e "\n Последние 5 строк системного лога:" >> $REPORT_FILE
if [ -f /var/log/messages ]; then
    tail -n 5 /var/log/messages >> $REPORT_FILE
else
    echo "Лог-файл messages недоступен (возможно, используется systemd-journald)" >> $REPORT_FILE
fi

# 3. Аудит подсистемы безопасности PARSEC (Специфика Astra Linux SE)
echo -e "\n Проверка мандатного контекста безопасности:" >> $REPORT_FILE
if command -v pdp-id &> /dev/null; then
    # Вызов мандатных атрибутов текущей сессии
    sudo pdp-id >> $REPORT_FILE
else
    echo "Команда pdp-id недоступна (система запущена не в режиме Special Edition)" >> $REPORT_FILE
fi

echo "Аудит завершен. Результаты успешно записаны в файл $REPORT_FILE"



