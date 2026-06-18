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
firebase deploy --only hosting:four-drinking-landing --project drinkingapp-84ac5
```

### CI/CD (GitHub Actions)

El workflow [`.github/workflows/ci.yml`](.github/workflows/ci.yml) se ejecuta en:

- **Pull requests / merge requests**: análisis, tests y build (sin deploy).
- **Push a `main`** (p. ej. al fusionar un MR): lo anterior + deploy a Firebase Hosting.
- **`workflow_dispatch`**: ejecución manual con deploy.

**Secrets del repositorio** (mismos que `four_drinking_admin`):

| Secret | Uso |
|--------|-----|
| `FIREBASE_SERVICE_ACCOUNT_DRINKINGAPP_BASE64` | **Recomendado.** JSON de la service account codificado en base64 (evita errores al pegar la clave privada). |
| `FIREBASE_SERVICE_ACCOUNT_DRINKINGAPP` | Alternativa: JSON en bruto (mismo valor que en `four_drinking_admin`). |
| `FIREBASE_TOKEN` | Alternativa: token de `firebase login:ci`. |

Para generar el secret en base64 (macOS/Linux):

```bash
base64 -i drinkingapp-84ac5-firebase-adminsdk.json | tr -d '\n' | pbcopy
```

Pega el resultado en GitHub → `four-drinking-landing` → Settings → Secrets → `FIREBASE_SERVICE_ACCOUNT_DRINKINGAPP_BASE64`.

No uses `FIREBASE_PROJECT_ID` en este repo: el proyecto (`drinkingapp-84ac5`) y el sitio (`four-drinking-landing`) están fijados en el workflow y en `firebase.json`.

Si el deploy falla con *Failed to get Firebase project*, el JSON del secret está mal copiado o la service account no tiene permisos de Firebase Admin. Regenera la clave en Firebase Console o usa `FIREBASE_TOKEN`.

### Dominio 4drinking.com

Cada app tiene su **sitio de Hosting** y su dominio:

| App | Sitio Firebase | Dominio |
|-----|----------------|---------|
| Landing | `four-drinking-landing` | `4drinking.com` |
| Admin | `drinkingapp-84ac5` | `admin.4drinking.com` |

La landing **nunca** debe desplegarse al sitio por defecto (`drinkingapp-84ac5`), porque ahí vive el admin.

1. Crear el sitio (una sola vez, ya hecho):

   ```bash
   firebase hosting:sites:create four-drinking-landing --project drinkingapp-84ac5
   ```

2. En [Firebase Console → Hosting](https://console.firebase.google.com/project/drinkingapp-84ac5/hosting), abrir el sitio `four-drinking-landing` y añadir el dominio personalizado `4drinking.com` (y `www.4drinking.com` si aplica).

3. Configurar los registros DNS que indique Firebase (normalmente `A`/`AAAA` o `CNAME`).

Tras el primer deploy desde CI, el dominio servirá el build de la landing.

### Hosting compartido con Admin

Admin y Landing usan el mismo proyecto Firebase (`drinkingapp-84ac5`) pero **sitios de Hosting distintos**:

- **Landing** → `four-drinking-landing` → `4drinking.com`
- **Admin** → `drinkingapp-84ac5` → `admin.4drinking.com`

Los workflows de CI despliegan cada uno solo a su sitio (`hosting:four-drinking-landing` y `hosting:drinkingapp-84ac5`).

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
- `choice.png`

Luego activa su carga en build:

```bash
flutter build web --release --dart-define=USE_SCREENSHOT_ASSETS=true
```

Hasta entonces la galería muestra placeholders sin solicitar assets inexistentes.

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
