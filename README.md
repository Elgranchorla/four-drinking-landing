# 4drinking Landing

Landing pública independiente para **4drinking**, desplegada en Firebase Hosting (Flutter Web).

Proyecto separado de `four_drinking_app` (app de consumo) y `four_drinking_admin` (panel de administración).

## Contenido

- Hero con logo y propuesta de valor
- Galería de capturas (placeholders hasta añadir assets reales)
- Formulario de waitlist → colección Firestore `waitlist`

## Requisitos

- Flutter stable
- Proyecto Firebase `drinkingapp-84ac5`
- Reglas Firestore en `four_drinking_admin/firestore.rules` (colección `waitlist`)

## Desarrollo local

```bash
cd four_drinking_landing
flutter pub get
flutter run -d chrome
```

## Build y deploy

```bash
flutter build web --release
firebase deploy --only hosting --project drinkingapp-84ac5
```

### Hosting compartido con Admin

Si Admin y Landing usan el mismo proyecto Firebase, configura **dos sitios de Hosting** en la consola de Firebase y asigna cada deploy a su sitio (por ejemplo, landing en el sitio por defecto y admin en un sitio secundario).

## Configuración opcional

Enlace “Accede a la app” (solo visible si se define la URL):

```bash
flutter build web --release --dart-define=APP_URL=https://tu-app.web.app
```

## Capturas

Añade imágenes en `assets/screenshots/`:

- `home.png`
- `questions.png`
- `recommendations.png`

## Estructura

```
lib/
  main.dart
  screens/landing_screen.dart
  services/waitlist_service.dart
  widgets/
  theme/
assets/
  images/
  screenshots/
web/
```
