# sanson-debian

Compila y empaqueta Sanson para Debian de 64 bits.

![Inicio](https://gitlab.com/AnddyCort/Sanson-FLinux/-/raw/main/capturas/inicio.png)

## Créditos

* **Proyecto Original:** [Sanson-FLinux en GitLab](https://gitlab.com/AnddyCort/Sanson-FLinux)

## Dependencias

Es necesario contar con las siguientes herramientas instaladas para compilar el proyecto:
* `compiletc` (o `build-essential`)
* `curl-dev` (o `libcurl4-openssl-dev`)
* `fltk-1.3-dev` (o `libfltk1.3-dev`)

## Instalación desde el código fuente

Asigna permisos de ejecución al script y ejecútalo en tu terminal:

```bash
chmod +x make_sansom_deb.sh
./make_sansom_deb.sh
```

Una vez finalizado el proceso, instala el paquete `.deb` generado utilizando la herramienta `apt`:

```bash
sudo apt install ./sanson_*_amd64.deb
```

## Instalación directa desde el paquete listo (.deb)

Si prefieres omitir la compilación, descarga el paquete precompilado e instálalo directamente ejecutando:

```bash
wget https://github.com/IamJony/sanson-debian/releases/download/v1.5.3/sanson_1.5.3_amd64.deb
sudo apt install ./sanson_1.5.3_amd64.deb
```

