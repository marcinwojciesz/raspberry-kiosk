#!/bin/bash

# Kiosk installer for Raspberry Pi with TTP223 touch sensor
# Autor: Generated for PanelDP
# Strona: http://192.168.1.112:8123

set -e

echo "========================================="
echo "Instalator systemu kioskowego Raspberry Pi"
echo "========================================="

# Zmienne konfiguracyjne
KIOSK_URL="http://192.168.1.112:8123"
SENSOR_GPIO="17"
USERNAME=$(whoami)

# 1. Aktualizacja systemu
echo "[1/10] Aktualizacja systemu..."
sudo apt update
sudo apt upgrade -y

# 2. Instalacja wymaganych pakietów
echo "[2/10] Instalacja pakietów..."
sudo apt install -y --no-install-recommends \
    xserver-xorg \
    x11-xserver-utils \
    xinit \
    openbox \
    chromium \
    unclutter \
    xdotool \
    python3-rpi.gpio

# 3. Konfiguracja automatycznego logowania
echo "[3/10] Konfiguracja automatycznego logowania..."
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d
sudo tee /etc/systemd/system/getty@tty1.service.d/override.conf > /dev/null << EOF
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin $USERNAME --noclear %I \$TERM
EOF

sudo systemctl daemon-reload
sudo systemctl restart getty@tty1

# 4. Konfiguracja Openbox
echo "[4/10] Konfiguracja Openbox..."
mkdir -p ~/.config/openbox

# Plik autostart
tee ~/.config/openbox/autostart > /dev/null << EOF
#!/bin/bash

# Włącz zarządzanie energią DPMS z timeoutem 20 sekund
xset dpms 20 20 20
xset s on
xset s 20

# Ukryj kursora myszy
unclutter -idle 0.1 -root &

# Uruchom Chromium w trybie kiosku
chromium --noerrdialogs --disable-infobars --disable-features=TranslateUI \\
--kiosk "$KIOSK_URL" \\
--disable-breakpad --disable-crash-reporter \\
--disable-dev-shm-usage --no-first-run \\
--fast-start --fast --quick-start \\
--disable-background-networking \\
--disable-component-extensions-with-background-pages \\
--disable-background-timer-throttling \\
--disable-renderer-backgrounding \\
--disable-backgrounding-occluded-windows &

# Skrypt włączania ekranu przez czujnik
/home/$USERNAME/screen_wakeup.sh &
EOF

chmod +x ~/.config/openbox/autostart

# 5. Skrypt włączania ekranu
echo "[5/10] Tworzenie skryptu włączania ekranu..."
tee ~/screen_wakeup.sh > /dev/null << EOF
#!/bin/bash

# GPIO setup
SENSOR_GPIO=$SENSOR_GPIO

echo "Skrypt włączania ekranu przez czujnik TTP223"
echo "GPIO \$SENSOR_GPIO - czujnik TTP223"

while true; do
    # Odczytaj stan czujnika przez Python
    SENSOR_VALUE=\$(python3 -c "
import RPi.GPIO as GPIO
GPIO.setmode(GPIO.BCM)
GPIO.setup(\$SENSOR_GPIO, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
print(GPIO.input(\$SENSOR_GPIO))
GPIO.cleanup()
" 2>/dev/null)
    
    # Jeśli czujnik jest aktywny (dotknięty)
    if [ "\$SENSOR_VALUE" = "1" ]; then
        echo "Włączanie ekranu - dotknięcie czujnika"
        
        # Włącz ekran przez xset (działa z DPMS)
        xset dpms force on
        
        # Poczekaj 2 sekundy żeby uniknąć wielokrotnego wyzwalania
        sleep 2
    fi
    
    # Krótki sleep
    sleep 0.5
done
EOF

chmod +x ~/screen_wakeup.sh

# 6. Konfiguracja .xinitrc
echo "[6/10] Konfiguracja .xinitrc..."
tee ~/.xinitrc > /dev/null << 'EOF'
#!/bin/bash
exec openbox-session
EOF

chmod +x ~/.xinitrc

# 7. Konfiguracja autostartu X
echo "[7/10] Konfiguracja autostartu X..."
tee ~/.bash_profile > /dev/null << 'EOF'
if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    exec startx
fi
EOF

# 8. Optymalizacja - wyłącz niepotrzebne usługi
echo "[8/10] Optymalizacja systemu..."
sudo systemctl disable bluetooth 2>/dev/null || true
sudo systemctl disable avahi-daemon 2>/dev/null || true
sudo systemctl disable triggerhappy 2>/dev/null || true

# 9. Konfiguracja VNC (opcjonalnie)
echo "[9/10] Konfiguracja VNC..."
sudo apt install -y x11vnc
x11vnc -storepasswd
sudo tee /etc/systemd/system/x11vnc.service > /dev/null << 'EOF'
[Unit]
Description=VNC Server
After=graphical.target

[Service]
Type=simple
User=$USERNAME
WorkingDirectory=/home/$USERNAME
ExecStart=/usr/bin/x11vnc -auth guess -forever -loop -noxdamage -repeat -rfbauth /home/$USERNAME/.vnc/passwd -rfbport 5900 -shared
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable x11vnc
sudo systemctl start x11vnc

# 10. Restart
echo "[10/10] Instalacja zakończona!"
echo ""
echo "========================================="
echo "PODSUMOWANIE:"
echo "1. Strona kiosku: $KIOSK_URL"
echo "2. Czujnik TTP223: GPIO $SENSOR_GPIO"
echo "3. Ekran wyłącza się po 20 sekundach"
echo "4. Dotknięcie czujnika włącza ekran"
echo "5. VNC dostępne na porcie 5900"
echo ""
echo "Aby zastosować zmiany, wykonaj:"
echo "sudo reboot"
echo "========================================="
