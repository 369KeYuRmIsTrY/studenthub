import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SubmissionFormWidget extends StatefulWidget {
  final TextEditingController commentsController;
  final VoidCallback onCommentsChanged;

  const SubmissionFormWidget({
    super.key,
    required this.commentsController,
    required this.onCommentsChanged,
  });

  @override
  State<SubmissionFormWidget> createState() => _SubmissionFormWidgetState();
}

class _SubmissionFormWidgetState extends State<SubmissionFormWidget> {
  final int maxCharacters = 500;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    widget.commentsController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.commentsController.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
    widget.onCommentsChanged();
  }

  int get _remainingCharacters {
    return maxCharacters - widget.commentsController.text.length;
  }

  Color get _counterColor {
    if (_remainingCharacters < 50) {
      return AppTheme.lightTheme.colorScheme.error;
    } else if (_remainingCharacters < 100) {
      return AppTheme.lightTheme.colorScheme.error;
    }
    return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Submission Comments',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Optional',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),

            SizedBox(height: 1.h),

            Text(
              'Add any additional notes or comments about your submission',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),

            SizedBox(height: 2.h),

            // Text Input Field
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: widget.commentsController.text.isNotEmpty
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.outline,
                  width: widget.commentsController.text.isNotEmpty ? 2 : 1,
                ),
              ),
              child: TextField(
                controller: widget.commentsController,
                maxLines: _isExpanded ? 8 : 4,
                maxLength: maxCharacters,
                decoration: InputDecoration(
                  hintText: 'Enter your comments here...',
                  hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.7),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(3.w),
                  counterText: '',
                ),
                style: AppTheme.lightTheme.textTheme.bodyMedium,
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
              ),
            ),

            SizedBox(height: 1.h),

            // Footer with character count and expand button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$_remainingCharacters characters remaining',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: _counterColor,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  icon: CustomIconWidget(
                    iconName: _isExpanded ? 'expand_less' : 'expand_more',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 16,
                  ),
                  label: Text(
                    _isExpanded ? 'Collapse' : 'Expand',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),

            if (widget.commentsController.text.isNotEmpty) ...[
              SizedBox(height: 2.h),

              // Auto-save indicator
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.tertiary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.tertiary
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'save',
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Comments auto-saved',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            SizedBox(height: 2.h),

            // Quick comment suggestions
            Text(
              'Quick Comments',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 1.h),

            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: [
                _buildQuickCommentChip(
                    'Please review my implementation approach'),
                _buildQuickCommentChip(
                    'I had trouble with the algorithm optimization'),
                _buildQuickCommentChip('Additional test cases included'),
                _buildQuickCommentChip('Completed ahead of schedule'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickCommentChip(String text) {
    return GestureDetector(
      onTap: () {
        final currentText = widget.commentsController.text;
        final newText = currentText.isEmpty ? text : '$currentText\n\n$text';

        if (newText.length <= maxCharacters) {
          widget.commentsController.text = newText;
          widget.commentsController.selection = TextSelection.fromPosition(
            TextPosition(offset: newText.length),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppTheme.lightTheme.colorScheme.secondary
                .withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'add',
              color: AppTheme.lightTheme.colorScheme.secondary,
              size: 14,
            ),
            SizedBox(width: 1.w),
            Flexible(
              child: Text(
                text,
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.secondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
