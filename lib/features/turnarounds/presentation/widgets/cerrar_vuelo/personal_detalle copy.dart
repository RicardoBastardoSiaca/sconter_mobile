import 'package:flutter/material.dart';

import '../../../domain/domain.dart';

class PersonalDetalle extends StatelessWidget {
  final DepartamentoPersonalResponse? departamentosPersona;
  const PersonalDetalle({super.key, required this.departamentosPersona});

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
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gerentes
            _GerenciasPersonalView(
              nommbre: 'Gerentes',
              departamentos: departamentosPersona?.gerenteTurno ?? [],
            ),
            // Supervisores
            _GerenciasPersonalView(
              nommbre: 'Supervisores',
              departamentos: departamentosPersona?.supervisor ?? [],
            ),
            // Personal
            _GerenciasPersonalView(
              nommbre: 'Personal',
              departamentos: departamentosPersona?.departamentosPersonal ?? [],
            ),
            // _PersonalView(departamentosPersona: departamentosPersona)
          ],
        ),
      ),
    );
  }
}

class _GerenciasPersonalView extends StatelessWidget {
  final String nommbre;
  final List<DepartamentoPersonal> departamentos;
  const _GerenciasPersonalView({
    required this.nommbre,
    required this.departamentos,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            nommbre,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        departamentos.isEmpty || noPersonalInDepartamento(departamentos)
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child: Text(
                    'No hay personal asignado',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              )
            : Column(
                children: [
                  ...departamentos.map((e) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text(
                          e.nombreDepartamento,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        e.personal.isEmpty
                            ? Text(
                                'No hay personal asignado',
                                style: theme.textTheme.bodyMedium,
                              )
                            // Lista de personal seleccionado
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: e.personal
                                    .where((e) => e.selected)
                                    .map(
                                      (e) => Text(
                                        '- ${e.nombre.toString()}',
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                    )
                                    .toList(),
                              ),
                        // ...e.personal.where((e) => e.selected).map((e) => Text(e.nombre.toString())),
                      ],
                    );
                  }),
                ],
              ),
      ],
    );
  }
}

// check if
bool noPersonalInDepartamento(List<DepartamentoPersonal> departamento) {
  for (var dept in departamento) {
    if (dept.personal.any((person) => person.selected)) {
      return false;
    }
  }
  return true;
}
