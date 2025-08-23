import 'package:flutter/material.dart';

import '../../domain/domain.dart';

class DemoraSearchDelegate extends SearchDelegate<DemoraCodigo?> {
  final List<DemoraCategoria> categorias;

  DemoraSearchDelegate({required this.categorias})
    : super(searchFieldLabel: 'Buscar', keyboardType: TextInputType.text);

  // @override
  // String get searchFieldLabel => 'Buscar';

  @override
  TextStyle? get searchFieldStyle => const TextStyle(
    fontSize: 20.0, // Set your desired font size here
    color: Colors.black54, // You can also customize color and other properties
  );

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        // return DemoraCodigo

        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final filteredData = _filterData();

    if (query.isEmpty) {
      return _buildAllCategories();
    }

    if (filteredData.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        child: Text(
          'No se encontraron resultados para "$query"',
          style: const TextStyle(fontSize: 20),
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredData.length,
      itemBuilder: (context, index) {
        final categoria = filteredData[index];
        return _buildCategoryCard(categoria, context);
      },
    );
  }

  List<DemoraCategoria> _filterData() {
    if (query.isEmpty) {
      return categorias;
    }

    final filteredCategorias = categorias
        .map((categoria) {
          final filteredCodigos = categoria.codigo.where((codigo) {
            return codigo.codIdentificadorNumero.toString().contains(query) ||
                codigo.codIdentificadorLetra.toLowerCase().contains(
                  query.toLowerCase(),
                ) ||
                codigo.codDescripcionEs.toLowerCase().contains(
                  query.toLowerCase(),
                );
          }).toList();

          return DemoraCategoria(
            nombre: categoria.nombre,
            identificador: categoria.identificador,
            codigo: filteredCodigos,
          );
        })
        .where((categoria) => categoria.codigo.isNotEmpty)
        .toList();

    return filteredCategorias;
  }

  Widget _buildAllCategories() {
    return ListView.builder(
      itemCount: categorias.length,
      itemBuilder: (context, index) {
        final categoria = categorias[index];
        return _buildCategoryCard(categoria, context);
      },
    );
  }

  Widget _buildCategoryCard(DemoraCategoria categoria, BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 12,
            bottom: 6,
          ),
          child: Text(
            categoria.nombre,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        // List of códigos
        ...categoria.codigo.map((codigo) {
          return _buildCodigoTile(codigo, categoria, context, theme);
        }).toList(),
      ],
    );
    // Card(
    //   margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    //   child: ExpansionTile(
    //     leading: _buildCategoryLeading(categoria),
    //     title: Text(
    //       categoria.nombre,
    //       style: const TextStyle(fontWeight: FontWeight.bold),
    //     ),
    //     subtitle: Text('${categoria.codigo.length} códigos'),
    //     children: categoria.codigo.map((codigo) {
    //       return _buildCodigoTile(codigo, categoria, context);
    //     }).toList(),
    //   ),
    // );
  }

  // Widget _buildCategoryLeading(DemoraCategoria categoria) {
  //   // Custom leading widget for category
  //   return Container(
  //     width: 40,
  //     height: 40,
  //     decoration: BoxDecoration(
  //       color: Colors.blue.shade100,
  //       shape: BoxShape.circle,
  //     ),
  //     child: Center(
  //       child: Text(
  //         categoria.nombre[0],
  //         style: const TextStyle(
  //           fontWeight: FontWeight.bold,
  //           color: Colors.blue,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildCodigoTile(
    DemoraCodigo codigo,
    DemoraCategoria categoria,
    BuildContext context,
    dynamic theme,
  ) {
    return ListTile(
      // dense: true,
      // leading: _buildCodigoLeading(codigo),
      // titleAlignment: ListTileTitleAlignment.top,
      leading: Text(
        '${codigo.codIdentificadorNumero.toString()} ${codigo.codIdentificadorLetra} ${codigo.codIdentificadorLetraAdicional}',
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      // title: Text(
      //   '${codigo.codIdentificadorNumero.toString()} ${codigo.codIdentificadorLetra} ${codigo.codIdentificadorLetraAdicional}',
      // ),
      title: Text(codigo.codDescripcionEs, style: theme.textTheme.bodyMedium),
      // trailing: _buildActionButtons(codigo, categoria, context),
      onTap: () {
        // Handle codigo selection
        close(context, codigo);
      },
    );
    // return Row(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Text(
    //       ' ${codigo.codIdentificadorNumero.toString()} ${codigo.codIdentificadorLetra} ${codigo.codIdentificadorLetraAdicional} ',
    //       style: theme.textTheme.titleLarge?.copyWith(
    //         fontWeight: FontWeight.w900,
    //       ),
    //     ),
    //     const SizedBox(width: 8.0),
    //     Expanded(
    //       child: Text(
    //         ' ${codigo.codDescripcionEs}',
    //         style: theme.textTheme.bodyMedium,
    //         maxLines: 2,
    //         overflow: TextOverflow.ellipsis,
    //       ),
    //     ),
    //   ],
    // );

    // ListTile(
    //   dense: true,
    //   // leading: _buildCodigoLeading(codigo),
    //   leading: Text(
    //     '${codigo.codIdentificadorNumero.toString()} ${codigo.codIdentificadorLetra} ${codigo.codIdentificadorLetraAdicional}',
    //     style: const TextStyle(fontWeight: FontWeight.bold),
    //   ),
    //   // title: Text(
    //   //   '${codigo.codIdentificadorNumero.toString()} ${codigo.codIdentificadorLetra} ${codigo.codIdentificadorLetraAdicional}',
    //   // ),
    //   subtitle: Text(codigo.codDescripcionEs),
    //   // trailing: _buildActionButtons(codigo, categoria, context),
    //   onTap: () {
    //     // Handle codigo selection
    //     close(context, codigo.codId.toString());
    //   },
    // );
  }

  // Widget _buildCodigoLeading(DemoraCodigo codigo) {
  //   // Custom leading widget for codigo
  //   return Container(
  //     // width: 36,
  //     // height: 36,
  //     decoration: BoxDecoration(
  //       color: Colors.green.shade100,
  //       shape: BoxShape.circle,
  //     ),
  //     child: Center(
  //       child: Text(
  //         codigo.codIdentificadorNumero.toString(),
  //         style: const TextStyle(
  //           fontWeight: FontWeight.bold,
  //           color: Colors.green,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildActionButtons(
  //   DemoraCodigo codigo,
  //   DemoraCategoria categoria,
  //   BuildContext context,
  // ) {
  //   return Row(
  //     mainAxisSize: MainAxisSize.min,
  //     children: [
  //       IconButton(
  //         icon: const Icon(Icons.info_outline, size: 20),
  //         onPressed: () {
  //           _showCodigoDetails(codigo, categoria, context);
  //         },
  //       ),
  //       IconButton(
  //         icon: const Icon(Icons.copy, size: 20),
  //         onPressed: () {
  //           _copyToClipboard(codigo.codIdentificadorNumero.toString(), context);
  //         },
  //       ),
  //     ],
  //   );
  // }

  // void _showCodigoDetails(
  //   DemoraCodigo codigo,
  //   DemoraCategoria categoria,
  //   BuildContext context,
  // ) {
  //   // You can implement a dialog or navigation to show details
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text('Código: ${codigo.codIdentificadorNumero}'),
  //       content: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Text('Categoría: ${categoria.nombre}'),
  //           const SizedBox(height: 8),
  //           Text('Descripción: ${codigo.codDescripcionEs}'),
  //         ],
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text('Cerrar'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // void _copyToClipboard(String text, BuildContext context) {
  //   // Implement clipboard functionality
  //   // You might want to use packages like clipboard or flutter/services
  //   ScaffoldMessenger.of(
  //     context,
  //   ).showSnackBar(SnackBar(content: Text('Copiado: $text')));
  // }
}

// import 'package:flutter/material.dart';

// import '../../domain/domain.dart';

// class MyDemorasSearchDelegate extends SearchDelegate<String> {
//   final List<DemoraCategoria> allCategories; // Your nested data

//   MyDemorasSearchDelegate(this.allCategories);

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     final theme = Theme.of(context);
//     final flattenedDemoras = allCategories.expand((c) => c.codigo).toList();
//     final demoras = flattenedDemoras
//         .where(
//           (demora) =>
//               (demora.codIdentificadorNumero.toString().contains(query) ||
//               demora.codIdentificadorLetra.toLowerCase().contains(
//                 query.toLowerCase(),
//               ) ||
//               demora.codIdentificadorLetraAdicional.toLowerCase().contains(
//                 query.toLowerCase(),
//               )
//               // || demora.codDescripcionEn.toLowerCase().contains(query.toLowerCase())
//               ),
//         )
//         .toList();

//     return ListView.builder(
//       itemCount: demoras.length,
//       itemBuilder: (context, index) {
//         final demora = demoras[index];
//         return ListTile(
//           dense: true,
//           title: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 ' ${demora.codIdentificadorNumero.toString()} ${demora.codIdentificadorLetra} ${demora.codIdentificadorLetraAdicional} ',
//                 style: theme.textTheme.titleLarge?.copyWith(
//                   fontWeight: FontWeight.w900,
//                 ),
//               ),
//               const SizedBox(width: 8.0),
//               Expanded(
//                 child: Text(
//                   ' ${demora.codDescripcionEs}',
//                   style: theme.textTheme.bodyMedium,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ],
//           ),
//           // subtitle: Text('Category: ${allCategories.firstWhere((c) => c.demoras.contains(demora)).name}'),
//           onTap: () {
//             print('Selected: ${demora.codIdentificadorNumero}');

//             // return Demora

//             // return demora;
//             query = demora.codIdentificadorNumero.toString();
//             showResults(context);
//           },
//         );
//       },
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     final flattenedDemoras = allCategories.expand((c) => c.codigo).toList();
//     final results = flattenedDemoras
//         .where(
//           (demora) =>
//               demora.codIdentificadorNumero.toString().contains(query) ||
//               demora.codIdentificadorLetra.toLowerCase().contains(
//                 query.toLowerCase(),
//               ) ||
//               demora.codIdentificadorLetraAdicional.toLowerCase().contains(
//                 query.toLowerCase(),
//               ),
//         )
//         .toList();

//     return ListView.builder(
//       itemCount: results.length,
//       itemBuilder: (context, index) {
//         final demora = results[index];
//         return Card(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Wrap(
//                   children: [
//                     Row(
//                       children: [
//                         Text(
//                           '${demora.codIdentificadorNumero.toString()} ${demora.codIdentificadorLetra} - ',
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         Text(demora.codDescripcionEs),
//                       ],
//                     ),
//                   ],
//                 ),
//                 // Text(
//                 //   'Category: ${allCategories.firstWhere((c) => c.codigo.contains(demora)).nombre}',
//                 // ),
//                 // Display nested variants
//                 // TODO: Replace 'variants' with the correct property or remove this block if not needed
//                 // ...demora.variants.map(
//                 //   (variant) =>
//                 //       Text('Color: ${variant.color}, Size: ${variant.size}'),
//                 // ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: Icon(Icons.clear),
//         onPressed: () {
//           query = '';
//         },
//       ),
//       IconButton(
//         icon: Icon(Icons.search),
//         onPressed: () {
//           showResults(context);
//         },
//       ),
//     ];
//   }

//   @override
//   Widget? buildLeading(BuildContext context) {
//     return IconButton(
//       icon: Icon(Icons.arrow_back),
//       onPressed: () {
//         close(context, '');
//       },
//     );
//   }

//   // ... (buildLeading, buildActions)
// }
