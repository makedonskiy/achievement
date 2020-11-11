import 'package:achievement/model/achievement_model.dart';
import 'package:achievement/widgets/achievement_card.dart';
import 'package:flutter/material.dart';
import 'package:achievement/db/db_achievement.dart';

class AchievementPage extends StatefulWidget {
  @override
  _AchievementPageState createState() => _AchievementPageState();
}

class _AchievementPageState extends State<AchievementPage> {
  @override
  Widget build(BuildContext context) {
    var achievements = DbAchievement.db.getAchievements();

    return Scaffold(
        appBar: AppBar(
          title: Text('Достигатор'),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, '/create_achievement_page')
                .then((value) => setState(() {}));
          },
        ),
        body: FutureBuilder<List<AchievementModel>>(
          future: achievements,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length > 0) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      var achievement = snapshot.data[index];
                      return GestureDetector(
                          onTap: () {
                            print('onTap ${achievement.header}');
                          },
                          onLongPress: () async {
                            var id = await DbAchievement.db
                                .deleteAchievement(achievement.id);
                            print('deleteAchievement $id');
                            setState(() {});
                          },
                          child: AchievementCard(achievement));
                    });
              } else {
                return Container();
              }
            } else {
              return CircularProgressIndicator();
            }
          },
        ));
  }
}
