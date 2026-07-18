#!/data/data/com.termux/files/usr/bin/bash
#######################################################
#  🚀 MOBILE DEV STUDIO - Ultimate Installer v1.0 (VNC TV)
#  
#  UI Theme: Verdant Cyberpunk (Mint & Lime)
#  
#  Edición Especial para TV:
#  - Cambiado Termux-X11 por TigerVNC para visualización remota en TV.
#  - Estructura limpia de directorios en raíz (Projects, Automation, Apps_Linux).
#  - Instalación y parche dinámico de Godot v4.7.1 Estable ARM64.
#  - Scripts únicos de control mapeados directamente en la raíz (~).
#######################################################

TOTAL_STEPS=15
CURRENT_STEP=0

# ============== COLORES VERDANT CYBERPUNK ==============
LIME='\033[1;32m'
FOREST='\033[0;32m'
MINT='\033[1;36m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'
RED='\033[0;31m'
NC='\033[0m'

# ============== FUNCIONES DE PROGRESO ==============
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
    echo -e "${FOREST}🟢 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 🟢${NC}"
    echo -e "  ${MINT}📊 ESTADO DEL SISTEMA: ${WHITE}Paso ${CURRENT_STEP}/${TOTAL_STEPS}${NC} ${BAR} ${LIME}${PERCENT}%${NC}"
    echo -e "${FOREST}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
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
        printf "\r  ${RED}✗${NC} ${message} ${RED}(falló)${NC}     \n"
    fi
    return $exit_code
}

install_pkg() {
    local pkg=$1
    local name=${2:-$pkg}
    (yes | pkg install $pkg -y > /dev/null 2>&1) &
    spinner $! "Instalando ${name}..."
}

# ============== BANNER ==============
show_banner() {
    clear
    echo -e "${MINT}"
    cat << 'BANNER'
    ⚡▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄⚡
      █                                        █
      █   🚀  MOBILE DEV STUDIO v1.0 PROD  🚀  █
      █       (TV VNC Native Core Edition)     █
      █                                        █
    ⚡▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀⚡
BANNER
    echo -e "${NC}"
    echo ""
}

# ============== DETECCIÓN DE HARDWARE ==============
detect_device() {
    echo -e "${MINT}[*] Analizando Arquitectura del Hardware...${NC}"
    echo ""
    DEVICE_MODEL=$(getprop ro.product.model 2>/dev/null || echo "Desconocido")
    DEVICE_BRAND=$(getprop ro.product.brand 2>/dev/null || echo "Desconocido")
    ANDROID_VERSION=$(getprop ro.build.version.release 2>/dev/null || echo "Desconocido")
    CPU_ABI=$(getprop ro.product.cpu.abi 2>/dev/null || echo "arm64-v8a")
    
    echo -e "  ${LIME}📱${NC} Hardware:   ${WHITE}${DEVICE_BRAND} ${DEVICE_MODEL}${NC}"
    echo -e "  ${LIME}🤖${NC} Android:    ${WHITE}${ANDROID_VERSION}${NC}"
    echo -e "  ${LIME}⚙️${NC}  Core ABI:   ${WHITE}${CPU_ABI} (ARM64 Nativo)${NC}"
    echo -e "  ${LIME}📺${NC} Output:     ${WHITE}Servidor VNC para Red Local (Televisor)${NC}"
    echo ""
    sleep 1
}

# ============== PASO 1: ACTUALIZACIÓN ==============
step_update() {
    update_progress
    echo -e "${MINT}[*] Sincronizando Base del Sistema...${NC}"
    (yes | pkg update -y > /dev/null 2>&1) & spinner $! "Actualizando índices..."
    (yes | pkg upgrade -y > /dev/null 2>&1) & spinner $! "Actualizando paquetes existentes..."
}

# ============== PASO 2: REPOSITORIOS ==============
step_repos() {
    update_progress
    echo -e "${MINT}[*] Inyectando Repositorios Estables...${NC}"
    install_pkg "x11-repo" "X11 Repository"
    install_pkg "tur-repo" "TUR Repository"
}

# ============== PASO 3: CONFIGURACIÓN DE ESTRUCTURA RAÍZ ==============
step_structure() {
    update_progress
    echo -e "${MINT}[*] Creando Estructura de Trabajo Limpia en Raíz...${NC}"
    mkdir -p ~/Desktop
    mkdir -p ~/Projects             
    mkdir -p ~/Automation           
    mkdir -p ~/Apps_Linux           
    mkdir -p ~/Godot/Templates      
    mkdir -p ~/Godot/Workspace      
    echo -e "  ${LIME}✓${NC} Directorios raíz estructurados con éxito."
}

# ============== PASO 4: TIGERVNC CORE (REEMPLAZO DE X11) ==============
step_vnc_setup() {
    update_progress
    echo -e "${MINT}[*] Configurando Servidor Gráfico Remoto TigerVNC...${NC}"
    install_pkg "tigervnc" "TigerVNC Server"
    install_pkg "xorg-xrandr" "XRandR Display Control"
}

# ============== PASO 5: ENTORNO ESCRITORIO ==============
step_desktop() {
    update_progress
    echo -e "${MINT}[*] Desplegando Interfaz de Escritorio XFCE4...${NC}"
    install_pkg "xfce4" "Escritorio XFCE4"
    install_pkg "xfce4-terminal" "Terminal Interactiva XFCE4"
    install_pkg "thunar" "Gestor de Archivos Thunar"
    install_pkg "mousepad" "Editor de Notas Ligero"
}

# ============== PASO 6: PERFIL GRÁFICO SEGURO (VNC ACCELERATION COMPAT) ==============
step_gpu() {
    update_progress
    echo -e "${MINT}[*] Inyectando Parches Gráficos del Sistema...${NC}"
    install_pkg "mesa-zink" "Mesa Zink Core"
    install_pkg "vulkan-loader-android" "Android Vulkan Loader"
}

# ============== PASO 7: SOPORTE DE AUDIO ==============
step_audio() {
    update_progress
    install_pkg "pulseaudio" "Servidor PulseAudio"
}

# ============== PASO 8: UTILIDADES BASE NATIVAS ==============
step_base_utils() {
    update_progress
    echo -e "${MINT}[*] Cargando Herramientas del Sistema...${NC}"
    install_pkg "firefox" "Firefox Browser"
    install_pkg "git" "Git Engine"
    install_pkg "wget" "Descargador Wget"
    install_pkg "curl" "cURL Transfer"
    install_pkg "file" "Anclaje de Tipos ELF"
    install_pkg "unzip" "Extractor ZIP"
    install_pkg "p7zip" "Extractor 7-Zip Core"
    install_pkg "termux-elf-cleaner" "Limpiador de Enlaces Dinámicos ELF"
    install_pkg "zsh" "Zsh Shell"
}

# ============== PASO 9: ENTORNO WEB Y PROGRAMACIÓN ==============
step_webdev() {
    update_progress
    echo -e "${MINT}[*] Armando Suite de Desarrollo Fullstack...${NC}"
    install_pkg "nodejs" "Node.js Engine"
    install_pkg "python" "Python Environment"
    install_pkg "clang" "Compilador Clang C/C++"
    install_pkg "make" "Herramienta de Compilación Make"
    install_pkg "cmake" "Sistema CMake"
    
    echo -e "  ${YELLOW}⚡${NC} Inyectando previsualizador web global..."
    npm install -g live-server > /dev/null 2>&1
}

# ============== PASO 10: AUTOMATIZACIÓN DE SHELL E IA LOCAL ==============
step_shell_ai() {
    update_progress
    echo -e "${MINT}[*] Configurando OhMyZsh e Inteligencia Artificial Local...${NC}"
    if [ ! -d ~/.oh-my-zsh ]; then
        (sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended > /dev/null 2>&1) &
        spinner $! "Configurando OhMyZsh..."
        chsh -s zsh
    fi
    
    install_pkg "ollama" "Ollama AI Engine"
    ollama serve > /dev/null 2>&1 &
    local server_pid=$!
    sleep 3
    ollama pull qwen2.5-coder:1.5b
    kill $server_pid 2>/dev/null
    pkill -9 -f "ollama" 2>/dev/null
}

# ============== PASO 11: EDITORES DE CÓDIGO NATIVOS ==============
step_editors() {
    update_progress
    install_pkg "code-oss" "VS Code Workspace"
    install_pkg "geany" "Geany Integrated Editor"
}

# ============== PASO 12: INSTALACIÓN CORREGIDA GODOT v4.7.1 ESTABLE NATIVO ==============
step_godot() {
    update_progress
    echo -e "${MINT}[*] Desplegando Godot Engine v4.7.1 Estable (Nativo ARM64)...${NC}"
    
    local GODOT_URL="https://github.com/godotengine/godot/releases/download/4.7.1-stable/Godot_v4.7.1-stable_linux.arm64.zip"
    local GODOT_ZIP="/tmp/godot_4.7.1.zip"
    local TARGET_BIN="/data/data/com.termux/files/home/Godot/Godot_v4.7.1-stable_linux.arm64"
    
    echo -e "  ${YELLOW}⚡${NC} Bajando binario oficial desde servidores de Godot..."
    (wget -q -O $GODOT_ZIP "$GODOT_URL" > /dev/null 2>&1) &
    spinner $! "Descargando paquete Godot..."
    
    echo -e "  ${YELLOW}⚡${NC} Descomprimiendo en el directorio definitivo..."
    unzip -o $GODOT_ZIP -d /tmp/ > /dev/null 2>&1
    mv /tmp/Godot_v4.7.1-stable_linux.arm64 $TARGET_BIN 2>/dev/null
    chmod +x $TARGET_BIN
    
    echo -e "  ${YELLOW}⚡${NC} Parchando enlaces dinámicos para entorno Termux..."
    termux-elf-cleaner $TARGET_BIN > /dev/null 2>&1
    
    rm -f $GODOT_ZIP
}

# ============== PASO 13: DISEÑO DE SPRITES Y PIXEL ART ==============
step_graphics() {
    update_progress
    install_pkg "libresprite" "LibreSprite Pixel Art Editor"
    install_pkg "imagemagick" "ImageMagick CLI Suite"
}

# ============== PASO 14: ESTUDIO DE AUDIO Y CÓDECS MULTIMEDIA ==============
step_media() {
    update_progress
    install_pkg "tenacity" "Tenacity Audio Workstation"
    install_pkg "mpv" "MPV Media Player"
    install_pkg "ffmpeg" "FFmpeg Processing Core"
}

# ============== PASO 15: ENTRAMADO WINE + CONTROLADORES VNC TV ==============
step_wine_launchers() {
    update_progress
    echo -e "${MINT}[*] Ajustando Wine y Escribiendo Scripts de Lanzamiento Remoto...${NC}"
    
    # Configuración de Wine
    (pkg remove wine-stable -y > /dev/null 2>&1) & spinner $! "Limpiando rastros legacy..."
    install_pkg "hangover-wine" "Wine Translator"
    install_pkg "hangover-wowbox64" "Box64 Integration"
    ln -sf /data/data/com.termux/files/usr/opt/hangover-wine/bin/wine /data/data/com.termux/files/usr/bin/wine
    ln -sf /data/data/com.termux/files/usr/opt/hangover-wine/bin/winecfg /data/data/com.termux/files/usr/bin/winecfg
    
    # Perfil gráfico unificado estable para evitar parpadeos en VNC
    mkdir -p ~/.config ~/.vnc
    cat > ~/.config/devlab-gpu.sh << 'GPUEOF'
export GALLIUM_DRIVER=llvmpipe
export MESA_LOADER_DRIVER_OVERRIDE=swrast
export LIBGL_ALWAYS_SOFTWARE=1
export MESA_GL_VERSION_OVERRIDE=3.1
GPUEOF
    chmod +x ~/.config/devlab-gpu.sh
    
    # Enlazador de arranque VNC
    cat > ~/.vnc/xstartup << 'XSTARTEOF'
#!/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
source ~/.config/devlab-gpu.sh 2>/dev/null
startxfce4 > /dev/null 2>&1 &
XSTARTEOF
    chmod +x ~/.vnc/xstartup

    # --- SCRIPTS ÚNICOS DE CONTROL EN LA RAÍZ (~) ---
    
    # 1. START SCRIPT (Mapeado para localhost abierto para la TV)
    cat > ~/start-devstudio.sh << 'LAUNCHEREOF'
#!/data/data/com.termux/files/usr/bin/bash
termux-wake-lock
echo "🚀 Levantando Servidor VNC Mobile Dev Studio v1.0 para la TV..."
source ~/.config/devlab-gpu.sh 2>/dev/null

vncserver -kill :1 >/dev/null 2>&1
pkill -9 -f "xfce" 2>/dev/null
pkill -9 -f "dbus" 2>/dev/null
pkill -9 -f "ollama" 2>/dev/null
pulseaudio --kill 2>/dev/null
sleep 0.5

# Servidor AI en background
ollama serve > /dev/null 2>&1 &

# Setup de Audio Remoto
pulseaudio --start --exit-idle-time=-1
sleep 0.5
pactl load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1 2>/dev/null
export PULSE_SERVER=127.0.0.1

# Iniciar servidor VNC abierto a la red local en el display :1
vncserver :1 -geometry 1280x720 -depth 24 -localhost no
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  📺 ¡Mobile Dev Studio v1.0 LISTO EN LA TV!"
echo "  🔗 Conéctate usando la IP de tu móvil en el puerto: 5901"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
LAUNCHEREOF
    chmod +x ~/start-devstudio.sh

    # 2. STOP SCRIPT
    cat > ~/stop-devstudio.sh << 'STOPEOF'
#!/data/data/com.termux/files/usr/bin/bash
echo "🔴 Deteniendo Entorno de Producción..."
vncserver -kill :1 >/dev/null 2>&1
pkill -9 -f "pulseaudio" 2>/dev/null
pkill -9 -f "xfce" 2>/dev/null
pkill -9 -f "dbus" 2>/dev/null
pkill -9 -f "ollama" 2>/dev/null
termux-wake-unlock
echo "✨ Sistema en reposo absoluto. Wake-Lock liberado."
STOPEOF
    chmod +x ~/stop-devstudio.sh

    # 3. CLEANUP SCRIPT
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
echo "🧹 Temporales, sockets y logs de VNC purgados limpiamente."
CLEANUPEOF
    chmod +x ~/cleanup.sh

    # --- CREACIÓN DE ATAJOS CATEGORIZADOS EN EL ESCRITORIO ---
    cat > ~/Desktop/Firefox.desktop << 'EOF'
[Desktop Entry]
Name=Firefox Web
Exec=firefox
Icon=firefox
Type=Application
Categories=Network;
EOF

    cat > ~/Desktop/VSCode_Workspace.desktop << 'EOF'
[Desktop Entry]
Name=VS Code Projects
Exec=code-oss --no-sandbox /data/data/com.termux/files/home/Projects
Icon=code-oss
Type=Application
Categories=Development;
EOF

    cat > ~/Desktop/Godot_v4.7.1.desktop << 'EOF'
[Desktop Entry]
Name=Godot 4.7.1 Nativo
Exec=sh -c "source ~/.config/devlab-gpu.sh && /data/data/com.termux/files/home/Godot/Godot_v4.7.1-stable_linux.arm64 --rendering-driver opengl3"
Icon=godot
Type=Application
Categories=Development;
EOF

    cat > ~/Desktop/LibreSprite.desktop << 'EOF'
[Desktop Entry]
Name=LibreSprite Art
Exec=libresprite
Icon=libresprite
Type=Application
Categories=Graphics;
EOF

    cat > ~/Desktop/Tenacity.desktop << 'EOF'
[Desktop Entry]
Name=Tenacity Audio
Exec=tenacity
Icon=tenacity
Type=Application
Categories=AudioVideo;
EOF

    cat > ~/Desktop/MPV_Player.desktop << 'EOF'
[Desktop Entry]
Name=MPV Player
Exec=mpv
Icon=mpv
Type=Application
Categories=AudioVideo;
EOF

    chmod +x ~/Desktop/*.desktop 2>/dev/null
}

# ============== PROCESAMIENTO FINAL ==============
show_completion() {
    echo -e "${LIME}"
    cat << 'COMPLETE'
    ╔═══════════════════════════════════════════════════════════════╗
    ║                                                               ║
    ║        ✅   ENTORNO VNC TV v1.0 DESPLEGADO CON ÉXITO   ✅     ║
    ║                                                               ║
    ║           Listo para producción en pantalla grande            ║
    ║                                                               ║
    ╚═══════════════════════════════════════════════════════════════╝
COMPLETE
    echo -e "${NC}"
    echo -e "${WHITE}🚀 CONTROLADORES DEL SISTEMA (Ubicados en la Raíz):${NC}"
    echo -e "   • Iniciar Entorno (VNC):  ${LIME}bash ~/start-devstudio.sh${NC}"
    echo -e "   • Detener Procesos:       ${LIME}bash ~/stop-devstudio.sh${NC}"
    echo -e "   • Limpiar Basura y Logs:  ${LIME}bash ~/cleanup.sh${NC}"
    echo ""
    echo -e "${MINT}📁 CARPETAS RAÍZ LISTAS:${NC}"
    echo -e "   • ~/Projects (Estudio VS Code) | ~/Automation (n8n)"
    echo -e "   • ~/Apps_Linux (Binarios Externos) | ~/Godot (Engine & Workspace)"
    echo ""
    echo -e "${YELLOW}⚡ TIP: Al correr start-devstudio.sh por primera vez, te pedirá asignar una clave corta de acceso para cuando te conectes desde la TV.${NC}\n"
}

main() {
    show_banner
    echo -e "${WHITE}Presiona Enter para inicializar la instalación v1.0 TV Edition...${NC}"
    read
    detect_device
    step_update
    step_repos
    step_structure
    step_vnc_setup
    step_desktop
    step_gpu
    step_audio
    step_base_utils
    step_webdev
    step_shell_ai
    step_editors
    step_godot
    step_graphics
    step_media
    step_wine_launchers
    show_completion
}

main
