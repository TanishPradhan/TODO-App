import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/reusable_widgets/todo_card.dart';
import '../bloc/list_bloc/list_bloc.dart';
import '../bloc/list_bloc/list_events.dart';
import '../bloc/list_bloc/list_states.dart';
import '../models/list_model.dart';

class ListWidget extends StatefulWidget {
  const ListWidget({super.key});

  @override
  State<ListWidget> createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  Box<ListModel> listBox = Hive.box<ListModel>('todo-list');
  late ListBloc listBloc;

  // InterstitialAd? interstitialAd;

  // TODO: replace this test ad unit with your own ad unit.
  final adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-3940256099942544/4411468910';

  @override
  void initState() {
    listBloc = ListBloc();
    // loadAd();
    super.initState();
  }

  // void loadAd() async {
  //   /// Loads an interstitial ad.
  //   await InterstitialAd.load(
  //       adUnitId: adUnitId,
  //       request: const AdRequest(),
  //       adLoadCallback: InterstitialAdLoadCallback(
  //         // Called when an ad is successfully received.
  //         onAdLoaded: (ad) {
  //           debugPrint('$ad loaded.');
  //           // Keep a reference to the ad so you can show it later.
  //           interstitialAd = ad;
  //         },
  //         // Called when an ad request failed.
  //         onAdFailedToLoad: (LoadAdError error) {
  //           debugPrint('InterstitialAd failed to load: $error');
  //         },
  //       ));
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => listBloc,
      child: BlocConsumer<ListBloc, ListState>(
        listener: (context, state) {
          if (state is UpdateListState) {
            debugPrint("List Updated");
            // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("List Updated")));
          }

          if (state is RemovedListState) {
            debugPrint("Item removed from List");
          }
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Reminder List",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      // interstitialAd?.show();

                      setState(() {
                        listBloc.add(const AddListEvent());
                      });
                    },
                    child: const Icon(
                      Icons.add_circle_rounded,
                      color: Colors.blue,
                      size: 25,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 14.0,
              ),
              ValueListenableBuilder<Box>(
                valueListenable: Hive.box<ListModel>('todo-list').listenable(),
                builder: (context, box, widget) {
                  return ListView.builder(
                    itemCount: box.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return TodoCard(
                        title: box.getAt(index).title,
                        value: box.getAt(index).value,
                        index: index,
                        key: Key(box.getAt(index).title),
                      );
                    },
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
