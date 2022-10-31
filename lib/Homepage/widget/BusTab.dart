import 'package:flutter/material.dart';


class BusTab extends StatelessWidget {
  const BusTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: ListView.builder(
          itemCount: 10,
          itemBuilder: ((context, index) => Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.all(8),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Bus Station',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black45)),
                      Text('2.25 km',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(color: Colors.black45)),
                    ],
                  ),
                ),
              ))),
    );
  }
}
