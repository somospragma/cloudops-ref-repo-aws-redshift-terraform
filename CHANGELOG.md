# Changelog

Todos los cambios notables en este proyecto serán documentados en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
y este proyecto adhiere a [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2023-11-30

### Añadido
- Implementación inicial del módulo para la creación de recursos Amazon Redshift
- Soporte para despliegues de tipo "provisioned" (clúster tradicional)
- Soporte para despliegues de tipo "serverless" (sin servidor)
- Configuración de red con subredes y grupos de seguridad
- Opciones de seguridad para cifrado y rotación de credenciales
- Integración con AWS Secrets Manager para almacenamiento de credenciales
- Configuración de logging y monitoreo
- Documentación completa y ejemplos de uso

### Cambiado
- N/A

### Eliminado
- N/A

### Corregido
- N/A

### Seguridad
- Implementación de cifrado por defecto para todos los despliegues
- Soporte para KMS personalizado
- Opción para almacenar credenciales en AWS Secrets Manager