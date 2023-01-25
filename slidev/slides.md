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

# Ejercicio 6 - Servidor Web simple (II)

- Necesitamos abrir el tráfico (`ingress`)

```hcl
resource "aws_instance" "example" {
#...
  vpc_security_group_ids = [aws_security_group.instance.id]
#...
}

resource "aws_security_group" "instance" {
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
