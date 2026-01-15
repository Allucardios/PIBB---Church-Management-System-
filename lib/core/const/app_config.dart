class AppConfig {
  // Supabase Configuration
  static const String url = 'https://lkaszoufsokphmjvvaju.supabase.co';
  static const String anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxrYXN6b3Vmc29rcGhtanZ2YWp1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI4OTkwMzEsImV4cCI6MjA3ODQ3NTAzMX0.oDABNKlu7wWmoq-6jOseJOdFTkBEI_VqztHfcT6Kk2o';

  // Table Names
  static const String tableProfiles = 'profiles';
  static const String tableIncomes = 'incomes';
  static const String tableExpenses = 'expenses';
  static const String tableMembers = 'members';
  static const String tableCategory = 'categories';

  // App Settings
  static const String appName = 'PIBB';
  static const String appVersion = '1.0.0';

  // Currency Format
  static const String currencySymbol = 'AOA';
  static const String currencyLocale = 'pt_AO';
}
