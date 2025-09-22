import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../../domain/domain.dart';
import '../providers/providers.dart';
import '../widgets/widgets.dart';

class ConsultarControlActividadesScreen extends ConsumerWidget {
  const ConsultarControlActividadesScreen({super.key});

  @override
  Widget build(BuildContext contextm, WidgetRef ref) {
     return Scaffold(
      appBar: AppBar(title: const Text('Consultar')),
      body: const _ConsultarControlActividadesView(),
    );
  }
}

class _ConsultarControlActividadesView extends ConsumerStatefulWidget {
  const _ConsultarControlActividadesView({super.key});

  
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ConsultarControlActividadesViewState();
  }

  // @override
  // State<_CerrarVueloView> createState() => _CerrarVueloViewState();
  
}



class _ConsultarControlActividadesViewState extends ConsumerState<_ConsultarControlActividadesView> {

  final introKey = GlobalKey<IntroductionScreenState>();
  
  Future<void> _onIntroEnd(BuildContext context) async {
    // print("onIntroEnd");
    Navigator.of(context).pop();
  }

//   Future<void> _onIntroEnd(BuildContext context) async {
//     print("onIntroEnd");

// final bool? result = await showConfirmationDialog(
//       context: context,
//       title: 'Cerrar Vuelo',
//       message: 'Esta seguro de cerrar el vuelo?',
//       // confirmText: 'Confirmar',
//       // confirmColor: Theme.of(context).colorScheme.primary,
//     );
    
//     if (result == true) {
//       // Perform delete action
//     final body = <String, Object?>{
//       'id_trc': ref.watch(selectedTurnaroundProvider)!.id,
//       'id_vuelo': ref.watch(selectedTurnaroundProvider)!.fkVuelo.id,
//       'comentario': ''
//     };
//     ref.read(turnaroundProvider.notifier).cerrarVuelo(body);
//     }
    

//     Widget buildImage(String assetName, [double width = 350]) {
//     return Image.asset('assets/$assetName', width: width);
//   }
//   }
  @override
  Widget build(BuildContext context) {

    // Variables
    final trcId = ref.watch(selectedTurnaroundProvider)!.id;
    final turnaround = ref.watch(selectedTurnaroundProvider)!;
    final ControlActividades? controlActividades = ref.watch(controlActividadesProvider(trcId)).controlActividades;
                                                  
    final List<Demora> demoras = ref.watch(demorasProvider).demoras;
        
    final  departamentosPersona = ref.watch(departamentoPersonalProvider(trcId));

    const bodyStyle = TextStyle(fontSize: 19.0);

    ThemeData theme = Theme.of(context);

    PageDecoration pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700, color: theme.colorScheme.primary),
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
          // PageViewModel(
          //   title: "1. Datos de Vuelo",
          //   bodyWidget: VueloDetalle( 
          //     controlActividades: controlActividades,
          //     turnaround: turnaround,),
          //   decoration: pageDecoration,
          // ),
          PageViewModel(
            title: "1. Control de Actividades",
             bodyWidget: ControlActividadesDetalle( 
              controlActividades: controlActividades,
              turnaround: turnaround,),
            decoration: pageDecoration,
          ),
          // PageViewModel(
          //   title: "3. SLA",
          //    bodyWidget: SlaDetalle( 
          //     controlActividades: controlActividades,
          //     turnaround: turnaround,),
          //   decoration: pageDecoration,
          // ),
          PageViewModel(
            title: "2. Servicios",
             bodyWidget: ServiciosDetalle( 
              controlActividades: controlActividades,
              turnaround: turnaround,),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "3. Codigos de Demora",
             bodyWidget: CodigosDemoraDetalle( 
              demoras: demoras,),
            decoration: pageDecoration,
          ),
          // PageViewModel(
          //   title: "6. Personal",
          //    bodyWidget: PersonalDetalle( 
          //     departamentosPersona: departamentosPersona.departamentoPersonalResponse,),
          //   decoration: pageDecoration,
          // ),
          
        ],
        onDone: () => _onIntroEnd(context),
        onSkip: () => _onIntroEnd(context), // You can override onSkip callback
        // showSkipButton: true,
        skipOrBackFlex: 0,
        nextFlex: 0,
        showBackButton: true,
        //rtl: true, // Display as right-to-left
        back: const Icon(Icons.arrow_back, size: 24),
        skip: const Text('Salir', style: TextStyle(fontWeight: FontWeight.w600)),
        next: const Icon(Icons.arrow_forward, size: 24),
        done: const Text('Salir', style: TextStyle(fontWeight: FontWeight.w600)),
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

