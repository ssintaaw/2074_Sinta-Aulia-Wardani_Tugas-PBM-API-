import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/custom_textfield.dart';

class SubmitPage extends StatefulWidget {
  const SubmitPage({super.key});

  @override
  State<SubmitPage> createState() => _SubmitPageState();
}

class _SubmitPageState extends State<SubmitPage> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  final _githubController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();
  bool _isLoading = false;

  void _submitTask() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        bool success = await _apiService.submitTask(
          _nameController.text,
          _priceController.text,
          _descController.text,
          _githubController.text,
        );
        
        if (success) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Tugas berhasil dikirim ke Dashboard!"),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          }
        } else {
          throw Exception("Gagal mengirim tugas. Cek koneksi atau data.");
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString()), backgroundColor: Colors.redAccent),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7EEF2),
      appBar: AppBar(
        title: const Text("Pengumpulan Tugas", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF6E2137),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Card(
                color: Color(0xFFFFFDFD),
                elevation: 0,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Color(0xFF6E2137)),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Pastikan data produk dan link GitHub sudah benar sesuai instruksi praktikum.",
                          style: TextStyle(fontSize: 13, color: Color(0xFF6E2137)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                controller: _nameController,
                label: "Nama Produk",
                hint: "Contoh: Silverqueen",
                validator: (v) => v!.isEmpty ? "Nama produk wajib diisi" : null,
              ),
              CustomTextField(
                controller: _priceController,
                label: "Harga Produk",
                hint: "Contoh: 35000",
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Harga wajib diisi" : null,
              ),
              CustomTextField(
                controller: _descController,
                label: "Deskripsi",
                hint: "Contoh: Chocolate",
                maxLines: 3,
                validator: (v) => v!.isEmpty ? "Deskripsi wajib diisi" : null,
              ),
              CustomTextField(
                controller: _githubController,
                label: "GitHub Repository URL",
                hint: "https://github.com/username/project",
                validator: (v) {
                  if (v!.isEmpty) return "URL GitHub wajib diisi";
                  if (!v.contains("github.com")) return "URL GitHub tidak valid";
                  return null;
                },
              ),
              const SizedBox(height: 12),
              const Text(
                "* Tugas akan dikirim ke API /api/products/submit untuk penilaian.",
                style: TextStyle(fontSize: 11, color: Colors.grey, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6E2137),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("SUBMIT SEKARANG", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
