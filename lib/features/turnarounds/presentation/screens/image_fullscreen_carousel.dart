import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
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
    final int indexStart =
        imagesList.index; // Set your desired initial index here
    final int trcId = ref.watch(
      trcIdProvider,
    ); // Get the trcId from the provider
    return Scaffold(
      // appBar: AppBar(title: Text('Fullscreen sliding carousel demo')),
      body: SafeArea(
        child: Builder(
          builder: (context) {
            final double height = MediaQuery.of(context).size.height;
            return CarouselSlider(
              options: CarouselOptions(
                height: height,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                initialPage: indexStart,
                autoPlay: false,
              ),
              items: imagenes
                  .map(
                    (imagen) => Center(
                      child: Stack(
                        children: [
                          Image.network(
                            '${Environment.apiUrl}/aerolineas/media/${imagen.imagen}',
                            fit: BoxFit.cover,
                            height: height,
                          ),
        
                          //  bottom Gradient overlay
                          Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: const [
                                    Colors.transparent,
                                    Colors.black54,
                                  ],
                                  stops: const [0.8, 1.0],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          ),
        
                          // top left corner Gradient overlay
                          Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: const [
                                    Colors.transparent,
                                    Colors.black54,
                                  ],
                                  stops: const [0.85, 1.0],
                                  begin: Alignment.bottomRight,
                                  end: Alignment.topLeft,
                                ),
                              ),
                            ),
                          ),
        
                          // back button
                          Positioned(
                            top: 20,
                            left: 10,
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios_rounded,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                // Handle back button action with GoRouter
                                context.pop();
                                // or Navigator.pop(context);
                              },
                            ),
                          ),
        
                          // Menu button bottom right
                          // Positioned(
                          //   bottom: 20,
                          //   right: 10,
                          //   child: IconButton(
                          //     icon: const Icon(Icons.menu, color: Colors.white),
                          //     onPressed: () {
                          //       // Handle menu button action
                          //       ScaffoldMessenger.of(context).showSnackBar(
                          //         const SnackBar(
                          //           content: Text('Menu button pressed'),
                          //         ),
                          //       );
                          //     },
                          //   ),
                          // ),
        
                          // Share button bottom right
                          Positioned(
                            bottom: 15,
                            right: 55,
                            child: IconButton(
                              icon: const Icon(
                                size: 28,
                                Icons.share_rounded,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                // Handle share button action
                                try {
      // 1. Download the image
      final response = await http.get(Uri.parse('${Environment.apiUrl}/aerolineas/media/${imagen.imagen}'));
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
        text: imagesList.shareMessage, 
        subject: 'Image from my app');
    } catch (e) {
      print('Error sharing image: $e');
      // Handle error, e.g., show a SnackBar
    }
                              },
                            ),
                          ),
                          // Delete button bottom right
                          Positioned(
                            bottom: 15,
                            right: 10,
                            child: IconButton(
                              icon: const Icon(
                                size: 30,
                                Icons.delete_outline_rounded,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                // dialog to confirm deletion
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Confirmar eliminación'),
                                    content: const Text(
                                      '¿Estás seguro de que deseas eliminar esta imagen?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          // Close the dialog
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          // Handle delete action
                                          // For example, call a delete function
        
                                          final response = await ref
                                              .read(
                                                controlActividadesProvider(
                                                  trcId,
                                                ).notifier,
                                              )
                                              .deleteImage(imagen.id);
        
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
                                              .read(
                                                controlActividadesProvider(
                                                  trcId,
                                                ).notifier,
                                              )
                                              .getControlDeActividadesByTrcId();
        
                                          // Pop with GoRouter
                                          // ignore: use_build_context_synchronously
                                          context.pop();
                                          // ignore: use_build_context_synchronously
                                          context.pop();
                                          // or Navigator.pop(context);
                                        },
                                        child: const Text('Eliminar'),
                                      ),
                                    ],
                                  ),
                                );
                                // Handle delete button action
                                // ScaffoldMessenger.of(context).showSnackBar(
                                //   const SnackBar(
                                //     content: Text('Delete button pressed'),
                                //   ),
                                // );
                              },
                            ),
                          ),
        
                          // enumerate the list of images
                          Positioned(
                            bottom: 20,
                            left: 30,
                            child: Text(
                              '${imagenes.indexOf(imagen) + 1}/${imagenes.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ),
    );
  }
}
