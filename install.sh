#!/data/data/com.termux/files/usr/bin/bash
#######################################################
#  🟢 MOBILE DEV STUDIO - Ultimate Native Workspace v0.3
#  
#  UI Theme: Verdant Cyberpunk (Mint & Lime)
#  
#  Registro Semántico v0.3:
#  - Reestructuración de almacenamiento (Proyectos Web, Apps Linux).
#  - Limpieza de redundancias en scripts de control raíz.
#  - Entorno nativo Godot ARM64 listo para ejecución.
#  - Optimización de Wine + Box64 para compatibilidad DX9.
#######################################################

TOTAL_STEPS=11
CURRENT_STEP=0

LIME='\033[1;32m'
FOREST='\033[0;32m'
MINT='\033[1;36m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'
RED='\033[0;31m'
NC='\033[0m'

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
    return $?
}

install_pkg() {
    local pkg=$1
    local name=${2:-$pkg}
    (yes | pkg install $pkg -y > /dev/null 2>&1) &
    spinner $! "Instalando ${name}..."
}

show_banner() {
    clear
    echo -e "${LIME}"
    cat << 'BANNER'
    ⚡▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄⚡
      █                                        █
      █   🚀  MOBILE DEV STUDIO v0.3   🚀      █
      █     (Native ARM64 Core + Wine Layer)   █
      █                                        █
    ⚡▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀⚡
BANNER
    echo -e "${NC}"
}

detect_device() {
    echo -e "${MINT}[*] Analizando Arquitectura del Dispositivo...${NC}"
    DEVICE_MODEL=$(getprop ro.product.model 2>/dev/null || echo "Unknown")
    DEVICE_BRAND=$(getprop ro.product.brand 2>/dev/null || echo "Unknown")
    ANDROID_VERSION=$(getprop ro.build.version.release 2>/dev/null || echo "Unknown")
    CPU_ABI=$(getprop ro.product.cpu.abi 2>/dev/null || echo "arm64-v8a")
    
    echo -e "  ${LIME}📱${NC} Hardware:   ${WHITE}${DEVICE_BRAND} ${DEVICE_MODEL}${NC}"
    echo -e "  ${LIME}⚙️${NC}  Core ABI:   ${WHITE}${CPU_ABI} (ARM64 Nativo)${NC}"
    echo ""
    sleep 1
}

# ============== PROCESO DE INSTALACIÓN ==============
step_update() {
    update_progress
    echo -e "${MINT}[*] Sincronizando Base del Sistema...${NC}"
    (yes | pkg update -y > /dev/null 2>&1) &
    spinner $! "Actualizando índices..."
    (yes | pkg upgrade -y > /dev/null 2>&1) &
    spinner $! "Actualizando paquetes..."
}

step_repos() {
    update_progress
    echo -e "${MINT}[*] Inyectando Repositorios X11 y TUR...${NC}"
    install_pkg "x11-repo" "X11 Repository"
    install_pkg "tur-repo" "TUR Repository"
}

step_structure() {
    update_progress
    echo -e "${MINT}[*] Creando Estructura de Trabajo Limpia...${NC}"
    mkdir -p ~/Desktop
    mkdir -p ~/Godot/Templates
    mkdir -p ~/Projects
    mkdir -p ~/Automation
    mkdir -p ~/Apps_Linux
}

step_vnc() { update_progress; install_pkg "tigervnc" "TigerVNC Server"; }
step_desktop() {
    update_progress
    install_pkg "xfce4" "Escritorio XFCE4"
    install_pkg "xfce4-terminal" "Terminal Interactiva"
    install_pkg "thunar" "Gestor de Archivos Thunar"
}
step_audio() { update_progress; install_pkg "pulseaudio" "Servidor PulseAudio"; }

step_apps() {
    update_progress
    echo -e "${MINT}[*] Instalando Suite de Herramientas Nativas...${NC}"
    install_pkg "firefox" "Firefox Browser"
    install_pkg "code-oss" "VS Code Editor"
    install_pkg "git" "Git Engine"
    install_pkg "nodejs" "Node.js Engine"
    install_pkg "htop" "Monitor Htop"
    install_pkg "mtpaint" "Editor mtPaint"
    install_pkg "audacity" "Estudio Audacity"
    install_pkg "mupdf" "Visor MuPDF (Estable)"
    install_pkg "p7zip" "Motor de Extracción 7-Zip"
    install_pkg "zsh" "Zsh Shell"
}

step_zsh_setup() {
    update_progress
    if [ ! -d ~/.oh-my-zsh ]; then
        (sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended > /dev/null 2>&1) &
        spinner $! "Configurando OhMyZsh de forma desatendida..."
        chsh -s zsh
    fi
}

step_ai_setup() {
    update_progress
    echo -e "${MINT}[*] Inicializando Entorno de IA Inteligente Local...${NC}"
    install_pkg "ollama" "Ollama AI Engine"
    ollama serve > /dev/null 2>&1 &
    local server_pid=$!
    sleep 3
    ollama pull qwen2.5-coder:1.5b
    kill $server_pid 2>/dev/null
    pkill -9 -f "ollama" 2>/dev/null
}

step_wine_setup() {
    update_progress
    echo -e "${MINT}[*] Ajustando Wine + Box64 (Perfil Compatibilidad DX9)...${NC}"
    install_pkg "hangover-wine" "Wine Translation Layer"
    install_pkg "hangover-wowbox64" "Box64 Wrapper"
    
    ln -sf /data/data/com.termux/files/usr/opt/hangover-wine/bin/wine /data/data/com.termux/files/usr/bin/wine
    ln -sf /data/data/com.termux/files/usr/opt/hangover-wine/bin/winecfg /data/data/com.termux/files/usr/bin/winecfg
    
    export GALLIUM_DRIVER=llvmpipe
    export MESA_GL_VERSION_OVERRIDE=3.1
    WINEPREFIX=~/.wine wineboot --init > /dev/null 2>&1
}

step_launchers() {
    update_progress
    echo -e "${MINT}[*] Escribiendo Scripts de Arranque Únicos...${NC}"
    
    mkdir -p ~/.config ~/.vnc
    
    cat > ~/.config/devstudio-gpu.sh << 'GPUEOF'
export GALLIUM_DRIVER=llvmpipe
export MESA_LOADER_DRIVER_OVERRIDE=swrast
export LIBGL_ALWAYS_SOFTWARE=1
GPUEOF
    chmod +x ~/.config/devstudio-gpu.sh

    cat > ~/.vnc/xstartup << 'XSTARTEOF'
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
source ~/.config/devstudio-gpu.sh 2>/dev/null
startxfce4 > /dev/null 2>&1 &
XSTARTEOF
    chmod +x ~/.vnc/xstartup
    
    cat > ~/start-devstudio.sh << 'LAUNCHEREOF'
#!/data/data/com.termux/files/usr/bin/bash
termux-wake-lock
vncserver -kill :1 >/dev/null 2>&1
pkill -9 -f "xfce" 2>/dev/null
pkill -9 -f "ollama" 2>/dev/null
pulseaudio --kill 2>/dev/null
sleep 0.5
pulseaudio --start --exit-idle-time=-1
sleep 0.5
pactl load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1 2>/dev/null
export PULSE_SERVER=127.0.0.1
ollama serve > /dev/null 2>&1 &
vncserver :1 -geometry 1280x720 -depth 24 -localhost no
echo "🟢 ¡Mobile Dev Studio v0.3 Activo!"
LAUNCHEREOF
    chmod +x ~/start-devstudio.sh

    cat > ~/stop-devstudio.sh << 'STOPEOF'
#!/data/data/com.termux/files/usr/bin/bash
vncserver -kill :1 >/dev/null 2>&1
pkill -9 -f "pulseaudio" 2>/dev/null
pkill -9 -f "xfce" 2>/dev/null
pkill -9 -f "ollama" 2>/dev/null
termux-wake-unlock
echo "🔴 Sistema en reposo. Wake-Lock liberado."
STOPEOF
    chmod +x ~/stop-devstudio.sh

    cat > ~/cleanup.sh << 'CLEANUPEOF'
#!/bin/bash
vncserver -kill :1 >/dev/null 2>&1
pkill -9 -f "ollama" 2>/dev/null
rm -rf /tmp/.X11-unix/X*
rm -rf /tmp/.X*-lock
rm -rf ~/.vnc/*.pid
rm -rf ~/.vnc/*.log
rm -rf /tmp/*
rm -rf ~/.cache/*
echo "🧹 Purgado de sockets y temporales completado."
CLEANUPEOF
    chmod +x ~/cleanup.sh

    # --- ESCRITORIO ---
    cat > ~/Desktop/VSCode.desktop << 'EOF'
[Desktop Entry]
Name=VS Code Projects
Comment=Proyectos Web en VS Code
Exec=code-oss --disable-gpu /data/data/com.termux/files/home/Projects
Icon=code-oss
Type=Application
Categories=Development;
EOF

    cat > ~/Desktop/Godot_Nativo.desktop << 'EOF'
[Desktop Entry]
Name=Godot Native ARM64
Comment=Ejecutar binario oficial ARM64
Exec=sh -c "source ~/.config/devstudio-gpu.sh && ~/Godot/Godot_v4.*_linux_arm64.elf --rendering-driver opengl3"
Icon=godot
Type=Application
Categories=Development;
EOF

    cat > ~/Desktop/MuPDF.desktop << 'EOF'
[Desktop Entry]
Name=MuPDF Viewer
Exec=mupdf
Icon=document-print
Type=Application
Categories=Office;
EOF

    cat > ~/Desktop/Htop.desktop << 'EOF'
[Desktop Entry]
Name=Htop Monitor
Exec=xfce4-terminal -e htop
Icon=utilities-system-monitor
Type=Application
Categories=System;
EOF

    chmod +x ~/Desktop/*.desktop 2>/dev/null
}

main() {
    show_banner
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
    echo -e "\n${LIME}¡ENTORNO DE PRODUCCIÓN v0.3 INSTALADO PERFECTAMENTE!${NC}\n"
}
main
