import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';
import '../viewmodels/units_vm.dart';
import '../models/campus_unit.dart';

class UnitsScreen extends StatefulWidget {
  const UnitsScreen({super.key});

  @override
  State<UnitsScreen> createState() => _UnitsScreenState();
}

class _UnitsScreenState extends State<UnitsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UnitsViewModel>(context, listen: false).loadUnits();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Câmpus da UTFPR'),
      ),
      body: Consumer<UnitsViewModel>(
        builder: (context, vm, child) {
          if (vm.state == UnitsLoadingState.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.state == UnitsLoadingState.error) {
            return Center(
                child: Text(vm.errorMessage ?? 'Erro ao carregar unidades'));
          }

          if (vm.units.isEmpty) {
            return const Center(child: Text('Nenhuma unidade encontrada.'));
          }

          return RefreshIndicator(
            onRefresh: () => vm.loadUnits(),
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: vm.units.length,
              itemBuilder: (context, index) {
                return _buildUnitCard(vm.units[index]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildUnitCard(CampusUnit unit) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              unit.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(child: Text(unit.address)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.phone, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(unit.phone.isEmpty ? 'Sem telefone' : unit.phone),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () async {
                    if (unit.phone.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Telefone não disponível')),
                      );
                      return;
                    }

                    final phoneParams =
                        unit.phone.replaceAll(RegExp(r'[^0-9+]'), '');
                    final url = Uri.parse('tel:$phoneParams');

                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Não foi possível abrir o discador.')),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.phone),
                  label: const Text('Ligar'),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: () async {
                    try {
                      final lat = double.parse(unit.lat.replaceAll(',', '.'));
                      final lng = double.parse(unit.long.replaceAll(',', '.'));
                      final title = unit.name;

                      final availableMaps = await MapLauncher.installedMaps;

                      if (availableMaps.isEmpty) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Nenhum aplicativo de mapas instalado.')),
                          );
                        }
                        return;
                      }

                      if (availableMaps.length == 1) {
                        await availableMaps.first.showMarker(
                          coords: Coords(lat, lng),
                          title: title,
                        );
                        return;
                      }

                      if (context.mounted) {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return SafeArea(
                              child: SingleChildScrollView(
                                child: Wrap(
                                  children: <Widget>[
                                    for (var map in availableMaps)
                                      ListTile(
                                        onTap: () {
                                          map.showMarker(
                                            coords: Coords(lat, lng),
                                            title: title,
                                          );
                                          Navigator.pop(context);
                                        },
                                        title: Text(map.mapName),
                                        leading: const Icon(Icons.map),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Erro ao abrir o mapa.')),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.map),
                  label: const Text('Mapa'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
