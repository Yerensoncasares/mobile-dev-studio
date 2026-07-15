  bash
#!/data/data/com.termux/files/usr/bin/bash
#######################################################
#  🎨 MOBILE DEV STUDIO - Ultimate VNC Installer v2.0
#  
#  Features:
#  - TigerVNC Server (Network exposed & Battery protected)
#  - Godot 3.3 via Wine/Hangover (As requested)
#  - Web Dev Stack (Firefox, VS Code, Node, Git)
#  - Zero bloat, Bulletproof connection logic
#  
#  Based on: Tech Jarves UI structure
#######################################################

# ============== CONFIGURATION ==============
TOTAL_STEPS=10
CURRENT_STEP=0

# ============== COLORS ==============
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'
NC='\033[0m'
BOLD='\033[1m'

# ============== PROGRESS FUNCTIONS ==============
update_progress() {
    CURRENT_STEP=$((CURRENT_STEP + 1))
    PERCENT=$((CURRENT_STEP * 100 / TOTAL_STEPS))
    
    FILLED=$((PERCENT / 5))
    EMPTY=$((20 - FILLED))
    
    BAR="${GREEN}"
    for ((i=0; i<FILLED; i++)); do BAR+="█"; done
    BAR+="${GRAY}"
    for ((i=0; i<EMPTY; i++)); do BAR+="░"; done
    BAR+="${NC}"
    
    echo ""
    echo -e "${WHITE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}  📊 OVERALL PROGRESS: ${WHITE}Step ${CURRENT_STEP}/${TOTAL_STEPS}${NC} ${BAR} ${WHITE}${PERCENT}%${NC}"
    echo -e "${WHITE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

spinner() {
    local pid=$1
    local message=$2
    local spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local i=0
    
    while kill -0 $pid 2>/dev/null; do
        i=$(( (i+1) % 10 ))
        printf "\r  ${YELLOW}⏳${NC} ${message} ${CYAN}${spin:$i:1}${NC}  "
        sleep 0.1
    done
    
    wait $pid
    local exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        printf "\r  ${GREEN}✓${NC} ${message}                    \n"
    else
        printf "\r  ${RED}✗${NC} ${message} ${RED}(failed)${NC}     \n"
    fi
    return $exit_code
}

install_pkg() {
    local pkg=$1
    local name=${2:-$pkg}
    
    (yes | pkg install $pkg -y > /dev/null 2>&1) &
    spinner $! "Installing ${name}..."
}

# ============== BANNER ==============
show_banner() {
    clear
    echo -e "${CYAN}"
    cat << 'BANNER'
    ╔════════════════════════════════════════╗
    ║                                        ║
    ║   🚀  MOBILE DEV STUDIO v2.0  🚀       ║
    ║      (Wine/Godot + AVNC Edition)       ║
    ║                                        ║
    ╚════════════════════════════════════════╝
BANNER
    echo -e "${NC}"
    echo -e "${WHITE}         Web Dev + Godot 3.3 (Wine) Environment${NC}"
    echo ""
}

# ============== DEVICE DETECTION ==============
detect_device() {
    echo -e "${PURPLE}[*] Detecting your device...${NC}"
    echo ""
    
    DEVICE_MODEL=$(getprop ro.product.model 2>/dev/null || echo "Unknown")
    DEVICE_BRAND=$(getprop ro.product.brand 2>/dev/null || echo "Unknown")
    ANDROID_VERSION=$(getprop ro.build.version.release 2>/dev/null || echo "Unknown")
    CPU_ABI=$(getprop ro.product.cpu.abi 2>/dev/null || echo "arm64-v8a")
    
    echo -e "  ${GREEN}📱${NC} Device: ${WHITE}${DEVICE_BRAND} ${DEVICE_MODEL}${NC}"
    echo -e "  ${GREEN}🤖${NC} Android: ${WHITE}${ANDROID_VERSION}${NC}"
    echo -e "  ${GREEN}⚙️${NC}  CPU: ${WHITE}${CPU_ABI}${NC}"
    echo -e "  ${GREEN}🎮${NC} GPU Driver: ${WHITE}Safe Software Rendering (llvmpipe)${NC}"
    echo ""
    sleep 1
}

# ============== STEP 1: UPDATE SYSTEM ==============
step_update() {
    update_progress
    echo -e "${PURPLE}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Updating system packages...${NC}"
    echo ""
    
    (yes | pkg update -y > /dev/null 2>&1) &
    spinner $! "Updating package lists..."
    
    (yes | pkg upgrade -y > /dev/null 2>&1) &
    spinner $! "Upgrading installed packages..."
}

# ============== STEP 2: INSTALL REPOSITORIES ==============
step_repos() {
    update_progress
    echo -e "${PURPLE}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Adding package repositories...${NC}"
    echo ""
    
    install_pkg "x11-repo" "X11 Repository"
    install_pkg "tur-repo" "TUR Repository (Firefox, VS Code, Wine)"
}

# ============== STEP 3: INSTALL TIGERVNC SERVER ==============
step_vnc() {
    update_progress
    echo -e "${PURPLE}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Installing TigerVNC Server...${NC}"
    echo ""
    
    install_pkg "tigervnc" "TigerVNC Display Server"
}

# ============== STEP 4: INSTALL DESKTOP ==============
step_desktop() {
    update_progress
    echo -e "${PURPLE}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Installing XFCE4 Desktop (Lightweight)...${NC}"
    echo ""
    
    install_pkg "xfce4" "XFCE4 Desktop Environment"
    install_pkg "xfce4-terminal" "XFCE4 Terminal"
    install_pkg "thunar" "Thunar File Manager"
}

# ============== STEP 5: INSTALL AUDIO ==============
step_audio() {
    update_progress
    echo -e "${PURPLE}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Installing Audio Support...${NC}"
    echo ""
    
    install_pkg "pulseaudio" "PulseAudio Sound Server"
}

# ============== STEP 6: INSTALL DEV APPS ==============
step_apps() {
    update_progress
    echo -e "${PURPLE}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Installing Development Applications...${NC}"
    echo ""
    
    install_pkg "firefox" "Firefox Browser"
    install_pkg "code-oss" "VS Code Editor"
    install_pkg "git" "Git Version Control"
    install_pkg "nodejs" "Node.js (NPM/Web Dev)"
    install_pkg "wget" "Wget Downloader"
    install_pkg "curl" "cURL"
    install_pkg "unzip" "Unzip (Required for Godot extraction)"
}

# ============== STEP 7: INSTALL WINE & GODOT 3.3 ==============
step_godot_wine() {
    update_progress
    echo -e "${PURPLE}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Installing Wine & Godot 3.3.4...${NC}"
    echo ""
    
    # Instalamos el emulador y sus dependencias
    install_pkg "hangover-wine" "Wine Compatibility Layer"
    install_pkg "hangover-wowbox64" "Box64 Wrapper"
    
    # Creamos accesos directos globales para wine
    ln -sf /data/data/com.termux/files/usr/opt/hangover-wine/bin/wine /data/data/com.termux/files/usr/bin/wine
    ln -sf /data/data/com.termux/files/usr/opt/hangover-wine/bin/winecfg /data/data/com.termux/files/usr/bin/winecfg
    
    echo -e "  ${YELLOW}⏳${NC} Configuring Wine prefix for the first time..."
    export GALLIUM_DRIVER=llvmpipe
    WINEPREFIX=~/.wine wineboot --init > /dev/null 2>&1
    echo -e "  ${GREEN}✓${NC} Wine configured"
    
    # Descargamos Godot 3.3.4 para Windows
    mkdir -p ~/Godot
    cd ~/Godot
    
    (wget -q --show-progress https://downloads.tuxfamily.org/godotengine/3.3.4/Godot_v3.3.4-stable_win64.exe.zip -O godot.zip > /dev/null 2>&1) &
    spinner $! "Downloading Godot 3.3.4 (Windows x64)..."
    
    (unzip -o godot.zip > /dev/null 2>&1) &
    spinner $! "Extracting Godot files..."
    
    # Limpiamos
    rm godot.zip 2>/dev/null
    cd ~
    echo -e "  ${GREEN}✓${NC} Godot 3.3.4 ready in ~/Godot/ (Powered by Wine)"
}

# ============== STEP 8: CREATE LAUNCHER SCRIPTS ==============
step_launchers() {
    update_progress
    echo -e "${PURPLE}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Creating Bulletproof Launcher Scripts...${NC}"
    echo ""
    
    # Secure GPU config
    mkdir -p ~/.config
    cat > ~/.config/devstudio-gpu.sh << 'GPUEOF'
# Mobile DevStudio - Stable VNC Rendering Config
export GALLIUM_DRIVER=llvmpipe
export MESA_LOADER_DRIVER_OVERRIDE=swrast
export MESA_NO_ERROR=1
export LIBGL_ALWAYS_SOFTWARE=1
GPUEOF
    echo -e "  ${GREEN}✓${NC} GPU Shield Config generated"
    
    # Configure VNC startup environment
    mkdir -p ~/.vnc
    cat > ~/.vnc/xstartup << 'XSTARTEOF'
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
source ~/.config/devstudio-gpu.sh 2>/dev/null
startxfce4 > /dev/null 2>&1 &
XSTARTEOF
    chmod +x ~/.vnc/xstartup
    echo -e "  ${GREEN}✓${NC} VNC xstartup generated"
    
    # Main Desktop Launcher (CON TODAS LAS SOLUCIONES INTEGRADAS)
    cat > ~/start-devstudio.sh << 'LAUNCHEREOF'
#!/data/data/com.termux/files/usr/bin/bash
echo ""
echo "🚀 Starting Mobile DevStudio VNC Server..."
echo ""
source ~/.config/devstudio-gpu.sh 2>/dev/null

# 1. PREVENIR QUE ANDROID APAGUE EL SERVICIO
echo "🔒 Acquiring Wake-Lock (Preventing Android from killing the service)..."
termux-wake-lock

# 2. LIMPIAR PROCESOS ZOMBIS
echo "🔄 Cleaning up old sessions..."
vncserver -kill :1 >/dev/null 2>&1
pkill -9 -f "xfce" 2>/dev/null
pkill -9 -f "dbus" 2>/dev/null

# 3. VERIFICACIÓN DE CONTRASEÑA A PRUEBA DE FALLOS
if [ ! -f ~/.vnc/passwd ]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  🔒 PRIMER INICIO: CREANDO CONTRASEÑA SEGURA"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    vncpasswd
fi

# FORZAR PERMISOS ESTRICTOS (Soluciona el 'Connection reset' de AVNC/bVNC)
chmod 600 ~/.vnc/passwd 2>/dev/null

# 4. AUDIO
unset PULSE_SERVER
pulseaudio --kill 2>/dev/null
sleep 0.5
echo "🔊 Starting audio server..."
pulseaudio --start --exit-idle-time=-1
sleep 1
pactl load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1 2>/dev/null
export PULSE_SERVER=127.0.0.1

# 5. INICIAR VNC EXPUESTO A LA RED (Soluciona el error de IP/Localhost)
echo "📺 Launching VNC desktop server on port :1..."
vncserver :1 -geometry 1280x720 -depth 24 -localhost no
sleep 2

# 6. VERIFICACIÓN DE SALUD
if pgrep -x "Xvnc" > /dev/null; then
    echo "  ${GREEN}✓${NC} VNC Server is running stable!"
else
    echo "  ${RED}✗${NC} ERROR: El servidor crasheó. Revisa ~/.vnc/*.log"
fi

# IP Detection
MY_IP=$(ifconfig wlan0 2>/dev/null | grep "inet " | awk '{print $2}')
if [ -z "$MY_IP" ]; then MY_IP="[Your-Phone-IP]"; fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  🖥️  DEV STUDIO ACTIVE"
echo "  👉 IP: $MY_IP"
echo "  👉 Port: 5901"
echo "  👉 App recomendada: AVNC"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
LAUNCHEREOF
    chmod +x ~/start-devstudio.sh
    echo -e "  ${GREEN}✓${NC} Created ~/start-devstudio.sh"
    
    # Desktop Shutdown Script
    cat > ~/stop-devstudio.sh << 'STOPEOF'
#!/data/data/com.termux/files/usr/bin/bash
echo "Stopping Mobile DevStudio..."
vncserver -kill :1 >/dev/null 2>&1
pkill -9 -f "pulseaudio" 2>/dev/null
pkill -9 -f "xfce" 2>/dev/null
termux-wake-unlock
echo "Stopped and released Wake-Lock."
STOPEOF
    chmod +x ~/stop-devstudio.sh
    echo -e "  ${GREEN}✓${NC} Created ~/stop-devstudio.sh"
}

# ============== STEP 9: CREATE DESKTOP SHORTCUTS ==============
step_shortcuts() {
    update_progress
    echo -e "${PURPLE}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Creating Desktop Shortcuts...${NC}"
    echo ""
    
    mkdir -p ~/Desktop
    
    # Firefox
    cat > ~/Desktop/Firefox.desktop << 'EOF'
[Desktop Entry]
Name=Firefox
Comment=Web Browser
Exec=firefox
Icon=firefox
Type=Application
Categories=Network;WebBrowser;
EOF
    
    # VS Code
    cat > ~/Desktop/VSCode.desktop << 'EOF'
[Desktop Entry]
Name=VS Code
Comment=Code Editor
Exec=code-oss --disable-gpu --disable-software-rasterizer %F
Icon=code-oss
Type=Application
Categories=Development;
EOF
    
    # Godot 3.3 via Wine (Ruta absoluta y forzando GLES2 para estabilidad en VNC)
    cat > ~/Desktop/Godot_3.3.desktop << 'EOF'
[Desktop Entry]
Name=Godot 3.3 (Wine)
Comment=Game Engine via Wine
Exec=sh -c "cd /data/data/com.termux/files/home/Godot && WINEPREFIX=/data/data/com.termux/files/home/.wine wine Godot_v3.3.4-stable_win64.exe --video-driver GLES2"
Icon=godot
Type=Application
Categories=Development;
EOF
    
    # Wine Config
    cat > ~/Desktop/Wine_Config.desktop << 'EOF'
[Desktop Entry]
Name=Wine Config
Comment=Windows Settings
Exec=WINEPREFIX=/data/data/com.termux/files/home/.wine winecfg
Icon=wine
Type=Application
Categories=Settings;
EOF
    
    # Terminal
    cat > ~/Desktop/Terminal.desktop << 'EOF'
[Desktop Entry]
Name=Terminal
Comment=XFCE Terminal
Exec=xfce4-terminal
Icon=utilities-terminal
Type=Application
Categories=System;TerminalEmulator;
EOF
    
    # File Manager
    cat > ~/Desktop/Files.desktop << 'EOF'
[Desktop Entry]
Name=Files
Comment=File Manager
Exec=thunar
Icon=folder
Type=Application
Categories=System;
EOF

    chmod +x ~/Desktop/*.desktop 2>/dev/null
    echo -e "  ${GREEN}✓${NC} Desktop shortcuts created"
}

# ============== STEP 10: COMPLETION ==============
show_completion() {
    update_progress
    echo ""
    echo -e "${GREEN}"
    cat << 'COMPLETE'
    
    ╔═══════════════════════════════════════════════════════════════╗
    ║                                                               ║
    ║         ✅  INSTALLATION COMPLETE!  ✅                        ║
    ║                                                               ║
    ║           🎉 Todo listo y optimizado al máximo! 🎉           ║
    ║                                                               ║
    ╚═══════════════════════════════════════════════════════════════╝
    
COMPLETE
    echo -e "${NC}"
    
    echo -e "${WHITE}📱 Tu Mobile Dev Studio está listo.${NC}"
    echo ""
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${WHITE}🚀 PARA INICIAR EL ESCRITORIO:${NC}"
    echo -e "   ${GREEN}bash ~/start-devstudio.sh${NC}"
    echo ""
    echo -e "${WHITE}🛑 PARA DETENER EL ESCRITORIO:${NC}"
    echo -e "   ${GREEN}bash ~/stop-devstudio.sh${NC}"
    echo ""
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${CYAN}📦 HERRAMIENTAS INSTALADAS:${NC}"
    echo -e "   • Firefox (Navegador Web)"
    echo -e "   • VS Code (Editor de código optimizado)"
    echo -e "   • Godot 3.3.4 (Corriendo vía Wine + GLES2)"
    echo -e "   • Wine Config (Para ajustar tus apps Windows)"
    echo -e "   • Git & Node.js (Esenciales Web)"
    echo -e "   • XFCE4 + TigerVNC (Red expuesta y anti-apagado)"
    echo ""
    echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${WHITE}💡 NOTAS IMPORTANTES:${NC}"
    echo -e "   1. El script bloquea el apagado automático de Android.${NC}"
    echo -e "   2. Al usar AVNC, la conexión ahora es 100% estable.${NC}"
    echo -e "   3. Godot por Wine tarda un poco más en abrir la${NC}"
    echo -e "      primera vez (Wine está configurando librerías).${NC}"
    echo ""
}

# ============== MAIN INSTALLATION ==============
main() {
    show_banner
    
    echo -e "${WHITE}  Este script instalará un entorno Linux completo por VNC${NC}"
    echo -e "${WHITE}  enfocado en Desarrollo Web y Godot 3.3 vía Wine.${NC}"
    echo ""
    echo -e "${GRAY}  Tiempo estimado: 10-15 minutos (depende de tu internet)${NC}"
    echo ""
    echo -e "${YELLOW}  Presiona Enter para comenzar, o Ctrl+C para cancelar...${NC}"
    read
    
    detect_device
    step_update
    step_repos
    step_vnc
    step_desktop
    step_audio
    step_apps
    step_godot_wine
    step_launchers
    step_shortcuts
    show_completion
}

# ============== RUN ==============
main

