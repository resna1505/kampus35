import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kampus/shared/theme.dart';
import 'package:kampus/ui/widgets/build_absence.dart';
import 'package:kampus/ui/widgets/build_academy.dart';
import 'package:kampus/ui/widgets/build_accounts.dart';
import 'package:kampus/ui/widgets/build_campus_news.dart';
import 'package:kampus/ui/widgets/build_explore.dart';
import 'package:kampus/ui/widgets/build_profile.dart';
import 'package:kampus/ui/widgets/build_schedule.dart';
import 'package:kampus/services/chat_provider.dart';
import 'package:kampus/ui/widgets/chat_tile.dart';
import 'package:kampus/ui/widgets/search_screen.dart';
import 'package:provider/provider.dart';

class HomePageMahasiswa extends StatefulWidget {
  const HomePageMahasiswa({super.key});

  @override
  State<HomePageMahasiswa> createState() => _HomePageMahasiswaState();
}

class _HomePageMahasiswaState extends State<HomePageMahasiswa> {
  int _currentIndex = 0;
  String qrResult = "";

  final _auth = FirebaseAuth.instance;
  User? loggedInUser;

  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    // try {
    final user = _auth.currentUser;
    if (user != null) {
      loggedInUser = user;
    }
    // } catch (e) {
    //   print(e);
    // }
  }

  Future<Map<String, dynamic>> _fetchChatData(String chatId) async {
    final chatDoc =
        await FirebaseFirestore.instance.collection('chats').doc(chatId).get();
    final chatData = chatDoc.data();
    final users = chatData!['users'] as List<dynamic>?;
    final receiverId = users!.firstWhere((id) => id != loggedInUser!.uid);
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .get();
    final userData = userDoc.data()!;
    return {
      'chatId': chatId,
      'lastMessage': chatData['lastMessage'] ?? 'No messages yet',
      'timestamp': chatData['timestamp']?.toDate() ?? DateTime.now(),
      'userData': userData,
    };
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      backgroundColor: lightBackgroundColor,
      bottomNavigationBar: BottomAppBar(
        // color: whiteColor,
        // shape: const CircularNotchedRectangle(),
        // clipBehavior: Clip.antiAlias,
        // notchMargin: 6,
        // elevation: 0,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: whiteColor,
          elevation: 0,
          selectedItemColor: purpleColor,
          unselectedItemColor: greyColor,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: blueTextStyle.copyWith(
            fontSize: 10,
            fontWeight: medium,
          ),
          unselectedLabelStyle: blackTextStyle.copyWith(
            fontSize: 10,
            fontWeight: medium,
          ),
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/ic_home.png',
                width: 25,
                color: _currentIndex == 0 ? purpleColor : greyColor,
              ),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/ic_explore.png',
                width: 25,
                color: _currentIndex == 1 ? purpleColor : greyColor,
              ),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.qr_code_scanner,
                color: _currentIndex == 2 ? purpleColor : greyColor,
                size: 30,
              ),
              label: 'absence',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/ic_chat.png',
                width: 25,
                color: _currentIndex == 3 ? purpleColor : greyColor,
              ),
              label: 'Chats',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/ic_account.png',
                width: 25,
                color: _currentIndex == 4 ? purpleColor : greyColor,
              ),
              label: 'Account',
            ),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            // if (index == 1) {
            //   Navigator.pushNamed(context, '/learning-progress');
            // }
          },
        ),
      ),
      body: ListView(
        children: [
          if (_currentIndex == 0) ...[
            const BuildProfile(),
            const BuildSchedule(),
            const BuildAcademy(),
            const BuildCampusNews(),

            // buildCampusNews(context),
            // buildSchedule(),
            // buildToDo(context),
            // buildAcademy(context),
            // buildProfile(context),
          ],
          if (_currentIndex == 1) ...[
            const BuildExplore(),
            // buildExplore(context),
          ],
          if (_currentIndex == 2) ...[
            const BuildAbsence(),
          ],
          if (_currentIndex == 3) ...[
            WillPopScope(
              onWillPop: () async => true,
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: greyDarkColor,
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Chats',
                          style: blackTextStyle.copyWith(
                              fontSize: 22, fontWeight: bold),
                        ),
                      ),
                    ),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: loggedInUser != null
                            ? chatProvider.getChats(loggedInUser!.uid)
                            : const Stream.empty(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final chatDocs = snapshot.data!.docs;

                          return FutureBuilder<List<Map<String, dynamic>>>(
                            future: Future.wait(
                              chatDocs.map(
                                (chatDoc) async {
                                  final chatData =
                                      await _fetchChatData(chatDoc.id);
                                  return chatData;
                                },
                              ),
                            ),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              final chatDataList = snapshot.data!;

                              return ListView.builder(
                                itemCount: chatDataList.length,
                                itemBuilder: (context, index) {
                                  final chatData = chatDataList[index];

                                  return ChatTile(
                                    chatId: chatData['chatId'],
                                    lastMessage: chatData['lastMessage'],
                                    timestamp: chatData['timestamp'],
                                    receiverData: chatData['userData'],
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (_currentIndex == 4) ...[
            const BuildAccounts(),
            // buildAccounts(context),
          ],
        ],
      ),
      floatingActionButton: _currentIndex == 3
          ? FloatingActionButton(
              backgroundColor: blueDarkColor,
              foregroundColor: whiteColor,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchScreen(),
                  ),
                );
              },
              child: const Icon(Icons.border_color_sharp),
            )
          : null,
      // body: tabs[_currentIndex],
    );
  }

  // Widget buildToDo(BuildContext context) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 24),
  //     decoration: BoxDecoration(
  //       color: whiteColor,
  //     ),
  //     child: Column(
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Row(
  //                   children: [
  //                     Container(
  //                       width: 24,
  //                       height: 24,
  //                       decoration: BoxDecoration(
  //                         shape: BoxShape.circle,
  //                         color: redColor,
  //                       ),
  //                       child: Center(
  //                         child: Text(
  //                           '1',
  //                           style: whiteTextStyle.copyWith(
  //                             fontSize: 12,
  //                             fontWeight: medium,
  //                             color: whiteColor,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     const SizedBox(
  //                       width: 4,
  //                     ),
  //                     Text(
  //                       'My To-Do',
  //                       style: blackTextStyle.copyWith(
  //                         fontSize: 16,
  //                         fontWeight: semiBold,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(
  //                   height: 4,
  //                 ),
  //                 Text(
  //                   'This is your personal to-do list',
  //                   style: greyTextStyle.copyWith(
  //                     fontSize: 12,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             CustomButtonOutline(
  //               title: 'All To-Do',
  //               onTap: () {
  //                 Navigator.pushNamed(context, '/todo');
  //               },
  //             )
  //           ],
  //         ),
  //         const SizedBox(
  //           height: 8,
  //         ),
  //         Container(
  //           padding: const EdgeInsets.all(
  //             16,
  //           ),
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(16),
  //             color: whiteColor,
  //             boxShadow: const [
  //               BoxShadow(
  //                 color: Colors.grey,
  //                 blurRadius: 5.0,
  //               ),
  //             ],
  //           ),
  //           child: Column(
  //             children: [
  //               HomeToDo(
  //                 title: 'Final Quiz',
  //                 status: 'Incomplete',
  //                 date: '22th, Mar 2024',
  //                 onTap: () {},
  //               ),
  //               HomeToDo(
  //                 title: 'Semester Exam',
  //                 status: 'Completed',
  //                 date: '23th, Feb 2024',
  //                 onTap: () {},
  //               )
  //             ],
  //           ),
  //         ),
  //         const SizedBox(
  //           height: 24,
  //         )
  //       ],
  //     ),
  //   );
  // }
}
