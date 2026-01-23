import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:share_plus/share_plus.dart';
import 'package:turnaround_mobile/config/constants/environment.dart';

import 'package:http/http.dart' as http;
import 'dart:io';
import '../../../shared/shared.dart';
import '../../domain/domain.dart';
import '../providers/providers.dart';

class ImageFullscreenCarousel extends ConsumerWidget {
  // final List<Imagen> imagenes;
  // final int indexStart;
  const ImageFullscreenCarousel({
    super.key,
    // required this.imagenes,
    // required this.indexStart,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CustomFullscreenCarouselData imagesList = ref.watch(
      imagesListProvider,
    );
    final List<Imagen> imagenes = imagesList.imagenes;
    // final List<String> images =
    //     imagenes.map((imagen) => '${Environment.apiUrl}/images/${imagen.imagen}').toList();
    final List<String> images = imagenes
        .map(
          (imagen) => '${Environment.apiUrl}/aerolineas/media/${imagen.imagen}',
        )
        .toList();
    final int indexStart =
        imagesList.index; // Set your desired initial index here
    final int trcId = ref.watch(
      trcIdProvider,
    ); // Get the trcId from the provider

    // sharedMessage
    final String sharedMessage = imagesList.shareMessage;

    return FullScreenGalleryWithControls(
      imagenes: imagenes,
      initialIndex: indexStart,
      images: images,
      sharedMessage: sharedMessage,
    );

    //     return Scaffold(
    //       // Botón para cerrar en la parte superior
    //       appBar: AppBar(
    //         backgroundColor: Colors.black,
    //         iconTheme: IconThemeData(color: Colors.white),
    //       ),
    //       backgroundColor: Colors.black,
    //       body:
    //       Stack(
    //         children: [
    //           PhotoViewGallery.builder(
    //             itemCount: images.length,
    //             builder: (context, index) {
    //               return PhotoViewGalleryPageOptions(
    //                 imageProvider: NetworkImage(images[index]),
    //                 // Escala inicial: que la imagen quepa en la pantalla
    //                 initialScale: PhotoViewComputedScale.contained,
    //                 // Escala mínima y máxima permitida
    //                 minScale: PhotoViewComputedScale.contained,
    //                 maxScale: PhotoViewComputedScale.covered * 3,
    //               );
    //             },
    //             // Esto permite que la galería empiece en la imagen seleccionada
    //             pageController: PageController(initialPage: indexStart),
    //             scrollPhysics: BouncingScrollPhysics(),
    //             backgroundDecoration: BoxDecoration(color: Colors.black),
    //             onPageChanged: (index) {
    //               setState(() {
    //                 _currentIndex = index;
    //               });
    //             },
    //           ),

    //           SafeArea(
    //             child: Container(
    //               padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
    //               // Agregamos un degradado sutil para que los iconos blancos se vean
    //               // incluso si la foto de fondo es blanca.
    //               decoration: BoxDecoration(
    //                 gradient: LinearGradient(
    //                   begin: Alignment.topCenter,
    //                   end: Alignment.bottomCenter,
    //                   colors: [Colors.black.withOpacity(0.6), Colors.transparent],
    //                   stops: [0.0, 1.0]
    //                 ),
    //               ),
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   // Botón de atrás
    //                   IconButton(
    //                     icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
    //                     onPressed: () => Navigator.pop(context),
    //                   ),
    //                   // Lado derecho: Iconos de acción
    //                   Row(
    //                     children: [
    //                        // Indicador de página (opcional)
    //                        Text(
    //                         "${_currentIndex + 1}/${images.length}  ",
    //                         style: const TextStyle(color: Colors.white70),
    //                       ),
    //                       // Botón Compartir
    //                       IconButton(
    //                         icon: const Icon(Icons.share, color: Colors.white),
    //                         onPressed: _shareCurrentPhoto,
    //                         tooltip: 'Compartir',
    //                       ),
    //                       // Botón Borrar
    //                       IconButton(
    //                         icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
    //                         onPressed: () {
    //                            // Diálogo de confirmación antes de borrar
    //                            showDialog(context: context, builder: (ctx) => AlertDialog(
    //                              title: Text("¿Borrar imagen?"),
    //                              actions: [
    //                                TextButton(onPressed: ()=> Navigator.pop(ctx), child: Text("Cancelar")),
    //                                TextButton(onPressed: () {
    //                                  Navigator.pop(ctx); // Cerrar diálogo
    //                                  _deleteCurrentPhoto(); // Borrar foto
    //                                }, child: Text("Borrar", style: TextStyle(color: Colors.red),)),
    //                              ],
    //                            ));
    //                         },
    //                          tooltip: 'Borrar',
    //                       ),
    //                        // Ejemplo de un menú desplegable (tres puntos) si quieres más opciones
    //                        PopupMenuButton<String>(
    //                         icon: Icon(Icons.more_vert, color: Colors.white),
    //                         onSelected: (value) {
    //                           print("Seleccionaste: $value");
    //                         },
    //                         itemBuilder: (BuildContext context) {
    //                           return {'Descargar', 'Establecer como fondo'}.map((String choice) {
    //                             return PopupMenuItem<String>(
    //                               value: choice,
    //                               child: Text(choice),
    //                             );
    //                           }).toList();
    //                         },
    //                       ),
    //                       ],
    //                   ),
    // ],
    //               ),
    //             ),
    //           ),

    //         ],
    //       ),
    //     );
  }
}

// Supongamos que tienes un provider así para tus fotos
// final imagesProvider = StateNotifierProvider<ImagesNotifier, List<String>>((ref) => ...);

class FullScreenGalleryWithControls extends ConsumerStatefulWidget {
  final List<Imagen> imagenes;
  final int initialIndex;
  final List<String> images; // Puedes seguir pasándolas o leerlas del provider
  final String sharedMessage;
  const FullScreenGalleryWithControls({
    super.key,
    required this.imagenes,
    required this.initialIndex,
    required this.images,
    required this.sharedMessage,
  });

  @override
  ConsumerState<FullScreenGalleryWithControls> createState() =>
      _FullScreenGalleryWithControlsState();
}

class _FullScreenGalleryWithControlsState
    extends ConsumerState<FullScreenGalleryWithControls> {
  late int _currentIndex;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  void _deleteCurrentPhoto(trcId, imagenId) async {
    // AQUÍ USAS RIVERPOD
    // ref.read(imagesProvider.notifier).removeImage(_currentIndex);

    // Handle delete action
    // For example, call a delete function

    final response = await ref
        .read(controlActividadesProvider(trcId).notifier)
        .deleteImage(imagenId);

    if (response.success) {
      // Show success snackbar// Show snackbar response
      CustomSnackbar.showResponseSnackbar(
        response.message,
        response.success,
        // ignore: use_build_context_synchronously
        context,
      );
    } else {
      // Show error snackbar
      CustomSnackbar.showResponseSnackbar(
        response.message,
        response.success,
        // ignore: use_build_context_synchronously
        context,
      );
    }
    // ignore: use_build_context_synchronously
    ref
        .read(controlActividadesProvider(trcId).notifier)
        .getControlDeActividadesByTrcId();
    ref
        .read(controlActividadesProvider(trcId).notifier)
        .getControlDeActividadesServicioMiscelaneoById();

    // Pop with GoRouter
    // ignore: use_build_context_synchronously
    context.pop();
    // ignore: use_build_context_synchronously
    // context.pop();
    // or Navigator.pop(context);

    // print("Borrando imagen en el índice $_currentIndex usando Riverpod");

    // // Si la lista local se reduce, podrías necesitar un setState o
    // // simplemente cerrar la pantalla si el provider actualiza todo.
    // if (widget.images.length <= 1) {
    //   Navigator.pop(context);
    // }
  }

  @override
  Widget build(BuildContext context) {
    // Puedes "escuchar" cambios en otros providers aquí si es necesario
    // final userSettings = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Galería
          PhotoViewGallery.builder(
            itemCount: widget.images.length,
            pageController: _pageController,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(widget.images[index]),
                initialScale: PhotoViewComputedScale.contained,
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2.5,
              );
            },
            backgroundDecoration: const BoxDecoration(color: Colors.black),
          ),

          // Controles (UI)
          _buildTopBar(context),
        ],
      ),
    );
  }

  // Widget de la barra superior separado para limpieza
  Widget _buildTopBar(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black.withOpacity(0.7), Colors.transparent],
          ),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              // icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.share_outlined, color: Colors.white),
                  onPressed: () async {
                    // Handle share button action
                    try {
                      // 1. Download the image
                      // final response = await http.get(Uri.parse('${Environment.apiUrl}/aerolineas/media/${widget.images[_currentIndex].split('/').last}'));
                      final response = await http.get(
                        Uri.parse(widget.images[_currentIndex]),
                      );
                      final bytes = response.bodyBytes;

                      // 2. Get a temporary directory
                      final directory = await getTemporaryDirectory();
                      final imagePath = '${directory.path}/shared_image.jpg';

                      // 3. Save the image to a temporary file
                      final File imageFile = File(imagePath);
                      await imageFile.writeAsBytes(bytes);

                      // 4. Share the file
                      await Share.shareXFiles(
                        [XFile(imagePath)],
                        // Nombre de la tarea
                        // text: widget.imagenes[_currentIndex].shareMessage ?? '',
                        text: "${widget.sharedMessage} - foto ${_currentIndex+1}",
                        subject: 'Image from my app',
                      );
                    } catch (e) {
                      print('Error sharing image: $e');
                      // Handle error, e.g., show a SnackBar
                    }

                    // Acción de compartir usando un provider de utilidades si tuvieras
                    // ref.read(shareProvider).shareImage(widget.images[_currentIndex]);
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                  ),
                  onPressed: () => _confirmDelete(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Eliminar"),
        content: const Text("¿Estás seguro de que quieres borrar esta foto?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _deleteCurrentPhoto(
                ref.read(trcIdProvider),
                widget.imagenes[_currentIndex].id,
              );
            },
            child: const Text("Borrar", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

                              































// **************************************************************************************************************************************
// **************************************************************************************************************************************
// **************************************************************************************************************************************
// **************************************************************************************************************************************
// **************************************************************************************************************************************
// **************************************************************************************************************************************
// **************************************************************************************************************************************
// **************************************************************************************************************************************
// **************************************************************************************************************************************
// **************************************************************************************************************************************





// class ImageFullscreenCarousel extends ConsumerWidget {
//   // final List<Imagen> imagenes;
//   // final int indexStart;
//   const ImageFullscreenCarousel({
//     super.key,
//     // required this.imagenes,
//     // required this.indexStart,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final CustomFullscreenCarouselData imagesList = ref.watch(
//       imagesListProvider,
//     );
//     final List<Imagen> imagenes = imagesList.imagenes;
//     final List<String> imageUrls = imagenes
//         .map(
//           (imagen) => '${Environment.apiUrl}/aerolineas/media/${imagen.imagen}',
//         )
//         .toList();
//     final int indexStart =
//         imagesList.index; // Set your desired initial index here
//     final int trcId = ref.watch(
//       trcIdProvider,
//     ); // Get the trcId from the provider
//     // Full height of the device
//     final double height = MediaQuery.of(context).size.height;
//     // final double height = MediaQuery.of(context).size.height;

//     return Scaffold(
//       appBar: AppBar(title: Text("Galería con Zoom")),
//       body: Center(
//         child: CarouselSlider.builder(
//           itemCount: imageUrls.length,
//           options: CarouselOptions(
//             height: height,
//             viewportFraction: 1.0,
//             enlargeCenterPage: false,
//             initialPage: indexStart,
//             autoPlay: false,
//           ),
          
//           itemBuilder: (context, index, realIndex) {
//             return GestureDetector(
//               onTap: () {
//                 // Al tocar, navegamos a la vista de pantalla completa
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => FullScreenGallery(
//                       images: imageUrls,
//                       initialIndex: index,
//                     ),
//                   ),
//                 );
//               },
//               child: Image.network(imageUrls[index], fit: BoxFit.cover, height: height),
//               // child: Image.network(
//               //               '${Environment.apiUrl}/aerolineas/media/${imagen.imagen}',
//               //               fit: BoxFit.cover,
//               //               height: height,
//               //             ),
//             );
//           },
//           // options: CarouselOptions(enlargeCenterPage: true),
//         ),
//       ),
//     );

//     // OLD CODE COMMENTED OUT FOR REFERENCE

//     // return Scaffold(
//     //   // appBar: AppBar(title: Text('Fullscreen sliding carousel demo')),
//     //   body: SafeArea(
//     //     child: Builder(
//     //       builder: (context) {
//     //         final double height = MediaQuery.of(context).size.height;
//     //         return CarouselSlider(
//     //           options: CarouselOptions(
//     //             height: height,
//     //             viewportFraction: 1.0,
//     //             enlargeCenterPage: false,
//     //             initialPage: indexStart,
//     //             autoPlay: false,
//     //           ),
//     //           items: imagenes
//     //               .map(
//     //                 (imagen) => Center(
//     //                   child: Stack(
//     //                     children: [
//     //                       Image.network(
//     //                         '${Environment.apiUrl}/aerolineas/media/${imagen.imagen}',
//     //                         fit: BoxFit.cover,
//     //                         height: height,
//     //                       ),

//     //                       //  bottom Gradient overlay
//     //                       Positioned.fill(
//     //                         child: DecoratedBox(
//     //                           decoration: BoxDecoration(
//     //                             gradient: LinearGradient(
//     //                               colors: const [
//     //                                 Colors.transparent,
//     //                                 Colors.black54,
//     //                               ],
//     //                               stops: const [0.8, 1.0],
//     //                               begin: Alignment.topCenter,
//     //                               end: Alignment.bottomCenter,
//     //                             ),
//     //                           ),
//     //                         ),
//     //                       ),

//     //                       // top left corner Gradient overlay
//     //                       Positioned.fill(
//     //                         child: DecoratedBox(
//     //                           decoration: BoxDecoration(
//     //                             gradient: LinearGradient(
//     //                               colors: const [
//     //                                 Colors.transparent,
//     //                                 Colors.black54,
//     //                               ],
//     //                               stops: const [0.85, 1.0],
//     //                               begin: Alignment.bottomRight,
//     //                               end: Alignment.topLeft,
//     //                             ),
//     //                           ),
//     //                         ),
//     //                       ),

//     //                       // back button
//     //                       Positioned(
//     //                         top: 20,
//     //                         left: 10,
//     //                         child: IconButton(
//     //                           icon: const Icon(
//     //                             Icons.arrow_back_ios_rounded,
//     //                             color: Colors.white,
//     //                           ),
//     //                           onPressed: () {
//     //                             // Handle back button action with GoRouter
//     //                             context.pop();
//     //                             // or Navigator.pop(context);
//     //                           },
//     //                         ),
//     //                       ),

//     //                       // Menu button bottom right
//     //                       // Positioned(
//     //                       //   bottom: 20,
//     //                       //   right: 10,
//     //                       //   child: IconButton(
//     //                       //     icon: const Icon(Icons.menu, color: Colors.white),
//     //                       //     onPressed: () {
//     //                       //       // Handle menu button action
//     //                       //       ScaffoldMessenger.of(context).showSnackBar(
//     //                       //         const SnackBar(
//     //                       //           content: Text('Menu button pressed'),
//     //                       //         ),
//     //                       //       );
//     //                       //     },
//     //                       //   ),
//     //                       // ),

//     //                       // Share button bottom right
//     //                       Positioned(
//     //                         bottom: 15,
//     //                         right: 55,
//     //                         child: IconButton(
//     //                           icon: const Icon(
//     //                             size: 28,
//     //                             Icons.share_rounded,
//     //                             color: Colors.white,
//     //                           ),
//     //                           onPressed: () async {
//     //                             // Handle share button action
//     //                             try {
//     //   // 1. Download the image
//     //   final response = await http.get(Uri.parse('${Environment.apiUrl}/aerolineas/media/${imagen.imagen}'));
//     //   final bytes = response.bodyBytes;

//     //   // 2. Get a temporary directory
//     //   final directory = await getTemporaryDirectory();
//     //   final imagePath = '${directory.path}/shared_image.jpg';

//     //   // 3. Save the image to a temporary file
//     //   final File imageFile = File(imagePath);
//     //   await imageFile.writeAsBytes(bytes);

//     //   // 4. Share the file
//     //   await Share.shareXFiles(
//     //     [XFile(imagePath)],
//     //     // Nombre de la tarea
//     //     text: imagesList.shareMessage,
//     //     subject: 'Image from my app');
//     // } catch (e) {
//     //   print('Error sharing image: $e');
//     //   // Handle error, e.g., show a SnackBar
//     // }
//     //                           },
//     //                         ),
//     //                       ),
//     //                       // Delete button bottom right
//     //                       Positioned(
//     //                         bottom: 15,
//     //                         right: 10,
//     //                         child: IconButton(
//     //                           icon: const Icon(
//     //                             size: 30,
//     //                             Icons.delete_outline_rounded,
//     //                             color: Colors.white,
//     //                           ),
//     //                           onPressed: () {
//     //                             // dialog to confirm deletion
//     //                             showDialog(
//     //                               context: context,
//     //                               builder: (context) => AlertDialog(
//     //                                 title: const Text('Confirmar eliminación'),
//     //                                 content: const Text(
//     //                                   '¿Estás seguro de que deseas eliminar esta imagen?',
//     //                                 ),
//     //                                 actions: [
//     //                                   TextButton(
//     //                                     onPressed: () {
//     //                                       // Close the dialog
//     //                                       Navigator.of(context).pop();
//     //                                     },
//     //                                     child: const Text('Cancelar'),
//     //                                   ),
//     //                                   TextButton(
//     //                                     onPressed: () async {
//     //                                       // Handle delete action
//     //                                       // For example, call a delete function

//     //                                       final response = await ref
//     //                                           .read(
//     //                                             controlActividadesProvider(
//     //                                               trcId,
//     //                                             ).notifier,
//     //                                           )
//     //                                           .deleteImage(imagen.id);

//     //                                       if (response.success) {
//     //                                         // Show success snackbar// Show snackbar response
//     //                                         CustomSnackbar.showResponseSnackbar(
//     //                                           response.message,
//     //                                           response.success,
//     //                                           // ignore: use_build_context_synchronously
//     //                                           context,
//     //                                         );
//     //                                       } else {
//     //                                         // Show error snackbar
//     //                                         CustomSnackbar.showResponseSnackbar(
//     //                                           response.message,
//     //                                           response.success,
//     //                                           // ignore: use_build_context_synchronously
//     //                                           context,
//     //                                         );
//     //                                       }
//     //                                       // ignore: use_build_context_synchronously
//     //                                       ref
//     //                                           .read(
//     //                                             controlActividadesProvider(
//     //                                               trcId,
//     //                                             ).notifier,
//     //                                           )
//     //                                           .getControlDeActividadesByTrcId();

//     //                                       // Pop with GoRouter
//     //                                       // ignore: use_build_context_synchronously
//     //                                       context.pop();
//     //                                       // ignore: use_build_context_synchronously
//     //                                       context.pop();
//     //                                       // or Navigator.pop(context);
//     //                                     },
//     //                                     child: const Text('Eliminar'),
//     //                                   ),
//     //                                 ],
//     //                               ),
//     //                             );
//     //                             // Handle delete button action
//     //                             // ScaffoldMessenger.of(context).showSnackBar(
//     //                             //   const SnackBar(
//     //                             //     content: Text('Delete button pressed'),
//     //                             //   ),
//     //                             // );
//     //                           },
//     //                         ),
//     //                       ),

//     //                       // enumerate the list of images
//     //                       Positioned(
//     //                         bottom: 20,
//     //                         left: 30,
//     //                         child: Text(
//     //                           '${imagenes.indexOf(imagen) + 1}/${imagenes.length}',
//     //                           style: const TextStyle(
//     //                             color: Colors.white,
//     //                             fontSize: 16,
//     //                             fontWeight: FontWeight.bold,
//     //                           ),
//     //                         ),
//     //                       ),
//     //                     ],
//     //                   ),
//     //                 ),
//     //               )
//     //               .toList(),
//     //         );
//     //       },
//     //     ),
//     //   ),
//     // );
//   }
// }

// class FullScreenGallery extends StatelessWidget {
//   final List<String> images;
//   final int initialIndex;

//   FullScreenGallery({required this.images, required this.initialIndex});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // Botón para cerrar en la parte superior
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         iconTheme: IconThemeData(color: Colors.white),
//       ),
//       backgroundColor: Colors.black,
//       body: PhotoViewGallery.builder(
//         itemCount: images.length,
//         builder: (context, index) {
//           return PhotoViewGalleryPageOptions(
//             imageProvider: NetworkImage(images[index]),
//             // Escala inicial: que la imagen quepa en la pantalla
//             initialScale: PhotoViewComputedScale.contained,
//             // Escala mínima y máxima permitida
//             minScale: PhotoViewComputedScale.contained,
//             maxScale: PhotoViewComputedScale.covered * 3,
//           );
//         },
//         // Esto permite que la galería empiece en la imagen seleccionada
//         pageController: PageController(initialPage: initialIndex),
//         scrollPhysics: BouncingScrollPhysics(),
//         backgroundDecoration: BoxDecoration(color: Colors.black),
//       ),
//     );
//   }
// }




// **************************************************************************************************************************************
// **************************************************************************************************************************************
// **************************************************************************************************************************************
// **************************************************************************************************************************************
// **************************************************************************************************************************************
// **************************************************************************************************************************************
// **************************************************************************************************************************************
// **************************************************************************************************************************************
// **************************************************************************************************************************************
// **************************************************************************************************************************************



// class ImageFullscreenCarousel extends ConsumerWidget {
//   // final List<Imagen> imagenes;
//   // final int indexStart;
//   const ImageFullscreenCarousel({
//     super.key,
//     // required this.imagenes,
//     // required this.indexStart,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final CustomFullscreenCarouselData imagesList = ref.watch(
//       imagesListProvider,
//     );
//     final List<Imagen> imagenes = imagesList.imagenes;
//     final int indexStart =
//         imagesList.index; // Set your desired initial index here
//     final int trcId = ref.watch(
//       trcIdProvider,
//     ); // Get the trcId from the provider
//     return Scaffold(
//       // appBar: AppBar(title: Text('Fullscreen sliding carousel demo')),
//       body: SafeArea(
//         child: Builder(
//           builder: (context) {
//             final double height = MediaQuery.of(context).size.height;
//             return CarouselSlider(
//               options: CarouselOptions(
//                 height: height,
//                 viewportFraction: 1.0,
//                 enlargeCenterPage: false,
//                 initialPage: indexStart,
//                 autoPlay: false,
//               ),
//               items: imagenes
//                   .map(
//                     (imagen) => Center(
//                       child: Stack(
//                         children: [
//                           Image.network(
//                             '${Environment.apiUrl}/aerolineas/media/${imagen.imagen}',
//                             fit: BoxFit.cover,
//                             height: height,
//                           ),
        
//                           //  bottom Gradient overlay
//                           Positioned.fill(
//                             child: DecoratedBox(
//                               decoration: BoxDecoration(
//                                 gradient: LinearGradient(
//                                   colors: const [
//                                     Colors.transparent,
//                                     Colors.black54,
//                                   ],
//                                   stops: const [0.8, 1.0],
//                                   begin: Alignment.topCenter,
//                                   end: Alignment.bottomCenter,
//                                 ),
//                               ),
//                             ),
//                           ),
        
//                           // top left corner Gradient overlay
//                           Positioned.fill(
//                             child: DecoratedBox(
//                               decoration: BoxDecoration(
//                                 gradient: LinearGradient(
//                                   colors: const [
//                                     Colors.transparent,
//                                     Colors.black54,
//                                   ],
//                                   stops: const [0.85, 1.0],
//                                   begin: Alignment.bottomRight,
//                                   end: Alignment.topLeft,
//                                 ),
//                               ),
//                             ),
//                           ),
        
//                           // back button
//                           Positioned(
//                             top: 20,
//                             left: 10,
//                             child: IconButton(
//                               icon: const Icon(
//                                 Icons.arrow_back_ios_rounded,
//                                 color: Colors.white,
//                               ),
//                               onPressed: () {
//                                 // Handle back button action with GoRouter
//                                 context.pop();
//                                 // or Navigator.pop(context);
//                               },
//                             ),
//                           ),
        
//                           // Menu button bottom right
//                           // Positioned(
//                           //   bottom: 20,
//                           //   right: 10,
//                           //   child: IconButton(
//                           //     icon: const Icon(Icons.menu, color: Colors.white),
//                           //     onPressed: () {
//                           //       // Handle menu button action
//                           //       ScaffoldMessenger.of(context).showSnackBar(
//                           //         const SnackBar(
//                           //           content: Text('Menu button pressed'),
//                           //         ),
//                           //       );
//                           //     },
//                           //   ),
//                           // ),
        
//                           // Share button bottom right
//                           Positioned(
//                             bottom: 15,
//                             right: 55,
//                             child: IconButton(
//                               icon: const Icon(
//                                 size: 28,
//                                 Icons.share_rounded,
//                                 color: Colors.white,
//                               ),
//                               onPressed: () async {
//                                 // Handle share button action
//                                 try {

//                                   // 1. Download the image
//                                   final response = await http.get(Uri.parse('${Environment.apiUrl}/aerolineas/media/${imagen.imagen}'));
//                                   final bytes = response.bodyBytes;

//                                   // 2. Get a temporary directory
//                                   final directory = await getTemporaryDirectory();
//                                   final imagePath = '${directory.path}/shared_image.jpg';

//                                   // 3. Save the image to a temporary file
//                                   final File imageFile = File(imagePath);
//                                   await imageFile.writeAsBytes(bytes);

//                                   // 4. Share the file
//                                   await Share.shareXFiles(
//                                     [XFile(imagePath)], 
//                                     // Nombre de la tarea
//                                     text: imagesList.shareMessage, 
//                                     subject: 'Image from my app');
//                                 } catch (e) {
//                                   print('Error sharing image: $e');
//                                   // Handle error, e.g., show a SnackBar
//                                 }
//                               },
//                             ),
//                           ),
//                           // Delete button bottom right
//                           Positioned(
//                             bottom: 15,
//                             right: 10,
//                             child: IconButton(
//                               icon: const Icon(
//                                 size: 30,
//                                 Icons.delete_outline_rounded,
//                                 color: Colors.white,
//                               ),
//                               onPressed: () {
//                                 // dialog to confirm deletion
//                                 showDialog(
//                                   context: context,
//                                   builder: (context) => AlertDialog(
//                                     title: const Text('Confirmar eliminación'),
//                                     content: const Text(
//                                       '¿Estás seguro de que deseas eliminar esta imagen?',
//                                     ),
//                                     actions: [
//                                       TextButton(
//                                         onPressed: () {
//                                           // Close the dialog
//                                           Navigator.of(context).pop();
//                                         },
//                                         child: const Text('Cancelar'),
//                                       ),
//                                       TextButton(
//                                         onPressed: () async {
//                                           // Handle delete action
//                                           // For example, call a delete function
        
//                                           final response = await ref
//                                               .read(
//                                                 controlActividadesProvider(
//                                                   trcId,
//                                                 ).notifier,
//                                               )
//                                               .deleteImage(imagen.id);
        
//                                           if (response.success) {
//                                             // Show success snackbar// Show snackbar response
//                                             CustomSnackbar.showResponseSnackbar(
//                                               response.message,
//                                               response.success,
//                                               // ignore: use_build_context_synchronously
//                                               context,
//                                             );
//                                           } else {
//                                             // Show error snackbar
//                                             CustomSnackbar.showResponseSnackbar(
//                                               response.message,
//                                               response.success,
//                                               // ignore: use_build_context_synchronously
//                                               context,
//                                             );
//                                           }
//                                           // ignore: use_build_context_synchronously
//                                           ref
//                                               .read(
//                                                 controlActividadesProvider(
//                                                   trcId,
//                                                 ).notifier,
//                                               )
//                                               .getControlDeActividadesByTrcId();
        
//                                           // Pop with GoRouter
//                                           // ignore: use_build_context_synchronously
//                                           context.pop();
//                                           // ignore: use_build_context_synchronously
//                                           context.pop();
//                                           // or Navigator.pop(context);
//                                         },
//                                         child: const Text('Eliminar'),
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                                 // Handle delete button action
//                                 // ScaffoldMessenger.of(context).showSnackBar(
//                                 //   const SnackBar(
//                                 //     content: Text('Delete button pressed'),
//                                 //   ),
//                                 // );
//                               },
//                             ),
//                           ),
        
//                           // enumerate the list of images
//                           Positioned(
//                             bottom: 20,
//                             left: 30,
//                             child: Text(
//                               '${imagenes.indexOf(imagen) + 1}/${imagenes.length}',
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   )
//                   .toList(),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }



