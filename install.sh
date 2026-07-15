#!/data/data/com.termux/files/usr/bin/bash
#######################################################
#  🎨 MOBILE DEV STUDIO - Lightweight VNC Installer v1.1
#  
#  Features:
#  - TigerVNC Server (Optimized for TV/PC Clients)
#  - Forced llvmpipe software rendering (Max stability)
#  - Focused on Web Dev & Godot 3 (Zero bloat, Zero Emulation)
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
    ║   🚀  MOBILE DEV STUDIO v1.1  🚀       ║
    ║      (Lightweight VNC Edition)         ║
    ║                                        ║
    ╚════════════════════════════════════════╝
BANNER
    echo -e "${NC}"
    echo -e "${WHITE}         Web Dev + Godot 3 Native ARM64${NC}"
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
    install_pkg "tur-repo" "TUR Repository (Firefox, VS Code, Godot)"
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
}

# ============== STEP 7: INSTALL GODOT 3 (NATIVE) ==============
step_godot() {
    update_progress
    echo -e "${PURPLE}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Installing Godot 3 (Native ARM64)...${NC}"
    echo ""
    
    # SOLUCIÓN: Instalamos el paquete nativo 'godot3' del repositorio TUR.
    # Esto evita usar Box64 que saturaba la RAM y mataba el servidor VNC.
    install_pkg "godot3" "Godot 3 Engine (Native ARM64)"
    
    echo -e "  ${GREEN}✓${NC} Godot 3 native installed successfully (Ultra stable!)"
}

# ============== STEP 8: CREATE LAUNCHER SCRIPTS ==============
step_launchers() {
    update_progress
    echo -e "${PURPLE}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Creating Launcher Scripts...${NC}"
    echo ""
    
    # Secure GPU config
    mkdir -p ~/.config
    cat > ~/.config/devstudio-gpu.sh << 'GPUEOF'
# Mobile DevStudio - Stable VNC Rendering Config
export GALLIUM_DRIVER=llvmpipe
export MESA_LOADER_DRIVER_OVERRIDE=swrast
export MESA_NO_ERROR=1
GPUEOF
    echo -e "  ${GREEN}✓${NC} GPU Config generated"
    
    # Configure VNC startup environment
    mkdir -p ~/.vnc
    cat > ~/.vnc/xstartup << 'XSTARTEOF'
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
source ~/.config/devstudio-gpu.sh 2>/dev/null
startxfce4 &
XSTARTEOF
    chmod +x ~/.vnc/xstartup
    echo -e "  ${GREEN}✓${NC} VNC xstartup generated"
    
    # Main Desktop Launcher
    cat > ~/start-devstudio.sh << 'LAUNCHEREOF'
#!/data/data/com.termux/files/usr/bin/bash
echo ""
echo "🚀 Starting Mobile DevStudio VNC Server..."
echo ""
source ~/.config/devstudio-gpu.sh 2>/dev/null

# Clean up existing sessions
echo "🔄 Cleaning up old sessions..."
vncserver -kill :1 >/dev/null 2>&1
pkill -9 -f "xfce" 2>/dev/null
pkill -9 -f "dbus" 2>/dev/null

# === AUDIO SETUP ===
unset PULSE_SERVER
pulseaudio --kill 2>/dev/null
sleep 0.5
echo "🔊 Starting audio server..."
pulseaudio --start --exit-idle-time=-1
sleep 1
pactl load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1 2>/dev/null
export PULSE_SERVER=127.0.0.1
# === END AUDIO ===

# Start TigerVNC Server
echo "📺 Launching VNC desktop server on port :1..."
vncserver :1 -geometry 1280x720 -depth 24
sleep 2

# IP Detection
MY_IP=$(ifconfig wlan0 2>/dev/null | grep "inet " | awk '{print $2}')
if [ -z "$MY_IP" ]; then
    MY_IP="[Your-Phone-IP]"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  🖥️  DEV STUDIO ACTIVE ON VNC SERVER"
echo "  "
echo "  🔗 Connection details:"
echo "  👉 Address/IP: $MY_IP"
echo "  👉 Port: 5901 (or Display :1)"
echo "  👉 Password: (The one you defined just now)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
LAUNCHEREOF
    chmod +x ~/start-devstudio.sh
    echo -e "  ${GREEN}✓${NC} Created ~/start-devstudio.sh"
    
    # Desktop Shutdown Script
    cat > ~/stop-devstudio.sh << 'STOPEOF'
#!/data/data/com.termux/files/usr/bin/bash
echo "Stopping Mobile DevStudio VNC Server..."
vncserver -kill :1 >/dev/null 2>&1
pkill -9 -f "pulseaudio" 2>/dev/null
pkill -9 -f "xfce" 2>/dev/null
pkill -9 -f "dbus" 2>/dev/null
echo "VNC Desktop stopped."
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
    
    # VS Code (Optimized to avoid crashes on llvmpipe)
    cat > ~/Desktop/VSCode.desktop << 'EOF'
[Desktop Entry]
Name=VS Code
Comment=Code Editor
Exec=code-oss --disable-gpu --disable-software-rasterizer %F
Icon=code-oss
Type=Application
Categories=Development;
EOF
    
    # Godot 3 Native (Using GLES2 for llvmpipe stability)
    cat > ~/Desktop/Godot_3.desktop << 'EOF'
[Desktop Entry]
Name=Godot 3
Comment=Game Engine
Exec=godot3 --video-driver GLES2
Icon=godot
Type=Application
Categories=Development;
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
    ║              🎉 100% - Lightweight Setup Ready! 🎉            ║
    ║                                                               ║
    ╚═══════════════════════════════════════════════════════════════╝
    
COMPLETE
    echo -e "${NC}"
    
    echo -e "${WHITE}📱 Your Mobile Dev Studio is ready!${NC}"
    echo ""
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${WHITE}🚀 TO START THE DESKTOP:${NC}"
    echo -e "   ${GREEN}bash ~/start-devstudio.sh${NC}"
    echo ""
    echo -e "${WHITE}🛑 TO STOP THE DESKTOP:${NC}"
    echo -e "   ${GREEN}bash ~/stop-devstudio.sh${NC}"
    echo ""
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${CYAN}📦 INSTALLED TOOLS:${NC}"
    echo -e "   • Firefox (Navegador)"
    echo -e "   • VS Code (Optimizado para no crashear)"
    echo -e "   • Godot 3 (Nativo ARM64, sin emulaciones pesadas)"
    echo -e "   • Git & Node.js (Esenciales Web)"
    echo -e "   • XFCE4 + TigerVNC (Entorno gráfico ligero)"
    echo ""
    echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${WHITE}⚡ TIP: Si VS Code se siente lento al abrir archivos grandes,${NC}"
    echo -e "${WHITE}   recuerda que puedes instalar 'geany' desde la terminal (${GRAY}pkg i geany${WHITE})${NC}"
    echo -e "${WHITE}   Es un editor de código ultra-ligero que vuela en el teléfono.${NC}"
    echo ""
    echo -e "${WHITE}🎮 TIP GODOT: Se abrió con GLES2 para no saturar tu teléfono.${NC}"
    echo -e "${WHITE}   En Project Settings -> Rendering -> Quality, asegúrate de${NC}"
    echo -e "${WHITE}   usar 'Low' o 'Medium' para un rendimiento perfecto.${NC}"
    echo ""
}

# ============== MAIN INSTALLATION ==============
main() {
    show_banner
    
    echo -e "${WHITE}  This script will install a lightweight Linux desktop (VNC)${NC}"
    echo -e "${WHITE}  focused on Web Development and Godot 3 (Native).${NC}"
    echo ""
    echo -e "${GRAY}  Estimated time: 5-10 minutes (depends on internet speed)${NC}"
    echo ""
    echo -e "${YELLOW}  Press Enter to start installation, or Ctrl+C to cancel...${NC}"
    read
    
    detect_device
    step_update
    step_repos
    step_vnc
    step_desktop
    step_audio
    step_apps
    step_godot
    step_launchers
    step_shortcuts
    show_completion
}

# ============== RUN ==============
main
