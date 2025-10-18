import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'my_ticket_screen.dart';
// import 'package:file_picker/file_picker.dart';

class ReportProblemScreen extends StatefulWidget {
  const ReportProblemScreen({super.key});

  @override
  State<ReportProblemScreen> createState() => _ReportProblemScreenState();
}

class _ReportProblemScreenState extends State<ReportProblemScreen> {
  String? selectedCategory;
  final TextEditingController _descriptionController = TextEditingController();
  File? selectedFile;
  String? selectedFileName;

  final List<String> categories = [
    'Account Issues',
    'Payment Problems',
    'Technical Bugs',
    'Game Related',
    'Security Concerns',
    'Other',
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF140A2D),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      _buildCategorySection(),
                      const SizedBox(height: 30),
                      _buildDescriptionSection(),
                      const SizedBox(height: 30),
                      _buildUploadSection(),
                      const SizedBox(height: 50),
                      _buildSubmitButton(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 42,
              height: 24,
              alignment: Alignment.centerLeft,
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'Report a Problem',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            width: 42,
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyTicketScreen()),
              ),
              child: const Text(
                'Ticket',
                style: TextStyle(
                  color: Color(0xFFFFA82E),
                  fontSize: 14,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category',
          style: TextStyle(
            color: Color(0xFFA395EE),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: _showCategoryBottomSheet,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: const Color(0xFFA395EE).withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedCategory ?? 'Select a Category',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            color: Color(0xFFA395EE),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          height: 140,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0xFFA395EE).withOpacity(0.2)),
          ),
          child: TextField(
            controller: _descriptionController,
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
            decoration: const InputDecoration(
              hintText: 'Enter issue description...',
              hintStyle: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 0.5),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upload Screenshot',
          style: TextStyle(
            color: Color(0xFFA395EE),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: _pickFile,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: const Color(0xFFA395EE).withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedFileName ?? 'No file chosen',
                    style: TextStyle(
                      color: selectedFileName != null
                          ? Colors.white
                          : const Color.fromRGBO(255, 255, 255, 0.5),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 20,
                  color: const Color.fromRGBO(255, 255, 255, 0.2),
                  margin: const EdgeInsets.symmetric(horizontal: 14),
                ),
                const Text(
                  'Choose file',
                  style: TextStyle(
                    color: Color(0xFFFFA82E),
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitReport,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFA82E),
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Submit Report',
          style: TextStyle(
            color: Color(0xFF0B0F1A),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  void _showCategoryBottomSheet() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Container(
          height: screenHeight * 0.8,
          decoration: const BoxDecoration(
            color: Color(0xFF271777),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.075),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Select Category',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ...categories.map(
                    (category) => _buildCategoryOption(category),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryOption(String category) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              selectedCategory = category;
            });
            Navigator.pop(context);
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text(
              category,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        if (category != categories.last)
          Container(
            height: 1,
            color: const Color(0xFFE5E5E5).withOpacity(0.1),
            margin: const EdgeInsets.symmetric(vertical: 10),
          ),
      ],
    );
  }

  Future<void> _pickFile() async {
    try {
      // FilePickerResult? result = await FilePicker.platform.pickFiles(
      //   type: FileType.image,
      //   allowMultiple: false,
      // );

      // if (result != null) {
      //   setState(() {
      //     selectedFile = File(result.files.single.path!);
      //     selectedFileName = result.files.single.name;
      //   });
      // }
      throw Exception();
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking file: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _submitReport() {
    if (selectedCategory == null) {
      _showErrorSnackBar('Please select a category');
      return;
    }

    if (_descriptionController.text.trim().isEmpty) {
      _showErrorSnackBar('Please enter a description');
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Report submitted successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
