import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late WebSocketChannel channel;
  Map<String, dynamic>? tickerData;

  @override
  void initState() {
    super.initState();

    // Establish WebSocket connection
    channel = WebSocketChannel.connect(
      Uri.parse('ws://prereg.ex.api.ampiy.com/prices'),
    );

    // Subscribe to the ticker data
    channel.sink.add(json.encode({
      "method": "SUBSCRIBE",
      "params": ["all@ticker"],
      "cid": 1
    }));

    // Listen to the data stream
    channel.stream.listen((data) {
      final parsedData = json.decode(data);
      print('recieved data:$parsedData');

      // Update the tickerData with the incoming data
      setState(() {
        tickerData = parsedData;
      });
    },
    onError: (error){
      print('$error');
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(preferredSize: Size.fromHeight(kToolbarHeight + 20),
       child: Padding(padding: EdgeInsets.only(top: 20),
       child: AppBar(
        centerTitle: true,
        title: Text('Welcome to AMPIY' , style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 27,
        ),
        ),
      ),
       ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Text('Buy Your First Crypto Assest Today', style: TextStyle(
            fontSize: 18
          ),
          ),
          ),
        Padding(
          padding: const EdgeInsets.only(top: 35.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(onPressed: (){},
                   icon: Icon(Icons.add_circle),
                      iconSize: 40,
                       ),
                Text('Buy'),
                 
                ],      
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(onPressed: (){},
                   icon: Icon(Icons.remove_circle),
                      iconSize: 40,
                       ),
                Text('Sell'),
                 
                ],      
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(onPressed: (){},
                   icon: Icon(Icons.person),
                      iconSize: 40,
                       ),
                Text('Referral'),
                 
                ],      
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(onPressed: (){},
                   icon: Icon(Icons.video_collection_rounded),
                      iconSize: 40,
                       ),
                Text('Tutorial'),
                 
                ],      
              ),
              
            ],
          ),
        ),
      
      SizedBox(height: 30),
      Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Text('Coins',style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold
        ),
        ),
      ),

      Padding(
        padding: const EdgeInsets.all(6.0),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            )
          ),   
        ),
      ),
     Expanded(
  child: tickerData != null && tickerData!['data'] != null
      ? ListView.builder(
          itemCount: tickerData!['data'].length,
          itemBuilder: (context, index) {
            final crypto = tickerData!['data'][index];
            return cryptoTile(
              icon: Icons.currency_bitcoin,
              name: crypto['s'],
              abbreviation: crypto['s'],
              price: crypto['c'],
              change: crypto['p'],
              changeColor: double.parse(crypto['p']) >= 0 ? Colors.green : Colors.red,
            );
          },
        )
      : Center(
          child: Text('No data available'),
        ),
),

      ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horizontal_circle_outlined,
            size: 55,
            color: Colors.blue,)
            ,
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
          type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

class cryptoTile extends StatelessWidget{
 final IconData icon;
 final String name;
 final String abbreviation;
 final String price;
 final String change;
 final Color changeColor;

 cryptoTile({
  required this.icon,
  required this.name,
  required this.abbreviation,
  required this.price,
  required this.change,
  required this.changeColor,

 });

 @override
 Widget build(BuildContext context){
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: ListTile(
      leading: CircleAvatar(
        child: Icon(icon , color:Colors.white ),
        backgroundColor: Colors.orange,
      ),
      title: Text(abbreviation),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(price,style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(change,style: TextStyle(color: changeColor),
          ),
        ],
      ),
    ),
  );
 }
}