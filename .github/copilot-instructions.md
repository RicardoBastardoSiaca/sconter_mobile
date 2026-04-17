# Instrucciones para GitHub Copilot

## Reglas de Estilo y Buenas Prácticas

- Usa siempre null safety.
- Para el manejo del estado, utiliza Riverpod.
- Sigue la estructura de archivos por características, no por tipo.
- Prefiere widgets stateless siempre que sea posible.

## Convenciones del Proyecto

- El naming de archivos debe ser en snake_case.
- Los nombres de las clases deben ir en UpperCamelCase.
- Todas las strings visibles para el usuario deben estar internacionalizadas.

## Patrones de Código a Seguir

- Para las llamadas a API, usa el patrón Repository.
- El manejo de errores debe hacerse con clases personalizadas.
<!-- - Logging con [logger de tu elección]. -->
