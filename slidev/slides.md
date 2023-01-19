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
