import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme.dart';
import 'package:rive/rive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;

  Artboard? _riveArtboard;
  RiveAnimationController? _controller;
  late SimpleAnimation _animation1, _animation2;
  void _playAnimation1() {
    // Remove the controller if necessary
    _riveArtboard!.removeController(_animation1);
    // Add the controller to fire the animation
    _riveArtboard!.addController(_animation1);
  }

  void _playAnimation2() {
    _riveArtboard!.removeController(_animation2);
    _riveArtboard!.addController(_animation2);
  }

  @override
  void initState() {
    super.initState();

    // Load the animation file from the bundle, note that you could also
    // download this. The RiveFile just expects a list of bytes.
    rootBundle.load('assets/house2.riv').then(
      (data) async {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
          _animation1 = SimpleAnimation('first');
          _animation2 = SimpleAnimation('last');
        artboard.addController(_controller = SimpleAnimation('idle'));
        setState(() => _riveArtboard = artboard);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Image.network(
                MediaQuery.of(context).platformBrightness == Brightness.light
                      ? "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2f/Google_2015_logo.svg/368px-Google_2015_logo.svg.png"
                      : "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4a/Logo_2013_Google.png/799px-Logo_2013_Google.png",
                  height: 146,
                  width: 200,
              ),
            ),
            Container(
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10)
                
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 0.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Container(
              height: 30,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).primaryColor
                ),
              child: Center(child: Text(
                'Search',
                ),
                ),
            ),
            SizedBox(height:20),
            Container(
              height: 300,
              width: 300,
              child: _riveArtboard == null
            ? const SizedBox()
            : Rive(artboard: _riveArtboard!),
            ),
            Padding(
          padding: const EdgeInsets.symmetric(vertical: 1),
          child: FlatButton(
            child: Text('Play Animation 1'),
            onPressed: _playAnimation1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 1),
          child: FlatButton(
            child: Text('Play Animation 2'),
            onPressed: _playAnimation2,
          ),
        ),
          ],
        ),
      
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
      onTap: (value) {
        setState(() {
          _selectedIndex = value;
        });
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
        BottomNavigationBarItem(icon: Icon(Icons.home,), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: "QR"),
      ],
      ),
    );
  }
}