import 'package:flutter/material.dart';
import 'package:njia/blocs/application_bloc.dart';
import 'package:njia/constants/app_constants.dart';
import 'package:provider/provider.dart';

class MapUserBadge extends StatelessWidget {
  const MapUserBadge({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<ApplicationBloc>(context);

    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          margin:
              const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset.zero)
              ]),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    image: const DecorationImage(
                        image: AssetImage('assets/images/avatar.jpg'),
                        fit: BoxFit.cover)),
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    autovalidateMode: AutovalidateMode.always,
                    // initialValue: ' ',
                    decoration:
                        const InputDecoration(hintText: 'Search by place name'),
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Please enter some text';
                    //   }
                    // },
                    onChanged: (value) => applicationBloc.searchPlaces(value),
                  )
                ],
              )),
              Icon(
                Icons.search,
                color: mainHexColor,
                size: 40,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
