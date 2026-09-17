import 'package:flutter/material.dart';
import 'package:scounter_mobile/config/config.dart';
import 'package:scounter_mobile/features/turnarounds/domain/domain.dart';

class VueloCompactCard extends StatelessWidget {
  final VueloLineup vuelo;

  const VueloCompactCard({super.key, required this.vuelo});

  Color _obtenerColorEstatus(String? colorString) {
    if (colorString == null) return const Color(0xFF0FA45F);
    
    switch (colorString.toLowerCase().trim()) {
      case 'verde':
        return const Color(0xFF0FA45F);
      case 'amarillo':
        return Colors.amber;
      case 'azul':
        return Colors.blue;
      case 'rojo':
        return Colors.red;
      case 'naranja':
        return Colors.orange;
      case 'gris':
        return Colors.grey.shade500;
      case 'blanco':
        return Colors.grey.shade300; 
      default:
        return const Color(0xFF0FA45F);
    }
  }

  String _formatearNombre(String? primerNombre, String? primerApellido) {
    final completo = '${primerNombre ?? ''} ${primerApellido ?? ''}'.trim().toLowerCase();
    if (completo.isEmpty) return '';
    
    return completo
        .split(' ')
        .where((str) => str.isNotEmpty)
        .map((str) => '${str[0].toUpperCase()}${str.substring(1)}')
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final maxCardWidth = MediaQuery.of(context).size.width * 0.43;
    const colorVerdeBase = Color(0xFF0FA45F);
    final colorEstatus = _obtenerColorEstatus(vuelo.estatusColor);

    final String baseUrl = Environment.apiUrl; 
    final String urlImagen = '$baseUrl/aerolineas${vuelo.imagen ?? ''}';

    final ordenDepartamentos = ['OPS', 'DES'];
    final personalMap = vuelo.personal;

    return Container(
      width: maxCardWidth,
      margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey.shade200, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        color: colorVerdeBase.withOpacity(0.03), 
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: colorEstatus, width: 4)),
            ),
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, 
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cabecera: Horas e Icono
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: (vuelo.imagen != null && vuelo.imagen!.isNotEmpty)
                          ? Image.network(
                              urlImagen,
                              width: 20,
                              height: 20,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.flight_takeoff, size: 16, color: colorVerdeBase);
                              },
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(strokeWidth: 1.5, color: colorVerdeBase),
                                );
                              },
                            )
                          : const Icon(Icons.flight_takeoff, size: 16, color: colorVerdeBase),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${vuelo.vueloHoraInicio ?? '--:--'} - ${vuelo.vueloHoraFin ?? '--:--'}',
                        style: TextStyle(
                          fontWeight: FontWeight.w900, 
                          fontSize: 15, 
                          color: Colors.blueGrey[800]
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 4),

                // Número de Vuelo
                Text(
                  vuelo.numeroVuelo ?? '',
                  style: TextStyle(
                    fontSize: 13, 
                    fontWeight: FontWeight.w800, 
                    color: Colors.grey.shade800
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: Divider(height: 1, thickness: 0.5, color: Color(0xFFE0E0E0)),
                ),
                
                // Despliegue de Personal con Jerarquía Distinguible
                if (personalMap == null || personalMap.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(
                      child: Text(
                        'Sin asignar',
                        style: TextStyle(fontSize: 11, color: Colors.grey, fontStyle: FontStyle.italic)
                      ),
                    ),
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: ordenDepartamentos.map((codigoArea) {
                      final areaData = personalMap[codigoArea];
                      if (areaData == null) return const SizedBox.shrink();

                      final rolesConfig = [
                        {
                          'titulo': 'Gerente',
                          'items': areaData.gerente,
                          // #d32f2f
                          'colorBadge': const Color.fromRGBO(211, 47, 47, 1), // Azul oscuro
                          'bgBadge': const Color(0xFFDBEAFE),
                        },
                        {
                          'titulo': 'Supervisor',
                          'items': areaData.supervisor,
                          // #ed6c02
                          'colorBadge': const Color.fromRGBO(237, 108, 2, 1), // Naranja
                          'bgBadge': const Color(0xFFFFEDD5),
                        },
                        {
                          'titulo': 'Personal',
                          'items': areaData.personal,
                          // primary
                          'colorBadge': Theme.of(context).colorScheme.primary,
                          'bgBadge': Colors.grey.shade200,
                        },
                      ];

                      final tienePersonal = rolesConfig.any((role) => (role['items'] as List).isNotEmpty);
                      if (!tienePersonal) return const SizedBox.shrink();

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Encabezado Departamento (OPS / DES)
                             Text(
                                codigoArea,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.grey.shade900,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            const SizedBox(height: 3),

                            // Recorrido por Cargos
                            ...rolesConfig.map((role) {
                              final String tituloCargo = role['titulo'] as String;
                              final List<PersonalItem> listaItems = role['items'] as List<PersonalItem>;
                              final Color colorBadge = role['colorBadge'] as Color;
                              final Color bgBadge = role['bgBadge'] as Color;

                              if (listaItems.isEmpty) return const SizedBox.shrink();

                              return Padding(
                                padding: const EdgeInsets.only(left: 4.0, top: 3.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Etiqueta del Cargo estilo pill/badge
                                    Text(
                                      tituloCargo,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                        color: colorBadge,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                    const SizedBox(height: 1),

                                    // Lista de Nombres bajo el Cargo
                                    ...listaItems.map((persona) {
                                      final nombreMostrar = persona.nombreCompleto ?? 
                                          _formatearNombre(persona.per1erNombre, persona.per1erApellido);

                                      return Padding(
                                        padding: const EdgeInsets.only(left: 6.0, top: 1.0),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 3,
                                              height: 3,
                                              decoration: BoxDecoration(
                                                color: colorBadge.withOpacity(0.7),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                nombreMostrar.isNotEmpty ? nombreMostrar : 'Sin nombre',
                                                style: TextStyle(
                                                  fontSize: 13, 
                                                  fontWeight: FontWeight.w500,
                                                  // fontWeight: tituloCargo == 'GERENTE' 
                                                  //     ? FontWeight.w700 
                                                  //     : (tituloCargo == 'SUPERVISOR' ? FontWeight.w600 : FontWeight.w400), 
                                                  color: Colors.black87,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}