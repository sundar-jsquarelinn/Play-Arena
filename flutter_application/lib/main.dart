import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const WebEntryPage(),
    );
  }
}




class WebEntryPage extends StatefulWidget {
  const WebEntryPage({super.key});

  @override
  State<WebEntryPage> createState() => _WebEntryPageState();
}

class _WebEntryPageState extends State<WebEntryPage> {
  String? _selectedValue1;
  String? _selectedValue2;
  String? _selectedValue3;
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final bool isMobile = screenWidth < 768;
    final double screenHeight=MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        
        // We use the title widget to build a custom responsive layout row
        backgroundColor: isMobile ? Colors.transparent : Colors.white,
        elevation: 0,
        title: Row(
          children: [
            // 1. LEFT SIDE: Logo & Brand Title
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/Badge.png', height: 40),
                ),
                const SizedBox(width: 50),
              ],
            ),

            // 2. CENTER: Dropdowns (Expanded pushes this group to take up all middle space)
            if (!isMobile)
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Dropdown 1: Sports
                    SizedBox(
                      width: 110,
                      child: _buildAppBarDropdown(
                        hintText: "Sports",
                        value: _selectedValue1,
                        items: const ['Cricket', 'Football', 'Basketball'],
                        onChanged: (val) =>
                            setState(() => _selectedValue1 = val),
                      ),
                    ),
                    const SizedBox(width: 20),

                    // Dropdown 2: Venues
                    SizedBox(
                      width: 110,
                      child: _buildAppBarDropdown(
                        hintText: "Venues",
                        value: _selectedValue2,
                        items: const ['Stadiums', 'Arena', 'Indoor Courts'],
                        onChanged: (val) =>
                            setState(() => _selectedValue2 = val),
                      ),
                    ),
                    const SizedBox(width: 20),

                    // Dropdown 3: Events
                    SizedBox(
                      width: 110,
                      child: _buildAppBarDropdown(
                        hintText: "Events",
                        value: _selectedValue3,
                        items: const [
                          'Tournaments',
                          'Find Players',
                          'Find Teams',
                        ],
                        onChanged: (val) =>
                            setState(() => _selectedValue3 = val),
                      ),
                    ),
                  ],
                ),
              ),
            
            // 3. RIGHT SIDE: Auth Buttons
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text("Login"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/registration');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4F46E5),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Get Started"),
                ),
              ],
            ),
          ],
        ),
      ),

      body: Stack(
        alignment: Alignment.center,
        children: [
          // 1. The Background Video Player Component
          const Positioned.fill(
            child: _BackgroundVideoPlayer(assetPath: 'assets/video.mp4'),
          ),

          // 2. Translucent Overlay Matrix (Optional: darkens video for text readability)
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.7)),
          ),

          // 3. Foreground Contents
          SafeArea(
            child: Center(
              child: SingleChildScrollView( // Prevents bottom overflow on smaller devices
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Fixed 'EdgeInsetsGeometry.all' compile errors to 'EdgeInsets.all'
                    const Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        "Play More. Connect Better. Win Together.",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    
                    Container(
                      // color: Colors.white,
                      width:isMobile ? screenWidth*0.90 :screenWidth*0.50,
                    child:Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        "Discover venues, book games, join tournaments and connect with players — all on one platform built for the sports community.",
                        style: TextStyle(fontSize: 20, color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                    )
                    ),
                    SizedBox(
                    width: 500.0,
                    height: screenHeight*0.15,
                    child: Padding(
                      padding: EdgeInsetsGeometry.all(15),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "search venue, games",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.search),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 8.0,
                          ),
                          suffixIcon: 
                          Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Text("Search"),
                              style: ElevatedButton.styleFrom(
                                // padding: EdgeInsets.symmetric(horizontal: 36.0, vertical: 24.0),
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                elevation: 0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                    // Padding(
                      // padding: const EdgeInsets.all(15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: 30.0,
                                vertical: 18.0
                              ),
                              backgroundColor: const Color(0xFF00B066),
                              foregroundColor: Colors.black,
                            ),
                            child: const Text("Explore Venues"),
                          ),
                          const SizedBox(width: 12.0),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: 30.0,
                                vertical: 18.0
                              ),
                              backgroundColor: const Color(0xFF00B066),
                              foregroundColor: Colors.black,
                            ),
                            child: const Text("Find Tournaments"),
                          )
                        ],
                      ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildAppBarDropdown({
  required String hintText,
  required String? value,
  required List<String> items,
  required ValueChanged<String?> onChanged,
}) {
  return PopupMenuButton<String>(
    // offset pushes the dropdown list completely down below the bar menu
    offset: const Offset(0, 45),
    onSelected: onChanged,

    // Custom visual design for the button layout on the AppBar
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white, // subtle background fill
        border: Border.all(color: Colors.white30),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              value ?? hintText, // If selection is null, display hint text
              style: TextStyle(
                color: value == null
                    ? Colors.black
                    : Colors.black, // color of the text in the dropdown button
                fontWeight: value == null ? FontWeight.bold : FontWeight.bold,
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Icon(Icons.arrow_drop_down, color: Colors.black, size: 20),
        ],
      ),
    ),

    // Builds the actual items that show up in the pop-down menu list
    itemBuilder: (BuildContext context) {
      return items.map((String item) {
        return PopupMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: const TextStyle(
              color: Colors.black,
            ), // color inside list menu
          ),
        );
      }).toList();
    },
  );
}

class _BackgroundVideoPlayer extends StatefulWidget {
  final String assetPath;
  const _BackgroundVideoPlayer({required this.assetPath});

  @override
  State<_BackgroundVideoPlayer> createState() => _BackgroundVideoPlayerState();
}

class _BackgroundVideoPlayerState extends State<_BackgroundVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.assetPath)
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _controller.setLooping(true);
        _controller.setVolume(
          0.0,
        ); // Background atmospheric loops must be silent
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Container(); // Keeps background black while spinning up
    }
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover, // Crops and fits video seamlessly full-screen
        child: SizedBox(
          width: _controller.value.size.width,
          height: _controller.value.size.height,
          child: VideoPlayer(_controller),
        ),
      ),
    );
  }
}
