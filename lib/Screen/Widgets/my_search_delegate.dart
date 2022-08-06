import 'package:flutter/material.dart';

class MySearchDelegate extends SearchDelegate {
  List<String> searchResuls = [];
  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
            onPressed: () {
              if (query.isEmpty) {
                close(context, null);
              } else {
                query = '';
              }
            },
            icon: const Icon(Icons.clear_rounded))
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back_ios_new_rounded));

  @override
  Widget buildResults(BuildContext context) {
    Future.delayed(Duration.zero, () {
      close(context, query);
    });
    return Text(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = ['sanaa', 'aden', 'istanbul'];

    return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];

          return ListTile(
            title: Text(suggestion),
            onTap: () {
              query = suggestion;
              close(context, suggestion);
              //  showResults(context);
            },
          );
        });
  }
}
