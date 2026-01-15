// Libraries
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Local Imports
import '../../core/const/theme.dart';
import '../../data/controllers/profile.dart';
import '../../data/models/user.dart';
import 'profile.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Usuários')),
      body: StreamBuilder<List<Profile>>(
        stream: ProfileCtrl().getAllProfiles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) return SizedBox.shrink();

          final map = snapshot.data!;

          return ListView.builder(
            itemCount: map.length,
            itemBuilder: (context, index) {
              final doc = map[index];
              if (doc.email == 'silviano339@gmail.com') return Container();

              return Card(
                margin: EdgeInsets.all(8),
                elevation: 2,
                child: ListTile(
                  leading: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: AppTheme.secondary,
                      border: Border.all(color: AppTheme.primary, width: 2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.person_2_outlined,
                        color: AppTheme.primary,
                        size: 30,
                      ),
                    ),
                  ),
                  title: Text(
                    doc.name!,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(doc.email!, style: TextStyle(fontSize: 12)),
                  onTap: () =>
                      Get.to(() => ProfilePage(prof: doc, isAdmin: true)),
                ),
              );
            },
          ); //
        },
      ),
    );
  }
}
