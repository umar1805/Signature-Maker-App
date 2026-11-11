import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const SignatureMakerApp());
}

const navy = Color(0xFF172554);
const violet = Color(0xFF5546E8);
const teal = Color(0xFF0EA5A4);
const bg = Color(0xFFF6F7FC);

class SignatureMakerApp extends StatelessWidget {
  const SignatureMakerApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Signature Maker',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: bg,
      colorScheme: ColorScheme.fromSeed(seedColor: violet),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: bg, foregroundColor: navy, elevation: 0,
        centerTitle: false,
      ),
    ),
    home: const SplashScreen(),
  );
}

// Data is kept in memory for this frontend demonstration.
class SignatureDesign {
  final List<List<Offset>> strokes;
  final Color color;
  final double thickness;
  final DateTime createdAt;
  SignatureDesign({
    required this.strokes,
    required this.color,
    required this.thickness,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

class SignatureStore extends ChangeNotifier {
  final List<SignatureDesign> signatures = [];
  void add(SignatureDesign signature) {
    signatures.insert(0, signature);
    notifyListeners();
  }
}
final signatureStore = SignatureStore();

class AppLogo extends StatelessWidget {
  final double size;
  const AppLogo({super.key, this.size = 46});
  @override
  Widget build(BuildContext context) => Container(
    width: size, height: size,
    decoration: BoxDecoration(
      gradient: const LinearGradient(colors: [violet, teal]),
      borderRadius: BorderRadius.circular(size * .3),
    ),
    child: Icon(Icons.draw_rounded, color: Colors.white, size: size * .56),
  );
}

class PrimaryButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  const PrimaryButton({super.key, required this.text, required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity, height: 55,
    child: DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [violet, Color(0xFF7165F2)]),
        borderRadius: BorderRadius.circular(17),
        boxShadow: [BoxShadow(color: violet.withValues(alpha: .22), blurRadius: 17, offset: const Offset(0, 8))],
      ),
      child: ElevatedButton.icon(
        onPressed: onTap, icon: Icon(icon, size: 19), label: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, shadowColor: Colors.transparent,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
        ),
      ),
    ),
  );
}

class ScreenTitle extends StatelessWidget {
  final String title, subtitle;
  const ScreenTitle(this.title, this.subtitle, {super.key});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: const TextStyle(color: navy, fontSize: 27, fontWeight: FontWeight.w900, letterSpacing: -.7)),
      const SizedBox(height: 7),
      Text(subtitle, style: const TextStyle(color: Color(0xFF718096), fontSize: 13, height: 1.45)),
    ],
  );
}

// SCREEN 1 — Splash
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (!mounted) return;
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SizedBox.expand(
      child: Image.asset(
        'assets/splash_screen.png',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: const Color(0xFFECEBFF),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(24),
          child: const Text(
            'Splash image not found. Add assets/splash_screen.png and register it in pubspec.yaml.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  );
}

// SCREEN 2 — Welcome
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(child: Padding(
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 25),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [const AppLogo(), const SizedBox(width: 11),
          const Text('Signature Maker', style: TextStyle(color: navy, fontWeight: FontWeight.w900, fontSize: 17)),
          const Spacer(), _pill('WELCOME')]),
        const Spacer(),
        Center(child: Container(width: 238, height: 238,
            decoration: const BoxDecoration(shape: BoxShape.circle,
                gradient: LinearGradient(colors: [Color(0xFFE8EAFE), Color(0xFFDDF8F5)])),
            child: Stack(alignment: Alignment.center, children: [
              Container(width: 165, height: 165,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(36)),
                  child: const Icon(Icons.draw_rounded, color: violet, size: 90)),
              const Positioned(right: 25, bottom: 25, child: CircleAvatar(radius: 25, backgroundColor: teal,
                  child: Icon(Icons.check_rounded, color: Colors.white, size: 28))),
              const Positioned(left: 30, top: 28, child: Icon(Icons.auto_awesome, color: Color(0xFFF59E0B), size: 27)),
            ]))),
        const SizedBox(height: 38),
        const Text('Make it\n'
            'official.', style: TextStyle(fontSize: 42, height: 1.05, fontWeight: FontWeight.w900, letterSpacing: -1.5, color: navy)),
        const SizedBox(height: 14),
        const Text('Create a signature that feels like you. Draw it by hand, personalize the look, and keep your favorite design.',
            style: TextStyle(color: Color(0xFF64748B), height: 1.6, fontSize: 14)),
        const SizedBox(height: 22),
        const _Feature(icon: Icons.gesture_rounded, text: 'Draw naturally with your finger'),
        const SizedBox(height: 12),
        const _Feature(icon: Icons.tune_rounded, text: 'Personalize colors and pen thickness'),
        const Spacer(),
        PrimaryButton(text: 'Get Started', icon: Icons.arrow_forward_rounded,
            onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()))),
        const SizedBox(height: 13),
        const Center(child: Text('Simple  •  Personal  •  Yours', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11))),
      ]),
    )),
  );
}
Widget _pill(String text) => Container(padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
    decoration: BoxDecoration(color: const Color(0xFFE9EAFE), borderRadius: BorderRadius.circular(30)),
    child: Text(text, style: const TextStyle(color: violet, fontWeight: FontWeight.w900, fontSize: 9, letterSpacing: 1)));
class _Feature extends StatelessWidget {
  final IconData icon; final String text;
  const _Feature({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) => Row(children: [
    Container(width: 32, height: 32, decoration: BoxDecoration(color: const Color(0xFFE9EAFE), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: violet, size: 18)),
    const SizedBox(width: 11), Text(text, style: const TextStyle(color: navy, fontSize: 12, fontWeight: FontWeight.w600)),
  ]);
}

// SCREEN 3 — Home
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() { super.initState(); signatureStore.addListener(_refresh); }
  @override
  void dispose() { signatureStore.removeListener(_refresh); super.dispose(); }
  void _refresh() { if (mounted) setState(() {}); }
  Future<void> _create() async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateScreen()));
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(21, 17, 21, 25),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [const AppLogo(), const SizedBox(width: 10),
          const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Signature Maker', style: TextStyle(color: navy, fontSize: 17, fontWeight: FontWeight.w900)),
            Text('YOUR PERSONAL SIGNATURE STUDIO', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 8, letterSpacing: 1.1, fontWeight: FontWeight.w700)),
          ]), const Spacer(), IconButton(onPressed: () => showAboutDialog(context: context,
              applicationName: 'Signature Maker', applicationVersion: '1.0',
              children: const [Text('A frontend demonstration for creating and saving signature designs.')]),
              icon: const Icon(Icons.info_outline_rounded, color: navy))]),
        const SizedBox(height: 25),
        Container(width: double.infinity, padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF172554), Color(0xFF4F46E5), Color(0xFF2563EB)]),
                borderRadius: BorderRadius.circular(27), boxShadow: [BoxShadow(color: violet.withValues(alpha: .18), blurRadius: 22, offset: const Offset(0, 10))]),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _pill('✦  SIGNATURE STUDIO'),
              const SizedBox(height: 18),
              const Text('Your signature,\nyour identity.', style: TextStyle(color: Colors.white, fontSize: 28, height: 1.13, fontWeight: FontWeight.w900)),
              const SizedBox(height: 9),
              const Text('Make a mark that is uniquely yours.', style: TextStyle(color: Color(0xFFDDE5FF), fontSize: 12)),
              const SizedBox(height: 18),
              ElevatedButton.icon(onPressed: _create, icon: const Icon(Icons.add_rounded),
                  label: const Text('Create Signature', style: TextStyle(fontWeight: FontWeight.w800)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: violet,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)), minimumSize: const Size(190, 46))),
            ])),
        const SizedBox(height: 25),
        const Text('Explore tools', style: TextStyle(color: navy, fontSize: 19, fontWeight: FontWeight.w900)),
        const SizedBox(height: 13),
        Row(children: [
          Expanded(child: _Tool(icon: Icons.gesture_rounded, title: 'Draw it', sub: 'Freehand', tint: const Color(0xFFE9EAFE), color: violet, onTap: _create)),
          const SizedBox(width: 10),
          Expanded(child: _Tool(icon: Icons.text_fields_rounded, title: 'Type it', sub: 'Text styles', tint: const Color(0xFFDDF8F5), color: teal, onTap: () => _coming(context))),
          const SizedBox(width: 10),
          Expanded(child: _Tool(icon: Icons.palette_outlined, title: 'Style it', sub: 'Customize', tint: const Color(0xFFFFF0D9), color: const Color(0xFFD97706), onTap: _create)),
        ]),
        const SizedBox(height: 25),
        Row(children: [const Text('My signatures', style: TextStyle(color: navy, fontSize: 19, fontWeight: FontWeight.w900)),
          const Spacer(), Text('${signatureStore.signatures.length} SAVED', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 9, letterSpacing: 1, fontWeight: FontWeight.w800))]),
        const SizedBox(height: 12),
        if (signatureStore.signatures.isEmpty)
          Container(width: double.infinity, padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(21), border: Border.all(color: const Color(0xFFE6EAF2))),
              child: Column(children: [
                const CircleAvatar(radius: 27, backgroundColor: Color(0xFFEFF0FF), child: Icon(Icons.draw_outlined, color: violet, size: 26)),
                const SizedBox(height: 10), const Text('No signatures yet', style: TextStyle(color: navy, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4), const Text('Create your first signature and it will appear here.', textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                TextButton.icon(onPressed: _create, icon: const Icon(Icons.add), label: const Text('Create now')),
              ]))
        else
          ...signatureStore.signatures.take(2).map((s) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _SavedCard(signature: s, onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => PreviewScreen(signature: s, fromSaved: true)))),
          )),
        const SizedBox(height: 12),
        Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(16)),
            child: const Row(children: [Icon(Icons.lightbulb_outline_rounded, color: Color(0xFF2563EB)),
              SizedBox(width: 10), Expanded(child: Text('Tip: Draw slowly for a smoother, more natural signature.',
                  style: TextStyle(color: Color(0xFF1E40AF), fontSize: 11, height: 1.4)))])),
      ]),
    )),
    bottomNavigationBar: NavigationBar(
      selectedIndex: 0, height: 66, backgroundColor: Colors.white,
      onDestinationSelected: (i) { if (i == 1) Navigator.push(context, MaterialPageRoute(builder: (_) => const MySignaturesScreen())); },
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.folder_open_outlined), label: 'My Signatures'),
      ],
    ),
  );
}
class _Tool extends StatelessWidget {
  final IconData icon; final String title, sub; final Color tint, color; final VoidCallback onTap;
  const _Tool({required this.icon, required this.title, required this.sub, required this.tint, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) => Material(color: Colors.white, borderRadius: BorderRadius.circular(18),
      child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(18),
          child: Container(padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFE7EBF3))),
              child: Column(children: [
                Container(width: 42, height: 42, decoration: BoxDecoration(color: tint, borderRadius: BorderRadius.circular(13)), child: Icon(icon, color: color)),
                const SizedBox(height: 8), Text(title, style: const TextStyle(color: navy, fontSize: 12, fontWeight: FontWeight.w800)),
                const SizedBox(height: 3), Text(sub, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10)),
              ]))));
}
void _coming(BuildContext context) => showDialog<void>(context: context, builder: (c) => AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), title: const Text('Coming soon'),
    content: const Text('This design option is planned for a future version. The draw and customize flow is ready to use.'),
    actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text('OK'))]));

// SCREEN 4 — Create method
class CreateScreen extends StatelessWidget {
  const CreateScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Create signature', style: TextStyle(fontWeight: FontWeight.w900))),
    body: SafeArea(child: ListView(padding: const EdgeInsets.fromLTRB(21, 10, 21, 25), children: [
      const ScreenTitle('How would you like\nto create it?', 'Choose a method to start making your personal signature.'),
      const SizedBox(height: 25),
      _Method(icon: Icons.gesture_rounded, title: 'Draw your signature', description: 'Use your finger or stylus to sign naturally on the canvas.',
          tag: 'AVAILABLE', color: violet, tint: const Color(0xFFE9EAFE),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DrawScreen()))),
      const SizedBox(height: 13),
      _Method(icon: Icons.text_fields_rounded, title: 'Type your signature', description: 'Enter your name and choose a script-inspired text style.',
          tag: 'COMING SOON', color: teal, tint: const Color(0xFFDDF8F5), onTap: () => _coming(context)),
      const SizedBox(height: 13),
      _Method(icon: Icons.auto_awesome_rounded, title: 'Choose a style', description: 'Explore a collection of signature looks and ideas.',
          tag: 'COMING SOON', color: const Color(0xFFD97706), tint: const Color(0xFFFFF0D9), onTap: () => _coming(context)),
      const SizedBox(height: 20),
      Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: const Color(0xFFF0FDF9), borderRadius: BorderRadius.circular(17)),
          child: const Row(children: [Icon(Icons.verified_user_outlined, color: teal), SizedBox(width: 10),
            Expanded(child: Text('Take your time and create a mark you are happy with.', style: TextStyle(color: Color(0xFF0F766E), fontSize: 12)))])),
    ])),
  );
}
class _Method extends StatelessWidget {
  final IconData icon; final String title, description, tag; final Color color, tint; final VoidCallback onTap;
  const _Method({required this.icon, required this.title, required this.description, required this.tag, required this.color, required this.tint, required this.onTap});
  @override
  Widget build(BuildContext context) => Material(color: Colors.white, borderRadius: BorderRadius.circular(21),
      child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(21),
          child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(borderRadius: BorderRadius.circular(21), border: Border.all(color: const Color(0xFFE7EBF3))),
              child: Row(children: [
                Container(width: 55, height: 55, decoration: BoxDecoration(color: tint, borderRadius: BorderRadius.circular(17)), child: Icon(icon, color: color, size: 27)),
                const SizedBox(width: 13), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(title, style: const TextStyle(color: navy, fontWeight: FontWeight.w900, fontSize: 14)),
                  const SizedBox(height: 5), Text(description, style: const TextStyle(color: Color(0xFF718096), fontSize: 11, height: 1.4)),
                  const SizedBox(height: 7), Text(tag, style: TextStyle(color: color, fontSize: 8, letterSpacing: 1, fontWeight: FontWeight.w900)),
                ])), const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF94A3B8), size: 15),
              ]))));
}

// SCREEN 5 — Draw
class DrawScreen extends StatefulWidget {
  const DrawScreen({super.key});
  @override
  State<DrawScreen> createState() => _DrawScreenState();
}
class _DrawScreenState extends State<DrawScreen> {
  final List<List<Offset>> _strokes = [];
  List<Offset> _active = [];
  Color _color = navy;
  double _width = 3.2;
  void _undo() { setState(() { if (_active.isNotEmpty) { _active = []; } else if (_strokes.isNotEmpty) { _strokes.removeLast(); } }); }
  void _clear() => setState(() { _strokes.clear(); _active.clear(); });
  void _save() {
    if (_strokes.isEmpty && _active.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please draw your signature first.')));
      return;
    }
    final all = [..._strokes, if (_active.isNotEmpty) List<Offset>.from(_active)];
    final design = SignatureDesign(strokes: all.map((s) => List<Offset>.from(s)).toList(), color: _color, thickness: _width);
    Navigator.push(context, MaterialPageRoute(builder: (_) => CustomizeScreen(signature: design)));
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Draw signature', style: TextStyle(fontWeight: FontWeight.w900)),
        actions: [IconButton(tooltip: 'Undo', onPressed: _undo, icon: const Icon(Icons.undo_rounded)),
          IconButton(tooltip: 'Clear', onPressed: _clear, icon: const Icon(Icons.delete_outline_rounded)), const SizedBox(width: 5)]),
    body: SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(18, 5, 18, 17),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const ScreenTitle('Put your mark on it.', 'Draw inside the canvas using your finger or a stylus.'),
        const SizedBox(height: 15),
        Expanded(child: Container(width: double.infinity,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), border: Border.all(color: const Color(0xFFDDE3F0)),
              boxShadow: [BoxShadow(color: navy.withValues(alpha: .04), blurRadius: 18, offset: const Offset(0, 7))]),
          child: ClipRRect(borderRadius: BorderRadius.circular(21),
            child: LayoutBuilder(builder: (context, constraints) => GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanStart: (d) => setState(() => _active = [d.localPosition]),
              onPanUpdate: (d) => setState(() => _active.add(d.localPosition)),
              onPanEnd: (_) => setState(() { if (_active.isNotEmpty) _strokes.add(List<Offset>.from(_active)); _active = []; }),
              child: Stack(children: [
                if (_strokes.isEmpty && _active.isEmpty) const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.gesture_rounded, size: 40, color: Color(0xFFCBD5E1)), SizedBox(height: 9),
                  Text('Sign here', style: TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.w700)),
                  SizedBox(height: 4), Text('Use your finger or stylus', style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 11)),
                ])),
                CustomPaint(size: Size.infinite, painter: SignaturePainter(strokes: _strokes, active: _active, color: _color, thickness: _width)),
                const Positioned(left: 18, right: 18, bottom: 43, child: Divider(color: Color(0xFFE2E8F0), height: 1)),
                const Positioned(left: 18, bottom: 19, child: Text('SIGNATURE', style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 8, letterSpacing: 2, fontWeight: FontWeight.w800))),
              ]),
            )),
          ),
        )),
        const SizedBox(height: 14),
        _controlPanel(),
        const SizedBox(height: 13),
        Row(children: [
          Expanded(child: OutlinedButton.icon(onPressed: _clear, icon: const Icon(Icons.refresh_rounded), label: const Text('Clear'),
              style: OutlinedButton.styleFrom(foregroundColor: navy, minimumSize: const Size(0, 52), side: const BorderSide(color: Color(0xFFDDE3F0)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))))),
          const SizedBox(width: 11),
          Expanded(flex: 2, child: SizedBox(height: 52, child: ElevatedButton.icon(onPressed: _save, icon: const Icon(Icons.arrow_forward_rounded),
              label: const Text('Continue', style: TextStyle(fontWeight: FontWeight.w800)),
              style: ElevatedButton.styleFrom(backgroundColor: violet, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))))),
        ]),
      ]),
    )),
  );
  Widget _controlPanel() => Container(padding: const EdgeInsets.fromLTRB(14, 12, 14, 5),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFE7EBF3))),
      child: Column(children: [
        Row(children: [const Text('Pen color', style: TextStyle(color: navy, fontSize: 12, fontWeight: FontWeight.w800)), const Spacer(),
          _Dot(color: navy, selected: _color == navy, onTap: () => setState(() => _color = navy)),
          _Dot(color: const Color(0xFF2563EB), selected: _color == const Color(0xFF2563EB), onTap: () => setState(() => _color = const Color(0xFF2563EB))),
          _Dot(color: teal, selected: _color == teal, onTap: () => setState(() => _color = teal)),
          _Dot(color: const Color(0xFFDC2626), selected: _color == const Color(0xFFDC2626), onTap: () => setState(() => _color = const Color(0xFFDC2626))),
        ]),
        Row(children: [const Text('Pen thickness', style: TextStyle(color: navy, fontSize: 12, fontWeight: FontWeight.w800)),
          const Spacer(), Text('${_width.toStringAsFixed(1)} px', style: const TextStyle(color: Color(0xFF64748B), fontSize: 11))]),
        Slider(value: _width, min: 1.5, max: 7, divisions: 11, activeColor: violet, onChanged: (v) => setState(() => _width = v)),
      ]));
}
class _Dot extends StatelessWidget {
  final Color color; final bool selected; final VoidCallback onTap;
  const _Dot({required this.color, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(onTap: onTap,
      child: Container(width: 29, height: 29, margin: const EdgeInsets.only(left: 9),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle,
              border: Border.all(color: selected ? const Color(0xFFCBD5E1) : Colors.transparent, width: 3)),
          child: selected ? const Icon(Icons.check, size: 14, color: Colors.white) : null));
}

class SignaturePainter extends CustomPainter {
  final List<List<Offset>> strokes; final List<Offset> active; final Color color; final double thickness;
  SignaturePainter({required this.strokes, required this.active, required this.color, required this.thickness});
  @override
  void paint(Canvas canvas, Size size) {
    final dots = Paint()..color = const Color(0xFFF1F5F9);
    for (double x = 20; x < size.width; x += 28) {
      for (double y = 18; y < size.height; y += 28) { canvas.drawCircle(Offset(x, y), .65, dots); }
    }
    final pen = Paint()..color = color..strokeWidth = thickness..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round..style = PaintingStyle.stroke;
    for (final stroke in [...strokes, if (active.isNotEmpty) active]) {
      if (stroke.isEmpty) continue;
      if (stroke.length == 1) { canvas.drawCircle(stroke.first, thickness / 2, Paint()..color = color); continue; }
      final path = Path()..moveTo(stroke.first.dx, stroke.first.dy);
      for (final point in stroke.skip(1)) { path.lineTo(point.dx, point.dy); }
      canvas.drawPath(path, pen);
    }
  }
  @override
  bool shouldRepaint(covariant SignaturePainter old) => old.strokes != strokes || old.active != active || old.color != color || old.thickness != thickness;
}

// SCREEN 6 — Customize
class CustomizeScreen extends StatefulWidget {
  final SignatureDesign signature;
  const CustomizeScreen({super.key, required this.signature});
  @override
  State<CustomizeScreen> createState() => _CustomizeScreenState();
}
class _CustomizeScreenState extends State<CustomizeScreen> {
  late Color color; late double thickness;
  bool transparent = false;
  @override
  void initState() { super.initState(); color = widget.signature.color; thickness = widget.signature.thickness; }
  SignatureDesign get updated => SignatureDesign(strokes: widget.signature.strokes, color: color, thickness: thickness, createdAt: widget.signature.createdAt);
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Customize signature', style: TextStyle(fontWeight: FontWeight.w900))),
    body: SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const ScreenTitle('Make it yours.', 'Fine-tune the look of your signature before previewing it.'),
        const SizedBox(height: 20),
        Expanded(child: Container(width: double.infinity, decoration: BoxDecoration(
            color: transparent ? const Color(0xFFF1F5F9) : Colors.white, borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFE0E6F0))),
            child: ClipRRect(borderRadius: BorderRadius.circular(22), child: CustomPaint(
              painter: SignaturePainter(strokes: widget.signature.strokes, active: const [], color: color, thickness: thickness),
              child: Center(child: Text('LIVE PREVIEW', style: TextStyle(color: navy.withValues(alpha: .22), fontSize: 9, letterSpacing: 2, fontWeight: FontWeight.w800))),
            )))),
        const SizedBox(height: 17),
        Container(padding: const EdgeInsets.all(17), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFE7EBF3))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Signature color', style: TextStyle(color: navy, fontWeight: FontWeight.w900, fontSize: 13)),
              const SizedBox(height: 13),
              Row(children: [
                _largeDot(navy), _largeDot(const Color(0xFF2563EB)), _largeDot(teal), _largeDot(const Color(0xFFDC2626)), _largeDot(const Color(0xFF111827)),
              ]),
              const SizedBox(height: 18),
              Row(children: [const Text('Pen thickness', style: TextStyle(color: navy, fontWeight: FontWeight.w900, fontSize: 13)),
                const Spacer(), Text('${thickness.toStringAsFixed(1)} px', style: const TextStyle(color: Color(0xFF64748B), fontSize: 11))]),
              Slider(value: thickness, min: 1.5, max: 7, divisions: 11, activeColor: violet, onChanged: (v) => setState(() => thickness = v)),
              SwitchListTile(contentPadding: EdgeInsets.zero, dense: true, activeColor: violet,
                  title: const Text('Preview on soft background', style: TextStyle(color: navy, fontSize: 12, fontWeight: FontWeight.w700)),
                  subtitle: const Text('Toggle the preview surface', style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
                  value: transparent, onChanged: (v) => setState(() => transparent = v)),
            ])),
        const SizedBox(height: 15),
        PrimaryButton(text: 'Continue to preview', icon: Icons.arrow_forward_rounded,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PreviewScreen(signature: updated)))),
      ]),
    )),
  );
  Widget _largeDot(Color c) => GestureDetector(onTap: () => setState(() => color = c),
      child: Container(width: 37, height: 37, margin: const EdgeInsets.only(right: 13),
          decoration: BoxDecoration(color: c, shape: BoxShape.circle, border: Border.all(color: color == c ? violet : const Color(0xFFE2E8F0), width: color == c ? 3 : 1)),
          child: color == c ? const Icon(Icons.check_rounded, color: Colors.white, size: 17) : null));
}

// SCREEN 7 — Preview
class PreviewScreen extends StatelessWidget {
  final SignatureDesign signature; final bool fromSaved;
  const PreviewScreen({super.key, required this.signature, this.fromSaved = false});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Signature preview', style: TextStyle(fontWeight: FontWeight.w900))),
    body: SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(20, 9, 20, 22),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const ScreenTitle('Looks like you.', 'Review your signature. Go back to customize it or save it to your collection.'),
        const SizedBox(height: 22),
        Expanded(child: Center(child: Container(width: double.infinity, constraints: const BoxConstraints(maxHeight: 310),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFFE0E6F0)),
                boxShadow: [BoxShadow(color: navy.withValues(alpha: .04), blurRadius: 20, offset: const Offset(0, 8))]),
            child: ClipRRect(borderRadius: BorderRadius.circular(24), child: CustomPaint(
              painter: SignaturePainter(strokes: signature.strokes, active: const [], color: signature.color, thickness: signature.thickness),
              child: const Center(child: Text('YOUR SIGNATURE', style: TextStyle(color: Color(0x3394A3B8), fontSize: 10, letterSpacing: 3, fontWeight: FontWeight.w800))),
            ))))),
        const SizedBox(height: 18),
        Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(17), border: Border.all(color: const Color(0xFFE7EBF3))),
            child: Row(children: [
              const Icon(Icons.verified_rounded, color: teal), const SizedBox(width: 10),
              const Expanded(child: Text('Your signature preview is ready.', style: TextStyle(color: navy, fontWeight: FontWeight.w700, fontSize: 12))),
              Text('${signature.strokes.length} strokes', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10)),
            ])),
        const SizedBox(height: 15),
        if (!fromSaved) ...[
          PrimaryButton(text: 'Save to My Signatures', icon: Icons.bookmark_add_rounded, onTap: () {
            signatureStore.add(signature);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Signature added to My Signatures.')));
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const MySignaturesScreen()), (route) => route.isFirst);
          }),
          const SizedBox(height: 10),
          SizedBox(width: double.infinity, height: 50, child: OutlinedButton.icon(
              onPressed: () => Navigator.pop(context), icon: const Icon(Icons.tune_rounded), label: const Text('Edit design'),
              style: OutlinedButton.styleFrom(foregroundColor: violet, side: const BorderSide(color: Color(0xFFD9D6FE)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))))),
        ] else
          PrimaryButton(text: 'Back to My Signatures', icon: Icons.folder_open_rounded, onTap: () => Navigator.pop(context)),
      ]),
    )),
  );
}

// SCREEN 8 — My Signatures
class MySignaturesScreen extends StatefulWidget {
  const MySignaturesScreen({super.key});
  @override
  State<MySignaturesScreen> createState() => _MySignaturesScreenState();
}
class _MySignaturesScreenState extends State<MySignaturesScreen> {
  @override
  void initState() { super.initState(); signatureStore.addListener(_refresh); }
  @override
  void dispose() { signatureStore.removeListener(_refresh); super.dispose(); }
  void _refresh() { if (mounted) setState(() {}); }
  void _delete(int index) {
    setState(() => signatureStore.signatures.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Signature removed.')));
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('My signatures', style: TextStyle(fontWeight: FontWeight.w900)),
        actions: [IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateScreen())),
            icon: const Icon(Icons.add_circle_outline_rounded, color: violet)), const SizedBox(width: 5)]),
    body: SafeArea(child: signatureStore.signatures.isEmpty
        ? Center(child: Padding(padding: const EdgeInsets.all(30), child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 78, height: 78, decoration: const BoxDecoration(color: Color(0xFFE9EAFE), shape: BoxShape.circle),
          child: const Icon(Icons.folder_open_rounded, color: violet, size: 38)),
      const SizedBox(height: 17), const Text('Your collection is empty', style: TextStyle(color: navy, fontSize: 18, fontWeight: FontWeight.w900)),
      const SizedBox(height: 7), const Text('Create and save a signature to see it here.', textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF718096), fontSize: 13, height: 1.5)),
      const SizedBox(height: 20), SizedBox(width: 220, child: PrimaryButton(text: 'Create signature', icon: Icons.add_rounded,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateScreen())))),
    ])))
        : ListView.separated(padding: const EdgeInsets.fromLTRB(19, 12, 19, 25), itemCount: signatureStore.signatures.length,
        separatorBuilder: (_, __) => const SizedBox(height: 13),
        itemBuilder: (context, index) => _SavedCard(signature: signatureStore.signatures[index],
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PreviewScreen(signature: signatureStore.signatures[index], fromSaved: true))),
            onDelete: () => _delete(index)))),
    bottomNavigationBar: NavigationBar(selectedIndex: 1, height: 66, backgroundColor: Colors.white,
        onDestinationSelected: (i) { if (i == 0) Navigator.pop(context); },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.folder_open_rounded), selectedIcon: Icon(Icons.folder_rounded), label: 'My Signatures'),
        ]),
  );
}
class _SavedCard extends StatelessWidget {
  final SignatureDesign signature; final VoidCallback onTap; final VoidCallback? onDelete;
  const _SavedCard({required this.signature, required this.onTap, this.onDelete});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(13), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(19),
      border: Border.all(color: const Color(0xFFE7EBF3))),
    child: Column(children: [
      GestureDetector(onTap: onTap, child: Container(height: 100, width: double.infinity,
          decoration: BoxDecoration(color: const Color(0xFFFBFCFF), borderRadius: BorderRadius.circular(13)),
          child: CustomPaint(painter: SignaturePainter(strokes: signature.strokes, active: const [], color: signature.color, thickness: signature.thickness)))),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('My Signature', style: TextStyle(color: navy, fontWeight: FontWeight.w900, fontSize: 13)),
          const SizedBox(height: 3), Text(_date(signature.createdAt), style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10)),
        ])),
        IconButton(tooltip: 'Preview', onPressed: onTap, icon: const Icon(Icons.visibility_outlined, color: violet)),
        if (onDelete != null) IconButton(tooltip: 'Delete', onPressed: onDelete, icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFDC2626))),
      ]),
    ]),
  );
}
String _date(DateTime d) => '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
