# mobile-dev-studio
🚀 Un entorno de escritorio ultra-ligero en Termux (XFCE4 + TigerVNC) optimizado exclusivamente para Desarrollo Web y Godot Engine 3.3 (vía Box64). Cero herramientas pesadas, máximo rendimiento móvil.

# 🎨 Mobile Dev Studio v1.0

Un entorno de desarrollo ligero y optimizado para dispositivos móviles, diseñado para correr en **Termux** y visualizarse en cualquier cliente VNC (TV, Tablet o PC). 

A diferencia de otros scripts cargados de herramientas de ciberseguridad o pesadas capas de compatibilidad con Windows, este entorno está depurado y enfocado al 100% en la creación de contenido y rendimiento bruto.

## ✨ Características Principales

* **🖥️ Escritorio XFCE4 + TigerVNC:** Interfaz gráfica ligera y fluida optimizada para conexiones simples sin cifrado (evita errores TLS).
* **🎮 Godot Engine 3.3.4:** Configurado con renderizado GLES2 y emulado de forma nativa en ARM64 mediante **Box64** (sin necesidad de Wine).
* **🌐 Listo para Desarrollo Web:** Incluye Node.js, NPM, Git y Firefox para maquetar y probar tus proyectos locales al instante.
* **🛡️ Renderizado Seguro:** Configurado con `llvmpipe` (software rendering) para evitar crasheos de drivers gráficos en Android.

## 🚀 Instalación Rápida

Ejecuta el siguiente comando en tu terminal de Termux:
```
curl -sL https://raw.githubusercontent.com/Yerensoncasares/mobile-dev-studio/main/install.sh -o install.sh && chmod +x install.sh && ./install.sh
```

o usa wget
```
wget https://raw.githubusercontent.com/Yerensoncasares/mobile-dev-studio/main/install.sh && chmod +x install.sh && ./install.sh
```
