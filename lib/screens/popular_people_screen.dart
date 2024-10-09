import 'package:emotion/screens/person_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/person_provider.dart';

class PopularPeopleScreen extends StatefulWidget {
  @override
  _PopularPeopleScreenState createState() => _PopularPeopleScreenState();
}

class _PopularPeopleScreenState extends State<PopularPeopleScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final personProvider = Provider.of<PersonProvider>(context, listen: false);
    personProvider.fetchPopularPeople();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        personProvider.fetchPopularPeople();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular People'),
      ),
      body: Consumer<PersonProvider>(
        builder: (context, personProvider, child) {
          if (personProvider.isLoading && personProvider.people.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            controller: _scrollController,
            itemCount: personProvider.people.length + 1,
            itemBuilder: (context, index) {
              if (index == personProvider.people.length) {
                return personProvider.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : SizedBox.shrink();
              }

              final person = personProvider.people[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://image.tmdb.org/t/p/w200${person.profilePath}',
                  ),
                ),
                title: Text(person.name),
                subtitle: Text('Popularity: ${person.popularity}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PersonDetailsScreen(personId: person.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
