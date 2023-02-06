---
theme: seriph
---

# TERRA-FORMA(CION)

Escribo la presentación mientras hablo

---

# DEVOPS

- @irene Una misma persona maneje ambos mundos
- @borja Una persona que tiene un conocimiento general tecnico de
  varios proyectos (apaga fuegos)
- @todos Lo asocian a un rol/persona

### **Son los procesos o ideas que hacen el Software Delivery mas eficiente**

- CULTURA
- **AUTOMATIZACION**
- MEDICIÓN
- COMPARTIR

---

# ¿QUÉ ES IaC?

## Infraestructura cómo **código**

DEFINIR - DESPLEGAR - ACTUALIZAR - ELIMINAR

### Beneficios

- Reutilizar
- Control de Versiones
- Validación (Testing)
- Autoservicio
- Auto-documentación

---

# Tipos de Herramientas

1. Adhoc script

- Configuración

2. Configuration Mgmt Tools (Puppet, Ansible)

- Idempotencia + Estructura + Distribución

3. Templates (Docker, Packer)

- Infraestructura inmutable

4. Orquestador (k8s, Nomad)

- Gestión de la infra inmutable

5. Provisionador (Terraform, CloudForm)

- TODA LA INFRA

NEXT BIG THING **REPRODUCIBILIDAD**

---

# ¿CÓMO FUNCIONA TERRAFORM?

### 1. ABSTRACCIÓN DE APIS DE CONFIGURACIÓN

### 2. RESOLUCION DE DEPENDENCIAS

#### Características

- Provisiona
- Ideal para infra. inmutable
- Lenguaje declarativo
- DSL (Domain-specific Language)
- Masterless
- Agentless
- Gratuito
- Comunidad grande

##### Ejemplo con otras herramientas:

- Packer -> Crea VM con k8s y Docker Engine
- TF -> Despliega redes, bbdd y servidores con VM de Packer

---

# Ejercicio 1 - Entorno de trabajo

- Inicializar entorno de trabajo
- Requisitos
  - S.O. Linux (real o virtual)
  - `git`
  - Gestor de paquetes `nix`
  - Gestor de entornos `direnv` (opcional)

```bash
$> mkdir ~/curso-tf
$> cd ~/curso-tf
$> git init
$> nix flake init -t github:CIVIR-SRC/terra-forma --refresh
$> direnv allow # o nix develop
```

---

# Ejercicio 2 - Credenciales

- Generar tokens de acceso de AWS (desde la consola web)
- Guardar los tokens en el entorno:

```bash
$> cat ~/.aws/credentials
[default]
aws_access_key_id=AKIAIOSFODNN7EXAMPLE
aws_secret_access_key=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
```

---

# Editores de texto
### IDEs

Se llaman IDEs, o Entornos de desarrollo integrados a los editores de
texto especializados en el desarrollo de proyectos. Suelen contar con
ayudas tipo autocompletado y verificación de sintaxis.

El entorno de trabajo del curso está preparado para conectarse a él
por SSH desde VSCode.
### Editores modales

Son llaman editores modales los editores de texto tipo `vim` o Helix
`hx` donde los MODOS de interacción son múltiples (normal, insert,
visual, ...). Ambos editores están disponibles en el entorno de trabajo.

#### Uso básico (abrir fichero, editar, guardar):

- Abres o comienzas un fichero con `hx main.tf`
- Activas modo escritura con tecla `i` (insert)
- Sales del modo escritura con la tecla `ESC`
- Guardas con `:w` (write), sales con `:q` (quit) (o `:wq`)

---

# Ejercicio 3 - Mi primer proveedor

- Creamos en el directorio de trabajo un fichero `main.tf`
- Declaramos en `main.tf` los proveedores que queremos utilizar:

```hcl
provider "aws" {
  region = "us-east-1"
}
```

- Inicializamos terraform

```bash
$> terraform init
```

---

# Ejercicio 4 - Servidor simple

- Añadimos un `resource` tipo EC2 al fichero `main.tf`
```hcl
resource "aws_instance" "example" {
  ami           = "ami-00874d747dde814fa" #us-east-1
  instance_type = "t2.micro"
}
```

- Ejecutamos `terraform plan` y `terraform apply`
- Entramos en la consola para ver que se ha creado la instancia (sin
  nombre)
- Le añadimos un nombre al `resource` usando `tags`:

```hcl
...
  tags = {
    Name = "terraform-example"
  }
...
```

---

# Ficheros propios de Terraform
##

Al ejecutar `terraform` en el directorio de trabajo se crearán una serie
de ficheros:

```bash
$> ls -a | grep terraform
.terraform/                # binarios de los proveedores
.terraform.lock.hcl        # versión de proveedores fijada
terraform.tfstate          # estado de terraform
terraform.tfstate.backup   # backup del estado
```

A la hora de trabajar en un repositorio tipo `git` el único que nos
interesa controlar es el fichero que fija la versión de los
proveedores `.terraform.lock.hcl` para que el resto de personas del equipo use las
mismas dependencias exactas.

El resto de ficheros deberían ser ignorados en el sistema de control
de versiones (`.gitignore`).

---

# Ejercicio 5 - Git local <-> GitHub

- Creamos o modificamos fichero `.gitignore` para que ignore ficheros
  propios de Terraform. (GitHub ofrece plantillas para casi todos los
  lenguajes: https://github.com/github/gitignore )

- Preparamos (*stage*) y confirmamos (*commit*) todos los ficheros del
  directorio de trabajo:
  
```bash
$> git add .                       # Añadimos al área de preparación (*staging area*)
$> git commit -m "Initial commit"  # Confirmamos los cambios con un mensaje
```

- Generamos par de claves SSH para nuestro entorno de trabajo:

```bash
$> ssh-keygen -t ed25519
```

- En nuestra cuenta de GitHub:
  - Añadimos la clave pública (`~/.ssh/id_ed25519.pub`) del entorno de
    trabajo a las autorizadas
  - Creamos un repositorio público vacio
  - Ejecutamos en nuestro entorno las instrucciones del epígrafe `…or
    push an existing repository from the command line` (protocolo SSH)

---

# Ejercicio 6 - Servidor Web simple

- Lavantaremos un servidor web mediante scripting usando el servicio
  *User Data* de AWS EC2
  (https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html):

```hcl
...
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF

  user_data_replace_on_change = true
...
```

- ¿Por qué 8080 y no 80?
- ¿Qué alternativas al script de user_data se os ocurren?
- ¿Qué es eso de `EOF`? (Sintaxis `heredoc`)
- ¿Por qué se necesita la directiva `user_data_replace_on_change`?
- ¿Podríamos acceder ya a ese servidor desde Internet?

---

# Expresiones Terraform (I)

Llamamos expresiones a cualquier elemento que devuelve un valor

### Literales

- Strings, números, ...

### Referencias a atributos

- Permiten acceder a valores de otras partes de tú código
- No solamente definidas, también exportadas por el `resource` (doc)
- `<PROVIDER>_<TYPE>.<NAME>.<ATTRIBUTE>`
- Generan dependencias implicitas entre recursos.

---

# Ejercicio 6 - Servidor Web simple (II)

- Necesitamos abrir el tráfico (`ingress`)

```hcl
resource "aws_instance" "example" {
#...
  vpc_security_group_ids = [aws_security_group.allow_example.id]
#...
}

resource "aws_security_group" "allow_example" {
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

- Aplicamos y miramos en la consola la IP pública de nuestra
  instancia
- Comprobamos que se accede desde un navegador web

---

# Input Variables
Don't Repeat Yourself

- `description`: Es importante añadirla ya que nos la mostrará en las
  diferentes salidas
- `default`: Regla: Que facilite la vida al usuario
- `type` / `validation`: *Catch errors as soon as possible*
- `sensitive`

## Inicialización
- Ficheros
- Interactiva
- Argumento línea de comando `terraform plan -var "<VARIABLE_NAME>=<VALUE>"`
- Variables de entorno `TF_VAR_<VARIABLE_NAME>`

---

# Expresiones Terraform (II)

### Literales
### Referencias a atributos
- `<PROVIDER>_<TYPE>.<NAME>.<ATTRIBUTE>`
### Referencias a variables
- `var.<VARIABLE_NAME>`
### Interpolación en *strings*
- `"${...}"`

---

# Ejercicio 7 - Servidor Web configurable

- Crearemos un nuevo fichero `variables.tf`

```hcl
variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
}
```

- Modificamos `main.tf` para hacer referencia a la nueva variable
  - En recursos `var.server_port`
  - En strings (como `user_data`): `${var.server_port}`
  
- Probamos estas 3 formas de inicializar variables:
  - `terraform plan` a secas (interactiva)
  - `terraform plan -var "server_port=8080"`
  - `export TF_VAR_server_port=8080` antes de lanzar `plan`

---

# Ejercicio 8 - Output Variables

- Vamos a pedir que nos diga la IP de la máquina que desplegamos
- Creamos fichero `outputs.tf`

```hcl
output "public_ip" {
  value       = aws_instance.example.public_ip
  description = "The public IP address of the web server"
}
```

## ¿Cómo usar los outputs?
- Al finalizar un `terraform apply`
- Al lanzar `terraform output`
- E, ideal para *scripting* `terraform output public_ip`

---

# Documentación
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs

---

# Ejercicio 9 - Convertir EC2 -> ASG

- ASG: Auto scaling group -> VA A NECESITAR UNA PLANTILLA
- Convertir nuestra `aws_instance` en `aws_launch_configuration`
  - Buscamos las equivalencias en la **documentación**:
     - `ami` -> `image_id`
     - `user_data_replace_on_change` -> No existe, eliminar
     - `vpc_security_group_ids` -> `security_groups`
- Quedaría así:
```hcl {2,3,4}
resource "aws_launch_configuration" "example" {
  image_id        = "ami-0fb653ca2d3203ac1"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.allow_example.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF
}
```

---

# Ejercicio 9 - Convertir EC2 -> ASG (II)

- Creamos el `aws_autoscaling_group`
```hcl
resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.example.name

  min_size = 2
  max_size = 10

  tag {
    key                 = "Name"
    value               = "terraform-asg-example"
    propagate_at_launch = true
  }
}
```

---

# Lifecycle (I)

- Por defecto, la lógica es: `destroy_before_create`.
- Hay casos donde esta lógica nos crea dependencias que provocan
  errores.
- Por ejemplo, el `autoscaling_group` depende de
  `launch_configuration`, por lo que si modificamos un
  `launch_configuration` que esté en uso, al intentar destruirlo nos
  dará error.
- Esto sucederá principalmente en `resources` del tipo inmutables.
  
- Para solucionarlo añadimos a `aws_launch_configuration`:

```hcl
lifecycle {
  create_before_destroy = true
}
```

---

# Repaso Sintáxis

- Recurso:

```hcl
resource "<PROVIDER>_<TYPE>" "<NAME>" {
  <CONFIG>
}
```

- Variable:

```hcl
variable "<NAME>" {
  <CONFIG>
}
```

- Referencias:

```hcl
<PROVIDER>_<TYPE>.<NAME>.<ATTRIBUTE>

var.<NAME>
```

---

# Data Sources

Información sólo lectura

Son trozos de información SÓLO LECTURA que se extraen del proveedor
CADA VEZ que se ejecuta `terraform`.

Un *data source* no crea nada nuevo, es una manera de extraer
información y tenerla disponible para el resto del código Terraform.

- Definición:

```hcl
data "<PROVIDER>_<TYPE> "<NAME>" {
  <CONFIG>
}
```

- Referencia:

```hcl
data.<PROVIDER>_<TYPE>.<NAME>.<ATTRIBUTE>
```

---

# Ejercicio 10 - Extraer *subnets*

- Utilizando *data sources* extraeremos la info de las *subnets* por
  defecto del VPC por defecto

```hcl
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}
```

- Apoyándonos en la documentación de `data.aws_subnets` hacemos que
  nuestro ASG utilice las *subnets* extraídas usando el argumento
  `vpc_zone_identifier`.

<!-- ```hcl
 !--   vpc_zone_identifier = data.aws_subnets.ids
 !-- ``` -->

---

# Ejercicio 11 - Balanceador

- Vamos a definir un balanceador ELB (Elastic Load Balancer) del tipo
  ALB (Application Load Balancer - Layer 7).
- Pasos:
  - Crear recurso LB
  - Crear recurso LB Listener
  - Autorizar entrada y salida de tráfico en ALB (`security_groups`)
  - Crear recurso LB Target Groups
  - Crear recurso LB Listener Rules
  - Actualizar nuestro Output a la dirección DNS del LB

---

# Capítulo 3 - **Terraform State**
##

Llamamos estado a la información almacenada sobre la infraestructura
ya creada, se guarda en un fichero JSON.

- La API del estado es **PRIVADA**
- Surgen las siguientes preguntas:
  - ¿Cómo lo compartimos? - (AWS S3 Bucket)
  - ¿Es seguro? - (*Encryption-at-rest*)
  - Al compartirlo, ¿cómo evitamos que varios miembros accedan a la
    vez? - (AWS DynamoDB)
  - ¿Cómo aislamos los estados de diferentes entornos? - (*workspaces*
    de Terraform ó estructura de directorios)

---

# Backends
##

Definición de dónde Terraform almacena el estado:

```hcl
terraform {
  backend "<BACKEND_NAME>" {
    [CONFIG...]
  }
}
```

- IMPORTANTE: No está permitido usar variables o referencias.
- El backend por defecto es `local`.
- Existen backends para: `s3`, `azurerm`, `gcs`, `consul`, `http`, etcétera.

---

# Ejercicio 12 - Infra para State

- Aislar (mover) el proyecto del cluster web a un direcotrio propio, por
  ejemplo a `./integ/services/webserver-cluster`.
- Definir aisladamente (por ejemplo en `./global/s3`) la
  infraestructura necesaria para almacenar el estado en AWS:
  - S3 Bucket, con las características de: versionado de ficheros;
    encriptación; y acceso público restringido.
  - Tabla en DynamoDB con el `hash_key` y el tipo de dato que necesita
    Terraform. (Buscar en la documentación del *backend* S3).
- Añadir en ambos directorios la definición del `backend` recién
  creado. (**OJO**: Deben tener valores `key` diferentes).
- Inicializar el *backend* con `terraform init` y migrar el estado
  `local`.

---

# Ejemplo de organización

```bash
$> tree
.
├── global
│   ├── iam
│   └── s3
│       ├── main.tf
│       └── outputs.tf
├── stage
│   ├── vpc
│   ├── services
│   │   ├── frontend-app
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   └── variables.tf
│   │   └── backend-app
│   └── data-storage
├── prod
└── mgmt
```

---

# Ejercicio 13 - Estado remoto *Data Source*

- Crear nueva configuración para una base de datos en
  `./integ/data-stores/mysql`:
  - Definimos nuevo recurso: `aws_db_instance` con motor `mysql`.
  - Creamos 2 variables para el usuario y contraseña de la
    BBDD. (Recuerda `sensitive = true`).
  - Configuramos el mismo *backend* que usamos en el ejercicio
    anterior. (Recuerda cambiar el valor de `key`).
  - Creamos 2 variables de salida (`outputs.tf`) para la dirección y el
    puerto de la BBDD.

- Aplicamos la nueva definición, exportando previamente el usuario y
  contraseña mediante variables de entorno: `$> export
  TF_VAR_db_password="PASSWORD"`.

- Añadimos *data source* tipo `terraform_remote_state` al `main.tf` de
  nuestro cluster web.

- Añadimos la referencia al puerto y dirección de la BBDD en nuestro
  `user_data` (OPCIONAL: Convertir el *script inline* en un fichero
  independiente).

---

# Parte 4 - **Módulos**
Funciones

- ¿Cómo evitamos tener que estar copiando y pegando código entre
  `integ` y `prod`?
- Los módulos son la clave para escribir código Terraform
  reutilizable, mantenible y *testable*.
- Cualquier conjunto de archivos `.tf` en un directorio son
  técnicamente un módulo. Es decir, lo que hemos hecho hasta ahora son
  módulos (_Root modules_), pero aun no son reutilizables.
- Para utilizar un módulo (_Child module_) usamos:

```hcl
module "<NAME>" {
  source = "<SOURCE>"
  [CONFIG ...]
}
```

## Ejercicio 4.1

- Creamos `./modules/services/webserver-cluster` y movemos el
  contenido de `./integ/services/webserver-cluster` eliminando el
  bloque `provider`.
- Llamamos al nuevo módulo en `prod` y en `integ`.

---

# Repaso organización de nuestro código (I)
##
(NOTA: Llamaremos `$PRJ_ROOT` al directorio raíz de nuestro entorno de
trabajo)

1. Comenzamos desarrollando un _Root Module_ (terminología exacta
   Terraform) para un _cluster_ web directamente en `$PRJ_ROOT`.
   
2. Para tener ficheros de estado aíslados según entorno o tipo de
   servicio creamos una estructura de directorios. NOTAS: 
   - **La organización de la estructura elegida es arbitraria,
   solamente un ejemplo.**.
   - Cada cliente puede necesitar una estructura diferente.
   - ¿Usa vuestro cliente una organización de este tipo?  ¿Usando
   directorios? ¿Qué otro modo diferente a los directorios usa?

3. Desarrollamos otros _Root Modules_ en sus correspondientes
   directorios (Ejemplos:`$PRJ_ROOT/global/s3` y servidor `mysql`).

---

# Repaso organización de nuestro código (II)
##

4. Creamos un nuevo directorio en `$PRJ_ROOT` donde guardaremos _Root
   Modules_ listos para ser reutilizados
   (`$PRJ_ROOT/modules/...`). NOTAS:
   - **Este nombre de directorio también es arbitrario**.
   - Es una manera de agrupar, de manera lógica, el código apto para
     ser reutilizado.
   - ¿Vuestro cliente cómo agrupa sus módulos? 

5. Convertimos nuestro _Root module_ del _cluster_ web en código
   preparado para ser reutilizado y lo guardamos en su propio
   directorio dentro de `modules`.

6. Modificamos nuestro _cluster_ web para que haga uso del módulo
   reutilizable ( `module "<NAME>" { source = ... }` ). Siguiendo
   estrictamente la terminología Terraform: Al módulo que es llamado
   desde el _Root Module_ se le llama _Child Module_.

7. Siendo necesario que el ciclo de desarrollo de los **módulos listos
   para ser reutilizados** sea diferente al del las **configuraciones
   que definen la infraestructura de cada entorno**, los separaremos
   en (al menos) 2 repositorios diferentes. (Por ejemplo: `modules` y
   `live`).

---

# Module Inputs
La API (Interfaz) del módulo.

- Son el equivalente a los parámetros en una función de un lenguaje de
  uso general.
- Se declaran EXACTAMENTE igual que se declaran las variables.
- Será necesario convertir en *input* valores *hardcodeados* que
  varien entre entornos y, opcionalmente, algunas configuraciones.

## Ejercicio 4.2

- Añadimos *inputs* al módulo `webserver-cluster` para evitar valores
  *hardcodeados* (`db_remote_state_bucket`, `db_remote_state_key`,
  `cluster_name`).
- Fijamos valores para estos nuevos *inputs* en la llamada al
  módulo. En `integ` y en `prod`.
- Añadimos y fijamos nuevos *inputs* para configuraciones que,
  potencialmente, variarán entre entornos. (Por ejemplop: `instance_type`).

---

# Module Locals
Variables de uso privado

- Para evitar *DRY* sin exponer variables públicamente.
- Facilitar la legibilidad y el mantenimiento.
```hcl
locals {
  <NAME> = <VALUE>
  ...
}
```

- Las referenciamos con `local.<NAME>`.

## Ejercicio 4.3

- Añadimos varios *locals* a nuestro módulo. Por ejemplo: `http_port`,
  `any_port`, `any_protocol`, `all_ips`, ...

---

# Module Outputs
Valores que devuelve

- Como en una función, tenemos que ser explicitos con los valores que
  queremos devolver a los usuarios de los módulos.
- Se definen igual que los _outputs_ que hemos definido hasta ahora.
- Para referenciar el valor de un output: `module.<MODULE_NAME>.<OUTPUT_NAME>`.

## Ejercicio 4.4

- Hacemos _pass through_ del nombre DNS en el `outputs.tf` de los
  entornos.
- Ejemplo:
```hcl
output "alb_dns_name" {
  value = module.webserver_cluster.alb_dns_name
}
```

---

# Notas sobre los Módulos
Algunas consideraciones a tener en cuenta

- Si usamos un ruta relativa en un módulo, Terraform buscará el fichero
  en el directorio de ejecución. Para evitar eso disponemos de las
  referencias: `path.module`, `path.root` y `path.cwd`.
- La configuración de algunos _resources_ se puede hacer dentro del
  propio bloque o en un _resource_ propio.
- Cuando creamos módulos el consejo es usar **SIEMPRE** _resources_
  separados. Esto hará que creemos módulos más flexibles y
  personalizables.
- Para que un módulo pueda usarse en entornos productivos y no
  productivos necesita tener su propio ciclo de desarrollo. _Semantic
  Versioning_.

## Ejercicio 4.5

- Pensar cómo haríamos para abrir en `prod` el puerto 80 y en `integ`
  el 80 y el 12345.
- Movemos los módulos a su propio repositorio `git` y _taggeamos_ la
  versión.

---

# Parte 5 - Tips and Tricks

---
layout: section
---
# Parte 6 - Gestión de Credenciales
##

Concepto básico

Clasificación de credenciales y herramientas

Comparativa de herramientas

Uso en Terraform

---

# Concepto básico

- 2 Reglas:
  - No guardes tus credenciales en ficheros de texto sin ecriptar.
  - **NO GUARDES TUS CREDENCIALES EN FICHEROS DE TEXTO SIN ENCRIPTAR**

- ¿Por qué es una mala idea?
  - Cualquier persona con acceso al sistema de control de versiones
    tiene acceso a la credencial.
  - Cada máquina (CI/CD, Backup...) que tiene acceso al control de
    versiones guardará una copia de la credencial.
  - Las credenciales estarán en tantos lugares que potencialmente
    cualquier software de la organización tendrá acceso a él.
  - No hay forma de auditar o revocar el acceso a esa credencial.

- SOLUCIÓN: **Herramienta** para la gestión de credenciales
  **adecuada**.

---

# Clasificación de credenciales y herramientas

- 3 tipos de credenciales:
  - Personales - _usuarios, contraseñas, claves SSH, ..._
  - De los clientes - _usuarios y contraseñas de tus clientes,
    información personal, ..._
  - De la infraestructura - _contraseñas de BBDD, claves API,
    certificados, ..._

- 2 formas habituales de guardarlas:
  - En ficheros encriptados (dilema: ¿dónde almacenamos la clave de
    encriptación? - _AWS KMS, usando claves PGP, ..._).
  - Almacén centralizado. La clave de encriptación se guarda con
    mecanismos del propio almacén o, de nuevo, con _AWS KMS_ o similar.

- 3 formas de acceder: API, CLI y/o Interfaz gráfica.

---

# Comparativa de herramientas

- **HashiCorp Vault** | Infraestructura | Centralizado | UI, API, CLI
- **AWS Secrets Manager** | Infraestructura | Centralizado | UI, API, CLI
- **sops** | Infraestructura | Ficheros | CLI
- **LastPass** | Personal | Centralizado | UI, API, CLI
- **KeePass** | Personal | Ficheros | UI, CLI
- **Active Directory** | Clientes | Centralizado | UI, API, CLI
- **Auth0** | Clientes | Centralizado | UI, API, CLI

---

# Uso en Terraform providers

- Por humanos:
  - Variables de entorno + gestor de tipo personal.
  - Herramientas CLI específicas de un proveedor (`aws-vault`).

## Ejercicio 6.1
Creamos un perfil en `aws-vault` usando nuestras credenciales y
eliminamos el fichero no seguro que estabamos utilizando hasta ahora.

```sh
$> export AWS_VAULT_BACKEND=file
$> aws-vault add <PROFILE>
$> rm ~/.aws/credentials
$> aws-vault exec --region=us-east-1 <PROFILE> env
```

---

# Uso en Terraform providers (II)

- Por máquinas

---

# Uso en Terraform resources y data sources

---

# Uso en Terraform plan
