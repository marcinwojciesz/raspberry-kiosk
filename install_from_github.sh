#!/bin/bash

# Pobierz i uruchom pełny skrypt instalacyjny z GitHub
INSTALL_URL="https://raw.githubusercontent.com/twoj-username/raspberry-kiosk/main/install_kiosk.sh"

echo "Pobieranie skryptu instalacyjnego..."
wget -O /tmp/install_kiosk.sh $INSTALL_URL

if [ $? -eq 0 ]; then
    echo "Uruchamianie skryptu instalacyjnego..."
    chmod +x /tmp/install_kiosk.sh
    /tmp/install_kiosk.sh
else
    echo "Błąd pobierania skryptu!"
    exit 1
fi
