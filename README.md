# PowerShell PDF Compressor GUI

Herramienta simple en PowerShell que permite seleccionar un archivo PDF y comprimirlo con Ghostscript desde una interfaz gráfica.

## Requisitos

- Windows
- [Ghostscript](https://www.ghostscript.com/download.html) instalado en:
  `C:\Program Files\gs\gs10.05.1\bin\gswin64c.exe`

## Características

- Interfaz gráfica (WinForms)
- Soporte para diferentes niveles de compresión: `/screen`, `/ebook`, `/printer`, `/prepress`
- Validación de archivos

## Uso

1. Ejecuta el script `PDFCompressor-GUI.ps1` con PowerShell.
2. Selecciona tu archivo PDF.
3. Elige el nivel de compresión.
4. Guarda el resultado comprimido.
