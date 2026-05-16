
# Laboratorio: Acceso Directo a Puertos de E/S (x86 Assembly)

* **Estudiante:** Juan Carlos Barajas Quintero 
* **Curso:** Arquitectura de Computadores - Unidad 9
* **Institución:** Universidad Francisco de Paula Santander

## Objetivo
El objetivo de este laboratorio es implementar programas en lenguaje ensamblador x86 utilizando **NASM** y **DOSBox** para acceder directamente a puertos de entrada y salida (E/S) mediante las instrucciones `IN` y `OUT`. Se aplica la técnica de **polling** para la sincronización con dispositivos y se verifica el comportamiento de los registros de estado del controlador de teclado 8042 y del puerto paralelo LPT1.

## Prerrequisitos
Para ejecutar los programas de este laboratorio, se requiere:
*   **Software:** DOSBox 0.74 o superior con NASM 2.x.
*   **Conocimientos:** Instrucciones de E/S básicas (`INT 21h`), registros de segmento y modos de direccionamiento x86.
*   **Directorio de trabajo:** Los archivos deben ubicarse en `C:\U9P1\` dentro del entorno de DOSBox, o en su defecto en la ruta dónde se clone el repositorio.

---

## Programas del Laboratorio

### 1. Lectura del Puerto de Estado del Teclado (`tecl.asm`)
*   **Propósito:** Leer el registro de estado (puerto 64h) del controlador 8042 para verificar si hay datos listos (bit OBF) y obtener el scancode del puerto de datos (60h).
*   **Compilación (SO anfitrión con NASM instalado):**
    ```bash
    nasm -f bin tecl.asm -o tecl.com
    ```
*   **Ejecución (Dentro de DosBox):**
    ```bash
    tecl.com
    ```
*   **Comportamiento esperado:** Al presionar una tecla (por ejemplo, la "A"), el programa muestra su scancode en hexadecimal (ej. "1E").

### 2. Polling con Timeout (`poll_t.asm`)
*   **Propósito:** Implementar un bucle de polling con un límite de reintentos (`MAX_RETRY`) para evitar que el programa se bloquee indefinidamente si el dispositivo no responde.
*   **Compilación:**
    ```bash
    nasm -f bin poll_t.asm -o pollt.com
    ```
*   **Ejecución:**
    ```bash
    pollt.com
    ```
*   **Comportamiento esperado:** Si se ajusta `MAX_RETRY` a un valor bajo (como `0005h`) y no se presiona ninguna tecla, el programa mostrará el mensaje: `"Timeout: sin respuesta del dispositivo"`.

### 3. Escritura al Puerto Paralelo LPT1 (`lpt1.asm`)
*   **Propósito:** Enviar el carácter "A" (0x41) al puerto paralelo LPT1 (0x378) siguiendo el protocolo Centronics (verificación de BUSY, envío de dato y pulso de STROBE).
*   **Compilación:**
    ```bash
    nasm -f bin lpt1.asm -o lpt1.com
    ```
*   **Ejecución:**
    ```bash
    lpt1.com
    ```
*   **Comportamiento observado:** 
    *   En el entorno de **DOSBox**, aunque el puerto paralelo no esté conectado a un dispositivo físico real, el acceso a los registros no genera errores de ejecución.
    *   Si el bit `BUSY#` (bit 7 del puerto de estado 0x379) se mantiene siempre en alto dentro del emulador, el bucle de espera termina de forma inmediata y el programa finaliza exitosamente sin bloquearse.

---

## Estructura del Repositorio
*   `README.md`: Documentación del laboratorio.
*   `TECL.ASM`: Código fuente del programa de lectura de teclado.
*   `POLL_T.ASM`: Código fuente con implementación de timeout.
*   `LPT1.ASM`: Código fuente para el control del puerto paralelo.
*   Capturas de pantalla de los checkpoints realizados.
