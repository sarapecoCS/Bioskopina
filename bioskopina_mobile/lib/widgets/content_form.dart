import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../providers/comment_provider.dart';
import '../providers/post_provider.dart';
import '../widgets/form_builder_text_field.dart';
import '../widgets/gradient_button.dart';
import '../models/post.dart';
import '../utils/colors.dart';
import '../utils/util.dart';

class ContentForm extends StatefulWidget {
  final Post? post; // Required for comments, null for posts
  final bool isPost; // New flag to indicate post creation
  final VoidCallback? onSuccess; // Callback for successful submission

  const ContentForm({
    super.key,
    this.post,
    this.isPost = false,
    this.onSuccess,
  }) : assert(post != null || isPost,
           "Either provide post for comment or set isPost for post creation");

  @override
  State<ContentForm> createState() => _ContentFormState();
}

class _ContentFormState extends State<ContentForm> {
  final GlobalKey<FormBuilderState> _contentFormKey =
      GlobalKey<FormBuilderState>();
  late final CommentProvider _commentProvider;
  late final PostProvider _postProvider;
  bool _isSubmitting = false;

  @override
  void initState() {
    _commentProvider = context.read<CommentProvider>();
    _postProvider = context.read<PostProvider>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(17),
      alignment: Alignment.center,
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Palette.darkPurple,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Palette.lightPurple.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: _buildChild(context),
      ),
    );
  }

  Widget _buildChild(BuildContext context) {
    return FormBuilder(
      key: _contentFormKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    widget.isPost ? "Create your post:" : "Write your comment:",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            MyFormBuilderTextField(
              name: "content",
              minLines: 5,
              fillColor: Palette.textFieldPurple.withOpacity(0.3),
              maxLines: null,
              textAlignVertical: TextAlignVertical.center,
              keyboardType: TextInputType.multiline,
              borderRadius: 15,
              errorBorderRadius: 15,
              contentPadding:
                  const EdgeInsets.only(left: 10, right: 10, top: 25),
              validator: (val) {
                return _buildValidator(val);
              },
            ),
            const SizedBox(height: 10),
            GradientButton(
              onPressed: _isSubmitting ? null : () async {
                if (_contentFormKey.currentState?.saveAndValidate() == true) {
                  setState(() {
                    _isSubmitting = true;
                  });

                  var content =
                      _contentFormKey.currentState?.fields["content"]?.value;

                  try {
                    if (widget.isPost) {
                      // Handle post creation
                      var post = {
                        "userId": LoggedUser.user!.id,
                        "content": content,
                        "likesCount": 0,
                        "dislikesCount": 0,
                        "datePosted": DateTime.now().toIso8601String(),
                      };
                      await _postProvider.insert(post);
                      if (context.mounted) {
                        Navigator.of(context).pop(); // Close form first
                        showSuccessDialog(context, "Post created successfully!");
                      }
                    } else {
                      // Handle comment insertion
                      var comment = {
                        "postId": widget.post!.id,
                        "userId": LoggedUser.user!.id,
                        "content": content,
                        "likesCount": 0,
                        "dislikesCount": 0,
                        "dateCommented": DateTime.now().toIso8601String(),
                      };
                      await _commentProvider.insert(comment);
                      if (context.mounted) {
                        Navigator.of(context).pop(); // Close form first
                        showSuccessDialog(context, "Comment added successfully!");
                      }
                    }

                    if (widget.onSuccess != null && context.mounted) {
                      widget.onSuccess!();
                    }
                  } on Exception catch (e) {
                    if (context.mounted) {
                      showErrorDialog(context, e);
                    }
                  } finally {
                    if (context.mounted && _isSubmitting) {
                      setState(() {
                        _isSubmitting = false;
                      });
                    }
                  }
                }
              },
              width: 80,
              height: 28,
              borderRadius: 50,
              gradient: Palette.buttonGradient,
              child: _isSubmitting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Palette.white,
                      ),
                    )
                  : const Text("Submit",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: Palette.white)),
            )
          ],
        ),
      ),
    );
  }

  String? _buildValidator(String? val) {
    if (val != null && val.isNotEmpty && !isValidReviewText(val)) {
      return "Some special characters are not allowed.";
    } else if (val == null || isEmptyOrWhiteSpace(val)) {
      return "This field cannot be empty.";
    } else if (val.isNotEmpty && val.length > 500) {
      return "Exceeded character limit: ${val.length}/500";
    }
    return null;
  }
}