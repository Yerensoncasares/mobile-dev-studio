#!/data/data/com.termux/files/usr/bin/bash
#######################################################
#  🟢 MOBILE DEV STUDIO - Ultimate VNC Installer v3.1
#  
#  UI Theme: Verdant Cyberpunk (Mint & Lime High-Contrast)
#  
#  Features:
#  - TigerVNC Server (Network exposed & Battery protected)
#  - Web Dev Stack (Node.js, Git, VS Code, Firefox)
#  - Local AI Copilot Engine (Ollama + Qwen Coder Sandbox)
#  - Custom Zsh Shell Injection (OhMyZsh Automated Setup)
#  - Categorized Creative & System Tools (Audacity, mtPaint, htop, ePDFView)
#######################################################

# ============== CONFIGURATION ==============
TOTAL_STEPS=12
CURRENT_STEP=0

# ============== VERDANT CYBER PALETTE ==============
LIME='\033[1;32m'      # Verde brillante (Texto principal / Éxito)
FOREST='\033[0;32m'    # Verde oscuro (Subtextos y bordes)
MINT='\033[1;36m'      # Menta/Cian brillante (Pasos y Títulos)
TEAL='\033[0;36m'      # Azul Teal (Detalles y variables)
YELLOW='\033[1;33m'    # Amarillo/Limón (Carga y Advertencias)
WHITE='\033[1;37m'     # Blanco puro (Valores y destaques)
GRAY='\033[0;90m'      # Gris oscuro (Barra vacía)
RED='\033[0;31m'       # Rojo (Errores críticos)
NC='\033[0m'           # Reset

# ============== PROGRESS FUNCTIONS ==============
update_progress() {
    CURRENT_STEP=$((CURRENT_STEP + 1))
    PERCENT=$((CURRENT_STEP * 100 / TOTAL_STEPS))
    
    FILLED=$((PERCENT / 5))
    EMPTY=$((20 - FILLED))
    
    BAR="${LIME}"
    for ((i=0; i<FILLED; i++)); do BAR+="█"; done
    BAR+="${GRAY}"
    for ((i=0; i<EMPTY; i++)); do BAR+="░"; done
    BAR+="${NC}"
    
    echo ""
    echo -e "${FOREST}🟢 ════════════════════════════════════════════════════════════════ 🟢${NC}"
    echo -e "  ${MINT}📊 SYSTEM STATUS: ${WHITE}Step ${CURRENT_STEP}/${TOTAL_STEPS}${NC} ${BAR} ${LIME}${PERCENT}%${NC}"
    echo -e "${FOREST}════════════════════════════════════════════════════════════════════${NC}"
    echo ""
}

spinner() {
    local pid=$1
    local message=$2
    local spin='▱▰▱▰'
    local i=0
    
    while kill -0 $pid 2>/dev/null; do
        i=$(( (i+1) % 4 ))
        printf "\r  ${YELLOW}⚡${NC} ${message} ${LIME}${spin:$i:1}${NC}  "
        sleep 0.15
    done
    
    wait $pid
    local exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        printf "\r  ${LIME}✓${NC} ${message}                    \n"
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
    echo -e "${LIME}"
    cat << 'BANNER'
    ⚡▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄⚡
      █                                        █
      █   🚀  MOBILE DEV STUDIO v3.1  🚀       █
      █     (Categorized Tools + AI Sandbox)   █
      █                                        █
    ⚡▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀⚡
BANNER
    echo -e "${NC}"
    echo -e "         ${MINT}⚡ Environment:${WHITE} Web Frontend + Local AI Workspace${NC}"
    echo ""
}

detect_device() {
    echo -e "${MINT}[*] Analyzing Android Environment...${NC}"
    echo ""
    DEVICE_MODEL=$(getprop ro.product.model 2>/dev/null || echo "Unknown")
    DEVICE_BRAND=$(getprop ro.product.brand 2>/dev/null || echo "Unknown")
    ANDROID_VERSION=$(getprop ro.build.version.release 2>/dev/null || echo "Unknown")
    CPU_ABI=$(getprop ro.product.cpu.abi 2>/dev/null || echo "arm64-v8a")
    
    echo -e "  ${LIME}📱${NC} Core Device: ${WHITE}${DEVICE_BRAND} ${DEVICE_MODEL}${NC}"
    echo -e "  ${LIME}🤖${NC} OS Kernel:   ${WHITE}Android ${ANDROID_VERSION}${NC}"
    echo -e "  ${LIME}⚙️${NC}  Processor:  ${WHITE}${CPU_ABI} (ARM64 Native)${NC}"
    echo ""
    sleep 1
}

# ============== STEPS 1 - 2: ENVIRONMENT SYNC ==============
step_update() {
    update_progress
    echo -e "${MINT}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Syncing Core Repositories...${NC}"
    echo ""
    (yes | pkg update -y > /dev/null 2>&1) &
    spinner $! "Updating repository index..."
    (yes | pkg upgrade -y > /dev/null 2>&1) &
    spinner $! "Upgrading core system packages..."
}

step_repos() {
    update_progress
    echo -e "${MINT}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Injecting Extra Repositories...${NC}"
    echo ""
    install_pkg "x11-repo" "X11 Repository"
    install_pkg "tur-repo" "TUR Repository (Firefox, VS Code, Wine)"
}

# ============== STEP 3: DIRECTORIES ==============
step_structure() {
    update_progress
    echo -e "${MINT}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Structuring Workspace Categories...${NC}"
    echo ""
    (mkdir -p ~/Desktop ~/Godot ~/Automation ~/Scripts) &
    spinner $! "Creating categorical directories..."
}

# ============== STEPS 4 - 6: GRAPHICS & AUDIO ==============
step_vnc() {
    update_progress
    echo -e "${MINT}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Deploying TigerVNC Protocol...${NC}"
    echo ""
    install_pkg "tigervnc" "TigerVNC Display Server"
}

step_desktop() {
    update_progress
    echo -e "${MINT}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Erecting XFCE4 Graphic Interface...${NC}"
    echo ""
    install_pkg "xfce4" "XFCE4 Desktop Environment"
    install_pkg "xfce4-terminal" "XFCE4 Terminal"
    install_pkg "thunar" "Thunar File Manager"
}

step_audio() {
    update_progress
    echo -e "${MINT}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Linking PulseAudio Framework...${NC}"
    echo ""
    install_pkg "pulseaudio" "PulseAudio Sound Server"
}

# ============== STEP 7: COMPILING COMPREHENSIVE APPS STACK ==============
step_apps() {
    update_progress
    echo -e "${MINT}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Compiling Dev & Creative Tools Stack...${NC}"
    echo ""
    
    # Core Dev
    install_pkg "firefox" "Firefox Browser"
    install_pkg "code-oss" "VS Code Editor"
    install_pkg "git" "Git Version Control"
    install_pkg "nodejs" "Node.js Engine"
    
    # Solicitados e indispensables del sistema
    install_pkg "htop" "Htop Performance Monitor"
    install_pkg "mtpaint" "mtPaint Pixel-Art Editor"
    install_pkg "audacity" "Audacity Audio Studio"
    install_pkg "epdfview" "ePDFView Lightweight Reader"
    install_pkg "p7zip" "7-Zip Extraction Engine"
    
    # Utilidades base
    install_pkg "wget" "Wget Downloader"
    install_pkg "curl" "cURL Tool"
    install_pkg "unzip" "Unzip Extractor"
    install_pkg "zsh" "Zsh Shell"
}

# ============== STEP 8: OHMYZSH INJECTION ==============
step_zsh_setup() {
    update_progress
    echo -e "${MINT}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Injecting OhMyZsh Framework...${NC}"
    echo ""
    if [ ! -d ~/.oh-my-zsh ]; then
        (sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended > /dev/null 2>&1) &
        spinner $! "Downloading and configuring OhMyZsh..."
        chsh -s zsh
    else
        echo -e "  ${LIME}✓${NC} OhMyZsh environment active."
    fi
}

# ============== STEP 9: OLLAMA ARCHITECTURE ==============
step_ai_setup() {
    update_progress
    echo -e "${MINT}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Establishing Local AI Assistant Architecture...${NC}"
    echo ""
    install_pkg "ollama" "Ollama AI Engine"
    
    echo -e "  ${YELLOW}⚡${NC} Activating background engine for model sync..."
    ollama serve > /dev/null 2>&1 &
    local server_pid=$!
    sleep 3
    
    echo -e "  ${YELLOW}📦${NC} Pulling lightweight coding brain (Qwen2.5-Coder:1.5b)..."
    ollama pull qwen2.5-coder:1.5b
    
    kill $server_pid 2>/dev/null
    wait $server_pid 2>/dev/null
    pkill -9 -f "ollama" 2>/dev/null
}

# ============== STEP 10: WINE SANDBOX ==============
step_wine_setup() {
    update_progress
    echo -e "${MINT}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Establishing Wine Translation Layer...${NC}"
    echo ""
    install_pkg "hangover-wine" "Wine Compatibility Layer"
    install_pkg "hangover-wowbox64" "Box64 Architecture Wrapper"
    
    ln -sf /data/data/com.termux/files/usr/opt/hangover-wine/bin/wine /data/data/com.termux/files/usr/bin/wine
    ln -sf /data/data/com.termux/files/usr/opt/hangover-wine/bin/winecfg /data/data/com.termux/files/usr/bin/winecfg
    
    echo -e "  ${YELLOW}⏳${NC} Building Wine prefix (~/.wine)..."
    export GALLIUM_DRIVER=llvmpipe
    WINEPREFIX=~/.wine wineboot --init > /dev/null 2>&1
}

# ============== STEP 11: SCRIPTS PERSISTENCE ==============
step_launchers() {
    update_progress
    echo -e "${MINT}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Generating Execution Launchers...${NC}"
    echo ""
    
    mkdir -p ~/.config
    cat > ~/.config/devstudio-gpu.sh << 'GPUEOF'
export GALLIUM_DRIVER=llvmpipe
export MESA_LOADER_DRIVER_OVERRIDE=swrast
export MESA_NO_ERROR=1
export LIBGL_ALWAYS_SOFTWARE=1
GPUEOF
    chmod +x ~/.config/devstudio-gpu.sh

    mkdir -p ~/.vnc
    cat > ~/.vnc/xstartup << 'XSTARTEOF'
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
source ~/.config/devstudio-gpu.sh 2>/dev/null
startxfce4 > /dev/null 2>&1 &
XSTARTEOF
    chmod +x ~/.vnc/xstartup
    
    # START SCRIPT (Con bypass silencioso para el servidor de IA)
    cat > ~/Scripts/start-devstudio.sh << 'LAUNCHEREOF'
#!/data/data/com.termux/files/usr/bin/bash
echo ""
echo -e "\033[1;32m🚀 Activating Mobile DevStudio Core System v3.1...\033[0m"
termux-wake-lock
vncserver -kill :1 >/dev/null 2>&1
pkill -9 -f "xfce" 2>/dev/null
pkill -9 -f "dbus" 2>/dev/null
pkill -9 -f "ollama" 2>/dev/null

unset PULSE_SERVER
pulseaudio --kill 2>/dev/null
sleep 0.5
pulseaudio --start --exit-idle-time=-1
sleep 1
pactl load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1 2>/dev/null
export PULSE_SERVER=127.0.0.1

echo "🤖 Initializing Local AI Assistant Engine in silent mode..."
ollama serve > /dev/null 2>&1 &
sleep 2

vncserver :1 -geometry 1280x720 -depth 24 -localhost no
sleep 2

MY_IP=$(ifconfig wlan0 2>/dev/null | grep "inet " | awk '{print $2}')
if [ -z "$MY_IP" ]; then MY_IP="[Your-Phone-IP]"; fi

echo ""
echo -e "\033[0;32m🟢 ══════════════════════════════════════════════ 🟢\033[0m"
echo -e "  \033[1;36m🖥️  DEV STUDIO ACTIVE WORKSTATION\033[0m"
echo -e "  \033[1;37m👉 IP:\033[0m \033[1;32m$MY_IP :5901\033[0m"
echo -e "  \033[1;37m👉 AI:\033[0m \033[1;33mollama run qwen2.5-coder:1.5b\033[0m"
echo -e "\033[0;32m═════════════════════════════════════════════════\033[0m"
LAUNCHEREOF
    chmod +x ~/Scripts/start-devstudio.sh
    ln -sf ~/Scripts/start-devstudio.sh ~/start-devstudio.sh

    # STOP SCRIPT
    cat > ~/Scripts/stop-devstudio.sh << 'STOPEOF'
#!/data/data/com.termux/files/usr/bin/bash
vncserver -kill :1 >/dev/null 2>&1
pkill -9 -f "pulseaudio" 2>/dev/null
pkill -9 -f "xfce" 2>/dev/null
pkill -9 -f "ollama" 2>/dev/null
termux-wake-unlock
echo "System resting. Wake-Lock released."
STOPEOF
    chmod +x ~/Scripts/stop-devstudio.sh
    ln -sf ~/Scripts/stop-devstudio.sh ~/stop-devstudio.sh

    # CLEANUP SCRIPT (Cruzado: VNC + Ollama + NPM)
    cat > ~/Scripts/cleanup.sh << 'CLEANUPEOF'
#!/bin/bash
echo "🧹 Iniciando limpieza masiva de mantenimiento..."
vncserver -kill :1 >/dev/null 2>&1
pkill -9 -f "ollama" 2>/dev/null
rm -rf /tmp/.X11-unix/X*
rm -rf /tmp/.X*-lock
rm -rf ~/.vnc/*.pid
rm -rf ~/.vnc/*.log
rm -rf /tmp/*
rm -rf ~/.cache/*
npm cache clean --force 2>/dev/null
echo "✨ ¡Sistema limpio y purgado al 100%!"
CLEANUPEOF
    chmod +x ~/Scripts/cleanup.sh
    ln -sf ~/Scripts/cleanup.sh ~/cleanup.sh
}

# ============== STEP 12: SHORTCUTS BY CATEGORIES ==============
step_shortcuts() {
    update_progress
    echo -e "${MINT}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Pushing Workspace Shortcuts...${NC}"
    echo ""
    
    # --- CATEGORÍA 1: DESARROLLO FRONTEND & WEB ---
    cat > ~/Desktop/Firefox.desktop << 'EOF'
[Desktop Entry]
Name=Firefox
Comment=Web Browser
Exec=firefox
Icon=firefox
Type=Application
Categories=Network;WebBrowser;
EOF
    
    cat > ~/Desktop/VSCode.desktop << 'EOF'
[Desktop Entry]
Name=VS Code
Comment=Code Editor
Exec=code-oss --disable-gpu --disable-software-rasterizer %F
Icon=code-oss
Type=Application
Categories=Development;
EOF

    # --- CATEGORÍA 2: VIDEOJUEGOS (GODOT ENGINE) ---
    cat > ~/Desktop/Godot_3.3.desktop << 'EOF'
[Desktop Entry]
Name=Godot 3.3 (Wine)
Comment=Game Engine via Wine
Exec=sh -c "cd /data/data/com.termux/files/home/Godot && WINEPREFIX=/data/data/com.termux/files/home/.wine wine Godot_v3.3.4-stable_win64.exe --video-driver GLES2"
Icon=godot
Type=Application
Categories=Development;
EOF

    cat > ~/Desktop/Wine_Config.desktop << 'EOF'
[Desktop Entry]
Name=Wine Config
Comment=Windows Settings
Exec=WINEPREFIX=/data/data/com.termux/files/home/.wine winecfg
Icon=wine
Type=Application
Categories=Settings;
EOF

    # --- CATEGORÍA 3: MULTIMEDIA Y DISEÑO (NUEVOS!) ---
    cat > ~/Desktop/Audacity.desktop << 'EOF'
[Desktop Entry]
Name=Audacity
Comment=Audio Editor
Exec=audacity
Icon=audacity
Type=Application
Categories=AudioVideo;AudioEditing;
EOF

    cat > ~/Desktop/mtPaint.desktop << 'EOF'
[Desktop Entry]
Name=mtPaint
Comment=Pixel Art Graphic Editor
Exec=mtpaint
Icon=mtpaint
Type=Application
Categories=Graphics;2DGraphics;
EOF

    # --- CATEGORÍA 4: PRODUCTIVIDAD Y SISTEMA ---
    cat > ~/Desktop/PDF_Reader.desktop << 'EOF'
[Desktop Entry]
Name=ePDFView
Comment=Lightweight PDF Document Viewer
Exec=epdfview
Icon=document-print
Type=Application
Categories=Office;Viewer;
EOF

    cat > ~/Desktop/Htop_Monitor.desktop << 'EOF'
[Desktop Entry]
Name=Htop Monitor
Comment=Process and Core Monitor
Exec=xfce4-terminal -e htop
Icon=utilities-system-monitor
Type=Application
Categories=System;
EOF
    
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
    echo -e "  ${LIME}✓${NC} Shortcuts organized on Desktop."
}

# ============== RUN ==============
main() {
    show_banner
    echo -e "${WHITE}  Iniciando instalación definitiva con suite de diseño y monitores...${NC}"
    echo ""
    detect_device
    step_update
    step_repos
    step_structure
    step_vnc
    step_desktop
    step_audio
    step_apps
    step_zsh_setup
    step_ai_setup
    step_wine_setup
    step_launchers
    step_shortcuts
    echo -e "\n${LIME}¡PROCESO COMPLETADO EXITOSAMENTE! Corre 'bash ~/start-devstudio.sh' para arrancar.${NC}\n"
}

main
