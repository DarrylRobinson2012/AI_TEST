import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/profile_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _bio = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = ref.read(profileProvider).user;
    _name.text = user.name;
    _phone.text = user.phone;
    _bio.text = user.bio;
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(profileProvider).user;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ${user.email}'),
            const SizedBox(height: 12),
            TextField(controller: _name, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: _phone, decoration: const InputDecoration(labelText: 'Phone')),
            TextField(controller: _bio, decoration: const InputDecoration(labelText: 'Bio')),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(profileProvider).update(
                      name: _name.text.trim(),
                      phone: _phone.text.trim(),
                      bio: _bio.text.trim(),
                    );
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated')));
              },
              child: const Text('Save'),
            )
          ],
        ),
      ),
    );
  }
}
