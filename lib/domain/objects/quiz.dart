import 'dart:collection';
import 'dart:math';

typedef ObservableHandler = void Function(
    ResultDescriptor resultDescriptor, QuestionDescriptor questionDescriptor);

class Quiz {
  final _listeners = HashMap<Object, ObservableHandler>();

  late int _nextQuestionIdIndex = -1;
  late int _totalOfCorrect = -1;
  late List<int> _selectedQuestionIds = [];

  late ResultDescriptor _resultDescriptor;
  late QuestionDescriptor _questionDescriptor;

  Quiz() {
    _updateDescriptors();
  }

  void start(int length) {
    if (length > _store.length) {
      throw Exception(
          'Invalid Input: length should not be more than ${_store.length}');
    }

    List<int> allQuestionIds = List<int>.generate(_store.length, (i) => i);

    final random = Random();
    allQuestionIds.shuffle(random);

    _selectedQuestionIds = allQuestionIds.sublist(0, length);
    _nextQuestionIdIndex = 0;
    _totalOfCorrect = 0;

    _updateDescriptors();
  }

  void answerCurrentAndGoToNext(String answer) {
    if (_nextQuestionIdIndex >= _selectedQuestionIds.length) {
      throw Exception("Quiz questions finished");
    }

    var question = _store[_selectedQuestionIds[_nextQuestionIdIndex]];

    if (question["correctAnswer"] == answer) _totalOfCorrect++;

    _nextQuestionIdIndex++;

    _updateDescriptors();
  }

  void observe(Object context, ObservableHandler handler) {
    _listeners.putIfAbsent(context, () => handler);
    handler(resultDescriptor(), questionDescriptor());
  }

  void unObserve(Object context) {
    _listeners.remove(context);
  }

  void _updateDescriptors() {
    _resultDescriptor = ResultDescriptor(this);
    _questionDescriptor = QuestionDescriptor(this);

    _listeners.forEach(
        (_, handler) => handler(_resultDescriptor, _questionDescriptor));
  }

  ResultDescriptor resultDescriptor() {
    return _resultDescriptor;
  }

  QuestionDescriptor questionDescriptor() {
    return _questionDescriptor;
  }
}

class QuestionDescriptor {
  late String question;
  late List<String> options;

  QuestionDescriptor(Quiz quiz) {
    var currentQuestionIndex = quiz._nextQuestionIdIndex;

    var isDone = currentQuestionIndex == quiz._selectedQuestionIds.length;
    var isNotStarted = currentQuestionIndex == -1;

    if (isDone || isNotStarted) {
      question = '';
      options = [];
    } else {
      question = _store[quiz._selectedQuestionIds[quiz._nextQuestionIdIndex]]
          ["questionText"] as String;

      options = (_store[quiz._selectedQuestionIds[quiz._nextQuestionIdIndex]]
              ["options"] as List<dynamic>)
          .cast<String>();
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QuestionDescriptor &&
        other.question == question &&
        other.options == options;
  }

  @override
  int get hashCode => Object.hash(question, options);
}

class ResultDescriptor {
  late final bool isQuizFinished;
  late final String percentageScore;

  ResultDescriptor(Quiz quiz) {
    isQuizFinished =
        quiz._nextQuestionIdIndex >= quiz._selectedQuestionIds.length;

    var totalOfCorrect = quiz._totalOfCorrect;
    var totalAnswered = quiz._nextQuestionIdIndex;

    int roundedScore = totalAnswered == 0
        ? totalAnswered
        : ((totalOfCorrect / totalAnswered) * 100).round();

    percentageScore = '$roundedScore %';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ResultDescriptor &&
        other.isQuizFinished == isQuizFinished &&
        other.percentageScore == percentageScore;
  }

  @override
  int get hashCode => Object.hash(isQuizFinished, percentageScore);
}

final _store = [
  {
    "questionText": "What is the capital of France?",
    "options": ["Berlin", "Madrid", "Paris", "Rome"],
    "correctAnswer": "Paris",
  },
  {
    "questionText": "Which planet is known as the 'Red Planet'?",
    "options": ["Venus", "Mars", "Jupiter", "Saturn"],
    "correctAnswer": "Mars",
  },
  {
    "questionText": "Who wrote the play 'Romeo and Juliet'?",
    "options": [
      "Charles Dickens",
      "William Shakespeare",
      "Jane Austen",
      "Leo Tolstoy"
    ],
    "correctAnswer": "William Shakespeare",
  },
  {
    "questionText":
        "Which gas do plants absorb from the atmosphere during photosynthesis?",
    "options": ["Oxygen", "Carbon Dioxide", "Nitrogen", "Hydrogen"],
    "correctAnswer": "Carbon Dioxide",
  },
  {
    "questionText":
        "Which programming language is commonly used for web development?",
    "options": ["Python", "Java", "JavaScript", "C++"],
    "correctAnswer": "JavaScript",
  },
  {
    "questionText": "In which year did the Titanic sink?",
    "options": ["1907", "1912", "1920", "1935"],
    "correctAnswer": "1912",
  },
  {
    "questionText": "What is the largest mammal in the world?",
    "options": ["African Elephant", "Giraffe", "Blue Whale", "Lion"],
    "correctAnswer": "Blue Whale",
  },
  {
    "questionText": "Who painted the Mona Lisa?",
    "options": [
      "Pablo Picasso",
      "Vincent van Gogh",
      "Leonardo da Vinci",
      "Michelangelo"
    ],
    "correctAnswer": "Leonardo da Vinci",
  },
  {
    "questionText": "Which gas is responsible for the Earth's ozone layer?",
    "options": [
      "Oxygen",
      "Methane",
      "Chlorofluorocarbons (CFCs)",
      "Nitrous Oxide"
    ],
    "correctAnswer": "Chlorofluorocarbons (CFCs)",
  },
  {
    "questionText": "What is the largest planet in our solar system?",
    "options": ["Earth", "Mars", "Jupiter", "Venus"],
    "correctAnswer": "Jupiter",
  },
  {
    "questionText": "Which metal is liquid at room temperature?",
    "options": ["Copper", "Iron", "Mercury", "Gold"],
    "correctAnswer": "Mercury",
  },
  {
    "questionText": "What is the largest organ in the human body?",
    "options": ["Heart", "Brain", "Skin", "Liver"],
    "correctAnswer": "Skin",
  },
  {
    "questionText":
        "Which famous scientist developed the theory of general relativity?",
    "options": [
      "Isaac Newton",
      "Galileo Galilei",
      "Albert Einstein",
      "Stephen Hawking"
    ],
    "correctAnswer": "Albert Einstein",
  },
  {
    "questionText": "What is the chemical symbol for water?",
    "options": ["H2O", "CO2", "O2", "NaCl"],
    "correctAnswer": "H2O",
  },
  {
    "questionText": "Which country is known as the Land of the Rising Sun?",
    "options": ["China", "India", "Japan", "South Korea"],
    "correctAnswer": "Japan",
  },
  {
    "questionText": "Who is the author of 'To Kill a Mockingbird'?",
    "options": [
      "Mark Twain",
      "Harper Lee",
      "F. Scott Fitzgerald",
      "J.K. Rowling"
    ],
    "correctAnswer": "Harper Lee",
  },
  {
    "questionText": "What is the chemical symbol for gold?",
    "options": ["Go", "Ge", "Au", "Ag"],
    "correctAnswer": "Au",
  },
  {
    "questionText":
        "Which planet is known as the 'Morning Star' or 'Evening Star'?",
    "options": ["Venus", "Mars", "Jupiter", "Saturn"],
    "correctAnswer": "Venus",
  },
  {
    "questionText": "What is the largest desert in the world?",
    "options": ["Sahara Desert", "Gobi Desert", "Antarctica", "Arabian Desert"],
    "correctAnswer": "Antarctica",
  },
  {
    "questionText":
        "Who is the first woman to fly solo across the Atlantic Ocean?",
    "options": [
      "Amelia Earhart",
      "Bessie Coleman",
      "Harriet Quimby",
      "Jacqueline Cochran"
    ],
    "correctAnswer": "Amelia Earhart",
  },
  {
    "questionText": "Which gas makes up the majority of Earth's atmosphere?",
    "options": ["Oxygen", "Nitrogen", "Carbon Dioxide", "Helium"],
    "correctAnswer": "Nitrogen",
  },
  {
    "questionText": "Who is the author of the 'Harry Potter' book series?",
    "options": [
      "J.R.R. Tolkien",
      "J.K. Rowling",
      "George R.R. Martin",
      "C.S. Lewis"
    ],
    "correctAnswer": "J.K. Rowling",
  },
  {
    "questionText": "What is the smallest planet in our solar system?",
    "options": ["Earth", "Mars", "Jupiter", "Mercury"],
    "correctAnswer": "Mercury",
  },
  {
    "questionText": "What is the chemical symbol for oxygen?",
    "options": ["O2", "CO2", "H2O", "N2"],
    "correctAnswer": "O2",
  },
  {
    "questionText": "In which year did World War II end?",
    "options": ["1943", "1945", "1950", "1939"],
    "correctAnswer": "1945",
  },
  {
    "questionText": "Who is known as the 'Father of Modern Physics'?",
    "options": [
      "Isaac Newton",
      "Galileo Galilei",
      "Albert Einstein",
      "Niels Bohr"
    ],
    "correctAnswer": "Albert Einstein",
  },
  {
    "questionText":
        "Which gas is responsible for the greenhouse effect on Earth?",
    "options": ["Oxygen", "Methane", "Carbon Dioxide", "Helium"],
    "correctAnswer": "Carbon Dioxide",
  },
  {
    "questionText": "What is the largest ocean in the world?",
    "options": [
      "Atlantic Ocean",
      "Indian Ocean",
      "Arctic Ocean",
      "Pacific Ocean"
    ],
    "correctAnswer": "Pacific Ocean",
  },
  {
    "questionText":
        "Who is the 16th President of the United States known for ending slavery?",
    "options": [
      "Abraham Lincoln",
      "George Washington",
      "Thomas Jefferson",
      "John F. Kennedy"
    ],
    "correctAnswer": "Abraham Lincoln",
  },
  {
    "questionText": "What is the chemical symbol for silver?",
    "options": ["Si", "Ag", "Au", "Sr"],
    "correctAnswer": "Ag",
  },
  {
    "questionText": "What is the largest planet in our solar system?",
    "options": ["Earth", "Mars", "Jupiter", "Venus"],
    "correctAnswer": "Jupiter",
  },
  {
    "questionText": "Who is the author of 'The Great Gatsby'?",
    "options": [
      "F. Scott Fitzgerald",
      "Ernest Hemingway",
      "Charles Dickens",
      "Mark Twain"
    ],
    "correctAnswer": "F. Scott Fitzgerald",
  },
  {
    "questionText": "What is the chemical symbol for sodium?",
    "options": ["S", "So", "Na", "N"],
    "correctAnswer": "Na",
  },
  {
    "questionText": "Which gas do humans exhale when they breathe?",
    "options": ["Oxygen", "Carbon Dioxide", "Nitrogen", "Helium"],
    "correctAnswer": "Carbon Dioxide",
  },
  {
    "questionText": "Who is the founder of Microsoft Corporation?",
    "options": ["Bill Gates", "Steve Jobs", "Larry Page", "Mark Zuckerberg"],
    "correctAnswer": "Bill Gates",
  },
  {
    "questionText": "What is the largest country by land area?",
    "options": ["Russia", "China", "USA", "Canada"],
    "correctAnswer": "Russia",
  },
  {
    "questionText": "Who is the Greek god of the sea?",
    "options": ["Zeus", "Hades", "Poseidon", "Apollo"],
    "correctAnswer": "Poseidon",
  },
  {
    "questionText": "What is the smallest prime number?",
    "options": ["0", "1", "2", "3"],
    "correctAnswer": "2",
  },
  {
    "questionText": "In which country is the city of Venice located?",
    "options": ["Spain", "France", "Italy", "Greece"],
    "correctAnswer": "Italy",
  },
  {
    "questionText": "What is the chemical symbol for iron?",
    "options": ["Fe", "Ir", "Io", "In"],
    "correctAnswer": "Fe",
  },
  {
    "questionText": "What is the largest species of shark?",
    "options": [
      "Great White Shark",
      "Hammerhead Shark",
      "Whale Shark",
      "Tiger Shark"
    ],
    "correctAnswer": "Whale Shark",
  },
  {
    "questionText": "Who wrote 'The Catcher in the Rye'?",
    "options": [
      "J.D. Salinger",
      "F. Scott Fitzgerald",
      "Ernest Hemingway",
      "Mark Twain"
    ],
    "correctAnswer": "J.D. Salinger",
  },
  {
    "questionText": "What is the chemical symbol for potassium?",
    "options": ["K", "P", "Po", "Pt"],
    "correctAnswer": "K",
  },
  {
    "questionText":
        "Which gas is commonly used to inflate balloons and make them float?",
    "options": ["Nitrogen", "Carbon Dioxide", "Helium", "Oxygen"],
    "correctAnswer": "Helium",
  },
  {
    "questionText":
        "Who is the first woman to win a Nobel Prize and the only person to win Nobel Prizes in two different scientific fields?",
    "options": [
      "Marie Curie",
      "Rosalind Franklin",
      "Dorothy Crowfoot Hodgkin",
      "Barbara McClintock"
    ],
    "correctAnswer": "Marie Curie",
  },
  {
    "questionText": "What is the largest mammal on land?",
    "options": ["African Elephant", "Giraffe", "Blue Whale", "Lion"],
    "correctAnswer": "African Elephant",
  },
  {
    "questionText": "Which planet is known as the 'Evening Star'?",
    "options": ["Venus", "Mars", "Jupiter", "Saturn"],
    "correctAnswer": "Venus",
  },
  {
    "questionText": "What is the chemical symbol for lead?",
    "options": ["Pb", "Le", "Ld", "Pd"],
    "correctAnswer": "Pb",
  },
  {
    "questionText": "In which country is the Great Barrier Reef located?",
    "options": ["Australia", "Brazil", "Indonesia", "Thailand"],
    "correctAnswer": "Australia",
  },
  {
    "questionText": "Who is known as the 'Father of Modern Computer Science'?",
    "options": [
      "Charles Babbage",
      "Alan Turing",
      "John von Neumann",
      "Grace Hopper"
    ],
    "correctAnswer": "Alan Turing",
  },
  {
    "questionText": "What is the largest moon of Jupiter?",
    "options": ["Io", "Europa", "Ganymede", "Callisto"],
    "correctAnswer": "Ganymede",
  },
  {
    "questionText": "Who is the author of 'Pride and Prejudice'?",
    "options": [
      "Charles Dickens",
      "Jane Austen",
      "Leo Tolstoy",
      "F. Scott Fitzgerald"
    ],
    "correctAnswer": "Jane Austen",
  },
  {
    "questionText": "What is the chemical symbol for silver?",
    "options": ["Si", "Ag", "Au", "Sr"],
    "correctAnswer": "Ag",
  },
  {
    "questionText": "What gas do humans need to breathe to survive?",
    "options": ["Carbon Dioxide", "Oxygen", "Nitrogen", "Hydrogen"],
    "correctAnswer": "Oxygen",
  },
  {
    "questionText":
        "Who is the co-founder of Apple Inc. along with Steve Jobs?",
    "options": ["Bill Gates", "Tim Cook", "Steve Wozniak", "Mark Zuckerberg"],
    "correctAnswer": "Steve Wozniak",
  },
  {
    "questionText":
        "What is the largest mountain in the world when measured from base to summit?",
    "options": ["Mount Kilimanjaro", "Mount Everest", "Mauna Kea", "K2"],
    "correctAnswer": "Mauna Kea",
  },
  {
    "questionText": "Which gas is responsible for the smell of rotten eggs?",
    "options": ["Oxygen", "Hydrogen", "Sulfur Dioxide", "Methane"],
    "correctAnswer": "Hydrogen",
  },
  {
    "questionText": "In which country is the city of Cairo located?",
    "options": ["Egypt", "Greece", "Turkey", "Morocco"],
    "correctAnswer": "Egypt",
  },
  {
    "questionText":
        "Who is the famous theoretical physicist known for his work on black holes and the theory of Hawking radiation?",
    "options": [
      "Albert Einstein",
      "Stephen Hawking",
      "Richard Feynman",
      "Niels Bohr"
    ],
    "correctAnswer": "Stephen Hawking",
  },
  {
    "questionText": "What is the chemical symbol for calcium?",
    "options": ["Co", "Ca", "Ce", "Cu"],
    "correctAnswer": "Ca",
  },
  {
    "questionText":
        "What is the smallest element by atomic number in the periodic table?",
    "options": ["Hydrogen", "Helium", "Lithium", "Boron"],
    "correctAnswer": "Hydrogen",
  },
  {
    "questionText": "Who is the author of the 'Critique of Pure Reason'?",
    "options": [
      "Friedrich Nietzsche",
      "Immanuel Kant",
      "Jean-Jacques Rousseau",
      "Karl Marx"
    ],
    "correctAnswer": "Immanuel Kant",
  },
  {
    "questionText": "What is the chemical symbol for potassium dichromate?",
    "options": ["K2Cr2O7", "Kr", "KCrO4", "KC2H3O2"],
    "correctAnswer": "K2Cr2O7",
  },
  {
    "questionText":
        "Which noble gas is the heaviest in terms of atomic weight?",
    "options": ["Helium", "Neon", "Argon", "Krypton"],
    "correctAnswer": "Krypton",
  },
  {
    "questionText":
        "Who developed the theory of relativity that applies to objects moving at any speed, including the speed of light?",
    "options": [
      "Isaac Newton",
      "Galileo Galilei",
      "Albert Einstein",
      "Niels Bohr"
    ],
    "correctAnswer": "Albert Einstein",
  },
  {
    "questionText": "What is the main component of the Earth's inner core?",
    "options": ["Nickel", "Iron", "Copper", "Gold"],
    "correctAnswer": "Iron",
  },
  {
    "questionText":
        "Which gas is the most abundant greenhouse gas in the Earth's atmosphere?",
    "options": ["Methane", "Carbon Dioxide", "Water Vapor", "Ozone"],
    "correctAnswer": "Water Vapor",
  },
  {
    "questionText": "In which country was the mathematician Euclid born?",
    "options": ["Greece", "Italy", "Egypt", "Persia"],
    "correctAnswer": "Greece",
  },
  {
    "questionText":
        "Who formulated the laws of motion and universal gravitation?",
    "options": [
      "Isaac Newton",
      "Galileo Galilei",
      "Albert Einstein",
      "Niels Bohr"
    ],
    "correctAnswer": "Isaac Newton",
  },
  {
    "questionText": "What is the chemical symbol for uranium?",
    "options": ["Un", "Ur", "U", "Uf"],
    "correctAnswer": "U",
  },
  {
    "questionText":
        "Who is known for the 'Theory of General Relativity' and 'Special Relativity'?",
    "options": [
      "Isaac Newton",
      "Galileo Galilei",
      "Albert Einstein",
      "Niels Bohr"
    ],
    "correctAnswer": "Albert Einstein",
  },
  {
    "questionText":
        "What is the chemical symbol for the element with atomic number 92?",
    "options": ["U", "N", "Pu", "Hg"],
    "correctAnswer": "U",
  },
  {
    "questionText":
        "What is the term for a type of chemical reaction where a substance reacts rapidly with oxygen and produces heat and light?",
    "options": ["Decomposition", "Oxidation", "Combustion", "Reduction"],
    "correctAnswer": "Combustion",
  },
  {
    "questionText":
        "Who was the mathematician known for the 'Fermat's Last Theorem'?",
    "options": [
      "Carl Friedrich Gauss",
      "Pierre-Simon Laplace",
      "Leonhard Euler",
      "Andrew Wiles"
    ],
    "correctAnswer": "Andrew Wiles",
  },
  {
    "questionText": "What is the smallest prime number greater than 10?",
    "options": ["11", "13", "17", "19"],
    "correctAnswer": "11",
  },
  {
    "questionText":
        "In which year was the double-helix structure of DNA discovered?",
    "options": ["1953", "1960", "1970", "1980"],
    "correctAnswer": "1953",
  },
  {
    "questionText":
        "What is the chemical symbol for the element commonly used in radioactive dating?",
    "options": ["Ra", "Po", "Th", "C"],
    "correctAnswer": "C",
  },
  {
    "questionText":
        "Who is known for the 'Uncertainty Principle' in quantum mechanics?",
    "options": [
      "Werner Heisenberg",
      "Max Planck",
      "Louis de Broglie",
      "Erwin Schrödinger"
    ],
    "correctAnswer": "Werner Heisenberg",
  },
  {
    "questionText":
        "What is the primary structural protein found in human hair, skin, and nails?",
    "options": ["Collagen", "Keratin", "Elastin", "Fibrin"],
    "correctAnswer": "Keratin",
  },
  {
    "questionText":
        "Which mathematical constant is approximately equal to 3.14159?",
    "options": [
      "Euler's number (e)",
      "Golden ratio (phi)",
      "Pi (π)",
      "Avogadro's number"
    ],
    "correctAnswer": "Pi (π)",
  },
  {
    "questionText": "What is the Riemann Hypothesis, and who formulated it?",
    "options": [
      "A conjecture about prime numbers by Pierre-Simon Laplace",
      "A conjecture about the distribution of prime numbers by Bernhard Riemann",
      "A theorem in group theory by Évariste Galois",
      "A conjecture about the behavior of complex functions by John von Neumann"
    ],
    "correctAnswer":
        "A conjecture about the distribution of prime numbers by Bernhard Riemann",
  },
  {
    "questionText":
        "Who is the mathematician known for the 'Four Color Theorem'?",
    "options": [
      "Leonhard Euler",
      "Kurt Gödel",
      "John Nash",
      "Kenneth Appel and Wolfgang Haken"
    ],
    "correctAnswer": "Kenneth Appel and Wolfgang Haken",
  },
  {
    "questionText": "What is the smallest perfect number?",
    "options": ["6", "28", "12", "496"],
    "correctAnswer": "6",
  },
  {
    "questionText":
        "What is the term for a substance that speeds up a chemical reaction but is not consumed in the process?",
    "options": ["Catalyst", "Reactant", "Solvent", "Inhibitor"],
    "correctAnswer": "Catalyst",
  },
  {
    "questionText":
        "Who is the scientist known for the development of the laws of electromagnetism and the invention of the telegraph?",
    "options": [
      "Michael Faraday",
      "James Clerk Maxwell",
      "Samuel Morse",
      "Nikola Tesla"
    ],
    "correctAnswer": "Samuel Morse",
  },
  {
    "questionText":
        "What is the chemical symbol for the element with atomic number 79?",
    "options": ["Au", "Ag", "Cu", "Pb"],
    "correctAnswer": "Au",
  },
  {
    "questionText": "Who is known for the 'Gödel's Incompleteness Theorems'?",
    "options": [
      "Kurt Gödel",
      "David Hilbert",
      "Alan Turing",
      "John von Neumann"
    ],
    "correctAnswer": "Kurt Gödel",
  },
  {
    "questionText":
        "What is the term for the study of the fundamental nature of reality and existence?",
    "options": ["Physics", "Biology", "Philosophy", "Metaphysics"],
    "correctAnswer": "Metaphysics",
  },
  {
    "questionText": "Who formulated the 'Second Law of Thermodynamics'?",
    "options": [
      "Albert Einstein",
      "James Clerk Maxwell",
      "Ludwig Boltzmann",
      "Max Planck"
    ],
    "correctAnswer": "Ludwig Boltzmann",
  },
  {
    "questionText": "What is the value of Avogadro's number?",
    "options": ["6.02 x 10^23", "3.14", "1.62 x 10^19", "9.81"],
    "correctAnswer": "6.02 x 10^23",
  }
];
