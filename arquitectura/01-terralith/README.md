# Arquitectura Terralitica

## Antes de ejecutar terraform
* Hay que crear un s3 bucket de nombre `dsolatam2020`. Si elegis otro nombre, recorda cambiarlo en los terraform file.
* Si no estas usando alguna herramienta de gestion de secretos hay que exportar las variables.
* Crear una Key y actualizar el recurso instance para que la consuma.

```
export AWS_ACCESS_KEY_ID="{TU_ACCESS_KEY_ID}"
export AWS_SECRET_KEY="{TU_SECRET_KEY_ID}"
```

## Crear ambiente de test
Asegurarse que `producction.tf` este renombrado (.bkp_tf por ejemplo) para no ser alcanzado por el `terraform plan`
```
terraform init
terraform plan
```

## Agregando ambiente de prueba
* Renombrar archivo que refleja ambiente productivo a algo como `produccion.tf`
* Ejecutar terraform
```
terraform init
terraform plan
```

## Arruinando el ambiente
Se asume que se quiere hacer un cambio en el ambiente de desarrollo y para prevenir ejecucion no deseada se renombra el archivo de produccion.tf
* Aplicar los cambios 
* Ejecutar terraform
```
terraform init
terraform plan
```

Tu ambiente productivo habra desaparecido.
