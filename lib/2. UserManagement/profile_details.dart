import 'package:flutter/material.dart';

class ProfileDetails extends StatelessWidget {
  const ProfileDetails({
    Key? key,
    required this.title,
    required this.value,
    required this.onPressed,
  }) : super(key: key);

  final String title;
  final String value;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final bool canEdit = title != 'Name' && title != 'Email' && title != 'Position';

    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 5,
              child: Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.normal),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (canEdit)
              const Expanded(
                child: Icon(Icons.edit, size: 14),
              ),
          ],
        ),
      ),
    );
  }
}
