import 'package:flutter/material.dart';
import 'dart:math'; // Za generiranje nasumičnog pitanja

class NetiquetteQuizScreen extends StatefulWidget {
  final int initialScore;

  NetiquetteQuizScreen({required this.initialScore});

  @override
  _NetiquetteQuizScreenState createState() => _NetiquetteQuizScreenState();
}

class _NetiquetteQuizScreenState extends State<NetiquetteQuizScreen> {
  late int _score;
  String? _feedbackMessage; // Poruka koja će se prikazati nakon odgovora

  // Lista pitanja i odgovora
  final List<Map<String, Object>> _questions = [
    {
      'question':
      'Koja je od sljedećih opcija najbolji primjer netiquette na društvenim mrežama?',
      'answers': [
        {
          'text':
          'Objavljivanje osobnih podataka drugih ljudi bez njihovog dopuštenja.',
          'isCorrect': false
        },
        {
          'text':
          'Poštivanje privatnosti drugih i izbjegavanje objavljivanja neprovjerenih informacija.',
          'isCorrect': true
        },
        {
          'text': 'Komentiranje na postove koristeći uvredljiv jezik.',
          'isCorrect': false
        },
      ],
    },
    {
      'question':
      'Kako biste trebali reagirati na online uvrede ili provokacije?',
      'answers': [
        {'text': 'Uvijek uzvratiti uvredama.', 'isCorrect': false},
        {
          'text': 'Ignorirati ili prijaviti korisnika koji vrijeđa.',
          'isCorrect': true
        },
        {
          'text': 'Pokrenuti raspravu kako biste dokazali svoj stav.',
          'isCorrect': false
        },
      ],
    },
    {
      'question':
      'Što biste trebali učiniti prije nego podijelite članke ili informacije online?',
      'answers': [
        {'text': 'Podijeliti odmah bez provjere izvora.', 'isCorrect': false},
        {'text': 'Provjeriti izvor informacija za točnost.', 'isCorrect': true},
        {'text': 'Prevesti članak na drugi jezik.', 'isCorrect': false},
      ],
    },
    {
      'question':
      'Koji je najbolji način za započeti email komunikaciju s nepoznatom osobom?',
      'answers': [
        {'text': 'Korištenje ležernog jezika i emotikona.', 'isCorrect': false},
        {'text': 'Pisati kratko i bez pozdrava.', 'isCorrect': false},
        {
          'text': 'Koristiti formalni pozdrav i predstaviti se.',
          'isCorrect': true
        },
      ],
    },
    {
      'question':
      'Što biste trebali izbjegavati prilikom komunikacije u grupnim chatovima?',
      'answers': [
        {'text': 'Korištenje previše emotikona.', 'isCorrect': false},
        {
          'text': 'Slanje poruka koje nisu relevantne za cijelu grupu.',
          'isCorrect': true
        },
        {'text': 'Odgovaranje u stvarnom vremenu.', 'isCorrect': false},
      ],
    },
    {
      'question':
      'Koji je ispravan način za upotrebu "Caps Lock" u online komunikaciji?',
      'answers': [
        {'text': 'Koristiti Caps Lock za cijelu poruku.', 'isCorrect': false},
        {'text': 'Koristiti ga umjereno za naglašavanje.', 'isCorrect': true},
        {'text': 'Nikada ne koristiti Caps Lock.', 'isCorrect': false},
      ],
    },
    {
      'question':
      'Što biste trebali učiniti ako primite poruku sumnjivog sadržaja?',
      'answers': [
        {'text': 'Odmah proslijediti prijateljima.', 'isCorrect': false},
        {'text': 'Ignorirati i obrisati poruku.', 'isCorrect': true},
        {'text': 'Kliknuti na sve linkove u poruci.', 'isCorrect': false},
      ],
    },
    {
      'question':
      'Kako biste trebali postupati prema osjetljivim temama u online raspravama?',
      'answers': [
        {
          'text': 'S lakoćom komentirati bez obzira na tuđa osjećanja.',
          'isCorrect': false
        },
        {
          'text': 'Razmotriti različite perspektive i biti obazriv.',
          'isCorrect': true
        },
        {
          'text': 'Izbjegavati komentare i napustiti raspravu.',
          'isCorrect': false
        },
      ],
    },
    {
      'question':
      'Što je najbolje učiniti prije nego što pošaljete email s važnim informacijama?',
      'answers': [
        {'text': 'Provjeriti pravopis i jasnoću poruke.', 'isCorrect': true},
        {
          'text': 'Slati poruku odmah bez ponovnog čitanja.',
          'isCorrect': false
        },
        {'text': 'Dodati što više detalja bez provjere.', 'isCorrect': false},
      ],
    },
    {
      'question':
      'Kako bi trebalo postupiti ako primijetite da netko širi netočne informacije online?',
      'answers': [
        {
          'text': 'Javite to administratoru ili moderatoru stranice.',
          'isCorrect': true
        },
        {
          'text': 'Ignorirati situaciju i ništa ne poduzeti.',
          'isCorrect': false
        },
        {
          'text': 'Početi raspravu kako biste razjasnili situaciju.',
          'isCorrect': false
        },
      ],
    },
  ];

  late Map<String, Object> _currentQuestion;

  @override
  void initState() {
    super.initState();
    _score = widget.initialScore;
    _currentQuestion = _getRandomQuestion(); // Dohvaćanje nasumičnog pitanja
  }

  Map<String, Object> _getRandomQuestion() {
    final randomIndex = Random().nextInt(_questions.length);
    return _questions[randomIndex];
  }

  void _checkAnswer(bool isCorrect) {
    setState(() {
      if (isCorrect) {
        _score++;
        _feedbackMessage = 'Točno!'; // Postavlja poruku na 'Točno'
      } else {
        _feedbackMessage = 'Netočno!'; // Postavlja poruku na 'Netočno'
      }
    });
  }

  void _goBack() {
    Navigator.pop(context, _score); // Vraća broj bodova na prethodni ekran
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, Object>> answers =
    _currentQuestion['answers'] as List<Map<String, Object>>;

    return Scaffold(
      appBar: AppBar(
        title: Text('Netiquette Quiz'),
        backgroundColor: Colors.grey[850],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_feedbackMessage == null) ...[
              // Prikaz pitanja i odgovora prije nego korisnik odgovori
              Text(
                _currentQuestion['question'] as String,
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ...answers.map((answer) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[700],
                    ),
                    onPressed: () => _checkAnswer(answer['isCorrect'] as bool),
                    child: Text(
                      answer['text'] as String,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              }).toList(),
            ] else ...[
              // Prikaz povratne informacije nakon što korisnik odgovori
              Text(
                _feedbackMessage!,
                style: TextStyle(
                  color:
                  _feedbackMessage == 'Točno!' ? Colors.green : Colors.red,
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'Vaš trenutni broj bodova: $_score',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _goBack,
                child: Text('Povratak na glavni ekran'),
              ),
            ],
          ],
        ),
      ),
      backgroundColor: Colors.grey[900],
    );
  }
}
