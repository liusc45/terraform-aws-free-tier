# CLAUDE.md ⚡

Guía para Claude Code (claude.ai/code) trabajando con este proyecto Terraform AWS Free Tier.

## 🎯 Propósito del Proyecto

**Terraform AWS Free Tier** es un proyecto de infraestructura como código (IaC) que utiliza Terraform para configurar automáticamente una infraestructura base gratuita en AWS. El proyecto crea una VPC, subredes, gateway de Internet, tabla de rutas y una instancia EC2 accesible públicamente.

## 📁 Estructura del Proyecto

```
terraform-aws-free-tier/
├── src/
│   ├── free-tier/              # Configuración principal
│   │   ├── main.tf             # Orquestación de módulos
│   │   ├── variables.tf        # Variables del proyecto
│   │   ├── outputs.tf          # Salidas del proyecto
│   │   ├── backend/
│   │   │   └── example.config.tf  # Plantilla de configuración S3
│   │   └── provision/
│   │       └── access/         # Claves SSH
│   └── modules/                # Módulos reutilizables
│       ├── vpc/
│       ├── public-subnet/
│       ├── internet-gateway/
│       ├── route-table/
│       └── ec2/
├── memory-bank/                # Memoria del proyecto
├── LEARNING-LOG.md             # Registro histórico
├── README.md                   # Documentación principal
└── CLAUDE.md                   # Esta guía
```

## 🏗️ Arquitectura

### Recursos AWS Creados

- **VPC**: 10.0.0.0/16 con DNS habilitado
- **Internet Gateway**: Para acceso a Internet
- **Public Subnet**: 10.0.1.0/24 en zona de disponibilidad
- **Route Table**: Enrutamiento hacia Internet Gateway
- **EC2 Instance**: t2.micro con Ubuntu 20.04 LTS
- **Security Groups**: SSH (22), HTTP (80), HTTPS (443)
- **Key Pair**: Para acceso SSH seguro

### Flujo de Dependencias

```hcl
VPC → Public Subnet
VPC → Internet Gateway
VPC + IGW + Subnet → Route Table
Subnet + Route Table → EC2 Instance
```

## ⚙️ Configuración para Claude Code

### Flujo de Trabajo Recomendado

1. **Análisis Inicial**:
   - Leer `README.md` para entender el proyecto
   - Revisar `memory-bank/` para contexto actual
   - Examinar estructura de módulos

2. **Desarrollo/Modificaciones**:
   - Trabajar en módulos primero si es necesario
   - Actualizar `main.tf` de free-tier para orquestar cambios
   - Mantener compatibilidad con backend S3

3. **Validación**:
   - `terraform fmt` para formateo
   - `terraform validate` para sintaxis
   - `terraform plan` para预览 cambios

4. **Documentación**:
   - Actualizar README.md si es necesario
   - Documentar cambios en CHANGELOG.md
   - Actualizar memory-bank/

### Comandos Útiles

```bash
# Inicializar
cd src/free-tier
terraform init -backend-config="./backend/config.tf"

# Planificar
terraform plan

# Aplicar
terraform apply

# Destruir
terraform destroy

# Formatear
terraform fmt -recursive

# Validar
terraform validate

# Salidas
terraform output
```

### Modificaciones Típicas

#### Agregar Nuevo Recurso

1. **Crear módulo** en `src/modules/nuevo-recurso/`
2. **Orquestar** en `src/free-tier/main.tf`
3. **Agregar variables** en `src/free-tier/variables.tf`
4. **Documentar** en README.md

#### Personalizar Configuración

Usar archivo `terraform.tfvars`:

```hcl
# Ejemplo terraform.tfvars
profile                = "terraform"
region                 = "us-east-1"
ec2_ssh_key_name       = "free-tier-ec2-key"
ec2_instance_type      = "t2.micro"
vpc_cidr_block         = "10.0.0.0/16"
```

## 🔧 Configuración AWS

### Credenciales

**Opción 1**: `~/.aws/credentials`
```ini
[terraform]
aws_access_key_id = TU_ACCESS_KEY
aws_secret_access_key = TU_SECRET_KEY
```

**Opción 2**: Variables de entorno
```bash
export AWS_ACCESS_KEY_ID="..."
export AWS_SECRET_ACCESS_KEY="..."
export AWS_DEFAULT_REGION="us-east-1"
```

### Backend S3

```hcl
# src/free-tier/backend/config.tf
bucket  = "mi-terraform-state-bucket"
key     = "terraform-aws-free-tier/terraform.tfstate"
region  = "us-east-1"
encrypt = true
```

## 📊 Métricas y Límites

### AWS Free Tier Limits

- **EC2**: 750 horas/mes t2.micro
- **EBS**: 30 GB almacenamiento
- **Transferencia**: 15 GB/mes
- **VPC**: Sin cargo adicional

### Costos Estimados

- **Sin uso (750h/mes)**: $0 USD
- **Uso moderado**: $5-15 USD/mes
- **Uso intensivo**: $15-50 USD/mes

## 🧪 Testing y Validación

### Pruebas Manuales

```bash
# 1. Crear infraestructura
terraform apply -auto-approve

# 2. Verificar recursos
aws ec2 describe-instances

# 3. Conectar vía SSH
ssh -i ./provision/access/free-tier-ec2-key ubuntu@[IP]

# 4. Probar HTTP
curl http://[IP]

# 5. Destruir
terraform destroy -auto-approve
```

### Validaciones Automáticas

- `terraform plan` debe completar sin errores
- `terraform show` debe listar todos los recursos
- Los outputs deben mostrar valores correctos

## 🚨 Consideraciones de Seguridad

### ✅ Buenas Prácticas Implementadas

- Backend S3 con cifrado habilitado
- Security Groups con reglas mínimas necesarias
- Claves SSH generadas localmente (no en repo)
- Instancia en subred pública controlada

### ⚠️ Áreas de Atención

- Security Group permite SSH desde 0.0.0.0/0 (cambiar en producción)
- No hay bastion host configurado
- No hay VPC Flow Logs habilitados
- AMI no está versionada explícitamente

### 🔒 Recomendaciones

Para uso en producción:
1. Restringir Security Group SSH a IP específica
2. Habilitar MFA en cuenta AWS
3. Usar AWS Systems Manager Session Manager
4. Habilitar CloudTrail para auditoría
5. Configurar VPC Flow Logs

## 📈 Roadmap

### v1.1.0 (Próxima)
- [ ] Módulo RDS (PostgreSQL/MySQL)
- [ ] Variables de entorno para configuración
- [ ] Ejemplos de terraform.tfvars

### v1.2.0
- [ ] Múltiples zonas de disponibilidad
- [ ] Application Load Balancer (ALB)
- [ ] Auto Scaling Group

### v1.3.0
- [ ] Integración CloudWatch
- [ ] SNS para notificaciones
- [ ] alarms para monitoreo

### v2.0.0
- [ ] Migración a Terraform 1.0+
- [ ] Terragrunt para gestión de estado
- [ ] GitOps con Atlantis otf

## 🤝 Contribución

### Estándares de Código

- **Formato**: `terraform fmt -recursive`
- **Documentación**: Comentarios en variables y outputs
- **Naming**: snake_case para recursos
- **Versionado**: SemVer (major.minor.patch)

### Proceso de Pull Request

1. Crear rama desde `main`
2. Realizar cambios con commits descriptivos
3. Ejecutar `terraform fmt` y `terraform validate`
4. Crear PR con descripción clara
5. Revisión de código obligatoria

## 📚 Recursos Adicionales

- [Terraform Docs](https://www.terraform.io/docs)
- [AWS VPC User Guide](https://docs.aws.amazon.com/vpc/latest/userguide/)
- [Terraform Best Practices](https://www.terraform-best-practices.com/)
- [AWS Free Tier](https://aws.amazon.com/free/)

## 🐛 Solución de Problemas

### Errores Comunes

**Error: "Bucket ya existe"**
```bash
# Crear bucket con nombre único
aws s3 mb s3://mi-terraform-state-unique
```

**Error: "No se puede conectar SSH"**
```bash
# Verificar permisos de clave
chmod 400 ./provision/access/free-tier-ec2-key
```

**Error: "AMI no encontrada"**
```bash
# Actualizar AMI ID en variables
aws ec2 describe-images --owners amazon --filters "Name=name,Values=ubuntu-*
```

### Logs y Depuración

```bash
# Habilitar logs de Terraform
export TF_LOG=DEBUG

# Ver detalles de recursos
terraform show

# Plan detallado
terraform plan -detailed-exitcode
```

---

**Última Actualización**: 2025-11-14
**Versión**: 1.0.0
**Mantenido por**: Equipo DevOps