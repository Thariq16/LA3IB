import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../common_widgets/responsive_center.dart';
import '../../../constants/app_sizes.dart';
import '../../../theme/brand_colors.dart';
import '../../authentication/data/auth_repository.dart';
import '../../authentication/data/firestore_service.dart';
import '../../authentication/presentation/user_profile_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  
  String? _selectedCity;
  String? _selectedGender;
  List<String> _selectedSports = [];
  
  Uint8List? _imageBytes;
  String? _imageName;
  bool _isLoading = false;
  bool _isUploading = false;

  final List<String> _cities = [
    'Riyadh', 'Jeddah', 'Mecca', 'Medina', 'Dammam',
    'Khobar', 'Dhahran', 'Tabuk', 'Abha', 'Taif',
  ];

  final List<String> _genderOptions = ['Male', 'Female'];
  
  final List<String> _sportsOptions = [
    'Football', 'Basketball', 'Volleyball', 'Tennis',
    'Padel', 'Cricket', 'Badminton', 'Swimming',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final appUserAsync = ref.read(currentUserProfileProvider);
    appUserAsync.whenData((appUser) {
      if (appUser != null) {
        _nameController.text = appUser.displayName ?? '';
        _selectedCity = appUser.city;
        _selectedGender = appUser.gender;
        _selectedSports = List.from(appUser.preferredSports);
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      
      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _imageBytes = bytes;
          _imageName = image.name;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  Future<String?> _uploadImage() async {
    if (_imageBytes == null) return null;
    
    setState(() => _isUploading = true);
    
    try {
      final user = ref.read(authRepositoryProvider).currentUser;
      if (user == null) return null;
      
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_photos')
          .child('${user.uid}.jpg');
      
      await storageRef.putData(
        _imageBytes!,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      
      return await storageRef.getDownloadURL();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading image: $e')),
        );
      }
      return null;
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a city')),
      );
      return;
    }
    if (_selectedSports.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one sport')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      String? photoUrl;
      
      // Upload image if selected
      if (_imageBytes != null) {
        photoUrl = await _uploadImage();
      }
      
      final user = ref.read(authRepositoryProvider).currentUser;
      final currentProfile = ref.read(currentUserProfileProvider).value;
      
      if (user == null || currentProfile == null) {
        throw Exception('User not found');
      }

      // Update profile
      final updatedUser = currentProfile.copyWith(
        displayName: _nameController.text.trim(),
        city: _selectedCity,
        gender: _selectedGender,
        preferredSports: _selectedSports,
        photoUrl: photoUrl ?? currentProfile.photoUrl,
      );

      await ref.read(firestoreServiceProvider).setAppUser(updatedUser);
      
      // Refresh user profile
      ref.invalidate(currentUserProfileProvider);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: BrandColors.primaryGreen,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving profile: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appUserAsync = ref.watch(currentUserProfileProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          TextButton.icon(
            onPressed: _isLoading ? null : _saveProfile,
            icon: _isLoading 
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.check),
            label: const Text('Save'),
          ),
        ],
      ),
      body: appUserAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (appUser) {
          if (appUser == null) {
            return const Center(child: Text('User not found'));
          }
          
          return ResponsiveCenter(
            maxContentWidth: 500,
            padding: const EdgeInsets.all(AppSizes.p24),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Profile Photo
                    Center(
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: _pickImage,
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: BrandColors.primaryGreen.withOpacity(0.2),
                              backgroundImage: _imageBytes != null
                                  ? MemoryImage(_imageBytes!)
                                  : (appUser.photoUrl != null
                                      ? NetworkImage(appUser.photoUrl!)
                                      : null) as ImageProvider?,
                              child: (_imageBytes == null && appUser.photoUrl == null)
                                  ? const Icon(
                                      Icons.person,
                                      size: 60,
                                      color: BrandColors.primaryGreen,
                                    )
                                  : null,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: BrandColors.primaryGreen,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: theme.scaffoldBackgroundColor,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          if (_isUploading)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black45,
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    gapH8,
                    Center(
                      child: Text(
                        'Tap to change photo',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    gapH32,
                    
                    // Name Field
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Display Name',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    gapH16,
                    
                    // City Dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedCity,
                      decoration: const InputDecoration(
                        labelText: 'City',
                        prefixIcon: Icon(Icons.location_city),
                      ),
                      items: _cities.map((city) {
                        return DropdownMenuItem(value: city, child: Text(city));
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedCity = value);
                      },
                    ),
                    gapH16,
                    
                    // Gender Selection
                    Text(
                      'Gender',
                      style: theme.textTheme.titleSmall,
                    ),
                    gapH8,
                    Wrap(
                      spacing: 8,
                      children: _genderOptions.map((gender) {
                        final isSelected = _selectedGender == gender;
                        return ChoiceChip(
                          label: Text(gender),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedGender = selected ? gender : null;
                            });
                          },
                          selectedColor: BrandColors.primaryGreen,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : null,
                          ),
                        );
                      }).toList(),
                    ),
                    gapH24,
                    
                    // Sports Selection
                    Text(
                      'Preferred Sports',
                      style: theme.textTheme.titleSmall,
                    ),
                    gapH8,
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _sportsOptions.map((sport) {
                        final isSelected = _selectedSports.contains(sport);
                        return FilterChip(
                          label: Text(sport),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedSports.add(sport);
                              } else {
                                _selectedSports.remove(sport);
                              }
                            });
                          },
                          selectedColor: BrandColors.primaryGreen,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : null,
                          ),
                          checkmarkColor: Colors.white,
                        );
                      }).toList(),
                    ),
                    gapH32,
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
