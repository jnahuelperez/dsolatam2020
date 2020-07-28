# Instalando VAULT

Si te das maña con el ingles podes seguir la guia oficial de hashicorp en [este link](https://learn.hashicorp.com/vault/getting-started/vault-intro)

## Iniciando servidor de prueba
Descargar vault [desde aca](https://www.vaultproject.io/downloads) y configurarlo en el path que corresponde appropriate package
Podes verificar que todo funciona bien haciendo un `vault -version`
Es posible usar `vault -autocomplete-install && exec $SHELL` para tener un binario que con doble tab previsualice argumentos

## Inicializando el servidor local
```
vault server -dev
export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_DEV_ROOT_TOKEN_ID=“ROOT_TOKEN_HERE”
```

<b>IMPORTANTE</b>: Vault no recomienda para nada correr un ambiente DEV como productivo. Recorda que el contenido es efimero, por que si se reinicia, se pierden todos los secretos que se hayan generado. Para el caso productivo es ma conveniente usar instancias dedicadas con Consul como soporte. Como se explica [en este link](https://learn.hashicorp.com/vault/getting-started/deploy)

## Habilitando secretos dinámicos
Habilitamos secretos para AWS
```
vault secrets enable -path=aws aws
```
Escribimos la root config que le permite a VAULT hablar con nuestra cuenta AWS
```
vault write aws/config/root \
access_key=[ACCESS_KEY] \
secret_key=[SECRET_KEY} \
region=us-east-1
```

## Creando Rol AWS
Para que vault pueda crear access/secret key que nos permitan realizar acciones, le tenemos que indificar que tipo de acciones va un usuario a poder realizar. Para ello creamos un rol:
```
vault write aws/roles/my-role \
credential_type=iam_user \
        policy_document=-<<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1426528957000",
      "Effect": "Allow",
      "Action": [
        "ec2:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF

vault write aws/config/lease lease=20s lease_max=20s
```

## Habilitando Github
Habilitamos Github como metodo de autenticacion para validar usuarios y centralizar la gestion desde una sola plataforma:
```
vault auth enable github
vault write auth/github/config organization={tu organizacion} ttl=86400s
vault write auth/github/map/teams/eng value=my-role
```
## Pidiendo nuestro AWS access/secret
Iniciamos sesion en vault usando nuestro github token y lo exportamos
```
vault login -method=github token=[your github token]
vault read aws/creds/my-role
export VAULT_TOKEN=[TOKEN DEVUELTO POR VAULT]
```

