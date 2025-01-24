const String kWorkerBoxName = 'workers';
const String kDarkModeBoxName = 'darkMode';
const String kDarkModeKey = 'isDarkMode';
const String kLogBoxName = 'logs';
const String kEditionBoxName = 'edition';
const String kEditionKey = 'currentEdition';

/// Gemini API key from environment variables
// ignore: constant_identifier_names
const String GEMINI_API_KEY = String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');
