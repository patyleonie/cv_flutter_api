import 'package:cv_flutter_phil/main.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('login validates demo credentials', (tester) async {
    await tester.pumpWidget(const CvApp());

    await tester.ensureVisible(find.byKey(const Key('signInButton')));
    await tester.tap(find.byKey(const Key('signInButton')));
    await tester.pump();
    expect(find.text('Saisissez votre identifiant.'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('usernameField')), 'wrong');
    await tester.enterText(find.byKey(const Key('passwordField')), 'wrong');
    await tester.ensureVisible(find.byKey(const Key('signInButton')));
    await tester.tap(find.byKey(const Key('signInButton')));
    await tester.pump();
    expect(find.byKey(const Key('loginError')), findsOneWidget);

    await tester.enterText(find.byKey(const Key('usernameField')), 'demo');
    await tester.enterText(find.byKey(const Key('passwordField')), 'demo123');
    await tester.ensureVisible(find.byKey(const Key('signInButton')));
    await tester.tap(find.byKey(const Key('signInButton')));
    await tester.pump();
    expect(find.byKey(const Key('cvPage')), findsOneWidget);
  });

  testWidgets('side drawer navigates through generated sample sections', (
    tester,
  ) async {
    await tester.pumpWidget(const CvApp());
    await tester.enterText(find.byKey(const Key('usernameField')), 'demo');
    await tester.enterText(find.byKey(const Key('passwordField')), 'demo123');
    await tester.ensureVisible(find.byKey(const Key('signInButton')));
    await tester.tap(find.byKey(const Key('signInButton')));
    await tester.pump();

    expect(find.text('Nakinja\nMUSHUSHU Patricia'), findsOneWidget);
    expect(find.text('Goma, RDC'), findsOneWidget);
    expect(find.byType(Image), findsNothing);
    expect(find.byType(NavigationBar), findsNothing);

    await tester.tap(find.byKey(const Key('openNavigationButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('nav-journey')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('journeyPage')), findsOneWidget);
    expect(find.text('Licence en gestion et administration'), findsOneWidget);
    expect(find.textContaining('Exemples fictifs à confirmer'), findsOneWidget);

    await tester.tap(find.byKey(const Key('openNavigationButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('nav-family')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('familyPage')), findsOneWidget);
    expect(find.text('Aline Nakinja'), findsOneWidget);
    expect(find.textContaining('Exemples fictifs à confirmer'), findsOneWidget);

    await tester.tap(find.byKey(const Key('openNavigationButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('nav-contact')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('contactPage')), findsOneWidget);
    expect(find.text('Non renseigné'), findsNWidgets(2));
    expect(find.text('Goma, République démocratique du Congo'), findsOneWidget);
    expect(find.text('lukoo.bauma.meshack@example.com'), findsNothing);
  });

  testWidgets('desktop layout shows persistent side navigation', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const CvApp());
    await tester.enterText(find.byKey(const Key('usernameField')), 'demo');
    await tester.enterText(find.byKey(const Key('passwordField')), 'demo123');
    await tester.ensureVisible(find.byKey(const Key('signInButton')));
    await tester.tap(find.byKey(const Key('signInButton')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('nav-profile')), findsOneWidget);
    expect(find.byKey(const Key('openNavigationButton')), findsNothing);

    await tester.tap(find.byKey(const Key('nav-journey')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('journeyPage')), findsOneWidget);
  });
}
