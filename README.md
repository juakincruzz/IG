# IG - Informática Gráfica

![Godot](https://img.shields.io/badge/Godot-4.5-blue)
![GDScript](https://img.shields.io/badge/GDScript-Game%20Logic-blueviolet)
![Shaders](https://img.shields.io/badge/GDShader-Visual%20Effects-orange)
![3D](https://img.shields.io/badge/Graphics-3D-green)

Repositorio de prácticas de la asignatura **Informática Gráfica**, desarrollado con **Godot 4.5**, **GDScript** y **GDShader**.

El proyecto recoge varias prácticas centradas en gráficos 3D, escenas, nodos, modelos, materiales, texturas, iluminación, interacción y efectos visuales mediante shaders.

---

## Descripción

Este repositorio muestra una evolución progresiva en el uso de **Godot** para construir escenas 3D interactivas.

A lo largo de las prácticas se trabajan conceptos básicos y avanzados de informática gráfica, desde la carga y manipulación de modelos hasta la creación de escenas interactivas con iluminación, materiales, texturas, selección de objetos y efectos visuales personalizados.

---

## Tecnologías utilizadas

- Godot 4.5
- GDScript
- GDShader
- Forward Plus renderer
- Git y GitHub

---

## Contenidos principales

- Arquitectura de escenas y nodos en Godot.
- Programación de comportamiento con GDScript.
- Carga y uso de modelos externos.
- Representación de ejes, figuras y objetos 3D.
- Iluminación direccional, puntual y focal.
- Materiales y texturas.
- Interacción mediante teclado, ratón y cámara.
- Selección y manipulación de objetos.
- Física básica en escenas 3D.
- Shaders espaciales para agua y tela.
- Proyecto final interactivo.

---

## Estructura del repositorio

```text
IG/
├── p2/
├── p3/p3/
├── p4/p4/
├── p5/p5/
├── p6/p6/
└── README.md
```

Cada carpeta corresponde a una práctica independiente de Godot, con su propio archivo `project.godot` y su escena principal.

---

## Prácticas

| Práctica | Tema | Contenido principal | Nota |
|---|---|---|---:|
| P2 | Modelos externos y normales | Carga de modelos, normales, ejes, pirámides y utilidades de escena. | 10/10 |
| P3 | Grafos de escena | Jerarquías de nodos, escena principal y control de figuras mediante teclado. | 9,5/10 |
| P4 | Iluminación, materiales y texturas | Luces direccionales, omnidireccionales y tipo spot; cambio de materiales y texturas. | 9,5/10 |
| P5 | Interacción | Interacción con ratón, selección de objetos y control de escenas 3D. | 8/10 |
| P6 | Proyecto final | Escena interactiva con física, cámara, animaciones y shaders personalizados. | 8/10 |

---

## Detalles técnicos

### Godot 4.5

Los proyectos están configurados con `config_version=5` y características de Godot **4.5** con renderizado **Forward Plus**.

Cada práctica tiene su propia escena principal. Por ejemplo:

- `p2/project.godot` ejecuta `practica2.tscn`.
- `p3/p3/project.godot` ejecuta `escena_principal.tscn`.
- `p5/p5/project.godot` ejecuta `escena_principal.tscn`.

### Entrada de usuario

Varias prácticas definen acciones de entrada para alternar elementos de la escena mediante teclado.

En P3 y P5 se usan acciones como:

- `toogle_principal`
- `toogle_secundario`
- `toogle_figura`
- `toogle_figuras_juntas`

En P4 se añaden controles para activar o cambiar luces y materiales:

- `toggle_luz_dir`
- `toggle_luz_omni`
- `toggle_luz_spot`
- `cambia_mat_1`
- `cambia_mat_2`
- `cambia_mat_3`

En P6 se usan las teclas `1`, `2` y `3` para controlar opciones del proyecto final.

### Shaders

La práctica final incluye shaders personalizados en GDShader:

- `shader_agua.gdshader`: shader espacial con movimiento de vértices para simular olas, color configurable, brillo y transparencia.
- `shader_tela.gdshader`: shader espacial con movimiento de vértices para simular una tela afectada por viento.

---

## Ejecución

Clonar el repositorio:

```bash
git clone https://github.com/juakincruzz/IG.git
cd IG
```

Abrir una práctica en Godot:

1. Abrir Godot 4.5.
2. Seleccionar **Importar**.
3. Elegir el archivo `project.godot` de la práctica correspondiente.
4. Ejecutar la escena principal desde el editor.

Rutas principales:

```text
p2/project.godot
p3/p3/project.godot
p4/p4/project.godot
p5/p5/project.godot
p6/p6/project.godot
```

---

## Aprendizajes principales

Este repositorio demuestra el trabajo progresivo con gráficos 3D e interacción en Godot.

Los aspectos más importantes trabajados son:

- Organización de proyectos en Godot.
- Uso de escenas y nodos.
- Programación de comportamiento interactivo con GDScript.
- Uso de materiales, texturas e iluminación.
- Creación de shaders personalizados.
- Control de entrada mediante teclado y ratón.
- Aplicación de física básica en una escena interactiva.
- Desarrollo incremental de prácticas gráficas.

---

## Autor

**Joaquín Cruz Lorenzo**  
GitHub: [@juakincruzz](https://github.com/juakincruzz)
