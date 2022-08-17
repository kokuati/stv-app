import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saudetv/app/modules/player/presenter/stores/player_store.dart';

import '../../../../core/domain/adapter/login_source.dart';

class PlayerPage extends StatefulWidget {
  final LoginSource loginSource;
  const PlayerPage({
    Key? key,
    required this.loginSource,
  }) : super(key: key);

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  @override
  void initState() {
    final playerStore = context.read<PlayerStore>();
    playerStore.setLoginSource(widget.loginSource);
    playerStore.initialize(widget.loginSource);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 200,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
