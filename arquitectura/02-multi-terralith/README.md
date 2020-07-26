# Arquitectura Multi Terralitica

# Antes de ejecutar terraform
* Hay que crear un s3 bucket de nombre `dsolatam2020`. Si elegis otro nombre, recorda cambiarlo en los terraform file.
* Si no estas usando alguna herramienta de gestion de secretos hay que exportar las variables.
* Crear una Key y actualizar el recurso instance para que la consuma.

```
export AWS_ACCESS_KEY_ID="{TU_ACCESS_KEY_ID}"
export AWS_SECRET_KEY="{TU_SECRET_KEY_ID}"
```
