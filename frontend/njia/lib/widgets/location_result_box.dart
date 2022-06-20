import 'package:flutter/material.dart';
import 'package:njia/blocs/application_bloc.dart';
import 'package:provider/provider.dart';

class LocationResultBox extends StatelessWidget {
  const LocationResultBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);
    final checkResults = applicationBloc.searchResults;

    return Container(
      height: 300,
      child: Stack(
        children: [
          if (checkResults != null && checkResults.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 20, right: 20),
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(10),
                  backgroundBlendMode: BlendMode.darken),
            ),
          if (checkResults != null && checkResults.isNotEmpty)
            Container(
              height: 300,
              width: double.infinity,
              margin: const EdgeInsets.only(
                  top: 0, bottom: 10, left: 20, right: 20),
              child: ListView.builder(
                itemCount: applicationBloc.searchResults?.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      applicationBloc.searchResults![index].description,
                      style: const TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      applicationBloc.setSelectedLocation(
                          applicationBloc.searchResults![index].placeId);
                    },
                  );
                },
              ),
            )
        ],
      ),
    );
  }
}
