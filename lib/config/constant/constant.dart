const kWorkerBoxName = 'workers';
const kDarkModeBoxName = 'dark_mode';
const kLogBoxName = 'logger';
const kDarkModeKey = 'enable';

/// Gemini API key from environment variables
// ignore: constant_identifier_names
const String GEMINI_API_KEY = String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');
