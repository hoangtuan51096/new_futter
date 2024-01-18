import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/screens.dart';
import 'dart:developer';
void main() {
  runApp(MyApp());
}

class Product {
   final String name; 
   final String description; 
   final int price; 
   final String image; 
   Product(this.name, this.description, this.price, this.image); 
   
   static List<Product> getProducts() {
      List<Product> items = <Product>[]; 
      items.add(
         Product(
            "Pixel", 
            "Pixel is the most featureful phone ever", 
            800, 
            "pixel.jpg"
         )
      );
      items.add(
         Product(
            "Laptop", 
            "Laptop is most productive development tool", 
            2000, 
            "laptop.jpg"
         )
      ); 
      items.add(
         Product(
            "Tablet", 
            "Tablet is the most useful device ever for meeting", 
            1500, 
            "tablet.jpg"
         )
      ); 
      items.add(
         Product( 
            "Pendrive", 
            "iPhone is the stylist phone ever", 
            100, 
            "pendrive.jpg"
         )
      ); 
      items.add(
         Product(
            "Floppy Drive", 
            "iPhone is the stylist phone ever", 
            20, 
            "floppy.jpg"
         )
      ); 
      items.add(
         Product(
            "iPhone", 
            "iPhone is the stylist phone ever", 
            1000, 
            "iphone.jpg"
         )
      ); 
      return items; 
   }
}

class MyApp extends StatelessWidget {
  
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: MyHomePage(title: 'Product Navigation demo home page'),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var history = <WordPair>[];

  GlobalKey? historyListKey;

  void getNext() {
    history.insert(0, current);
    var animatedList = historyListKey?.currentState as AnimatedListState?;
    animatedList?.insertItem(0);
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite([WordPair? pair]) {
    pair = pair ?? current;
    if (favorites.contains(pair)) {
      favorites.remove(pair);
    } else {
      favorites.add(pair);
    }
    notifyListeners();
  }

  void removeFavorite(WordPair pair) {
    favorites.remove(pair);
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Null key, required this.title }) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  var selectedIndex = 0;
  late Animation<double> animation; 
  late AnimationController controller;

   
  @override 
  void initState() {
    super.initState(); 
    controller = AnimationController(
        duration: const Duration(seconds: 10), vsync: this); 
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller); 
    controller.forward(); 
  } 
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      case 2:
        page = ListImagesPage(animation: animation,);
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.list),
                      label: Text('List Screens'),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                )
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                )
              )
            ]
          ),
        );
      }
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var theme = Theme.of(context);

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }
    var size = MediaQuery.of(context).size;
    final double itemWidth = size.width / 2;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: (itemWidth / 100),
            children: [
              for (var pair in appState.favorites)
                ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.delete_outline, semanticLabel: 'Delete'),
                    color: theme.colorScheme.primary,
                    onPressed: () {
                      appState.removeFavorite(pair);
                    },
                  ),
                  title: Text(
                    pair.asLowerCase,
                    semanticsLabel: pair.asPascalCase,
                  )
                )
            ],
          )
        )
      ],
    );
  }
}

class ListImagesPage extends StatelessWidget {
  ListImagesPage({required this.animation});
  final Animation<double> animation; 
  @override
  Widget build(BuildContext context) {

    return ListView(
      shrinkWrap: true, padding: const EdgeInsets.fromLTRB(2.0, 10.0, 2.0, 10.0),
      children: <Widget>[
         ProductBox(
          name: "iPhone", 
          description: "iPhone is the stylist phone ever", 
          price: 1000, 
          image: "iphone.jpg"
        ), 
        ProductBox(
          name: "Pixel", 
          description: "Pixel is the most featureful phone ever", 
          price: 800, 
          image: "pixel.jpg"
        ), 
        ProductBox( 
          name: "Laptop", 
          description: "Laptop is most productive development tool", 
          price: 2000, 
          image: "laptop.jpg"
        ), 
        ProductBox( 
          name: "Tablet", 
          description: "Tablet is the most useful device ever for meeting", 
          price: 1500, 
          image: "tablet.jpg"
        ), 
        ProductBox(
          name: "Pendrive", 
          description: "Pendrive is useful storage medium", 
          price: 100, 
          image: "pendrive.jpg"
        ), 
        ProductBox(
          name: "Floppy Drive", 
          description: "Floppy drive is useful rescue storage medium", 
          price: 20, 
          image: "floppydisk.jpg"
        ), 
      ]
    );
  }
}

class RatingBox extends StatefulWidget { 
   @override 
   _RatingBoxState createState() => _RatingBoxState(); 
}

class _RatingBoxState extends State<RatingBox> { 
   int _rating = 0;
   void _setRatingAsOne(number) {
      setState(() {
         _rating = number; 
      }); 
   }
   Widget build(BuildContext context) {
      double _size = 20; 
      print(_rating); 
      return Row(
         mainAxisAlignment: MainAxisAlignment.end, 
         crossAxisAlignment: CrossAxisAlignment.end, 
         mainAxisSize: MainAxisSize.max, 
         children: <Widget>[
            for (int star = 1; star <= 5; ++star)
               Container(
               padding: EdgeInsets.all(0), 
               child: IconButton(
                  icon: (
                     _rating >= star ? Icon( 
                        Icons.star, 
                        size: _size, 
                     ) 
                     : Icon(
                        Icons.star_border, 
                        size: _size,
                     )
                  ), 
                  color: Colors.red[500], 
                  onPressed: () {
                    _setRatingAsOne(star);
                  }, 
                  iconSize: _size, 
               ), 
            ),            
         ], 
      ); 
   } 
}

class GeneratorPage extends StatelessWidget {
   void _showDialog(BuildContext context) { 
      showDialog( 
        context: context, builder: (BuildContext context) { 
           return AlertDialog(
              title: new Text("Message"), 
              content: new Text("Hello World"),   
              actions: <Widget>[
                new ElevatedButton(
                    child: new Text("Close"), 
                    onPressed: () {   
                      Navigator.of(context).pop();  
                    }, 
                ), 
              ]
          );
         },
      );
   }
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;
    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: HistoryListView(),
          ),
          Center(
            child: GestureDetector( 
              onTap: () {
                _showDialog(context);
              },
              child: Text( 'Hello World', )
            )
          ),
          SizedBox(height: 10),
          BigCart(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
          Spacer(flex: 2),
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.grey,
            ),
            child: Container(
              padding: const
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
              decoration: const BoxDecoration(
              ),
              child: const Text(
                'OK',textAlign: TextAlign.center, style: TextStyle(color: Colors.black)
              ), 
            ), 
          ),
          Center(
            child: Image.asset('assets/images/smile.jpg')
          ),
        ],
      ),
    );
  }
}

class ProductBox extends StatelessWidget {
   ProductBox({Null key, required this.name, required this.description, required this.price,required this.image}) :
      super(key: key); 
   final String name; 
   final String description; 
   final int price; 
   final String image; 
   
   Widget build(BuildContext context) {
      return Container(
         padding: EdgeInsets.all(2), 
         height: 160, 
         child: Card(
            child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
               children: <Widget>[ 
                  Image.asset("assets/images/" + image), 
                  Expanded( 
                     child: Container( 
                        padding: EdgeInsets.all(5), 
                        child: Column( 
                           mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                           children: <Widget>[ 
                              Text(
                                 this.name, style: TextStyle(
                                    fontWeight: FontWeight.bold
                                 )
                              ),
                              Text(this.description), Text(
                                 "Price: " + this.price.toString()
                              ),
                              RatingBox()
                           ], 
                        )
                     )
                  ) 
               ]
            ), 
         )
      ); 
   } 
}

class BigCart extends StatelessWidget {

  const BigCart({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}

class ProductPage extends StatelessWidget {
   ProductPage({Null key, required this.item}) : super(key: key); 
   final Product item; 

   @override
   Widget build(BuildContext context) {
      return Scaffold(
         appBar: AppBar(
            title: Text(this.item.name), 
         ), 
         body: Center(
            child: Container( 
               padding: EdgeInsets.all(0), 
               child: Column( 
                  mainAxisAlignment: MainAxisAlignment.start, 
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: <Widget>[ 
                     Image.asset("assets/images/" + this.item.image), 
                     Expanded( 
                        child: Container( 
                           padding: EdgeInsets.all(5), 
                           child: Column( 
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                              children: <Widget>[ 
                                 Text(this.item.name, style: TextStyle(fontWeight: FontWeight.bold)), 
                                 Text(this.item.description), 
                                 Text("Price: " + this.item.price.toString()), 
                                //  RatingBox(), 
                              ], 
                           )
                        )
                     ) 
                  ]
               ), 
            ), 
         ), 
      ); 
   } 
}

class HistoryListView extends StatefulWidget {
  const HistoryListView({Key? key}) : super(key: key);

  @override
  State<HistoryListView> createState() => _HistoryListViewState();
}

class _HistoryListViewState extends State<HistoryListView> {
  /// Needed so that [MyAppState] can tell [AnimatedList] below to animate
  /// new items.
  final _key = GlobalKey();

  /// Used to "fade out" the history items at the top, to suggest continuation.
  static const Gradient _maskingGradient = LinearGradient(
    // This gradient goes from fully transparent to fully opaque black...
    colors: [Colors.transparent, Colors.black],
    // ... from the top (transparent) to half (0.5) of the way to the bottom.
    stops: [0.0, 0.5],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    appState.historyListKey = _key;

    return ShaderMask(
      shaderCallback: (bounds) => _maskingGradient.createShader(bounds),
      // This blend mode takes the opacity of the shader (i.e. our gradient)
      // and applies it to the destination (i.e. our animated list).
      blendMode: BlendMode.dstIn,
      child: AnimatedList(
        key: _key,
        reverse: true,
        padding: EdgeInsets.only(top: 100),
        initialItemCount: appState.history.length,
        itemBuilder: (context, index, animation) {
          final pair = appState.history[index];
          return SizeTransition(
            sizeFactor: animation,
            child: Center(
              child: TextButton.icon(
                onPressed: () {
                  appState.toggleFavorite(pair);
                },
                icon: appState.favorites.contains(pair)
                    ? Icon(Icons.favorite, size: 12)
                    : SizedBox(),
                label: Text(
                  pair.asLowerCase,
                  semanticsLabel: pair.asPascalCase,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
