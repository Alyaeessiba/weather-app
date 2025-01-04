import 'package:flutter/material.dart';

class FavoriteLocationsPage extends StatelessWidget {
  final List<String> favoriteLocations;
  final String currentCity;
  final Function(String) onLocationSelected;
  final Function(String) onLocationRemoved;

  const FavoriteLocationsPage({
    super.key,
    required this.favoriteLocations,
    required this.currentCity,
    required this.onLocationSelected,
    required this.onLocationRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Locations'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
            ],
          ),
        ),
        child: favoriteLocations.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No favorite locations yet',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add locations by tapping the heart icon',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: favoriteLocations.length,
                itemBuilder: (context, index) {
                  final location = favoriteLocations[index];
                  final isCurrentCity = location == currentCity;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isCurrentCity
                            ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                            : Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: ListTile(
                          onTap: () {
                            onLocationSelected(location);
                            Navigator.pop(context);
                          },
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          leading: Icon(
                            Icons.location_on,
                            color: isCurrentCity
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).iconTheme.color,
                          ),
                          title: Text(
                            location,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: isCurrentCity
                                      ? Theme.of(context).colorScheme.primary
                                      : null,
                                  fontWeight: isCurrentCity
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.favorite,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            onPressed: () => onLocationRemoved(location),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
