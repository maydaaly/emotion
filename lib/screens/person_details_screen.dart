import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/person_details_provider.dart';
import 'full_screen_image_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class PersonDetailsScreen extends StatelessWidget {
  final int personId;

  const PersonDetailsScreen({Key? key, required this.personId}) : super(key: key);

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $urlString';
    }
  }

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
              indicatorColor: Colors.purple,
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
                      children: [
                        if (provider.personDetails != null) ...[
                          Wrap(
                            spacing: 16,
                            runSpacing: 12,
                            children: [
                              _buildDetailRow('Name', provider.personDetails!.name),
                              _buildDetailRow('Biography', provider.personDetails!.biography),
                              _buildDetailRow('Birthday', provider.personDetails!.birthday),
                              _buildDetailRow('Place of Birth', provider.personDetails!.placeOfBirth),
                              _buildDetailRow('Gender', _genderToString(provider.personDetails!.gender)),
                              _buildDetailRow('Known For', provider.personDetails!.knownForDepartment),
                              _buildDetailRow('Popularity', provider.personDetails!.popularity.toString()),
                              if (provider.personDetails!.homepage != null)
                                _buildDetailRow('Homepage', provider.personDetails!.homepage, isLink: true),
                            ],
                          ),
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
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullScreenImageScreen(
                                imageUrl: 'https://image.tmdb.org/t/p/original$image',
                              ),
                            ),
                          );
                        },
                        child: CachedNetworkImage(
                          imageUrl: 'https://image.tmdb.org/t/p/w500$image',
                          placeholder: (context, url) => const CircularProgressIndicator(),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                          fit: BoxFit.cover,
                        ),
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

  Widget _buildDetailRow(String title, String? value, {bool isLink = false}) {
    if (value == null || value.isEmpty) {
      return SizedBox.shrink(); // to not show anything for null or empty values
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(_getIconForDetail(title), size: 24, color: Colors.orange.shade600),
          const SizedBox(width: 10),
          Expanded(
            child: isLink
                ? GestureDetector(
              onTap: () => _launchUrl(value),
              child: Text(
                value,
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
                : RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$title: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontFamily: 'Sans-serif',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForDetail(String title) {
    switch (title) {
      case 'Name':
        return Icons.person;
      case 'Biography':
        return Icons.info;
      case 'Birthday':
        return Icons.cake;
      case 'Place of Birth':
        return Icons.location_on;
      case 'Gender':
        return Icons.transgender;
      case 'Known For':
        return Icons.star;
      case 'Popularity':
        return Icons.trending_up;
      case 'Homepage':
        return Icons.link;
      default:
        return Icons.info;
    }
  }

  String _genderToString(int gender) {
    switch (gender) {
      case 1:
        return 'Female';
      case 2:
        return 'Male';
      default:
        return 'Other';
    }
  }
}
