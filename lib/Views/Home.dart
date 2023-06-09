import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:needify/Views/faq.dart';
// import 'package:needify/Views/LogOut.dart';
import 'package:needify/Views/my_purchases.dart';
import 'package:needify/Views/sold_items.dart';
import 'package:needify/Views/my_posts.dart';
import 'package:needify/Views/my_wallet.dart';
import '../reusable_widgets/UserImage.dart';
import '../reusable_widgets/round_image.dart';
import 'SignIn.dart';
import 'dashboard_needify.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final currentUser = FirebaseAuth.instance;
  var currentPage = DrawerSelections.Dashboard;


  @override
  Widget build(BuildContext context) {
    var container;
    String appBarText = "NEEDIFY";

    if(currentPage == DrawerSelections.Dashboard){
      container = Dashboard();
    }else if (currentPage == DrawerSelections.MyPosts){
      container = MyPosts();
      appBarText = "My Posts";
    } else if (currentPage == DrawerSelections.MyPurchases){
      container = LoadData();
      appBarText = "My Purchases";
    } else if (currentPage == DrawerSelections.SoldItems){
      container = SoldItems();
      appBarText = "Sold Items";
    } else if (currentPage == DrawerSelections.FAQ) {
      container = FAQFINAL();
      appBarText = "FAQ";
    }else if (currentPage == DrawerSelections.MyWallet){
      container = MyWallet();
      appBarText = "My Wallet";
    } else if (currentPage == DrawerSelections.Logout){
      FirebaseAuth.instance.signOut().then((value) {
        print("Signed Out!");
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => SignInScreen()));
      });
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Color(0xFFC52348),
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(
          appBarText,
          style: TextStyle(fontSize: 24),
        ),
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Users")
                        .where("Email", isEqualTo: currentUser.currentUser!.email)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData){
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var data = snapshot.data!.docs[index];
                              return Container(
                                //color: Color(0xFF25253D),
                                color: Color(0xFF050542),
                                width: double.infinity,
                                height: 200,
                                padding: EdgeInsets.only(top: 20,),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AppRoundImage.url(
                                        data["User image"].toString(),
                                        height: 80,
                                        width: 80
                                    ),
                                     SizedBox(
                                      height: 10,
                                     ),
                                      //Image.network(data["User image"].toString()),
                                    Text(
                                      data["Name"],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      data["Email"],
                                      style: TextStyle(
                                        color: Colors.grey[200],
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              );

                            }
                        );
                      }else{
                        return CircularProgressIndicator();
                      }
                    }),
                MyDrawerList(),
              ],
            ),
          ),
        ),
      ),
      body: container,

    );
  }

  Widget MyDrawerList() {
    return Container(
      padding: EdgeInsets.only(top: 70,),
      child: Column(
        children: [
          menuItem(1, "Dashboard", Icons.dashboard_outlined,
              currentPage == DrawerSelections.Dashboard? true : false),
          menuItem(2, "My Posts", Icons.ad_units_outlined,
              currentPage == DrawerSelections.MyPosts? true : false),
          menuItem(3, "My Purchases", Icons.shopping_bag_outlined,
              currentPage == DrawerSelections.MyPurchases? true : false),
          menuItem(4, "Sold Items", Icons.sell_outlined,
              currentPage == DrawerSelections.SoldItems? true : false),
          menuItem(5, "FAQ", Icons.question_answer,
              currentPage == DrawerSelections.FAQ? true : false),
          menuItem(6, "My Wallet", Icons.account_balance_wallet_outlined,
              currentPage == DrawerSelections.MyWallet? true : false),
          menuItem(7, "Logout", Icons.logout_outlined,
              currentPage == DrawerSelections.Logout? true : false),
        ],
      ),
    );
  }

  Widget menuItem(int id, String title, IconData icon, bool selected) {
    return Material(
      color: selected ? Colors.grey[300] : Colors.transparent,
      child: InkWell(
        onTap: (){
          Navigator.pop(context);
          setState(() {
            if (id == 1) {
              currentPage = DrawerSelections.Dashboard;
            } else if (id == 2) {
              currentPage = DrawerSelections.MyPosts;
            } else if (id == 3) {
              currentPage = DrawerSelections.MyPurchases;

            } else if (id == 4) {
              currentPage = DrawerSelections.SoldItems;
            } else if (id == 5) {
              currentPage = DrawerSelections.FAQ;
            } else if (id == 6) {
              currentPage = DrawerSelections.MyWallet;

            }else if (id == 7) {
              currentPage = DrawerSelections.Logout;
            }
          });
        },
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              Expanded(
                  child: Icon(
                    icon,
                    size: 20,
                    color: Colors.black,
                  )
              ),
              Expanded(
                flex: 3,
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}

enum DrawerSelections {
  Dashboard,
  MyPosts,
  MyPurchases,
  SoldItems,
  Logout,
  FAQ,
  MyWallet
}

