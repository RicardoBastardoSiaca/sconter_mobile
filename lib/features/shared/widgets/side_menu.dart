import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:scounter_mobile/features/shared/shared.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../config/config.dart';
import '../../auth/presentation/providers/auth_provider.dart';

class SideMenu extends ConsumerStatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const SideMenu({super.key, required this.scaffoldKey});

  @override
  SideMenuState createState() => SideMenuState();
}

class SideMenuState extends ConsumerState<SideMenu> {
  int navDrawerIndex = 0;

  @override
  Widget build(BuildContext context) {
    // final authResponse = ref.watch(authProvider);
    final theme = Theme.of(context);
    // final hasNotch = MediaQuery.of(context).viewPadding.top > 35;
    // final textStyles = Theme.of(context).textTheme;

    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            // Header with user info
            _buildHeader(context, ref),

            // Navigation items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.home,
                      color: Colors.black45,
                      size: 22,
                    ),
                    title: Text(
                      'Check-In',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.black87),
                    ),
                    onTap: () {
                      // Handle navigation to Home with GoRouter
                      context.go('/');
                      widget.scaffoldKey.currentState?.closeDrawer();
                    },
                  ),

                  // vuelos-calendario-screen
                  ListTile(
                    leading: const Icon(
                      Icons.calendar_month,
                      color: Colors.black45,
                      size: 22,
                    ),
                    title: Text(
                      'Calendario de Vuelos',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.black87),
                    ),
                    onTap: () {
                      // Handle navigation to Home with GoRouter
                      context.go('/vuelos-calendario-screen');
                      widget.scaffoldKey.currentState?.closeDrawer();
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.calendar_month,
                      color: Colors.black45,
                      size: 22,
                    ),
                    title: Text(
                      'Workload',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.black87),
                    ),
                    onTap: () {
                      // Handle navigation to Home with GoRouter
                      context.go('/vuelos-workload-screen');
                      widget.scaffoldKey.currentState?.closeDrawer();
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.group,
                      color: Colors.black45,
                      size: 22,
                    ),
                    title: Text(
                      'LineUp',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.black87),
                    ),
                    onTap: () {
                      // Handle navigation to Home with GoRouter
                      context.go('/vuelos-lineup-screen');
                      widget.scaffoldKey.currentState?.closeDrawer();
                    },
                  ),

                  // Servicios miscelaneos
                  // ListTile(
                  //   leading: const Icon(
                  //     Icons.miscellaneous_services,
                  //     color: Colors.black45,
                  //     size: 22,
                  //   ),
                  //   title: Text(
                  //     'Servicios Miscelaneos',
                  //     style: Theme.of(
                  //       context,
                  //     ).textTheme.bodySmall?.copyWith(color: Colors.black87),
                  //   ),
                  //   onTap: () {
                  //     // Handle navigation to Home with GoRouter
                  //     context.go('/servicios-miscelaneos-screen');
                  //     widget.scaffoldKey.currentState?.closeDrawer();
                  //   },
                  // ),

                  // ListTile(
                  //   leading: Icon(Icons.person, color: Colors.black45, size: 22),
                  //   title: Text(
                  //     'Perfil',
                  //     style: Theme.of(
                  //       context,
                  //     ).textTheme.bodySmall?.copyWith(color: Colors.black87),
                  //   ),
                  //   onTap: () {
                  //     // Handle navigation to Profile
                  //     // Navigator.of(context).pushNamed('/profile');
                  //   },
                  // ),
                ],
              ),
            ),

            // Sign out button at the bottom
            _buildSignOutButton(context, ref),
            // version
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text(
            //     'SiacaTRC v1.0.0',
            //     style: theme.textTheme.labelMedium?.copyWith(color: Colors.grey),
            //   ),
            // ),

            // Pie de página con indicador de versión / actualización
            Consumer(
              builder: (context, ref, child) {
                final updateState = ref.watch(appUpdateProvider);

                if (updateState.hasUpdate) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: 12.0,
                      left: 16.0,
                      right: 16.0,
                    ),
                    child: InkWell(
                      onTap: () {
                        widget.scaffoldKey.currentState?.closeDrawer();
                        showDialog(
                          context: context,
                          barrierDismissible: !updateState.isMandatory,
                          builder: (context) =>
                              UpdateDialog(updateData: updateState.toMap()),
                        );
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0FA45F).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF0FA45F)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.system_update_alt,
                              color: Color(0xFF0FA45F),
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Actualización v${updateState.versionName ?? ''}',
                                    style: const TextStyle(
                                      color: Color(0xFF0FA45F),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const Text(
                                    'Toca para instalar',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                // Si no hay actualización, se mantiene el texto informativo habitual
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final packageInfo = snapshot.data!;
                        return Text(
                          'Scounter v${packageInfo.version}',
                          // 'App Version: ${packageInfo.version} (${packageInfo.buildNumber})',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.grey,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error loading app info');
                      }
                      return CircularProgressIndicator(); // Show a loading indicator
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
    // return NavigationDrawer(
    //   elevation: 1,
    //   selectedIndex: navDrawerIndex,
    //   onDestinationSelected: (value) {
    //     setState(() {
    //       navDrawerIndex = value;
    //     });

    //     // final menuItem = appMenuItems[value];
    //     // context.push( menuItem.link );
    //     widget.scaffoldKey.currentState?.closeDrawer();
    //   },
    //   children: [
    //     // Header with user info
    //     _buildHeader(context, ref),

    //     // Navigation items
    //     // _buildNavigationItems(),
    //     Column(
    //       // take all vertical space
    //       mainAxisSize: MainAxisSize.max,
    //       children: [
    //         ListTile(
    //           leading: const Icon(Icons.home, color: Colors.black45, size: 22),
    //           title: Text(
    //             'Turnarounds',
    //             style: Theme.of(
    //               context,
    //             ).textTheme.bodySmall?.copyWith(color: Colors.black87),
    //           ),
    //           onTap: () {
    //             // Handle navigation to Home
    //           },
    //         ),
    //         ListTile(
    //           leading: Icon(Icons.person, color: Colors.black45, size: 22),
    //           title: Text(
    //             'Perfil',
    //             style: Theme.of(
    //               context,
    //             ).textTheme.bodySmall?.copyWith(color: Colors.black87),
    //           ),
    //           onTap: () {
    //             // Handle navigation to Profile
    //           },
    //         ),
    //       ],
    //     ),

    //     // vertical spacer that takes all available space
    //     const SizedBox(height: 16),
    //     // const Divider(),

    //     // Sign out button at the bottom
    //     _buildSignOutButton(context),
    //     // Padding(
    //     //   padding: const EdgeInsets.symmetric(horizontal: 20),
    //     //   child: CustomFilledButton(
    //     //     onPressed: () {
    //     //       _showSignOutDialog(context);
    //     //     },
    //     //     text: 'Cerrar sesión',
    //     //   ),
    //     // ),
    //     // Padding(
    //     //   padding: const EdgeInsets.symmetric(horizontal: 20),
    //     //   child: CustomFilledButton(
    //     //     onPressed: () {
    //     //       _showSignOutDialog(context);
    //     //     },
    //     //     text: 'Cerrar sesión',
    //     //   ),
    //     // ),

    //     // DrawerHeader(
    //     //   decoration: BoxDecoration(color: Colors.grey.shade200),
    //     //   child: Column(
    //     //     crossAxisAlignment: CrossAxisAlignment.start,
    //     //     children: [
    //     //       Text('Turnaround App', style: textStyles.titleLarge),
    //     //       SizedBox(height: 4),
    //     //       Text(
    //     //         'Bienvenido a la app de turnos',
    //     //         style: textStyles.bodySmall,
    //     //       ),
    //     //     ],
    //     //   ),
    //     // ),

    //     // Padding(
    //     //   padding: EdgeInsets.fromLTRB(20, hasNotch ? 0 : 20, 16, 0),
    //     //   child: Text('Saludos', style: textStyles.titleMedium),
    //     // ),

    //     // Padding(
    //     //   padding: const EdgeInsets.fromLTRB(20, 0, 16, 10),
    //     //   child: Text('Tony Stark', style: textStyles.titleSmall),
    //     // ),

    //     // const NavigationDrawerDestination(
    //     //   icon: Icon(Icons.home_outlined),
    //     //   label: Text('Productos'),
    //     // ),

    //     // const Padding(
    //     //   padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
    //     //   child: Divider(),
    //     // ),

    //     // const Padding(
    //     //   padding: EdgeInsets.fromLTRB(28, 10, 16, 10),
    //     //   child: Text('Otras opciones'),
    //     // ),

    //     // Padding(
    //     //   padding: const EdgeInsets.symmetric(horizontal: 20),
    //     //   child: CustomFilledButton(
    //     //     onPressed: () {
    //     //       ref.read(authProvider.notifier).logout();
    //     //     },
    //     //     text: 'Cerrar sesión',
    //     //   ),
    //     // ),
    //   ],
    // );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Sign Out"),
          content: const Text("Are you sure you want to sign out?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(authProvider.notifier).logout();
              },
              child: const Text("Sign Out"),
            ),
          ],
        );
      },
    );
  }
}

// _buildNavigationItems() {
//   return ListView(
//     padding: EdgeInsets.zero,
//     children: [
//       ListTile(
//         leading: const Icon(Icons.home_outlined),
//         title: const Text('Home'),
//         onTap: () {
//           // Handle navigation to Home
//         },
//       ),
//       ListTile(
//         leading: const Icon(Icons.person_outline),
//         title: const Text('Profile'),
//         onTap: () {
//           // Handle navigation to Profile
//         },
//       ),
//       ListTile(
//         leading: const Icon(Icons.settings_outlined),
//         title: const Text('Settings'),
//         onTap: () {
//           // Handle navigation to Settings
//         },
//       ),
//       ListTile(
//         leading: const Icon(Icons.info_outline),
//         title: const Text('About'),
//         onTap: () {
//           // Handle navigation to About
//         },
//       ),
//     ],
//   );
// }

Widget _buildHeader(BuildContext context, WidgetRef ref) {
  final user = ref.watch(authProvider).loginResponse;
  final env = Environment.apiUrl;
  return UserAccountsDrawerHeader(
    // center
    margin: EdgeInsets.zero,
    currentAccountPictureSize: Size(65, 65),

    // decoration: BoxDecoration(
    //   // color: Theme.of(context).primaryColor,
    //   color: Colors.grey.shade200,
    // ),
    accountName: Text(
      user?.name ?? "",
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
    ),
    accountEmail: Text(
      user?.username ?? "unknown@example.com",
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: 18),
    ),
    currentAccountPicture: CircleAvatar(
      backgroundColor: Colors.white,
      child: ClipOval(
        child: user?.imagen == null || user?.imagen == ""
            ? Image.asset(
                'assets/images/no-user-image.png',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              )
            // ?  Image.network(
            //   "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face",
            //   width: 100,
            //   height: 100,
            //   fit: BoxFit.cover,
            // )
            // '$env/usuarios/media/${user!.imagen}'
            : Image.network(
                "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face",
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
      ),
    ),
    decoration: BoxDecoration(
      // color: Theme.of(context).primaryColor,
      color: Color.fromRGBO(0, 166, 91, 1),
      // color: Color.fromRGBO(196, 196, 196, 1),
      // image: DecorationImage(
      //   image: AssetImage('assets/images/mapa-mundi-bg.png'),
      //   fit: BoxFit.cover,
      //   colorFilter: ColorFilter.mode(
      //     Colors.black.withOpacity(0.2),
      //     BlendMode.darken,
      //   ),
      // ),

      // image: DecorationImage(
      //    SvgPicture.asset(
      //   'assets/icons/mapa-mundi-bg.svg',
      //   alignment: Alignment.bottomCenter,
      //   width: MediaQuery.sizeOf(context).width,
      //   height: MediaQuery.sizeOf(context).height,
      // ),

      // image: NetworkImage(
      //   // "https://torontotouchfootball.com/wp-content/uploads/2017/02/grey-metal-sheet-texture-background-header.jpg",
      //   // "https://static.vecteezy.com/system/resources/thumbnails/006/304/593/small/abstract-white-and-light-grey-geometric-square-overlapped-pattern-on-background-with-shadow-modern-silver-color-cube-shape-with-copy-space-simple-and-minimal-banner-design-eps10-vector.jpg",
      //   "https://img.freepik.com/free-vector/smooth-neumorphic-backdrop-banner-beautiful-presentation_1017-43122.jpg?semt=ais_hybrid&w=740&q=80",
      // ),
      // fit: BoxFit.cover,
      // colorFilter: ColorFilter.mode(
      //   Colors.black.withOpacity(0.2),
      //   BlendMode.darken,
      // ),
    ),
    // ),
  );
}

Widget _buildSignOutButton(BuildContext context, WidgetRef ref) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.logout, size: 20),
        label: const Text("Cerrar sesión", style: TextStyle(fontSize: 20)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: () {
          // _showSignOutDialog(context);
          CustomDialog.showConfirmationDialog(
            context,
            "Cerrar sesión",
            "¿Estás seguro de que deseas cerrar sesión?",
            "Cerrar",
          ).then((value) async {
            if (value == true) {
              // Add your sign out logic here
              await ref.read(authProvider.notifier).logout();

              CustomSnackbar.showSuccessSnackbar(
                "Has cerrado sesión",
                context,
                isFixed: true,
              );
            }
          });
        },
      ),
    ),
  );
}

void _showSignOutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Sign Out"),
        content: const Text("Are you sure you want to sign out?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Add your sign out logic here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Signed out successfully")),
              );
            },
            child: const Text("Sign Out", style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}
