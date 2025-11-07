import 'package:flutter/material.dart';
import 'package:turnaround_mobile/features/turnarounds/domain/domain.dart';

class VueloDetalle extends StatelessWidget {
  final ControlActividades? controlActividades;
  final TurnaroundMain? turnaround;

  const VueloDetalle({super.key, this.controlActividades, this.turnaround});

  @override
  Widget build(BuildContext context) {
    // final vueloLlegada = controlActividades!.;
    return SingleChildScrollView(
      // padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MutualInfoSection(
            aerolinea: turnaround?.fkVuelo.fkAerolinea.aka ?? '',
            icaoHex: controlActividades?.icaoHex ?? '',
            acReg: controlActividades?.acReg ?? '',
            acType: turnaround?.fkVuelo.acType ?? '',
            puerta: turnaround?.fkVuelo.gate?.toString() ?? '',
            tipoVuelo: turnaround!.fkVuelo.tipoVuelo.nombre,
            tipoServicio: turnaround!.fkVuelo.tipoServicio.nombre,
          ),
          turnaround?.fkVuelo.lugarSalida == null 
              ? SizedBox.shrink()
              :
          SizedBox(height: 24),
          turnaround?.fkVuelo.lugarSalida == null 
              ? SizedBox.shrink()
              :
          FlightInfoCard(
            titulo: 'Vuelo de llegada',
            flightNumber: '${turnaround?.fkVuelo.fkAerolinea.codigoIata}-${controlActividades?.numeroVueloIn}' ?? '',
            routing: '${controlActividades?.lugarSalidaIata}-${turnaround?.fkVuelo.stn?.codigoIata} ' ?? '',
            etd: '${turnaround?.fkVuelo.etdIn?.substring(0, 5)}' ?? '',
            eta: '${turnaround?.fkVuelo.etaIn?.substring(0, 5)}' ?? '',
            // fecha: '${turnaround?.fechaInicio}' ?? '',
            fecha: (turnaround?.fkVuelo.etaFechaIn == null)
                ? ''
                : DateTimeInputFormatter.displayFormat.format(
                    DateTimeInputFormatter.parseStringToDate(turnaround!.fkVuelo.etaFechaIn ?? '') ?? DateTime.now()),

            // fecha: DateTimeInputFormatter.displayFormat.format(DateTime(DateTimeInputFormatter.parseStringToDate turnaround?.fechaInicio)),
          ),
          turnaround?.fkVuelo.lugarDestino == null 
              ? SizedBox.shrink()
              :
          SizedBox(height: 16),
          turnaround?.fkVuelo.lugarDestino == null 
              ? SizedBox.shrink()
              :
          FlightInfoCard(
            titulo: 'Vuelo de salida',
            flightNumber: '${turnaround?.fkVuelo.fkAerolinea.codigoIata}-${controlActividades?.numeroVueloOut}' ?? '',
            routing: '${turnaround?.fkVuelo.stn?.codigoIata}-${controlActividades?.lugarDestinoIata}' ?? '',
            etd: '${turnaround?.fkVuelo.etdOut?.substring(0, 5)}' ?? '',
            eta: '${turnaround?.fkVuelo.etaOut?.substring(0, 5)}' ?? '',
            fecha: (turnaround?.fkVuelo.etdFechaOut == null)
                ? ''
                : DateTimeInputFormatter.displayFormat.format(
                    DateTimeInputFormatter.parseStringToDate(turnaround!.fkVuelo.etdFechaOut ?? '') ?? DateTime.now()),
          ),
        ],
      ),
    );
  }
}

class MutualInfoSection extends StatelessWidget {
  final String aerolinea;
  final String icaoHex;
  final String acReg;
  final String acType;
  final String puerta;
  final String tipoVuelo;
  final String tipoServicio;

  const MutualInfoSection({
    super.key,
    required this.aerolinea,
    required this.icaoHex,
    required this.acReg,
    required this.acType,
    required this.puerta,
    required this.tipoVuelo,
    required this.tipoServicio,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoRow(
              icon: Icons.airlines_rounded,
              label: 'Aerolinea:',
              value: aerolinea,
            ),
            InfoRow(
              icon: Icons.confirmation_number,
              label: 'A/C Reg:',
              value: acReg,
            ),
            InfoRow(
              icon: Icons.airplanemode_active,
              label: 'A/C Type:',
              value: acType,
            ),
            InfoRow(icon: Icons.meeting_room, label: 'Puerta:', value: puerta),
            InfoRow(
              icon: Icons.airplane_ticket,
              label: 'Tipo de vuelo:',
              value: tipoVuelo,
            ),
            InfoRow(
              icon: Icons.airline_stops_rounded,
              label: 'Tipo de servicio:',
              value: tipoServicio,
            ),
          ],
        ),
      ),
    );
  }
}

class FlightInfoCard extends StatelessWidget {
  final String flightNumber;
  final String routing;
  final String etd;
  final String eta;
  final String? fecha;
  final String titulo;

  const FlightInfoCard({
    super.key,
    required this.flightNumber,
    required this.routing,
    required this.etd,
    required this.eta,
    required this.fecha, required this.titulo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                  ),
                ),
               
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            InfoRow(icon: Icons.numbers, label: 'Nro. de vuelo:', value: flightNumber),
            InfoRow(icon: Icons.route, label: 'Routing:', value: routing),
            InfoRow(icon: Icons.schedule, label: 'ETD:', value: etd),
            InfoRow(icon: Icons.timelapse, label: 'ETA:', value: eta),
            InfoRow(icon: Icons.calendar_today, label: 'Fecha:', value: fecha ?? ''),
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
                fontSize: 20,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
