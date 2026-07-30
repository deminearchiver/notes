library material;

export 'package:flutter/material.dart'
    hide
        // Navigation bar
        NavigationBar,
        NavigationDestination,
        // Card
        Card;

export 'src/navigation_bar.dart';
export 'src/card.dart';

export 'src/window_size_class.dart';
