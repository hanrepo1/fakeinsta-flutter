import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final bool isVisible;
  final Function onClose;
  final GestureTapCallback? onTapOutside;

  const PostCard({
    super.key, 
    required this.isVisible, 
    required this.onClose, 
    this.onTapOutside
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: GestureDetector(
        onTap: onTapOutside,
        child: Container(
          alignment: Alignment.bottomCenter,
          color: Colors.black54,
          child: AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 8.0),
                    height: 5.0,
                    width: 40.0,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 45),
                        const Text(
                          'Comments',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => onClose(),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text('Comment $index'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}