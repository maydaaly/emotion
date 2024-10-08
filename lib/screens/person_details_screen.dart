import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/person_details_provider.dart';

class PersonDetailsScreen extends StatelessWidget {
  final int personId;

  const PersonDetailsScreen({Key? key, required this.personId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PersonDetailsProvider()..fetchPersonDetails(personId),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Person Details'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Info'),
                Tab(text: 'Images'),
              ],
            ),
          ),
          body: Consumer<PersonDetailsProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (provider.error != null) {
                return Center(child: Text('Error: ${provider.error}'));
              }

              return TabBarView(
                children: [
                  // First tab - Info
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (provider.personDetails != null) ...[
                          Text('Name: ${provider.personDetails!.name}', style: TextStyle(fontSize: 18)),
                          const SizedBox(height: 8),
                          Text('Biography: ${provider.personDetails!.biography}'),
                          const SizedBox(height: 8),
                          Text('Birthday: ${provider.personDetails!.birthday}'),
                          const SizedBox(height: 8),
                          Text('Place of Birth: ${provider.personDetails!.placeOfBirth}'),
                        ] else ...[
                          const Text('No details available'),
                        ],
                      ],
                    ),
                  ),

                  // Second tab - Images
                  GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0,
                    ),
                    itemCount: provider.personImages.length,
                    itemBuilder: (context, index) {
                      final image = provider.personImages[index];
                      return CachedNetworkImage(
                        imageUrl: 'https://image.tmdb.org/t/p/w500$image',
                        placeholder: (context, url) => const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
