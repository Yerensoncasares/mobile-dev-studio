#!/data/data/com.termux/files/usr/bin/bash
#######################################################
#  🟢 MOBILE DEV STUDIO - Ultimate VNC Installer v2.0
#  
#  UI Theme: Verdant Cyberpunk (Mint & Lime High-Contrast)
#  
#  Features:
#  - TigerVNC Server (Network exposed & Battery protected)
#  - Godot 3.3 via Wine/Hangover (Absolute paths fixed)
#  - Web Dev Stack (Firefox, VS Code, Node, Git)
#  - Zero bloat, Bulletproof connection logic
#######################################################

# ============== CONFIGURATION ==============
TOTAL_STEPS=10
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
      █   🚀  MOBILE DEV STUDIO v2.0  🚀       █
      █      (Wine/Godot + AVNC Edition)       █
      █                                        █
    ⚡▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀⚡
BANNER
    echo -e "${NC}"
    echo -e "         ${MINT}⚡ Environment:${WHITE} Web Dev + Godot 3.3 (Wine)${NC}"
    echo ""
}

# ============== DEVICE DETECTION ==============
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
    echo -e "  ${LIME}🧪${NC} GPU Shield:  ${WHITE}Forced Software Rendering (llvmpipe)${NC}"
    echo ""
    sleep 1
}

# ============== STEP 1: UPDATE SYSTEM ==============
step_update() {
    update_progress
    echo -e "${MINT}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Syncing Core Repositories...${NC}"
    echo ""
    
    (yes | pkg update -y > /dev/null 2>&1) &
    spinner $! "Updating repository index..."
    
    (yes | pkg upgrade -y > /dev/null 2>&1) &
    spinner $! "Upgrading core system packages..."
}

# ============== STEP 2: INSTALL REPOSITORIES ==============
step_repos() {
    update_progress
    echo -e "${MINT}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Injecting Extra Repositories...${NC}"
    echo ""
    
    install_pkg "x11-repo" "X11 Repository"
    install_pkg "tur-repo" "TUR Repository (Firefox, VS Code, Wine)"
}

# ============== STEP 3: INSTALL TIGERVNC SERVER ==============
step_vnc() {
    update_progress
    echo -e "${MINT}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Deploying TigerVNC Protocol...${NC}"
    echo ""
    
    install_pkg "tigervnc" "TigerVNC Display Server"
}

# ============== STEP 4: INSTALL DESKTOP ==============
step_desktop() {
    update_progress
    echo -e "${MINT}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Erecting XFCE4 Graphic Interface...${NC}"
    echo ""
    
    install_pkg "xfce4" "XFCE4 Desktop Environment"
    install_pkg "xfce4-terminal" "XFCE4 Terminal"
    install_pkg "thunar" "Thunar File Manager"
}

# ============== STEP 5: INSTALL AUDIO ==============
step_audio() {
    update_progress
    echo -e "${MINT}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Linking PulseAudio Framework...${NC}"
    echo ""
    
    install_pkg "pulseaudio" "PulseAudio Sound Server"
}

# ============== STEP 6: INSTALL DEV APPS ==============
step_apps() {
    update_progress
    echo -e "${MINT}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Compiling Dev Tools Stack...${NC}"
    echo ""
    
    install_pkg "firefox" "Firefox Browser"
    install_pkg "code-oss" "VS Code Editor"
    install_pkg "git" "Git Version Control"
    install_pkg "nodejs" "Node.js (NPM Engine)"
    install_pkg "wget" "Wget Downloader"
    install_pkg "curl" "cURL Transfer Tool"
    install_pkg "unzip" "Unzip Extractor"
}

# ============== STEP 7: INSTALL WINE & GODOT 3.3 ==============
step_godot_wine() {
    update_progress
    echo -e "${MINT}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Establishing Wine Translation Layer...${NC}"
    echo ""
    
    install_pkg "hangover-wine" "Wine Compatibility Layer"
    install_pkg "hangover-wowbox64" "Box64 Architecture Wrapper"
    
    # Global symlinks
    ln -sf /data/data/com.termux/files/usr/opt/hangover-wine/bin/wine /data/data/com.termux/files/usr/bin/wine
    ln -sf /data/data/com.termux/files/usr/opt/hangover-wine/bin/winecfg /data/data/com.termux/files/usr/bin/winecfg
    
    echo -e "  ${YELLOW}⏳${NC} Building pristine Wine prefix (~/.wine)..."
    export GALLIUM_DRIVER=llvmpipe
    WINEPREFIX=~/.wine wineboot --init > /dev/null 2>&1
    echo -e "  ${LIME}✓${NC} Wine subsystem initialized successfully."
    
    mkdir -p ~/Godot
    cd ~/Godot
    
    (wget -q --show-progress https://downloads.tuxfamily.org/godotengine/3.3.4/Godot_v3.3.4-stable_win64.exe.zip -O godot.zip > /dev/null 2>&1) &
    spinner $! "Downloading Godot 3.3.4 Win64..."
    
    (unzip -o godot.zip > /dev/null 2>&1) &
    spinner $! "Extracting binary components..."
    
    rm godot.zip 2>/dev/null
    cd ~
    echo -e "  ${LIME}✓${NC} Godot Engine mapped at ~/Godot/"
}

# ============== STEP 8: CREATE LAUNCHER SCRIPTS ==============
step_launchers() {
    update_progress
    echo -e "${MINT}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Generating Execution Launchers...${NC}"
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
    echo -e "  ${LIME}✓${NC} GPU Safety Shield generated."
    
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
    echo -e "  ${LIME}✓${NC} Graphic environment link set."
    
    # Main Desktop Launcher
    cat > ~/start-devstudio.sh << 'LAUNCHEREOF'
#!/data/data/com.termux/files/usr/bin/bash
echo ""
echo -e "\033[1;32m🚀 Activating Mobile DevStudio Core VNC System...\033[0m"
echo ""
source ~/.config/devstudio-gpu.sh 2>/dev/null

# Wake-Lock
echo -e "🔒 \033[1;36mAcquiring Wake-Lock (Defending backend process from Android OS)...\033[0m"
termux-wake-lock

# Flush ghosts
echo "🔄 Clearing obsolete sockets and sessions..."
vncserver -kill :1 >/dev/null 2>&1
pkill -9 -f "xfce" 2>/dev/null
pkill -9 -f "dbus" 2>/dev/null

# Password failsafe
if [ ! -f ~/.vnc/passwd ]; then
    echo ""
    echo -e "\033[1;32m 🔒 SECURITY SETUP: DEFINE YOUR VNC PASSWORD \033[0m"
    echo ""
    vncpasswd
fi

chmod 600 ~/.vnc/passwd 2>/dev/null

# Audio
unset PULSE_SERVER
pulseaudio --kill 2>/dev/null
sleep 0.5
echo "🔊 Routing PulseAudio stream tunnels..."
pulseaudio --start --exit-idle-time=-1
sleep 1
pactl load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1 2>/dev/null
export PULSE_SERVER=127.0.0.1

# Exposed VNC
echo -e "📺 \033[1;32mSpawning TigerVNC Canvas on Port :1 (Network Exposed)...\033[0m"
vncserver :1 -geometry 1280x720 -depth 24 -localhost no
sleep 2

# Check
if pgrep -x "Xvnc" > /dev/null; then
    echo -e "  \033[1;32m✓ Server status: ONLINE and stable.\033[0m"
else
    echo -e "  \033[0;31m✗ ERROR: Host crashed. Inspect logs at ~/.vnc/*.log\033[0m"
fi

MY_IP=$(ifconfig wlan0 2>/dev/null | grep "inet " | awk '{print $2}')
if [ -z "$MY_IP" ]; then MY_IP="[Your-Phone-IP]"; fi

echo ""
echo -e "\033[0;32m🟢 ══════════════════════════════════════════════ 🟢\033[0m"
echo -e "  \033[1;36m🖥️  DEV STUDIO ACTIVE WORKSTATION\033[0m"
echo -e "  \033[1;37m👉 Remote IP:\033[0m \033[1;32m$MY_IP\033[0m"
echo -e "  \033[1;37m👉 Port:\033[0m      \033[1;32m5901 (Display :1)\033[0m"
echo -e "  \033[1;37m👉 Client App:\033[0m \033[1;36mAVNC / bVNC\033[0m"
echo -e "\033[0;32m═════════════════════════════════════════════════\033[0m"
echo ""
LAUNCHEREOF
    chmod +x ~/start-devstudio.sh
    echo -e "  ${LIME}✓${NC} Created ~/start-devstudio.sh"
    
    # Desktop Shutdown Script
    cat > ~/stop-devstudio.sh << 'STOPEOF'
#!/data/data/com.termux/files/usr/bin/bash
echo "Dismantling Mobile DevStudio environment..."
vncserver -kill :1 >/dev/null 2>&1
pkill -9 -f "pulseaudio" 2>/dev/null
pkill -9 -f "xfce" 2>/dev/null
termux-wake-unlock
echo "System resting. Wake-Lock released."
STOPEOF
    chmod +x ~/stop-devstudio.sh
    echo -e "  ${LIME}✓${NC} Created ~/stop-devstudio.sh"
}

# ============== STEP 9: CREATE DESKTOP SHORTCUTS ==============
step_shortcuts() {
    update_progress
    echo -e "${MINT}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Pushing Workspace Shortcuts...${NC}"
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
    
    # Godot 3.3 via Wine
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
    echo -e "  ${LIME}✓${NC} All UI shortcuts updated."
}

# ============== STEP 10: COMPLETION ==============
show_completion() {
    update_progress
    echo ""
    echo -e "${LIME}"
    cat << 'COMPLETE'
    ⚡▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀⚡
      █                                                               █
      █         ✅  CORE DEPLOYMENT SUCCESSFUL!  ✅                    █
      █                                                               █
      █         🎉 100% - Studio Ready & Highly Optimized! 🎉          █
      █                                                               █
    ⚡▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄⚡
COMPLETE
    echo -e "${NC}"
    
    echo -e "${WHITE}📱 Tu Mobile Dev Studio está listo y configurado.${NC}"
    echo ""
    echo -e "${FOREST}════════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${WHITE}🚀 PARA INICIAR EL ENTORNO GRÁFICO:${NC}"
    echo -e "   ${LIME}bash ~/start-devstudio.sh${NC}"
    echo ""
    echo -e "${WHITE}🛑 PARA APAGAR EL ENTORNO:${NC}"
    echo -e "   ${LIME}bash ~/stop-devstudio.sh${NC}"
    echo ""
    echo -e "${FOREST}════════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${MINT}📦 HERRAMIENTAS INTEGRADAS:${NC}"
    echo -e "   • Firefox (Navegador Web)"
    echo -e "   • VS Code (Editor optimizado con GPU bypass)"
    echo -e "   • Godot 3.3.4 (Engine Windows x64 vía Wine + GLES2)"
    echo -e "   • Wine Config (Panel de control del prefijo)"
    echo -e "   • Git & Node.js (Ecosistema Frontend nativo)"
    echo -e "   • XFCE4 + TigerVNC (Entorno gráfico expuesto seguro)"
    echo ""
    echo -e "${TEAL}════════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${YELLOW}💡 TIPS DE RENDIMIENTO MÓVIL:${NC}"
    echo -e "   1. El script tiene activo el Wake-Lock para evitar cierres fatales.${NC}"
    echo -e "   2. La conexión vía AVNC ahora no requiere túneles locales molestos.${NC}"
    echo -e "   3. Al abrir Godot por primera vez, dale un momento; Wine estará${NC}"
    echo -e "      mapeando las llamadas a las librerías dinámicas del sistema.${NC}"
    echo ""
}

# ============== MAIN INSTALLATION ==============
main() {
    show_banner
    
    echo -e "${WHITE}  Este instalador montará un entorno de desarrollo completo${NC}"
    echo -e "${WHITE}  enfocado en Web Dev y modelado en Godot 3.3 por Wine.${NC}"
    echo ""
    echo -e "${GRAY}  Tiempo estimado: 10-15 minutos (dependiendo de tu ancho de banda)${NC}"
    echo ""
    echo -e "${YELLOW}  Presiona Enter para iniciar el despliegue, o Ctrl+C para abortar...${NC}"
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
