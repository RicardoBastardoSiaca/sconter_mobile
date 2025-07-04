import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../shared/shared.dart';
import '../providers/providers.dart';

class ControlActividadesScreen extends ConsumerWidget {
  final int trcId;
  const ControlActividadesScreen({super.key, required this.trcId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Color
    final Color primaryColor = Theme.of(context).colorScheme.primary;

    // Control de actividades state
    final controlActividadesState = ref.watch(
      controlActividadesProvider(trcId),
    );
    var controlActividades = controlActividadesState.controlActividades;

    return DefaultTabController(
      length: controlActividades?.departamentos?.length ?? 0,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: Colors.white,
                // elevation: 0,
                title: Center(
                  child: SvgPicture.asset(
                    "assets/icons/logo-trc.svg",
                    fit: BoxFit.scaleDown,
                    height: 35,
                  ),
                ),

                pinned: true,
                floating: true,
                bottom: TabBar(
                  labelColor: Colors.white,
                  dividerColor: Colors.transparent,
                  // indicatorColor: Colors.transparent,
                  isScrollable: true,
                  unselectedLabelColor: primaryColor,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryColor, primaryColor],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    color: primaryColor,
                  ),

                  // Map
                  tabs:
                      controlActividades?.departamentos
                          ?.map(
                            (dep) =>
                                _customTabBarHeaderItem(title: dep.nombreArea),
                          )
                          .toList() ??
                      [],
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_sharp),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.manage_accounts),
                    onPressed: () {},
                  ),
                ],
              ),
            ];
          },
          body: TabBarView(
            physics: const BouncingScrollPhysics(),
            children:
                controlActividades?.departamentos?.map((dep) {
                  return _ControlActividadesMainView(trcId: trcId);
                }).toList() ??
                [],
            // children: <Widget>[
            //   Icon(Icons.flight, size: 350),
            //   Icon(Icons.directions_transit, size: 350),
            //   Icon(Icons.flight, size: 350),
            // ],
          ),
        ),
      ),
    );
  }
}

class _customTabBarHeaderItem extends StatelessWidget {
  final String title;
  const _customTabBarHeaderItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Text(
        title,
        style: GoogleFonts.openSans().copyWith(fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _ControlActividadesMainView extends ConsumerWidget {
  final int trcId;
  const _ControlActividadesMainView({super.key, required this.trcId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ControlActividadesState controlActividadesState = ref.read(
      controlActividadesProvider(trcId),
    );

    return Stack(
      children: [
        // Background image
        BackgroundImg(),
        // Main content
        SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Control de Actividades',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontFamily: GoogleFonts.openSans(
                        fontWeight: FontWeight.w700,
                      ).fontFamily,
                    ),
                  ),
                ),

                // const SizedBox(height: 20),
                // const _ControlActividadesHeader(),
                // const SizedBox(height: 20),
                // const _ControlActividadesSearchBar(),
                // const SizedBox(height: 20),
                // controlActividadesState.when(
                //   data: (data) => ControlActividadesListView(
                //     controlActividades: data,
                //   ),
                //   error: (error, stackTrace) => Center(
                //     child: Text('Error: $error'),
                //   ),
                //   loading: () => const Center(child: CircularProgressIndicator()),
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ****************************************************************************************************************************************
// ****************************************************************************************************************************************
// ****************************************************************************************************************************************
// ****************************************************************************************************************************************


// class ControlActividadesScreen extends ConsumerWidget {
//   final int trcId;
//   const ControlActividadesScreen({super.key, required this.trcId});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // final theme = Theme.of(context);

//     final scaffoldKey = GlobalKey<ScaffoldState>();

//     return Scaffold(
//       // backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
//       drawer: SideMenu(scaffoldKey: scaffoldKey),
//       appBar: AppBar(
//         leading: IconButton(
//           // Back button
//           icon: const Icon(Icons.arrow_back_sharp),
//           onPressed: () => Navigator.of(context).pop(),
//           // icon: const Icon(Icons.more_vert),
//           // onPressed: () => scaffoldKey.currentState?.openDrawer(),
//         ),
//         // title: const Text('Turnaround 2'),
//         title: Center(
//           child: SvgPicture.asset(
//             "assets/icons/logo-trc.svg",
//             fit: BoxFit.scaleDown,
//             height: 35,
//           ),
//         ),
//         // user icon menu
//         actions: [
//           IconButton(onPressed: () {}, icon: const Icon(Icons.manage_accounts)),
//         ],
//       ),
//       body: _ControlActividadesMainView(trcId: trcId),

//       // bottomNavigationBar: const _CustomBottomNavigationBar(),
//     );
//   }
// }

// class _ControlActividadesMainView extends ConsumerWidget {
//   final int trcId;
//   const _ControlActividadesMainView({super.key, required this.trcId});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final ControlActividadesState controlActividadesState = ref.read(
//       controlActividadesProvider(trcId),
//     );

//     return Stack(
//       children: [
//         // Background image
//         BackgroundImg(),
//         // Main content
//         SafeArea(
//           child: SingleChildScrollView(
//             physics: BouncingScrollPhysics(),
//             child: Column(
//               children: [
//                 const SizedBox(height: 8),
//                 Center(
//                   child: Text(
//                     'Control de Actividades',
//                     style: Theme.of(context).textTheme.headlineLarge?.copyWith(
//                       color: Theme.of(context).colorScheme.primary,
//                       fontFamily: GoogleFonts.openSans(
//                         fontWeight: FontWeight.w700,
//                       ).fontFamily,
//                     ),
//                   ),
//                 ),
                
//                 // const SizedBox(height: 20),
//                 // const _ControlActividadesHeader(),
//                 // const SizedBox(height: 20),
//                 // const _ControlActividadesSearchBar(),
//                 // const SizedBox(height: 20),
//                 // controlActividadesState.when(
//                 //   data: (data) => ControlActividadesListView(
//                 //     controlActividades: data,
//                 //   ),
//                 //   error: (error, stackTrace) => Center(
//                 //     child: Text('Error: $error'),
//                 //   ),
//                 //   loading: () => const Center(child: CircularProgressIndicator()),
//                 // ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }





// ****************************************************************************************************************************************
// ****************************************************************************************************************************************
// ****************************************************************************************************************************************
// ****************************************************************************************************************************************














































// class _ControlActividadesMainView extends ConsumerStatefulWidget {
//   final int trcId;
//   const _ControlActividadesMainView({required this.trcId});

//   @override
//   _ControlActividadesMainViewState createState() =>
//       _ControlActividadesMainViewState();
// }

// class _ControlActividadesMainViewState extends ConsumerState {
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();

//     ref
//         .read(controlActividadesProvider(trcId).notifier)
//         .getControlDeActividadesByTrcId();

//     // ref
//     // .read(controlActividadesProvider(widget.trcId).notifier);
//     // .getControlDeActividadesByTrcId();
//     // _scrollController.addListener(_scrollListener);
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final controlActividadesState = ref.watch(controlActividadesProvider(widget.trcId));
//      final ControlActividadesState controlActividadesState = ref.read(
//       controlActividadesProvider(trcId),
//     );

//     return Center();
//   }
// }
