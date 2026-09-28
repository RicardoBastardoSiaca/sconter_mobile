import 'package:flutter/material.dart';
import '../../../domain/domain.dart';

class PersonalDetalle extends StatelessWidget {
  final DepartamentoPersonalResponse? departamentosPersona;
  
  const PersonalDetalle({
    super.key, 
    required this.departamentosPersona,
  });

  @override
  Widget build(BuildContext context) {
    return _PersonalDetalleView(departamentosPersona);
  }
}

class _PersonalDetalleView extends StatelessWidget {
  final DepartamentoPersonalResponse? departamentosPersona;
  
  const _PersonalDetalleView(this.departamentosPersona);

  @override
  Widget build(BuildContext context) {
    final areas = departamentosPersona?.areas ?? [];
    final theme = Theme.of(context);

    if (areas.isEmpty || _noHayPersonalAsignado(areas)) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person_off_outlined,
                size: 48,
                color: theme.colorScheme.outline,
              ),
              const SizedBox(height: 12),
              Text(
                'No hay personal asignado a este turnaround',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: areas.map((area) => _AreaConsultaCard(area: area)).toList(),
        ),
      ),
    );
  }

  bool _noHayPersonalAsignado(List<DepartamentoPersonal> areas) {
    return !areas.any((area) => area.personal.any((person) => person.selected));
  }
}

class _AreaConsultaCard extends StatelessWidget {
  final DepartamentoPersonal area;

  const _AreaConsultaCard({required this.area});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final personalAsignado = area.personal.where((p) => p.selected).toList();

    // Si un área no tiene personal seleccionado en la respuesta, omitimos renderizar la tarjeta
    if (personalAsignado.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header del Área
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    area.nombreDepartamento,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${personalAsignado.length}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),

            // Lista del personal asignado
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: personalAsignado.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final personal = personalAsignado[index];
                
                // Formateo de nombre completo (erNombre + erApellido con fallback a nombre)
                final nombreCompleto = '${personal.erNombre} ${personal.erApellido}'.trim();
                final displayName = nombreCompleto.isEmpty ? personal.nombre : nombreCompleto;

                return Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: theme.colorScheme.secondaryContainer,
                      child: Text(
                        displayName.isNotEmpty ? displayName[0].toUpperCase() : '?',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (personal.cargo.isNotEmpty)
                            Text(
                              personal.cargo,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey.shade600,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}