```markdown
# 🎨 Mobile Dev Studio v2.2

🚀 Un entorno de escritorio ultraligero en Termux (XFCE4 + TigerVNC) optimizado exclusivamente para desarrollo web y Godot Engine 4.3 de forma 100% nativa (ARM64). Sin emuladores, con el máximo rendimiento móvil, mayor duración de batería y libre de sobrecalentamientos.

---

A diferencia de otros scripts sobrecargados con herramientas pesadas o complejas capas de compatibilidad para Windows (como Wine o Box64), **Mobile Dev Studio v2.2** está completamente depurado y enfocado en el rendimiento bruto y la creación de contenido de manera nativa.

## ✨ Características principales

* **🖥️ Escritorio XFCE4 + TigerVNC:** Interfaz gráfica ligera y fluida, optimizada para conexiones móviles locales y directas.
* **🎮 Godot Engine 4.3 nativo:** Olvídate de capas de emulación lentas. El script instala el motor de videojuegos compilado directamente para Linux ARM64, ofreciendo la máxima velocidad y fluidez posibles en tu dispositivo.
* **🌐 Listo para desarrollo web:** Incluye un entorno completo con Node.js, NPM, Git, VS Code (optimizado) y Firefox para maquetar y probar tus proyectos locales al instante.
* **🛡️ Renderizado seguro:** Configurado con `llvmpipe` (renderizado por software) para evitar bloqueos por incompatibilidad de controladores gráficos en Android.

---

## 🛠️ Paso 1: Preparación crítica del dispositivo (Antes de instalar)

Para evitar que el sistema operativo Android cierre tus herramientas de desarrollo o la sesión de VNC de forma imprevista (debido al límite de procesos fantasma o *Phantom Processes* de Android), ejecuta los siguientes comandos en tu terminal de Termux antes de lanzar el instalador:

### 1. Conceder permisos de almacenamiento
Asegúrate de que Termux tenga acceso a tus archivos locales:
```bash
termux-setup-storage
```

### 2. Actualizar los repositorios y el sistema base
Configura los servidores de Termux más rápidos y actualiza el sistema:
```bash
termux-change-repo
apt upgrade -y
```

### 3. Desactivar el límite de procesos en segundo plano
Instala las herramientas de Android para conectarte a tu propio teléfono mediante depuración inalámbrica:
```bash
pkg install android-tools -y
```
Activa la Depuración inalámbrica en las Opciones de desarrollador de tu dispositivo y vincula Termux ejecutando:

```bash
# Introduce el puerto y el código de vinculación que te proporcione tu teléfono
adb pair [IP_De_Tu_Dispositivo]:[Puerto_De_Vinculación]

# Conéctate usando la IP y el puerto de depuración activa
adb connect [IP_De_Tu_Dispositivo]:[Puerto]

# Verifica que tu dispositivo aparezca como conectado en la lista
adb devices
```

Una vez conectado, ejecuta estos comandos para deshabilitar de forma permanente el límite de procesos en segundo plano de Android:
```bash
adb shell "/system/bin/device_config set_sync_disabled_for_tests persistent"
adb shell "/system/bin/device_config put activity_manager max_phantom_processes 2147483647"
adb shell settings put global settings_enable_monitor_phantom_procs false
```

Puedes verificar que los cambios se aplicaron correctamente con estos comandos: 
```bash
adb shell "/system/bin/dumpsys activity settings | grep max_phantom_processes"
adb shell "/system/bin/device_config get activity_manager max_phantom_processes"
```

---

## 🚀 Paso 2: Instalación rápida

Una vez preparado tu dispositivo para soportar cargas de trabajo continuas, ejecuta el script de instalación en Termux:  

```bash
curl -sL https://raw.githubusercontent.com/Yerensoncasares/mobile-dev-studio/main/install.sh -o install.sh && chmod +x install.sh && ./install.sh
```

O bien, utilizando `wget`:
```bash
wget https://raw.githubusercontent.com/Yerensoncasares/mobile-dev-studio/main/install.sh && chmod +x install.sh && ./install.sh
```

---

## 🖥️ Uso del entorno

### Iniciar el entorno gráfico (Servidor VNC)
Para iniciar el servidor VNC y activar el Wake-Lock (evitando que el sistema suspenda el proceso):
```bash
bash ~/start-devstudio.sh
```
Abre tu cliente VNC preferido (como AVNC o bVNC) y conéctate usando el puerto `5901` (pantalla :1) y la contraseña que configuraste.

### Detener el entorno
Para liberar memoria RAM y cerrar de forma segura todos los servicios activos en segundo plano:
```bash
bash ~/stop-devstudio.sh
```
