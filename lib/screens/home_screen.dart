import 'package:admo_train/admob/banner/banner_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("home"),
      ),
      body: ListView.separated(
          itemCount: 100,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 120,
              color: Colors.primaries[index % 17],
            );
          },separatorBuilder: (_,index){
            if(index%3==0){
              return BannerAdWidget();
            }else{
              return Divider(thickness: 0,height: 2,);
            }
      },),
    );
  }
}
