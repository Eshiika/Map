import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/map_view_model.dart';

class HabitantMinField extends StatefulWidget {
  const HabitantMinField({super.key});

  @override
  State<HabitantMinField> createState() => _HabitantMinFieldState();
}

class _HabitantMinFieldState extends State<HabitantMinField> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    final vm = context.read<MapViewModel>();
    controller = TextEditingController(
      text: vm.habitantMin?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<MapViewModel>();

    return TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: "Ex: 5000",
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 2,
          ),
        ),
        suffixIcon: IconButton(
          onPressed: () async {
            vm.setHabitantMin(controller.text);
            await vm.loadCities();
          },
          icon: const Icon(Icons.search),
        ),
      ),
      onSubmitted: (value) async {
        vm.setHabitantMin(value);
        await vm.loadCities();
      },
    );
  }
}