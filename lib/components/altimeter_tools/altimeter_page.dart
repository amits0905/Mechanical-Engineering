// lib/components/altimeter_tools/altimeter_page.dart

import 'package:flutter/material.dart';
import 'altimeter_controller.dart';
import 'package:mechanicalengineering/components/custom_widgets.dart'; // Import custom widgets
import 'altimeter_styles.dart';
import 'altimeter_constants.dart';
import 'package:mechanicalengineering/theme/app_theme.dart';

class AltimeterPage extends StatefulWidget {
  const AltimeterPage({super.key});

  @override
  State<AltimeterPage> createState() => _AltimeterPageState();
}

class _AltimeterPageState extends State<AltimeterPage> {
  late final AltimeterController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AltimeterController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  List<DropdownMenuItem<String>> _buildDropdownItems(List<String> units) {
    return units
        .map(
          (unit) => DropdownMenuItem<String>(
            value: unit,
            child: Text(
              unit,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.dropdownText,
              ),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Altimeter"),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, child) {
          // Show error message if any
          if (_controller.errorMessage != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showErrorSnackBar(context, _controller.errorMessage!);
              _controller.clearError();
            });
          }

          return _buildContent();
        },
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.md,
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BorderRadii.xxLarge),
        ),
        elevation: 10,
        shadowColor: AppColors.primary50,
        color: AppColors.card,
        child: Padding(
          padding: const EdgeInsets.all(Spacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: Spacing.sm),

              if (_controller.isUsingSimulatedData) _buildSimulatedDataBanner(),

              const SizedBox(height: Spacing.lg),
              _buildElevationCard(),
              const SizedBox(height: Spacing.lg),
              _buildPressureCard(),
              const SizedBox(height: Spacing.xl),

              if (_controller.locationData != null) _buildLocationInfo(),

              if (_controller.locationData != null)
                const SizedBox(height: Spacing.lg),

              _buildRefreshButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(Spacing.md),
          decoration: BoxDecoration(
            color: AppColors.primary10,
            borderRadius: BorderRadius.circular(BorderRadii.medium),
          ),
          child: const Icon(
            Icons.terrain_rounded,
            color: AppColors.primary,
            size: 32,
          ),
        ),
        const SizedBox(width: Spacing.md),
        Expanded(
          child: Text(
            'Elevation Reader',
            style: TextStyles.header,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildSimulatedDataBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: Spacing.xs,
        horizontal: Spacing.sm,
      ),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(BorderRadii.small),
        border: Border.all(color: Colors.orange.shade200, width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 16, color: Colors.orange.shade700),
          const SizedBox(width: Spacing.xs),
          Expanded(
            child: Text(
              'Barometer unavailable - Using simulated data',
              style: TextStyle(
                fontSize: 12,
                color: Colors.orange.shade900,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildElevationCard() {
    return _buildDataCard(
      icon: Icons.terrain_rounded,
      title: 'Current Elevation',
      value: _controller.rawPressureHpa == 0.0
          ? '---'
          : _controller.displayedElevation.toStringAsFixed(2),
      unit: _controller.elevationUnit,
      units: kElevationUnits,
      onUnitChanged: (newUnit) {
        if (newUnit != null) _controller.setElevationUnit(newUnit);
      },
    );
  }

  Widget _buildPressureCard() {
    return _buildDataCard(
      icon: Icons.speed_rounded,
      title: 'Atmospheric Pressure',
      value: _controller.rawPressureHpa == 0.0
          ? '---'
          : _controller.displayedVacuum.toStringAsFixed(2),
      unit: _controller.vacuumUnit,
      units: kVacuumUnits,
      onUnitChanged: (newUnit) {
        if (newUnit != null) _controller.setVacuumUnit(newUnit);
      },
    );
  }

  Widget _buildDataCard({
    required IconData icon,
    required String title,
    required String value,
    required String unit,
    required List<String> units,
    required ValueChanged<String?> onUnitChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(BorderRadii.large),
        border: Border.all(color: AppColors.primary30, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.label),
              const SizedBox(width: Spacing.xs),
              Expanded(
                child: Text(
                  title,
                  style: TextStyles.subheader,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 2,
                child: Text(
                  value,
                  style: TextStyles.value,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: Spacing.xs),
              Flexible(
                flex: 1,
                child: SizedBox(
                  width: 120,
                  // USING CUSTOM DROPDOWN WIDGET
                  child: CustomDropdown<String>(
                    value: unit,
                    items: _buildDropdownItems(units),
                    onChanged: onUnitChanged,
                    borderRadius: BorderRadii.small,
                    height: 40,
                    backgroundColor: AppColors.dropdownBackground,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationInfo() {
    final lat = _controller.latitude?.toStringAsFixed(5) ?? '---';
    final lon = _controller.longitude?.toStringAsFixed(5) ?? '---';

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: Spacing.sm,
        horizontal: Spacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(BorderRadii.medium),
      ),
      child: Text(
        'Location: Lat: $lat, Lon: $lon',
        textAlign: TextAlign.center,
        style: TextStyles.label,
      ),
    );
  }

  Widget _buildRefreshButton() {
    final bool isLoading = _controller.loading;
    final String buttonText = isLoading ? 'FETCHING DATA...' : 'REFRESH';

    // USING CUSTOM BUTTON WIDGET
    return CustomButton(
      text: buttonText,
      onPressed: isLoading
          ? null
          : () {
              _controller.requestLocationAndFetchData();
            },
      backgroundColor: AppColors.primary,
      textColor: Colors.white,
      borderRadius: BorderRadii.medium,
      height: 54,
      fontSize: 16,
      uppercase: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading)
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          else
            const Icon(
              Icons.my_location_rounded,
              size: 24,
              color: Colors.white,
            ),
          const SizedBox(width: Spacing.sm),
          Flexible(
            child: Text(
              buttonText,
              style: TextStyles.button,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
