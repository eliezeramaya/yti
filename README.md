# YouTube Insights – Flutter Pro Scaffold

- Riverpod state management
- go_router navigation (Dashboard, Analyze)
- Repository pattern (YouTubeRepository, AIRepository)
- Services stubs (YouTubeService, AIService)
- Liquid Glass theme tokens and reusable widgets (KPI, sparkline)
- Viralidad formula with configurable weights + unit tests

## Run
```
flutter pub get
flutter run -d chrome
```

## Dart-define
```
# Opción A: pasar defines sueltos
flutter run -d chrome --dart-define=YOUTUBE_API_KEY=xxx --dart-define=OPENAI_API_KEY=sk-xxx

# Opción B: usar archivo .env
# 1) Copia .env.sample a .env y rellena valores
# 2) Ejecuta con:
flutter run -d chrome --dart-define-from-file=.env
```
