import 'package:aluga_comigo/app/modules/config/ui/controllers/profile_controller.dart';
import 'package:aluga_comigo/app/modules/customer/data/models/customer_model.dart';
import 'package:aluga_comigo/app/shared/domain/consts/cities_and_states.dart';
import 'package:aluga_comigo/app/shared/presenter/formatters/cep_formatter.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

/// Campos do imóvel exibidos no [HouseFlipCard] (verso e frente).
class ProfileImmobileExtendedFields extends StatefulWidget {
  final IProfileController controller;
  final ImmobileCustomerModel customer;

  const ProfileImmobileExtendedFields({
    super.key,
    required this.controller,
    required this.customer,
  });

  @override
  State<ProfileImmobileExtendedFields> createState() =>
      _ProfileImmobileExtendedFieldsState();
}

class _ProfileImmobileExtendedFieldsState
    extends State<ProfileImmobileExtendedFields> {
  final _cepController = TextEditingController();
  String? _boundCustomerId;
  String? _selectedState;
  String? _selectedCity;
  List<String> _availableCities = [];

  IProfileController get controller => widget.controller;

  ImmobileCustomerModel get customer =>
      controller.customer is ImmobileCustomerModel
      ? controller.customer! as ImmobileCustomerModel
      : widget.customer;

  @override
  void dispose() {
    _cepController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ProfileImmobileExtendedFields oldWidget) {
    super.didUpdateWidget(oldWidget);
    _bindIfNeeded(customer);
  }

  void _bindIfNeeded(ImmobileCustomerModel c) {
    if (_boundCustomerId == c.id) return;
    _boundCustomerId = c.id;
    _cepController.text = c.cep;
    _parseCityState(c.cityState);
  }

  void _parseCityState(String cityState) {
    if (cityState.isEmpty) {
      _selectedState = null;
      _selectedCity = null;
      _availableCities = [];
      return;
    }
    final idx = cityState.lastIndexOf(' - ');
    if (idx <= 0) return;
    _selectedCity = cityState.substring(0, idx).trim();
    _selectedState = cityState.substring(idx + 3).trim();
    _loadCitiesForState(_selectedState);
    if (!_availableCities.contains(_selectedCity) && _selectedCity!.isNotEmpty) {
      _availableCities = [..._availableCities, _selectedCity!];
    }
  }

  void _loadCitiesForState(String? stateSigla) {
    if (stateSigla == null || stateSigla.isEmpty) {
      _availableCities = [];
      return;
    }
    Map<String, dynamic>? stateData;
    for (final state in estatesCitiesMap) {
      if (state['sigla'] == stateSigla) {
        stateData = state;
        break;
      }
    }
    _availableCities = List<String>.from(stateData?['cidades'] ?? const []);
  }

  void _patchCityState() {
    final city = _selectedCity ?? '';
    final state = _selectedState ?? '';
    final cityState = city.isNotEmpty && state.isNotEmpty
        ? '$city - $state'
        : '';
    controller.patchImmobile((c) => c.copyWith(cityState: cityState));
    controller.updatePage();
  }

  TextStyle get _labelStyle => GoogleFonts.rubik(
    fontWeight: FontWeight.w500,
    fontSize: 16,
  );

  InputDecoration _fieldDecoration() => InputDecoration(
    border: InputBorder.none,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  );

  BoxDecoration get _fieldBox => BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    color: const Color(0xFFEFEFEF),
  );

  Widget _sectionDivider(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Expanded(child: Divider(thickness: 2)),
          Gap(8),
          Text(title, style: GoogleFonts.rubik(fontWeight: FontWeight.w500)),
          Gap(8),
          const Expanded(child: Divider(thickness: 2)),
        ],
      ),
    );
  }

  Widget _counterRow({
    required String label,
    required int value,
    required ValueChanged<int> onChanged,
  }) {
    return Row(
      children: [
        Expanded(child: Text(label, style: _labelStyle)),
        IconButton(
          onPressed: value > 0 ? () => onChanged(value - 1) : null,
          icon: const Icon(Icons.remove_circle_outline),
        ),
        Text('$value', style: GoogleFonts.rubik(fontSize: 16)),
        IconButton(
          onPressed: value < 99 ? () => onChanged(value + 1) : null,
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }

  Widget _nearbyChip({
    required String label,
    required bool selected,
    required VoidCallback onToggle,
  }) {
    return FilterChip(
      label: Text(label, style: GoogleFonts.rubik(fontSize: 13)),
      selected: selected,
      onSelected: (_) => onToggle(),
      showCheckmark: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    _bindIfNeeded(customer);
    final c = customer;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('CEP', style: _labelStyle),
        const Gap(8),
        Container(
          decoration: _fieldBox,
          child: TextFormField(
            controller: _cepController,
            keyboardType: TextInputType.number,
            inputFormatters: [CepFormatter()],
            style: GoogleFonts.rubik(fontWeight: FontWeight.w500, fontSize: 16),
            onChanged: (value) {
              controller.patchImmobile((imm) => imm.copyWith(cep: value));
            },
            decoration: _fieldDecoration(),
          ),
        ),
        const Gap(16),
        Text('Estado', style: _labelStyle),
        const Gap(8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: _fieldBox,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedState,
              hint: Text('Selecione', style: GoogleFonts.rubik()),
              items: estatesCitiesMap.map((state) {
                final sigla = state['sigla'] as String;
                return DropdownMenuItem(
                  value: sigla,
                  child: Text('$sigla - ${state['nome']}'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedState = value;
                  _selectedCity = null;
                  _loadCitiesForState(value);
                });
                _patchCityState();
              },
            ),
          ),
        ),
        const Gap(16),
        Text('Cidade', style: _labelStyle),
        const Gap(8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: _fieldBox,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _availableCities.contains(_selectedCity)
                  ? _selectedCity
                  : null,
              hint: Text(
                _selectedState == null ? 'Selecione o estado' : 'Selecione',
                style: GoogleFonts.rubik(),
              ),
              items: _availableCities.map((city) {
                return DropdownMenuItem(value: city, child: Text(city));
              }).toList(),
              onChanged: _selectedState == null
                  ? null
                  : (value) {
                      setState(() => _selectedCity = value);
                      _patchCityState();
                    },
            ),
          ),
        ),
        _sectionDivider('Interior da casa'),
        _counterRow(
          label: 'Banheiros',
          value: c.bathrooms,
          onChanged: (v) {
            controller.patchImmobile((imm) => imm.copyWith(bathrooms: v));
            controller.updatePage();
          },
        ),
        _counterRow(
          label: 'Quartos',
          value: c.bedrooms,
          onChanged: (v) {
            controller.patchImmobile((imm) => imm.copyWith(bedrooms: v));
            controller.updatePage();
          },
        ),
        _counterRow(
          label: 'Vagas na garagem',
          value: c.carSpaces,
          onChanged: (v) {
            controller.patchImmobile((imm) => imm.copyWith(carSpaces: v));
            controller.updatePage();
          },
        ),
        _sectionDivider('Locais próximos'),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            _nearbyChip(
              label: 'Hospital',
              selected: c.isHospitalNear,
              onToggle: () {
                controller.patchImmobile(
                  (imm) => imm.copyWith(isHospitalNear: !imm.isHospitalNear),
                );
                controller.updatePage();
              },
            ),
            _nearbyChip(
              label: 'Mercado',
              selected: c.isMarketNear,
              onToggle: () {
                controller.patchImmobile(
                  (imm) => imm.copyWith(isMarketNear: !imm.isMarketNear),
                );
                controller.updatePage();
              },
            ),
            _nearbyChip(
              label: 'Faculdade',
              selected: c.isSchoolNear,
              onToggle: () {
                controller.patchImmobile(
                  (imm) => imm.copyWith(isSchoolNear: !imm.isSchoolNear),
                );
                controller.updatePage();
              },
            ),
            _nearbyChip(
              label: 'Parque',
              selected: c.isParkNear,
              onToggle: () {
                controller.patchImmobile(
                  (imm) => imm.copyWith(isParkNear: !imm.isParkNear),
                );
                controller.updatePage();
              },
            ),
            _nearbyChip(
              label: 'Academia',
              selected: c.isGymNear,
              onToggle: () {
                controller.patchImmobile(
                  (imm) => imm.copyWith(isGymNear: !imm.isGymNear),
                );
                controller.updatePage();
              },
            ),
            _nearbyChip(
              label: 'Shopping',
              selected: c.isMallNear,
              onToggle: () {
                controller.patchImmobile(
                  (imm) => imm.copyWith(isMallNear: !imm.isMallNear),
                );
                controller.updatePage();
              },
            ),
            _nearbyChip(
              label: 'Praia',
              selected: c.isBeachNear,
              onToggle: () {
                controller.patchImmobile(
                  (imm) => imm.copyWith(isBeachNear: !imm.isBeachNear),
                );
                controller.updatePage();
              },
            ),
          ],
        ),
        const Gap(8),
      ],
    );
  }
}
