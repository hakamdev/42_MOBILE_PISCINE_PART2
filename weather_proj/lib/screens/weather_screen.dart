import 'package:flutter/material.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen>
    with TickerProviderStateMixin {
  String searchText = "";
  int screenIndex = 0;
  TabController? controller;
  TextEditingController textController = TextEditingController();

  String displayText = "";

  void onSearchTextSubmitted(text) {
    setState(() {
      searchText = text.trim();
      if (searchText.isNotEmpty) {
        displayText = searchText;
      }
    });
  }

  void onLocationIconPressed() {
    setState(() {
      displayText = "Geolocation";
    });
  }

  void onDestinationChanged(index) {
    setState(() {
      screenIndex = index;
    });
    controller?.animateTo(index);
  }

  @override
  void initState() {
    controller = TabController(length: 3, vsync: this);
    controller?.addListener(() {
      setState(() {
        screenIndex = controller!.index;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            foregroundColor: Theme.of(context).colorScheme.onSurface,
            title: TextField(
              controller: textController,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
              onChanged: (text) {
                setState(() {
                  searchText = text.trim();
                  displayText = "";
                });
              },
              onSubmitted: onSearchTextSubmitted,
              decoration: InputDecoration(
                hintText: "Search locations",
                border: InputBorder.none,
                suffixIcon: textController.text.isNotEmpty
                    ? IconButton(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withAlpha(100),
                        onPressed: () {
                          setState(() {
                            searchText = "";
                            displayText = "";
                          });
                          textController.clear();
                        },
                        icon: const Icon(Icons.clear_rounded, size: 20),
                      )
                    : null,
              ),
            ),
            actions: [
              IconButton(
                onPressed: onLocationIconPressed,
                icon: const Icon(Icons.location_on_rounded),
              ),
            ],
          ),
          body: TabBarView(
            controller: controller,
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Currently",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    if (displayText.isNotEmpty)
                      Text(
                        displayText,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                  ],
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Today",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    if (displayText.isNotEmpty)
                      Text(
                        displayText,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                  ],
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Weekly",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    if (displayText.isNotEmpty)
                      Text(
                        displayText,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: screenIndex,
            onDestinationSelected: onDestinationChanged,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.sunny),
                label: "Currently",
              ),
              NavigationDestination(
                icon: Icon(Icons.calendar_today),
                label: "Today",
              ),
              NavigationDestination(
                icon: Icon(Icons.calendar_month_rounded),
                label: "Weekly",
              ),
            ],
          )),
    );
  }
}
