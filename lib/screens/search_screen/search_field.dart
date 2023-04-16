import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:webinarprime/controllers/webinar_management_controller.dart';
import 'package:webinarprime/screens/webinar_management/view_webinar_screen/webinar_details_screen.dart';
import 'package:webinarprime/utils/colors.dart';
import 'package:webinarprime/utils/styles.dart';

class SearchFieldForSearchScreen extends StatefulWidget {
  const SearchFieldForSearchScreen({super.key});

  @override
  State<SearchFieldForSearchScreen> createState() =>
      _SearchFieldForSearchScreenState();
}

class _SearchFieldForSearchScreenState
    extends State<SearchFieldForSearchScreen> {
  List<dynamic> suggestions = WebinarManagementController.webinarsList;
  TextEditingController serachcontroller = TextEditingController();
  final TextEditingController _typeAheadController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isSuggestionOpen = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          _isSuggestionOpen = true;
        });
      } else {
        setState(() {
          _isSuggestionOpen = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _typeAheadController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadField(
      suggestionsBoxDecoration: const SuggestionsBoxDecoration(
        constraints: BoxConstraints(maxHeight: 300),
      ),
      // suggestionsBoxVerticalOffset: 5,
      animationStart: 0,
      hideOnEmpty: true,
      animationDuration: Duration.zero,
      hideOnLoading: true,
      hideOnError: true,
      keepSuggestionsOnLoading: true,
      textFieldConfiguration: TextFieldConfiguration(
          controller: serachcontroller,
          focusNode: _focusNode,
          // autofocus: true,

          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 16.sp,
              ),
          decoration: InputDecoration(
              hintText: 'Search . . .',
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.LTsecondaryColor),
              ),
              enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              hintStyle: myhintTextstyle.copyWith(
                fontSize: 16.sp,
              ),
              contentPadding: const EdgeInsets.all(10),
              border: const OutlineInputBorder())),
      suggestionsCallback: (pattern) {
        List<dynamic> matches = [];
        if (pattern == '') {
          return const Iterable<String>.empty();
        }
        matches.addAll(suggestions);
        print("matches are $matches");

        matches.retainWhere((s) {
          return s['name'].toLowerCase().contains(pattern.toLowerCase());
        });
        return matches;
      },
      onSuggestionsBoxToggle: (isOpen) {
        setState(() {
          _isSuggestionOpen = isOpen;
        });
      },
      itemBuilder: (context, sone) {
        Map<String, dynamic> webinar = sone as Map<String, dynamic>;
        print(" sone is =========================================$sone");
        print(suggestions);
        return Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: const BoxDecoration(
              // color: Colors.black,

              ),
          child: Text(
            webinar['name'],
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 16.sp,
                ),
          ),
        );
      },
      onSuggestionSelected: (suggestion) async {
        Map<String, dynamic> webinar = suggestion as Map<String, dynamic>;

        print(suggestion['_id']);
        await Get.find<WebinarManagementController>()
            .getwebinarById(suggestion['_id']);
        Get.to(() => const WebinarDetailsScreen(
              webinarDetails: {},
            ));
      },
      hideSuggestionsOnKeyboardHide: true,
    );
  }
}
