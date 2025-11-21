import 'dart:io' as dart_io;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'upload_provider.dart';

/// Simple test page for Cloudinary uploads
class StorageTestPage extends ConsumerStatefulWidget {
  const StorageTestPage({super.key});

  @override
  ConsumerState<StorageTestPage> createState() => _StorageTestPageState();
}

class _StorageTestPageState extends ConsumerState<StorageTestPage> {
  final _imagePicker = ImagePicker();
  XFile? _selectedImage;

  Future<void> _pickImage() async {
    try {
      final image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() => _selectedImage = image);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image first')),
      );
      return;
    }

    // Trigger upload in provider
    await ref.read(uploadProvider.notifier).uploadImage(_selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    final uploadState = ref.watch(uploadProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cloudinary Upload Test'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info Card
            Card(
              color: Colors.blue.shade50,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cloudinary Upload Test',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Steps:\n'
                      '1. Pick an image\n'
                      '2. Click Upload\n'
                      '3. View result',
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Image Preview
            if (_selectedImage != null) ...[
              const Text(
                'Selected Image:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 12),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    dart_io.File(_selectedImage!.path),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Buttons
            ElevatedButton.icon(
              onPressed: uploadState.isLoading ? null : _pickImage,
              icon: const Icon(Icons.image),
              label: const Text('Pick Image'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed:
                  (_selectedImage == null || uploadState.isLoading)
                      ? null
                      : _uploadImage,
              icon: uploadState.isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.cloud_upload),
              label: Text(
                uploadState.isLoading ? 'Uploading...' : 'Upload to Cloudinary',
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            const SizedBox(height: 24),

            // Error Display
            if (uploadState.error != null)
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '❌ Upload Failed',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        uploadState.error!,
                        style: TextStyle(color: Colors.red.shade700),
                      ),
                    ],
                  ),
                ),
              ),

            // Success Display
            if (uploadState.uploadedUrl != null) ...[
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '✅ Upload Successful!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Cloudinary URL:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      SelectableText(
                        uploadState.uploadedUrl!,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.blue[700],
                          fontFamily: 'Monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 24),
              const Text(
                'View Image:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  // Open image in new tab/window
                  // For web, you can use: window.open(uploadState.uploadedUrl, '_blank');
                  // Or just copy the URL for manual viewing
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Image URL copied to clipboard'),
                      action: SnackBarAction(
                        label: 'Open',
                        onPressed: () {
                          // In a real app, use url_launcher package to open URL
                          // For now, just show the URL
                        },
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.open_in_browser),
                label: const Text('Open Image in Browser'),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'The image has been successfully uploaded to Cloudinary! ✓',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Note: Image preview requires CORS headers. You can:',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• Click "Open Image in Browser" to view it\n'
                      '• Copy the URL below and open in a new tab\n'
                      '• The URL will work in your mobile app',
                      style: TextStyle(fontSize: 11),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onLongPress: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Copy the URL below manually'),
                          ),
                        );
                      },
                      child: SelectableText(
                        uploadState.uploadedUrl!,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.blue[700],
                          fontFamily: 'Monospace',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
