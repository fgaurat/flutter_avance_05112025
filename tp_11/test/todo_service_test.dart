import 'package:flutter_test/flutter_test.dart';
import 'package:tp_11/models/todo.dart';
import 'package:tp_11/services/todo_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

class MockHttpClient extends Mock implements http.Client {}

main() {
  late MockHttpClient mockHttpClient;
  late TodoService service;

  setUp(() {
    mockHttpClient = MockHttpClient();

    service = TodoService(client: mockHttpClient, baseUrl: "http://fake");
    registerFallbackValue(Uri.parse('http://fallback'));
  });

  testWidgets('test TodoService getTodos', (WidgetTester tester) async {
    // AAA: Arrange, Act, Assert
    //await tester.pumpWidget(const MyApp());
    const json = '''
    [
      {"id": 1, "title": "A", "completed": false},
      {"id": 2, "title": "B", "completed": true}
    ]
    ''';

    when(() => mockHttpClient.get(any())).thenAnswer(
      (_) async => http.Response(
        json,
        200,
        headers: {'Content-Type': 'application/json'},
      ),
    );

    final todos = await service.getTodos();

    expect(todos.length, 2);
    expect(todos, isA<List<Todo>>());
    expect(todos.first.id, 1);
    expect(todos.first.title, 'A');
    verify(() => mockHttpClient.get(Uri.parse('http://fake/todos'))).called(1);
    verifyNoMoreInteractions(mockHttpClient);
  });

  testWidgets("getTodos() -> status !=200 throw exception", (
    WidgetTester tester,
  ) async {
    when(() => mockHttpClient.get(any())).thenAnswer(
      (_) async => http.Response(
        'Not Found',
        404,
        headers: {'Content-Type': 'application/json'},
      ),
    );

    expect(service.getTodos(), throwsA(isA<Exception>()));
  });

  test('getTodos() -> JSON invalide lève une FormatException', () async {
    when(
      () => mockHttpClient.get(any()),
    ).thenAnswer((_) async => http.Response('not json', 200));

    expect(() => service.getTodos(), throwsA(isA<FormatException>()));
  });
}
