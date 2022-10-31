import 'package:flutter/material.dart';

class MetroTab extends StatelessWidget {
  const MetroTab({super.key});

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
                      Text('Metro Station',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black45)),
                      Text('2.1 km',
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
