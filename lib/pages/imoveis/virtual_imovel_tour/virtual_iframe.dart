import 'dart:html';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/components/custom_menu.dart';
import 'package:projeto_imobiliaria/util/app_bar_model.dart';


class VirtualTourIFrame extends StatefulWidget {
  @override
  State<VirtualTourIFrame> createState() => _VirtualTourIFrameState();
}

class _VirtualTourIFrameState extends State<VirtualTourIFrame> {
  final IFrameElement _iFrameElement = IFrameElement();

  @override
  void initState() {
    _iFrameElement.style.height = '100%';
    _iFrameElement.style.width = '100%';
    _iFrameElement.src = 'https://kuula.co/share/collection/7JJvB?logo=1&info=1&fs=1&vr=0&sd=1&thumbs=1&inst=pt';
    _iFrameElement.style.border = 'none';

// ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'iframeElement',
      (int viewId) => _iFrameElement,
    );

    super.initState();
  }

  final Widget _iframeWidget = HtmlElementView(
    viewType: 'iframeElement',
    key: UniqueKey(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(subtitle: '', title: 'VirtualTour', isDarkMode: false),
      drawer: CustomMenu(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height - 100,
                width: MediaQuery.of(context).size.width - 100,
                child: _iframeWidget,
              )
            ],
          ),
        ),
      ),
     
    );
  }
}
