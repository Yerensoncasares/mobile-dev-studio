# 🎨 Mobile Dev Studio v2.2

🚀 Un entorno de escritorio ultra-ligero en Termux (XFCE4 + TigerVNC) optimizado exclusivamente para Desarrollo Web y Godot Engine 4.3 de forma 100% Nativa (ARM64)[span_1](start_span)[span_1](end_span). Cero emuladores, máximo rendimiento móvil, mayor duración de batería y cero sobrecalentamiento[span_2](start_span)[span_2](end_span).

---

A diferencia de otros scripts cargados de herramientas pesadas o complejas capas de compatibilidad con Windows (como Wine o Box64), **Mobile Dev Studio v2.2** está depurado y enfocado al 100% en el rendimiento bruto y la creación de contenido de manera nativa[span_3](start_span)[span_3](end_span).

## ✨ Características Principales

* **🖥️ Escritorio XFCE4 + TigerVNC:** Interfaz gráfica ligera y fluida optimizada para conexiones móviles locales directas.
* **🎮 Godot Engine 4.3 Nativo:** Olvídate de capas de emulación lentas[span_4](start_span)[span_4](end_span). El script instala el motor de videojuegos compilado de forma nativa para Linux ARM64, ofreciendo máxima velocidad y fluidez[span_5](start_span)[span_5](end_span).
* **🌐 Listo para Desarrollo Web:** Incluye un entorno completo con Node.js, NPM, Git, VS Code (optimizado) y Firefox para maquetar y probar tus proyectos locales al instante.
* **🛡️ Renderizado Seguro:** Configurado con `llvmpipe` (software rendering) para evitar crasheos de drivers gráficos en Android.

---

## 🛠️ Paso 1: Preparación Crítica del Dispositivo (Antes de Instalar)

Para evitar que Android cierre tus herramientas de desarrollo o la sesión VNC de forma imprevista (debido al limitador de *Phantom Processes* de Android), ejecuta los siguientes comandos en tu terminal de Termux antes de lanzar el instalador[span_6](start_span)[span_6](end_span):

### 1. Conceder Permisos de Almacenamiento
Asegura que Termux tenga acceso a tus archivos locales[span_7](start_span)[span_7](end_span):
```bash
termux-setup-storage
