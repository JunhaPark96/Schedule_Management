import 'package:flutter/material.dart';

class AnimatedSearchBar extends StatefulWidget {
  final Function(String) onSearch;

  const AnimatedSearchBar({
    super.key,
    required this.onSearch,
  });

  @override
  _AnimatedSearchBarState createState() => _AnimatedSearchBarState();
}

class _AnimatedSearchBarState extends State<AnimatedSearchBar> {
  bool folded = true;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: folded ? 56 : 270,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: Colors.white,
        boxShadow: kElevationToShadow[6],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 20),
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.blue),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  widget.onSearch(value);
                },
                onTap: () {
                  // TextField에 포커스가 주어지면 펼쳐짐
                  if (folded) {
                    setState(() {
                      folded = false;
                    });
                  }
                },
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(folded ? 32 : 0),
                  topRight: const Radius.circular(32),
                  bottomLeft: Radius.circular(folded ? 32 : 0),
                  bottomRight: const Radius.circular(32),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(
                    folded ? Icons.search : Icons.close,
                    color: Colors.blue[900],
                  ),
                ),
                onTap: () {
                  setState(() {
                    if (!folded) {
                      // 검색 바를 닫을 때만 텍스트 필드를 초기화
                      _controller.clear();
                      widget.onSearch('');
                    }
                    folded = !folded;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
