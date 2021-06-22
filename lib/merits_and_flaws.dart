import 'package:flutter/material.dart';

enum MeritType { Physical, Mental, Social, Supernatural, Undefined }

String meritName(MeritType type) {
  switch (type) {
    case MeritType.Physical:
      return "Physical";
    case MeritType.Mental:
      return "Mental";
    case MeritType.Social:
      return "Social";
    case MeritType.Supernatural:
      return "Supernatural";
    default:
      return "Undefined";
  }
}

class Merit {
  Merit(
      {required this.name,
      this.type = MeritType.Undefined,
      this.cost = 0,
      this.description = ""});

  final String name;
  final MeritType type;
  final int cost;
  final String description;
}

class MeritWidget extends StatelessWidget {
  MeritWidget(this._merit);

  final Merit _merit;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_merit.name),
      subtitle: Text(meritName(_merit.type)),
      trailing: Text(_merit.cost.toString()),
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return SimpleDialog(
                title: Text(_merit.name),
                children: [
                  Text(
                    "Description",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text(_merit.description),
                ],
              );
            }).then((value) => null);
      },
    );
  }
}

class MeritsAndFlawsSectionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final merits = [
      MeritWidget(
        Merit(
          name: "Computer Aptitude",
          type: MeritType.Mental,
          cost: 2,
          description:
              "You are familiar with and talented in the uses of computer equipment. Other Kindred may not understand computers, but to you they are intuitive. All rolls involving computers are at -2 difficulty for you.",
        ),
      ),
    ];

    int meritSum = 0;
    for (var merit in merits) {
      meritSum += merit._merit.cost;
    }

    final flaws = [
      MeritWidget(
        Merit(
          name: "Bad Sight (1 pt.)",
          type: MeritType.Physical,
          cost: 1,
          description:
              "Your sight is defective. The difficulties of any die rolls involving the use of your eyesight are increased by two. As a one-point Flaw, this condition can be corrected with glasses or contacts.",
        ),
      ),
    ];

    int flawSum = 0;
    for (var flaw in flaws) {
      flawSum += flaw._merit.cost;
    }

    return Column(
      children: [
        Text(
          "Merits ($meritSum)",
          style: Theme.of(context).textTheme.headline4,
        ),
        Flexible(
          child: ListView(
            children: merits,
            shrinkWrap: true,
          ),
        ),
        Spacer(),
        Text(
          "Flaws ($flawSum)",
          style: Theme.of(context).textTheme.headline4,
        ),
        Flexible(
            child: ListView(
          children: flaws,
          shrinkWrap: true,
        )),
      ],
      mainAxisSize: MainAxisSize.min,
    );
  }
}
