import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

const _canvas = Color(0xFFF3F5F9);
const _navy = Color(0xFF151D2B);
const _blue = Color(0xFF526DF5);
const _mint = Color(0xFF79E0C1);
const _text = Color(0xFF202A3A);
const _muted = Color(0xFF6D788B);
const _line = Color(0xFFE1E6EF);

void main() {
  runApp(const CvApp());
}

class CvApp extends StatefulWidget {
  const CvApp({super.key});

  @override
  State<CvApp> createState() => _CvAppState();
}

class _CvAppState extends State<CvApp> {
  bool _isSignedIn = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nakinja MUSHUSHU Patricia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: _canvas,
        colorScheme: ColorScheme.fromSeed(seedColor: _blue, surface: _canvas),
        fontFamily: 'Roboto',
      ),
      home: _isSignedIn
          ? PortfolioShell(onSignOut: () => setState(() => _isSignedIn = false))
          : LoginPage(onSignIn: () => setState(() => _isSignedIn = true)),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({required this.onSignIn, super.key});

  final VoidCallback onSignIn;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;
  String? _loginError;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn() {
    if (!_formKey.currentState!.validate()) return;

    if (_usernameController.text.trim() != 'demo' ||
        _passwordController.text != 'demo123') {
      setState(() => _loginError = 'Identifiant ou mot de passe incorrect.');
      return;
    }

    widget.onSignIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _navy,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, viewport) => SingleChildScrollView(
            padding: EdgeInsets.all(viewport.maxWidth > 700 ? 36 : 18),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1050),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth >= 760;
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x33000000),
                            blurRadius: 35,
                            offset: Offset(0, 18),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: isWide
                          ? Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: _LoginBrandPanel(isCompact: false),
                                ),
                                Expanded(flex: 6, child: _buildLoginForm()),
                              ],
                            )
                          : Column(
                              children: [
                                _LoginBrandPanel(isCompact: true),
                                Padding(
                                  padding: const EdgeInsets.all(26),
                                  child: _buildLoginForm(),
                                ),
                              ],
                            ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'ESPACE PERSONNEL',
            style: TextStyle(
              color: _blue,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.8,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Connexion',
            style: TextStyle(
              color: _text,
              fontSize: 30,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Accédez au CV et aux coordonnées.',
            style: TextStyle(color: _muted, height: 1.5),
          ),
          const SizedBox(height: 28),
          TextFormField(
            key: const Key('usernameField'),
            controller: _usernameController,
            textInputAction: TextInputAction.next,
            decoration: _loginInputDecoration(
              label: 'Identifiant',
              icon: Icons.person_outline_rounded,
            ),
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Saisissez votre identifiant.'
                : null,
            onChanged: (_) => setState(() => _loginError = null),
          ),
          const SizedBox(height: 14),
          TextFormField(
            key: const Key('passwordField'),
            controller: _passwordController,
            obscureText: !_passwordVisible,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _signIn(),
            decoration:
                _loginInputDecoration(
                  label: 'Mot de passe',
                  icon: Icons.lock_outline_rounded,
                ).copyWith(
                  suffixIcon: IconButton(
                    tooltip: _passwordVisible
                        ? 'Masquer le mot de passe'
                        : 'Afficher le mot de passe',
                    onPressed: () =>
                        setState(() => _passwordVisible = !_passwordVisible),
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  ),
                ),
            validator: (value) => value == null || value.isEmpty
                ? 'Saisissez votre mot de passe.'
                : null,
            onChanged: (_) => setState(() => _loginError = null),
          ),
          if (_loginError != null) ...[
            const SizedBox(height: 12),
            Text(
              _loginError!,
              key: const Key('loginError'),
              style: const TextStyle(color: Color(0xFFB33845), fontSize: 13),
            ),
          ],
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              key: const Key('signInButton'),
              onPressed: _signIn,
              style: FilledButton.styleFrom(
                backgroundColor: _blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Entrer dans mon espace',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F4FA),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Text.rich(
              TextSpan(
                style: TextStyle(color: _muted, height: 1.55, fontSize: 12),
                children: [
                  TextSpan(
                    text: 'Démo  ',
                    style: TextStyle(color: _text, fontWeight: FontWeight.w800),
                  ),
                  TextSpan(text: 'demo  ·  demo123'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginBrandPanel extends StatelessWidget {
  const _LoginBrandPanel({required this.isCompact});

  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: isCompact ? 0 : 550),
      padding: EdgeInsets.all(isCompact ? 24 : 42),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_blue, Color(0xFF3348B5)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 62,
            height: 62,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'NP',
              style: TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: isCompact ? 22 : 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'PORTFOLIO PROFESSIONNEL',
                  style: TextStyle(
                    color: _mint,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.7,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Nakinja\nMUSHUSHU Patricia',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    height: 1.12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.8,
                  ),
                ),
                const SizedBox(height: 17),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: _mint,
                      size: 17,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Goma, RDC',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.86),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (!isCompact)
            Text(
              'Un espace dédié à mon profil et à mon parcours.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 12,
              ),
            ),
        ],
      ),
    );
  }
}

InputDecoration _loginInputDecoration({
  required String label,
  required IconData icon,
}) {
  return InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon, size: 20),
    filled: true,
    fillColor: const Color(0xFFF8F9FC),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: _line),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: _line),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: _blue, width: 1.5),
    ),
  );
}

class PortfolioShell extends StatefulWidget {
  const PortfolioShell({required this.onSignOut, super.key});

  final VoidCallback onSignOut;

  @override
  State<PortfolioShell> createState() => _PortfolioShellState();
}

class _PortfolioShellState extends State<PortfolioShell> {
  int _selectedIndex = 0;

  List<Widget> get _pages => [
    ProfilePage(onNavigate: _selectPage),
    const JourneyPage(),
    const FamilyPage(),
    const ContactPage(),
  ];

  void _selectPage(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 860;
    final selectedTitle = _destinations[_selectedIndex].label;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: _canvas,
        surfaceTintColor: Colors.transparent,
        titleSpacing: isWide ? 28 : 4,
        leading: isWide
            ? null
            : Builder(
                builder: (context) => IconButton(
                  key: const Key('openNavigationButton'),
                  tooltip: 'Ouvrir le menu',
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: const Icon(Icons.menu_rounded),
                ),
              ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isWide) ...[
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'NP',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
            Text(
              selectedTitle,
              style: const TextStyle(
                color: _text,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            key: const Key('signOutButton'),
            tooltip: 'Se déconnecter',
            onPressed: widget.onSignOut,
            icon: const Icon(Icons.logout_rounded, color: _muted),
          ),
          const SizedBox(width: 10),
        ],
      ),
      drawer: isWide
          ? null
          : Drawer(
              width: 290,
              backgroundColor: _navy,
              child: SafeArea(
                child: _NavigationMenu(
                  selectedIndex: _selectedIndex,
                  onSelect: (index) {
                    _selectPage(index);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
      body: isWide
          ? Row(
              children: [
                SizedBox(
                  width: 260,
                  child: _NavigationMenu(
                    selectedIndex: _selectedIndex,
                    onSelect: _selectPage,
                  ),
                ),
                const VerticalDivider(width: 1, thickness: 1, color: _line),
                Expanded(child: _pageStack),
              ],
            )
          : _pageStack,
    );
  }

  Widget get _pageStack =>
      IndexedStack(index: _selectedIndex, children: _pages);
}

class _NavigationMenu extends StatelessWidget {
  const _NavigationMenu({required this.selectedIndex, required this.onSelect});

  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _navy,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _blue,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text(
                    'NP',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Nakinja Patricia',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 38),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'ESPACE PERSONNEL',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 9,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 12),
          for (var index = 0; index < _destinations.length; index++)
            _NavigationDestinationTile(
              destination: _destinations[index],
              selected: selectedIndex == index,
              onTap: () => onSelect(index),
            ),
          const Spacer(),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: const Row(
              children: [
                Icon(Icons.place_outlined, color: _mint, size: 18),
                SizedBox(width: 9),
                Text(
                  'Goma · RDC',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavigationDestinationTile extends StatelessWidget {
  const _NavigationDestinationTile({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final _Destination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: selected ? _blue : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: ListTile(
          key: Key('nav-${destination.id}'),
          onTap: onTap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          leading: Icon(
            destination.icon,
            color: selected ? Colors.white : Colors.white60,
            size: 20,
          ),
          title: Text(
            destination.label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.white70,
              fontSize: 13,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          trailing: selected
              ? const Icon(Icons.chevron_right_rounded, color: Colors.white70)
              : null,
          contentPadding: const EdgeInsets.symmetric(horizontal: 13),
          dense: true,
        ),
      ),
    );
  }
}

class _Destination {
  const _Destination({
    required this.id,
    required this.label,
    required this.icon,
  });

  final String id;
  final String label;
  final IconData icon;
}

const _destinations = [
  _Destination(id: 'profile', label: 'Profil', icon: Icons.dashboard_outlined),
  _Destination(id: 'journey', label: 'Parcours', icon: Icons.timeline_rounded),
  _Destination(id: 'family', label: 'Famille', icon: Icons.diversity_3_rounded),
  _Destination(
    id: 'contact',
    label: 'Coordonnées',
    icon: Icons.alternate_email_rounded,
  ),
];

class ProfilePage extends StatelessWidget {
  const ProfilePage({required this.onNavigate, super.key});

  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const Key('cvPage'),
      padding: const EdgeInsets.all(26),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _PageIntro(
                  eyebrow: 'PROFIL PERSONNEL',
                  title: 'Bonjour, Patricia.',
                  subtitle:
                      'Découvrez mon profil et les informations disponibles.',
                ),
                const SizedBox(height: 22),
                const _SampleDataNotice(),
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(26),
                  decoration: BoxDecoration(
                    color: _navy,
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 58,
                            height: 58,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: _blue,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Text(
                              'NP',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          const Text(
                            'CURRICULUM VITAE',
                            style: TextStyle(
                              color: _mint,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.7,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 23),
                      const Text(
                        'Nakinja\nMUSHUSHU Patricia',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          height: 1.1,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.8,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.09),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: _mint,
                              size: 16,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Goma, RDC',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const _SectionHeading(eyebrow: 'EN BREF', title: 'À propos'),
                const SizedBox(height: 12),
                const _InformationPanel(
                  icon: Icons.person_outline_rounded,
                  title: 'Profil',
                  description: 'Nakinja MUSHUSHU Patricia est basée à Goma, en République démocratique du Congo.',
                ),
                const SizedBox(height: 12),
                const _InformationPanel(
                  icon: Icons.edit_note_rounded,
                  title: 'Parcours de démonstration',
                  description: 'Les expériences et membres de famille présentés dans ce CV sont fictifs et restent à confirmer.',
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: OutlinedButton.icon(
                    key: const Key('profileJourneyButton'),
                    onPressed: () => onNavigate(1),
                    icon: const Icon(Icons.arrow_forward_rounded, size: 17),
                    label: const Text('Voir la section parcours'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _blue,
                      side: const BorderSide(color: _line),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SampleDataNotice extends StatelessWidget {
  const _SampleDataNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3D9),
        border: Border.all(color: const Color(0xFFF0DCA8)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: Color(0xFF916A17), size: 19),
          SizedBox(width: 10),
        ],
      ),
    );
  }
}

class FamilyPage extends StatelessWidget {
  const FamilyPage({super.key});

  static const _members = [
    _FamilyMember(
      name: 'Chantal Nakinja',
      relationship: 'Mère',
      occupation: 'Enseignante',
      color: Color(0xFFE5EAFE),
    ),
    _FamilyMember(
      name: 'Jean-Bosco Nakinja',
      relationship: 'Père',
      occupation: 'Agent administratif',
      color: Color(0xFFE0F4EF),
    ),
    _FamilyMember(
      name: 'Aline Nakinja',
      relationship: 'Sœur',
      occupation: 'Étudiante en santé',
      color: Color(0xFFFFE9DF),
    ),
    _FamilyMember(
      name: 'David Nakinja',
      relationship: 'Frère',
      occupation: 'Technicien informatique',
      color: Color(0xFFEDE5F8),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const Key('familyPage'),
      padding: const EdgeInsets.all(26),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _PageIntro(
                  eyebrow: 'CERCLE FAMILIAL',
                  title: 'Ma famille.',
                  subtitle:
                      'Exemples de profils pour personnaliser cette page.',
                ),
                const SizedBox(height: 22),
                const _SampleDataNotice(),
                const SizedBox(height: 18),
                ..._members.map(
                  (member) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _FamilyCard(member: member),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FamilyMember {
  const _FamilyMember({
    required this.name,
    required this.relationship,
    required this.occupation,
    required this.color,
  });

  final String name;
  final String relationship;
  final String occupation;
  final Color color;
}

class _FamilyCard extends StatelessWidget {
  const _FamilyCard({required this.member});

  final _FamilyMember member;

  @override
  Widget build(BuildContext context) {
    final initials = member.name
        .split(' ')
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0])
        .join()
        .toUpperCase();

    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: member.color,
              borderRadius: BorderRadius.circular(17),
            ),
            child: Text(
              initials,
              style: const TextStyle(
                color: _navy,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name,
                  style: const TextStyle(
                    color: _text,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${member.relationship} · ${member.occupation}',
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.diversity_1_outlined, color: _blue, size: 20),
        ],
      ),
    );
  }
}

class JourneyPage extends StatelessWidget {
  const JourneyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const Key('journeyPage'),
      padding: const EdgeInsets.all(26),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _PageIntro(
                  eyebrow: 'PARCOURS',
                  title: 'Mon chemin.',
                  subtitle:
                      'Exemple de parcours professionnel à personnaliser.',
                ),
                SizedBox(height: 22),
                _SampleDataNotice(),
                SizedBox(height: 20),
                _JourneySampleContent(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _JourneySampleContent extends StatelessWidget {
  const _JourneySampleContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _SectionHeading(eyebrow: 'FORMATION', title: 'Études'),
        SizedBox(height: 12),
        _SampleTimelineCard(
          period: '2021 — 2024',
          title: 'Licence en gestion et administration',
          subtitle: 'Parcours universitaire · établissement à confirmer',
          icon: Icons.school_outlined,
        ),
        SizedBox(height: 22),
        _SectionHeading(eyebrow: 'EXPÉRIENCE', title: 'Expériences proposées'),
        SizedBox(height: 12),
        _SampleTimelineCard(
          period: '2024 — 2025',
          title: 'Assistante administrative',
          subtitle: 'Organisation locale · Goma',
          icon: Icons.work_outline_rounded,
        ),
        SizedBox(height: 10),
        _SampleTimelineCard(
          period: '2023',
          title: 'Stagiaire en communication',
          subtitle: 'Projet communautaire · Goma',
          icon: Icons.campaign_outlined,
        ),
        SizedBox(height: 22),
        _SectionHeading(eyebrow: 'SAVOIR-FAIRE', title: 'Compétences'),
        SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _ExampleSkillChip(label: 'Organisation'),
            _ExampleSkillChip(label: 'Communication écrite'),
            _ExampleSkillChip(label: 'Gestion documentaire'),
            _ExampleSkillChip(label: 'Bureautique'),
          ],
        ),
        SizedBox(height: 22),
        _SectionHeading(eyebrow: 'LANGUES', title: 'Langues parlées'),
        SizedBox(height: 12),
        _InformationPanel(
          icon: Icons.translate_rounded,
          title: 'Français · Swahili',
          description: 'Exemples de langues à confirmer avec Patricia.',
        ),
      ],
    );
  }
}

class _SampleTimelineCard extends StatelessWidget {
  const _SampleTimelineCard({
    required this.period,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String period;
  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFEDF0FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: _blue, size: 20),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  period,
                  style: const TextStyle(
                    color: _blue,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  title,
                  style: const TextStyle(
                    color: _text,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExampleSkillChip extends StatelessWidget {
  const _ExampleSkillChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: _text,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const Key('contactPage'),
      padding: const EdgeInsets.all(26),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _PageIntro(
                  eyebrow: 'RESTONS EN CONTACT',
                  title: 'Coordonnées.',
                  subtitle:
                      'Retrouvez ici les informations de contact disponibles.',
                ),
                SizedBox(height: 22),
                _ContactDetails(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ContactDetails extends StatelessWidget {
  const _ContactDetails();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _ContactCard(
          icon: Icons.place_outlined,
          label: 'LOCALISATION',
          value: 'Goma, République démocratique du Congo',
          uri: 'https://www.google.com/maps/search/?api=1&query=Goma%2C%20RDC',
        ),
        SizedBox(height: 12),
        _ContactCard(
          icon: Icons.call_outlined,
          label: 'TÉLÉPHONE',
          value: 'Non renseigné',
        ),
        SizedBox(height: 12),
        _ContactCard(
          icon: Icons.mail_outline_rounded,
          label: 'E-MAIL',
          value: 'Non renseigné',
        ),
        SizedBox(height: 18),
        Text(
          'Le téléphone et l’adresse e-mail n’ont pas été communiqués.',
          textAlign: TextAlign.center,
          style: TextStyle(color: _muted, fontSize: 12, height: 1.5),
        ),
      ],
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({
    required this.icon,
    required this.label,
    required this.value,
    this.uri,
  });

  final IconData icon;
  final String label;
  final String value;
  final String? uri;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: uri == null
            ? null
            : () => launchUrl(
                Uri.parse(uri!),
                mode: LaunchMode.externalApplication,
              ),
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            border: Border.all(color: _line),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDF0FF),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(icon, color: _blue, size: 21),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.3,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      value,
                      style: const TextStyle(
                        color: _text,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (uri != null)
                const Icon(Icons.open_in_new_rounded, color: _muted, size: 17),
            ],
          ),
        ),
      ),
    );
  }
}

class _PageIntro extends StatelessWidget {
  const _PageIntro({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
  });

  final String eyebrow;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow,
          style: const TextStyle(
            color: _blue,
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.6,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          title,
          style: const TextStyle(
            color: _text,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.7,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          style: const TextStyle(color: _muted, height: 1.45, fontSize: 13),
        ),
      ],
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.eyebrow, required this.title});

  final String eyebrow;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow,
          style: const TextStyle(
            color: _blue,
            fontSize: 9,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.6,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: const TextStyle(
            color: _text,
            fontSize: 21,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}

class _InformationPanel extends StatelessWidget {
  const _InformationPanel({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFEDF0FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: _blue, size: 20),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _text,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
