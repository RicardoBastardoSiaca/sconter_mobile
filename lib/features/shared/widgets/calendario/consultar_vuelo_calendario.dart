import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:scounter_mobile/features/turnarounds/domain/domain.dart';
import 'package:scounter_mobile/features/turnarounds/presentation/providers/providers.dart';
import 'package:scounter_mobile/features/turnarounds/presentation/widgets/widgets.dart';

class ConsultarVueloCalendario extends ConsumerStatefulWidget {
  final VueloCalendario vuelo;

  const ConsultarVueloCalendario({
    super.key,
    required this.vuelo,
  });

  @override
  ConsumerState<ConsultarVueloCalendario> createState() =>
      _ConsultarVueloCalendarioState();
}

class _ConsultarVueloCalendarioState
    extends ConsumerState<ConsultarVueloCalendario> {
  final introKey = GlobalKey<IntroductionScreenState>();

  @override
  Widget build(BuildContext context) {
    // Tomamos el ID del turnaround asignado al vuelo seleccionado
    final trcId = widget.vuelo.id ?? 0;

    // Leemos los providers con la información de actividades y personal
    final controlActividades = trcId != 0
        ? ref.watch(controlActividadesProvider(trcId)).controlActividades
        : null;

    final departamentosPersona = trcId != 0
        ? ref.watch(departamentoPersonalProvider(trcId))
        : null;

    final theme = Theme.of(context);

    final pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.w700,
        color: theme.colorScheme.primary,
      ),
      bodyTextStyle: const TextStyle(fontSize: 16.0),
      bodyPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Vuelo ${widget.vuelo.numeroVuelo ?? ''}'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: IntroductionScreen(
          key: introKey,
          globalBackgroundColor: Colors.white,
          allowImplicitScrolling: true,
          pages: [
            // 1. Datos de Vuelo
            PageViewModel(
              title: "1. Datos de Vuelo",
              bodyWidget: VueloDetalle(
                controlActividades: controlActividades,
                turnaround: null, // Si posees entidad Turnaround la pasas aquí
                isTurnarond: false,
              ),
              decoration: pageDecoration,
            ),
            // 2. Control de Actividades
            PageViewModel(
              title: "2. Control de Actividades",
              bodyWidget: ControlActividadesDetalle(
                controlActividades: controlActividades,
                turnaround: null,
              ),
              decoration: pageDecoration,
            ),
            // 3. Personal Asignado
            PageViewModel(
              title: "3. Personal",
              bodyWidget: PersonalDetalle(
                departamentosPersona:
                    departamentosPersona?.departamentoPersonalResponse,
              ),
              decoration: pageDecoration,
            ),
          ],
          showBackButton: true,
          back: const Icon(Icons.arrow_back, size: 24),
          next: const Icon(Icons.arrow_forward, size: 24),
          done: const Text(
            'Entendido',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          onDone: () => Navigator.of(context).pop(),
          controlsMargin: const EdgeInsets.all(16),
          controlsPadding: kIsWeb
              ? const EdgeInsets.all(8.0)
              : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
          dotsDecorator: const DotsDecorator(
            size: Size(10.0, 10.0),
            color: Color(0xFFBDBDBD),
            activeSize: Size(22.0, 10.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
          ),
          dotsContainerDecorator: ShapeDecoration(
            color: Colors.grey[100],
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
          ),
        ),
      ),
    );
  }
}