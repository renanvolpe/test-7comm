import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gap/gap.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../core/style/app_color.dart';
import '../../../core/style/text_style.dart';
import '../../data/param/login_param.dart';
import '../../data/param/recovery_secret_param.dart';
import '../bloc/recovery_pass/recovery_secret_bloc.dart';
import '../widget/btn_recovery_secret.dart';

class RecoverySecretPage extends StatefulWidget {
  const RecoverySecretPage({super.key, required this.loginParam});

  final LoginParam loginParam;

  @override
  State<RecoverySecretPage> createState() => _RecoverySecretPageState();
}

class _RecoverySecretPageState extends State<RecoverySecretPage> {
  late RecoverySecretBloc recoverySecretBloc;
  late TextEditingController codeTextController;
  @override
  void initState() {
    recoverySecretBloc = Modular.get<RecoverySecretBloc>();
    codeTextController = TextEditingController();

    super.initState();
  }

  String? validator(String? value) {
    if (value!.length < 6) {
      return "Insert the 6 values";
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var loginParam = widget.loginParam;
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () => Modular.to.pop(), child: const Icon(Icons.chevron_left, color: AppColor.kPrimary)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Verificação", style: Style.darkStyle.copyWith(fontSize: 20, fontWeight: FontWeight.w600)),
              const Gap(10),
              Text("Insira o código que foi enviado:", style: Style.greyStyle.copyWith(fontSize: 16)),
              const Gap(85),
              PinCodeTextField(
                appContext: context,
                length: 6,
                animationType: AnimationType.fade,
                blinkWhenObscuring: true,
                validator: validator,
                pinTheme: PinTheme(
                  activeColor: AppColor.kPrimary,
                  selectedColor: AppColor.kPrimary,
                  inactiveColor: AppColor.kBorderLight,
                  inactiveFillColor: AppColor.kBackgroundLight,
                  inactiveBorderWidth: 2,
                  selectedFillColor: AppColor.kWhite,
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 50,
                  activeFillColor: AppColor.kWhite,
                ),
                cursorColor: AppColor.kBlack,
                animationDuration: const Duration(milliseconds: 300),
                enableActiveFill: true,
                controller: codeTextController,
                keyboardType: TextInputType.number,
                boxShadows: const [
                  BoxShadow(
                    offset: Offset(0, 1),
                    color: Colors.black12,
                    blurRadius: 10,
                  )
                ],
                onCompleted: (value) {
                  String username = loginParam.username;
                  String password = loginParam.password;
                  RecoverySecretParam param =
                      RecoverySecretParam(username: username, password: password, code: codeTextController.text);
                  recoverySecretBloc.add(RecoverySecretStarted(param));
                },
                onChanged: (value) {
                  debugPrint(value);
                },
                beforeTextPaste: (text) {
                  debugPrint("Allowing to paste $text");

                  return true;
                },
              ),
              const Gap(20),
              BtnRecoverySecret(
                loginParam: loginParam,
                codeTextController: codeTextController,
              ),
              const Gap(30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.messenger_outline,
                    color: AppColor.kPrimary,
                  ),
                  const Gap(10),
                  Text(
                    "Não Recebi o código",
                    style: Style.defaultStyle.copyWith(fontWeight: FontWeight.w600),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
