#!/data/data/com.termux/files/usr/bin/bash
#######################################################
#  🚀 MOBILE DEV STUDIO - Ultimate Installer v1.0
#  
#  Features:
#  - Overall progress percentage
#  - GPU acceleration auto-setup (Turnip/Zink)
#  - Web Dev Environment (Node.js, Python, Git)
#  - Game Dev (Godot 4 ARM64, LibreSprite)
#  - Media Editing (Tenacity, MPV)
#  - One-click desktop launch
#  
#  Author: Tech Jarves (Modificado para Dev)
#  YouTube: https://youtube.com/@TechJarves
#######################################################

# ============== CONFIGURATION ==============
TOTAL_STEPS=15
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
    echo -e "${CYAN}  📊 PROGRESO GENERAL: ${WHITE}Paso ${CURRENT_STEP}/${TOTAL_STEPS}${NC} ${BAR} ${WHITE}${PERCENT}%${NC}"
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
    echo -e "${CYAN}"
    cat << 'BANNER'
    ╔══════════════════════════════════════╗
    ║                                      ║
    ║   💻 MOBILE DEV STUDIO v1.0 💻       ║
    ║      (Web Dev & Game Dev)            ║
    ║                                      ║
    ║       Tech Jarves - YouTube          ║
    ║                                      ║
    ╚══════════════════════════════════════╝
BANNER
    echo -e "${NC}"
    echo ""
}

# ============== DEVICE DETECTION ==============
detect_device() {
    echo -e "${PURPLE}[*] Detectando tu dispositivo...${NC}"
    echo ""
    
    DEVICE_MODEL=$(getprop ro.product.model 2>/dev/null || echo "Desconocido")
    DEVICE_BRAND=$(getprop ro.product.brand 2>/dev/null || echo "Desconocido")
    ANDROID_VERSION=$(getprop ro.build.version.release 2>/dev/null || echo "Desconocido")
    CPU_ABI=$(getprop ro.product.cpu.abi 2>/dev/null || echo "arm64-v8a")
    GPU_VENDOR=$(getprop ro.hardware.egl 2>/dev/null || echo "")
    
    echo -e "  ${GREEN}📱${NC} Dispositivo: ${WHITE}${DEVICE_BRAND} ${DEVICE_MODEL}${NC}"
    echo -e "  ${GREEN}🤖${NC} Android: ${WHITE}${ANDROID_VERSION}${NC}"
    echo -e "  ${GREEN}⚙️${NC}  CPU: ${WHITE}${CPU_ABI}${NC}"
    
    if [[ "$GPU_VENDOR" == *"adreno"* ]] || [[ "$DEVICE_BRAND" == *"samsung"* ]] || [[ "$DEVICE_BRAND" == *"Samsung"* ]] || [[ "$DEVICE_BRAND" == *"oneplus"* ]] || [[ "$DEVICE_BRAND" == *"xiaomi"* ]]; then
        GPU_DRIVER="freedreno"
        echo -e "  ${GREEN}🎮${NC} GPU: ${WHITE}Adreno (Qualcomm) - Driver Turnip${NC}"
    else
        GPU_DRIVER="swrast"
        echo -e "  ${GREEN}🎮${NC} GPU: ${WHITE}Renderizado por software${NC}"
    fi
    echo ""
    sleep 1
}

# ============== STEP 1: UPDATE SYSTEM ==============
step_update() {
    update_progress
    echo -e "${PURPLE}[Paso ${CURRENT_STEP}/${TOTAL_STEPS}] Actualizando paquetes del sistema...${NC}"
    echo ""
    (yes | pkg update -y > /dev/null 2>&1) & spinner $! "Actualizando listas de paquetes..."
    (yes | pkg upgrade -y > /dev/null 2>&1) & spinner $! "Actualizando paquetes instalados..."
}

# ============== STEP 2: INSTALL REPOSITORIES ==============
step_repos() {
    update_progress
    echo -e "${PURPLE}[Paso ${CURRENT_STEP}/${TOTAL_STEPS}] Agregando repositorios...${NC}"
    echo ""
    install_pkg "x11-repo" "Repositorio X11"
    install_pkg "tur-repo" "Repositorio TUR (Editores extra)"
}

# ============== STEP 3: INSTALL TERMUX-X11 ==============
step_x11() {
    update_progress
    echo -e "${PURPLE}[Paso ${CURRENT_STEP}/${TOTAL_STEPS}] Instalando Termux-X11...${NC}"
    echo ""
    install_pkg "termux-x11-nightly" "Servidor Termux-X11"
    install_pkg "xorg-xrandr" "XRandR (Configuración de pantalla)"
}

# ============== STEP 4: INSTALL DESKTOP ==============
step_desktop() {
    update_progress
    echo -e "${PURPLE}[Paso ${CURRENT_STEP}/${TOTAL_STEPS}] Instalando Escritorio XFCE4...${NC}"
    echo ""
    install_pkg "xfce4" "Entorno de Escritorio XFCE4"
    install_pkg "xfce4-terminal" "Terminal XFCE4"
    install_pkg "thunar" "Gestor de Archivos Thunar"
    install_pkg "mousepad" "Editor de Texto Mousepad (Notas)"
}

# ============== STEP 5: INSTALL GPU DRIVERS ==============
step_gpu() {
    update_progress
    echo -e "${PURPLE}[Paso ${CURRENT_STEP}/${TOTAL_STEPS}] Instalando Aceleración GPU (Turnip/Zink)...${NC}"
    echo ""
    install_pkg "mesa-zink" "Mesa Zink (OpenGL sobre Vulkan)"
    if [ "$GPU_DRIVER" == "freedreno" ]; then
        install_pkg "mesa-vulkan-icd-freedreno" "Driver Turnip para Adreno"
    else
        install_pkg "mesa-vulkan-icd-swrast" "Renderizador Vulkan por Software"
    fi
    install_pkg "vulkan-loader-android" "Cargador Vulkan"
    echo -e "  ${GREEN}✓${NC} ¡Aceleración GPU configurada!"
}

# ============== STEP 6: INSTALL AUDIO ==============
step_audio() {
    update_progress
    echo -e "${PURPLE}[Paso ${CURRENT_STEP}/${TOTAL_STEPS}] Instalando Soporte de Audio...${NC}"
    echo ""
    install_pkg "pulseaudio" "Servidor de Sonido PulseAudio"
}

# ============== STEP 7: BASE UTILITIES ==============
step_base_utils() {
    update_progress
    echo -e "${PURPLE}[Paso ${CURRENT_STEP}/${TOTAL_STEPS}] Instalando Utilidades Base...${NC}"
    echo ""
    install_pkg "firefox" "Navegador Firefox"
    install_pkg "git" "Control de Versiones Git"
    install_pkg "wget" "Descargador Wget"
    install_pkg "curl" "cURL"
    install_pkg "file" "Utilidad de análisis de archivos"
    install_pkg "unzip" "Descompresor ZIP"
}

# ============== STEP 8: WEB DEV ENVIRONMENT ==============
step_webdev() {
    update_progress
    echo -e "${PURPLE}[Paso ${CURRENT_STEP}/${TOTAL_STEPS}] Configurando Entorno Web (Frontend/Backend)...${NC}"
    echo ""
    install_pkg "nodejs" "Node.js (Backend/Frontend)"
    install_pkg "python" "Python (Backend/Scripts)"
    # Dependencias de compilación esenciales para paquetes NPM nativos (ej. node-sass, bcrypt)
    install_pkg "clang" "Compilador C/C++ (Clang)"
    install_pkg "make" "Herramienta Make"
    install_pkg "cmake" "Herramienta CMake"
    
    echo -e "  ${YELLOW}⏳${NC} Instalando herramientas globales de Node..."
    npm install -g live-server > /dev/null 2>&1
    echo -e "  ${GREEN}✓${NC} Live-server instalado (para previsualizar webs)"
}

# ============== STEP 9: CODE EDITORS ==============
step_editors() {
    update_progress
    echo -e "${PURPLE}[Paso ${CURRENT_STEP}/${TOTAL_STEPS}] Instalando Editores de Código...${NC}"
    echo ""
    install_pkg "code-oss" "VS Code Editor"
    install_pkg "geany" "Geany (Editor UI ligero ideal para código)"
}

# ============== STEP 10: GODOT ENGINE ==============
step_godot() {
    update_progress
    echo -e "${PURPLE}[Paso ${CURRENT_STEP}/${TOTAL_STEPS}] Instalando Godot Engine 4 (Linux ARM64)...${NC}"
    echo ""
    
    # Se descarga la versión estándar de Linux ARM64 directamente desde GitHub
    local GODOT_URL="https://github.com/godotengine/godot/releases/download/4.2.2-stable/Godot_v4.2.2-stable_linux.arm64.zip"
    local GODOT_ZIP="/tmp/godot.zip"
    local GODOT_BIN="$PREFIX/bin/godot"
    
    echo -e "  ${YELLOW}⏳${NC} Descargando Godot 4.2.2 ARM64..."
    (wget -q --show-progress -O $GODOT_ZIP "$GODOT_URL" > /dev/null 2>&1) &
    spinner $! "Descargando Godot Engine..."
    
    echo -e "  ${YELLOW}⏳${NC} Extrayendo e instalando..."
    (unzip -o $GODOT_ZIP -d /tmp/ > /dev/null 2>&1 && mv /tmp/Godot_v4.2.2-stable_linux.arm64 $GODOT_BIN && chmod +x $GODOT_BIN) &
    spinner $! "Configurando Godot..."
    
    rm -f $GODOT_ZIP
    echo -e "  ${GREEN}✓${NC} ¡Godot Engine instalado correctamente!"
}

# ============== STEP 11: GRAPHICS & SPRITES ==============
step_graphics() {
    update_progress
    echo -e "${PURPLE}[Paso ${CURRENT_STEP}/${TOTAL_STEPS}] Instalando Editores Gráficos y de Sprites...${NC}"
    echo ""
    # LibreSprite es el mejor clon de Aseprite, ideal para pixel art y mosaicos
    install_pkg "libresprite" "LibreSprite (Editor de Sprites/Pixel Art)"
    # ImageMagick útil para manipular imágenes desde terminal (ej. generar sprite sheets)
    install_pkg "imagemagick" "ImageMagick (Procesamiento de imágenes CLI)"
}

# ============== STEP 12: AUDIO & MEDIA ==============
step_media() {
    update_progress
    echo -e "${PURPLE}[Paso ${CURRENT_STEP}/${TOTAL_STEPS}] Instalando Multimedia (Audio/Video)...${NC}"
    echo ""
    # Tenacity es un fork de Audacity muy optimizado
    install_pkg "tenacity" "Tenacity (Editor de audio ligero)"
    # MPV es el visor de audio/video más ligero y potente
    install_pkg "mpv" "Reproductor Multimedia MPV"
    # FFmpeg es obligatorio para desarrollo de juegos y procesamiento web
    install_pkg "ffmpeg" "FFmpeg (Códecs y conversión A/V)"
}

# ============== STEP 13: WINE (WINDOWS APPS) ==============
step_wine() {
    update_progress
    echo -e "${PURPLE}[Paso ${CURRENT_STEP}/${TOTAL_STEPS}] Instalando Wine (Compatibilidad Windows)...${NC}"
    echo ""
    (pkg remove wine-stable -y > /dev/null 2>&1) & spinner $! "Limpiando versiones antiguas de Wine..."
    install_pkg "hangover-wine" "Capa de Compatibilidad Wine"
    install_pkg "hangover-wowbox64" "Wrapper Box64"
    ln -sf /data/data/com.termux/files/usr/opt/hangover-wine/bin/wine /data/data/com.termux/files/usr/bin/wine
    ln -sf /data/data/com.termux/files/usr/opt/hangover-wine/bin/winecfg /data/data/com.termux/files/usr/bin/winecfg
}

# ============== STEP 14: CREATE LAUNCHER SCRIPTS ==============
step_launchers() {
    update_progress
    echo -e "${PURPLE}[Paso ${CURRENT_STEP}/${TOTAL_STEPS}] Creando Scripts de Inicio...${NC}"
    echo ""
    
    mkdir -p ~/.config
    cat > ~/.config/devlab-gpu.sh << 'GPUEOF'
# Mobile DevStudio - GPU Acceleration Config
export MESA_NO_ERROR=1
export MESA_GL_VERSION_OVERRIDE=4.6
export MESA_GLES_VERSION_OVERRIDE=3.2
export GALLIUM_DRIVER=zink
export MESA_LOADER_DRIVER_OVERRIDE=zink
export TU_DEBUG=noconform
export MESA_VK_WSI_PRESENT_MODE=immediate
export ZINK_DESCRIPTORS=lazy
GPUEOF
    echo -e "  ${GREEN}✓${NC} Config GPU creada"
    
    if ! grep -q "devlab-gpu.sh" ~/.bashrc 2>/dev/null; then
        echo 'source ~/.config/devlab-gpu.sh 2>/dev/null' >> ~/.bashrc
    fi
    
    # Script de inicio principal
    cat > ~/start-devstudio.sh << 'LAUNCHEREOF'
#!/data/data/com.termux/files/usr/bin/bash
echo ""
echo "🚀 Iniciando Mobile DevStudio..."
echo ""
source ~/.config/devlab-gpu.sh 2>/dev/null

echo "🔄 Limpiando sesiones antiguas..."
pkill -9 -f "termux.x11" 2>/dev/null
pkill -9 -f "xfce" 2>/dev/null
pkill -9 -f "dbus" 2>/dev/null

# === AUDIO SETUP ===
unset PULSE_SERVER
pulseaudio --kill 2>/dev/null
sleep 0.5
echo "🔊 Iniciando servidor de audio..."
pulseaudio --start --exit-idle-time=-1
sleep 1
pactl load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1 2>/dev/null
export PULSE_SERVER=127.0.0.1
# === END AUDIO ===

echo "📺 Iniciando servidor gráfico X11..."
termux-x11 :0 -ac &
sleep 3
export DISPLAY=:0

echo "🖥️ Lanzando escritorio XFCE4..."
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  📱 ¡Abre la app Termux-X11 para ver el escritorio!"
echo "  🔊 ¡El audio está habilitado!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
exec startxfce4
LAUNCHEREOF
    chmod +x ~/start-devstudio.sh
    echo -e "  ${GREEN}✓${NC} Creado ~/start-devstudio.sh"
    
    # Script para detener
    cat > ~/stop-devstudio.sh << 'STOPEOF'
#!/data/data/com.termux/files/usr/bin/bash
echo "Deteniendo Mobile DevStudio..."
pkill -9 -f "termux.x11" 2>/dev/null
pkill -9 -f "pulseaudio" 2>/dev/null
pkill -9 -f "xfce" 2>/dev/null
pkill -9 -f "dbus" 2>/dev/null
echo "Escritorio detenido."
STOPEOF
    chmod +x ~/stop-devstudio.sh
    echo -e "  ${GREEN}✓${NC} Creado ~/stop-devstudio.sh"
}

# ============== STEP 15: CREATE DESKTOP SHORTCUTS ==============
step_shortcuts() {
    update_progress
    echo -e "${PURPLE}[Paso ${CURRENT_STEP}/${TOTAL_STEPS}] Creando Atajos de Escritorio...${NC}"
    echo ""
    
    mkdir -p ~/Desktop
    
    cat > ~/Desktop/Firefox.desktop << 'EOF'
[Desktop Entry]
Name=Firefox
Comment=Navegador Web
Exec=firefox
Icon=firefox
Type=Application
Categories=Network;WebBrowser;
EOF

    cat > ~/Desktop/VSCode.desktop << 'EOF'
[Desktop Entry]
Name=VS Code
Comment=Editor de Código Fuente
Exec=code-oss --no-sandbox
Icon=code-oss
Type=Application
Categories=Development;
EOF

    cat > ~/Desktop/Geany.desktop << 'EOF'
[Desktop Entry]
Name=Geany
Comment=Editor Ligero y Notas
Exec=geany
Icon=geany
Type=Application
Categories=Development;TextEditor;
EOF

    cat > ~/Desktop/Godot.desktop << 'EOF'
[Desktop Entry]
Name=Godot Engine 4
Comment=Motor de Videojuegos
Exec=godot
Icon=godot
Type=Application
Categories=Development;GameDev;
EOF

    cat > ~/Desktop/LibreSprite.desktop << 'EOF'
[Desktop Entry]
Name=LibreSprite
Comment=Editor de Sprites y Pixel Art
Exec=libresprite
Icon=libresprite
Type=Application
Categories=Graphics;
EOF

    cat > ~/Desktop/Tenacity.desktop << 'EOF'
[Desktop Entry]
Name=Tenacity
Comment=Editor de Audio
Exec=tenacity
Icon=tenacity
Type=Application
Categories=AudioVideo;AudioEditor;
EOF

    cat > ~/Desktop/MPV.desktop << 'EOF'
[Desktop Entry]
Name=MPV Player
Comment=Reproductor de Audio y Video
Exec=mpv
Icon=mpv
Type=Application
Categories=AudioVideo;Player;
EOF

    cat > ~/Desktop/Terminal.desktop << 'EOF'
[Desktop Entry]
Name=Terminal
Comment=Terminal XFCE
Exec=xfce4-terminal
Icon=utilities-terminal
Type=Application
Categories=System;TerminalEmulator;
EOF

    chmod +x ~/Desktop/*.desktop 2>/dev/null
    echo -e "  ${GREEN}✓${NC} Atajos de escritorio creados"
}

# ============== COMPLETION ==============
show_completion() {
    echo ""
    echo -e "${GREEN}"
    cat << 'COMPLETE'
    
    ╔═══════════════════════════════════════════════════════════════╗
    ║                                                               ║
    ║         ✅  INSTALACIÓN COMPLETADA  ✅                        ║
    ║                                                               ║
    ║              🎉 100% - ¡Todo Listo! 🎉                       ║
    ║                                                               ║
    ╚═══════════════════════════════════════════════════════════════╝
    
COMPLETE
    echo -e "${NC}"
    
    echo -e "${WHITE}💻 ¡Tu Estudio de Desarrollo Móvil está listo!${NC}"
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
    echo -e "   • Desarrollo Web: Node.js, NPM, Python, Live-server"
    echo -e "   • Editores: VS Code, Geany, Mousepad"
    echo -e "   • Game Dev: Godot Engine 4.2.2 ARM64"
    echo -e "   • Gráficos: LibreSprite (Sprites), ImageMagick"
    echo -e "   • Multimedia: Tenacity (Audio), MPV (Video/Audio)"
    echo -e "   • Extras: Firefox, Git, FFmpeg, Wine"
    echo -e "   • Sistema: XFCE4 Desktop + Aceleración GPU"
    echo ""
    echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}  📺 Suscríbete: https://youtube.com/@TechJarves${NC}"
    echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${WHITE}⚡ TIP: Abre la app Termux-X11 primero, luego ejecuta start-devstudio.sh${NC}"
    echo ""
}

# ============== MAIN INSTALLATION ==============
main() {
    show_banner
    
    echo -e "${WHITE}  Este script instalará un entorno de desarrollo completo con${NC}"
    echo -e "${WHITE}  herramientas Web, GameDev (Godot) y Multimedia en tu Android.${NC}"
    echo ""
    echo -e "${GRAY}  Tiempo estimado: 15-30 minutos (depende de tu internet)${NC}"
    echo ""
    echo -e "${YELLOW}  Presiona Enter para iniciar la instalación, o Ctrl+C para cancelar...${NC}"
    read
    
    detect_device
    step_update
    step_repos
    step_x11
    step_desktop
    step_gpu
    step_audio
    step_base_utils
    step_webdev
    step_editors
    step_godot
    step_graphics
    step_media
    step_wine
    step_launchers
    step_shortcuts
    
    show_completion
}

# ============== RUN ==============
main
