import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:scounter_mobile/features/shared/shared.dart';
import 'package:scounter_mobile/features/turnarounds/domain/domain.dart';
import 'package:scounter_mobile/features/turnarounds/presentation/providers/providers.dart';
import 'package:scounter_mobile/features/turnarounds/presentation/widgets/widgets.dart';


class CerrarVueloServicioMiscelaneoScreen extends StatelessWidget {
  const CerrarVueloServicioMiscelaneoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cerrar Vuelo')),
      body: const _CerrarVueloView(),
    );
  }
}

class _CerrarVueloView extends ConsumerStatefulWidget {
  const _CerrarVueloView();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _CerrarVueloViewState();
  }

  // @override
  // State<_CerrarVueloView> createState() => _CerrarVueloViewState();
}

class _CerrarVueloViewState extends ConsumerState<_CerrarVueloView> {
  final introKey = GlobalKey<IntroductionScreenState>();

  Future<bool> _onIntroEnd(BuildContext context) async {
    print("onIntroEnd");

    final bool? result = await showConfirmationDialogNoClose(
      context: context,
      title: 'Cerrar Vuelo',
      message: 'Esta seguro de cerrar el vuelo?',
      // confirmText: 'Confirmar',
      // confirmColor: Theme.of(context).colorScheme.primary,
    );

    if (result == true) {
      // Perform delete action
      final body = <String, Object?>{
        'id_trc': ref.watch(selectedTurnaroundProvider)!.id,
        'id_vuelo': ref.watch(selectedTurnaroundProvider)!.fkVuelo.id,
        'comentario': ref.read(comentarioProvider),
      };
      final response = await ref
          .read(turnaroundProvider.notifier)
          .cerrarVueloervicioMiscelaneo(body);
      // introductionscreen does not have context after await, prevent closing introduction screen
      // await snackbar to show message
      // if (context.mounted) {
      //   ScaffoldMessenger.of(
      //     context,
      //   ).showSnackBar(SnackBar(content: Center(child: Text(response.message, ))));//asdasd
      // }
      print(response);
      // Custom snackbar to show message
      if (response.success) {
        if (context.mounted) {
          CustomSnackbar.showSuccessSnackbar(response.message, context, );
          // get servicios miscelaneos again to refresh list
          ref
              .read(turnaroundProvider.notifier)
              .getServiciosMiscelaneos();
          Navigator.of(context).pop(); // Close the screen after successful closure

          
        }
      } else {
        if (context.mounted) {
          CustomSnackbar.showErrorSnackbar('Error: ${response.message}', context);
        }
      }

       return true;
    }
      return false;
  }

  @override
  Widget build(BuildContext context) {
    // Variables
    final trcId = ref.watch(selectedTurnaroundProvider)!.id;
    final turnaround = ref.watch(selectedTurnaroundProvider)!;
    // final comentario = ref.watch(comentarioProvider);

    final ControlActividades? controlActividades = ref
        .watch(controlActividadesProvider(trcId))
        .controlActividades;

    final List<Demora> demoras = ref.watch(demorasProvider).demoras;

    final departamentosPersona = ref.watch(departamentoPersonalProvider(trcId));

    const bodyStyle = TextStyle(fontSize: 19.0);

    ThemeData theme = Theme.of(context);

    PageDecoration pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.w700,
        color: theme.colorScheme.primary,
      ),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return SafeArea(
      child: IntroductionScreen(
        key: introKey,
        globalBackgroundColor: Colors.white,
        allowImplicitScrolling: true,
        autoScrollDuration: null,
        infiniteAutoScroll: false,
        globalHeader: Align(
          alignment: Alignment.topRight,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 16, right: 16),
              // child: _buildImage('flutter.png', 100),
            ),
          ),
        ),
        // globalFooter: SizedBox(
        //   width: double.infinity,
        //   height: 60,
        //   child: SafeArea(
        //     child: ElevatedButton(
        //       child: const Text(
        //         'Let\'s go right away!',
        //         style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        //       ),
        //       onPressed: () => _onIntroEnd(context),
        //     ),
        //   ),
        // ),
        pages: [
          // PageViewModel(
          //   title: "Full Screen Page",
          //   body:
          //       "Pages can be full screen as well.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc id euismod lectus, non tempor felis. Nam rutrum rhoncus est ac venenatis.",
          //   // backgroundImage: backgroundImage,
          //   decoration: pageDecoration.copyWith(
          //     contentMargin: const EdgeInsets.symmetric(horizontal: 16),
          //     bodyFlex: 2,
          //     imageFlex: 3,
          //     safeArea: 100,
          //   ),
          // ),
          PageViewModel(
            title: "1. Datos de Vuelo",
            bodyWidget: VueloDetalle(
              controlActividades: controlActividades,
              turnaround: turnaround,
              isTurnarond: false,
            ),
            decoration: pageDecoration,
          ),
          // PageViewModel(
          //   title: "2. Control de Actividades",
          //   bodyWidget: ControlActividadesDetalle(
          //     controlActividades: controlActividades,
          //     turnaround: turnaround,
          //   ),
          //   decoration: pageDecoration,
          // ),
          // PageViewModel(
          //   title: "3. SLA",
          //   bodyWidget: SlaDetalle(
          //     controlActividades: controlActividades,
          //     turnaround: turnaround,
          //   ),
          //   decoration: pageDecoration,
          // ),
          PageViewModel(
            title: "2. Servicios",
            bodyWidget: ServiciosDetalle(
              controlActividades: controlActividades,
              turnaround: turnaround,
            ),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "3. Codigos de Demora",
            bodyWidget: CodigosDemoraDetalle(demoras: demoras),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "4. Personal",
            bodyWidget: PersonalDetalle(
              departamentosPersona:
                  departamentosPersona.departamentoPersonalResponse,
            ),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "5. Comentarios",
            bodyWidget: ComentariosDetalle(),
            decoration: pageDecoration,
          ),


          // PageViewModel(
          //   title: "Learn as you go",
          //   body:
          //       "Download the Stockpile app and master the market with our mini-lesson.",
          //   // image: _buildImage('img2.jpg'),
          //   decoration: pageDecoration,
          // ),
          // PageViewModel(
          //   title: "Kids and teens",
          //   body:
          //       "Kids and teens can track their stocks 24/7 and place trades that you approve.",
          //   // image: _buildImage('img3.jpg'),
          //   decoration: pageDecoration,
          // ),

          // PageViewModel(
          //   title: "Another title page",
          //   body: "Another beautiful body text for this example onboarding",
          //   // image: _buildImage('img2.jpg'),
          //   footer: ElevatedButton(
          //     onPressed: () {
          //       introKey.currentState?.animateScroll(0);
          //     },
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: Colors.lightBlue,
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(8.0),
          //       ),
          //     ),
          //     child: const Text(
          //       'FooButton',
          //       style: TextStyle(color: Colors.white),
          //     ),
          //   ),
          //   decoration: pageDecoration.copyWith(
          //     bodyFlex: 6,
          //     imageFlex: 6,
          //     safeArea: 80,
          //   ),
          // ),
          // PageViewModel(
          //   title: "Title of last page - reversed",
          //   bodyWidget: const Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Text("Click on ", style: bodyStyle),
          //       Icon(Icons.edit),
          //       Text(" to edit a post", style: bodyStyle),
          //     ],
          //   ),
          //   decoration: pageDecoration.copyWith(
          //     bodyFlex: 2,
          //     imageFlex: 4,
          //     bodyAlignment: Alignment.bottomCenter,
          //     imageAlignment: Alignment.topCenter,
          //   ),
          //   // image: _buildImage('img1.jpg'),
          //   reverse: true,
          // ),
        ],
        onDone: () => _onIntroEnd(context),
        onSkip: () => _onIntroEnd(context), // You can override onSkip callback
        // onSkip: () async {
        //   final bool success = await _onIntroEnd(context);
        //   print('Success on skip: $success');
        //   if (success) {
        //     Navigator.of(context).pop();
        //   }
        // }, // You can override onSkip callback
        // showSkipButton: true,
        skipOrBackFlex: 0,
        nextFlex: 0,
        showBackButton: true,
        //rtl: true, // Display as right-to-left
        back: const Icon(Icons.arrow_back, size: 24),
        skip: const Text(
          'Salir',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        next: const Icon(Icons.arrow_forward, size: 24),
        done: const Text(
          'Cerrar',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        curve: Curves.fastLinearToSlowEaseIn,
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
    );
  }
}
