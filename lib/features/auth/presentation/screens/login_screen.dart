import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/widgets.dart';
import '../providers/providers.dart';
import '../widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor:scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * .9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Logo(),

                  SizedBox(height: 20),

                  _LoginForm(),

                  // Labels(),

                  // _Form()
                ],
              ),
            ),
          ),
        ),
      ),

      bottomNavigationBar: Container(
        height: 50, // Or whatever height your footer needs
        // color: Colors.blue,
        alignment: Alignment.center,
        child: const CustomBottomNavigationBar(),
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    int currentYear = DateTime.now().year;

    return Text(
      // 'Terminos y condiciones',
      // Copyright © 2023 Turnaround
      'Copyright Siaca© $currentYear',
      style: Theme.of(
        context,
      ).textTheme.labelSmall?.copyWith(color: Colors.grey),
    );
  }
}

class _LoginForm extends ConsumerWidget {
  const _LoginForm();

  void showSnackBar(BuildContext context, String errorMessage) {
    // final snackBar = SnackBar(
    //   content: Text(errorMessage),
    //   backgroundColor: Colors.red,
    // );
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding: const EdgeInsets.all(25),
        // margin: const EdgeInsets.all(15),
        behavior: SnackBarBehavior.floating,
        elevation: 100,
        content: Center(child: Text(errorMessage)),

        // backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginForm = ref.watch(loginFormProvider);

    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage.isEmpty) return;

      showSnackBar(context, next.errorMessage);
      // Navigator.pushReplacementNamed(context, 'home');
    });
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [
        CustomTextFormField(
          // label: 'Correo',
          keyboardType: TextInputType.emailAddress,
          hint: 'Correo',
          prefixIcon: Icon(
            Icons.email_outlined,
            color: colors.primary,
            size: 20,
          ),
          onChanged: (value) =>
              ref.read(loginFormProvider.notifier).onEmailChanged(value),
          errorMessage: loginForm.isFormPosted
              ? loginForm.email.errorMessage
              : null,
        ),

        CustomTextFormField(
          // label: 'Contraseña',
          onFieldSubmitted: (_) =>
              ref.read(loginFormProvider.notifier).onFormSubmit(),
          obscureText: true,
          hint: 'Contraseña',
          prefixIcon: Icon(Icons.lock_outline, color: colors.primary, size: 20),
          onChanged: (value) =>
              ref.read(loginFormProvider.notifier).onPasswordChanged(value),
          errorMessage: loginForm.isFormPosted
              ? loginForm.password.errorMessage
              : null,
        ),

        CustomFilledButton(
          text: 'Ingresar',
          buttonColor: colors.primary,
          onPressed: loginForm.isPosting
              ? null
              : ref.read(loginFormProvider.notifier).onFormSubmit,
        ),
      ],
    );
  }
}










































// *********************************************************************************************************************
// *********************************************************************************************************************
// *********************************************************************************************************************


// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

// import '../../../shared/widgets/widgets.dart';

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Background(
//       child: SingleChildScrollView(
//         child: Responsive(
//           mobile: MobileLoginScreen(), 
//           desktop: Placeholder()
//         ),
//       ),
//     );
//   }
// }

// class MobileLoginScreen extends StatelessWidget {
//   const MobileLoginScreen({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         LoginScreenTopImage(),

//         Row(
//           children: [
//             // SvgPicture.asset("assets/icons/logo-trc.svg") ,
//             const Spacer(),
//             const Expanded(
//               flex: 8,
//               child: Text('Hola'),
//             ),
//             const Spacer(),
//           ],
//         ),
//       ],
//     );
//   }
// }


// class LoginScreenTopImage extends StatelessWidget {

//   static const double defaultPadding = 16.0;
//   const LoginScreenTopImage({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           children: [
//             const Spacer(),
//             Expanded(
//               flex: 8,
//               child: SvgPicture.asset("assets/icons/logo-trc.svg", height: 90, width: 90,),
//             ),
//             const Spacer(),
//           ],
//         ),
//         const SizedBox(height: defaultPadding * 2),
//         const Text(
//           "LOGIN",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: defaultPadding * 2),
//       ],
//     );
//   }
// }


// *********************************************************************************************************************
// *********************************************************************************************************************
// *********************************************************************************************************************




// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:turnaround_mobile/features/shared/shared.dart';


// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {

//     final size = MediaQuery.of(context).size;
//     final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

//     return GestureDetector(
//       onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
//       child: Scaffold(
//         body: GeometricalBackground( 
//           child: SingleChildScrollView(
//             physics: const ClampingScrollPhysics(),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const SizedBox( height: 80 ),
//                 // Icon Banner
//                 const Icon( 
//                   Icons.production_quantity_limits_rounded, 
//                   color: Colors.white,
//                   size: 100,
//                 ),
//                 const SizedBox( height: 80 ),
    
//                 Container(
//                   height: size.height - 260, // 80 los dos sizebox y 100 el ícono
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     color: scaffoldBackgroundColor,
//                     borderRadius: const BorderRadius.only(topLeft: Radius.circular(100)),
//                   ),
//                   child: const _LoginForm(),
//                 )
//               ],
//             ),
//           )
//         )
//       ),
//     );
//   }
// }

// class _LoginForm extends StatelessWidget {
//   const _LoginForm();

//   @override
//   Widget build(BuildContext context) {

//     final textStyles = Theme.of(context).textTheme;

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 50),
//       child: Column(
//         children: [
//           const SizedBox( height: 50 ),
//           Text('Login', style: textStyles.titleLarge ),
//           const SizedBox( height: 90 ),

//           const CustomTextFormField(
//             label: 'Correo',
//             keyboardType: TextInputType.emailAddress,
//           ),
//           const SizedBox( height: 30 ),

//           const CustomTextFormField(
//             label: 'Contraseña',
//             obscureText: true,
//           ),
    
//           const SizedBox( height: 30 ),

//           SizedBox(
//             width: double.infinity,
//             height: 60,
//             child: CustomFilledButton(
//               text: 'Ingresar',
//               buttonColor: Colors.black,
//               onPressed: (){

//               },
//             )
//           ),

//           const Spacer( flex: 2 ),

//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text('¿No tienes cuenta?'),
//               TextButton(
//                 onPressed: ()=> context.push('/register'), 
//                 child: const Text('Crea una aquí')
//               )
//             ],
//           ),

//           const Spacer( flex: 1),
//         ],
//       ),
//     );
//   }
// }