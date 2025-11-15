# Guía de Contribución

¡Gracias por tu interés en contribuir a **Terraform AWS Free Tier**! Esta guía te ayudará a comenzar.

## 📋 Índice

- [Código de Conducta](#código-de-conducta)
- [Cómo Contribuir](#cómo-contribuir)
- [Proceso de Desarrollo](#proceso-de-desarrollo)
- [Estándares de Código](#estándares-de-código)
- [Testing](#testing)
- [Documentación](#documentación)
- [Envío de Pull Requests](#envío-de-pull-requests)

## 📜 Código de Conducta

Este proyecto y todos los participantes se rigen por el Código de Conducta adoptado. Al participar, se espera que mantengas este código.

### Nuestro Compromiso

Nosotros, como miembros, colaboradores y administradores, nos comprometemos a hacer de la participación en nuestra comunidad una experiencia libre de acoso para todos.

## 🤝 Cómo Contribuir

### Tipos de Contribuciones

Buscamos contribuciones en las siguientes áreas:

- 🐛 **Corrección de errores**
- ✨ **Nuevas características**
- 📖 **Mejoras en documentación**
- 🎨 **Mejoras de código y estructura**
- 💡 **Sugerencias y mejoras**
- 🧪 **Pruebas y validación**

### Antes de Empezar

1. **Revisa los issues abiertos**: Quizás ya exista una solución en progreso
2. **Crea un issue nuevo**: Si tienes una idea nueva o encontraste un bug
3. **Discute en el issue**: Asegúrate de que tu enfoque es correcto antes de empezar a trabajar

## ⚙️ Proceso de Desarrollo

### Configuración del Entorno

1. **Fork el repositorio**

```bash
git clone https://github.com/tu-usuario/terraform-aws-free-tier.git
cd terraform-aws-free-tier
```

2. **Añade el repositorio original como remote**

```bash
git remote add upstream https://github.com/original/terraform-aws-free-tier.git
```

3. **Crea una rama para tu feature**

```bash
git checkout -b feature/mi-nueva-caracteristica
```

4. **Instala las herramientas necesarias**

```bash
# Terraform
brew install terraform  # macOS
# o descarga desde: https://www.terraform.io/downloads.html

# AWS CLI
brew install awscli  # macOS
# o sigue: https://aws.amazon.com/cli/
```

### Flujo de Trabajo

```bash
# 1. Sincroniza con el repo original
git fetch upstream
git checkout main
git merge upstream/main

# 2. Crea tu rama
git checkout -b feature/mi-feature

# 3. Realiza tus cambios
# ... haz cambios ...

# 4. Formatea el código
terraform fmt -recursive

# 5. Valida la sintaxis
terraform validate

# 6. Prueba tu cambio
terraform plan

# 7. Commit tus cambios
git add .
git commit -m "feat: añadir nueva característica"

# 8. Push a tu fork
git push origin feature/mi-feature

# 9. Crea un Pull Request
```

## 📏 Estándares de Código

### Terraform

1. **Formato**
   - Usa `terraform fmt -recursive` antes de commit
   - Mantén una línea entre bloques de recursos
   - Indenta con 2 espacios

```hcl
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main-vpc"
  }
}
```

2. **Nomenclatura**
   - Recursos: `snake_case` (ej: `aws_instance`, `aws_vpc`)
   - Variables: `snake_case` (ej: `instance_type`, `vpc_id`)
   - Outputs: `snake_case` (ej: `instance_public_ip`)
   - Tags: `PascalCase` para keys (ej: `Name`, `Environment`)

3. **Documentación**
   - Todas las variables deben tener `description`
   - Outputs deben tener `description`
   - Recursos complejos deben tener comentarios explicativos

```hcl
variable "instance_type" {
  description = "Tipo de instancia EC2 (ej: t2.micro, t3.small)"
  type        = string
  default     = "t2.micro"
}

resource "aws_instance" "web" {
  # Instancia web en subred pública
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name = "web-server"
  }
}
```

4. **Buenas Prácticas**
   - Usa `count` o `for_each` para múltiples recursos
   - Configura `lifecycle` para prevenir cambios no deseados
   - Usa variables para valores que pueden cambiar
   - No hardcodees valores que deberían ser parametrizables

```hcl
resource "aws_security_group" "web" {
  name_prefix = "web-sg-"

  lifecycle {
    create_before_destroy = true
  }
}

variable "environment" {
  description = "Ambiente de despliegue"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "El ambiente debe ser dev, staging o prod."
  }
}
```

### Git

1. **Commits Conventionales**

```
feat: añadir módulo RDS para base de datos
fix: corregir problema con security group
docs: actualizar README con nuevos ejemplos
refactor: reorganizar estructura de módulos
test: añadir tests para módulo EC2
chore: actualizar .gitignore
```

2. **Estructura de Mensaje**

```
tipo(alcance): descripción corta

descripción más larga si es necesaria

 footer si es necesario
```

## 🧪 Testing

### Validación Automática

Antes de enviar un PR, asegúrate de:

1. **Formatear código**
```bash
terraform fmt -recursive
```

2. **Validar sintaxis**
```bash
terraform validate
```

3. **Plan de despliegue**
```bash
terraform plan
```

### Manual Testing

1. **Crear un entorno de prueba**
```bash
terraform apply -auto-approve
```

2. **Verificar recursos**
```bash
# Listar recursos creados
terraform show

# Ver salidas
terraform output
```

3. **Probar funcionalidades**
```bash
# Conectar a EC2
ssh -i ./provision/access/free-tier-ec2-key ubuntu@[IP]

# Verificar servicios
curl http://[IP]
```

4. **Limpiar**
```bash
terraform destroy -auto-approve
```

## 📖 Documentación

### Qué Documentar

- **Nuevas características**
- **Cambios en configuraciones**
- **Variables nuevas o modificadas**
- **Outputs nuevos**
- **Ejemplos de uso**

### Dónde Documentar

1. **README.md**: Actualiza si cambias el flujo principal
2. **Código**: Comentarios en el código para lógica compleja
3. **CHANGELOG.md**: Documenta todos los cambios
4. **memory-bank/**: Actualiza contexto si es relevante

### Ejemplo de Documentación

```hcl
# Crear bucket S3 con versioning y encryption
resource "aws_s3_bucket" "main" {
  bucket = var.bucket_name

  # El versioning permite recuperar versiones anteriores
  versioning {
    enabled = true
  }

  # El encryption protege los datos en reposo
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}
```

## 📤 Envío de Pull Requests

### Antes de Enviar

- [ ] El código pasa `terraform fmt`
- [ ] El código pasa `terraform validate`
- [ ] `terraform plan` no produce errores
- [ ] Los commits siguen la convención conventional commits
- [ ] La documentación está actualizada
- [ ] Los tests pasan (si aplica)

### Template de PR

```markdown
## Descripción
Descripción clara y concisa de qué hace este PR.

## Tipo de Cambio
- [ ] 🐛 Corrección de bug
- [ ] ✨ Nueva característica
- [ ] 💥 Breaking change
- [ ] 📖 Documentación
- [ ] 🎨 Refactor de código

## Cómo se Probó?
Describe las pruebas que ejecutaste para verificar los cambios.

## Checklist:
- [ ] Mi código sigue las guías de estilo del proyecto
- [ ] He realizado self-review de mi código
- [ ] He comentado mi código, especialmente en áreas complejas
- [ ] He actualizado la documentación correspondiente
- [ ] Mis cambios no generan nuevos warnings
- [ ] He añadido tests que prueban que mi fix es efectivo o que mi feature funciona
- [ ] Tests unitarios nuevos y existentes pasan localmente con mis cambios
- [ ] Cualquier dependent changes han sido mergeados y publicados

## Screenshots (si aplica):
```

### Proceso de Revisión

1. **Revisión Automática**: CI/CD verificará formateo, sintaxis y validaciones
2. **Revisión de Código**: Un maintainer revisará tu código
3. **Feedback**: Puede que recibas comentarios para hacer cambios
4. **Merge**: Una vez aprobado, tu PR será mergeado

## 🐛 Reportando Bugs

Si encuentras un bug, por favor crea un issue con:

### Template de Bug Report

```markdown
## 🐛 Descripción del Bug
Descripción clara y concisa del bug.

## Para Reproducir
Pasos para reproducir el comportamiento:
1. Ve a '...'
2. Haz clic en '....'
3. Scroll hasta '....'
4. Ve error

## Comportamiento Esperado
Descripción clara y concisa de lo que esperabas que pasara.

## Screenshots
Si aplica, añade screenshots del problema.

## Información del Entorno:
 - OS: [ej: Ubuntu 20.04]
 - Terraform Version: [ej: 1.5.0]
 - AWS Provider Version: [ej: 5.0.0]

## Contexto Adicional
Cualquier otro contexto sobre el problema.
```

## 💡 Solicitando Features

### Template de Feature Request

```markdown
## 🚀 Resumen de Feature
Descripción clara y concisa de la feature.

## Problema que Resuelve
Qué problema resuelve esta feature? Es tu problema actual?

## Solución Propuesta
Descripción clara y concisa de lo que quieres que pase.

## Alternativas Consideradas
Descripción de alternativas que consideraste.

## Contexto Adicional
Screenshots, mockups, etc. sobre la feature.
```

## 🎓 Recursos de Aprendizaje

- [Documentación oficial de Terraform](https://www.terraform.io/docs)
- [Guía de estilo de HashiCorp](https://www.terraform.io/docs/cloud/guides/recommended-practices/style-guide.html)
- [Mejores prácticas de Terraform](https://www.terraform-best-practices.com/)
- [AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

## ❓ ¿Tienes Preguntas?

Si tienes preguntas, no dudes en:

1. Crear un issue con la etiqueta `question`
2. Abrir una discusión
3. Contactar a los maintainers

## 🙏 Agradecimientos

Gracias a todos los contribuidores que han ayudado a mejorar este proyecto!

## 📄 Licencia

Al contribuir, aceptas que tus contribuciones serán licenciadas bajo la misma Licencia MIT del proyecto.

---

**¡Gracias por contribuir a Terraform AWS Free Tier!** 🎉