import 'package:callkit_experimental/models/suspecious_number.dart';
import 'package:flutter/material.dart';

class CallerIndentityCard extends StatelessWidget {
  final SuspeciousNumber caller;
  final VoidCallback? onTapDelete;
  const CallerIndentityCard(
      {super.key, required this.caller, this.onTapDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "${caller.title}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                InkWell(
                  child: Icon(
                    Icons.delete_forever_outlined,
                    color: Colors.red,
                  ),
                  onTap: onTapDelete,
                )
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Text("${caller.number}"),
          ],
        ),
      ),
    );
  }
}
