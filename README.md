cat > ~/README.md << 'EOF'
# Raspberry Pi Kiosk System with TTP223 Touch Control

Automatyczna konfiguracja systemu kioskowego dla Raspberry Pi z obsługą czujnika dotyku TTP223.

## ✨ Funkcje
- Automatyczne uruchamianie przeglądarki w trybie kiosku
- Wyłączanie ekranu po 20 sekundach bezczynności
- Włączanie ekranu po dotknięciu czujnika TTP223
- Minimalne zużycie zasobów systemowych
- VNC dostępne na porcie 5900
- SSH dostęp przez Putty

## 📋 Wymagania wstępne
- Raspberry Pi 4 (testowane na modelu 4B)
- System: **Raspbian GNU/Linux 13 (Trixie)**
  - Wersja: 13.1
  - Kernel: 6.12.47+rpt-rpi-v8
  - Architektura: aarch64 (64-bit)
  - Data obrazu: 2025-09-26
- Karta microSD min. 8GB
- Czujnik TTP223
- Połączenie sieciowe

## 🔌 Podłączenie czujnika TTP223
TTP223 → Raspberry Pi 4
VCC → Pin 1 (3.3V)
GND → Pin 6 (GND)
OUT → Pin 11 (GPIO17)

## 🚀 Szybka instalacja

### Pobranie i uruchomienie skryptu


# Pobranie i uruchomienie skryptu instalacyjnego
wget https://raw.githubusercontent.com/marcinwojciesz/raspberry-kiosk/main/install_from_github.sh
chmod +x install_from_github.sh
./install_from_github.sh


⚙️ Konfiguracja
Zmiana adresu URL strony
Edytuj plik ~/.config/openbox/autostart i zmień adres w linii:


--kiosk "http://192.168.1.112:8123" \

Zmiana GPIO czujnika
Edytuj plik ~/screen_wakeup.sh i zmień zmienną:


SENSOR_GPIO=17  # zmień na inny numer GPIO

📊 Specyfikacja systemu (testowana konfiguracja)
System operacyjny: Raspbian GNU/Linux 13 (Trixie)

Wersja: 13.1

ID systemu: raspbian

Wersja Debiana: 13.1

Kodowa nazwa: trixie

Kernel: 6.12.47+rpt-rpi-v8

Architektura: aarch64 (64-bit)

Przeglądarka: Chromium 143.0.7499.109

Menedżer okien: Openbox 3.6.1

Data testowania: 26 grudnia 2025

Model Raspberry Pi: 4B

Pamięć RAM: 4GB/8GB (dowolna)

🔧 Pliki konfiguracyjne
~/.config/openbox/autostart - autostart środowiska

~/screen_wakeup.sh - obsługa czujnika TTP223

~/.xinitrc - konfiguracja X server

~/.bash_profile - automatyczne uruchamianie X

~/install_kiosk.sh - główny skrypt instalacyjny

~/test_sensor.py - skrypt testowy czujnika



📁 Struktura skryptów

raspberry-kiosk/
├── install_kiosk.sh          # Główny skrypt instalacyjny
├── install_from_github.sh    # Skrypt pobierający z GitHub
├── screen_wakeup.sh          # Obsługa czujnika TTP223
├── test_sensor.py           # Test czujnika GPIO
├── README.md                # Ta dokumentacja
└── examples/                # Przykłady konfiguracji

🤝 Autor
System skonfigurowany dla PanelDP.
Testowany i sprawdzony na Raspberry Pi 4B z Raspbian GNU/Linux 13 (Trixie).

Ostatnia aktualizacja: 26 grudnia 2025
*Sprawdzone na: Raspberry Pi 4B 4GB/8GB*
*Wersja systemu: Raspbian GNU/Linux 13.1 (Trixie)*
*Kernel: 6.12.47+rpt-rpi-v8*

Po instalacji system automatycznie uruchomi stronę http://192.168.1.112:8123 w trybie kiosku z oszczędzaniem energii i obsługą czujnika dotyku.
EOF
